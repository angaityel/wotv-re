-- chunkname: @scripts/unit_extensions/default_player_unit/states/state_components/player_state_travel_mode_rotation_component.lua

PlayerStateTravelModeRotationComponent = class(PlayerStateTravelModeRotationComponent)
EPSILON = 0.0001

function PlayerStateTravelModeRotationComponent:init(unit, internal, state, rotation_lerp_factor, rotation_max_speed, chase_mode_rotation_lerp_factor, chase_rotation_max_speed)
	self._data = internal
	self._state = state
	self._unit = unit
	self._rotation_lerp_factor = rotation_lerp_factor or 5
	self._rotation_max_speed = rotation_max_speed or 2 * math.pi
	self._chase_rotation_lerp_factor = chase_mode_rotation_lerp_factor or rotation_lerp_factor
	self._chase_rotation_max_speed = chase_rotation_max_speed or rotation_max_speed
end

function PlayerStateTravelModeRotationComponent:update(dt, t, epsilon)
	local data = self._data
	local move = data.speed:unbox()
	local unit = self._unit
	local y = move.y + (epsilon or EPSILON)
	local camera_manager = Managers.state.camera
	local camera_rotation = camera_manager:camera_rotation(data.player.viewport_name)
	local flat_camera_rot = Quaternion.look(Vector3.flat(Quaternion.forward(camera_rotation)), Vector3.up())
	local speed = Vector3.normalize(data.speed:unbox())
	local target_dir = Quaternion.right(flat_camera_rot) * speed.x + Quaternion.forward(flat_camera_rot) * speed.y
	local inverse_move_rot = false

	if y < 0 then
		target_dir = -target_dir
		inverse_move_rot = true
	end

	local target_rotation = Quaternion.look(target_dir, Vector3.up())

	self._state:set_target_world_rotation(target_rotation)
	self:_update_current_rotation(dt, inverse_move_rot)
end

function PlayerStateTravelModeRotationComponent:_update_current_rotation(dt, inverse_move_rot)
	local unit = self._unit
	local data = self._data
	local target_rot = data.target_world_rotation:unbox()
	local current_rot = Unit.local_rotation(unit, 0)
	local lerp_factor, max_speed

	if self._data.chase_mode then
		lerp_factor = self._chase_rotation_lerp_factor
		max_speed = self._chase_rotation_max_speed
	else
		lerp_factor = self._rotation_lerp_factor
		max_speed = self._rotation_max_speed
	end

	local flat_current = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rot)))
	local flat_target = Vector3.normalize(Vector3.flat(Quaternion.forward(target_rot)))
	local dot_angle = Vector3.dot(flat_current, flat_target)
	local angle = math.acos(math.clamp(dot_angle, -1, 1))
	local max_lerp = 1

	if angle > 0 then
		max_lerp = max_speed * dt / angle
	end

	local new_rot = Quaternion.lerp(current_rot, target_rot, math.min(dt * lerp_factor, max_lerp))
	local aim_vector = self._data.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())

	data.camera_local_current_rotation:store(Quaternion.multiply(new_rot, Quaternion.inverse(aim_rot_flat)))

	if inverse_move_rot then
		local new_rot_inverse = Quaternion.look(-Quaternion.forward(new_rot), Vector3.up())

		data.move_rot:store(new_rot_inverse)
	else
		data.move_rot:store(new_rot)
	end

	self._state:_update_rotation_variable(dt, Unit.local_rotation(self._unit, 0), new_rot)
	self._state:_set_rotation(new_rot)
end
