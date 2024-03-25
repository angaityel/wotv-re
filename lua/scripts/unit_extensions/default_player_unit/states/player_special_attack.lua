-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_special_attack.lua

require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component")

PlayerSpecialAttack = class(PlayerSpecialAttack, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerSpecialAttack:init(unit, internal, world)
	PlayerSpecialAttack.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self, 10, math.pi * 2)
end

function PlayerSpecialAttack:update(dt, t)
	PlayerSpecialAttack.super.update(self, dt, t)

	local attack_settings = self._attack_settings

	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	if self._player_sweep and self._attacking then
		self:_update_player_sweep(dt, t)
	end

	if self._attacking and t > self._end_time then
		self:_end_attack()
	elseif t > self._end_time then
		self._transition = "onground"
	end

	local data = self._special_attack_settings
	local controller = self._controller
	local current_attack_index = self._current_attack_index
	local next_attack_index = math.min(current_attack_index + 1, #data.attack_names)
	local attack_name = data.attack_names[next_attack_index]
	local stamina_settings = self._gear_settings.attacks[attack_name].stamina_settings or PlayerUnitMovementSettings.special_attack.stamina_settings

	if not self._attacking and controller and controller:get("melee_pose_pushed") and self:_can_combo_special_attack(t, stamina_settings) then
		local attack_data = {
			attack_name = attack_name,
			slot_name = data.slot_name
		}

		self:_start_next_attack(attack_data)
	end

	if self:_inair_check(dt, t) then
		self:anim_event("to_inair")

		self._transition = "inair"
	end

	if self._transition then
		local internal = self._internal

		if internal.blocking or internal.parrying then
			self:_lower_block()
		end

		self:change_state(self._transition, self._transition_data)
		self:safe_action_interrupt("state_" .. self._transition)

		self._transition = nil
	end
end

function PlayerSpecialAttack:enter(old_state, data)
	PlayerSpecialAttack.super.enter(self, old_state)

	self._special_attack_settings = data

	local inventory = self._internal:inventory()
	local gear = inventory:gear(data.slot_name)

	self._gear_settings = gear:settings()
	self._current_attack_index = 1
	self._attack_end_reason = nil

	local max_rotation_speed = data.max_rotation_speed or math.pi * 2

	self._rotation_component:set_rotation_max_speed(max_rotation_speed)

	local attack_data = {
		attack_name = data.attack_names[self._current_attack_index],
		slot_name = data.slot_name,
		stamina_settings = data.stamina_settings
	}

	self:_start_next_attack(attack_data)
end

function PlayerSpecialAttack:_start_next_attack(data)
	local attack_name = data.attack_name
	local slot_name = data.slot_name
	local internal = self._internal

	self._attack_name = attack_name
	self._slot_name = slot_name
	self._start_time = Managers.time:time("game")
	self._start_position = Vector3Box(Unit.world_position(self._unit, 0))

	local attack_settings = self._gear_settings.attacks[attack_name]

	self._attack_settings = attack_settings
	self._end_time = self._start_time + attack_settings.attack_time + (attack_settings.animation_end_delay or 0)
	self._attacking = true

	self:_align_to_camera()
	self:stamina_activate(attack_settings.stamina_settings or data.stamina_settings or PlayerUnitMovementSettings.special_attack.stamina_settings)

	local viewport_name = internal.player.viewport_name

	self._aim_target_interpolation_source = QuaternionBox(Managers.state.camera:camera_rotation(viewport_name))

	self:start_special_attack()

	internal.special_attacking = true

	if not internal.pose_direction then
		self:_set_pose_direction()
	end
end

function PlayerSpecialAttack:_end_attack(reason)
	self._attacking = false

	local swing_recovery
	local internal = self._internal
	local hit, _, swing_time_left
	local penalties = self._attack_settings.penalties
	local attack_settings = self._attack_settings

	if attack_settings.player_sweep then
		hit = self._player_sweep.hit
		swing_time_left = self._end_time - Managers.time:time("game")
	else
		local inventory = internal:inventory()
		local gear = inventory:gear(self._slot_name)

		_, hit, swing_time_left = gear:end_melee_attack()
	end

	if reason == "hit_character" then
		swing_recovery = penalties.hit

		self:anim_event_with_variable_float("attack_hit_soft", "weapon_penetration", penalties.character_hit_animation_speed)
	elseif reason == "hard" then
		swing_recovery = penalties.hard

		self:anim_event_with_variable_float("attack_hit_hard", "weapon_penetration", 0)
	elseif reason == "blocking" then
		swing_recovery = penalties.blocked

		self:anim_event_with_variable_float("attack_hit_hard", "weapon_penetration", 0)
	elseif reason == "parrying" then
		swing_recovery = penalties.parried

		self:anim_event_with_variable_float("attack_hit_hard", "weapon_penetration", 0)
	elseif not hit then
		swing_recovery = penalties.miss
	else
		swing_recovery = penalties.hit
	end

	self._end_time = Managers.time:time("game") + swing_recovery
	self._attack_end_reason = reason

	if internal.pose_direction then
		self:_unset_pose_direction()
	end
end

function PlayerSpecialAttack:_can_combo_special_attack(t, stamina_settings)
	local data = self._special_attack_settings

	return data.combo_attack and self:stamina_can_activate(t, stamina_settings) and not self._attack_end_reason
end

function PlayerSpecialAttack:_set_pose_direction()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot = self._slot_name
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

function PlayerSpecialAttack:_unset_pose_direction()
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

function PlayerSpecialAttack:update_movement(dt)
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

	local anim_delta = Vector3.flat(wanted_position - current_position)
	local movement_multiplier = self._attack_settings.movement_multiplier or 1
	local delta = anim_delta * movement_multiplier + Vector3(0, 0, fall_velocity) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	internal.velocity:store(Vector3(0, 0, Vector3.z(delta)) / dt)
	self:set_local_position(final_position)
end

function PlayerSpecialAttack:exit(new_state)
	PlayerSpecialAttack.super.exit(self, new_state)

	local internal = self._internal

	if self._attacking then
		self:_end_attack()
	end

	self:start_aim_target_interpolation(self._aim_target_interpolation_source:unbox(), Managers.time:time("game"), 0.5)
	self:anim_event("attack_finished")

	internal.special_attacking = false
end

function PlayerSpecialAttack:update_rotation(dt, t)
	if t < self._start_time + self._attack_settings.rotation_time then
		self:_align_to_camera()
	end

	self:update_aim_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerSpecialAttack:update_aim_target(dt, t)
	local unit = self._unit
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(unit, "viewport_name")

	if viewport_name and self._attacking then
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

		local anim_variable = PlayerUnitMovementSettings.block.aim_direction_pitch_function(Vector3.normalize(rel_aim_dir).z)

		self:anim_set_variable(Unit.animation_find_variable(unit, "aim_direction_pitch"), anim_variable)

		if internal.game and internal.id then
			GameSession.set_game_object_field(internal.game, internal.id, "aim_target", rel_aim_dir)
		end
	end
end

function PlayerSpecialAttack:_constrain_to_character_rotation(aim_rotation)
	local relative_rotation = Quaternion.multiply(Quaternion.inverse(Unit.local_rotation(self._unit, 0)), aim_rotation)
	local direction = Quaternion.forward(relative_rotation)
	local angle = math.atan2(direction.x, direction.y)
	local pi = math.pi
	local max_angle = self._attack_settings.max_aim_angle or pi * 0.25
	local error_angle

	if angle < -max_angle then
		error_angle = -max_angle - angle
	elseif max_angle < angle then
		error_angle = max_angle - angle
	else
		return aim_rotation
	end

	return Quaternion.multiply(aim_rotation, Quaternion(Vector3.up(), -error_angle))
end

function PlayerSpecialAttack:start_special_attack()
	local attack_settings = self._attack_settings
	local inventory = self._internal:inventory()
	local gear = inventory:gear(self._slot_name)

	if not gear then
		return
	end

	if attack_settings.player_sweep then
		local sweep_settings = attack_settings.player_sweep
		local unit = self._unit
		local node = Unit.node(unit, sweep_settings.node)

		self._player_sweep = {
			started = false,
			start_time = self._start_time + attack_settings.attack_time * sweep_settings.start_delay,
			end_time = self._start_time + attack_settings.attack_time * sweep_settings.end_delay,
			node = node,
			last_pos = Vector3Box(self:_sweep_pos(unit, node))
		}

		self:_set_delayed_local_callback(self._local_start_special_attack, {
			attack_name = self._attack_name,
			attack_time = attack_settings.attack_time
		})
		self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_settings.attack_time)
	else
		gear:send_start_melee_attack(0, self._attack_name, attack_settings, callback(self, "gear_cb_abort_special_attack"), attack_settings.attack_time)
		self:_set_delayed_local_callback(self._local_start_special_attack, {
			attack_name = self._attack_name,
			attack_time = attack_settings.attack_time
		})
		self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_settings.attack_time, false, true)
	end
end

function PlayerSpecialAttack:_local_start_special_attack(t, params)
	local slot_name = params.slot_name
	local attack_name = params.attack_name
	local attack_time = params.attack_time
	local attack_settings = self._attack_settings
	local inventory = self._internal:inventory()
	local gear = inventory:gear(self._slot_name)

	if not gear then
		return
	end

	if attack_settings.player_sweep then
		local sweep_settings = attack_settings.player_sweep
		local unit = self._unit
		local node = Unit.node(unit, sweep_settings.node)

		self._player_sweep = {
			started = false,
			start_time = self._start_time + attack_settings.attack_time * sweep_settings.start_delay,
			end_time = self._start_time + attack_settings.attack_time * sweep_settings.end_delay,
			node = node,
			last_pos = Vector3Box(self:_sweep_pos(unit, node))
		}
	else
		gear:start_melee_attack(0, self._attack_name, attack_settings, callback(self, "gear_cb_abort_special_attack"), attack_settings.attack_time)
		self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_settings.attack_time, true)
	end
end

function PlayerSpecialAttack:_update_player_sweep(dt, t)
	local sweep_data = self._player_sweep
	local attack_settings = self._attack_settings
	local sweep_settings = attack_settings.player_sweep
	local unit = self._unit
	local node = sweep_data.node

	if not sweep_data.started and t >= sweep_data.start_time then
		sweep_data.started = true
	end

	local old_pos = sweep_data.last_pos:unbox()
	local new_pos = self:_sweep_pos(unit, node)

	if sweep_data.started and t < sweep_data.end_time then
		local rot = Quaternion.look(Vector3.normalize(new_pos - old_pos), Vector3.up())
		local physics_world = World.physics_world(self._internal.world)
		local sweep_extents = 0.5 * Vector3(sweep_settings.width, sweep_settings.depth, sweep_settings.height)

		if script_data.debug_special_attack then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon"
			})

			drawer:box_sweep(Matrix4x4.from_quaternion_position(rot, old_pos), sweep_extents, new_pos - old_pos)
		end

		local hits = physics_world:linear_obb_sweep(old_pos, new_pos, sweep_extents, rot, 50, "types", "both", "collision_filter", "melee_trigger")

		if hits then
			for _, hit in ipairs(hits) do
				if self:_resolve_player_sweep_hit(hit) then
					break
				end
			end
		end
	end

	sweep_data.last_pos:store(new_pos)
end

function PlayerSpecialAttack:_sweep_pos(unit, node)
	local pos = Unit.world_position(unit, node)
	local attack_settings = self._attack_settings
	local sweep_settings = attack_settings.player_sweep
	local offset = sweep_settings and Quaternion.forward(Unit.local_rotation(unit, 0)) * sweep_settings.forward_offset or Vector3.zero()

	pos = pos + offset

	return pos
end

function PlayerSpecialAttack:_resolve_player_sweep_hit(hit)
	local internal = self._internal
	local sweep_data = self._player_sweep
	local hit_actor = hit.actor
	local hit_unit = hit_actor and Actor.unit(hit_actor)
	local unit = self._unit
	local reason

	hit_unit, hit_actor = WeaponHelper:helmet_hack(hit_unit, hit_actor)

	if Unit.alive(hit_unit) and hit_unit ~= unit and Unit.get_data(hit_unit, "user_unit") ~= unit then
		sweep_data.hit = hit

		if ScriptUnit.has_extension(hit_unit, "locomotion_system") then
			local hit_player = Managers.player:owner(hit_unit)
			local local_player = internal.player

			if hit_player.team ~= local_player.team then
				reason = "hit_character"

				local normal = hit.normal
				local position = hit.position
				local impact_direction = Quaternion.forward(Unit.local_rotation(self._unit, 0))

				self:_player_sweep_hit_character(hit_unit, position, normal, hit_actor, impact_direction)
			end
		elseif Unit.has_data(hit_unit, "gear_name") then
			local gear_user = Unit.get_data(hit_unit, "user_unit")

			if not Unit.alive(gear_user) then
				return false
			end

			local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

			if gear_user_locomotion.blocking and gear_user_locomotion.block_unit == hit_unit and self:_check_blocking(gear_user_locomotion) then
				local hit_player = Managers.player:owner(gear_user)
				local local_player = internal.player

				if hit_player.team ~= local_player.team then
					reason = "hit_character"

					local normal = hit.normal
					local position = hit.position
					local impact_direction = Quaternion.forward(Unit.local_rotation(self._unit, 0))

					self:_player_sweep_hit_character(gear_user, position, normal, hit_actor, impact_direction)
				end
			else
				return false
			end
		else
			reason = "hard"
		end

		self:_end_attack(reason)

		return true
	end

	return false
end

function PlayerSpecialAttack:_check_blocking(victim_locomotion)
	if not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	local attacker_aim = self._internal:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3.flat(attacker_aim)
	local victim_aim_flat = Vector3.flat(victim_aim)
	local dot = Vector3.dot(attacker_aim_flat, victim_aim_flat)

	return dot < 0
end

function PlayerSpecialAttack:_player_sweep_hit_character(hit_unit, position, normal, actor, impact_direction)
	local network_manager = Managers.state.network
	local internal = self._internal
	local world = self._world

	WeaponHelper:push_impact_character(hit_unit, position, normal, world, impact_direction)
	internal.velocity:store(Vector3(0, 0, 0))

	if internal.game and internal.id then
		local inventory = internal:inventory()
		local gear = inventory:gear(self._slot_name)
		local player = internal.player
		local gear_name = gear:name()
		local attack_name = self._attack_name

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_push_impact_character", network_manager:game_object_id(hit_unit), position, normal, impact_direction, false)

			local damage_ext = ScriptUnit.has_extension(hit_unit, "damage_system") and ScriptUnit.extension(hit_unit, "damage_system")

			if damage_ext then
				damage_ext:set_last_damager(player, gear_name, attack_name, 0)
			end
		else
			network_manager:send_rpc_server("rpc_set_last_damager", network_manager:game_object_id(hit_unit), player:player_id(), NetworkLookup.gear_names[gear_name], NetworkLookup.weapon_hit_parameters[attack_name or "nil"])
			network_manager:send_rpc_server("rpc_push_impact_character", network_manager:game_object_id(hit_unit), position, normal, impact_direction, false)
		end
	end
end

function PlayerSpecialAttack:gear_cb_abort_special_attack(reason)
	if self._attacking then
		self:_end_attack(reason)
	end
end

function PlayerSpecialAttack:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
