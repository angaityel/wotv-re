-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_dodging.lua

PlayerDodging = class(PlayerDodging, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerDodging:init(unit, internal, world)
	PlayerDodging.super.init(self, unit, internal, world)

	self._start_max_rotation_speed = math.pi * 2
	self._end_max_rotation_speed = math.pi * 0.1
	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self, 10, math.pi * 2)
	self._world = world
end

function PlayerDodging:update(dt, t)
	PlayerDodging.super.update(self, dt, t)

	local internal = self._internal
	local controller = self._controller

	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	self._time = self._time + dt

	if self._dodge_attack_sweep_settings then
		self:update_dodge_block(t, self._settings.block_settings)
	end

	local perk_name = "dodge_attack"
	local perk_activation_command

	if internal:has_perk(perk_name) then
		internal:set_perk_state(perk_name, "ready")

		perk_activation_command = controller and controller:get(internal:perk_activation_command(perk_name))
	end

	self._attack_triggered = self._attack_triggered or controller and (controller:get("melee_pose_pushed") or perk_activation_command)

	local inventory = internal:inventory()
	local slot = inventory:wielded_melee_weapon_slot()

	if t > self._attack_time and self._attack_triggered and self:can_special_attack(t) and slot and inventory:gear(slot):settings().attacks[self._attack_name] then
		self._unpose_attack = false

		internal:set_perk_state(perk_name, "active")
		self:safe_action_interrupt(perk_name)

		if self._attack_name_secondary then
			self:change_state("dual_wield_special_attack", {
				slot_name = "primary",
				secondary_slot_name = "secondary",
				attack_name = self._attack_name,
				secondary_attack_name = self._attack_name_secondary,
				stamina_settings = self._settings.attack_stamina_settings
			})
		else
			self:change_state("special_attack", {
				attack_names = {
					self._attack_name
				},
				slot_name = slot,
				stamina_settings = self._settings.attack_stamina_settings
			})
		end
	elseif t > self._end_time then
		self:change_state("onground")
	end
end

function PlayerDodging:update_dodge_block(t, block_settings)
	local sweep_settings = self._dodge_attack_sweep_settings

	if t < sweep_settings.start_time or t > sweep_settings.end_time then
		return
	end

	local unit = self._unit
	local node = sweep_settings.node
	local old_pos = sweep_settings.last_pos:unbox()
	local new_pos = self:_dodge_block_position(unit, node)
	local rot = Quaternion.look(Vector3.normalize(new_pos - old_pos), Vector3.up())
	local physics_world = World.physics_world(self._internal.world)
	local sweep_extents = 0.5 * Vector3(block_settings.width, block_settings.depth, block_settings.height)
	local hits = physics_world:linear_obb_sweep(old_pos, new_pos, sweep_extents, rot, 50, "types", "both", "collision_filter", "melee_trigger")

	if script_data.debug_dodge_block then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})

		drawer:box_sweep(Matrix4x4.from_quaternion_position(rot, old_pos), sweep_extents, new_pos - old_pos)
	end

	if hits then
		for _, hit in ipairs(hits) do
			if self:_dodge_block_resolve_hit(hit) then
				return
			end
		end
	end
end

function PlayerDodging:_dodge_block_resolve_hit(hit)
	local unit = self._unit
	local hit_actor = hit.actor
	local hit_unit = Actor.unit(hit_actor)

	if Unit.alive(hit_unit) and hit_unit ~= unit and Unit.get_data(hit_unit, "user_unit") ~= unit then
		local local_player = self._internal.player
		local hit_player, game_object_id

		if ScriptUnit.has_extension(hit_unit, "locomotion_system") then
			hit_player = Managers.player:owner(hit_unit)
			game_object_id = hit_unit
		elseif Unit.has_data(hit_unit, "gear_name") then
			local gear_user = Unit.get_data(hit_unit, "user_unit")

			hit_player = Managers.player:owner(gear_user)
			game_object_id = gear_user

			if not hit_player or not Unit.alive(hit_player.player_unit) then
				return false
			end
		else
			return false
		end

		if hit_player.team == local_player.team then
			return false
		end

		local normal = hit.normal
		local position = hit.position
		local impact_direction = Quaternion.forward(Unit.local_rotation(self._unit, 0))
		local unit_id = Managers.state.network:unit_game_object_id(game_object_id)

		Managers.state.network:send_rpc_server("rpc_push_impact_character", unit_id, position, normal, impact_direction, false)
		self:change_state("stunned", "torso", impact_direction, "torso")

		return true
	end
end

function PlayerDodging:can_special_attack(t)
	local internal = self._internal

	if not internal.ghost_mode and internal:has_perk("dodge_attack") then
		return true
	end

	return false
end

function PlayerDodging:enter(old_state, dodge_settings)
	PlayerDodging.super.enter(self, old_state)

	local internal = self._internal
	local t = Managers.time:time("game")
	local duration = dodge_settings.duration

	self._settings = dodge_settings

	self:stamina_activate(dodge_settings.stamina_settings, internal.stamina.dodge_chain_use_data)

	self._start_time = t
	self._end_time = t + duration
	self._attack_time = t + dodge_settings.attack_trigger_time

	if internal:inventory():is_dual_wielding() then
		self._attack_name = "dual_wield_" .. dodge_settings.attack_name .. "_primary"
		self._attack_name_secondary = "dual_wield_" .. dodge_settings.attack_name .. "_secondary"
	else
		self._attack_name = dodge_settings.attack_name
	end

	self._attack_triggered = false
	self._unpose_attack = true
	self._time = 0

	self:_align_to_camera()

	local viewport_name = internal.player.viewport_name

	self._aim_target_interpolation_source = QuaternionBox(Managers.state.camera:camera_rotation(viewport_name))

	local anim_event = dodge_settings.anim_event

	self:anim_event_with_variable_float(anim_event, "dodge_time", dodge_settings.anim_time)

	internal.dodging = true

	self:_set_pose_direction()

	if dodge_settings.block_settings then
		self:_setup_dodge_block(dodge_settings)
	end
end

function PlayerDodging:_setup_dodge_block(settings)
	local block_settings = settings.block_settings
	local unit = self._unit
	local node = Unit.node(unit, block_settings.node)

	self._dodge_attack_sweep_settings = {
		started = false,
		start_time = self._start_time + block_settings.start_time,
		end_time = self._start_time + block_settings.end_time,
		node = node,
		last_pos = Vector3Box(self:_dodge_block_position(unit, node))
	}
end

function PlayerDodging:_dodge_block_position(unit, node)
	local pos = Unit.world_position(unit, node)
	local forward_offset = self._settings.block_settings.forward_offset
	local offset = forward_offset and Quaternion.forward(Unit.local_rotation(unit, 0)) * forward_offset or Vector3.zero()

	pos = pos + offset

	return pos
end

function PlayerDodging:_set_pose_direction()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot = inventory:wielded_melee_weapon_slot()
	local settings = slot and inventory:gear(slot):settings().attacks[self._attack_name]
	local direction = settings and settings.parry_direction

	if not direction then
		return
	end

	internal.pose_direction = direction

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(self._unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[direction])
		else
			network_manager:send_rpc_server("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[direction])
		end
	end
end

function PlayerDodging:_unset_pose_direction()
	self._internal.pose_direction = nil

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(self._unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_stop_posing_melee_weapon", user_object_id)
		else
			network_manager:send_rpc_server("rpc_stop_posing_melee_weapon", user_object_id)
		end
	end
end

function PlayerDodging:update_movement(dt)
	local internal = self._internal
	local unit = self._unit
	local mover = Unit.mover(unit)
	local wanted_pose = Unit.animation_wanted_root_pose(unit)
	local wanted_position = Matrix4x4.translation(wanted_pose)
	local current_position = Unit.local_position(unit, 0)
	local z_velocity = Vector3.z(internal.velocity:unbox())
	local inv_drag_force = 0.00225 * math.abs(z_velocity) * z_velocity
	local fall_velocity = z_velocity - (9.82 + inv_drag_force) * dt

	if fall_velocity > 0 then
		fall_velocity = 0
	end

	local settings = self._settings
	local aim_rot = self:aim_rotation()
	local right = Quaternion.right(aim_rot)
	local rotation = Quaternion(Vector3.up(), math.pi * 0.5 - settings.angle)
	local dir = Quaternion.rotate(rotation, right)
	local anim_delta = settings.movement_multiplier * dir * Vector3.length(Vector3.flat(wanted_position - current_position))
	local delta = anim_delta + Vector3(0, 0, fall_velocity) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	internal.velocity:store(delta / dt)
	self:set_local_position(final_position)

	if Mover.collides_sides(Unit.mover(unit)) and Vector3.length(delta) < 0.05 then
		self:change_state("onground")

		return
	end
end

function PlayerDodging:exit(new_state)
	PlayerDodging.super.exit(self, new_state)

	local internal = self._internal

	self:start_aim_target_interpolation(self._aim_target_interpolation_source:unbox(), Managers.time:time("game"), 0.5)
	self:anim_event("dodge_finished")

	if self._unpose_attack then
		self:_unset_pose_direction()
	end

	self._internal.dodging = false
end

function PlayerDodging:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)

	local rot = Quaternion.look(Vector3.flat(self._internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)

	local rotation_t = (t - self._start_time) / (self._end_time - self._start_time)
	local max_rotation_speed = math.lerp(self._start_max_rotation_speed, self._end_max_rotation_speed, rotation_t)

	self._rotation_component:set_rotation_max_speed(max_rotation_speed)
	self._rotation_component:update(dt, t)
end

function PlayerDodging:update_aim_target(dt, t)
	local unit = self._unit
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(unit, "viewport_name")

	if viewport_name then
		local internal = self._internal
		local aim_from_pos = Mover.position(Unit.mover(unit)) + Unit.local_position(unit, Unit.node(unit, "camera_attach"))
		local aim_rotation = camera_manager:aim_rotation(viewport_name)

		aim_rotation = self:_constrain_to_character_rotation(aim_rotation)

		self._aim_target_interpolation_source:store(aim_rotation)

		local max_z = 2
		local dir = Quaternion.forward(aim_rotation)
		local flat_rel_aim_dir = Vector3(dir.x, dir.y, 0)
		local flat_length = Vector3.length(flat_rel_aim_dir)
		local unmodified_rel_aim_dir = dir / flat_length
		local unnormalized_rel_aim_dir = Vector3(unmodified_rel_aim_dir.x, unmodified_rel_aim_dir.y, math.min(unmodified_rel_aim_dir.z, max_z))
		local rel_aim_dir = Vector3.normalize(unnormalized_rel_aim_dir) * 3
		local aim_target = aim_from_pos + rel_aim_dir

		internal.aim_target:store(aim_target)

		if script_data.aim_constraint_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "constraint debug"
			})

			drawer:sphere(aim_target, 0.05, Color(255, 255, 0))
		end

		Unit.animation_set_constraint_target(unit, self._aim_constraint_anim_var, aim_target)

		if internal.game and internal.id then
			GameSession.set_game_object_field(internal.game, internal.id, "aim_target", rel_aim_dir)
		end
	end
end

function PlayerDodging:_constrain_to_character_rotation(aim_rotation)
	return Unit.local_rotation(self._unit, 0)
end

function PlayerDodging:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:_set_rotation(rot)
end
