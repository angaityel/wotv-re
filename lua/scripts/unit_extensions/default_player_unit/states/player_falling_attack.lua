-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_falling_attack.lua

PlayerFallingAttack = class(PlayerFallingAttack, PlayerMovementStateBase)

function PlayerFallingAttack:init(unit, internal, world)
	PlayerFallingAttack.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerFallingAttack:update(dt, t)
	PlayerFallingAttack.super.update(self, dt, t)
	self:_update_movement(dt, t)
	self:_update_rotation(dt, t)
	self:_update_attack(dt, t)
	self:_update_transition(dt, t)
end

function PlayerFallingAttack:_update_attack(dt, t)
	local attack_settings = self._attack_settings

	if self._attacking and t > self._start_time + attack_settings.attack_time then
		self:_end_attack()
	end
end

function PlayerFallingAttack:_update_transition(dt, t)
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

		if landing ~= "knocked_down" then
			landing = landing .. "_attack"
		end

		self:change_state("landing", landing)
	end
end

function PlayerFallingAttack:enter(old_state, data)
	PlayerFallingAttack.super.enter(self, old_state)

	local internal = self._internal

	internal.falling = true
	self._fall_height = data.fall_height
	self._suicided = false

	self:set_target_world_rotation(Quaternion.look(Vector3.flat(Quaternion.forward(Unit.local_rotation(self._unit, 0))), Vector3.up()))

	local attack_name = data.attack_name
	local slot_name = data.slot_name
	local stamina_settings = data.stamina_settings

	self._attack_name = attack_name
	self._slot_name = slot_name
	self._start_time = Managers.time:time("game")
	self._end_time = math.huge
	self._attacking = true

	self:_align_to_camera()
	self:stamina_activate(stamina_settings)

	local viewport_name = internal.player.viewport_name

	self:start_attack()
end

function PlayerFallingAttack:exit(new_state)
	PlayerFallingAttack.super.exit(self, new_state)

	self._internal.falling = false
	self._suicided = false

	if self._attacking then
		self:_end_attack()
	end
end

function PlayerFallingAttack:_update_movement(dt)
	local final_position = PlayerMechanicsHelper:velocity_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerFallingAttack:_update_rotation(dt, t)
	self:update_aim_rotation(dt, t)

	local internal = self._internal
	local aim_vector = internal.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())
	local velocity = internal.velocity:unbox()

	internal.speed:store(Vector3(Vector3.dot(Quaternion.right(aim_rot_flat), velocity), Vector3.dot(Quaternion.forward(aim_rot_flat), velocity), 0) / self:_move_speed())
	self._rotation_component:update(dt, t)
end

function PlayerFallingAttack:_end_attack(reason)
	self._attacking = false

	local swing_recovery
	local internal = self._internal
	local hit, _, swing_time_left
	local penalties = self._attack_settings.penalties
	local inventory = internal:inventory()
	local gear = inventory:gear(self._slot_name)

	_, hit, swing_time_left = gear:end_melee_attack()

	if reason == "hit_character" then
		swing_recovery = swing_time_left + penalties.hit

		self:anim_event_with_variable_float("attack_hit_hard", "weapon_penetration", penalties.character_hit_animation_speed)
	elseif reason == "hard" then
		swing_recovery = penalties.hard
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

	if internal.pose_direction then
		self:_unset_pose_direction()
	end
end

function PlayerFallingAttack:start_attack()
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(self._slot_name)
	local attack_settings = gear:settings().attacks[self._attack_name]

	self._attack_settings = attack_settings

	gear:start_melee_attack(0, self._attack_name, attack_settings, callback(self, "gear_cb_abort_special_attack"), attack_settings.attack_time)
	self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_settings.attack_time)
end

function PlayerFallingAttack:gear_cb_abort_special_attack(reason)
	if self._attacking then
		self:_end_attack(reason)
	end
end

function PlayerFallingAttack:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
