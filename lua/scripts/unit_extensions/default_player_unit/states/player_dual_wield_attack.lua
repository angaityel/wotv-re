-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_dual_wield_attack.lua

require("scripts/unit_extensions/default_player_unit/states/player_special_attack")

PlayerDualWieldAttack = class(PlayerDualWieldAttack, PlayerSpecialAttack)

local ABORT_TIME = 0.1

function PlayerDualWieldAttack:init(...)
	PlayerDualWieldAttack.super.init(self, ...)

	self._input_queue = {}
	self._input_queue_max_length = 1
end

function PlayerDualWieldAttack:enter(...)
	PlayerDualWieldAttack.super.enter(self, ...)
	table.clear(self._input_queue)
end

function PlayerDualWieldAttack:update(dt, t)
	PlayerDualWieldAttack.super.super.update(self, dt, t)

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

	if self:_inair_check(dt, t) then
		self:anim_event("to_inair")

		self._transition = "inair"
	end

	if t > self._start_time + self:_abort_time(attack_settings) and not self._stamina_consumed then
		self:_consume_stamina()
	end

	self:_update_input(dt, t, self._controller)

	local attack_name, slot_name = self:_update_attacks(dt, t)

	if attack_name then
		table.remove(self._input_queue, 1)
		self:_start_next_attack({
			attack_name = attack_name,
			slot_name = slot_name
		})
		print("DUAL WIELD", attack_name, self._internal:inventory():gear(slot_name):settings().attacks[attack_name].attack_time)
	end

	if self._transition then
		self:change_state(self._transition, self._transition_data)
		self:safe_action_interrupt("state_" .. self._transition)

		self._transition = nil
	end
end

function PlayerDualWieldAttack:_start_next_attack(data)
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

	self._stamina_consumed = false

	local viewport_name = internal.player.viewport_name

	self._aim_target_interpolation_source = QuaternionBox(Managers.state.camera:camera_rotation(viewport_name))

	self:start_special_attack()

	internal.special_attacking = true

	if not internal.pose_direction then
		self:_set_pose_direction()
	end
end

function PlayerDualWieldAttack:_update_attacks(dt, t)
	local next_attack = self._input_queue[1]

	if next_attack then
		local attack_name, slot_name
		local current_attack = self._attack_name
		local last_attack_left = current_attack == "left_start" or current_attack == "left_alternated" or current_attack == "left_repeated"

		if next_attack == "left" and last_attack_left then
			attack_name = "left_repeated"
			slot_name = "secondary"
		elseif next_attack == "left" then
			attack_name = "left_alternated"
			slot_name = "secondary"
		elseif next_attack == "right" and last_attack_left then
			attack_name = "right_alternated"
			slot_name = "primary"
		elseif next_attack == "right" then
			attack_name = "right_repeated"
			slot_name = "primary"
		else
			assert(false)
		end

		local stamina_settings = self:_swing_stamina_settings(slot_name)
		local can, stamina_is_decider = self:can_dual_wield_attack(t, stamina_settings)

		if can then
			return attack_name, slot_name
		elseif not can and stamina_is_decider then
			table.clear(self._input_queue)
		end
	end
end

local BUTTON_THRESHOLD = 0.5

function PlayerDualWieldAttack:_abort_time(attack_settings)
	return attack_settings.abort_time_factor * attack_settings.attack_time
end

function PlayerDualWieldAttack:_update_input(dt, t, controller)
	if not controller then
		return
	end

	local left_pressed = controller:get("left_hand_attack_pressed")
	local left_held = controller:get("left_hand_attack_held") > BUTTON_THRESHOLD
	local right_pressed = controller:get("right_hand_attack_pressed")
	local right_held = controller:get("right_hand_attack_held") > BUTTON_THRESHOLD

	if right_held and left_held then
		table.clear(self._input_queue)

		if t < self:_abort_time(self._attack_settings) + self._start_time then
			self._transition = "onground"
		end

		return
	end

	local current_index = math.min(#self._input_queue + 1, self._input_queue_max_length)

	if left_pressed then
		self._input_queue[current_index] = "left"
	elseif right_pressed then
		self._input_queue[current_index] = "right"
	elseif controller:get("dodge") then
		table.clear(self._input_queue)
	end
end

function PlayerDualWieldAttack:_consume_stamina()
	self._stamina_consumed = true

	self:stamina_activate(self._attack_settings.stamina_settings)
end

function PlayerDualWieldAttack:_end_attack(reason)
	self._attacking = false

	if not self._stamina_consumed and reason then
		self:_consume_stamina()
	end

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

	local swing_recovery, animation_recovery, parry_recovery

	if reason == "hit_character" then
		swing_recovery = swing_time_left
		parry_recovery = swing_time_left
		animation_recovery = swing_recovery + 0.1

		self:anim_event_with_variable_float("attack_hit_soft", "weapon_penetration", penalties.character_hit_animation_speed)
	elseif reason == "hard" then
		swing_recovery = swing_time_left
		parry_recovery = swing_time_left
		animation_recovery = swing_recovery + 0.1

		self:anim_event_with_variable_float("swing_attack_interrupt", "weapon_penetration", 0)
	elseif reason == "blocking" then
		swing_recovery = penalties.blocked
		parry_recovery = penalties.blocked_parry or penalties.blocked
		animation_recovery = swing_recovery + 0.1

		self:anim_event_with_variable_float("swing_attack_interrupt", "weapon_penetration", 0)
	elseif reason == "parrying" then
		swing_recovery = penalties.parried
		parry_recovery = penalties.parried_parry or penalties.parried
		animation_recovery = swing_recovery + 0.1

		self:anim_event_with_variable_float("swing_attack_interrupt", "weapon_penetration", 0)
	elseif not hit then
		animation_recovery = penalties.miss + 0.1
		swing_recovery = penalties.miss
		parry_recovery = penalties.miss_parry or penalties.miss
	else
		animation_recovery = 0.1
		swing_recovery = penalties.hit
		parry_recovery = 0
	end

	local t = Managers.time:time("game")

	internal.swing_recovery_time = t + swing_recovery
	internal.swing_parry_recovery_time = t + parry_recovery
	self._end_time = t + animation_recovery
	self._attack_end_reason = reason

	if internal.pose_direction then
		self:_unset_pose_direction()
	end
end

function PlayerDualWieldAttack:can_dual_wield_attack(t)
	if not self._attacking and not self._transition and (not self._internal.swing_recovery_time or t > self._internal.swing_recovery_time) then
		local has_stamina = self:stamina_can_activate(t, PlayerUnitMovementSettings.special_attack.stamina_settings)

		return has_stamina, true
	else
		return false, false
	end
end
