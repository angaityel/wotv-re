-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_special_attack_stance.lua

require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component")

PlayerSpecialAttackStance = class(PlayerSpecialAttackStance, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerSpecialAttackStance:init(unit, internal, world)
	PlayerSpecialAttackStance.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self, 10, math.pi * 2)

	self._rotation_component:set_rotation_max_speed(math.pi * 0.5)
end

function PlayerSpecialAttackStance:update(dt, t)
	PlayerSpecialAttackStance.super.update(self, dt, t)
	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	if not self._internal.special_attacking then
		return
	end

	local controller = self._controller
	local stance_settings = self._stance_settings

	if t > self._stance_end_time and (not controller or self:_wants_to_leave_stance(dt, t, controller)) then
		self:anim_event("special_attack_end")

		self._transition = "onground"

		self:safe_action_interrupt("state_onground")
	elseif controller and controller:get("melee_pose_pushed") then
		self._stored_input = "melee_pose_pushed"
	elseif controller and controller:get("block") > BUTTON_THRESHOLD then
		self._stored_input = "block"
	end

	if self._minimum_stance_time - t <= 0 and self._stored_input then
		local slot_name = self._slot_name

		if self._stored_input == "melee_pose_pushed" then
			self._transition = "special_attack"
			self._transition_data = {
				combo_attack = true,
				attack_names = {
					stance_settings.first_attack,
					stance_settings.repeated_attack
				},
				slot_name = slot_name,
				max_rotation_speed = math.pi * 0.3
			}
			self._stored_input = nil
		elseif self._stored_input == "block" then
			self._transition = "special_attack"
			self._transition_data = {
				attack_names = {
					stance_settings.shield_bash
				},
				slot_name = slot_name
			}
			self._stored_input = nil
		end
	end

	if self:_inair_check(dt, t) then
		self:anim_event("to_inair")

		self._transition = "inair"
	end

	if self._transition then
		self:change_state(self._transition, self._transition_data)

		self._transition = nil
	end
end

local MOVE_THRESHOLD = 0.25

function PlayerSpecialAttackStance:_wants_to_leave_stance(dt, t, controller)
	if Application.user_setting("move_to_leave_stance") then
		return Vector3.length(controller:get("move")) > MOVE_THRESHOLD
	else
		return controller:get("special_attack_held") < 0.5
	end
end

function PlayerSpecialAttackStance:enter(old_state, data)
	self:_raise_shield_block("shield")
	self:anim_event("special_attack_stance", false, true)
	self:_set_delayed_local_callback(self._local_enter, {
		old_state = old_state,
		data = data
	})
end

function PlayerSpecialAttackStance:_local_enter(t, params)
	local old_state = params.old_state
	local data = params.data

	PlayerSpecialAttackStance.super.enter(self, old_state)

	local internal = self._internal
	local stance_settings = data.stance_settings

	self._stance_settings = stance_settings
	self._stance_end_time = Managers.time:time("game") + stance_settings.stance_duration
	self._minimum_stance_time = Managers.time:time("game") + stance_settings.minimum_time
	self._slot_name = data.slot_name

	self:_align_to_camera()
	self:anim_event("special_attack_stance", true)

	local viewport_name = internal.player.viewport_name

	self._aim_target_interpolation_source = QuaternionBox(Managers.state.camera:camera_rotation(viewport_name))
	internal.special_attacking = true
end

function PlayerSpecialAttackStance:exit(new_state)
	PlayerSpecialAttackStance.super.exit(self, new_state)

	local internal = self._internal

	self:start_aim_target_interpolation(self._aim_target_interpolation_source:unbox(), Managers.time:time("game"), 0.5)

	internal.special_attacking = false
end

function PlayerSpecialAttackStance:update_movement(dt)
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
	local delta = anim_delta + Vector3(0, 0, fall_velocity) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	internal.velocity:store(Vector3(0, 0, Vector3.z(delta)) / dt)
	self:set_local_position(final_position)
end

function PlayerSpecialAttackStance:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)

	local rot = Quaternion.look(Vector3.flat(self._internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
	self._rotation_component:update(dt, t)
end

function PlayerSpecialAttackStance:update_aim_target(dt, t)
	if not self._internal.special_attacking then
		PlayerSpecialAttackStance.super.update_aim_target(self, dt, t)

		return
	end

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

		local anim_variable = PlayerUnitMovementSettings.block.aim_direction_pitch_function(Vector3.normalize(rel_aim_dir).z)

		self:anim_set_variable(Unit.animation_find_variable(unit, "aim_direction_pitch"), anim_variable)

		if internal.game and internal.id then
			GameSession.set_game_object_field(internal.game, internal.id, "aim_target", rel_aim_dir)
		end
	end
end

function PlayerSpecialAttackStance:_constrain_to_character_rotation(aim_rotation)
	local relative_rotation = Quaternion.multiply(Quaternion.inverse(Unit.local_rotation(self._unit, 0)), aim_rotation)
	local direction = Quaternion.forward(relative_rotation)
	local angle = math.atan2(direction.x, direction.y)
	local pi = math.pi
	local max_angle = pi * 0.125
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

function PlayerSpecialAttackStance:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
