-- chunkname: @scripts/unit_extensions/default_player_unit/states/state_components/player_state_local_rotation_component.lua

PlayerStateLocalRotationComponent = class(PlayerStateLocalRotationComponent)

local EPSILON = 1e-05
local ASYMPTOTIC_INTERPOLATION_SPEED = 5
local MIN_ROTATION_SPEED = math.pi / 16
local MAX_ROTATION_SPEED = math.pi * 2

function PlayerStateLocalRotationComponent:init(unit, internal, state)
	self._data = internal
	self._state = state
	self._unit = unit
end

function PlayerStateLocalRotationComponent:update(dt, t, epsilon)
	local data = self._data
	local move = data.speed:unbox()
	local unit = self._unit
	local x = move.x
	local y = move.y + (epsilon or EPSILON)

	if y < 0 then
		x = -x
	end

	data.camera_local_target_rotation:store(Quaternion(Vector3.up(), -math.atan2(x, math.abs(y))))
	self:_update_current_rotation(dt)
	self._state:set_target_world_rotation(Unit.local_rotation(unit, 0))
end

function PlayerStateLocalRotationComponent:_update_current_rotation(dt)
	local data = self._data
	local unit = self._unit
	local aim_vector = self._data.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())
	local target_rot = data.camera_local_target_rotation:unbox()
	local current_rot = data.camera_local_current_rotation:unbox()
	local diff_rotation = Quaternion.multiply(target_rot, Quaternion.inverse(current_rot))
	local new_rot = current_rot
	local angle = math.abs(Quaternion.angle(diff_rotation))

	if angle ~= 0 then
		local min_lerp_speed = math.min(MIN_ROTATION_SPEED * dt / angle, 1)
		local max_lerp_speed = math.min(MAX_ROTATION_SPEED * dt / angle, 1)
		local lerp_t = math.clamp(ASYMPTOTIC_INTERPOLATION_SPEED * dt, min_lerp_speed, max_lerp_speed)

		new_rot = Quaternion.lerp(current_rot, target_rot, lerp_t)
	end

	data.camera_local_current_rotation:store(new_rot)
	data.move_rot:store(Quaternion.multiply(aim_rot_flat, Quaternion.look(data.speed:unbox(), Vector3.up())))

	local new_world_rot = Quaternion.multiply(new_rot, aim_rot_flat)

	self._state:_update_rotation_variable(dt, Unit.local_rotation(self._unit, 0), new_world_rot)
	self._state:_set_rotation(new_world_rot)
end
