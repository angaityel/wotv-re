-- chunkname: @scripts/entity_system/systems/deserting/deserting_system.lua

require("scripts/unit_extensions/default_player_unit/player_unit_deserter")

DesertingSystem = class(DesertingSystem)
MARKER_VIEW_RADIUS = 14

function DesertingSystem:init(context, system_name)
	local em = context.entity_manager

	em:register_system(self, system_name)

	self.entity_manager = em
	self._extensions = {}
	self._world = context.world
	self._active_team_boundary_areas = {}

	for _, team_name in pairs(Managers.state.team:names()) do
		self._active_team_boundary_areas[team_name] = {}
	end

	self._deserter_zone_markers = {}

	local event_manager = Managers.state.event

	event_manager:register(self, "activate_boundary_area", "flow_cb_activate_boundary_area")
	event_manager:register(self, "deactivate_boundary_area", "flow_cb_deactivate_boundary_area")
	event_manager:register(self, "boundary_area_activated", "rpc_boundary_area_activated")
	event_manager:register(self, "boundary_area_deactivated", "rpc_boundary_area_deactivated")
	event_manager:register(self, "player_joined_team", "event_player_joined_team")
	event_manager:register(self, "player_left_team", "event_player_left_team")
end

function DesertingSystem:on_add_extension(world, unit, extension_name, extension_class, ...)
	if script_data.extension_debug then
		print(string.format("%s:on_add_component(unit, %s)", self.NAME, extension_name))
	end

	self._extensions[extension_name] = (self._extensions[extension_name] or 0) + 1
end

function DesertingSystem:on_remove_extension(unit, extension_name)
	return
end

function DesertingSystem:update(context, t)
	self:_hide_all_markers()

	for extension_name, _ in pairs(self._extensions) do
		self:update_extension(extension_name, context, t)
	end

	self:_update_marker_visibility()
end

function DesertingSystem:update_extension(extension_name, context, t)
	local units = self.entity_manager:get_entities(extension_name)

	for unit, _ in pairs(units) do
		local timer = Unit.get_data(unit, "deserter_timer")
		local player = Managers.player:owner(unit)

		if player then
			local damage_extension = ScriptUnit.extension(unit, "damage_system")

			if Managers.lobby.server or not Managers.lobby.lobby then
				if self:_unit_in_active_boundary(unit) then
					if timer then
						self:_remove_desert_timer(unit, player)
					end
				elseif timer then
					if timer <= t then
						self:_kill_player(unit, player, damage_extension)
					end

					if damage_extension:is_dead() then
						self:_remove_desert_timer(unit, player)
					end
				elseif not damage_extension:is_dead() then
					self:_set_desert_timer(unit, player, t)
				end
			end

			if not player.remote then
				self:_deserter_zone_marker_overlap(context, t, unit)
			end
		end
	end
end

function DesertingSystem:_hide_all_markers()
	for area_name, projection_units in pairs(self._deserter_zone_markers) do
		for projection_unit, _ in pairs(projection_units) do
			self._deserter_zone_markers[area_name][projection_unit] = 0
		end
	end
end

function DesertingSystem:_update_marker_visibility()
	for area_name, projection_units in pairs(self._deserter_zone_markers) do
		for projection_unit, alpha in pairs(projection_units) do
			if alpha > 0 then
				Unit.set_mesh_visibility(projection_unit, 0, true)

				local mesh = Unit.mesh(projection_unit, "projection_box")
				local material = Mesh.material(mesh, "lambert1")

				Material.set_scalar(material, "diffuse_alpha", alpha)
			else
				Unit.set_mesh_visibility(projection_unit, 0, false)
			end
		end
	end
end

function DesertingSystem:_deserter_zone_marker_overlap(context, t, player_unit)
	local physics_world = World.physics_world(self._world)
	local pose = Unit.world_pose(player_unit, 0)
	local actors = PhysicsWorld.overlap(physics_world, nil, "shape", "sphere", "pose", pose, "size", MARKER_VIEW_RADIUS, "types", "statics", "collision_filter", "deserter_zone_marker_overlap")

	for _, actor in ipairs(actors) do
		local unit = Actor.unit(actor)
		local distance = Vector3.distance(Unit.world_position(player_unit, 0), Unit.world_position(unit, 0))
		local alpha_multiplier = 0.5
		local alpha = (1 - distance / (MARKER_VIEW_RADIUS + 1)) * alpha_multiplier

		for area_name, projection_units in pairs(self._deserter_zone_markers) do
			for projection_unit, _ in pairs(projection_units) do
				if projection_unit == unit then
					self._deserter_zone_markers[area_name][projection_unit] = alpha

					break
				end
			end
		end
	end
end

function DesertingSystem:_set_desert_timer(unit, player, t)
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local deserter_timer = t + GameModeSettings[game_mode_key].deserter_timer

	Unit.set_data(unit, "deserter_timer", deserter_timer)

	if player.remote then
		local network_manager = Managers.state.network
		local player_network_id = player:network_id()
		local player_id = player:player_id()

		RPC.rpc_player_deserting(player_network_id, player_id, true, deserter_timer - t)
	else
		Managers.state.event:trigger("event_deserting_activated", player, deserter_timer - t)

		local unit = player.player_unit

		if Unit.alive(unit) then
			local locomotion = ScriptUnit.extension(unit, "locomotion_system")

			locomotion.deserting = true
		end
	end
end

function DesertingSystem:_remove_desert_timer(unit, player)
	Unit.set_data(unit, "deserter_timer", nil)

	if player.remote then
		local network_manager = Managers.state.network
		local player_network_id = player:network_id()
		local player_id = player:player_id()

		RPC.rpc_player_deserting(player_network_id, player_id, false, 0)
	else
		Managers.state.event:trigger("event_deserting_deactivated", player)

		local unit = player.player_unit

		if Unit.alive(unit) then
			local locomotion = ScriptUnit.extension(unit, "locomotion_system")

			locomotion.deserting = false
		end
	end
end

function DesertingSystem:_unit_in_active_boundary(unit)
	local position = Unit.world_position(unit, 0)
	local team_name = Unit.get_data(unit, "team_name")
	local team_boundaries = self._active_team_boundary_areas[team_name]
	local level = LevelHelper:current_level(self._world)

	if table.is_empty(team_boundaries) then
		return true
	end

	for boundary, _ in pairs(team_boundaries) do
		if Level.is_point_inside_volume(level, boundary, position) then
			return true
		end
	end

	return false
end

function DesertingSystem:_kill_player(unit, player, damage_extension)
	if player.remote then
		local network_manager = Managers.state.network
		local game_object_id = network_manager:game_object_id(unit)

		network_manager:send_rpc_server("rpc_suicide", game_object_id)
	else
		damage_extension:die(Managers.player:owner(unit), nil, true)
	end
end

function DesertingSystem:flow_cb_activate_boundary_area(params)
	local team_name = Managers.state.team:name(params.side)
	local area_name = params.boundary_area

	self._active_team_boundary_areas[team_name][area_name] = true

	local team = Managers.state.team:team_by_name(team_name)
	local members = team:get_members()

	for _, member in ipairs(members) do
		RPC.rpc_boundary_area_activated(member:network_id(), area_name)
	end
end

function DesertingSystem:flow_cb_deactivate_boundary_area(params)
	local team_name = Managers.state.team:name(params.side)
	local area_name = params.boundary_area

	self._active_team_boundary_areas[team_name][area_name] = nil

	local team = Managers.state.team:team_by_name(team_name)
	local members = team:get_members()

	for _, member in ipairs(members) do
		RPC.rpc_boundary_area_deactivated(member:network_id(), area_name)
	end
end

function DesertingSystem:event_player_joined_team(player)
	local team_name = player.team.name
	local active_boundary_areas = self._active_team_boundary_areas[team_name]
	local network_manager = Managers.state.network

	if network_manager:game() and Managers.lobby.server then
		for area_name, active in pairs(active_boundary_areas) do
			if active then
				RPC.rpc_boundary_area_activated(player:network_id(), area_name)
			end
		end
	end
end

function DesertingSystem:event_player_left_team(player)
	local team_name = player.team.name
	local active_boundary_areas = self._active_team_boundary_areas[team_name]
	local network_manager = Managers.state.network

	if network_manager:game() and Managers.lobby.server then
		for area_name, active in pairs(active_boundary_areas) do
			if active then
				RPC.rpc_boundary_area_deactivated(player:network_id(), area_name)
			end
		end
	end
end

function DesertingSystem:_remove_boundary_markers(area_name)
	for name, projection_units in pairs(self._deserter_zone_markers) do
		if name == area_name then
			for projection_unit, alpha in pairs(projection_units) do
				World.destroy_unit(self._world, projection_unit)
			end

			self._deserter_zone_markers[area_name] = nil
		end
	end
end

function DesertingSystem:rpc_boundary_area_deactivated(area_name)
	self:_remove_boundary_markers(area_name)
end

function DesertingSystem:rpc_boundary_area_activated(area_name)
	local level = LevelHelper:current_level(self._world)
	local boundary_verticies = Level.volume_verticies_2D(level, area_name)

	self._projector_rotation = nil
	self._previous_boundary_vertex_pos = nil
	self._first_boundary_vertex_pos = nil
	self._last_boundary_vertex_pos = nil

	local vertex_callback = callback(self, "cb_boundary_vertex_raycast_result", area_name)
	local boundary_vertex_raycast = PhysicsWorld.make_raycast(World.physics_world(self._world), vertex_callback, "closest", "types", "statics", "collision_filter", "ray_deserter_zone_point")

	for i, point in ipairs(boundary_verticies) do
		if i == 1 then
			self._first_boundary_vertex_pos = point
		elseif i == #boundary_verticies then
			self._last_boundary_vertex_pos = point
		end

		point.z = 500

		local vertex_callback = callback(self, "cb_boundary_vertex_raycast_result", area_name, point)
		local boundary_vertex_raycast = PhysicsWorld.make_raycast(World.physics_world(self._world), vertex_callback, "closest", "types", "statics", "collision_filter", "ray_deserter_zone_point")

		boundary_vertex_raycast:cast(point, -Vector3.up())
	end

	self:_spawn_projection_boxes_between(self._first_boundary_vertex_pos, self._last_boundary_vertex_pos, area_name)
end

function DesertingSystem:cb_boundary_vertex_raycast_result(area_name, point, hit, position, distance, normal, actor)
	if hit then
		local current_position = position
		local previous_position = self._previous_boundary_vertex_pos

		if previous_position then
			self:_spawn_projection_boxes_between(current_position, previous_position, area_name)
		end

		self._previous_boundary_vertex_pos = current_position
	elseif script_data.debug_boundary_areas then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "sefaef"
		})

		drawer:vector(point, -Vector3.up() * point.z, Color(255, 255, 0, 0))
	else
		fassert(hit, "Boundary Area Raycast hit nothing, check that boundary area points are over terrain, script_data.debug_boundary_areas = true")
	end
end

function DesertingSystem:_spawn_projection_boxes_between(current_point, previous_point, area_name)
	local cur_flat = Vector3.flat(current_point)
	local prev_flat = Vector3.flat(previous_point)
	local distance = Vector3.distance(cur_flat, prev_flat)
	local rounded_distance = math.floor(distance)
	local box_count = math.ceil(rounded_distance / 2)
	local difference = cur_flat - prev_flat
	local difference_norm = Vector3.normalize(difference)
	local remainder = distance - rounded_distance
	local offset = remainder / 2
	local projector_rotation = QuaternionBox(Quaternion.look(difference, Vector3.up()))
	local projector_callback = callback(self, "cb_boundary_projector_raycast_result", projector_rotation, area_name)
	local boundary_projector_raycast = PhysicsWorld.make_raycast(World.physics_world(self._world), projector_callback, "closest", "types", "statics", "collision_filter", "ray_deserter_zone_point")

	for i = 1, box_count do
		local point = prev_flat + i * difference_norm * 2 - difference_norm + (offset * difference_norm - 0.5 * difference_norm)

		point.z = 3000

		boundary_projector_raycast:cast(point, -Vector3.up())
	end
end

function DesertingSystem:cb_boundary_projector_raycast_result(projector_rotation, area_name, hit, position, distance, normal, actor)
	if hit then
		local projector_pos = Vector3(position.x, position.y, position.z)
		local projection_unit = World.spawn_unit(self._world, "units/decals/boundary_marker_projector", projector_pos, projector_rotation:unbox())

		Unit.set_local_scale(projection_unit, 0, Vector3(0.8, 0.8, 1))
		Unit.set_mesh_visibility(projection_unit, 0, false)

		self._deserter_zone_markers[area_name] = self._deserter_zone_markers[area_name] or {}
		self._deserter_zone_markers[area_name][projection_unit] = 0
	end
end

function DesertingSystem:hot_join_synch(sender, player)
	return
end

function DesertingSystem:destroy()
	return
end
