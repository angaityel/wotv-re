-- chunkname: @scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component.lua

PlayerStateWorldRotationComponent = class(PlayerStateWorldRotationComponent)

function PlayerStateWorldRotationComponent:init(unit, internal, state, rotation_lerp_factor, rotation_max_speed)
	self._data = internal
	self._state = state
	self._unit = unit
	self._rotation_lerp_factor = rotation_lerp_factor or 10
	self._rotation_max_speed = rotation_max_speed
end

function PlayerStateWorldRotationComponent:update(dt, t)
	self:_update_current_rotation(dt)
end

function PlayerStateWorldRotationComponent:set_rotation_max_speed(radians_per_sec)
	self._rotation_max_speed = radians_per_sec
end

function PlayerStateWorldRotationComponent:_update_current_rotation(dt)
	local unit = self._unit
	local data = self._data
	local target_rot = data.target_world_rotation:unbox()
	local current_rot = Unit.local_rotation(unit, 0)
	local max_speed = self._rotation_max_speed
	local max_lerp = 1

	if max_speed then
		local flat_current = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rot)))
		local flat_target = Vector3.normalize(Vector3.flat(Quaternion.forward(target_rot)))
		local dot_angle = Vector3.dot(flat_current, flat_target)
		local angle = math.acos(math.clamp(dot_angle, -1, 1))

		if angle > 0 then
			max_lerp = max_speed * dt / angle
		end
	end

	local new_rot = Quaternion.lerp(current_rot, target_rot, math.min(dt * self._rotation_lerp_factor, max_lerp))
	local aim_vector = self._data.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())

	data.camera_local_current_rotation:store(Quaternion.multiply(new_rot, Quaternion.inverse(aim_rot_flat)))
	data.move_rot:store(Quaternion.multiply(aim_rot_flat, Quaternion.look(data.speed:unbox(), Vector3.up())))
	self._state:_update_rotation_variable(dt, Unit.local_rotation(self._unit, 0), new_rot)
	self._state:_set_rotation(new_rot)
end
