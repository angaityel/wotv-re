-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_pushing.lua

PlayerPushing = class(PlayerPushing, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerPushing:init(unit, internal, world)
	PlayerPushing.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerPushing:update(dt, t)
	PlayerPushing.super.update(self, dt, t)
	self:update_rotation(dt, t)
	self:update_movement(dt, t)
end

function PlayerPushing:update_movement(dt)
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

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	internal.velocity:store(delta / dt)
	self:set_local_position(final_position)
end

function PlayerPushing:enter(old_state)
	PlayerPushing.super.enter(self, old_state)
	self:_align_to_camera()

	local internal = self._internal
	local inventory = internal:inventory()

	self:_swing_push()
	self:_play_voice("chr_vce_push")
end

function PlayerPushing:exit(new_state)
	PlayerPushing.super.exit(self, new_state)

	local internal = self._internal

	internal.swinging_push = false

	self:_play_voice("stop_chr_vce_push")
end

function PlayerPushing:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerPushing:_swing_push(t)
	local internal = self._internal

	internal.swinging_push = true

	local inventory = internal:inventory()
	local slot_name = inventory:wielded_block_slot()
	local gear = inventory:gear(slot_name)
	local attack_settings = Gear[gear:name()].attacks.push

	gear:start_melee_attack(0, "push", attack_settings, callback(self, "gear_cb_abort_push_swing"), attack_settings.attack_time)
	self:anim_event_with_variable_float("push_start", "push_time", attack_settings.attack_time)
end

function PlayerPushing:anim_cb_push_damage_finished()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_block_slot()
	local gear = inventory:gear(slot_name)

	self:push_swing_finished()
end

function PlayerPushing:anim_cb_push_finished()
	self:anim_event("push_finished")
	self:change_state("onground")
end

function PlayerPushing:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
