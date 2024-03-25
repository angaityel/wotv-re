-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_jumping.lua

PlayerJumping = class(PlayerJumping, PlayerMovementStateBase)

function PlayerJumping:init(unit, internal, world)
	PlayerJumping.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateLocalRotationComponent:new(unit, internal, self)
end

function PlayerJumping:update(dt, t)
	PlayerJumping.super.update(self, dt, t)
	self:update_movement(dt, t)
	self:update_rotation(dt, t)
	self:update_transition(dt, t)
end

function PlayerJumping:update_transition(dt)
	if self._movement_type ~= "falling" then
		return
	end

	local unit = self._unit
	local mover = Unit.mover(unit)
	local internal = self._internal
	local pos = Mover.position(mover)
	local fall_distance = PlayerMechanicsHelper.calculate_fall_distance(internal, self._fall_height, pos)

	if fall_distance > PlayerUnitMovementSettings.fall.heights.dead and not self._suicided then
		PlayerMechanicsHelper.suicide(internal)

		self._suicided = true
	elseif Mover.collides_down(mover) and Mover.flying_frames(mover) == 0 then
		local landing = PlayerMechanicsHelper._pick_landing(internal, fall_distance)

		self:change_state("landing", landing)
	end
end

function PlayerJumping:enter(old_state)
	PlayerJumping.super.enter(self, old_state)

	local internal = self._internal

	internal.jumping = true
	self._fall_height = nil
	self._movement_type = "jumping"
	self._suicided = false

	local t = Managers.time:time("game")
	local camera_manager = Managers.state.camera

	camera_manager:camera_effect_sequence_event("jumped", t)
	camera_manager:camera_effect_shake_event("jumped", t)
end

function PlayerJumping:exit(new_state)
	PlayerJumping.super.exit(self, new_state)

	self._movement_type = nil
	self._internal.jumping = false
	self._suicided = false
end

function PlayerJumping:update_movement(dt)
	local internal = self._internal
	local final_position = PlayerMechanicsHelper:velocity_driven_update_movement(self._unit, internal, dt, true)

	self:set_local_position(final_position)

	local fall = internal.velocity:unbox().z < 0

	if fall and self._movement_type ~= "falling" then
		self._fall_height = final_position.z
		self._movement_type = "falling"
	elseif not fall then
		self._fall_height = nil
		self._movement_type = "jumping"
	end
end

function PlayerJumping:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)

	local internal = self._internal
	local aim_vector = internal.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())
	local velocity = Vector3.flat(internal.velocity:unbox())

	internal.speed:store(Vector3(Vector3.dot(Quaternion.right(aim_rot_flat), velocity), Vector3.dot(Quaternion.forward(aim_rot_flat), velocity), 0) / self:_move_speed())
	self._rotation_component:update(dt, t, 0.2)
end
