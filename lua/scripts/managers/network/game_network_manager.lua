-- chunkname: @scripts/managers/network/game_network_manager.lua

require("scripts/network_lookup/network_lookup")

GameNetworkManager = class(GameNetworkManager)

local PING_SAMPLES_MAX_SIZE = 10
local PING_SAMPLE_INTERVAL = 1
local PING_TABLE_SYNC_INTERVAL = 0.5
local Player_pings = {}
local network_callback_names = {
	game_object_sync_done = "(peer_id)",
	game_session_disconnect = "(host_id)",
	game_object_destroyed = "(id, destroyer_id)",
	game_object_created = "(id, creator_id)",
	game_object_migrated_to_me = "(id, old_owner_id)",
	game_object_migrated_away = "(id, new_owner_id)"
}

local function patch_add_profiling_scopes(table_to_be_patched, string_map_function_names)
	for callback_name, _ in pairs(string_map_function_names) do
		while true do
			if type(callback_name) ~= "string" then
				break
			end

			local patch_function = table_to_be_patched[callback_name]

			if patch_function and type(patch_function) == "function" then
				table_to_be_patched[callback_name] = function(...)
					Profiler.start(callback_name)
					patch_function(...)
					Profiler.stop()
				end
			end

			break
		end
	end
end

function GameNetworkManager:init(state, world, lobby)
	self._state = state
	self._world = world
	self._game = nil
	self._lobby = lobby
	self._units = {}
	self._owners = {}
	self._game_started = false
	self._received_network = false
	self._left_game = false
	self._join_lobby_failed = false
	self._exit_to_menu_lobby = false
	self._next_level_settings = nil
	self._migrate_to_me_stack = nil
	self._game_object_types = {}
	self._object_synchronizing_clients = {}
	self._game_object_disconnect_callbacks = {}
	Player_pings = {}

	if self._lobby then
		Network.set_pong_timeout(GameSettingsDevelopment.network_timeout)
		dofile("scripts/network_lookup/network_constants")
	end

	self._split_update = false

	Managers.chat:register_chat_rpc_callbacks(self)

	for key, value in pairs(self) do
		if key:sub(1, 4) == "rpc_" and type(value) == "function" then
			self[key] = function(...)
				Profiler.start(key)
				value(...)
				Profiler.stop()
			end
		end
	end

	patch_add_profiling_scopes(self, network_callback_names)
	patch_add_profiling_scopes(self, NetworkLookup.game_object_functions)
end

function GameNetworkManager:rpc_ping(sender, t)
	RPC.rpc_pong(sender, t)
end

function GameNetworkManager:rpc_pong(sender, t)
	print("PONG", Managers.time:time("game") - t)
end

function GameNetworkManager:update(dt)
	if self._split_update then
		Network.update_receive(dt, self)

		self._received_network = true
	else
		Network.update(dt, self)
	end

	if not self._lobby then
		return
	end

	if Managers.lobby.server and self._game and #Managers.player:players() > 0 then
		local t = self._ping_table_time_left or 0

		t = t - dt

		if t < 0 then
			self:broadcast_ping_table()

			t = PING_TABLE_SYNC_INTERVAL
		end

		self._ping_table_time_left = t
	end

	if Managers.lobby.state == LobbyState.JOINED and not self._game and Managers.lobby.server and not self._left_game then
		local game = Network.create_game_session()

		UnitSynchronizer.set_world(GameSession.unit_synchronizer(game), self._world)
		GameSession.make_game_session_host(game)
		self:_send_game_server_set(true)

		self._game_started = true
		self._game = game
		self._split_update = true
	elseif Managers.lobby.state == LobbyState.JOINED and not self._game and Managers.lobby:game_server_set() and not self._left_game then
		local game = Network.create_game_session()

		UnitSynchronizer.set_world(GameSession.unit_synchronizer(game), self._world)

		local player = Managers.player:player(1)
		local profile_id = Managers.persistence:profile_id()

		self:send_rpc_server("rpc_drop_in", player.index, profile_id, IS_DEMO, Postman.anti_cheat_key)

		self._game = game
		self._split_update = true
	elseif Managers.lobby.state == LobbyState.FAILED then
		self._join_lobby_failed = true
	end

	if self._migrate_game_object_stack then
		for _, config in ipairs(self._migrate_game_object_stack) do
			GameSession.migrate_game_object(self._game, config.object_id, config.player_id, self)
		end

		self._migrate_game_object_stack = nil
	end

	if self._game_started and self._game then
		local broken = GameSession.broken_connection(self._game)

		while broken do
			if Managers.lobby.server then
				printf("removing broken gamesession peer %s", tostring(broken))
				self:remove(broken, false, true)
			end

			broken = GameSession.broken_connection(self._game)
		end
	end

	if Managers.lobby.server and self._game_started and self._game then
		local left = GameSession.wants_to_leave(self._game)

		while left do
			printf("removing gamesession peer %s that wants to leave", tostring(left))
			self:remove(left)

			left = GameSession.wants_to_leave(self._game)
		end
	end

	if self._game and self._game_session_disconnect then
		Network.shutdown_game_session()

		self._game = nil
		self._left_game = true
	end

	if Managers.lobby.server and self:game() then
		Managers.state.ping:update(Managers.time:time("game"))
	end
end

function GameNetworkManager:post_update(dt)
	if self._received_network then
		Network.update_transmit()

		self._received_network = false
	end
end

function GameNetworkManager:_sample_ping()
	for player_index, player in pairs(Managers.player:players()) do
		if player.remote then
			local ping_data = player.ping_data
			local ping = self.ping_manager:is_active() and self.ping_manager:get_ping(player:network_id()) or Network.ping(player:network_id())

			ping_data.ping_table_index = ping_data.ping_table_index % PING_SAMPLES_MAX_SIZE + 1
			ping_data.ping_table[ping_data.ping_table_index] = ping
			ping_data.mean_ping = self:_calculate_mean_ping(ping_data.ping_table)
		end
	end
end

function GameNetworkManager:_calculate_mean_ping(ping_table)
	local ping_sum = 0

	for _, ping in ipairs(ping_table) do
		ping_sum = ping_sum + ping
	end

	return math.ceil(ping_sum / #ping_table * 1000)
end

function GameNetworkManager:_sync_mean_ping()
	for player_index, player in pairs(Managers.player:players()) do
		if not player.ai_player and player.game_object_id then
			local mean_ping = math.clamp(player.ping_data.mean_ping, NetworkConstants.ping.min, NetworkConstants.ping.max)

			GameSession.set_game_object_field(self:game(), player.game_object_id, "ping", mean_ping)
		end
	end
end

function GameNetworkManager:_send_game_server_set(is_set)
	local lobby_members = Managers.lobby:lobby_members()

	for _, member in pairs(lobby_members) do
		if member ~= Network.peer_id() then
			RPC.rpc_game_server_set(member, is_set)
		end
	end

	Managers.lobby:set_game_server(is_set and Network.peer_id() or nil)
end

function GameNetworkManager:rpc_player_killed_by_enemy(sender, own_player_id, attacking_player_id)
	local own_player = Managers.player:player(self:temp_player_index(own_player_id))
	local attacking_player = Managers.player:player(self:temp_player_index(attacking_player_id))

	Managers.state.event:trigger("player_killed_by_enemy", own_player, attacking_player)
end

function GameNetworkManager:rpc_synch_unit_damage_level(sender, game_object_id, damage_level, dead)
	local level = LevelHelper:current_level(self._world)
	local unit_index = GameSession.game_object_field(self._game, game_object_id, "unit_game_object_id")
	local unit = Level.unit_by_index(level, unit_index)
	local extension = ScriptUnit.extension(unit, "damage_system")

	extension:rpc_synch_unit_damage_level(damage_level, dead)
end

function GameNetworkManager:rpc_climb_ladder(sender, unit_id, ladder_lvl_id)
	local unit = self._units[unit_id]
	local level = LevelHelper:current_level(self._world)
	local ladder_unit = Level.unit_by_index(level, ladder_lvl_id)

	if Unit.alive(unit) and Unit.alive(ladder_unit) then
		if Managers.lobby.server then
			self:send_rpc_clients_except("rpc_climb_ladder", sender, unit_id, ladder_lvl_id)
		end

		ScriptUnit.extension(unit, "locomotion_system"):set_ladder_unit(ladder_unit)
	end
end

function GameNetworkManager:rpc_remove_projectiles(sender, player_index)
	Managers.state.projectile:remove_projectiles(player_index)
end

function GameNetworkManager:rpc_link_projectile_obj_id(sender, unit_hit_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal, actor_index)
	local hit_unit = self._units[unit_hit_id]
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients("rpc_link_projectile_obj_id", unit_hit_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, actor_index, impact_direction, normal)
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]
	local actor = Unit.actor(hit_unit, actor_index)

	Managers.state.projectile:link_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, false, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal, actor)
end

function GameNetworkManager:rpc_link_projectile_lvl_id(sender, unit_lvl_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	local level = LevelHelper:current_level(self._world)
	local hit_unit = Level.unit_by_index(level, unit_lvl_id)
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients("rpc_link_projectile_lvl_id", unit_lvl_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]

	Managers.state.projectile:link_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, false, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal)
end

function GameNetworkManager:rpc_link_thrown_projectile_obj_id(sender, unit_hit_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal, lootable)
	local hit_unit = self._units[unit_hit_id]
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]

	Managers.state.projectile:link_thrown_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal, lootable)
end

function GameNetworkManager:rpc_thrown_projectile_disabled(sender, projectile_id)
	local projectile_unit = self._units[projectile_id]

	Managers.state.projectile:thrown_projectile_disabled(projectile_unit)
end

function GameNetworkManager:rpc_link_thrown_projectile_lvl_id(sender, unit_lvl_id, node_index, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal, lootable)
	local level = LevelHelper:current_level(self._world)
	local hit_unit = Level.unit_by_index(level, unit_lvl_id)
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]

	Managers.state.projectile:link_thrown_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal, lootable)
end

function GameNetworkManager:rpc_drop_projectile_obj_id(sender, unit_hit_id, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	local hit_unit = self._units[unit_hit_id]
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients("rpc_drop_projectile_obj_id", unit_hit_id, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]

	Managers.state.projectile:drop_projectile(hit_unit, position, rotation, damage, penetrated, target_type, projectile_unit, false, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal)
end

function GameNetworkManager:rpc_drop_projectile_lvl_id(sender, unit_lvl_id, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	local level = LevelHelper:current_level(self._world)
	local hit_unit = Level.unit_by_index(level, unit_lvl_id)
	local projectile_unit = self._units[projectile_id]

	if not hit_unit or not Unit.alive(hit_unit) or not projectile_unit or not Unit.alive(projectile_unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients("rpc_drop_projectile_lvl_id", unit_lvl_id, projectile_id, position, rotation, damage, penetrated, target_type_id, hit_zone_id, impact_direction, normal)
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]

	Managers.state.projectile:drop_projectile(hit_unit, position, rotation, damage, penetrated, target_type, projectile_unit, false, NetworkLookup.hit_zones[hit_zone_id], impact_direction, normal)
end

function GameNetworkManager:rpc_battle_tiebreak(sender)
	local world = self._world
	local level = LevelHelper:current_level(self._world)

	Level.trigger_event(level, "battle_tiebreak_client")
end

function GameNetworkManager:rpc_activate_spawn_area(sender, spawn_area_id, team_name_id)
	local spawn_area_name = Managers.state.spawn:network_lookup_to_area_name(spawn_area_id)
	local team_name = NetworkLookup.team[team_name_id]

	Managers.state.spawn:activate_spawn_area(spawn_area_name, team_name, Vector3.right())
end

function GameNetworkManager:rpc_deactivate_spawn_area(sender, spawn_area_id, team_name_id)
	local spawn_area_name = Managers.state.spawn:network_lookup_to_area_name(spawn_area_id)
	local team_name = NetworkLookup.team[team_name_id]

	Managers.state.spawn:deactivate_spawn_area(spawn_area_name, team_name)
end

function GameNetworkManager:rpc_set_spawn_area_priority(sender, spawn_area_id, team_name_id, priority)
	local spawn_area_name = Managers.state.spawn:network_lookup_to_area_name(spawn_area_id)
	local team_name = NetworkLookup.team[team_name_id]

	Managers.state.spawn:set_spawn_area_priority(spawn_area_name, team_name, priority)
end

function GameNetworkManager:rpc_yield_request(sender, unit_id)
	local unit = self._units[unit_id]

	if unit and Unit.alive(unit) then
		local damage_ext = ScriptUnit.extension(unit, "damage_system")
		local can_yield = damage_ext:can_yield()

		if can_yield then
			local self_peer_id = Network.peer_id()

			if sender == self_peer_id then
				InteractionHelper:confirmed("yield", ScriptUnit.extension(unit, "locomotion_system"))
			else
				InteractionHelper:confirm_request("yield", sender, unit_id)
			end

			damage_ext:yield()

			return
		end
	end

	InteractionHelper:deny_request("yield", sender, unit_id)
end

function GameNetworkManager:rpc_yield_denied(sender, unit_id)
	local unit = self._units[unit_id]

	InteractionHelper:denied("yield", ScriptUnit.extension(unit, "locomotion_system"))
end

function GameNetworkManager:rpc_yield_confirmed(sender, unit_id)
	local unit = self._units[unit_id]

	InteractionHelper:confirmed("yield", ScriptUnit.extension(unit, "locomotion_system"))
end

function GameNetworkManager:_shutdown_server()
	for _, player in ipairs(GameSession.other_peers(self._game)) do
		self:remove(player, true)
	end

	self:game_session_disconnect()

	for game_object_id, owner_id in pairs(self._owners) do
		if Network.peer_id() ~= owner_id then
			self:game_object_destroyed(game_object_id, owner_id)
		end
	end

	GameSession.shutdown_game_session_host(self._game)
	Network.shutdown_game_session()
	self:_send_game_server_set(false)

	self._game = nil
	self._left_game = true
end

function GameNetworkManager:leave_game()
	if Managers.lobby.server then
		self:_shutdown_server()
	else
		GameSession.leave(self._game)
	end
end

function GameNetworkManager:exit_all_to_menu_lobby()
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_exit_to_menu_lobby")

		self._exit_to_menu_lobby = true

		self:_shutdown_server()
	else
		assert(false, "Only server can exit all players to menu lobby!")
	end
end

function GameNetworkManager:reload_level(level_key, game_mode_key, win_score, time_limit)
	local lobby_manager = Managers.lobby

	Player_pings = {}

	if lobby_manager.server then
		local game_server_settings = lobby_manager.game_server_settings
		local game_start_countdown = game_server_settings and game_server_settings.game_start_countdown or GameSettingsDevelopment.game_start_countdown

		self._next_level_settings = "reload_level"

		local own_peer_id = Network.peer_id()

		for _, member in ipairs(Managers.lobby:lobby_members()) do
			if member ~= own_peer_id then
				RPC.rpc_reload_level(member)
			end
		end

		self:_shutdown_server()
	else
		assert(false, "Only server can initiate reloading level!")
	end
end

function GameNetworkManager:rpc_reload_level(sender)
	self._next_level_settings = "reload_level"

	print("reload_level", sender)
end

function GameNetworkManager:load_next_level(level_key, game_mode_key, win_score, time_limit)
	local lobby_manager = Managers.lobby

	if lobby_manager.server then
		local game_server_settings = lobby_manager.game_server_settings
		local game_start_countdown = game_server_settings and game_server_settings.game_start_countdown or GameSettingsDevelopment.game_start_countdown

		self._next_level_settings = {
			level_key = level_key,
			game_mode_key = game_mode_key,
			game_start_countdown = game_start_countdown,
			win_score = win_score,
			time_limit = time_limit
		}

		local level = LevelSettings[level_key]
		local map = level.game_server_map_name

		lobby_manager:set_lobby_data("map", map)

		if lobby_manager:is_dedicated_server() then
			lobby_manager:set_game_tag("game_mode_key", game_mode_key)
		end

		lobby_manager:set_lobby_data("level_key", level_key)
		lobby_manager:set_lobby_data("game_mode_key", game_mode_key)
		lobby_manager:set_lobby_data("win_score", win_score)
		lobby_manager:set_lobby_data("time_limit", time_limit)

		for _, member in ipairs(Managers.lobby:lobby_members()) do
			if member ~= Network.peer_id() then
				RPC.rpc_load_next_level(member, NetworkLookup.level_keys[level_key], NetworkLookup.game_mode_keys[game_mode_key], game_start_countdown, win_score, time_limit)
			end
		end

		self:_shutdown_server()
	else
		assert(false, "Only server can initiate loading of next level!")
	end
end

function GameNetworkManager:rpc_exit_to_menu_lobby()
	self._exit_to_menu_lobby = true
end

function GameNetworkManager:rpc_load_next_level(sender, level_key, game_mode_key, game_start_countdown, win_score, time_limit)
	Profiler.start("EventManager:trigger: level_change")
	Managers.state.event:trigger("level_change")
	Profiler.stop()

	self._next_level_settings = {
		level_key = NetworkLookup.level_keys[level_key],
		game_mode_key = NetworkLookup.game_mode_keys[game_mode_key],
		game_start_countdown = game_start_countdown,
		win_score = win_score,
		time_limit = time_limit
	}
end

function GameNetworkManager:exit_to_menu_lobby()
	return self._exit_to_menu_lobby
end

function GameNetworkManager:has_left_game()
	return self._left_game
end

function GameNetworkManager:join_lobby_failed()
	return self._join_lobby_failed
end

function GameNetworkManager:next_level_settings()
	return self._next_level_settings
end

function GameNetworkManager:destroy()
	if self._lobby then
		NetworkConstants = nil
	end
end

function GameNetworkManager:game()
	return self._game_started and self._game
end

function GameNetworkManager:game_object_owner(obj_id)
	return self._owners[obj_id]
end

function GameNetworkManager:game_object_id(unit)
	return Unit.get_data(unit, "game_object_id")
end

function GameNetworkManager:level_object_id(unit)
	local current_level = LevelHelper:current_level(self._world)

	return Level.unit_index(current_level, unit)
end

function GameNetworkManager:unit_game_object_id(unit)
	if Unit.has_data(unit, "game_object_id") then
		return Unit.get_data(unit, "game_object_id")
	end
end

function GameNetworkManager:game_object_unit(obj_id)
	return self._units[obj_id]
end

function GameNetworkManager:create_game_object(object_template, data_table, local_object_destroy_callback, local_object_created_func, ...)
	if script_data.network_debug then
		print("CREATING GAME OBJECT")
	end

	local game_object_id = GameSession.create_game_object(self._game, object_template, data_table)

	self._game_object_types[game_object_id] = object_template
	self._game_object_disconnect_callbacks[game_object_id] = local_object_destroy_callback

	if local_object_created_func then
		self[local_object_created_func](self, game_object_id, ...)
	end

	if script_data.network_debug then
		print("GAME OBJECT CREATED", game_object_id)
		table.dump(data_table)
	end

	return game_object_id
end

function GameNetworkManager:create_spawn_point_game_object(data_table)
	local game_object_id = GameSession.create_game_object(self._game, "spawn_point", data_table)

	self._game_object_types[game_object_id] = "spawn_point"

	if script_data.network_debug then
		print("CREATE GAME OBJECT id: " .. game_object_id .. " type: spawn_point")
	end

	return game_object_id
end

function GameNetworkManager:create_player_game_object(profile, data_table, local_object_destroy_callback)
	local game_object_id = GameSession.create_game_object(self._game, profile, data_table)

	self._game_object_types[game_object_id] = "player"
	self._game_object_disconnect_callbacks[game_object_id] = local_object_destroy_callback

	if script_data.network_debug then
		print("CREATE GAME OBJECT id: " .. game_object_id .. " type: player")
		table.dump(data_table)
	end

	return game_object_id
end

function GameNetworkManager:cb_spawn_point_game_object_created(game_object_id, owner_id)
	Managers.state.event:trigger("event_create_client_spawnpoint", game_object_id)

	if script_data.spawn_debug then
		print("spawn created", game_object_id)
	end
end

function GameNetworkManager:cb_player_game_object_created(game_object_id, owner_id)
	local player_manager = Managers.player

	assert(not Managers.lobby.server, "cb_player_game_object_created: FAIL")

	if script_data.network_debug then
		print("cb_player_game_object_created", game_object_id, owner_id)
	end

	if script_data.network_debug then
		print("cb_player_game_object_created, player_id:", game_object_id)
	end

	local player_manager = Managers.player
	local players = player_manager:players()
	local max_players = player_manager.MAX_PLAYERS
	local peer_id = GameSession.game_object_field(self._game, game_object_id, "network_id")
	local local_id = GameSession.game_object_field(self._game, game_object_id, "local_id")

	if peer_id == Network.peer_id() then
		local player = player_manager:player(local_id)

		player:set_game_object_id(game_object_id)
		player:sync_coat_of_arms()
	else
		if script_data.network_debug then
			print("PLAYER ADDED " .. tostring(game_object_id))
		end

		player_manager:add_remote_player(local_id, game_object_id, peer_id)
	end
end

function GameNetworkManager:cb_player_game_object_destroyed(game_object_id, owner_id)
	local player_manager = Managers.player
	local player_id = game_object_id

	if not Managers.lobby.server and player_manager:player_exists(player_id) then
		player_manager:remove_player(player_id)
	end
end

function GameNetworkManager:cb_squad_object_created(game_object_id, owner_id)
	local team_name = NetworkLookup.team[GameSession.game_object_field(self._game, game_object_id, "team_name")]
	local squad_id = GameSession.game_object_field(self._game, game_object_id, "squad_id")
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team:squad(squad_id)

	squad:cb_game_object_created(game_object_id)
end

function GameNetworkManager:cb_squad_object_destroyed(game_object_id, owner_id)
	if owner_id ~= Network.peer_id() then
		local team_name = NetworkLookup.team[GameSession.game_object_field(self._game, game_object_id, "team_name")]
		local squad_id = GameSession.game_object_field(self._game, game_object_id, "squad_id")
		local team = Managers.state.team:team_by_name(team_name)
		local squad = team:squad(squad_id)

		squad:cb_game_object_created(game_object_id)
	end
end

function GameNetworkManager:cb_player_stats_created(game_object_id, owner_id)
	local player_id = GameSession.game_object_field(self._game, game_object_id, "player_id")
	local player = Managers.player:player(self:temp_player_index(player_id))

	player:set_stat_game_object(game_object_id, self._game)
end

function GameNetworkManager:cb_player_stats_destroyed(game_object_id, owner_id)
	if owner_id ~= Network.peer_id() then
		local player_id = GameSession.game_object_field(self._game, game_object_id, "player_id")

		if not Managers.player:player_exists(player_id) then
			return
		end

		local player = Managers.player:player(player_id)

		player:set_stat_game_object(nil)
	end
end

function GameNetworkManager:cb_generic_unit_interactable_created(game_object_id, owner_id)
	local unit_level_object_id = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_object_id)
	local extension = ScriptUnit.extension(unit, "objective_system")

	extension:set_game_object_id(game_object_id, self._game)
end

function GameNetworkManager:cb_generic_unit_interactable_destroyed(game_object_id, owner_id)
	local unit_level_object_id = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_object_id)
	local extension = ScriptUnit.extension(unit, "objective_system")

	extension:remove_game_object_id()
end

function GameNetworkManager:cb_generic_damage_extension_game_object_created(game_object_id, owner_id)
	local unit_level_object_id = GameSession.game_object_field(self._game, game_object_id, "unit_game_object_id")
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_object_id)
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:set_game_object_id(game_object_id, self._game)
end

function GameNetworkManager:cb_generic_damage_extension_game_object_destroyed(game_object_id, owner_id)
	local unit_level_object_id = GameSession.game_object_field(self._game, game_object_id, "unit_game_object_id")
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_object_id)

	if unit and Unit.alive(unit) then
		local damage_ext = ScriptUnit.extension(unit, "damage_system")

		damage_ext:remove_game_object_id()
	else
		Application.warning("Trying to destroy a game object for an unspawned unit!")
	end
end

function GameNetworkManager:cb_player_damage_extension_game_object_created(game_object_id, owner_id)
	local unit_game_object_id = GameSession.game_object_field(self._game, game_object_id, "player_unit_game_object_id")
	local unit = self._units[unit_game_object_id]

	if script_data.network_debug then
		print("DAMAGE EXT HUSK SET GAME OBJECT", unit_game_object_id, game_object_id, unit)
	end

	if not Unit.alive(unit) then
		return
	end

	if not ScriptUnit.has_extension(unit, "damage_system") then
		return
	end

	local area_buff_ext = ScriptUnit.extension(unit, "area_buff_system")

	area_buff_ext:set_game_object_id(game_object_id, self._game)

	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:set_game_object_id(game_object_id, self._game)
end

function GameNetworkManager:cb_player_damage_extension_game_object_destroyed(game_object_id, owner_id)
	local unit_game_object_id = GameSession.game_object_field(self._game, game_object_id, "player_unit_game_object_id")
	local unit = self._units[unit_game_object_id]

	if not Unit.alive(unit) then
		return
	end

	if script_data.network_debug then
		print("DAMAGE EXT HUSK REMOVE GAME OBJECT", unit_game_object_id, game_object_id, unit)
	end

	local area_buff_ext = ScriptUnit.extension(unit, "area_buff_system")

	area_buff_ext:remove_game_object_id(game_object_id, self._game)

	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:remove_game_object_id(game_object_id, self._game)
end

function GameNetworkManager:cb_area_buff_game_object_destroyed(game_object_id, owner_id)
	local unit_game_object_id = GameSession.game_object_field(self._game, game_object_id, "player_unit_game_object_id")
	local unit = self._units[unit_game_object_id]

	if not Unit.alive(unit) then
		return
	end

	local area_buff_ext = ScriptUnit.extension(unit, "area_buff_system")

	area_buff_ext:remove_game_object_id(game_object_id, self._game)
end

function GameNetworkManager:cb_local_unit_spawned(obj_id, unit)
	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)
end

function GameNetworkManager:game_object_created(game_object_id, owner_id)
	if script_data.network_debug then
		print("game object created", game_object_id, owner_id)
	end

	local id = GameSession.game_object_field(self._game, game_object_id, "game_object_created_func")
	local game_object_created_func = NetworkLookup.game_object_functions[id]

	if script_data.network_debug then
		print("calling game object func", game_object_created_func)
	end

	self[game_object_created_func](self, game_object_id, owner_id)
end

function GameNetworkManager:cb_team_created(obj_id, owner_id)
	local team_manager = Managers.state.team
	local name = NetworkLookup.team[GameSession.game_object_field(self._game, obj_id, "name")]

	team_manager:cb_game_object_created(name, obj_id)
end

function GameNetworkManager:cb_team_destroyed(obj_id, owner_id)
	local team_manager = Managers.state.team
	local name = NetworkLookup.team[GameSession.game_object_field(self._game, obj_id, "name")]

	team_manager:cb_game_object_destroyed(name, obj_id)
end

function GameNetworkManager:cb_spawn_flag(obj_id, owner_id)
	local game = self._game
	local husk_unit = NetworkLookup.husks[GameSession.game_object_field(game, obj_id, "husk_unit")]
	local position = GameSession.game_object_field(game, obj_id, "position")
	local rotation = GameSession.game_object_field(game, obj_id, "rotation")

	if script_data.network_debug then
		print("spawning_flag_husk: ", husk_unit, position, rotation, game, obj_id, owner_id)
	end

	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	Unit.set_data(unit, "game_object_id", obj_id)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Managers.state.entity:register_unit(self._world, unit, obj_id, game, owner_id)

	if script_data.network_debug then
		print("SPAWNING FLAG HUSK", obj_id)
	end

	local unit = self._units[obj_id]
	local objective_ext = ScriptUnit.extension(unit, "flag_system")

	objective_ext:set_game_object_id(obj_id, game)
end

function GameNetworkManager:cb_spawn_unit(obj_id, owner_id)
	local husk_unit = NetworkLookup.husks[GameSession.game_object_field(self._game, obj_id, "husk_unit")]
	local position = GameSession.game_object_field(self._game, obj_id, "position")
	local rotation = GameSession.game_object_field(self._game, obj_id, "rotation")
	local ghost_mode = GameSession.game_object_field(self._game, obj_id, "ghost_mode")

	if script_data.network_debug then
		print("spawning_husk: ", husk_unit, position, rotation, self._game, obj_id, owner_id)
	end

	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	Unit.set_data(unit, "game_object_id", obj_id)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Managers.state.entity:register_unit(self._world, unit, obj_id, self._game, ghost_mode)

	if script_data.network_debug then
		print("SPAWNING HUSK", obj_id)
	end
end

function GameNetworkManager:cb_spawn_player_unit(obj_id, owner_id)
	local husk_unit = DefaultUnits.standard.husk
	local position = GameSession.game_object_field(self._game, obj_id, "position")
	local rotation = GameSession.game_object_field(self._game, obj_id, "rotation")
	local ghost_mode = GameSession.game_object_field(self._game, obj_id, "ghost_mode")

	if script_data.network_debug then
		print("spawning_husk: ", husk_unit, position, rotation, self._game, obj_id, owner_id)
	end

	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	Unit.set_data(unit, "game_object_id", obj_id)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Managers.state.entity:register_unit(self._world, unit, obj_id, self._game, ghost_mode)

	local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_ext:setup_player_profile(obj_id)

	if script_data.network_debug then
		print("SPAWNING HUSK", obj_id)
	end
end

function GameNetworkManager:cb_spawn_ai_unit(obj_id, owner_id)
	local husk_unit = DefaultUnits.standard.ai
	local position = GameSession.game_object_field(self._game, obj_id, "position")
	local rotation = GameSession.game_object_field(self._game, obj_id, "rotation")
	local ghost_mode = GameSession.game_object_field(self._game, obj_id, "ghost_mode")

	if script_data.network_debug then
		print("spawning_husk: ", husk_unit, position, rotation, self._game, obj_id, owner_id)
	end

	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	Unit.set_data(unit, "game_object_id", obj_id)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Managers.state.entity:register_unit(self._world, unit, obj_id, self._game, ghost_mode)

	if script_data.network_debug then
		print("SPAWNING HUSK", obj_id)
	end
end

function GameNetworkManager:cb_spawn_projectile(obj_id, owner_id)
	local game = self._game
	local husk_unit = NetworkLookup.husks[GameSession.game_object_field(game, obj_id, "husk_unit")]
	local position = GameSession.game_object_field(game, obj_id, "position")
	local projectile_name = NetworkLookup.projectiles[GameSession.game_object_field(game, obj_id, "projectile_name_id")]
	local gear_name = NetworkLookup.inventory_gear[GameSession.game_object_field(game, obj_id, "gear_name_id")]
	local exit_velocity = GameSession.game_object_field(game, obj_id, "exit_velocity")
	local user_object_id = GameSession.game_object_field(game, obj_id, "user_object_id")
	local weapon_object_id = GameSession.game_object_field(game, obj_id, "weapon_object_id")
	local player_index = GameSession.game_object_field(game, obj_id, "player_index")
	local gravity_multiplier = GameSession.game_object_field(game, obj_id, "gravity_multiplier")
	local charge_value = GameSession.game_object_field(game, obj_id, "charge_value")
	local properties_id = GameSession.game_object_field(game, obj_id, "properties_id")
	local user_unit = self._units[user_object_id]
	local weapon_unit = self._units[weapon_object_id]
	local rotation = Quaternion.look(exit_velocity, Vector3.up())
	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Unit.set_data(unit, "game_object_id", obj_id)

	player_index = self:temp_player_index(player_index)

	Managers.state.entity:register_unit(self._world, unit, player_index, user_unit, weapon_unit, true, game, projectile_name, gear_name, exit_velocity, gravity_multiplier, charge_value, properties_id)
end

function GameNetworkManager:rpc_create_squad_flag(sender, team_id, squad_id, position, rotation)
	local team_name = NetworkLookup.team[team_id]
	local flag_unit_name = "units/weapons/wpn_squad_flag/wpn_squad_flag_" .. team_name
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team:squad(squad_id)

	squad:server_create_squad_flag(team_id, squad_id, position, rotation)
end

function GameNetworkManager:cb_spawn_squad_flag(obj_id, owner_id)
	local game = self._game
	local team_name = NetworkLookup.team[GameSession.game_object_field(game, obj_id, "team_name")]
	local squad_id = GameSession.game_object_field(game, obj_id, "squad_id")
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team:squad(squad_id)
	local husk_unit = NetworkLookup.husks[GameSession.game_object_field(game, obj_id, "husk_unit")]
	local position = GameSession.game_object_field(game, obj_id, "position")
	local rotation = GameSession.game_object_field(game, obj_id, "rotation")
	local team_name = NetworkLookup.team[GameSession.game_object_field(game, obj_id, "team_name")]
	local unit = World.spawn_unit(self._world, husk_unit, position, rotation)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Managers.state.entity:register_unit(self._world, unit, team_name, squad_id)
	Unit.set_data(unit, "game_object_id", obj_id)
	squad:register_squad_flag(unit, obj_id)
end

function GameNetworkManager:rpc_destroy_flag(sender, obj_id)
	local unit = self._units[obj_id]
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:rpc_destroy_flag()
end

function GameNetworkManager:cb_spawn_gear(obj_id, owner_id)
	if script_data.network_debug then
		print("[GameNetworkManager] cb_spawn_gear")
	end

	local dropped = GameSession.game_object_field(self._game, obj_id, "dropped")
	local unit
	local gear_name = NetworkLookup.inventory_gear[GameSession.game_object_field(self._game, obj_id, "gear_name")]

	if not dropped then
		local user_object_id = GameSession.game_object_field(self._game, obj_id, "user_object_id")
		local user_unit = self._units[user_object_id]

		if script_data.network_debug then
			print("   user unit:", tostring(user_unit), "user object id:", user_object_id)
		end

		local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

		if script_data.network_debug and locomotion then
			print("   locomotion system:", locomotion.SYSTEM)
		end

		local inventory = locomotion:inventory()
		local slot_name = NetworkLookup.inventory_slots[GameSession.game_object_field(self._game, obj_id, "slot_name")]

		unit = inventory:add_gear(gear_name, obj_id, slot_name, locomotion)
	else
		local unit_name = Gear[gear_name].husk_unit

		unit = World.spawn_unit(self._world, unit_name)

		Unit.set_data(unit, "dropped", true)
		Unit.set_data(unit, "gear_name", gear_name)

		local actor_index = Unit.find_actor(unit, "dropped")

		Unit.create_actor(unit, actor_index, 0)
	end

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Unit.set_data(unit, "game_object_id", obj_id)

	if Managers.lobby.server then
		Managers.state.entity:register_unit(self._world, unit)
	end
end

function GameNetworkManager:cb_local_gear_unit_spawned(obj_id, unit)
	if script_data.network_debug then
		print("[GameNetworkManager] cb_local_gear_unit_spawned " .. tostring(unit))
	end

	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)

	if Managers.lobby.server then
		Managers.state.entity:register_unit(self._world, unit)
	end
end

function GameNetworkManager:cb_capture_point_created(obj_id, owner_id)
	local game = self._game
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(game, obj_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Unit.set_data(unit, "game_object_id", obj_id)

	local objective_ext = ScriptUnit.extension(unit, "objective_system")

	objective_ext:set_game_object_id(obj_id, game)

	local object_order_id = GameSession.game_object_field(game, obj_id, "object_order_id")

	if Managers.state.game_mode:game_mode_key() == "con" and NetworkLookup.objective_point_order_ids[object_order_id] ~= "none" then
		Managers.state.event:trigger("objective_points_ordered", GameSession.game_object_field(game, obj_id, "object_order_id"), unit)
	end
end

function GameNetworkManager:cb_payload_created(obj_id, owner_id)
	local game = self._game
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(game, obj_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Unit.set_data(unit, "game_object_id", obj_id)

	local objective_ext = ScriptUnit.extension(unit, "objective_system")

	objective_ext:set_game_object_id(obj_id, game)
end

function GameNetworkManager:cb_local_payload_created(obj_id, unit)
	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)
end

function GameNetworkManager:cb_local_capture_point_created(obj_id, unit)
	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)
end

function GameNetworkManager:cb_payload_destroyed(obj_id)
	local unit = self._units[obj_id]

	if not Managers.lobby.server then
		local objective_ext = ScriptUnit.extension(unit, "objective_system")

		objective_ext:set_game_object_id(nil)
	end

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_capture_point_destroyed(obj_id)
	local unit = self._units[obj_id]

	if not Managers.lobby.server then
		local objective_ext = ScriptUnit.extension(unit, "objective_system")

		objective_ext:set_game_object_id(nil)
	end

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_player_profile_created(obj_id, owner_id)
	local player_game_obj_id = GameSession.game_object_field(self._game, obj_id, "player_game_obj_id")
	local unit = self._units[player_game_obj_id]

	if unit then
		local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_ext:setup_player_profile(obj_id)
	end
end

function GameNetworkManager:rpc_sync_coat_of_arms(sender, player_game_object_id, hot_join, r_base_clr_id, r_mid_heraldry_clr_id, r_top_heraldry_clr_id, r_charge_heraldry_clr_id, r_mid_heraldry, r_top_heraldry, r_charge_heraldry, w_base_clr_id, w_mid_heraldry_clr_id, w_top_heraldry_clr_id, w_charge_heraldry_clr_id, w_mid_heraldry, w_top_heraldry, w_charge_heraldry)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_game_object_id))

	if Managers.lobby.server then
		Managers.state.network:send_rpc_clients_except("rpc_sync_coat_of_arms", sender, player_game_object_id, false, r_base_clr_id, r_mid_heraldry_clr_id, r_top_heraldry_clr_id, r_charge_heraldry_clr_id, r_mid_heraldry, r_top_heraldry, r_charge_heraldry, w_base_clr_id, w_mid_heraldry_clr_id, w_top_heraldry_clr_id, w_charge_heraldry_clr_id, w_mid_heraldry, w_top_heraldry, w_charge_heraldry)

		local players = player_manager:players()

		for _, p in pairs(players) do
			if p ~= player then
				local coat_of_arms = p:get_coat_of_arms()

				if coat_of_arms then
					local red_coat_of_arms = coat_of_arms.red
					local white_coat_of_arms = coat_of_arms.white
					local red_base_color_index = red_coat_of_arms.base_color_index
					local red_mid_heraldry_color_index = red_coat_of_arms.mid_heraldry_color_index
					local red_top_heraldry_color_index = red_coat_of_arms.top_heraldry_color_index
					local red_charge_heraldry_color_index = red_coat_of_arms.charge_heraldry_color_index
					local red_mid_heraldry = NetworkLookup.coat_of_arms_materials[red_coat_of_arms.mid_heraldry]
					local red_top_heraldry = NetworkLookup.coat_of_arms_materials[red_coat_of_arms.top_heraldry]
					local red_charge_heraldry = NetworkLookup.coat_of_arms_materials[red_coat_of_arms.charge_heraldry]
					local white_base_color_index = white_coat_of_arms.base_color_index
					local white_mid_heraldry_color_index = white_coat_of_arms.mid_heraldry_color_index
					local white_top_heraldry_color_index = white_coat_of_arms.top_heraldry_color_index
					local white_charge_heraldry_color_index = white_coat_of_arms.charge_heraldry_color_index
					local white_mid_heraldry = NetworkLookup.coat_of_arms_materials[white_coat_of_arms.mid_heraldry]
					local white_top_heraldry = NetworkLookup.coat_of_arms_materials[white_coat_of_arms.top_heraldry]
					local white_charge_heraldry = NetworkLookup.coat_of_arms_materials[white_coat_of_arms.charge_heraldry]

					RPC.rpc_sync_coat_of_arms(sender, p:player_id(), false, red_base_color_index, red_mid_heraldry_color_index, red_top_heraldry_color_index, red_charge_heraldry_color_index, red_mid_heraldry, red_top_heraldry, red_charge_heraldry, white_base_color_index, white_mid_heraldry_color_index, white_top_heraldry_color_index, white_charge_heraldry_color_index, white_mid_heraldry, white_top_heraldry, white_charge_heraldry)
				end
			end
		end
	end

	local coat_of_arms = {
		red = {
			base_color_index = r_base_clr_id,
			mid_heraldry_color_index = r_mid_heraldry_clr_id,
			top_heraldry_color_index = r_top_heraldry_clr_id,
			charge_heraldry_color_index = r_charge_heraldry_clr_id,
			mid_heraldry = NetworkLookup.coat_of_arms_materials[r_mid_heraldry],
			top_heraldry = NetworkLookup.coat_of_arms_materials[r_top_heraldry],
			charge_heraldry = NetworkLookup.coat_of_arms_materials[r_charge_heraldry]
		},
		white = {
			base_color_index = w_base_clr_id,
			mid_heraldry_color_index = w_mid_heraldry_clr_id,
			top_heraldry_color_index = w_top_heraldry_clr_id,
			charge_heraldry_color_index = w_charge_heraldry_clr_id,
			mid_heraldry = NetworkLookup.coat_of_arms_materials[w_mid_heraldry],
			top_heraldry = NetworkLookup.coat_of_arms_materials[w_top_heraldry],
			charge_heraldry = NetworkLookup.coat_of_arms_materials[w_charge_heraldry]
		}
	}

	player:set_coat_of_arms(coat_of_arms)
end

function GameNetworkManager:destroy_game_object(object_id)
	local owner_id = self._owners[object_id]
	local object_destroy_func = NetworkLookup.game_object_functions[GameSession.game_object_field(self._game, object_id, "object_destroy_func")]

	if script_data.network_debug then
		print("DESTROY GAME OBJECT object_id:", object_id, "owner_id:", owner_id, "object_destroy_func:", object_destroy_func, "type:", self._game_object_types[object_id] or "unknown")
	end

	self._game_object_disconnect_callbacks[object_id] = nil

	self[object_destroy_func](self, object_id, owner_id)
	GameSession.destroy_game_object(self._game, object_id)
end

function GameNetworkManager:game_object_destroyed(object_id, owner_id)
	local object_destroy_func = NetworkLookup.game_object_functions[GameSession.game_object_field(self._game, object_id, "object_destroy_func")]

	if script_data.network_debug then
		print("GAME OBJECT DESTROYED object_id:", object_id, "owner_id:", owner_id, "object_destroy_func:", object_destroy_func, "type:", self._game_object_types[object_id] or "unknown")
	end

	self[object_destroy_func](self, object_id, owner_id)
end

function GameNetworkManager:migrate_game_object(object_id, player_id)
	self._migrate_game_object_stack = self._migrate_game_object_stack or {}

	table.insert(self._migrate_game_object_stack, {
		object_id = object_id,
		player_id = player_id
	})
end

function GameNetworkManager:game_object_migrated_away(object_id, new_peer_id)
	local unit = self._units[object_id]

	if Unit.alive(unit) and Unit.has_data(unit, "game_object_migrated_away_cb") then
		Unit.get_data(unit, "game_object_migrated_away_cb")(object_id, new_peer_id)
	end

	self._owners[object_id] = new_peer_id
	self._game_object_disconnect_callbacks[object_id] = nil

	if script_data.migration_debug then
		print("migrated away, object val game_object_created_func: ", GameSession.game_object_field(self._game, object_id, "game_object_created_func"))
		print("migrated away, object val owner_destroy_func: ", GameSession.game_object_field(self._game, object_id, "owner_destroy_func"))
	end
end

function GameNetworkManager:game_object_migrated_to_me(object_id, old_peer_id)
	local unit = self._units[object_id]

	if Unit.alive(unit) and Unit.has_data(unit, "game_object_migrated_to_me_cb") then
		Unit.get_data(unit, "game_object_migrated_to_me_cb")(object_id, old_peer_id)
	end

	self._game_object_disconnect_callbacks[object_id] = Unit.get_data(unit, "game_session_disconnect_callback")
	self._owners[object_id] = Network.peer_id()

	if script_data.migration_debug then
		print("migrated away, object val game_object_created_func: ", GameSession.game_object_field(self._game, object_id, "game_object_created_func"))
		print("migrated away, object val owner_destroy_func: ", GameSession.game_object_field(self._game, object_id, "owner_destroy_func"))
	end
end

function GameNetworkManager:game_session_disconnect(host_id)
	self._game_session_disconnect = true

	for _, callback in pairs(self._game_object_disconnect_callbacks) do
		callback()
	end
end

function GameNetworkManager:cb_destroy_gear(obj_id, owner_id)
	local unit = self._units[obj_id]
	local user_object_id = GameSession.game_object_field(self._game, obj_id, "user_object_id")
	local user_unit = self._units[user_object_id]

	if Unit.alive(unit) and Unit.get_data(unit, "dropped") then
		World.destroy_unit(self._world, unit)
	elseif user_unit then
		local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
		local inventory = locomotion:inventory()
		local slot_name = inventory:find_slot_by_unit(unit)

		if owner_id ~= Network.peer_id() and not Unit.get_data(unit, "gear_dead") then
			inventory:remove_gear(slot_name)
		end
	end

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_destroy_squad_flag_unit(obj_id)
	local unit = self._units[obj_id]
	local game = self._game
	local team_name = NetworkLookup.team[GameSession.game_object_field(game, obj_id, "team_name")]
	local squad_id = GameSession.game_object_field(game, obj_id, "squad_id")
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team:squad(squad_id)

	squad:unregister_squad_flag()
	Managers.state.entity:unregister_unit(unit)
	World.destroy_unit(self._world, unit)

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_destroy_unit(obj_id)
	local unit = self._units[obj_id]

	Managers.state.entity:unregister_unit(unit)
	World.destroy_unit(self._world, unit)

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_destroy_player_unit(obj_id)
	local unit = self._units[obj_id]
	local player_manager = Managers.player

	Managers.state.entity:unregister_unit(unit)
	World.destroy_unit(self._world, unit)

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_projectile_game_object_destroyed(obj_id)
	local unit = self._units[obj_id]

	Unit.set_data(unit, "game_object_id", nil)

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:rpc_loot_manager_client_destroy_gear_manually(sender, obj_id)
	local unit = self._units[obj_id]

	self._units[obj_id] = nil
	self._owners[obj_id] = nil

	if Unit.alive(unit) then
		World.destroy_unit(self._world, unit)
	end
end

function GameNetworkManager:cb_thrown_projectile_game_object_destroyed(obj_id)
	local unit = self._units[obj_id]

	if Unit.alive(unit) then
		Unit.set_data(unit, "game_object_id", nil)
	end

	self._units[obj_id] = nil
	self._owners[obj_id] = nil
end

function GameNetworkManager:cb_do_nothing()
	return
end

function GameNetworkManager:remove(peer, retain_peer, broken_connection)
	if Managers.admin then
		Managers.admin:unregister_peer(peer)
	end

	if self._object_synchronizing_clients[peer] then
		self._object_synchronizing_clients[peer] = nil
	else
		self:_cleanup_game_objects(peer)
		self:_cleanup_player(peer)
	end

	if not retain_peer then
		printf("GameSession.remove_peer(peer)", tostring(peer))
		GameSession.remove_peer(self._game, peer, self)

		if broken_connection and Managers.lobby:is_dedicated_server() then
			Managers.lobby.lobby:remove_member(peer)
		end
	else
		printf("GameNetworkManager:remove(%s). %s was kept in game_session!", tostring(peer), tostring(peer))
	end
end

function GameNetworkManager:_cleanup_teams(player)
	local team_manager = Managers.state.team

	if player.team then
		team_manager:remove_player_from_team_by_name(player, player.team.name)
	end
end

function GameNetworkManager:_cleanup_player(peer)
	local player_manager = Managers.player
	local player = player_manager:player_from_network_id(peer)

	while player do
		Managers.state.trap:remove_player_traps_server(player)
		Managers.state.projectile:remove_projectiles(player:player_id())
		self:_cleanup_teams(player)
		player_manager:remove_player(player.index)

		player = player_manager:player_from_network_id(peer)
	end
end

function GameNetworkManager:_cleanup_game_objects(peer)
	local objects = GameSession.objects_owned_by(self._game, peer)

	for _, id in ipairs(objects) do
		if self._owners[id] then
			local owner_destroy_func = NetworkLookup.game_object_functions[GameSession.game_object_field(self._game, id, "owner_destroy_func")]

			self[owner_destroy_func](self, id)
		end
	end
end

function GameNetworkManager:cb_destroy_object(object_id)
	return
end

function GameNetworkManager:cb_migrate_object(id)
	return
end

function GameNetworkManager:gear_game_object_inventory(object_id)
	local gear_name = NetworkLookup.inventory_gear[GameSession.game_object_field(self._game, object_id, "gear_name")]
	local user_object_id = GameSession.game_object_field(self._game, object_id, "user_object_id")
	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local inventory = locomotion:inventory()

	return inventory
end

function GameNetworkManager:gear_game_object_owner_locomotion(object_id)
	if not GameSession.game_object_exists(self._game, object_id) then
		return
	end

	local gear_name = NetworkLookup.inventory_gear[GameSession.game_object_field(self._game, object_id, "gear_name")]
	local user_object_id = GameSession.game_object_field(self._game, object_id, "user_object_id")
	local user_unit = self._units[user_object_id]

	if not user_unit then
		return
	end

	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	return locomotion
end

function GameNetworkManager:rpc_start_gear_fire_effect(sender, game_object_id)
	local unit = self._units[game_object_id]
	local user_unit = Unit.get_data(unit, "user_unit")
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local inventory = locomotion:inventory()
	local gear = inventory:gear("shield")

	gear:start_fire_effect()
end

function GameNetworkManager:rpc_end_gear_fire_effect(sender, game_object_id)
	local unit = self._units[game_object_id]
	local user_unit = Unit.get_data(unit, "user_unit")
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local inventory = locomotion:inventory()
	local gear = inventory:gear("shield")

	gear:end_fire_effect()
end

function GameNetworkManager:rpc_stat_weapon_missed(sender, player_object_id, gear_name_id)
	local player_id = player_object_id
	local player = Managers.player:player(self:temp_player_index(player_id))
	local gear_name = NetworkLookup.gear_names[gear_name_id]

	Managers.state.stats_collector:weapon_missed(player, gear_name)
end

function GameNetworkManager:rpc_award_achievement(sender, player_object_id, achievement_id)
	if not Achievement.unlocked(achievement_id) then
		AchievementHelper:unlock(achievement_id)
		print("GameNetworkManager:rpc_award_achievement", player_object_id, achievement_id)
	end
end

function GameNetworkManager:rpc_award_prize(sender, player_object_id, prize_id)
	print("GameNetworkManager:rpc_award_prize", player_object_id, NetworkLookup.prizes[prize_id])
	Managers.state.event:trigger("awarded_prize", NetworkLookup.prizes[prize_id])
end

function GameNetworkManager:rpc_award_medal(sender, player_object_id, medal_id)
	print("GameNetworkManager:rpc_award_medal", player_object_id, NetworkLookup.medals[medal_id])
	Managers.state.event:trigger("awarded_medal", NetworkLookup.medals[medal_id])
end

function GameNetworkManager:rpc_rank_up(sender, player_object_id, rank)
	print("GameNetworkManager:rpc_rank_up", player_object_id, rank)
	Managers.state.event:trigger("awarded_rank", rank)
	UnviewedUnlockedItemsHelper:rank_up(rank)
end

function GameNetworkManager:rpc_gain_exp_test(sender, player_id)
	local player = Managers.player:player(self:temp_player_index(player_id))

	Managers.state.event:trigger("gain_xp_test", player)
end

function GameNetworkManager:rpc_gain_xp_and_coins(sender, reason_id, xp, coins)
	local reason = NetworkLookup.xp_reason[reason_id]

	Managers.state.event:trigger("gained_xp_and_coins", reason, xp, coins)
end

function GameNetworkManager:rpc_set_short_term_goal(sender, end_time, end_xp, short_term_goal)
	Managers.state.event:trigger("short_term_goal_set", end_time, end_xp, short_term_goal)
end

function GameNetworkManager:rpc_short_term_goal_achieved(sender, short_term_goal)
	Managers.state.event:trigger("short_term_goal_achieved", short_term_goal)
end

function GameNetworkManager:rpc_destroy_objective(sender, game_object_id, damage)
	local unit_level_object_id = GameSession.game_object_field(self._game, game_object_id, "unit_game_object_id")
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_object_id)
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:die(damage)
end

function GameNetworkManager:rpc_raise_dual_wield_block(sender, user_object_id, slot_name, delay)
	delay = 0

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_raise_dual_wield_block", sender, user_object_id, slot_name, delay)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_raise_dual_wield_block(NetworkLookup.inventory_slots[slot_name], delay)
end

function GameNetworkManager:rpc_lower_dual_wield_block(sender, user_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_lower_dual_wield_block", sender, user_object_id)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_lower_dual_wield_block()
end

function GameNetworkManager:rpc_raise_parry_block(sender, user_object_id, slot_name, direction, delay)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_raise_parry_block", sender, user_object_id, slot_name, direction, delay)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_raise_parry_block(NetworkLookup.inventory_slots[slot_name], NetworkLookup.directions[direction], delay)
end

function GameNetworkManager:rpc_lower_parry_block(sender, user_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_lower_parry_block", sender, user_object_id)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_lower_parry_block()
end

function GameNetworkManager:rpc_hot_join_synch_parry_block(sender, player_object_id, slot_name, direction)
	local unit = self._units[player_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	locomotion:rpc_raise_parry_block(NetworkLookup.inventory_slots[slot_name], NetworkLookup.directions[direction], 0)
end

function GameNetworkManager:rpc_raise_shield_block(sender, user_object_id, slot_name)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_raise_shield_block", sender, user_object_id, slot_name)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_raise_shield_block(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_lower_shield_block(sender, user_object_id, play_animation)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_lower_shield_block", sender, user_object_id, play_animation)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_lower_shield_block(play_animation)
end

function GameNetworkManager:rpc_hot_join_synch_shield_block(sender, player_object_id, slot_name)
	local unit = self._units[player_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	locomotion:rpc_raise_shield_block(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_pose_melee_weapon(sender, user_object_id, direction)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_pose_melee_weapon", sender, user_object_id, direction)
	end

	local user_unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:rpc_pose_melee_weapon(NetworkLookup.directions[direction])
end

function GameNetworkManager:rpc_stop_posing_melee_weapon(sender, user_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_stop_posing_melee_weapon", sender, user_object_id)
	end

	local user_unit = self._units[user_object_id]

	if user_unit then
		local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

		locomotion:rpc_stop_posing_melee_weapon()
	end
end

function GameNetworkManager:rpc_hot_join_synch_pose(sender, user_object_id, direction)
	local unit = self._units[user_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	locomotion:rpc_hot_join_synch_pose(NetworkLookup.inventory_slots[direction])
end

function GameNetworkManager:rpc_synch_ready_projectile(sender, game_object_id, slot_name, projectile_name)
	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	if locomotion.IsHusk() then
		return
	end

	local inventory = locomotion:inventory()
	local gear = inventory:gear(NetworkLookup.inventory_slots[slot_name])
	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:ready_projectile(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_gear_destroyed(sender, object_id)
	if script_data.network_debug then
		print("GameNetworkManager:rpc_gear_dead")
	end

	local locomotion = self:gear_game_object_owner_locomotion(object_id)

	if not locomotion then
		return
	end

	local unit = self._units[object_id]

	locomotion:rpc_gear_dead(unit)
end

function GameNetworkManager:rpc_gear_dropped(sender, object_id)
	local locomotion = self:gear_game_object_owner_locomotion(object_id)

	if not locomotion then
		return
	end

	local unit = self._units[object_id]

	if not Unit.alive(unit) then
		return
	end

	if Managers.lobby.server then
		GameSession.migrate_game_object(self._game, object_id, Network.peer_id(), self)
		GameSession.set_game_object_field(self._game, object_id, "dropped", true)
		Managers.state.loot:add_gear(unit, false, GameSession.game_object_field(self._game, object_id, "ammunition"))
		self:send_rpc_clients_except("rpc_gear_dropped", sender, object_id)
	end

	locomotion:rpc_gear_dropped(unit)
end

function GameNetworkManager:rpc_gear_dead(sender, object_id)
	if script_data.network_debug then
		print("GameNetworkManager:rpc_gear_dead")
	end

	local locomotion = self:gear_game_object_owner_locomotion(object_id)

	if not locomotion then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_gear_dead", sender, object_id)
	end

	local unit = self._units[object_id]

	locomotion:rpc_gear_dead(unit)
	Unit.set_data(unit, "gear_dead", true)
end

function GameNetworkManager:rpc_player_dead(sender, object_id, is_instakill, damage_type_id, hit_zone_id, direction, finish_off)
	local unit = self._units[object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local damage_ext = ScriptUnit.extension(unit, "damage_system")
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local damage_type = NetworkLookup.damage_types[damage_type_id]

	locomotion:player_dead(is_instakill, damage_type, hit_zone, direction, finish_off)
	damage_ext:player_dead()
end

function GameNetworkManager:rpc_player_knocked_down(sender, object_id, hit_zone_id, impact_direction, damage_type)
	local unit = self._units[object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	locomotion:player_knocked_down(NetworkLookup.hit_zones[hit_zone_id], impact_direction, NetworkLookup.damage_types[damage_type])
	damage_ext:player_knocked_down()
end

function GameNetworkManager:rpc_suicide(sender, object_id)
	local unit = self._units[object_id]
	local damage_ext = ScriptUnit.extension(unit, "damage_system")
	local self_player = Managers.player:owner(unit)

	if self_player and not damage_ext:is_dead() then
		damage_ext:die(self_player, nil, true)
	end
end

function GameNetworkManager:rpc_self_knock_down(sender, object_id)
	local unit = self._units[object_id]
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	damage_ext:self_knock_down()
end

function GameNetworkManager:rpc_boundary_area_activated(sender, area_name)
	Managers.state.event:trigger("boundary_area_activated", area_name)
end

function GameNetworkManager:rpc_boundary_area_deactivated(sender, area_name)
	Managers.state.event:trigger("boundary_area_deactivated", area_name)
end

function GameNetworkManager:rpc_player_deserting(sender, player_id, deserting, deserter_timer)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local unit = player.player_unit

	if Unit.alive(unit) then
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")

		locomotion.deserting = deserting
	end

	if deserting then
		Managers.state.event:trigger("event_deserting_activated", player, deserter_timer)
	else
		Managers.state.event:trigger("event_deserting_deactivated", player)
	end
end

function GameNetworkManager:rpc_heal_on_taunt(sender, player_unit_id)
	local user_unit = self._units[player_unit_id]
	local damage = ScriptUnit.extension(user_unit, "damage_system")

	damage:heal_on_taunt_activated()

	local player = Managers.player:owner(user_unit)

	Managers.state.event:trigger("player_heal_on_taunt", player)
end

function GameNetworkManager:rpc_blade_master_got_parried(sender, parrying_id, attacking_id)
	local parrying_unit = self._units[parrying_id]
	local attacking_unit = self._units[attacking_id]

	if Managers.lobby.server then
		local attacking_player = Managers.player:owner(attacking_unit)

		self:send_rpc_clients_except("rpc_blade_master_got_parried", sender, parrying_id, attacking_id)
	end

	local attacking_locomotion = ScriptUnit.extension(attacking_unit, "locomotion_system")

	attacking_locomotion:blade_master_got_parried(parrying_unit, attacking_unit)
end

function GameNetworkManager:rpc_show_damage_number(sender, player_id, damage_type_id, damage, position, damage_range_type_id, hit_zone_id)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]

	Managers.state.event:trigger("show_damage_number", player, damage, position, hit_zone)
end

function GameNetworkManager:rpc_show_shield_damage_number(sender, player_id, damage_type_id, damage, position, damage_range_type_id)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type_id]

	Managers.state.event:trigger("show_shield_icon", player, damage, position)
end

function GameNetworkManager:rpc_show_perk_combat_text(sender, player_id, perk_id, position)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local perk = Perks[NetworkLookup.perks[perk_id]]

	Managers.state.event:trigger("show_perk_text", player, perk.combat_text, position)
end

function GameNetworkManager:rpc_send_perk_combat_text(sender, player_id, perk_id, position)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))

	RPC.rpc_show_perk_combat_text(player:network_id(), player_id, perk_id, position)
end

function GameNetworkManager:rpc_fake_death_activated(sender, player_unit_id)
	local user_unit = self._units[player_unit_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:fake_death_start_time()
end

function GameNetworkManager:rpc_player_collapse(sender, player_unit_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_player_collapse", sender, player_unit_id)
	else
		self:_player_collapse(player_unit_id)
	end
end

function GameNetworkManager:_player_collapse(player_unit_id)
	local user_unit = self._units[player_unit_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	locomotion:player_collapse()
end

function GameNetworkManager:rpc_show_healing_number(sender, health, position)
	local player_manager = Managers.player

	Managers.state.event:trigger("show_healing_number", health, position)
end

function GameNetworkManager:rpc_dev_not_entertained(sender, object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_dev_not_entertained", sender, object_id)
	end

	local unit = self._units[object_id]

	Managers.state.event:trigger("not_entertained", unit)
end

function GameNetworkManager:rpc_arrow_hit_player(sender, user_unit_id, victim_unit_id, hit_zone_id)
	local user_unit = self._units[user_unit_id]
	local victim_unit = self._units[victim_unit_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local victim_damage = Unit.alive(victim_unit) and ScriptUnit.extension(victim_unit, "damage_system")
	local t = Managers.time:time("game")
	local player_manager = Managers.player
	local attacker_player = Managers.player:owner(user_unit)
	local victim_player = Managers.player:owner(victim_unit)

	if victim_damage and not victim_damage:is_dead() and not victim_damage:is_knocked_down() and attacker_player.team ~= victim_player.team and locomotion:has_perk("faster_bow_charge") then
		locomotion.perk_fast_aim_charge.faster_bow_charge.timer = t + Perks.faster_bow_charge.charge_speed_duration

		locomotion:set_perk_state("faster_bow_charge", "active")
	end

	if locomotion:has_perk("light_01") and (hit_zone == "head" or hit_zone == "helmet") then
		locomotion:set_perk_state("light_01", "active")
	end
end

function GameNetworkManager:rpc_hit_with_bow_zoom_longshot(sender, unit_id)
	local unit = self._units[unit_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	locomotion:set_perk_state("bow_zoom", "active")
end

function GameNetworkManager:rpc_tagged_enemy_with_tag_on_bow_shot(sender, unit_id)
	if Managers.lobby.server then
		local unit = self._units[unit_id]
		local owner = Managers.player:owner(unit)

		RPC.rpc_tagged_enemy_with_tag_on_bow_shot(owner:network_id(), unit_id)
	else
		local unit = self._units[unit_id]
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")

		locomotion:set_perk_state("tag_on_bow_shot", "active")
	end
end

function GameNetworkManager:rpc_fire_arrow_hit_shield(sender, unit_id)
	local unit = self._units[unit_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	locomotion:set_perk_state("flaming_arrows", "active")
end

function GameNetworkManager:rpc_horse_dead(sender, mount_object_id, impact_direction)
	local mount = self._units[mount_object_id]
	local horse_locomotion = ScriptUnit.extension(mount, "locomotion_system")
	local horse_damage = ScriptUnit.extension(mount, "damage_system")

	horse_locomotion:rpc_set_dead(impact_direction)
	horse_damage:rpc_set_dead()
end

function GameNetworkManager:rpc_try_kill_owned_horse(sender, mount_object_id)
	local mount = self._units[mount_object_id]

	if Unit.alive(mount) then
		local damage_ext = ScriptUnit.extension(mount, "damage_system")

		if not damage_ext:is_dead() then
			damage_ext:die()
		end
	end
end

function GameNetworkManager:rpc_notify_lobby_joined(sender)
	local is_dedicated = script_data.settings.dedicated_server

	if is_dedicated and Managers.admin:is_player_banned(sender) then
		RPC.rpc_denied_to_enter_game(sender, "banned")
	elseif is_dedicated and Managers.admin:is_server_locked() then
		RPC.rpc_denied_to_enter_game(sender, "locked")
	elseif is_dedicated and not Managers.admin:check_reserved_slots(sender) then
		RPC.rpc_denied_to_enter_game(sender, "reserved_slot")
	else
		local level_key = Managers.lobby:get_lobby_data("level_key")
		local game_mode_key = Managers.lobby:get_lobby_data("game_mode_key")
		local win_score = Managers.lobby:get_lobby_data("win_score")
		local time_limit = Managers.lobby:get_lobby_data("time_limit")

		RPC.rpc_load_level(sender, NetworkLookup.level_keys[level_key], NetworkLookup.game_mode_keys[game_mode_key], self._state:game_start_countdown(), win_score, time_limit)
		RPC.rpc_permission_to_enter_game(sender)
	end
end

function GameNetworkManager:rpc_drop_in(sender, local_id, backend_profile_id, is_demo, anti_cheat_key)
	if self._game then
		printf("GameSession.add_peer(sender)", tostring(sender))
		GameSession.add_peer(self._game, sender)

		self._object_synchronizing_clients[sender] = {
			local_id = local_id,
			backend_profile_id = backend_profile_id,
			is_demo = is_demo,
			anti_cheat_key = anti_cheat_key
		}
	end
end

function GameNetworkManager:game_object_sync_done(remote_id)
	if Managers.lobby.server then
		local player_manager = Managers.player
		local client_data = self._object_synchronizing_clients[remote_id]
		local anti_cheat_key = client_data.anti_cheat_key
		local is_demo = client_data.is_demo
		local backend_profile_id = client_data.backend_profile_id
		local local_id = client_data.local_id

		self._object_synchronizing_clients[remote_id] = nil

		local player = player_manager:add_remote_player(local_id, nil, remote_id, backend_profile_id, is_demo)

		self:_hot_join_synch(remote_id, player)

		local squad_screen, auto_team = Managers.state.game_mode:squad_screen_spawning()
		local skip_team_selection = false

		if not squad_screen then
			Managers.state.team:add_player_to_team_by_side(player, auto_team)
		elseif player.team.name ~= "unassigned" then
			skip_team_selection = true
		end

		if Managers.admin then
			Managers.admin:register_peer(remote_id, anti_cheat_key)
		end

		RPC.rpc_game_started(remote_id, skip_team_selection)
	end
end

function GameNetworkManager:_hot_join_synch(sender, player)
	Managers.state.team:hot_join_synch(sender, player)
	Managers.state.entity_system:hot_join_synch(sender, player)
	Managers.state.spawn:hot_join_synch(sender, player)
	Managers.state.game_mode:hot_join_synch(sender, player)
	Managers.state.loot:hot_join_synch(sender, player)
	Managers.state.trap:hot_join_synch(sender, player)

	if script_data.unlimited_ammo then
		RPC.rpc_toggle_unlimited_ammo(sender, true)
	end

	RPC.rpc_synch_round_time(sender, Managers.time:time("round"), Managers.time:active("round"))
end

function GameNetworkManager:rpc_synch_player_anim_state(sender, game_object_id, ...)
	local unit = self._units[game_object_id]

	Unit.animation_set_state(unit, ...)
end

function GameNetworkManager:rpc_synch_horse_anim_state(sender, game_object_id, ...)
	local unit = self._units[game_object_id]

	Unit.animation_set_state(unit, ...)
end

function GameNetworkManager:rpc_synch_round_time(sender, round_time, active)
	round_time = round_time + Network.ping(sender) / 2

	if not Managers.time:has_timer("round") then
		Managers.time:register_timer("round", "main", round_time)
	else
		Managers.time:set_time("round", round_time)
	end

	Managers.time:set_active("round", active)
end

function GameNetworkManager:rpc_synch_game_mode_time_limit(sender, time_limit)
	Managers.state.game_mode:set_time_limit(time_limit)
end

function GameNetworkManager:rpc_add_player_to_team(sender, player_game_object_id, team_name_id)
	local player_manager = Managers.player
	local team_manager = Managers.state.team

	if script_data.network_debug then
		print("rpc_add_player_to_team() player_game_object_id:", player_game_object_id)
	end

	if not GameSession.game_object_exists(self._game, player_game_object_id) then
		Application.warning("rpc_add_player_to_team - Game object doesn't exist", player_game_object_id)

		return
	end

	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local team_name = NetworkLookup.team[team_name_id]

	team_manager:add_player_to_team_by_name(player, team_name)
end

function GameNetworkManager:rpc_remove_player_from_team(sender, player_game_object_id, team_name_id)
	local player_manager = Managers.player
	local team_manager = Managers.state.team

	if script_data.network_debug then
		print("rpc_remove_player_from_team() player_game_object_id:", player_game_object_id)
	end

	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local team_name = NetworkLookup.team[team_name_id]

	team_manager:remove_player_from_team_by_name(player, team_name)
end

function GameNetworkManager:rpc_move_player_to_team(sender, player_game_object_id, team_name_id)
	local player_manager = Managers.player
	local team_manager = Managers.state.team

	if script_data.network_debug then
		print("rpc_add_player_to_team() player_game_object_id:", player_game_object_id)
	end

	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local team_name = NetworkLookup.team[team_name_id]

	team_manager:move_player_to_team_by_name(player, team_name)
end

function GameNetworkManager:rpc_request_to_join_squad(sender, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local squad = player.team.squads[squad_id]
	local old_squad = player.team.squads[player.squad_index]

	if squad:can_join(player) and (old_squad == nil or old_squad:can_leave(player)) then
		if old_squad then
			old_squad:remove_member(player)
		end

		squad:add_member(player)
	end
end

function GameNetworkManager:rpc_change_squad_animal_index(sender, team_id, squad_id, animal_index)
	local team_name = NetworkLookup.team[team_id]
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team.squads[squad_id]

	squad:set_animal_index(animal_index)

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_change_squad_animal_index", sender, team_id, squad_id, animal_index)
	end
end

function GameNetworkManager:rpc_change_squad_lock_state(sender, team_id, squad_id, locked_state)
	local team_name = NetworkLookup.team[team_id]
	local team = Managers.state.team:team_by_name(team_name)
	local squad = team.squads[squad_id]

	squad:set_squad_lock_state(locked_state)

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_change_squad_lock_state", sender, team_id, squad_id, locked_state)
	end
end

function GameNetworkManager:rpc_request_to_leave_squad(send, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local squad = player.team.squads[squad_id]

	if squad:can_leave(player) then
		squad:remove_member(player)
	end
end

function GameNetworkManager:rpc_set_squad_corporal(sender, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)

	player.team.squads[squad_id]:set_corporal(player)
end

function GameNetworkManager:rpc_set_squad_corporal_coa_hot_sync(sender, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)

	player.team.squads[squad_id]:hot_sync_corporal_coat_of_arms(player, self._game)
end

function GameNetworkManager:rpc_add_player_to_squad(sender, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)

	player.team.squads[squad_id]:add_member(player)
end

function GameNetworkManager:rpc_remove_player_from_squad(sender, player_game_object_id, squad_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)

	player.team.squads[squad_id]:remove_member(player)
end

function GameNetworkManager:rpc_set_max_squad_size(sender, max_squad_size)
	Managers.state.team:team_by_name("red"):set_max_squad_size(max_squad_size)
	Managers.state.team:team_by_name("white"):set_max_squad_size(max_squad_size)
end

function GameNetworkManager:rpc_game_started(sender, skip_team_selection)
	self._game_started = true

	Managers.state.event:trigger("game_started", skip_team_selection)
end

function GameNetworkManager:rpc_request_to_tag_player_unit(sender, player_game_object_id, tagged_player_unit_game_object_id)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local tagged_unit = self._units[tagged_player_unit_game_object_id]
	local tagging_manager = Managers.state.tagging

	if tagging_manager:can_tag_player_unit(player, tagged_unit) then
		tagging_manager:add_player_unit_tag(player, tagged_unit, Managers.time:time("round") + PlayerActionSettings.tagging.duration)

		if Managers.lobby.server then
			self:send_rpc_clients("rpc_tagged_player", self:game_object_id(player.player_unit), tagged_player_unit_game_object_id)
			Managers.state.event:trigger("tagged_player", player.player_unit, tagged_unit)
		end
	end
end

function GameNetworkManager:rpc_request_to_tag_objective(sender, player_game_object_id, tagged_objective_unit_level_index)
	local player_manager = Managers.player
	local player_id = self:temp_player_index(player_game_object_id)
	local player = player_manager:player(player_id)
	local level = LevelHelper:current_level(self._world)
	local tagged_unit = Level.unit_by_index(level, tagged_objective_unit_level_index)
	local tagging_manager = Managers.state.tagging

	if tagging_manager:can_tag_objective(player, tagged_unit) then
		tagging_manager:add_objective_tag(player, tagged_unit, Managers.time:time("round") + PlayerActionSettings.tagging.duration)
	end
end

function GameNetworkManager:rpc_request_knocked_down_help(sender, tagger_unit_id, tagged_unit_id)
	local tagger_unit = self._units[tagger_unit_id]
	local tagged_unit = self._units[tagged_unit_id]
	local player = Managers.player:owner(tagged_unit)

	if player and Managers.lobby.server then
		local player_network_id = player:network_id()

		if Managers.state.tagging:can_tag_player_unit(player, tagged_unit) then
			RPC.rpc_knocked_down_help(player_network_id, tagger_unit_id)
		end
	end
end

function GameNetworkManager:rpc_knocked_down_help(sender, tagger_unit_id)
	local tagger_unit = self._units[tagger_unit_id]

	Managers.state.event:trigger("received_help_request", tagger_unit)
end

function GameNetworkManager:rpc_request_squad_knocked_down_help(sender, tagger_unit_id)
	local tagger_unit = self._units[tagger_unit_id]
	local player = Managers.player:owner(tagger_unit)
	local squad = player.team.squads[player.squad_index]

	if squad then
		local squad_members = squad:members()

		for squad_member, _ in pairs(squad_members) do
			if player ~= squad_member then
				local player_network_id = squad_member:network_id()

				RPC.rpc_knocked_down_help(player_network_id, tagger_unit_id)
			end
		end
	end
end

function GameNetworkManager:rpc_play_particle_effect(sender, effect_id, game_object_id, node_id, offset, rotation_offset, linked)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_play_particle_effect", effect_id, game_object_id, node_id, offset, rotation_offset, linked)
	end

	Managers.state.event:trigger("event_play_particle_effect", NetworkLookup.effects[effect_id], self._units[game_object_id], node_id, offset, rotation_offset, linked)
end

function GameNetworkManager:rpc_output_debug_console_text(sender, text_id, color, display_time)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_output_debug_console_text", sender, text_id, color, display_time)
	end

	Managers.state.hud:output_console_text(L(NetworkLookup.localized_strings[text_id]), color, display_time)
end

function GameNetworkManager:rpc_output_debug_screen_text(sender, text_id, text_size, time, color)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_output_debug_screen_text", sender, text_id, text_size, time, color)
	end

	if time == -1 then
		time = nil
	end

	if text_size == -1 then
		text_size = nil
	end

	Managers.state.debug_text:output_screen_text(L(NetworkLookup.localized_strings[text_id]), text_size, time, color)
end

function GameNetworkManager:rpc_output_debug_unit_text(sender, text_id, text_size, unit_game_object_id, node_index, offset, time, color)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_output_debug_unit_text", sender, text_id, text_size, unit_game_object_id, node_index, offset, time, color)
	end

	local unit = self._units[unit_game_object_id]

	assert(unit, "[GameNetworkManager] Game object ID not found in table self._units")

	if time == -1 then
		time = nil
	end

	if text_size == -1 then
		text_size = nil
	end

	Managers.state.debug_text:clear_unit_text(unit, nil)
	Managers.state.debug_text:output_unit_text(L(NetworkLookup.localized_strings[text_id]), text_size, unit, node_index, offset, time, nil, color)
end

function GameNetworkManager:rpc_output_debug_lvl_unit_text(sender, text_id, text_size, unit_index, node_index, offset, time, color)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_output_debug_lvl_unit_text", sender, text_id, text_size, unit_index, node_index, offset, time, color)
	end

	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_index)

	assert(unit, "[GameNetworkManager] Unit must be spawned statically in level")

	if time == -1 then
		time = nil
	end

	if text_size == -1 then
		text_size = nil
	end

	Managers.state.debug_text:clear_unit_text(unit, nil)
	Managers.state.debug_text:output_unit_text(L(NetworkLookup.localized_strings[text_id]), text_size, unit, node_index, offset, time, nil, color)
end

function GameNetworkManager:rpc_output_debug_world_text(sender, id, text_id, text_size, position, time, color)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_output_debug_world_text", sender, id, text_id, text_size, position, time, color)
	end

	if time == -1 then
		time = nil
	end

	if text_size == -1 then
		text_size = nil
	end

	Managers.state.debug_text:clear_world_text(id)
	Managers.state.debug_text:output_world_text(L(NetworkLookup.localized_strings[text_id]), text_size, position, time, id, color)
end

function GameNetworkManager:rpc_anim_event(sender, anim_id, object_id)
	local unit = self._units[object_id]

	if not unit or not Unit.alive(unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_anim_event", sender, anim_id, object_id)
	end

	local event = NetworkLookup.anims[anim_id]

	assert(event, "[GameNetworkManager] Lookup missing for event_id", anim_id)
	ScriptUnit.extension(unit, "locomotion_system"):rpc_animation_event(event)
end

function GameNetworkManager:rpc_anim_event_variable_float(sender, anim_id, object_id, variable_id, variable_value)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_anim_event_variable_float", sender, anim_id, object_id, variable_id, variable_value)
	end

	local event = NetworkLookup.anims[anim_id]

	assert(event, "[GameNetworkManager] Lookup missing for event_id", anim_id)

	local unit = self._units[object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local variable_name = NetworkLookup.anims[variable_id]
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	locomotion:rpc_animation_set_variable(variable_index, variable_value)
	locomotion:rpc_animation_event(event)
end

function GameNetworkManager:rpc_bow_draw_animation_event(sender, anim_id, object_id, draw_time_id, draw_time, tense_time_id, tense_time, hold_time_id, hold_time)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_bow_draw_animation_event", sender, anim_id, object_id, draw_time_id, draw_time, tense_time_id, tense_time, hold_time_id, hold_time)
	end

	local event = NetworkLookup.anims[anim_id]

	assert(event, "[GameNetworkManager] Lookup missing for event_id", anim_id)

	local unit = self._units[object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local variable_name = NetworkLookup.anims[draw_time_id]
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	locomotion:rpc_animation_set_variable(variable_index, draw_time)

	variable_name = NetworkLookup.anims[tense_time_id]
	variable_index = Unit.animation_find_variable(unit, variable_name)

	locomotion:rpc_animation_set_variable(variable_index, tense_time)

	variable_name = NetworkLookup.anims[hold_time_id]
	variable_index = Unit.animation_find_variable(unit, variable_name)

	locomotion:rpc_animation_set_variable(variable_index, hold_time)
	locomotion:rpc_animation_event(event)
end

function GameNetworkManager:rpc_request_mount(sender, rider_object_id, mount_object_id, player_id)
	local unit = self._units[mount_object_id]
	local player_manager = Managers.player
	local mount_owner = player_manager:owner(unit)

	assert(not mount_owner or mount_owner.temp_random_user_id ~= player_id, "Requesting ownership of already owned mount.")

	if mount_owner or not Unit.alive(unit) or ScriptUnit.extension(unit, "damage_system"):is_dead() then
		RPC.rpc_mount_denied(sender, rider_object_id, mount_object_id)
	else
		self:send_rpc_clients_except("rpc_mounted_husk", sender, rider_object_id, mount_object_id, player_id)

		if sender ~= Network.peer_id() then
			self:rpc_mounted_husk(Network.peer_id(), rider_object_id, mount_object_id, player_id)
		end

		if self._owners[mount_object_id] ~= sender then
			GameSession.migrate_game_object(self._game, mount_object_id, sender, self)
			RPC.rpc_mount_confirmed(sender, rider_object_id, mount_object_id)

			self._owners[mount_object_id] = sender
		elseif sender == Network.peer_id() then
			self:rpc_mount_confirmed(sender, rider_object_id, mount_object_id)
		else
			RPC.rpc_mount_confirmed(sender, rider_object_id, mount_object_id)
		end
	end
end

function GameNetworkManager:rpc_kicked(sender, msg)
	Managers.state.event:trigger("kicked_from_game", msg)
	self:leave_game()
end

function GameNetworkManager:rpc_unmount(sender, rider_object_id, mount_object_id)
	local rider = self._units[rider_object_id]
	local mount = self._units[mount_object_id]

	Unit.set_data(mount, "user_unit", nil)
	ScriptUnit.extension(rider, "locomotion_system"):rpc_unmount(mount)
end

function GameNetworkManager:rpc_unmounted_husk(sender, rider_object_id, mount_object_id)
	local rider = self._units[rider_object_id]
	local mount = self._units[mount_object_id]

	Unit.set_data(mount, "user_unit", nil)
	Managers.player:relinquish_unit_ownership(mount)

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_unmounted_husk", sender, rider_object_id, mount_object_id)
	end

	ScriptUnit.extension(rider, "locomotion_system"):set_mounted()
end

function GameNetworkManager:rpc_mounted_husk(sender, rider_object_id, mount_object_id, player_id)
	local rider = self._units[rider_object_id]
	local mount = self._units[mount_object_id]

	Unit.set_data(mount, "user_unit", rider)
	Managers.player:assign_unit_ownership(mount, player_id)
	ScriptUnit.extension(rider, "locomotion_system"):set_mounted(mount)
end

function GameNetworkManager:rpc_mount_confirmed(sender, rider_object_id, mount_object_id)
	local rider = self._units[rider_object_id]
	local mount = self._units[mount_object_id]

	if not Unit.alive(mount) then
		return
	end

	Unit.set_data(mount, "user_unit", rider)
	Managers.player:assign_unit_ownership(mount, Unit.get_data(rider, "owner_player_index"))
end

function GameNetworkManager:rpc_mount_denied(sender, rider_object_id, mount_object_id)
	local rider = self._units[rider_object_id]
	local mount = self._units[mount_object_id]

	if Unit.alive(rider) then
		local locomotion_ext = ScriptUnit.extension(rider, "locomotion_system")

		locomotion_ext:rpc_mount_denied(mount_object_id, Unit.alive(mount) and mount)
	end
end

function GameNetworkManager:rpc_ready_projectile(sender, game_object_id, slot_name, projectile_name)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_ready_projectile", sender, game_object_id, slot_name, projectile_name)
	end

	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	if locomotion.IsHusk() then
		return
	end

	local inventory = locomotion:inventory()
	local gear = inventory:gear(NetworkLookup.inventory_slots[slot_name])
	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:ready_projectile(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_release_projectile(sender, game_object_id, slot_name)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_release_projectile", sender, game_object_id, slot_name)
	end

	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	if locomotion.IsHusk() then
		return
	end

	local inventory = locomotion:inventory()
	local gear = inventory:gear(NetworkLookup.inventory_slots[slot_name])
	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:release_projectile(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_spawn_projectile(sender, player_index, user_obj_id, weapon_object_id, projectile_name_id, gear_name_id, position, exit_velocity, gravity_multiplier, charge_value, properties_id, faster_bow_charge_active)
	local user_unit = self._units[user_obj_id]
	local weapon_unit = self._units[weapon_object_id]

	if not user_unit or not weapon_unit then
		return
	end

	local game = self._game

	if script_data.projectile_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "script_data.projectile_debug"
		})

		drawer:sphere(position, 0.05, Color(0, 255, 0))
	end

	Managers.state.projectile:spawn_projectile(player_index, user_unit, weapon_unit, projectile_name_id, gear_name_id, position, exit_velocity, gravity_multiplier, charge_value, properties_id, faster_bow_charge_active)
end

function GameNetworkManager:rpc_spawn_thrown_projectile(sender, player_index, gear_name_id, position, rotation, exit_velocity, user_obj_id)
	local user_unit = self._units[user_obj_id]

	if not user_unit then
		return
	end

	local game = self._game

	Managers.state.projectile:spawn_thrown_projectile(player_index, gear_name_id, position, rotation, exit_velocity, user_unit)
end

function GameNetworkManager:create_projectile_game_object(player_index, user_unit, weapon_unit, projectile_name_id, gear_name_id, position, exit_velocity, gravity_multiplier, charge_value, properties_id, projectile_unit_name, unit)
	local data_table = {
		husk_unit = NetworkLookup.husks[projectile_unit_name],
		position = position,
		projectile_name_id = projectile_name_id,
		gear_name_id = gear_name_id,
		exit_velocity = exit_velocity,
		user_object_id = self:game_object_id(user_unit),
		weapon_object_id = self:game_object_id(weapon_unit),
		gravity_multiplier = gravity_multiplier,
		charge_value = charge_value,
		properties_id = properties_id,
		player_index = player_index,
		game_object_created_func = NetworkLookup.game_object_functions.cb_spawn_projectile,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		object_destroy_func = NetworkLookup.game_object_functions.cb_projectile_game_object_destroyed
	}
	local callback = callback(self, "cb_projectile_game_session_disconnect", unit)
	local obj_id = self:create_game_object("projectile_unit", data_table, callback)

	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)
	Unit.set_data(unit, "user_unit", user_unit)
end

function GameNetworkManager:create_thrown_projectile_game_object(unit, gear_name, exit_velocity, user_unit, player_index)
	local data_table = {
		extension_destroyed = false,
		gear_name_id = NetworkLookup.gear_names[gear_name],
		position = Unit.local_position(unit, 0),
		rotation = Unit.local_rotation(unit, 0),
		exit_velocity = exit_velocity,
		user_object_id = self:game_object_id(user_unit),
		player_index = player_index,
		game_object_created_func = NetworkLookup.game_object_functions.cb_spawn_thrown_projectile,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		object_destroy_func = NetworkLookup.game_object_functions.cb_thrown_projectile_game_object_destroyed
	}
	local callback = callback(self, "cb_thrown_projectile_game_session_disconnect", unit)
	local obj_id = self:create_game_object("thrown_projectile_unit", data_table, callback)

	self._units[obj_id] = unit
	self._owners[obj_id] = Network.peer_id()

	Unit.set_data(unit, "game_object_id", obj_id)
end

function GameNetworkManager:cb_spawn_thrown_projectile(obj_id, owner_id)
	local game = self._game
	local position = GameSession.game_object_field(game, obj_id, "position")
	local rotation = GameSession.game_object_field(game, obj_id, "rotation")
	local gear_name = NetworkLookup.inventory_gear[GameSession.game_object_field(game, obj_id, "gear_name_id")]
	local exit_velocity = GameSession.game_object_field(game, obj_id, "exit_velocity")
	local player_index = GameSession.game_object_field(game, obj_id, "player_index")
	local user_object_id = GameSession.game_object_field(game, obj_id, "user_object_id")
	local user_unit = self._units[user_object_id]
	local unit = World.spawn_unit(self._world, Gear[gear_name].unit, position, rotation)

	self._units[obj_id] = unit
	self._owners[obj_id] = owner_id

	Unit.set_data(unit, "game_object_id", obj_id)

	local extension_index = 1

	while Unit.has_data(unit, extension_index) do
		Unit.set_data(unit, extension_index, nil)

		extension_index = extension_index + 1
	end

	Unit.set_data(unit, "gear_extensions", nil)
	Unit.set_data(unit, "extensions", 0, "ThrownProjectile")

	local ext_destroyed = GameSession.game_object_field(game, obj_id, "extension_destroyed")

	if ext_destroyed then
		Unit.set_data(unit, "gear_name", gear_name)

		local actor_index = Unit.find_actor(unit, "thrown")

		Unit.create_actor(unit, actor_index, 0)
	else
		player_index = self:temp_player_index(player_index)

		Managers.state.entity:register_unit(self._world, unit, player_index, exit_velocity, gear_name, user_unit, true)
	end
end

function GameNetworkManager:temp_player_index(player_id)
	local player_manager = Managers.player
	local players = player_manager:players()
	local max_players = player_manager.MAX_PLAYERS

	for player_index = 1, max_players do
		if player_manager:player_exists(player_index) then
			local player = player_manager:player(player_index)

			if player.temp_random_user_id == player_id then
				return player_index
			end
		end
	end

	if player_manager:player_exists("York") then
		local player = player_manager:player("York")

		if player.temp_random_user_id == player_id then
			return "York"
		end
	end

	if player_manager:player_exists("Lancaster") then
		local player = player_manager:player("Lancaster")

		if player.temp_random_user_id == player_id then
			return "Lancaster"
		end
	end

	for player_index, player in pairs(players) do
		if player.temp_random_user_id == player_id then
			return player_index
		end
	end

	return player_id
end

function GameNetworkManager:cb_projectile_game_session_disconnect(projectile_unit)
	Managers.state.entity:unregister_unit(projectile_unit)
	World.destroy_unit(self._world, projectile_unit)
end

function GameNetworkManager:cb_thrown_projectile_game_session_disconnect(projectile_unit)
	if Unit.alive(projectile_unit) and Managers.state.entity:is_unit_registered(projectile_unit) then
		Managers.state.entity:unregister_unit(projectile_unit)
		World.destroy_unit(self._world, projectile_unit)
	end
end

function GameNetworkManager:rpc_set_gear_wielded(sender, game_object_id, slot_name, wielded, ignore_sound, dual_wielding)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_set_gear_wielded", sender, game_object_id, slot_name, wielded, ignore_sound, dual_wielding)
	end

	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local inventory = locomotion:inventory()

	inventory:set_gear_wielded(NetworkLookup.inventory_slots[slot_name], wielded, ignore_sound, dual_wielding)
end

function GameNetworkManager:rpc_set_gear_sheathed(sender, game_object_id, slot_name, sheathed, ignore_sound, dual_wielding)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_set_gear_sheathed", sender, game_object_id, slot_name, sheathed, ignore_sound, dual_wielding)
	end

	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local inventory = locomotion:inventory()

	inventory:set_gear_sheathed(NetworkLookup.inventory_slots[slot_name], sheathed, ignore_sound, dual_wielding)
end

function GameNetworkManager:rpc_sheathe_wielded_weapon(sender, game_object_id, slot_name)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_sheathe_wielded_weapon", sender, game_object_id, slot_name)
	end

	local unit = self._units[game_object_id]
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local inventory = locomotion:inventory()

	inventory:sheathe_wielded_weapon(NetworkLookup.inventory_slots[slot_name])
end

function GameNetworkManager:rpc_player_point_spawned(sender, player_id, spawn_point_level_id, spawn_confirmation_time)
	local level = LevelHelper:current_level(self._world)
	local spawn_point_unit = Level.unit_by_index(level, spawn_point_level_id)
	local player = Managers.player:player(self:temp_player_index(player_id))

	Managers.state.spawn:rpc_player_point_spawned(player, spawn_point_unit, spawn_confirmation_time)
end

function GameNetworkManager:rpc_add_damage(sender, attacker_player_id, attacker_game_object_id, victim_game_object_id, damage_type, damage, position, normal, damage_range_type, gear_name_id, attack_name_id, hit_zone_id, impact_direction, real_damage, range, riposte)
	local victim_unit = self._units[victim_game_object_id]

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if ScriptUnit.has_extension(victim_unit, "damage_system") then
		self:_apply_damage(attacker_player_id, attacker_game_object_id, victim_unit, damage_type, damage, position, normal, damage_range_type, gear_name_id, attack_name_id, hit_zone_id, impact_direction, real_damage, range, riposte)
	end
end

function GameNetworkManager:rpc_start_melee_attack(sender, player_unit_id, gear_unit_id, attack_index, attack_time, charge_factor, riposte)
	self:_start_melee_attack(player_unit_id, gear_unit_id, attack_index, attack_time, charge_factor, riposte)
end

function GameNetworkManager:_start_melee_attack(player_unit_id, gear_unit_id, attack_index, attack_time, charge_factor, riposte)
	local player_unit = self._units[player_unit_id]
	local gear_unit = self._units[gear_unit_id]
	local weapon_gear_name = Unit.get_data(gear_unit, "gear_name")
	local gear_settings = Gear[weapon_gear_name]
	local attack_name = NetworkLookup.attack_names[attack_index]

	if not attack_name then
		printf("ERROR: attack_name does not have an index in NetworkLookup!")
	end

	local attack_settings = gear_settings.attacks[attack_name]
	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")
	local inventory = locomotion:inventory()
	local gear = inventory:find_gear_by_unit(gear_unit)

	assert(gear ~= nil, "Err! gear is nil!")

	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	gear:start_melee_attack(charge_factor, attack_name, attack_settings, nil, attack_time, attack_settings.abort_on_hit, riposte)
end

function GameNetworkManager:rpc_abort_melee_attack(sender, player_unit_id)
	self:_abort_melee_attack(player_unit_id)
end

function GameNetworkManager:_abort_melee_attack(player_unit_id)
	local player_unit = self._units[player_unit_id]
	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")

	locomotion:abort_attack()
end

function GameNetworkManager:rpc_add_generic_damage(sender, attacker_player_id, attacker_game_object_id, victim_level_object_id, damage_type, damage, position, normal, damage_range_type, gear_name_id, attack_name_id, hit_zone_id, impact_direction)
	local level = LevelHelper:current_level(self._world)
	local victim_unit = Level.unit_by_index(level, victim_level_object_id)

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if ScriptUnit.has_extension(victim_unit, "damage_system") then
		self:_apply_damage(attacker_player_id, attacker_game_object_id, victim_unit, damage_type, damage, position, normal, damage_range_type, gear_name_id, attack_name_id, hit_zone_id, impact_direction)
	end
end

function GameNetworkManager:rpc_add_generic_heal(sender, heal, player_unit_id)
	local player_unit = self._units[player_unit_id]

	if not player_unit or not Unit.alive(player_unit) then
		return
	end

	if ScriptUnit.has_extension(player_unit, "damage_system") then
		local damage_ext = ScriptUnit.extension(player_unit, "damage_system")

		damage_ext:apply_healing(heal)
	end
end

function GameNetworkManager:rpc_add_damage_over_time(sender, attacker_player_id, victim_game_object_id, damage_type)
	local victim_unit = self._units[victim_game_object_id]

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if ScriptUnit.has_extension(victim_unit, "damage_system") then
		local attacker = Managers.player:player(self:temp_player_index(attacker_player_id))
		local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")

		damage_extension:network_recieve_add_damage_over_time(attacker, NetworkLookup.damage_over_time_types[damage_type])
	end
end

function GameNetworkManager:rpc_add_custom_damage_over_time(sender, attacker_player_id, victim_game_object_id, damage_type, duration, dps)
	local victim_unit = self._units[victim_game_object_id]

	if not victim_unit or not Unit.alive(victim_unit) then
		return
	end

	if ScriptUnit.has_extension(victim_unit, "damage_system") then
		local attacker = Managers.player:player(self:temp_player_index(attacker_player_id))
		local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")

		damage_extension:network_recieve_add_custom_damage_over_time(attacker, NetworkLookup.damage_over_time_types[damage_type], duration, dps)
	end
end

function GameNetworkManager:_apply_damage(attacker_player_id, attacker_game_object_id, victim_unit, damage_type, damage, position, normal, damage_range_type, gear_name_id, attack_name_id, hit_zone_id, impact_direction, real_damage, range, riposte)
	local attacker = Managers.player:player(self:temp_player_index(attacker_player_id))
	local attacker_unit = self._units[attacker_game_object_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type]
	local friendly_fire_multiplier = 1 --Managers.state.team:friendly_fire_multiplier(attacker_unit, victim_unit, damage_range_type)
	local damage = friendly_fire_multiplier * damage
	local mirrored = false
	local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")
	local is_on_same_team = Managers.state.team:is_on_same_team(attacker_unit, victim_unit)
	local mirror_damage = AttackDamageRangeTypes[damage_range_type].mirrored
	local is_alive = damage_extension:is_alive()
	local attack_name = NetworkLookup.weapon_hit_parameters[attack_name_id]

	if attack_name == "nil" then
		-- block empty
	end
--[[
	if is_on_same_team and mirror_damage and is_alive then
		mirrored = true
		attacker_unit, victim_unit = victim_unit, attacker_unit
		damage_extension = ScriptUnit.extension(victim_unit, "damage_system")
	end
--]]
	damage_extension:network_recieve_add_damage(attacker, attacker_unit, NetworkLookup.damage_types[damage_type], damage, position, normal, damage_range_type, NetworkLookup.gear_names[gear_name_id], attack_name, NetworkLookup.hit_zones[hit_zone_id], impact_direction, real_damage or damage, range, riposte, mirrored)
end

function GameNetworkManager:rpc_trigger_request(sender, player_unit_id, interactable_unit_id)
	local player_unit = self._units[player_unit_id]
	local player = Managers.player:owner(player_unit)
	local side = player.team.side
	local current_level = LevelHelper:current_level(self._world)
	local interactable_unit = Level.unit_by_index(current_level, interactable_unit_id)
	local extension = ScriptUnit.extension(interactable_unit, "objective_system")

	if extension:active(side) and not extension:interactor() and extension:can_interact(player) then
		InteractionHelper:confirm_request("trigger", sender, player_unit_id)
		extension:set_interactor(player_unit_id)
	else
		InteractionHelper:deny_request("trigger", sender, player_unit_id)
	end
end

function GameNetworkManager:rpc_trigger_confirmed(sender, player_unit_id)
	local player_unit = self._units[player_unit_id]
	local extension = ScriptUnit.extension(player_unit, "locomotion_system")

	InteractionHelper:confirmed("trigger", extension)
end

function GameNetworkManager:rpc_trigger_denied(sender, player_unit_id)
	local player_unit = self._units[player_unit_id]
	local extension = ScriptUnit.extension(player_unit, "locomotion_system")

	InteractionHelper:denied("trigger", extension)
end

function GameNetworkManager:rpc_trigger_abort(sender, player_unit_id, interactable_unit_id)
	local current_level = LevelHelper:current_level(self._world)
	local interactable_unit = Level.unit_by_index(current_level, interactable_unit_id)
	local extension = ScriptUnit.extension(interactable_unit, "objective_system")

	if extension:interactor() == player_unit_id then
		extension:set_interactor(nil)
	end
end

function GameNetworkManager:rpc_trigger_complete(sender, player_unit_id, interactable_unit_id)
	local player_unit = self._units[player_unit_id]
	local current_level = LevelHelper:current_level(self._world)
	local interactable_unit = Level.unit_by_index(current_level, interactable_unit_id)
	local player = Managers.player:owner(player_unit)
	local interactable_name = Unit.get_data(interactable_unit, "interact_settings", "name")
	local event_name = player.team.side .. "_" .. interactable_name .. "_triggered"
	local extension = ScriptUnit.extension(interactable_unit, "objective_system")

	if extension:interactor() ~= player_unit_id then
		return
	end

	extension:interaction_complete(player)

	if Managers.lobby.server then
		Unit.flow_event(interactable_unit, event_name .. "_server")
		self:send_rpc_clients("rpc_trigger_complete", player_unit_id, interactable_unit_id)
		extension:set_interactor(nil)
	end

	Unit.flow_event(interactable_unit, event_name)
end

function GameNetworkManager:rpc_client_player_damaged(sender, player_id, attacking_player_id, damage, gear_id, hit_zone_id, damage_range_type_id, range, mirrored)
	local player = Managers.player:player(self:temp_player_index(player_id))
	local attacking_player = Managers.player:player(self:temp_player_index(attacking_player_id))
	local gear_name = NetworkLookup.gear_names[gear_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type_id]

	Managers.state.event:trigger("client_player_damaged", player, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)
end

function GameNetworkManager:rpc_bandage_request(sender, bandager_id, bandagee_id)
	local bandagee_unit = self._units[bandagee_id]
	local bandager_unit = self._units[bandager_id]

	if bandagee_unit and Unit.alive(bandagee_unit) and bandager_unit and Unit.alive(bandager_unit) then
		local damage_ext = ScriptUnit.extension(bandagee_unit, "damage_system")
		local can_be_bandaged = bandagee_unit == bandager_unit and damage_ext:can_be_self_bandaged() or damage_ext:can_be_team_bandaged()

		if can_be_bandaged then
			InteractionHelper:confirm_request("bandage", sender, bandager_id)
			damage_ext:start_bandage(bandager_id, bandagee_id)

			return
		end
	end

	InteractionHelper:deny_request("bandage", sender, bandager_id)
end

function GameNetworkManager:rpc_bandage_denied(sender, bandager_id)
	local bandager_unit = self._units[bandager_id]

	InteractionHelper:denied("bandage", ScriptUnit.extension(bandager_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_bandage_confirmed(sender, bandager_id)
	local bandager_unit = self._units[bandager_id]

	InteractionHelper:confirmed("bandage", ScriptUnit.extension(bandager_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_bandage_abort(sender, bandager_id, bandagee_id)
	local bandagee_unit = self._units[bandagee_id]

	if bandagee_unit and Unit.alive(bandagee_unit) then
		local damage_ext = ScriptUnit.extension(bandagee_unit, "damage_system")

		damage_ext:abort_bandage(bandager_id, bandagee_id)
	end
end

function GameNetworkManager:rpc_revive_yourself_request(sender, player_id)
	local player_unit = self._units[player_id]

	if player_unit and Unit.alive(player_unit) then
		local damage_ext = ScriptUnit.extension(player_unit, "damage_system")
		local can_be_revived = damage_ext:can_be_revived()

		if can_be_revived then
			InteractionHelper:confirm_request("revive_yourself", sender, player_id)
			damage_ext:start_revive(player_id, player_id, true)

			return
		end
	end

	InteractionHelper:deny_request("revive_yourself", sender, player_id)
end

function GameNetworkManager:rpc_revive_yourself_confirmed(sender, reviver_id)
	local reviver_unit = self._units[reviver_id]

	InteractionHelper:confirmed("revive_yourself", ScriptUnit.extension(reviver_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_revive_yourself_denied(sender, reviver_id)
	local reviver_unit = self._units[reviver_id]

	InteractionHelper:denied("revive_yourself", ScriptUnit.extension(reviver_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_completed_revive_yourself(sender, reviver_id)
	local revivee_unit = self._units[reviver_id]

	if revivee_unit and Unit.alive(revivee_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")

		damage_ext:completed_revive()
	end
end

function GameNetworkManager:rpc_revive_request(sender, reviver_id, revivee_id)
	local revivee_unit = self._units[revivee_id]
	local reviver_unit = self._units[reviver_id]

	if revivee_unit and Unit.alive(revivee_unit) and reviver_unit and Unit.alive(reviver_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")
		local can_be_revived = damage_ext:can_be_revived()

		if can_be_revived then
			InteractionHelper:confirm_request("revive", sender, reviver_id)
			damage_ext:start_revive(reviver_id, revivee_id)

			return
		end
	end

	InteractionHelper:deny_request("revive", sender, reviver_id)
end

function GameNetworkManager:rpc_revive_denied(sender, reviver_id)
	local reviver_unit = self._units[reviver_id]

	InteractionHelper:denied("revive", ScriptUnit.extension(reviver_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_revive_confirmed(sender, reviver_id)
	local reviver_unit = self._units[reviver_id]

	InteractionHelper:confirmed("revive", ScriptUnit.extension(reviver_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_revive_abort(sender, reviver_id, revivee_id)
	local revivee_unit = self._units[revivee_id]

	if revivee_unit and Unit.alive(revivee_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")

		damage_ext:abort_revive(reviver_id, revivee_id)
	end
end

function GameNetworkManager:rpc_abort_revive_teammate(sender, reviver_id, revivee_id)
	local revivee_unit = self._units[revivee_id]

	if revivee_unit and Unit.alive(revivee_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")

		damage_ext:abort_revive(reviver_id, revivee_id)
	end
end

function GameNetworkManager:rpc_completed_revive(sender, revivee_id)
	local revivee_unit = self._units[revivee_id]

	if revivee_unit and Unit.alive(revivee_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")

		damage_ext:completed_revive()
	end
end

function GameNetworkManager:rpc_bandage_completed_client(sender, bandagee_id)
	local bandagee_unit = self._units[bandagee_id]

	if bandagee_unit and Unit.alive(bandagee_unit) then
		local damage_ext = ScriptUnit.extension(bandagee_unit, "damage_system")

		damage_ext:rpc_bandage_completed_client(bandagee_unit)
	end
end

function GameNetworkManager:rpc_start_revive_teammate(sender, reviver_id, revivee_id)
	local revivee_unit = self._units[revivee_id]
	local reviver_unit = self._units[reviver_id]

	if revivee_unit and Unit.alive(revivee_unit) and reviver_unit and Unit.alive(reviver_unit) then
		local damage_ext = ScriptUnit.extension(revivee_unit, "damage_system")

		damage_ext:start_revive(reviver_id, revivee_id)
	end
end

function GameNetworkManager:rpc_request_flag_spawn(sender, picker_id, objective_index)
	local picker_unit = self._units[picker_id]
	local current_level = LevelHelper:current_level(self._world)
	local objective_unit = Level.unit_by_index(current_level, objective_index)

	if picker_unit and Unit.alive(picker_unit) and objective_unit and Unit.alive(objective_unit) then
		local objective_ext = ScriptUnit.extension(objective_unit, "objective_system")

		if objective_ext:can_spawn_flag(picker_unit) then
			local flag = objective_ext:spawn_flag(picker_unit)
			local flag_ext = ScriptUnit.extension(flag, "flag_system")

			flag_ext:pickup(picker_unit)

			local locomotion_ext = ScriptUnit.extension(picker_unit, "locomotion_system")

			locomotion_ext:rpc_flag_pickup_confirmed(flag)

			local flag_id = self:unit_game_object_id(flag)

			self:send_rpc_clients("rpc_flag_pickup_confirmed", picker_id, flag_id)

			return
		end
	end

	RPC.rpc_flag_pickup_denied(sender, picker_id)
end

function GameNetworkManager:rpc_request_flag_pickup(sender, picker_id, flag_id)
	local flag_unit = self._units[flag_id]
	local picker_unit = self._units[picker_id]

	if picker_unit and Unit.alive(picker_unit) and flag_unit and Unit.alive(flag_unit) then
		local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

		if flag_ext:can_be_picked_up(picker_unit) then
			flag_ext:pickup(picker_unit)

			local locomotion_ext = ScriptUnit.extension(picker_unit, "locomotion_system")

			locomotion_ext:rpc_flag_pickup_confirmed(flag_unit)
			self:send_rpc_clients("rpc_flag_pickup_confirmed", picker_id, flag_id)

			return
		end
	end

	RPC.rpc_flag_pickup_denied(sender, picker_id)
end

function GameNetworkManager:rpc_flag_pickup_confirmed(sender, picker_id, flag_id)
	local flag_unit = self._units[flag_id]
	local picker_unit = self._units[picker_id]
	local locomotion = ScriptUnit.extension(picker_unit, "locomotion_system")

	locomotion:rpc_flag_pickup_confirmed(flag_unit)

	local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

	flag_ext:pickup(picker_unit)
end

function GameNetworkManager:rpc_flag_pickup_denied(sender, picker_id)
	local picker_unit = self._units[picker_id]
	local locomotion = ScriptUnit.extension(picker_unit, "locomotion_system")

	locomotion:rpc_flag_pickup_denied()
end

function GameNetworkManager:rpc_request_flag_plant(sender, planter_id, flag_id, objective_index)
	local planter_unit = self._units[planter_id]
	local flag_unit = self._units[flag_id]
	local level = LevelHelper:current_level(self._world)
	local objective_unit = Level.unit_by_index(level, objective_index)

	if planter_unit and Unit.alive(planter_unit) and flag_unit and Unit.alive(flag_unit) and objective_unit and Unit.alive(objective_unit) then
		local objective_ext = ScriptUnit.extension(objective_unit, "objective_system")
		local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

		if objective_ext:can_plant_flag(planter_unit) and flag_ext:can_be_dropped(planter_unit) then
			objective_ext:set_current_planter(planter_unit)
			RPC.rpc_flag_plant_confirmed(sender, planter_id)

			return
		end
	end

	RPC.rpc_flag_plant_denied(sender, planter_id)
end

function GameNetworkManager:rpc_flag_plant_denied(sender, planter_id)
	local planter_unit = self._units[planter_id]
	local locomotion = ScriptUnit.extension(planter_unit, "locomotion_system")

	locomotion:rpc_flag_plant_denied()
end

function GameNetworkManager:rpc_flag_plant_confirmed(sender, picker_id)
	local picker_unit = self._units[picker_id]
	local locomotion = ScriptUnit.extension(picker_unit, "locomotion_system")

	locomotion:rpc_flag_plant_confirmed()
end

function GameNetworkManager:rpc_flag_plant_complete(sender, planter_id, flag_id, objective_index)
	local planter_unit = self._units[planter_id]
	local flag_unit = self._units[flag_id]
	local objective_unit = Level.unit_by_index(ScriptWorld.level(self._world, LevelSettings[Managers.state.game_mode:level_key()].level_name), objective_index)

	if planter_unit and Unit.alive(planter_unit) and flag_unit and Unit.alive(flag_unit) and objective_unit and Unit.alive(objective_unit) then
		local objective_ext = ScriptUnit.extension(objective_unit, "objective_system")

		objective_ext:plant_flag(planter_unit)

		local locomotion_ext = ScriptUnit.extension(planter_unit, "locomotion_system")

		locomotion_ext:rpc_flag_plant_complete(flag_unit)

		local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

		flag_ext:die()
	end
end

function GameNetworkManager:rpc_flag_plant_fail(sender, planter_id, objective_index)
	local level = LevelHelper:current_level(self._world)
	local objective_unit = Level.unit_by_index(level, objective_index)

	if objective_unit and Unit.alive(objective_unit) then
		local objective_ext = ScriptUnit.extension(objective_unit, "objective_system")

		objective_ext:set_current_planter(nil)
	end
end

function GameNetworkManager:rpc_drop_flag(sender, dropper_id, flag_id)
	local flag_unit = self._units[flag_id]
	local dropper_unit = self._units[dropper_id]

	if flag_unit and Unit.alive(flag_unit) and dropper_unit and Unit.alive(dropper_unit) then
		local locomotion_ext = ScriptUnit.extension(dropper_unit, "locomotion_system")

		locomotion_ext:rpc_drop_flag(flag_unit)

		if Managers.lobby.server then
			self:send_rpc_clients_except("rpc_drop_flag", sender, dropper_id, flag_id)
		end
	end
end

function GameNetworkManager:rpc_wpn_impact_char_no_pos_norm(sender, hit_unit_game_object_id, self_gear_game_object_id, target_type_id, direction_id, stun, damage, damage_without_armour, hit_zone_id, impact_direction, interrupt)
	local character_unit = self._units[hit_unit_game_object_id]
	local gear_unit = self._units[self_gear_game_object_id]

	if not character_unit or not gear_unit then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_wpn_impact_char_no_pos_norm", sender, hit_unit_game_object_id, self_gear_game_object_id, target_type_id, direction_id, stun, damage, damage_without_armour, hit_zone_id, impact_direction)
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]
	local direction = NetworkLookup.weapon_hit_parameters[direction_id]

	WeaponHelper:weapon_impact_character(character_unit, gear_unit, target_type, direction, stun, damage, damage_without_armour, nil, nil, self._world, NetworkLookup.hit_zones[hit_zone_id], impact_direction, interrupt)
end

function GameNetworkManager:rpc_weapon_impact_character(sender, hit_unit_game_object_id, self_gear_game_object_id, target_type_id, direction_id, stun, damage, damage_without_armour, hit_zone_id, position, normal, impact_direction, weapon_damage_direction, interrupt, actor_index)
	local character_unit = self._units[hit_unit_game_object_id]
	local gear_unit = self._units[self_gear_game_object_id]

	if not character_unit or not gear_unit or not ScriptUnit.has_extension(character_unit, "damage_system") or ScriptUnit.extension(character_unit, "damage_system"):is_dead() then
		return
	end

	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]
	local direction = NetworkLookup.weapon_hit_parameters[direction_id]
	local actor = Unit.actor(character_unit, actor_index)

	WeaponHelper:weapon_impact_character(character_unit, gear_unit, target_type, direction, stun, damage, damage_without_armour, position, normal, self._world, NetworkLookup.hit_zones[hit_zone_id], impact_direction, weapon_damage_direction, interrupt, actor)
end

function GameNetworkManager:_is_owner_local(gear_unit)
	local owner_unit = Unit.get_data(gear_unit, "user_unit")
	local owner_player = Managers.player:owner(owner_unit)
	local local_player = self:player_from_peer_id(Network.peer_id())

	return owner_player == local_player
end

function GameNetworkManager:rpc_finish_off_blood(sender, game_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_finish_off_blood", sender, game_object_id)
	end

	local character_unit = self._units[game_object_id]

	Managers.state.event:trigger("finish_off_blood", character_unit)
end

function GameNetworkManager:rpc_add_instakill_push(sender, game_object_id, velocity, mass, hit_zone_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_add_instakill_push", sender, game_object_id, velocity, mass, hit_zone_id)
	end

	if sender ~= Network.peer_id() then
		local hit_zone_name = NetworkLookup.hit_zones[hit_zone_id]
		local unit = self._units[game_object_id]
		local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_ext:rpc_add_instakill_push(velocity, mass, hit_zone_name)
	end
end

function GameNetworkManager:rpc_mount_impact_character(sender, mount_id, victim_id, damage, position, normal, impulse)
	local mount_unit = self._units[mount_id]
	local victim_unit = self._units[victim_id]

	if mount_unit then
		ScriptUnit.extension(mount_unit, "locomotion_system"):impact_obstacle()
	end

	if victim_unit then
		WeaponHelper:mount_impact_character(victim_unit, damage, position, normal, self._world, "mount_impact", impulse)
	end
end

function GameNetworkManager:rpc_shield_impact_character(sender, shield_unit_id, victim_id, damage, position, normal, hit_zone_id, impact_direction)
	local shield_unit = self._units[shield_unit_id]
	local victim_unit = self._units[victim_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]

	if not shield_unit or not victim_unit then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_shield_impact_character", sender, shield_unit_id, victim_id, damage, position, normal, hit_zone_id, impact_direction)
	end

	WeaponHelper:shield_impact_character(victim_unit, damage, position, normal, self._world, hit_zone, impact_direction)
end

function GameNetworkManager:rpc_push_impact_character(sender, victim_id, position, normal, impact_direction, scaled)
	local victim_unit = self._units[victim_id]

	if not victim_unit then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_push_impact_character", sender, victim_id, position, normal, impact_direction, scaled)
	end

	WeaponHelper:push_impact_character(victim_unit, position, normal, self._world, impact_direction, scaled)
end

function GameNetworkManager:rpc_pommel_bash_impact_character(sender, victim_id, position, normal, hit_zone, impact_direction)
	local victim_unit = self._units[victim_id]
	local victim_player = Managers.player:owner(victim_unit)

	if Managers.lobby.server and victim_player.remote then
		local damage = Unit.alive(victim_unit) and ScriptUnit.has_extension(victim_unit, "damage_system") and ScriptUnit.extension(victim_unit, "damage_system")

		if damage and not damage:is_knocked_down() and not damage:is_dead() then
			RPC.rpc_pommel_bash_impact_character(victim_player:network_id(), victim_id, position, normal, hit_zone, impact_direction)
		end
	elseif Unit.alive(victim_unit) then
		local locomotion = ScriptUnit.has_extension(victim_unit, "locomotion_system") and ScriptUnit.extension(victim_unit, "locomotion_system")

		if locomotion then
			locomotion:pommel_bash_interrupt(hit_zone, impact_direction)
		end
	end
end

function GameNetworkManager:rpc_rush_impact_character(sender, attacking_unit_id, victim_id, position, normal, impact_direction)
	local attacking_unit = self._units[attacking_unit_id]
	local victim_unit = self._units[victim_id]

	if not attacking_unit or not victim_unit then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_rush_impact_character", sender, attacking_unit_id, victim_id, position, normal, impact_direction)
	end

	WeaponHelper:rush_impact_character(victim_unit, position, normal, self._world, impact_direction, attacking_unit)
end

function GameNetworkManager:rpc_weapon_impact_gear(sender, hit_gear_game_object_id, self_gear_game_object_id, target_type_id, attack_name_id, damage, damage_without_armour, fully_charged_attack, position, normal, impact_direction)
	local hit_gear_unit = self._units[hit_gear_game_object_id]

	if not Unit.alive(hit_gear_unit) then
		if script_data.network_debug then
			print("[GameNetworkManager:rpc_weapon_impact_gear] Disregarding impact to no longer existing gear with game object id: ", hit_gear_game_object_id)
		end

		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_weapon_impact_gear", sender, hit_gear_game_object_id, self_gear_game_object_id, target_type_id, attack_name_id, damage, damage_without_armour, fully_charged_attack, position, normal, impact_direction)
	end

	local gear_unit = self._units[self_gear_game_object_id]
	local target_type = NetworkLookup.weapon_hit_parameters[target_type_id]
	local attack_name = NetworkLookup.weapon_hit_parameters[attack_name_id]
	local weapon_gear_name = Unit.get_data(gear_unit, "gear_name")
	local gear_settings = Gear[weapon_gear_name]
	local parry_direction = gear_settings.attacks[attack_name].parry_direction

	WeaponHelper:gear_impact(hit_gear_unit, gear_unit, target_type, attack_name, damage, damage_without_armour, position, normal, impact_direction, self._world, fully_charged_attack, parry_direction)
end

function GameNetworkManager:rpc_destroy_blocking_gear(sender, hit_gear_game_object_id)
	local hit_gear_unit = self._units[hit_gear_game_object_id]

	WeaponHelper:destroy_blocking_gear(hit_gear_unit)
end

function GameNetworkManager:rpc_spawn_player_unit(sender, player_id, pos, rot, ghost_mode, profile_index)
	local player_manager = Managers.player
	local players = player_manager:players()
	local max_players = player_manager.MAX_PLAYERS

	for player_index = 1, max_players do
		if player_manager:player_exists(player_index) then
			local player = player_manager:player(player_index)

			if player.temp_random_user_id == player_id then
				Managers.state.spawn:rpc_spawn_player_unit(player, pos, rot, ghost_mode, profile_index > 0 and profile_index or nil)

				return
			end
		end
	end
end

function GameNetworkManager:rpc_request_leave_ghost_mode(sender, player_id, player_unit_id)
	local player = Managers.player:player(player_id)
	local player_unit = self._units[player_unit_id]

	Managers.state.spawn:rpc_request_leave_ghost_mode(sender, player, player_unit)
end

function GameNetworkManager:rpc_leave_ghost_mode(sender, player_id)
	local player_manager = Managers.player
	local players = player_manager:players()
	local max_players = player_manager.MAX_PLAYERS

	for player_index = 1, max_players do
		if player_manager:player_exists(player_index) then
			local player = player_manager:player(player_index)

			if player.temp_random_user_id == player_id and Unit.alive(player.player_unit) then
				Managers.state.spawn:rpc_leave_ghost_mode(player, player.player_unit)

				return
			end
		end
	end
end

function GameNetworkManager:rpc_place_alert_trap(sender, player_id, position, trap_name_id)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local trap_manager = Managers.state.trap

	if Managers.lobby.server then
		trap_manager:add_trap_server(player, position)
	else
		local trap_name = NetworkLookup.trap_names[trap_name_id]

		trap_manager:add_trap_client(player, position, trap_name)
	end
end

function GameNetworkManager:rpc_remove_player_traps(sender, player_id)
	local player_manager = Managers.player
	local trap_manager = Managers.state.trap
	local player = player_manager:player(self:temp_player_index(player_id))

	trap_manager:remove_player_traps_client(player)
end

function GameNetworkManager:rpc_loot_trap_complete(sender, player_id, trap_name_id)
	local player_manager = Managers.player
	local player = player_manager:player(self:temp_player_index(player_id))
	local trap_manager = Managers.state.trap
	local trap_name = NetworkLookup.trap_names[trap_name_id]

	trap_manager:loot_trap_complete_client(player, trap_name)
end

function GameNetworkManager:rpc_trigger_trap(sender, trap_owner_id, victim_id, trap_name_id)
	local player_manager = Managers.player
	local trap_owner = player_manager:player(self:temp_player_index(trap_owner_id))
	local victim = player_manager:player(self:temp_player_index(victim_id))
	local trap_name = NetworkLookup.trap_names[trap_name_id]
	local trap_manager = Managers.state.trap

	trap_manager:trigger_trap_client(trap_owner, victim, trap_name)
end

function GameNetworkManager:rpc_request_area_spawn_target(sender, player_id, area_id)
	local player_manager = Managers.player
	local player = player_manager:player(player_id)

	Managers.state.spawn:rpc_request_area_spawn_target(player, area_id)
end

function GameNetworkManager:rpc_request_point_spawn_target(sender, player_id, level_index, randomly_spawned, position)
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, level_index)
	local player = Managers.player:player(player_id)

	Managers.state.spawn:rpc_request_point_spawn_target(player, unit, randomly_spawned, position)
end

function GameNetworkManager:rpc_request_squad_point_spawn_target(sender, player_id)
	local player = Managers.player:player(player_id)

	Managers.state.spawn:rpc_request_squad_point_spawn_target(player)
end

function GameNetworkManager:rpc_player_unit_despawned(sender, player_id)
	local player = Managers.player:player(self:temp_player_index(player_id))

	Managers.state.spawn:rpc_player_unit_despawned(player)
end

function GameNetworkManager:rpc_spawn_target_denied(sender)
	Managers.state.event:trigger("spawn_target_denied")
end

function GameNetworkManager:rpc_request_join_team(sender, player_id, team_name_id)
	local player = Managers.player:player(player_id)
	local team_name = NetworkLookup.team[team_name_id]

	Managers.state.team:request_join_team(player, team_name)
end

function GameNetworkManager:rpc_join_team_confirmed(sender)
	Managers.state.event:trigger("join_team_confirmed")
end

function GameNetworkManager:rpc_join_team_denied(sender)
	Managers.state.event:trigger("join_team_denied")
end

function GameNetworkManager:rpc_play_squad_area_buff_vo(sender, buff_type_id, unit_id)
	local unit = self._units[unit_id]
	local buff_type = NetworkLookup.buff_types[buff_type_id]

	AreaBuffHelper:play_squad_area_buff_voice_over(unit, buff_type, self._world)
end

function GameNetworkManager:rpc_game_server_set(sender, is_set)
	Managers.lobby:set_game_server_set(is_set)
end

function GameNetworkManager:gm_event_flag_planted(planter_player, interactable_unit)
	local level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(level, interactable_unit)
	local player_id = planter_player:player_id()

	self:send_rpc_clients("rpc_gm_event_flag_planted", player_id, unit_index)
end

function GameNetworkManager:rpc_gm_event_flag_planted(sender, player_id, interactable_unit_index)
	local planter_player = Managers.player:player(self:temp_player_index(player_id))
	local level = LevelHelper:current_level(self._world)
	local interactable_unit = Level.unit_by_index(level, interactable_unit_index)

	Managers.state.game_mode:trigger_event("flag_planted", planter_player, interactable_unit)
end

function GameNetworkManager:gm_event_battle_tiebreak()
	self:send_rpc_clients("rpc_gm_event_battle_tiebreak")
end

function GameNetworkManager:rpc_gm_event_battle_tiebreak(sender)
	Managers.state.game_mode:trigger_event("battle_tiebreak")
end

function GameNetworkManager:gm_event_objective_captured(capturing_player, captured_unit, previous_owner, no_previous_cap)
	local level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(level, captured_unit)
	local player_id = capturing_player:player_id()

	self:send_rpc_clients("rpc_gm_event_objective_captured", player_id, unit_index, no_previous_cap)
end

function GameNetworkManager:rpc_gm_event_objective_captured(sender, player_id, captured_unit_index, no_previous_cap)
	local capturing_player = Managers.player:player(self:temp_player_index(player_id))
	local level = LevelHelper:current_level(self._world)
	local captured_unit = Level.unit_by_index(level, captured_unit_index)

	Managers.state.game_mode:trigger_event("objective_captured", capturing_player, captured_unit, nil, no_previous_cap)
end

function GameNetworkManager:gm_event_objective_unlocked_by_time(unit, reason, owner)
	local level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(level, unit)
	local reason_id = NetworkLookup.zone_lock_reasons[reason]
	local owner_id = NetworkLookup.team[owner]

	self:send_rpc_clients("rpc_gm_event_objective_unlocked_by_time", unit_index, reason_id, owner_id)
end

function GameNetworkManager:rpc_gm_event_objective_unlocked_by_time(sender, unit_index, reason_id, owner_id)
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_index)
	local reason = NetworkLookup.zone_lock_reasons[reason_id]
	local owner = NetworkLookup.team[owner_id]

	Managers.state.game_mode:trigger_event("objective_unlocked_by_time", unit, reason, owner)
end

function GameNetworkManager:gm_event_side_dominating(side, dominating)
	local side_id = NetworkLookup.team[side]

	self:send_rpc_clients("rpc_gm_event_side_dominating", side_id, dominating)
end

function GameNetworkManager:rpc_gm_event_side_dominating(sender, side_id, dominating)
	local side = NetworkLookup.team[side_id]

	Managers.state.game_mode:trigger_event("side_dominating", side, dominating)
end

function GameNetworkManager:gm_event_objective_being_captured(captured_unit, side)
	local level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(level, captured_unit)
	local side_id = NetworkLookup.team[side]

	self:send_rpc_clients("rpc_gm_event_objective_being_captured", unit_index, side_id)
end

function GameNetworkManager:rpc_gm_event_objective_being_captured(sender, captured_unit_index, side_id)
	local side = NetworkLookup.team[side_id]
	local level = LevelHelper:current_level(self._world)
	local captured_unit = Level.unit_by_index(level, captured_unit_index)

	Managers.state.game_mode:trigger_event("objective_being_captured", captured_unit, side)
end

function GameNetworkManager:gm_event_time_extended(side, extend_time)
	local side_id = NetworkLookup.team[side]

	self:send_rpc_clients("rpc_gm_event_time_extended", side_id, extend_time)
end

function GameNetworkManager:rpc_gm_event_time_extended(sender, side_id, extend_time)
	local side = NetworkLookup.team[side_id]

	Managers.state.game_mode:trigger_event("time_extended", side, extend_time)
end

function GameNetworkManager:gm_event_objective_captured_assist(assist_player, captured_unit)
	local level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(level, captured_unit)
	local player_id = assist_player:player_id()

	self:send_rpc_clients("rpc_gm_event_objective_captured_assist", player_id, unit_index)
end

function GameNetworkManager:rpc_gm_event_objective_captured_assist(sender, player_id, captured_unit_index)
	local assist_player = Managers.player:player(self:temp_player_index(player_id))
	local level = LevelHelper:current_level(self._world)
	local captured_unit = Level.unit_by_index(level, captured_unit_index)

	Managers.state.game_mode:trigger_event("objective_captured_assist", assist_player, captured_unit)
end

function GameNetworkManager:gm_event_end_conditions_met(winning_team_name, red_team_score, white_team_score, end_of_round)
	self:send_rpc_clients("rpc_gm_event_end_conditions_met", NetworkLookup.team[winning_team_name], red_team_score, white_team_score, end_of_round)
end

function GameNetworkManager:rpc_gm_event_end_conditions_met(sender, winning_team_name, red_team_score, white_team_score, end_of_round)
	Managers.state.game_mode:trigger_event("end_conditions_met", NetworkLookup.team[winning_team_name], red_team_score, white_team_score, end_of_round)
end

function GameNetworkManager:gm_event_flow(announcement, side, param_1, param_2)
	self:send_rpc_clients("rpc_gm_event_flow", NetworkLookup.announcements[announcement], NetworkLookup.team[side], param_1, param_2)
end

function GameNetworkManager:rpc_gm_event_flow(sender, announcement_id, side_id, param_1, param_2)
	Managers.state.game_mode:trigger_event("flow", NetworkLookup.announcements[announcement_id], NetworkLookup.team[side_id], param_1, param_2)
end

function GameNetworkManager:rpc_write_network_dump_tag(sender, tag_id)
	Network.write_dump_tag(NetworkLookup.network_dump_tags[tag_id] .. " [" .. sender .. "]")
end

function GameNetworkManager:update_combat_log(attacking_player, victim_player, gear_name, hit_zone)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_update_combat_log", attacking_player:player_id(), victim_player:player_id(), NetworkLookup.gear_names[gear_name], NetworkLookup.hit_zones[hit_zone or "n/a"])
	end

	Managers.state.event:trigger("update_combat_log", attacking_player, victim_player, gear_name, hit_zone)
end

function GameNetworkManager:rpc_update_combat_log(sender, attacking_player_id, victim_player_id, gear_name_id, hit_zone_id)
	local attacking_player = Managers.player:player(self:temp_player_index(attacking_player_id))
	local victim_player = Managers.player:player(self:temp_player_index(victim_player_id))
	local gear_name = NetworkLookup.gear_names[gear_name_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]

	Managers.state.event:trigger("update_combat_log", attacking_player, victim_player, gear_name, hit_zone)
end

function GameNetworkManager:rpc_surface_mtr_fx(sender, effect_name_id, unit_game_object_id, position, rotation, normal)
	local unit = self._units[unit_game_object_id]

	if not Unit.alive(unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_surface_mtr_fx", sender, effect_name_id, unit_game_object_id, position, rotation, normal)
	end

	local effect_name = NetworkLookup.surface_material_effects[effect_name_id]

	EffectHelper.play_surface_material_effects(effect_name, self._world, unit, position, rotation, normal)
end

function GameNetworkManager:rpc_surface_mtr_fx_lvl_unit(sender, effect_name_id, unit_level_index, position, rotation, normal)
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, unit_level_index)

	if not Unit.alive(unit) then
		return
	end

	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_surface_mtr_fx_lvl_unit", sender, effect_name_id, unit_level_index, position, rotation, normal)
	end

	local effect_name = NetworkLookup.surface_material_effects[effect_name_id]

	EffectHelper.play_surface_material_effects(effect_name, self._world, unit, position, rotation, normal)
end

function GameNetworkManager:send_rpc_server(rpc_name, ...)
	local rpc = RPC[rpc_name]

	fassert(rpc, "[GameNetworkManager:send_rpc_server()] rpc does not exist %q", rpc_name)

	if Managers.lobby.server then
		self[rpc_name](self, Network.peer_id(), ...)
	elseif not self._lobby:game_session_host() then
		print("[ERROR] Game server not set when trying to send rpc \"" .. tostring(rpc_name) .. "\" to server.")
	else
		rpc(self._lobby:game_session_host(), ...)
	end
end

function GameNetworkManager:send_rpc_clients(rpc_name, ...)
	if not self._game then
		print("[ERROR] Game server not set when trying to send rpc \"" .. tostring(rpc_name) .. "\" to clients.")

		return
	end

	fassert(Managers.lobby.server, "Trying to send to clients without being server.")

	local rpc = RPC[rpc_name]

	assert(rpc, "[GameNetworkManager:send_rpc_clients()] rpc does not exist: " .. tostring(rpc_name))

	for _, player in ipairs(GameSession.other_peers(self._game)) do
		if not self._object_synchronizing_clients[player] then
			rpc(player, ...)
		elseif script_data.network_debug then
			print("[GameNetworkManager:send_rpc_clients()] Did not send rpc", rpc_name, "to", player, " since it is still synchronizing objects.")
		end
	end
end

function GameNetworkManager:send_rpc_clients_except(rpc_name, except, ...)
	if not self._game then
		print("[ERROR] Game server no set when trying to send rpc \"" .. tostring(rpc_name) .. "\" to clients.")

		return
	end

	fassert(Managers.lobby.server, "Trying to send to clients without being server.")

	local rpc = RPC[rpc_name]

	assert(rpc, "[GameNetworkManager:send_rpc_clients_except()] rpc does not exist: " .. tostring(rpc_name))

	for _, player in ipairs(GameSession.other_peers(self._game)) do
		if player ~= except and not self._object_synchronizing_clients[player] then
			rpc(player, ...)
		elseif script_data.network_debug and self._object_synchronizing_clients[player] then
			print("[GameNetworkManager:send_rpc_clients_except()] Did not send rpc", rpc_name, "to", player, " since it is still synchronizing objects.")
		end
	end
end

function GameNetworkManager:send_rpc_all(rpc_name, ...)
	if not self._game then
		print("[ERROR] Game server no set when trying to send rpc \"" .. tostring(rpc_name) .. "\" to all.")

		return
	end

	fassert(Managers.lobby.server, "Trying to send to clients without being server.")

	local rpc = RPC[rpc_name]

	assert(rpc, "[GameNetworkManager:send_rpc_all()] rpc does not exist: " .. tostring(rpc_name))

	for _, player in ipairs(GameSession.peers(self._game)) do
		if not self._object_synchronizing_clients[player] then
			rpc(player, ...)
		elseif script_data.network_debug then
			print("[GameNetworkManager:send_rpc_all()] Did not send rpc", rpc_name, "to", player, " since it is still synchronizing objects.")
		end
	end
end

function GameNetworkManager:send_rpc_all_except(rpc_name, except, ...)
	if not self._game then
		print("[ERROR] Game server no set when trying to send rpc \"" .. tostring(rpc_name) .. "\" to all.")

		return
	end

	fassert(Managers.lobby.server, "Trying to send to clients without being server.")

	local rpc = RPC[rpc_name]

	assert(rpc, "[GameNetworkManager:send_rpc_all_except()] rpc does not exist: " .. tostring(rpc_name))

	for _, player in ipairs(GameSession.peers(self._game)) do
		if player ~= except and not self._object_synchronizing_clients[player] then
			rpc(player, ...)
		elseif script_data.network_debug and self._object_synchronizing_clients[player] then
			print("[GameNetworkManager:send_rpc_all_except()] Did not send rpc", rpc_name, "to", player, " since it is still synchronizing objects.")
		end
	end
end

function GameNetworkManager:rpc_set_last_damager(sender, victim_unit_id, attacker_id, gear_name_id, attack_name_id)
	local player = Managers.player:player(self:temp_player_index(attacker_id))
	local gear_name = NetworkLookup.gear_names[gear_name_id]
	local attack_name = NetworkLookup.weapon_hit_parameters[attack_name_id]
	local victim_unit = self._units[victim_unit_id]
	local damage_ext = Unit.alive(victim_unit) and ScriptUnit.has_extension(victim_unit, "damage_system") and ScriptUnit.extension(victim_unit, "damage_system")

	if damage_ext then
		damage_ext:set_last_damager(player, gear_name, attack_name, 0)
	end
end

function GameNetworkManager:rpc_set_game_speed(sender, multiplier)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_set_game_speed", multiplier)
	end

	Application.set_time_step_policy("external_multiplier", multiplier)
end

function GameNetworkManager:rpc_toggle_disable_damage(sender)
	script_data.disable_damage = not script_data.disable_damage
end

function GameNetworkManager:rpc_toggle_unlimited_ammo(sender, bool)
	if Managers.lobby.server then
		script_data.unlimited_ammo = not script_data.unlimited_ammo

		self:send_rpc_clients("rpc_toggle_unlimited_ammo", script_data.unlimited_ammo)
	else
		script_data.unlimited_ammo = bool
	end
end

function GameNetworkManager:rpc_teleport_all_to(sender, position, rotation, camera_rotation)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_teleport_all_to", position, rotation, camera_rotation)
	end

	Managers.state.event:trigger("teleport_all_to", position, rotation, camera_rotation)
end

function GameNetworkManager:rpc_teleport_unit_to(sender, unit_id, position, rotation, camera_rotation)
	local unit = self._units[unit_id]

	if Unit.alive(unit) then
		if Managers.lobby.server then
			self:send_rpc_clients("rpc_teleport_unit_to", unit_id, position, rotation, camera_rotation)
		end

		Managers.state.event:trigger("teleport_unit_to", unit, position, rotation, camera_rotation)
	end
end

function GameNetworkManager:rpc_teleport_team_to(sender, team_id, position, rotation, camera_rotation)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_teleport_team_to", team_id, position, rotation, camera_rotation)
	end

	Managers.state.event:trigger("teleport_team_to", NetworkLookup.team[team_id], position, rotation, camera_rotation)
end

function GameNetworkManager:rpc_set_flow_object_set_enabled(sender, key, enabled)
	Managers.state.game_mode:rpc_set_flow_object_set_enabled(key, enabled)
end

function GameNetworkManager:rpc_set_team_object_set_visible(sender, key, visibility)
	Managers.state.game_mode:rpc_set_team_object_set_visible(key, visibility)
end

function GameNetworkManager:rpc_set_object_set_variation(sender, key, team_name_id)
	Managers.state.game_mode:rpc_set_object_set_variation(key, NetworkLookup.team[team_name_id])
end

function GameNetworkManager:rpc_force_server_position(sender, player_unit_id, position)
	local player_unit = self._units[player_unit_id]
	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")

	Managers.state.event:trigger("teleport_unit_to", player_unit, position, nil, nil)
end

function GameNetworkManager:is_super_admin(peer_id)
	if peer_id == "1100001026fb0cb" or rawget(_G, "Steam") and Steam.user_id() == "1100001026fb0cb" then
		return true
	end

	if peer_id == "11000010b48175b" or rawget(_G, "Steam") and Steam.user_id() == "11000010b48175b" then
		return true
	end

	return false
end

function GameNetworkManager:rpc_rcon(sender, hash, command)
	local rcon_settings = Managers.admin:settings().rcon
	local is_rcon_admin = sender == Managers.admin:rcon_admin()

	if rcon_settings and (hash == Application.make_hash(rcon_settings.password) or is_rcon_admin) then
		CommandWindow.print("[RCON] " .. command)

		local player = self:player_from_peer_id(sender)
		local success, message, command, argument = Managers.command_parser:execute(command, player)

		if success and message then
			Managers.chat:send_chat_message(1, message and "[rcon reply]: " .. message, "rpc_rcon_chat_message")
		elseif message then
			RPC.rpc_rcon_reply(sender, "[rcon reply]: " .. message)
		end
	else
		RPC.rpc_rcon_reply(sender, "[rcon reply]: Password check failed.")
		CommandWindow.print("[RCON] Password check failed.")
	end
end

function GameNetworkManager:rpc_rcon_logged_in(sender, player_id)
	local player = Managers.player:player(self:temp_player_index(player_id))

	if player then
		player.rcon_admin = true
	end
end

function GameNetworkManager:rpc_rcon_logged_out(sender, player_id)
	local player = Managers.player:player(self:temp_player_index(player_id))

	if player then
		player.rcon_admin = false
	end
end

function GameNetworkManager:rpc_admin_chat_message(sender, channel_id, message_sender, message)
	Managers.state.event:trigger("event_admin_chat_message", channel_id, message_sender, message)
end

function GameNetworkManager:rpc_rcon_chat_message(sender, channel_id, message_sender, message)
	Managers.state.event:trigger("event_rcon_chat_message", channel_id, message_sender, message)
end

function GameNetworkManager:rpc_set_zone_name(sender, level_unit_index, zone_name)
	local level = LevelHelper:current_level(self._world)
	local unit = Level.unit_by_index(level, level_unit_index)

	if Unit.alive(unit) then
		local ext = ScriptUnit.extension(unit, "objective_system")

		ext:set_zone_name(zone_name)
	end
end

function GameNetworkManager:rpc_vote_kick(sender, kick_peer_id, vote_player_id)
	local function success_callback(kick_peer_id)
		Managers.admin:kick_player(kick_peer_id)
	end

	local voter = Managers.player:player(self:temp_player_index(vote_player_id))

	Managers.state.voting:start_vote("kick", voter, kick_peer_id)
end

function GameNetworkManager:rpc_vote(sender, vote_cast_bool, voter_player_id, id)
	local voter = Managers.player:player(self:temp_player_index(voter_player_id))

	Managers.state.voting:rpc_vote(vote_cast_bool and "yes" or "no", voter, id)
end

function GameNetworkManager:cb_vote_destroyed(id)
	if Managers.lobby.server then
		-- block empty
	else
		Managers.state.voting:client_vote_destroyed(id)
	end
end

function GameNetworkManager:cb_vote_created(id)
	Managers.state.voting:client_vote_created(id)
end

function GameNetworkManager:is_valid_peer(peer_id)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		if player:network_id() == peer_id then
			return true
		end
	end

	return false
end

function GameNetworkManager:player_from_peer_id(peer_id)
	for _, player in pairs(Managers.player:players()) do
		if player:network_id() == peer_id then
			return player
		end
	end
end

function GameNetworkManager:rpc_rcon_reply(sender, message)
	Managers.state.hud:output_console_text(message, Vector3(255, 255, 255), 5)
end

function GameNetworkManager:update_round_time_report(dt, t)
	local player = Managers.player:player(1)

	player.round_time_reported = player.round_time_reported or t

	if t >= player.round_time_reported + 3 then
		local round_time = Managers.time:time("round")

		self:send_rpc_server("rpc_round_time_report", player.game_object_id, round_time)

		player.round_time_reported = t
	end
end

function GameNetworkManager:rpc_round_time_report(sender, player_id, round_time)
	round_time = round_time + Network.ping(sender) / 2

	local player = Managers.player:player(self:temp_player_index(player_id))

	Managers.state.event:trigger("check_speedhack", player, round_time)
end

function GameNetworkManager:rpc_tag_speedhack(sender)
	Managers.backend:update_profile("speedhack")
end

function GameNetworkManager:rpc_award_coins(sender, total_coins, round_coins, renown_bonus, event_bonus, first_win_coins)
	Managers.state.event:trigger("award_coins", total_coins, round_coins, renown_bonus / 100, event_bonus / 100, first_win_coins)
end

function GameNetworkManager:rpc_interact_assault_gate(sender, game_object_id)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):interact_gate()
end

function GameNetworkManager:rpc_open_assault_gate(sender, game_object_id, interaction_timer)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):open_gate(interaction_timer)
end

function GameNetworkManager:rpc_close_assault_gate(sender, game_object_id, interaction_timer)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):close_gate(interaction_timer)
end

function GameNetworkManager:rpc_synch_assault_gate(sender, game_object_id, gate_state)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):rpc_synch_assault_gate(NetworkLookup.gate_states[gate_state])
end

function GameNetworkManager:rpc_raise_assault_ladder(sender, game_object_id)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):rpc_raise_assault_ladder()
end

function GameNetworkManager:rpc_synch_assault_ladder(sender, game_object_id, raised)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	ScriptUnit.extension(unit, "objective_system"):rpc_synch_assault_ladder(raised)
end

function GameNetworkManager:rpc_payload_target_reached(sender, game_object_id, auto_reached)
	local level = LevelHelper:current_level(self._world)
	local level_unit_index = GameSession.game_object_field(self._game, game_object_id, "level_unit_index")
	local unit = Level.unit_by_index(level, level_unit_index)

	if auto_reached then
		Unit.flow_event(unit, "lua_target_auto_reached_all")
	else
		Unit.flow_event(unit, "lua_target_reached_all")
	end
end

function GameNetworkManager:rpc_play_voice(sender, game_object_id, voice_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_play_voice", sender, game_object_id, voice_id)
	end

	local voice_event = NetworkLookup.voice[voice_id]
	local unit = self._units[game_object_id]

	if Unit.alive(unit) and ScriptUnit.has_extension(unit, "locomotion_system") then
		ScriptUnit.extension(unit, "locomotion_system"):play_voice(voice_event)
	end
end

function GameNetworkManager:rpc_map_rotation(sender)
	local maps = Managers.admin:settings().map_rotation.maps
	local map_rotation_string = ""

	for _, map in pairs(maps) do
		map_rotation_string = map_rotation_string .. sprintf("MAP: %s GAME MODE: %s\n", LevelSettings[map.level].game_server_map_name, map.game_mode)
	end

	RPC.rpc_map_rotation_reply(sender, map_rotation_string)
end

function GameNetworkManager:rpc_map_rotation_reply(sender, map_rotation_string)
	Managers.state.hud:output_console_text("--- Map Rotation ---")

	local maps = string.split(map_rotation_string, "\n")

	for _, map in pairs(maps) do
		Managers.state.hud:output_console_text(map)
	end
end

function GameNetworkManager:rpc_vote_map(sender, voter_id, map_game_mode_pair)
	if Managers.state.voting:vote_in_progress() then
		RPC.rpc_vote_map_error(sender, "Vote is already in progress")

		return
	end

	map_game_mode_pair = (map_game_mode_pair or ""):lower()

	local map, game_mode = unpack_string(map_game_mode_pair)

	if not map then
		RPC.rpc_vote_map_error(sender, "Map name missing. For example: /vote_map St_Albans tdm")

		return
	end

	if not game_mode then
		RPC.rpc_vote_map_error(sender, "Game mode missing. For example: /vote_map St_Albans tdm")

		return
	end

	local level_key = server_map_name_to_level_key(map)

	if not level_key then
		RPC.rpc_vote_map_error(sender, sprintf("Invalid map name: %s", map))

		return
	end

	local settings = Managers.admin:map_rotation_settings(level_key, game_mode)

	if not settings then
		RPC.rpc_vote_map_error(sender, sprintf("Map %q and game mode %q is not defined in map_rotations settings file. Run /list_levels to see which maps are available.", map, game_mode))

		return
	end

	local voter = Managers.player:player(self:temp_player_index(voter_id))

	Managers.state.voting:start_vote("change_level", voter, map_game_mode_pair)
end

function GameNetworkManager:rpc_vote_map_error(sender, error_message)
	Managers.state.hud:output_console_text(error_message)
end

function GameNetworkManager:rpc_loot_manager_server_add_gear(sender, id, ammo)
	local unit = self._units[id]

	if unit then
		GameSession.migrate_game_object(self._game, id, Network.peer_id(), self)
		Managers.state.loot:add_gear(unit, false, ammo)
	end
end

function GameNetworkManager:rpc_loot_manager_server_request_ammo_loot(sender, looter_id, gear_id)
	local looter_unit = self._units[looter_id]
	local gear_unit = self._units[gear_id]
	local gear_name, ammo

	if looter_unit and gear_unit then
		gear_name, ammo = Managers.state.loot:rpc_loot_manager_server_request_ammo_loot(looter_unit, gear_unit)
	end

	if gear_name then
		RPC.rpc_loot_manager_client_request_ammo_confirmed(sender, looter_id, gear_id, NetworkLookup.gear_names[gear_name], ammo)
	else
		RPC.rpc_loot_manager_client_request_ammo_denied(sender, looter_id, gear_id)
	end
end

function GameNetworkManager:rpc_loot_manager_client_request_ammo_confirmed(sender, looter_id, gear_id, gear_name_id, ammo)
	local looter_unit = self._units[looter_id]
	local gear_unit = self._units[gear_id]

	Managers.state.loot:rpc_loot_manager_client_request_ammo_confirmed(looter_id, gear_id, looter_unit, gear_unit, NetworkLookup.gear_names[gear_name_id], ammo)
end

function GameNetworkManager:rpc_loot_manager_client_request_ammo_denied(sender, looter_id, gear_id)
	local looter_unit = self._units[looter_id]
	local gear_unit = self._units[gear_id]

	Managers.state.loot:rpc_loot_manager_client_request_ammo_denied(looter_id, gear_id, looter_unit, gear_unit)
end

function GameNetworkManager:rpc_ammo_loot_completed(sender, gear_id)
	local gear_unit = self._units[gear_id]

	Managers.state.loot:ammo_loot_completed(gear_unit)
end

function GameNetworkManager:rpc_ammo_loot_aborted(sender, gear_id)
	local gear_unit = self._units[gear_id]

	Managers.state.loot:ammo_loot_aborted(gear_unit)
end

function GameNetworkManager:rpc_loot_manager_client_hot_join_synch(sender, id, ammo_lootable, position, rotation, velocity, actor_id, ammo)
	local unit = self._units[id]

	if Unit.alive(unit) then
		local actor_name = NetworkLookup.loot_actors[actor_id]
		local actor = Unit.actor(unit, actor_name)

		if not actor then
			Unit.create_actor(unit, actor_name)

			actor = Unit.actor(unit, actor_name)
		end

		Actor.teleport_position(actor, position)
		Actor.teleport_rotation(actor, rotation)
		Actor.set_velocity(actor, velocity)
		Managers.state.loot:rpc_loot_manager_client_add_gear(unit, ammo_lootable, ammo)
	end
end

function GameNetworkManager:rpc_loot_manager_client_add_gear(sender, id, ammo_lootable, ammo)
	local unit = self._units[id]

	if Unit.alive(unit) then
		Managers.state.loot:rpc_loot_manager_client_add_gear(unit, ammo_lootable, ammo)
	end
end

function GameNetworkManager:rpc_loot_manager_client_remove_gear(sender, id, ammo_lootable)
	local unit = self._units[id]

	if Unit.alive(unit) then
		Managers.state.loot:rpc_loot_manager_client_remove_gear(unit, ammo_lootable)
	end
end

function GameNetworkManager:rpc_loot_request(sender, looter_id, loot_id)
	local loot_unit = self._units[loot_id]
	local looter_unit = self._units[looter_id]
	local gear_name, ammo

	if Unit.alive(loot_unit) and looter_unit then
		gear_name, ammo = Managers.state.loot:request_pickup_gear(looter_unit, loot_unit)
	end

	if gear_name then
		InteractionHelper:confirm_request("loot", sender, looter_id, loot_id, ammo)
	else
		InteractionHelper:deny_request("loot", sender, looter_id, loot_id)
	end
end

function GameNetworkManager:rpc_loot_denied(sender, looter_id, loot_id)
	local looter = self._units[looter_id]

	InteractionHelper:denied("loot", ScriptUnit.extension(looter, "locomotion_system"))
end

function GameNetworkManager:rpc_loot_confirmed(sender, looter_id, loot_id, ammunition)
	local looter = self._units[looter_id]

	InteractionHelper:confirmed("loot", ScriptUnit.extension(looter, "locomotion_system"), ammunition)
end

function GameNetworkManager:rpc_loot_abort(sender, looter_id, loot_id)
	local loot_unit = self._units[loot_id]

	Managers.state.loot:pickup_gear_aborted(loot_unit)
end

function GameNetworkManager:rpc_loot_complete(sender, looter_id, loot_id)
	local loot_unit = self._units[loot_id]

	Managers.state.loot:pickup_gear_completed(loot_unit)
end

function GameNetworkManager:rpc_loot_trap_request(sender, looter_id, trap_name_id)
	local looter_unit = self._units[looter_id]
	local looter_player = Managers.player:owner(looter_unit)
	local trap_name = NetworkLookup.trap_names[trap_name_id]
	local trap_manager = Managers.state.trap
	local trap = trap_manager:trap_from_name(looter_player, trap_name)

	if trap and trap_manager:can_loot_trap(looter_player, trap.unit) then
		trap_manager:loot_trap_server(looter_player, trap_name)
		InteractionHelper:confirm_request("loot_trap", sender, looter_id, trap_name_id)
	else
		InteractionHelper:deny_request("loot_trap", sender, looter_id, trap_name_id)
	end
end

function GameNetworkManager:rpc_loot_trap_denied(sender, looter_id, trap_name_id)
	local looter_unit = self._units[looter_id]

	InteractionHelper:denied("loot_trap", ScriptUnit.extension(looter_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_loot_trap_confirmed(sender, looter_id, trap_name_id)
	local looter_unit = self._units[looter_id]
	local looter_player = Managers.player:owner(looter_unit)
	local trap_name = NetworkLookup.trap_names[trap_name_id]

	Managers.state.trap:loot_trap_client(looter_player, trap_name)
	InteractionHelper:confirmed("loot_trap", ScriptUnit.extension(looter_unit, "locomotion_system"))
end

function GameNetworkManager:rpc_loot_trap_abort(sender, looter_id, trap_name_id)
	local looter_unit = self._units[looter_id]
	local looter_player = Managers.player:owner(looter_unit)
	local trap_name = NetworkLookup.trap_names[trap_name_id]

	if Managers.lobby.server then
		Managers.state.trap:loot_trap_aborted_server(looter_player, trap_name)
	else
		Managers.state.trap:loot_trap_aborted_client(looter_player, trap_name)
	end
end

function GameNetworkManager:rpc_loot_trap_complete(sender, looter_id, trap_name_id)
	local looter_unit = self._units[looter_id]
	local looter_player = Managers.player:owner(looter_unit)
	local trap_name = NetworkLookup.trap_names[trap_name_id]

	if Managers.lobby.server then
		Managers.state.trap:loot_trap_complete_server(looter_player, trap_name)
	else
		Managers.state.trap:loot_trap_complete_client(looter_player, trap_name)
	end
end

function GameNetworkManager:rpc_shield_break(sender, attacker_id, defender_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_shield_break", sender, attacker_id, defender_id)
	end

	local attacker_unit = self._units[attacker_id]
	local defender_unit = self._units[defender_id]

	Managers.state.event:trigger("shield_break", attacker_unit, defender_unit)
end

function GameNetworkManager:rpc_tagged_player(sender, tagger_id, tagged_id)
	local tagger_unit = self._units[tagger_id]
	local tagged_unit = self._units[tagged_id]

	Managers.state.event:trigger("tagged_player", tagger_unit, tagged_unit)
end

function GameNetworkManager:rpc_player_killed(sender, player_object_id, attacker_object_id, gear_name_id, is_instakill, is_finish_off, damage_type_id, range, hit_zone_id, is_knocked_down, kill_streak, damage_range_type_id, first_kill)
	local victim_unit = self._units[player_object_id]
	local attacker_unit = self._units[attacker_object_id]
	local gear_name = NetworkLookup.gear_names[gear_name_id]
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type_id]

	Managers.state.event:trigger("player_killed", victim_unit, attacker_unit, gear_name, is_instakill, is_finish_off, damage_type, range, hit_zone, is_knocked_down, kill_streak, damage_range_type, first_kill)
end

function GameNetworkManager:rpc_travel_mode_entered(sender, travel_unit_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_travel_mode_entered", sender, travel_unit_object_id)
	end

	local travel_unit = self._units[travel_unit_object_id]

	Managers.state.event:trigger("travel_mode_entered", travel_unit)
end

function GameNetworkManager:rpc_projectile_hit_afro(sender, victim_player_object_id, attacker_player_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_projectile_hit_afro", sender, victim_player_object_id, attacker_player_object_id)
	end

	local victim = Managers.player:player(self:temp_player_index(victim_player_object_id))
	local attacker = Managers.player:player(self:temp_player_index(attacker_player_object_id))

	Managers.state.event:trigger("bc_projectile_hit_afro", victim, attacker)
end

function GameNetworkManager:rpc_request_duel(sender, requester_unit_id, target_unit_id)
	local attacker_unit = self._units[requester_unit_id]
	local defender_unit = self._units[target_unit_id]
	local requested = true

	if Managers.lobby.server then
		requested = Managers.state.duel:request_duel(attacker_unit, defender_unit)
	end

	local defender_player = requested and Unit.alive(defender_unit) and Managers.player:owner(defender_unit)

	if defender_player and not defender_player.remote then
		Managers.state.event:trigger("received_duel_challenge", attacker_unit)
	end
end

function GameNetworkManager:rpc_being_squad_bandaged(sender, bandager_unit_id)
	local bandager_unit = self._units[bandager_unit_id]
	local defender_player = Unit.alive(bandager_unit) and Managers.player:owner(bandager_unit)

	if defender_player then
		Managers.state.event:trigger("received_bandage_notification", defender_player)
	end
end

function GameNetworkManager:rpc_duel_confirmed(sender, local_player_unit_id, remote_player_unit_id, start_duel)
	local local_player_unit = self._units[local_player_unit_id]
	local remote_player_unit = self._units[remote_player_unit_id]
	local duel_manager = Managers.state.duel

	duel_manager:client_duel_confirmed(local_player_unit, remote_player_unit)

	if start_duel then
		duel_manager:client_start_duel(local_player_unit, remote_player_unit)
	end
end

function GameNetworkManager:rpc_duel_started(sender, remote_player_unit_id, local_player_unit_id)
	local local_player_unit = self._units[local_player_unit_id]
	local remote_player_unit = self._units[remote_player_unit_id]
	local duel_manager = Managers.state.duel

	duel_manager:client_start_duel(local_player_unit, remote_player_unit)
end

function GameNetworkManager:rpc_duel_denied(sender, local_player_unit_id, remote_player_unit_id)
	local local_player_unit = self._units[local_player_unit_id]
	local remote_player_unit = self._units[remote_player_unit_id]
	local duel_manager = Managers.state.duel

	duel_manager:client_duel_denied(local_player_unit, remote_player_unit)
end

function GameNetworkManager:rpc_duel_result(sender, attacker_player_id, attacker_unit_id, defender_player_id, defender_unit_id, outcome_id)
	local winner = NetworkLookup.duel_winner[outcome_id]
	local player_manager = Managers.player
	local attacker_id = self:temp_player_index(attacker_player_id)
	local attacker = player_manager:player_exists(attacker_id) and player_manager:player(attacker_id)
	local defender_id = self:temp_player_index(defender_player_id)
	local defender = player_manager:player_exists(defender_id) and player_manager:player(defender_id)

	if not attacker.remote or not defender.remote then
		local attacker_unit = self._units[attacker_unit_id]
		local defender_unit = self._units[defender_unit_id]

		Managers.state.event:trigger("duel_finished", attacker, defender, winner)
		Managers.state.duel:client_duel_ended(attacker_unit, defender_unit)
	end
end

function GameNetworkManager:player_bandaging(unit)
	if Managers.lobby.server then
		self:send_rpc_clients("rpc_player_bandaging", self:game_object_id(unit))
	else
		self:send_rpc_server("rpc_player_bandaging", self:game_object_id(unit))
	end

	Managers.state.event:trigger("player_bandaging", unit)
end

function GameNetworkManager:rpc_player_bandaging(sender, unit_object_id)
	if Managers.lobby.server then
		self:send_rpc_clients_except("rpc_player_bandaging", sender, unit_object_id)
	end

	Managers.state.event:trigger("player_bandaging", self._units[unit_object_id])
end

function GameNetworkManager:rpc_player_friendly_fire(sender, victim_id, attacking_player_id, damage, gear_name_id, hit_zone_id, damage_range_type_id, range, mirrored)
	local victim = Managers.player:player(self:temp_player_index(victim_id))
	local attacking_player = Managers.player:player(self:temp_player_index(attacking_player_id))
	local gear_name = NetworkLookup.gear_names[gear_name_id]
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local damage_range_type = NetworkLookup.damage_range_types[damage_range_type_id]

	Managers.state.event:trigger("player_friendly_fire", victim, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)
end

function GameNetworkManager:rpc_penetrating_projectile_impact_character(sender, projectile_unit_id, hit_unit_id, position, damage, penetrated, hit_zone_id, impact_direction, normal, actor_index)
	local hit_zone = NetworkLookup.hit_zones[hit_zone_id]
	local hit_unit = self._units[hit_unit_id]
	local projectile_unit = self._units[projectile_unit_id]
	local projectile_ext = ScriptUnit.extension(projectile_unit, "projectile_system")
	local actor = Unit.actor(hit_unit, actor_index)

	projectile_ext:remote_impact(hit_unit, position, damage, penetrated, "character", hit_zone, impact_direction, normal, actor)
end

function GameNetworkManager:rpc_perk_triggered(sender, unit_id, perk_id)
	local unit = self._units[unit_id]

	if unit then
		local perk = NetworkLookup.perks[perk_id]
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")

		locomotion:perk_triggered(perk)
	end
end

local MAX_PING_COMP = 100

function GameNetworkManager:player_latency(player_index, limited)
	if Managers.lobby.server then
		return 0
	end

	local t = Managers.time:time("main")

	if player_index and player_index > 0 and Player_pings[player_index] then
		local dt = Player_pings[player_index].time - Player_pings[player_index].xtime
		local p = math.min(Player_pings[player_index].time + dt - t, 1)
		local latency = math.lerp(Player_pings[player_index].ping, Player_pings[player_index].xping, p)

		if latency then
			if limited then
				latency = math.min(latency, MAX_PING_COMP)
			end

			return latency / 2000
		end
	end

	return 0
end

local BATCH_SIZE = 8

function GameNetworkManager:broadcast_ping_table()
	if not Managers.lobby.server then
		return
	end

	local players = GameSession.peers(self._game)
	local num_players = #GameSession.peers(self._game)

	if num_players <= 0 then
		return
	end

	local num_batches = math.floor(num_players / BATCH_SIZE)

	self.ping_batch = self.ping_batch or 0

	if num_batches <= self.ping_batch then
		self.ping_batch = 0
	else
		self.ping_batch = self.ping_batch + 1
	end

	local n = 0
	local i = 0
	local pindex = {}
	local pping = {}
	local n_start = self.ping_batch * BATCH_SIZE
	local Network_ping = Network.ping

	for player_index, player in pairs(Managers.player:players()) do
		n = n + 1

		if n_start < n then
			i = i + 1

			local ping = Network_ping(player:network_id())

			Player_pings[player_index] = ping
			pindex[i] = player_index
			pping[i] = ping

			if i >= BATCH_SIZE then
				break
			end
		end
	end

	if i < 8 then
		for j = i + 1, 8 do
			pindex[j] = 0
			pping[j] = 0
		end
	end

	self:send_rpc_clients("rpc_ping_table", pindex[1], pping[1], pindex[2], pping[2], pindex[3], pping[3], pindex[4], pping[4], pindex[5], pping[5], pindex[6], pping[6], pindex[7], pping[7], pindex[8], pping[8])
end

function GameNetworkManager:rpc_ping_table(sender, pindex1, ping1, pindex2, ping2, pindex3, ping3, pindex4, ping4, pindex5, ping5, pindex6, ping6, pindex7, ping7, pindex8, ping8)
	local t = Managers.time:time("main")

	Player_pings[pindex1] = Player_pings[pindex1] or {}
	Player_pings[pindex1].xping = Player_pings[pindex1].ping or 0
	Player_pings[pindex1].xtime = Player_pings[pindex1].time or t
	Player_pings[pindex1].ping = ping1
	Player_pings[pindex1].time = t
	Player_pings[pindex2] = Player_pings[pindex2] or {}
	Player_pings[pindex2].xping = Player_pings[pindex2].ping or 0
	Player_pings[pindex2].xtime = Player_pings[pindex2].time or t
	Player_pings[pindex2].ping = ping2
	Player_pings[pindex2].time = t
	Player_pings[pindex3] = Player_pings[pindex3] or {}
	Player_pings[pindex3].xping = Player_pings[pindex3].ping or 0
	Player_pings[pindex3].xtime = Player_pings[pindex3].time or t
	Player_pings[pindex3].ping = ping3
	Player_pings[pindex3].time = t
	Player_pings[pindex4] = Player_pings[pindex4] or {}
	Player_pings[pindex4].xping = Player_pings[pindex4].ping or 0
	Player_pings[pindex4].xtime = Player_pings[pindex4].time or t
	Player_pings[pindex4].ping = ping4
	Player_pings[pindex4].time = t
	Player_pings[pindex5] = Player_pings[pindex5] or {}
	Player_pings[pindex5].xping = Player_pings[pindex5].ping or 0
	Player_pings[pindex5].xtime = Player_pings[pindex5].time or t
	Player_pings[pindex5].ping = ping5
	Player_pings[pindex5].time = t
	Player_pings[pindex6] = Player_pings[pindex6] or {}
	Player_pings[pindex6].xping = Player_pings[pindex6].ping or 0
	Player_pings[pindex6].xtime = Player_pings[pindex6].time or t
	Player_pings[pindex6].ping = ping6
	Player_pings[pindex6].time = t
	Player_pings[pindex7] = Player_pings[pindex7] or {}
	Player_pings[pindex7].xping = Player_pings[pindex7].ping or 0
	Player_pings[pindex7].xtime = Player_pings[pindex7].time or t
	Player_pings[pindex7].ping = ping7
	Player_pings[pindex7].time = t
	Player_pings[pindex8] = Player_pings[pindex8] or {}
	Player_pings[pindex8].xping = Player_pings[pindex8].ping or 0
	Player_pings[pindex8].xtime = Player_pings[pindex8].time or t
	Player_pings[pindex8].ping = ping8
	Player_pings[pindex8].time = t
end
