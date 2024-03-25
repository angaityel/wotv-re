-- chunkname: @scripts/managers/spawn/spawn_manager.lua

require("scripts/settings/player_profiles")
require("scripts/settings/robot_profiles")
require("scripts/managers/spawn/squad_point_spawn_component")

SpawnManager = class(SpawnManager)

local SPAWN_UPWARD_OFFSET = Vector3Box(0, 0, 0.1)
local CHECKED_SQUAD_SPAWN_POINT_POSITIONS = 10
local MAX_SQUAD_SPAWN_DISTANCE = 8
local SPAWN_POINT_COOLDOWN = 0.75
local SPAWN_CHECK_RADIUS = 60
local ENEMY_RADIUS = 20

function SpawnManager:init(world)
	self._world = world
	self._spawn_areas = {}
	self._sp_spawn_area_names = {}
	self._active_spawn_areas_per_team = {}
	self._spawn_area_priority_per_team = {}
	self._highest_spawn_area_priority = {}
	self._point_spawn_point_timers = {}

	for _, team_name in pairs(Managers.state.team:names()) do
		self._active_spawn_areas_per_team[team_name] = {}
		self._spawn_area_priority_per_team[team_name] = {}
		self._highest_spawn_area_priority[team_name] = 1
	end

	self._num_spawn_areas = 0
	self._spawning = false

	Managers.state.event:register(self, "player_knocked_down", "event_player_knocked_down")
	Managers.state.event:register(self, "player_instakilled", "event_player_instakilled")
	Managers.state.event:register(self, "player_unit_dead", "event_player_unit_dead")
	Managers.state.event:register(self, "team_set", "event_team_set")

	self._squad_point_component = SquadPointSpawnComponent:new(self, world)
end

function SpawnManager:flow_cb_add_squad_point(unit)
	self._squad_point_component:flow_cb_add_squad_point(unit)
end

function SpawnManager:event_team_set(player)
	if player.team and (Managers.lobby.server or not Managers.lobby.lobby) then
		self:set_spawn_timer(player)
	end
end

function SpawnManager:event_player_knocked_down(knocked_down_player, attacking_player, gear_name, damagers, damage_type)
	if Managers.lobby.server or not Managers.lobby.lobby then
		self:set_spawn_timer(knocked_down_player)
	end
end

function SpawnManager:event_player_instakilled(instakilled_player, attacking_player, gear_name, damagers, damage_type)
	if Managers.lobby.server or not Managers.lobby.lobby then
		self:set_spawn_timer(instakilled_player)
	end
end

function SpawnManager:event_player_unit_dead(player, position)
	local spawn_data = player.spawn_data

	spawn_data.death_position = nil

	local pos_box = Vector3Box()

	pos_box:store(position)

	spawn_data.death_position = pos_box
	spawn_data.state = "dead"
	spawn_data.mode = nil
end

function SpawnManager:set_spawn_timer(player)
	local spawn_timer = Managers.state.game_mode:next_spawn_time(player)

	player.spawn_data.timer = spawn_timer

	local game = Managers.state.network:game()

	if player.game_object_id and game then
		if spawn_timer == math.huge then
			spawn_timer = -1
		end

		GameSession.set_game_object_field(game, player.game_object_id, "spawn_timer", spawn_timer)
	end
end

function SpawnManager:destroy()
	return
end

function SpawnManager:activate_editor_spawnpoint(unit)
	self._editor_spawn_point = unit
end

function SpawnManager:create_spawn_area(name, volumes)
	fassert(not self._spawn_areas[name], "Trying to create spawn area with name %s but there already exists a spawn with such a name.", name)

	local spawn_area_index = self._num_spawn_areas + 1
	local level = LevelHelper:current_level(self._world)
	local pos = Vector3(0, 0, 0)

	for _, volume in ipairs(volumes) do
		pos = pos + Level.random_point_inside_volume(level, volume)
	end

	pos = pos / #volumes
	self._spawn_areas[name] = {
		volumes = volumes,
		network_lookup = spawn_area_index,
		position = Vector3Box(pos),
		spawn_rotations = {}
	}
	self._num_spawn_areas = spawn_area_index
end

function SpawnManager:activate_spawn_area(name, team_name, spawn_direction)
	if self._active_spawn_areas_per_team[team_name][name] then
		printf("Trying to activate spawn area %s for side %s that is already activated.", name, team_name)
	end

	fassert(self._spawn_areas[name], "Trying to activate spawn area %s that doesn't exist.", name)

	self._active_spawn_areas_per_team[team_name][name] = true

	local lobby_manager = Managers.lobby
	local multiplayer = lobby_manager.lobby
	local server = lobby_manager.server
	local spawn_area

	if not multiplayer or server then
		spawn_area = self._spawn_areas[name]
		spawn_area.spawn_rotations[team_name] = QuaternionBox(Quaternion.look(Vector3.flat(spawn_direction), Vector3.up()))
	end

	if server then
		Managers.state.network:send_rpc_clients("rpc_activate_spawn_area", spawn_area.network_lookup, NetworkLookup.team[team_name])
	end
end

function SpawnManager:deactivate_spawn_area(name, team_name)
	if not self._active_spawn_areas_per_team[team_name][name] then
		printf("Trying to deactivate spawn area %s for side %s that is already deactivated.", name, team_name)
	end

	fassert(self._spawn_areas[name], "Trying to deactivate spawn area %s that doesn't exist.", name)

	self._active_spawn_areas_per_team[team_name][name] = nil

	if Managers.lobby.server then
		local spawn_area = self._spawn_areas[name]

		Managers.state.network:send_rpc_clients("rpc_deactivate_spawn_area", spawn_area.network_lookup, NetworkLookup.team[team_name])
	end
end

function SpawnManager:activate_sp_spawn_area(name, team_name, spawn_direction, spawn_profile)
	if self._active_spawn_areas_per_team[team_name][name] then
		printf("Trying to activate spawn area %s for side %s that is already activated.", name, team_name)
	end

	fassert(self._spawn_areas[name], "Trying to activate spawn area %s that doesn't exist.", name)

	self._active_spawn_areas_per_team[team_name][name] = true

	local spawn_area = self._spawn_areas[name]

	spawn_area.spawn_rotations[team_name] = QuaternionBox(Quaternion.look(Vector3.flat(spawn_direction), Vector3.up()))
	spawn_area.spawn_profile = spawn_profile
	self._sp_spawn_area_names[#self._sp_spawn_area_names + 1] = name
end

function SpawnManager:deactivate_sp_spawn_area(name, team_name)
	if not self._active_spawn_areas_per_team[team_name][name] then
		printf("Trying to deactivate spawn area %s for side %s that is already deactivated.", name, team_name)
	end

	fassert(self._spawn_areas[name], "Trying to deactivate spawn area %s that doesn't exist.", name)

	self._active_spawn_areas_per_team[team_name][name] = nil

	for key, area_name in ipairs(self._sp_spawn_area_names) do
		if name == area_name then
			table.remove(self._sp_spawn_area_names, key)
		end
	end
end

function SpawnManager:set_spawn_area_priority(name, team_name, priority)
	fassert(self._spawn_areas[name], "Trying to activate spawn area %s that doesn't exist.", name)

	for prio, areas in pairs(self._spawn_area_priority_per_team[team_name]) do
		if areas[name] then
			areas[name] = nil

			break
		end
	end

	self._spawn_area_priority_per_team[team_name][priority] = self._spawn_area_priority_per_team[team_name][priority] or {}
	self._spawn_area_priority_per_team[team_name][priority][name] = true

	if priority > self._highest_spawn_area_priority[team_name] then
		self._highest_spawn_area_priority[team_name] = priority
	end

	if Managers.lobby.server then
		Managers.state.network:send_rpc_clients("rpc_set_spawn_area_priority", self._spawn_areas[name].network_lookup, NetworkLookup.team[team_name], priority)
	end
end

function SpawnManager:spawn_area_with_highest_priority(team_name)
	local active_areas = {}

	for i = self._highest_spawn_area_priority[team_name], 1, -1 do
		local areas = self._spawn_area_priority_per_team[team_name][i]

		if areas and table.size(areas) > 0 then
			local found_area

			for area_name, _ in pairs(areas) do
				if self._active_spawn_areas_per_team[team_name][area_name] then
					active_areas[#active_areas + 1] = area_name
					found_area = true
				end
			end

			if found_area then
				break
			end
		end
	end

	local num_active_areas = #active_areas

	if num_active_areas > 0 then
		return active_areas[Math.random(1, num_active_areas)]
	end

	return nil
end

function SpawnManager:random_area_name(team_name)
	local active_areas = {}

	for area_name, _ in pairs(self._active_spawn_areas_per_team[team_name]) do
		active_areas[#active_areas + 1] = area_name
	end

	local num_active_areas = #active_areas

	if num_active_areas > 0 then
		return active_areas[Math.random(1, num_active_areas)]
	end
end

function SpawnManager:activate_spawning()
	self._spawning = true
end

function SpawnManager:deactivate_spawning()
	self._spawning = false
end

function SpawnManager:spawn_areas()
	return self._spawn_areas
end

function SpawnManager:active_spawn_areas(team_name)
	return self._active_spawn_areas_per_team[team_name]
end

function SpawnManager:valid_point_spawn_target(player, spawn_point_unit, randomly_spawned)
	local timer = self._point_spawn_point_timers[spawn_point_unit]
	local spawn_blocker_nearby, blocker_type = self:_enemies_or_inactive_spawn_nearby(player, spawn_point_unit)
	local unit_alive = Unit.alive(spawn_point_unit)
	local valid_spawn = randomly_spawned and unit_alive or unit_alive and not timer and not spawn_blocker_nearby
	local invalid_reason = timer and "spawn point on cooldown" or blocker_type == "enemy" and "enemy nearby" or blocker_type == "locked_spawn_point" and "locked spawn point nearby"

	return valid_spawn, invalid_reason
end

function SpawnManager:_enemies_or_inactive_spawn_nearby(player, spawn_point_unit)
	local spawn_blocker_nearby = false
	local blocker_type
	local position = Unit.world_position(spawn_point_unit, 0)
	local physics_world = World.physics_world(self._world)
	local units_close = PhysicsWorld.overlap(physics_world, nil, "shape", "sphere", "position", position, "size", ENEMY_RADIUS, "types", "both", "collision_filter", "spawn_blocking_overlap")

	for _, actor in ipairs(units_close) do
		local unit = Actor.unit(actor)
		local owner = Managers.player:owner(unit)
		local damage_ext = ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")
		local disabled_team = Unit.get_data(unit, "disabled_team")

		if owner and owner.team and owner.team ~= player.team and damage_ext and damage_ext:is_alive() then
			spawn_blocker_nearby = true
			blocker_type = "enemy"

			break
		elseif disabled_team and disabled_team == player.team.name then
			spawn_blocker_nearby = true
			blocker_type = "locked_spawn_point"

			break
		end
	end

	return spawn_blocker_nearby, blocker_type
end

function SpawnManager:set_point_spawn_target(player, spawn_point_unit, randomly_spawned, spawn_target_pos)
	local spawn_data = player.spawn_data

	spawn_data.needs_spawn = false

	if Managers.lobby.server or not Managers.lobby.lobby then
		local valid_spawn, invalid_reason = self:valid_point_spawn_target(player, spawn_point_unit, randomly_spawned)

		if not valid_spawn then
			if Managers.state.network:game() then
				RPC.rpc_spawn_target_denied(player:network_id())

				if GameSettingsDevelopment.tdm_spawning_debug then
					print("Player Spawn Invalid", player:name(), Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0), randomly_spawned, invalid_reason)
				end
			end

			return
		end

		if spawn_data.state == "ghost_mode" then
			self:despawn_player_unit(player)
		end

		local round_time = Managers.time:time("round")

		spawn_data.mode = "point"
		spawn_data.spawn_point_unit = spawn_point_unit
		spawn_data.spawn_confirmation_time = round_time
		spawn_data.look_pos = Vector3Box(spawn_target_pos)

		if GameSettingsDevelopment.tdm_spawning_debug then
			print("Player Spawn Valid, Spawn Disabled On Server", player:name(), Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
		end

		self:_disable_point_spawn_point(player, spawn_point_unit, round_time)
	elseif Managers.state.network:game() then
		spawn_data.mode = "unconfirmed_point"
		spawn_data.spawn_point_unit = spawn_point_unit

		local unit_level_object_id = Managers.state.network:level_object_id(spawn_point_unit)

		Managers.state.network:send_rpc_server("rpc_request_point_spawn_target", player:player_id(), unit_level_object_id, randomly_spawned, spawn_target_pos)

		if GameSettingsDevelopment.tdm_spawning_debug then
			print("Player Requesting Spawn From Server", player:name(), Managers.time:time("round"))
		end
	end
end

function SpawnManager:_disable_point_spawn_point(player, spawn_point_unit, spawn_confirmation_time)
	self._point_spawn_point_timers[spawn_point_unit] = spawn_confirmation_time + SPAWN_POINT_COOLDOWN

	if Unit.find_actor(spawn_point_unit, "inactive_spawn_point") then
		Unit.create_actor(spawn_point_unit, "inactive_spawn_point")
	end

	local team = player.team
	local enemy_team_name = team.name == "red" and "white" or "red"

	Unit.set_data(spawn_point_unit, "disabled_team", enemy_team_name)
end

function SpawnManager:rpc_request_point_spawn_target(player, spawn_point_unit, randomly_spawned, spawn_target_pos)
	self:set_point_spawn_target(player, spawn_point_unit, randomly_spawned, spawn_target_pos)
end

function SpawnManager:rpc_request_squad_point_spawn_target(player)
	self._squad_point_component:set_spawn_target(player)
end

function SpawnManager:set_area_spawn_target(player, area_name)
	local spawn_data = player.spawn_data

	spawn_data.needs_spawn = false

	if Managers.lobby.server or not Managers.lobby.lobby then
		if not self:valid_area_spawn_target(player, area_name) then
			if Managers.state.network:game() then
				RPC.rpc_spawn_target_denied(player:network_id())
			end

			return
		end

		if spawn_data.state == "ghost_mode" then
			self:despawn_player_unit(player)
		end

		spawn_data.mode = "area"
		spawn_data.area_name = area_name
	elseif Managers.state.network:game() then
		spawn_data.mode = "unconfirmed_area"
		spawn_data.area_name = area_name

		Managers.state.network:send_rpc_server("rpc_request_area_spawn_target", player.temp_random_user_id, self._spawn_areas[area_name].network_lookup)
	end
end

function SpawnManager:rpc_request_area_spawn_target(player, area_name_network_lookup)
	local area_name = self:network_lookup_to_area_name(area_name_network_lookup)

	self:set_area_spawn_target(player, area_name)
end

function SpawnManager:network_lookup_to_area_name(network_lookup)
	for area_name, area in pairs(self._spawn_areas) do
		if area.network_lookup == network_lookup then
			return area_name
		end
	end

	ferror("[SpawnManager] Can't find area with lookup %s.", network_lookup)
end

function SpawnManager:update(dt, t)
	local id = Profiler.start("SpawnManager:update(dt,t)")
	local round_timer = Managers.time:time("round")

	for spawn_point_unit, timer in pairs(self._point_spawn_point_timers) do
		if timer < round_timer then
			if Unit.find_actor(spawn_point_unit, "inactive_spawn_point") then
				Unit.destroy_actor(spawn_point_unit, "inactive_spawn_point")
			end

			Unit.set_data(spawn_point_unit, "disabled_team", nil)

			self._point_spawn_point_timers[spawn_point_unit] = nil

			if GameSettingsDevelopment.tdm_spawning_debug then
				if Managers.lobby.server then
					print("Spawn Enabled Server", Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
				else
					print("Spawn Enabled Client", Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
				end
			end
		end
	end

	if Managers.lobby.server or not Managers.lobby.lobby then
		if EDITOR_LAUNCH then
			self:_update_spawn_editor_simulation(dt, t)
		else
			self:_update_spawn(dt, round_timer)
		end
	end

	Profiler.stop(id)
end

function SpawnManager:update_player(player, dt, t, input)
	local spawn_data = player.spawn_data

	if input and spawn_data.state == "ghost_mode" and player.team and input:get("next_spawn") then
		Managers.state.spawn:next_spawn(player)
	end

	if spawn_data.needs_spawn then
		self:request_spawn(player, false)
	end
end

function SpawnManager:request_spawn(player, first_request)
	if EDITOR_LAUNCH then
		return
	end

	local scope_name = "SpawnManager:request_spawn()"
	local id = Profiler.start(scope_name)
	local spawn_data = player.spawn_data

	if not player.team then
		spawn_data.needs_spawn = true

		Profiler.stop(id)

		return
	end

	local last_spawn_mode = spawn_data.last_spawn_mode
	local allowed_spawn_modes = Managers.state.game_mode:allowed_spawn_modes(player)
	local spawn_mode

	if allowed_spawn_modes[last_spawn_mode] then
		spawn_mode = last_spawn_mode
	else
		for mode, active in pairs(allowed_spawn_modes) do
			if active then
				spawn_mode = mode

				break
			end
		end
	end

	if spawn_mode == "area" then
		local team_name = player.team.name
		local area = self:game_mode_specific_spawn_area(player, Managers.state.game_mode:game_mode_key(), team_name) or self:spawn_area_with_highest_priority(team_name) or self:random_active_spawn_area(team_name)

		if area then
			self:set_area_spawn_target(player, area)
		else
			spawn_data.needs_spawn = true
		end
	elseif spawn_mode == "point" then
		local spawn_point_unit, randomly_spawned, spawn_target = self:find_spawn_point_for_player(player, first_request)

		if spawn_point_unit then
			local spawn_target_pos = spawn_target and Unit.world_position(spawn_target, 0) or self:_spawn_point_offset_position(spawn_point_unit, 10)

			self:set_point_spawn_target(player, spawn_point_unit, randomly_spawned, spawn_target_pos)
		else
			spawn_data.needs_spawn = true
		end
	elseif spawn_mode == "squad_point" then
		self._squad_point_component:request_spawn(player)
	end

	Profiler.stop(id)
end

function SpawnManager:game_mode_specific_spawn_area(player, game_mode_key, team_name)
	local areas = self._active_spawn_areas_per_team[team_name]
	local spawn_area

	if game_mode_key == "domination" and player.spawn_data.death_position then
		local closest_distance = math.huge

		for area_name, active in pairs(areas) do
			if active then
				local level = LevelHelper:current_level(self._world)
				local area = self._spawn_areas[area_name]
				local volumes = area.volumes
				local volume = #volumes == 1 and volumes[1] or volumes[Math.random(#volumes)]
				local position = Level.random_point_inside_volume(level, volume)
				local death_pos = player.spawn_data.death_position:unbox()
				local distance = Vector3.distance(position, death_pos)

				if distance < closest_distance then
					spawn_area = area_name
					closest_distance = distance
				end
			end
		end
	end

	return spawn_area
end

function SpawnManager:find_spawn_point_for_player(player, first_request)
	local team = player.team
	local team_name = team.name
	local squad = team:squad(player.squad_index)

	if first_request then
		local spawn_targets = {}

		if squad then
			self:_add_squad_corporal_to_targets(player, squad, spawn_targets)
			self:_add_squad_members_to_targets(player, squad, spawn_targets)
		end

		self:_add_team_members_to_targets(player, spawn_targets)
		self:_add_enemies_to_targets(player, spawn_targets)

		player.spawn_data.spawn_targets = spawn_targets
		player.spawn_data.spawn_target_index = 1
	end

	local spawn_data = player.spawn_data
	local spawn_targets = spawn_data.spawn_targets
	local spawn_target_index = spawn_data.spawn_target_index
	local spawn_point, spawn_target
	local randomly_spawned = false

	if spawn_target_index <= #spawn_targets then
		spawn_target = spawn_targets[spawn_target_index]

		if Unit.alive(spawn_target) and ScriptUnit.has_extension(spawn_target, "damage_system") and ScriptUnit.extension(spawn_target, "damage_system"):is_alive() then
			spawn_point = self:_find_closest_spawn_point(player, spawn_target)
		end
	else
		spawn_point = self:_random_spawn_point(player)
		randomly_spawned = true
	end

	player.spawn_data.spawn_target_index = spawn_target_index + 1

	return spawn_point, randomly_spawned, spawn_target
end

function SpawnManager:_add_squad_corporal_to_targets(player, squad, targets)
	local corporal = squad:corporal()

	if corporal and corporal ~= player then
		local unit = corporal.player_unit

		if Unit.alive(unit) then
			targets[#targets + 1] = unit
		end
	end
end

function SpawnManager:_add_squad_members_to_targets(player, squad, targets)
	local corporal = squad:corporal()
	local members = squad:members()

	for squad_member, _ in pairs(members) do
		if squad_member ~= corporal and squad_member ~= player then
			local unit = squad_member.player_unit

			if Unit.alive(unit) then
				targets[#targets + 1] = unit
			end
		end
	end
end

function SpawnManager:_add_team_members_to_targets(player, targets)
	local team_members = player.team:get_members()

	for _, team_member in pairs(team_members) do
		if team_member ~= player and (team_member.squad_index ~= player.squad_index or not player.squad_index) then
			local unit = team_member.player_unit

			if Unit.alive(unit) then
				targets[#targets + 1] = unit
			end
		end
	end
end

function SpawnManager:_add_enemies_to_targets(player, targets)
	local team_manager = Managers.state.team
	local sides = team_manager:sides()

	for _, side in pairs(sides) do
		if player.team.side ~= side then
			local team_members = team_manager:team_by_side(side):get_members()

			for _, team_member in pairs(team_members) do
				local unit = team_member.player_unit

				if Unit.alive(unit) then
					targets[#targets + 1] = unit
				end
			end
		end
	end
end

function SpawnManager:_find_closest_spawn_point(player, unit)
	if not unit then
		return
	end

	local position = Unit.world_position(unit, 0)
	local physics_world = World.physics_world(self._world)
	local spawn_points = PhysicsWorld.overlap(physics_world, nil, "shape", "sphere", "position", position, "size", SPAWN_CHECK_RADIUS, "types", "statics", "collision_filter", "spawn_point_overlap")
	local round_timer = Managers.time:time("round")
	local timers = self._point_spawn_point_timers

	table.sort(spawn_points, function(actor1, actor2)
		return Vector3.length(position - Actor.position(actor1)) < Vector3.length(position - Actor.position(actor2))
	end)

	for _, point in ipairs(spawn_points) do
		local spawn_point_unit = Actor.unit(point)
		local timer = timers[spawn_point_unit]
		local spawn_blocker_nearby = self:_enemies_or_inactive_spawn_nearby(player, spawn_point_unit)

		if not timer and not spawn_blocker_nearby then
			if GameSettingsDevelopment.tdm_spawning_debug then
				print("Client Found Spawn Point", player:name(), Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
			end

			return spawn_point_unit
		end
	end
end

function SpawnManager:_random_spawn_point(player)
	local physics_world = World.physics_world(self._world)
	local spawn_points = PhysicsWorld.overlap(physics_world, nil, "shape", "sphere", "position", Vector3(0, 0, 0), "size", Vector3(3000, 3000, 3000), "types", "statics", "collision_filter", "spawn_point_overlap")

	if #spawn_points > 0 then
		if script_data.spawn_debug then
			print("RANDOM POINT")
		end

		local point = spawn_points[Math.random(1, #spawn_points)]
		local spawn_point_unit = Actor.unit(point)

		if GameSettingsDevelopment.tdm_spawning_debug then
			print("Client Spawned Randomly", player:name(), Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
		end

		return spawn_point_unit
	end
end

function SpawnManager:random_active_spawn_area(team_name)
	local areas = self._active_spawn_areas_per_team[team_name]
	local num_areas = 0

	for _, active in pairs(areas) do
		if active then
			num_areas = num_areas + 1
		end
	end

	if num_areas <= 0 then
		return nil
	end

	local random_area = Math.random(num_areas)
	local area_number = 0

	for area_name, active in pairs(areas) do
		if active then
			area_number = area_number + 1
		end

		if area_number == random_area then
			return area_name
		end
	end
end

function SpawnManager:next_spawn(player)
	local spawn_data = player.spawn_data
	local last_spawn_mode = spawn_data.last_spawn_mode

	if last_spawn_mode == "area" then
		local last_area = spawn_data.area_name
		local team_name = player.team.name
		local area = last_area and (self:next_prioritized_area(last_area, team_name) or self:next_area(last_area, team_name)) or self:spawn_area_with_highest_priority(team_name) or self:random_active_spawn_area(team_name)

		if area and area ~= last_area then
			if script_data.spawn_debug then
				print("AREA NAME:", area, last_area)
			end

			self:set_area_spawn_target(player, area)
		end
	end
end

function SpawnManager:next_prioritized_area(last_area, team_name)
	local highest_active_area

	for i = self._highest_spawn_area_priority[team_name], 1, -1 do
		local areas = self._spawn_area_priority_per_team[team_name][i]

		if areas and table.size(areas) > 0 then
			local found_area, found_last_area

			for area_name, _ in pairs(areas) do
				if area_name == last_area then
					found_last_area = true
				elseif found_last_area and self._active_spawn_areas_per_team[team_name][area_name] then
					found_area = true
				else
					highest_active_area = highest_active_area or area_name
				end
			end

			if found_area then
				return area_name
			end
		end
	end
end

function SpawnManager:next_area(last_area, team_name)
	local found_area = false
	local first_area

	for area_name, active in pairs(self._active_spawn_areas_per_team[team_name]) do
		if area_name == last_area then
			found_area = true
		elseif found_area and active then
			return area_name
		elseif active then
			first_area = first_area or area_name
		end
	end

	return first_area
end

function SpawnManager:spawn_target_denied(player)
	self:request_spawn(player, true)
end

function SpawnManager:_update_spawn(dt, t)
	local network_game = Managers.state.network:game()

	if Managers.lobby.lobby and (not network_game or not Managers.lobby.server) or self._spawning == false then
		return
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for player_index, player in pairs(players) do
		if not player.ai_player then
			local spawn_data = player.spawn_data

			if spawn_data.timer == math.huge then
				self:set_spawn_timer(player)
			end

			if spawn_data.state == "not_spawned" or spawn_data.state == "dead" then
				self:_check_spawn(player, spawn_data)

				if not Managers.state.game_mode:squad_screen_spawning() then
					self:_update_sp_spawn(spawn_data)
				end

				if spawn_data.mode == "squad_point" and self._squad_point_component:can_spawn(player) then
					self._squad_point_component:spawn(player)
				elseif spawn_data.mode == "area" and spawn_data.area_name then
					local ghost_mode = not (not GameSettingsDevelopment.sp_spawn_in_ghost_mode and not Managers.lobby.lobby) and true or false

					self:_spawn_player_unit_in_area(player, spawn_data.area_name, ghost_mode)
				elseif spawn_data.mode == "point" and spawn_data.spawn_point_unit then
					if t >= spawn_data.timer then
						self:_spawn_player_unit_at_unit(player, spawn_data.spawn_point_unit)
						self:_notify_players_of_point_spawn(player, spawn_data.spawn_point_unit, spawn_data.spawn_confirmation_time)
					end
				elseif spawn_data.mode == "squad_member" and t >= spawn_data.timer then
					local spawn_unit = Unit.alive(spawn_data.squad_unit) and spawn_data.squad_unit

					if spawn_unit then
						self:_spawn_player_unit_at_unit(player, spawn_unit)
					end
				end
			elseif spawn_data.state == "ghost_mode" then
				self:_check_spawn(player, spawn_data)
			end
		end
	end
end

function SpawnManager:_notify_players_of_point_spawn(player, spawn_point_unit, spawn_confirmation_time)
	local level = LevelHelper:current_level(self._world)
	local unit_level_index = Level.unit_index(level, spawn_point_unit)

	if GameSettingsDevelopment.tdm_spawning_debug then
		print("Player Point Spawned Notification Server", player:name(), Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
	end

	Managers.state.network:send_rpc_clients("rpc_player_point_spawned", player:player_id(), unit_level_index, spawn_confirmation_time)
end

function SpawnManager:rpc_player_point_spawned(player, spawn_point_unit, spawn_confirmation_time)
	if GameSettingsDevelopment.tdm_spawning_debug then
		print("Spawn Disabled on Client", Managers.time:time("round"), Unit.world_position(spawn_point_unit, 0))
	end

	self:_disable_point_spawn_point(player, spawn_point_unit, spawn_confirmation_time)
end

function SpawnManager:force_spawn()
	local network_game = Managers.state.network:game()

	if Managers.lobby.lobby and (not network_game or not Managers.lobby.server) then
		return
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for player_index, player in pairs(players) do
		if not player.ai_player then
			local spawn_data = player.spawn_data

			if spawn_data.state == "not_spawned" or spawn_data.state == "dead" then
				self:_check_spawn(player, spawn_data)

				if not Managers.state.game_mode:squad_screen_spawning() then
					self:_update_sp_spawn(spawn_data)
				end

				if spawn_data.mode == "area" and spawn_data.area_name then
					self:_spawn_player_unit_in_area(player, spawn_data.area_name, false)
				elseif spawn_data.mode == "squad_member" then
					self:_spawn_player_unit_at_unit(player, spawn_data.squad_unit, false)
				elseif player.team and player.team.name ~= "unassigned" then
					local random_area = self:random_area_name(player.team.name)

					self:_spawn_player_unit_in_area(player, random_area, false)
				end
			elseif spawn_data.state == "ghost_mode" then
				self:_check_spawn(player, spawn_data)

				if spawn_data.mode == "area" then
					self:_force_leave_ghost_mode(player)
				end
			end
		end
	end
end

function SpawnManager:_update_sp_spawn(spawn_data)
	local sp_spawn_area_amount = #self._sp_spawn_area_names

	if spawn_data.mode ~= "area" and sp_spawn_area_amount >= 1 then
		spawn_data.mode = "area"
		spawn_data.area_name = self._sp_spawn_area_names[Math.random(1, sp_spawn_area_amount)]

		local level = LevelHelper:current_level(self._world)

		Level.trigger_event(level, "sp_player_spawned")
	end
end

function SpawnManager:spawn_timer(player)
	local t = Managers.time:time("round")

	if t then
		if Managers.lobby.server or not Managers.lobby.lobby then
			if player.spawn_data.timer then
				return player.spawn_data.timer - t
			end
		elseif Managers.state.network:game() then
			local spawn_timer = GameSession.game_object_field(Managers.state.network:game(), player.game_object_id, "spawn_timer")

			if spawn_timer == -1 then
				spawn_timer = math.huge
			end

			return spawn_timer - t
		end
	end
end

function SpawnManager:allowed_to_leave_ghost_mode(player)
	local robot_player = GameSettingsDevelopment.enable_robot_player and player.spawn_data.state == "ghost_mode"
	local ready_to_spawn = player.spawn_data.state == "ghost_mode" and Managers.time:time("round") >= 0 and self:spawn_timer(player) <= 0

	return robot_player or ready_to_spawn
end

function SpawnManager:request_leave_ghost_mode(player, ghost_player_unit)
	if Managers.lobby.server or not Managers.lobby.lobby then
		self:_leave_ghost_mode(player, ghost_player_unit)
	else
		Managers.state.network:send_rpc_server("rpc_request_leave_ghost_mode", player:player_id(), Managers.state.network:game_object_id(ghost_player_unit))
	end
end

function SpawnManager:_leave_ghost_mode(player, ghost_player_unit)
	player.spawn_data.state = "spawned"
	player.spawn_data.spawns = player.spawn_data.spawns + 1

	local locomotion = ScriptUnit.extension(ghost_player_unit, "locomotion_system")

	locomotion:blend_out_of_ghost_mode()
	LevelHelper:flow_event(self._world, "player_unit_spawned")

	if GameSettingsDevelopment.enable_robot_player then
		local profile_name = Unit.get_data(ghost_player_unit, "player_profile")
		local profile = RobotProfiles[profile_name]

		Managers.input:start_script_input(profile.script_input, true)
	end
end

function SpawnManager:_force_leave_ghost_mode(player)
	if player.remote then
		player.spawn_data.state = "spawned"
		player.spawn_data.spawns = player.spawn_data.spawns + 1

		RPC.rpc_leave_ghost_mode(player:network_id(), player:player_id())
	elseif Unit.alive(player.player_unit) then
		self:_leave_ghost_mode(player, player.player_unit)
	end
end

function SpawnManager:rpc_request_leave_ghost_mode(sender, player, ghost_player_unit)
	if self:allowed_to_leave_ghost_mode(player) then
		player.spawn_data.state = "spawned"
		player.spawn_data.spawns = player.spawn_data.spawns + 1

		RPC.rpc_leave_ghost_mode(sender, player:player_id())
	end
end

function SpawnManager:rpc_leave_ghost_mode(player, player_unit)
	self:_leave_ghost_mode(player, player_unit)
end

function SpawnManager:_check_spawn(player, spawn_data)
	if spawn_data.mode == "area" then
		if not self:valid_area_spawn_target(player, spawn_data.area_name) then
			spawn_data.mode = nil

			if Managers.lobby.lobby then
				RPC.rpc_spawn_target_denied(player:network_id())
			end
		end
	elseif spawn_data.mode == "squad_point" and not self._squad_point_component:valid_spawn_target(player, spawn_data.spawn_squad_point_unit) then
		spawn_data.mode = nil

		if Managers.lobby.lobby then
			RPC.rpc_spawn_target_denied(player:network_id())
		end
	end
end

function SpawnManager:valid_squad_flag_spawn_target(player, flag_unit, verbose)
	if not Managers.state.game_mode:allow_flag_spawn() then
		return false
	end

	local player_team = player.team
	local squad_index = player.squad_index

	if not squad_index or not player_team.squads[squad_index] then
		return false
	end

	local squad_spawn_mode = Managers.state.game_mode:squad_spawn_mode(player_team)

	if squad_spawn_mode == "off" then
		return false
	end

	if player.spawn_data.spawns >= Managers.state.game_mode:allowed_spawns(player.team) then
		return false
	end

	local squad = player_team.squads[squad_index]

	if squad:squad_flag_unit() ~= flag_unit then
		if verbose then
			print("[SpawnManager:valid_squad_flag_spawn_target] SPAWN DENIED!", "squad:squad_flag_unit() ~= flag_unit:", squad:squad_flag_unit() ~= flag_unit)
		end

		return false
	end

	if not Unit.alive(flag_unit) then
		if verbose then
			print("[SpawnManager:valid_squad_flag_spawn_target] SPAWN DENIED!", "not Unit.alive( squad_unit ):", not Unit.alive(flag_unit))
		end

		return false
	end

	return true
end

function SpawnManager:valid_squad_spawn_target(player, squad_unit, verbose)
	local player_team = player.team
	local squad_spawn_mode = Managers.state.game_mode:squad_spawn_mode(player_team)

	if squad_spawn_mode == "off" then
		return false
	end

	if player.spawn_data.spawns >= Managers.state.game_mode:allowed_spawns(player.team) then
		return false
	end

	local squad_member = Managers.player:owner(squad_unit)

	if not squad_member or not squad_member.is_corporal or not player_team or player_team ~= squad_member.team or player.squad_index ~= squad_member.squad_index or player == squad_member then
		if verbose and squad_member then
			print("[SpawnManager:valid_squad_spawn_target] SPAWN DENIED!", "squad_member:", squad_member, "squad_member.is_corporal:", squad_member.is_corporal, "player.team:", player.team, "player.team == squad_member.team:", player_team == squad_member.team, "player.squad_index == squad_member.squad_index:", player.squad_index == squad_member.squad_index, "player ~= squad_member", player ~= squad_member)
		elseif verbose then
			print("[SpawnManager:valid_squad_spawn_target] SPAWN DENIED! squad_member == ", squad_member)
		end

		return false
	end

	if not Unit.alive(squad_unit) then
		if verbose then
			print("[SpawnManager:valid_squad_spawn_target] SPAWN DENIED!", "not Unit.alive( squad_unit ):", not Unit.alive(squad_unit))
		end

		return false
	end

	local damage_system = ScriptUnit.extension(squad_unit, "damage_system")
	local locomotion_system = ScriptUnit.extension(squad_unit, "locomotion_system")

	if damage_system:is_knocked_down() or damage_system:is_dead() or locomotion_system.ghost_mode then
		if verbose then
			print("[SpawnManager:valid_squad_spawn_target] SPAWN DENIED!", "damage_system:is_knocked_down():", damage_system:is_knocked_down(), "damage_system:is_dead():", damage_system:is_dead(), "locomotion_system.ghost_mode:", locomotion_system.ghost_mode)
		end

		return false
	end

	return true
end

function SpawnManager:valid_area_spawn_target(player, area_name)
	local allowed_spawns = Managers.state.game_mode:allowed_spawns(player.team)
	local spawns = player.spawn_data.spawns

	if allowed_spawns <= spawns then
		return false
	end

	if player.team and self._active_spawn_areas_per_team[player.team.name][area_name] then
		return true
	end
end

function SpawnManager:valid_spawn_areas_per_team(team_name)
	return self._active_spawn_areas_per_team[team_name]
end

function SpawnManager:valid_squad_spawn_targets_per_team(team_name)
	local team = Managers.state.team:team_by_name(team_name)
	local valid_targets = {}

	for _, squad in pairs(team.squads) do
		local corporal = squad:corporal()

		if corporal then
			local corporal_unit = corporal.player_unit

			if Unit.alive(corporal_unit) then
				local damage_system = ScriptUnit.extension(corporal_unit, "damage_system")
				local locomotion_system = ScriptUnit.extension(corporal_unit, "locomotion_system")

				if not damage_system:is_knocked_down() and not damage_system:is_dead() and not locomotion_system.ghost_mode then
					valid_targets[#valid_targets + 1] = corporal
				end
			end
		end
	end

	return valid_targets
end

function SpawnManager:_spawn_player_unit_in_area(player, area_name, ghost_mode)
	local poly, spawn_point
	local world = self._world
	local physics_world = World.physics_world(world)
	local level = LevelHelper:current_level(world)
	local nav_mesh = Level.navigation_mesh(level)
	local area = self._spawn_areas[area_name]
	local profile = area.spawn_profile
	local volumes = area.volumes
	local volume, drawer

	if script_data.spawn_debug then
		drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "spawn_debug"
		})
	end

	local count = 1
	local pos

	while not poly and count < 25 do
		volume = #volumes == 1 and volumes[1] or volumes[Math.random(#volumes)]
		spawn_point = Level.random_point_inside_volume(level, volume)
		poly = NavigationMesh.find_polygon(nav_mesh, spawn_point)
		count = count + 1

		if poly then
			pos = NavigationMesh.project_to_polygon(nav_mesh, spawn_point, poly) + SPAWN_UPWARD_OFFSET:unbox()

			local hits = PhysicsWorld.overlap(physics_world, nil, "shape", "capsule", "position", pos + Vector3(0, 0, 0.675), "size", Vector3(0.49, 0.49, 0.675), "types", "statics", "collision_filter", "ghost_mode_mover")

			if #hits > 0 then
				if script_data.spawn_debug then
					drawer:capsule(pos, pos + Vector3(0, 0, 1.35), 0.49, Color(255, 0, 0))
				end

				poly = nil
			end

			if script_data.spawn_debug then
				drawer:capsule(pos, pos + Vector3(0, 0, 1.35), 0.49, Color(50, 50, 50))
			end
		end
	end

	if not poly then
		print("[SpawnManager] No valid spawn found at spawn", area_name, " check nav graph at location.")

		if GameSettingsDevelopment.prototype_spawn_fallback then
			local rot = QuaternionBox.unbox(area.spawn_rotations[player.team.name])

			self:_spawn_player_unit(player, spawn_point, rot, ghost_mode, profile)
		end

		return
	end

	local rot = QuaternionBox.unbox(area.spawn_rotations[player.team.name] or QuaternionBox())

	if script_data.spawn_debug then
		print("Spawn:", rot, Quaternion.forward(rot))
	end

	self:_spawn_player_unit(player, pos, rot, ghost_mode, profile)
	Managers.state.event:trigger("player_spawned_in_area", player, pos)
end

function SpawnManager:_spawn_player_unit_at_unit(player, unit, override_combat_check, ghost_mode)
	local spawn_data = player.spawn_data
	local spawn_pos = Unit.local_position(unit, 0)
	local look_pos = spawn_data.look_pos and spawn_data.look_pos:unbox() or self:_spawn_point_offset_position(unit, 10)
	local rotation = Quaternion.look(Vector3.flat(look_pos - spawn_pos), Vector3.up())

	self:_spawn_player_unit(player, spawn_pos, rotation, ghost_mode or false)

	if spawn_data.mode == "squad_member" then
		Managers.state.event:trigger("player_spawned_at_unit", player, squad_player, player_pos)
	end
end

function SpawnManager:_spawn_point_offset_position(unit, offset)
	local rotation = Unit.local_rotation(unit, 0)
	local position = Unit.local_position(unit, 0)
	local forward = Quaternion.forward(rotation)

	return position + forward * offset
end

function SpawnManager:_squad_spawn_sanity_check(pos, squad_unit_pos)
	local world = self._world
	local physics_world = World.physics_world(world)
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "spawn_debug"
	})
	local hits = PhysicsWorld.overlap(physics_world, nil, "shape", "capsule", "position", pos + Vector3(0, 0, 0.675), "size", Vector3(0.49, 0.49, 0.675), "types", "statics", "collision_filter", "ghost_mode_mover")

	if #hits > 0 then
		if script_data.spawn_debug then
			drawer:capsule(pos, pos + Vector3(0, 0, 1.35), 0.49, Color(255, 0, 0))
		end

		return false
	elseif script_data.spawn_debug then
		drawer:capsule(pos, pos + Vector3(0, 0, 1.35), 0.49, Color(50, 50, 50))
	end

	return Vector3.length(Vector3.flat(pos - squad_unit_pos)) < MAX_SQUAD_SPAWN_DISTANCE
end

function SpawnManager:spawn_mount(mount_profile, pos, rot, player_unit, ghost_mode)
	local unit_name = MountProfiles[mount_profile].unit
	local spawner_id
	local network_manager = Managers.state.network

	if network_manager:game() then
		spawner_id = network_manager:game_object_id(player_unit)
	end

	local mount_unit = World.spawn_unit(self._world, unit_name, pos, rot)

	Unit.set_data(mount_unit, "mount_profile", mount_profile)
	Managers.state.entity:register_unit(self._world, mount_unit, nil, nil, ghost_mode, spawner_id)

	return mount_unit
end

function SpawnManager:rpc_spawn_player_unit(player, pos, rot, ghost_mode, profile_index)
	self:_spawn_player_unit(player, pos, rot, ghost_mode, profile_index)
end

function SpawnManager:_spawn_player_unit(player, pos, rot, ghost_mode, profile_index)
	local spawn_data = player.spawn_data

	spawn_data.state = ghost_mode and "ghost_mode" or "spawned"

	if not ghost_mode then
		spawn_data.spawns = spawn_data.spawns + 1
	end

	if player.remote then
		RPC.rpc_spawn_player_unit(player:network_id(), player.index, pos, rot, ghost_mode, profile_index or 0)

		return
	end

	local game_mode = Managers.state.game_mode:game_mode_key()
	local profiles = game_mode == "headhunter" and HeadHunterProfiles or GameSettingsDevelopment.enable_robot_player and RobotProfiles or PlayerProfiles
	local profile_name = profile_index or player.state_data.spawn_profile or Application.user_setting("profile_selection") or 1
	local profile = Managers.state.game_mode:squad_screen_spawning() and profiles[profile_name] or SPProfiles[profile_name]

	fassert(profile, "[SpawnManager] Trying to spawn with profile %q that doesn't exist in %q.", profile_name, Managers.lobby.lobby and "PlayerProfiles" or "SPProfiles")

	local team_name = player.team.name
	local unit_name = DefaultUnits.standard.player
	local world = self._world
	local unit = World.spawn_unit(world, unit_name, pos, rot)

	Unit.set_data(unit, "player_profile", profile_name)
	Managers.state.entity:register_unit(world, unit, player.index, ghost_mode, profile)

	if not ghost_mode then
		LevelHelper:flow_event(world, "player_unit_spawned")
	end

	if player.viewport_name then
		local viewport_name = player.viewport_name

		Unit.set_data(unit, "viewport_name", viewport_name)
	end

	return unit
end

function SpawnManager:rpc_player_unit_despawned(player)
	self:despawn_player_unit(player)
end

function SpawnManager:despawn_player_unit(player)
	player.spawn_data.state = "dead"

	if player.remote then
		RPC.rpc_player_unit_despawned(player:network_id(), player:player_id())

		return
	end

	local player_unit = player.player_unit
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local entity_manager = Managers.state.entity
	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")
	local mounted_unit = locomotion.mounted_unit

	Managers.player:relinquish_unit_ownership(player_unit)

	if game then
		local object_id = network_manager:unit_game_object_id(player_unit)

		network_manager:destroy_game_object(object_id)
	else
		entity_manager:unregister_unit(player_unit)
		World.destroy_unit(self._world, player_unit)
	end

	if mounted_unit then
		if game then
			local object_id = network_manager:unit_game_object_id(mounted_unit)

			network_manager:destroy_game_object(object_id)
		else
			entity_manager:remove_unit(mounted_unit)
			World.destroy_unit(self._world, mounted_unit)
		end
	end
end

function SpawnManager:_update_spawn_editor_simulation(dt, t)
	local player_manager = Managers.player

	for player_index, player in ipairs(player_manager:players()) do
		local spawn_data = player.spawn_data
		local team_name = player.team.name

		if (spawn_data.state == "dead" or spawn_data.state == "not_spawned") and (team_name == "red" or team_name == "white") then
			local pose = Application.get_data("camera")
			local pos = Matrix4x4.translation(pose)
			local rot = Matrix4x4.rotation(pose)

			self:_spawn_player_unit(player, pos, rot, false)
		end
	end
end

function SpawnManager:hot_join_synch(sender, player)
	for team_name, areas in pairs(self._active_spawn_areas_per_team) do
		for area_name, _ in pairs(areas) do
			local spawn_area = self._spawn_areas[area_name]

			RPC.rpc_activate_spawn_area(sender, spawn_area.network_lookup, NetworkLookup.team[team_name])
		end
	end

	for team_name, priorities in pairs(self._spawn_area_priority_per_team) do
		for priority, areas in pairs(priorities) do
			for area_name, _ in pairs(areas) do
				Managers.state.network:send_rpc_clients("rpc_set_spawn_area_priority", self._spawn_areas[area_name].network_lookup, NetworkLookup.team[team_name], priority)
			end
		end
	end
end
