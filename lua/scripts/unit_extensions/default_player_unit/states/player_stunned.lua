-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_stunned.lua

require("scripts/unit_extensions/default_player_unit/states/player_movement_state_base")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_local_rotation_component")

PlayerStunned = class(PlayerStunned, PlayerMovementStateBase)

function PlayerStunned:init(unit, internal, world, ...)
	PlayerStunned.super.init(self, unit, internal, world, ...)

	self._rotation_component = PlayerStateLocalRotationComponent:new(unit, internal, self)
end

function PlayerStunned:update(dt, t)
	PlayerStunned.super.update(self, dt, t)
	self:update_aim_rotation(dt, t)
	self:_update_rotation(dt, t)
	self:update_speed(dt, t)
	self:update_movement(dt, t)
	self:update_transitions(dt, t)
end

function PlayerStunned:_update_rotation(dt, t)
	if self._stun_type ~= "rooted" then
		self._rotation_component:update(dt, t)
	end
end

function PlayerStunned:update_movement(dt, t)
	local final_position, wanted_animation_pose

	if self._stun_type == "rooted" then
		final_position, wanted_animation_pose = PlayerMechanicsHelper:scaled_animation_driven_update_movement(self._unit, self._internal, dt, false, self._scale)

		self:_set_rotation(Matrix4x4.rotation(wanted_animation_pose))
	else
		final_position = PlayerMechanicsHelper:script_driven_camera_relative_update_movement(self._unit, self._internal, dt, false)
	end

	self:set_local_position(final_position)
end

function PlayerStunned:update_speed(dt, t)
	local internal = self._internal
	local target_speed

	if self._stun_type == "rooted" then
		target_speed = Vector3(0, 0, 0)
	elseif self._stun_type == "moving" then
		target_speed = self._controller and self._controller:get("move") or Vector3(0, 0, 0)
	elseif self._stun_type == "slowed" then
		local t_val = math.smoothstep(math.clamp((t - self._start_time) / ((self._stun_time - self._start_time) * 0.5), 0, 1), 0, 1)

		target_speed = Vector3.lerp(self._start_speed:unbox(), Vector3(0, 0, 0), t_val)
	else
		target_speed = Vector3.lerp(internal.speed:unbox(), Vector3(0, 0, 0), dt * 3)
	end

	local encumbrance = internal:inventory():encumbrance()
	local speed = self:_calculate_speed(dt, internal.speed:unbox(), target_speed, encumbrance)
	local move_length = Vector3.length(speed)
	local move_speed = move_length * self:_move_speed()

	internal.move_speed = move_speed

	internal.speed:store(speed)
end

function PlayerStunned:_calculate_speed(dt, current_speed, target_speed, encumbrance)
	local x = current_speed.x
	local y = current_speed.y
	local internal = self._internal
	local movement_settings = self._internal.archetype_settings.movement_settings
	local encumbrance_factor = PlayerUnitMovementSettings.encumbrance.functions.movement_acceleration(encumbrance)
	local new_x = movement_settings.movement_acceleration(dt, current_speed.x, target_speed.x, encumbrance_factor)
	local new_y = movement_settings.movement_acceleration(dt, current_speed.y, target_speed.y, encumbrance_factor)
	local ret = Vector3(new_x, new_y, 0)

	return ret
end

local STUN_FORCE = 0.3
local MOUNTED_IMPACT_FAST_THRESHOLD = 3.6

function PlayerStunned:enter(old_state, hit_zone, impact_direction, impact_type)
	PlayerStunned.super.enter(self, old_state)
	self:safe_action_interrupt("stunned")

	local t = Managers.time:time("game")
	local animation_stun_time, animation_event, stun_type, stun_time

	self._scale = 1

	if impact_type == "squad_spawn" then
		animation_event = "stun_spawn"
		stun_type = "rooted"
		stun_time = 1.65
	else
		stun_type = "forced"

		local camera_manager = Managers.state.camera

		camera_manager:camera_effect_sequence_event("stunned", t)
		camera_manager:camera_effect_shake_event("stunned", t)

		if impact_type == "mounted_stun_dismount" then
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, "mounted_stun_dismount", impact_direction)
		elseif impact_type == "shield_bash_impact" then
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, "shield_bash_impact", impact_direction)
		elseif impact_type == "push_impact" then
			stun_type = "rooted"

			local forward_direction

			animation_event, animation_stun_time, forward_direction = WeaponHelper:player_unit_stun_animation(self._unit, "push_impact", impact_direction)

			if forward_direction then
				local internal = self._internal
				local flat_forward = Vector3.flat(forward_direction:unbox())
				local flat_impact_dir = Vector3.flat(impact_direction)
				local rotation = Unit.world_rotation(self._unit, 0)
				local direction = Quaternion.rotate(rotation, flat_forward)
				local angle = math.atan2(flat_impact_dir.y, flat_impact_dir.x) - math.atan2(direction.y, direction.x)
				local rot = Quaternion(Vector3.up(), angle)
				local old_rot = GameSession.game_object_field(internal.game, internal.id, "rotation")
				local new_rot = Quaternion.multiply(rot, old_rot)

				self:_set_rotation(new_rot)
			end
		elseif impact_type == "push_impact_scaled" then
			stun_type = "rooted"

			local forward_direction

			self._scale = 0.4
			animation_event, animation_stun_time, forward_direction = WeaponHelper:player_unit_stun_animation(self._unit, "push_impact", impact_direction)

			if forward_direction then
				local internal = self._internal
				local flat_forward = Vector3.flat(forward_direction:unbox())
				local flat_impact_dir = Vector3.flat(impact_direction)
				local rotation = Unit.world_rotation(self._unit, 0)
				local direction = Quaternion.rotate(rotation, flat_forward)
				local angle = math.atan2(flat_impact_dir.y, flat_impact_dir.x) - math.atan2(direction.y, direction.x)
				local rot = Quaternion(Vector3.up(), angle)
				local old_rot = GameSession.game_object_field(internal.game, internal.id, "rotation")
				local new_rot = Quaternion.multiply(rot, old_rot)

				self:_set_rotation(new_rot)
			end
		elseif impact_type == "rush_impact" then
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, "rush_impact", impact_direction)
		elseif impact_type == "rush_impact_travel_mode" then
			stun_type = "rooted"
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, "rush_impact_travel_mode", impact_direction)
		elseif impact_type == "travel_mode_damage" then
			stun_type = "slowed"
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, "travel_mode_damage", impact_direction)
		elseif impact_type == "mount_impact" then
			local mounted_impact_type = Vector3.length(impact_direction) > MOUNTED_IMPACT_FAST_THRESHOLD and "mount_impact_fast" or "mount_impact_slow"

			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, mounted_impact_type, impact_direction)
		else
			animation_event, animation_stun_time = WeaponHelper:player_unit_stun_animation(self._unit, hit_zone, impact_direction)
		end

		stun_time = PlayerUnitMovementSettings.encumbrance.functions.stun_time(self._internal:inventory():encumbrance()) * animation_stun_time
	end

	self:anim_event_with_variable_float(animation_event, "stun_time", stun_time)

	local t = Managers.time:time("game")
	local internal = self._internal

	self._stun_time = stun_time + t
	self._start_time = t
	self._start_speed = Vector3Box(internal.speed:unbox())

	local unit = internal.unit

	if stun_type == "forced" then
		local speed = internal.speed:unbox()
		local rot = internal.aim_rotation:unbox()
		local impulse = Vector3(Vector3.dot(impact_direction, Quaternion.right(rot)), Vector3.dot(impact_direction, Quaternion.forward(rot)), 0)

		if impact_type == "mount_impact" then
			speed = speed + impulse
		else
			speed = Vector3.normalize(speed + impulse * STUN_FORCE)
		end

		internal.speed:store(speed)
	end

	self._stun_type = stun_type
end

function PlayerStunned:exit(new_state)
	PlayerStunned.super.exit(self, new_state)
	self:anim_event("stun_end")

	self._stun_time = nil
end

function PlayerStunned:update_transitions(dt, t)
	if t > self._stun_time then
		self:change_state("onground")
	end
end

function PlayerStunned:destroy()
	return
end
