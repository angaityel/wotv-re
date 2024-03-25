-- chunkname: @scripts/managers/team/squad.lua

require("scripts/settings/squad_settings")

Squad = class(Squad)

function Squad:init(index, max_size, world, team_name, squad_reload_context)
	self._world = world
	self._index = index
	self._team_name = team_name
	self._max_size = max_size
	self._plant_time = 0
	self._members = {}
	self._corporal = nil
	self._animal_index = squad_reload_context.animal_index or index
	self._locked = squad_reload_context.locked or false
	self._squad_name_strings = self:_compile_squad_name_strings()
end

function Squad:_compile_squad_name_strings()
	local squad_name_strings = {}

	for _, colour_settings in ipairs(SquadSettings.squad_colours) do
		for _, animal_settings in ipairs(SquadSettings.squad_animals) do
			local colour_name = colour_settings.name
			local animal_name = animal_settings.name

			squad_name_strings[colour_name] = squad_name_strings[colour_name] or {}
			squad_name_strings[colour_name][animal_name] = colour_name .. "_" .. animal_name
		end
	end

	return squad_name_strings
end

function Squad:name()
	local colour_settings = SquadSettings.squad_colours[self._index]
	local animal_settings = SquadSettings.squad_animals[self._animal_index]

	return self._squad_name_strings[colour_settings.name][animal_settings.name]
end

function Squad:animal_index()
	return self._animal_index
end

function Squad:next_animal_index()
	local animal_index = self._animal_index % 8 + 1

	self:set_animal_index(animal_index)

	if Managers.state.network:game() then
		Managers.state.network:send_rpc_server("rpc_change_squad_animal_index", NetworkLookup.team[self._team_name], self._index, animal_index)
	end
end

function Squad:set_animal_index(animal_index)
	self._animal_index = animal_index
end

function Squad:create_game_object()
	local data_table = {
		game_object_created_func = NetworkLookup.game_object_functions.cb_squad_object_created,
		object_destroy_func = NetworkLookup.game_object_functions.cb_squad_object_destroyed,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		team_name = NetworkLookup.team[self._team_name],
		squad_id = self._index,
		plant_time = Managers.time:time("round")
	}
	local disconnect_callback = callback(self, "cb_game_session_disconnect")

	self._squad_game_object_id = Managers.state.network:create_game_object("squad", data_table, disconnect_callback)
end

function Squad:plant_time()
	local game = Managers.state.network:game()

	if game then
		return GameSession.game_object_field(game, self._squad_game_object_id, "plant_time")
	else
		return self._plant_time
	end
end

function Squad:_update_squad_game_object(game, field, value)
	GameSession.set_game_object_field(game, self._squad_game_object_id, field, value)
end

function Squad:cb_game_object_created(object_id)
	self._squad_game_object_id = object_id
end

function Squad:cb_game_object_destroyed(object_id)
	fassert(self._squad_game_object_id == object_id, "[Squad] destroying game object id %d, but game object id assigned to squad %s is game_object id %d", object_id, self._index, self._squad_game_object_id)

	self._squad_game_object_id = nil
end

function Squad:request_to_join(player)
	if Managers.state.network:game() then
		Managers.state.network:send_rpc_server("rpc_request_to_join_squad", player.game_object_id, self._index)
	end
end

function Squad:request_to_leave(player)
	if Managers.state.network:game() then
		Managers.state.network:send_rpc_server("rpc_request_to_leave_squad", player.game_object_id, self._index)
	end
end

function Squad:can_join(player)
	return self._members[player] == nil and self:num_members() < self._max_size and not self:locked()
end

function Squad:can_leave(player)
	return self._members[player] ~= nil
end

function Squad:add_member(player)
	self._members[player] = true
	player.squad_index = self._index

	if Managers.lobby.server then
		Managers.state.network:send_rpc_clients("rpc_add_player_to_squad", player.game_object_id, self._index)

		if table.size(self._members) == 1 then
			self:set_corporal(player)
		end
	end

	Managers.state.event:trigger("player_joined_squad", player, self._index)
end

function Squad:get_corporal_coat_of_arms()
	local corporal = self:corporal()

	if corporal and corporal.is_corporal then
		return corporal:get_coat_of_arms(), corporal.team.name
	end
end

function Squad:remove_member(player)
	self._members[player] = nil
	player.squad_index = nil

	if Managers.lobby.server then
		Managers.state.network:send_rpc_clients("rpc_remove_player_from_squad", player.game_object_id, self._index)
	end

	Managers.state.event:trigger("player_left_squad", player, self._index)

	if Managers.lobby.server and player.is_corporal then
		self:pick_new_corporal()
	end

	if player.is_corporal then
		Managers.state.event:trigger("player_no_longer_corporal", player)
	end

	player.is_corporal = false

	if self:num_members() == 0 then
		self._locked = false
	end

	if Managers.lobby.server and not next(self._members) then
		self:destroy_squad_flag()
	end
end

function Squad:pick_new_corporal()
	local new_corporal = next(self._members)

	if new_corporal then
		self:set_corporal(new_corporal)
	else
		self._corporal = nil
	end
end

function Squad:set_corporal(player)
	self._corporal = player
	player.is_corporal = true

	if Managers.lobby.server then
		Managers.state.network:send_rpc_clients("rpc_set_squad_corporal", player.game_object_id, self._index)
	end

	Managers.state.event:trigger("player_became_corporal", player)

	if player.local_player then
		Managers.state.event:trigger("game_mode_announcement", "new_squad_leader")
	end
end

function Squad:hot_sync_corporal_coat_of_arms(corporal, game)
	local corporal = self:corporal()

	if corporal and corporal.is_corporal then
		local coat_of_arms = corporal:hot_sync_coat_of_arms(game)

		for player, _ in pairs(self._members) do
			if Unit.alive(player.player_unit) then
				local inventory = ScriptUnit.extension(player.player_unit, "locomotion_system"):inventory()

				inventory:update_coat_of_arms(coat_of_arms, corporal.team.name)
			end
		end
	end
end

function Squad:index()
	return self._index
end

function Squad:corporal()
	return self._corporal
end

function Squad:members()
	return self._members
end

function Squad:num_members()
	return table.size(self._members)
end

function Squad:set_max_size(max_size)
	self._max_size = max_size
end

function Squad:max_size()
	return self._max_size
end

function Squad:full()
	return self:num_members() == self._max_size
end

function Squad:locked()
	return self._locked
end

function Squad:next_lock_state()
	local next_lock_state = not self._locked

	self:set_squad_lock_state(next_lock_state)

	if Managers.state.network:game() then
		Managers.state.network:send_rpc_server("rpc_change_squad_lock_state", NetworkLookup.team[self._team_name], self._index, next_lock_state)
	end
end

function Squad:set_squad_lock_state(lock_state)
	self._locked = lock_state
end

function Squad:synch(new_player)
	for member, _ in pairs(self._members) do
		RPC.rpc_add_player_to_squad(new_player, member.game_object_id, self._index)
	end

	local team_id = NetworkLookup.team[self._team_name]

	RPC.rpc_change_squad_lock_state(new_player, team_id, self._index, self._locked)

	if self._corporal then
		RPC.rpc_set_squad_corporal(new_player, self._corporal.game_object_id, self._index)
	end

	RPC.rpc_set_max_squad_size(new_player, self._max_size)
end

function Squad:cb_game_session_disconnect()
	self._flag_unit = nil
end

function Squad:_create_squad_flag_unit(flag_unit_name, position, rotation, team_name, squad_id)
	self._flag_unit = {}
	self._flag_unit.unit = World.spawn_unit(self._world, flag_unit_name, position, rotation)

	Managers.state.entity:register_unit(self._world, self._flag_unit.unit, team_name, squad_id)

	return self._flag_unit.unit
end

function Squad:_create_squad_flag_game_object(flag_unit_name, position, rotation, team_id, squad_id)
	local data_table = {
		game_object_created_func = NetworkLookup.game_object_functions.cb_spawn_squad_flag,
		object_destroy_func = NetworkLookup.game_object_functions.cb_destroy_squad_flag_unit,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		husk_unit = NetworkLookup.husks[flag_unit_name],
		position = position,
		rotation = rotation,
		team_name = team_id,
		squad_id = squad_id
	}
	local disconnect_callback = callback(self, "cb_game_session_disconnect")
	local created_callback = "cb_local_unit_spawned"
	local game_object_id = Managers.state.network:create_game_object("squad_flag_unit", data_table, disconnect_callback, created_callback, self._flag_unit.unit)

	self._flag_unit.id = game_object_id
end

function Squad:server_create_squad_flag(team_id, squad_id, position, rotation)
	self:destroy_squad_flag()

	local team_name = NetworkLookup.team[team_id]
	local flag_unit_name = "units/weapons/wpn_squad_flag/wpn_squad_flag_" .. team_name

	self:_create_squad_flag_unit(flag_unit_name, position, rotation, team_name, squad_id)

	if self:player_squad() then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, "hud_squad_place_spawn_flag")
	end

	if Managers.state.network and Managers.state.network:game() and Managers.lobby and Managers.lobby.server then
		self:_create_squad_flag_game_object(flag_unit_name, position, rotation, team_id, squad_id)
		self:_update_squad_game_object(Managers.state.network:game(), "plant_time", Managers.time:time("round"))
	else
		self._plant_time = Managers.time:time("round")
	end
end

function Squad:register_squad_flag(unit, game_object_id)
	self._flag_unit = {
		unit = unit,
		id = game_object_id
	}

	if self:player_squad() then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, "hud_squad_place_spawn_flag")
	end
end

function Squad:unregister_squad_flag(unit, game_object_id)
	self._flag_unit = nil
end

function Squad:destroy_squad_flag()
	if self._flag_unit and Managers.lobby.server then
		Managers.state.network:destroy_game_object(self._flag_unit.id)
	elseif self._flag_unit then
		local unit = self._flag_unit.unit

		Managers.state.entity:unregister_unit(unit)
		World.destroy_unit(self._world, unit)
	end

	self._flag_unit = nil
end

function Squad:squad_flag_unit()
	return self._flag_unit and self._flag_unit.unit or nil
end

function Squad:player_squad()
	for player, _ in pairs(self._members) do
		if player.local_player then
			return true
		end
	end

	return false
end

function Squad:buff_type()
	return self._squad_buff and self._squad_buff.type or SquadSettings.default_buff.type
end

function Squad:buff_level()
	return self._squad_buff and self._squad_buff.level or SquadSettings.default_buff.level
end

function Squad:buff_shape()
	return self._squad_buff and self._squad_buff.shape or SquadSettings.default_buff.shape
end

function Squad:buff_radius()
	return self._squad_buff and self._squad_buff.radius or SquadSettings.default_buff.radius
end
