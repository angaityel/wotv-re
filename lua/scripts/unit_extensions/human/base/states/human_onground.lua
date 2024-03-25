-- chunkname: @scripts/unit_extensions/human/base/states/human_onground.lua

require("scripts/unit_extensions/default_player_unit/states/player_movement_state_base")

HumanOnground = class(HumanOnground, PlayerMovementStateBase)

function HumanOnground:can_double_time()
	local internal = self._internal

	return false
end

function HumanOnground:can_unsheath_weapon()
	local internal = self._internal

	if not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.posing and not internal.swinging and not internal.attempting_pose and not internal.attempting_parry and not internal.aiming and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_wield_weapon(slot_name, t)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.wielding and not internal.posing and not internal.swinging and not internal.attempting_pose and not internal.attempting_parry and not internal.aiming and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.dual_wield_attacking then
		local inventory = internal:inventory()

		if slot_name and inventory:can_wield(slot_name, internal.current_state_name) then
			return true
		end
	end

	return false
end

function HumanOnground:can_toggle_weapon(slot_name, t)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.posing and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.dual_wield_attacking then
		local inventory = internal:inventory()

		if slot_name and inventory:can_unwield(slot_name) and inventory:can_toggle(slot_name) then
			return true
		end
	end

	return false
end

function HumanOnground:can_pommel_bash(t, no_stamina_sound)
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()

	if slot_name and self:stamina_can_activate(t, self:_swing_stamina_settings(slot_name), no_stamina_sound) and not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.wielding and not internal.posing and not internal.swinging and not internal.pose_ready and not internal.blocking and internal.parrying and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and GameSettingsDevelopment.allow_pommel_bash and not internal.dual_wield_attacking then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_attempt_pose_melee_weapon(t, no_stamina_sound)
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()

	if slot_name and self:stamina_can_activate(t, self:_swing_stamina_settings(slot_name), no_stamina_sound, internal.stamina.swing_chain_use_data) and not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.wielding and not internal.posing and not internal.swinging and not internal.pose_ready and not internal.blocking and not internal.parrying and not internal.attempting_parry and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal.dual_wield_attacking then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_pose_melee_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()

	if not internal.sheathing and not internal.unsheathing and not internal.throw_data and slot_name and not internal.posing and not internal.swinging and internal.pose_ready and not internal.blocking and not internal.parrying and not internal.attempting_parry and not internal.ghost_mode and not internal.dual_wield_attacking then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_swing_melee_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.pose_slot_name

	if not internal.throw_data and internal.posing and not internal.swinging and not internal.crouching and slot_name and inventory:is_wielded(slot_name) and not internal.dual_wield_attacking then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_special_attack(t, stamina_settings)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and self:stamina_can_activate(t, stamina_settings or PlayerUnitMovementSettings.special_attack.stamina_settings) and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_dual_wield_attack(t, attack_name, slot_name)
	local internal = self._internal
	local attack_settings = internal:inventory():gear(slot_name):settings().attacks[attack_name]

	if not internal.dual_wield_attacking and not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode then
		local has_stamina = self:stamina_can_activate(t, attack_settings.stamina_settings)

		return has_stamina, true
	else
		return false, false
	end
end

function HumanOnground:can_stance_special_attack(t, slot_name)
	local internal = self._internal
	local inventory = internal:inventory()

	return self:can_special_attack(t) and inventory:stance_special_attack_requirements_met(slot_name)
end

function HumanOnground:can_dodge(t, stamina_settings)
	local internal = self._internal

	if self:stamina_can_activate(t, stamina_settings, false, internal.stamina.dodge_chain_use_data) and not internal.unsheathing and not internal.travel_mode and not internal.aiming and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_loot(target, t)
	local internal = self._internal

	if Managers.lobby.lobby and not Managers.state.network:game_object_id(target) then
		return false
	end

	if not internal.travel_mode and not internal.sheathing and not internal.reloading and not internal.unsheathing and not internal.attempting_pose and not internal.attempting_parry and not internal.blocking and not internal.wielding and not internal.aiming and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal:has_perk("berserk_01") and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_loot_trap(target, t)
	local internal = self._internal
	local trap_manager = Managers.state.trap
	local trap_owner = trap_manager:owner(target)
	local owns_trap = trap_owner == internal.player

	if owns_trap and not internal.travel_mode and not internal.sheathing and not internal.reloading and not internal.unsheathing and not internal.attempting_pose and not internal.attempting_parry and not internal.blocking and not internal.wielding and not internal.aiming and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_switch_item(target, t)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.reloading and not internal.unsheathing and not internal.attempting_pose and not internal.attempting_parry and not internal.blocking and not internal.wielding and not internal.aiming and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.swinging and (not internal.swing_recover_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_travel_mode(t, stamina_settings)
	local internal = self._internal

	if not internal.attempting_pose and not internal.attempting_parry and not internal.blocking and not internal.wielding and not internal.aiming and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode and not internal.dual_wield_attacking and self:stamina_can_activate(t, stamina_settings) then
		return true
	end

	return false
end

function HumanOnground:can_backstab(t)
	local internal = self._internal
	local inventory = internal:inventory()

	if not internal.ghost_mode and not internal.travel_mode and not internal.throw_data and not internal.posing and not internal.swinging and inventory:is_wielded("dagger") and internal:has_perk("backstab") and t - internal.chase_mode.last_hit_time <= PlayerUnitMovementSettings.backstab.last_chase_mode_hit_timer and not internal.dual_wield_attacking then
		return true
	end

	return false
end

function HumanOnground:can_shield_bash(t)
	local internal = self._internal

	return not internal.throw_data and t > internal.shield_bash_cooldown and t > internal.anim_forced_upper_body_block and internal.blocking and internal:has_perk("shield_bash") and not internal.ghost_mode
end

function HumanOnground:can_push(t)
	local internal = self._internal

	return not internal.throw_data and t > internal.push_cooldown and t > internal.anim_forced_upper_body_block and internal.parrying and internal:has_perk("push") and not internal.ghost_mode
end

function HumanOnground:can_call_horse(unit, t)
	local internal = self._internal
	local owned_mount = internal.owned_mount_unit
	local mount_locomotion = Unit.alive(owned_mount) and ScriptUnit.extension(owned_mount, "locomotion_system")
	local mount_stolen = mount_locomotion and Unit.get_data(owned_mount, "user_unit")

	return not internal.throw_data and internal:has_perk("cavalry") and internal._player_profile.mount and not mount_stolen and not internal.call_horse_release_button and t >= internal.call_horse_blackboard.cooldown_time and not internal.posing and not internal.swinging and not internal.wielding and not internal.blocking and not internal.parrying and not internal.reloading and not internal.attempting_pose and not internal.attempting_parry and not internal.aiming and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode
end

function HumanOnground:can_mount(t)
	local internal = self._internal

	return not internal.throw_data and not internal.posing and not internal.swinging and not internal.wielding and not internal.blocking and not internal.parrying and not internal.reloading and not internal.attempting_pose and not internal.attempting_parry and not internal.aiming and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.ghost_mode
end

function HumanOnground:can_rush(t, stamina_settings, no_sound)
	local internal = self._internal
	local inventory = internal:inventory()
	local enc = inventory:encumbrance()

	if not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.attempting_parry and not internal.blocking and not internal.parrying and not internal.aiming and t > internal.rush_cooldown_time and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.reloading and not internal.ghost_mode and self:stamina_can_activate(t, stamina_settings or PlayerUnitMovementSettings.rush.stamina_settings, no_sound) then
		return true
	else
		return false
	end
end

local EPSILON = 0.01

function HumanOnground:_double_time_speed()
	local internal = self._internal
	local inventory = self._internal:inventory()
	local enc = inventory:encumbrance()

	if internal:has_perk("runner") then
		local perk = Perks.runner

		return PlayerUnitMovementSettings.double_time.move_speed * perk.move_speed_multiplier * PlayerUnitMovementSettings.encumbrance.functions.double_time_speed(enc)
	else
		return PlayerUnitMovementSettings.double_time.move_speed * PlayerUnitMovementSettings.encumbrance.functions.double_time_speed(enc)
	end
end

function HumanOnground:_max_speed()
	local internal = self._internal
	local max_speed = self:_double_time_speed()
	local unit = internal.unit

	return max_speed + EPSILON
end

function HumanOnground:can_jump(t, stamina_settings)
	local internal = self._internal

	return self:stamina_can_activate(t, stamina_settings) and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.aiming and not internal.posing and not internal.swinging and not internal.crouching and not internal.wielding and not internal.reloading and not internal.blocking and not internal.parrying and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.on_slope and not internal.dual_wield_attacking
end

function HumanOnground:can_revive(t)
	local internal = self._internal

	return InteractionHelper:can_request("revive", internal) and self:_can_interact(t)
end

function HumanOnground:can_abort_melee_swing()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.swing_slot_name

	if internal.swinging and slot_name and inventory:is_wielded(slot_name) then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_aim_ranged_weapon(no_sound)
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_ranged_weapon_slot()

	if slot_name then
		local gear = inventory:gear(slot_name)
		local extensions = gear:extensions()
		local weapon_ext = extensions and extensions.base
		local weapon_can_aim = true

		if weapon_ext then
			weapon_can_aim = weapon_ext:can_aim()
		end

		local t = Managers.time:time("game")
		local stamina_settings = gear:settings().attacks.ranged.stamina_settings

		if not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and not internal.wielding and not internal.reloading and not internal.ghost_mode and weapon_can_aim and self:stamina_can_activate(t, stamina_settings, no_sound) then
			return true, slot_name
		end
	end

	return false, nil
end

function HumanOnground:can_unaim_ranged_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.aim_slot_name

	if internal.aiming and slot_name and inventory:is_wielded(slot_name) then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_fire_ranged_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.aim_slot_name

	if internal.aiming and not internal.reloading and slot_name and inventory:is_wielded(slot_name) and not internal.ghost_mode then
		local gear = inventory:gear(slot_name)
		local extensions = gear:extensions()
		local weapon_ext = extensions.base

		if weapon_ext:can_fire() then
			return true, slot_name
		end
	end

	return false, nil
end

function HumanOnground:can_reload(slot_name, aim_input)
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(slot_name)
	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local weapon_category = weapon_ext:category()
	local t = Managers.time:time("game")

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and t > internal.anim_forced_upper_body_block and inventory:can_reload(slot_name) and (weapon_category ~= "crossbow" or aim_input) and (weapon_category == "bow" or not internal.aiming) and not internal.wielding and not internal.ghost_mode then
		return true
	end

	return false
end

function HumanOnground:can_dual_wield_defend(t)
	local internal = self._internal
	local damage_ext = ScriptUnit.extension(self._unit, "damage_system")

	if not internal.dual_wield_attacking and not damage_ext:is_last_stand_active() and Perks.last_stand.disallow_defending and not internal.travel_mode and not internal.sheathing and not internal.unsheathing and (not internal.throw_data or internal.throw_data.state == "posing" and t > internal.throw_data.pose_time) and t > internal.anim_forced_upper_body_block and (not internal.swinging or t < internal.swing_abort_time) and (not internal.swing_parry_recovery_time or t > internal.swing_parry_recovery_time) and not internal.wielding and not internal.ghost_mode then
		return true
	end

	return false
end

function HumanOnground:can_raise_block(t)
	local internal = self._internal

	if internal.pre_swing or internal.swinging then
		return false, nil
	end

	local inventory = internal:inventory()
	local slot_name = inventory:wielded_block_slot()
	local block_type = slot_name and inventory:block_type(slot_name)

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and (not internal.throw_data or internal.throw_data.state == "posing" and t > internal.throw_data.pose_time) and t > internal.anim_forced_upper_body_block and block_type and (not internal.swinging or t < internal.swing_abort_time) and (not internal.swing_parry_recovery_time or t > internal.swing_parry_recovery_time) and not internal.wielding and not internal.dual_wield_attacking and not internal.ghost_mode then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_lower_block()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.block_slot_name

	if (internal.blocking or internal.parrying) and slot_name and inventory:is_wielded(slot_name) then
		return true, slot_name
	end

	return false, nil
end

function HumanOnground:can_crouch(t)
	local internal = self._internal

	return not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.posing and not internal.swinging and not internal.parrying and not internal.attempting_parry and not internal.attempting_pose and not internal.aiming and not internal.wielding and not internal.reloading and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.dual_wield_attacking
end

function HumanOnground:can_pickup_flag()
	local internal = self._internal

	return not internal.carried_flag and not internal.picking_flag and not internal.ghost_mode
end

function HumanOnground:can_drop_flag()
	local internal = self._internal

	return internal.carried_flag
end

function HumanOnground:can_plant_flag()
	local internal = self._internal

	return internal.carried_flag
end

function HumanOnground:_can_interact(t)
	local internal = self._internal

	return not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.posing and not internal.swinging and not internal.blocking and not internal.parrying and not internal.attempting_parry and not internal.attempting_pose and not internal.aiming and not internal.wielding and not internal.reloading and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.interacting and not internal.ghost_mode and not internal.dual_wield_attacking
end

function HumanOnground:can_climb(t)
	local internal = self._internal

	return not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.posing and not internal.swinging and not internal.blocking and not internal.parrying and not internal.attempting_parry and not internal.attempting_pose and not internal.aiming and not internal.wielding and not internal.reloading and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.interacting and not internal.dual_wield_attacking
end

function HumanOnground:can_execute(t)
	local internal = self._internal

	return InteractionHelper:can_request("execute", internal) and self:_can_interact(t)
end

function HumanOnground:can_bandage(t)
	local internal = self._internal
	local damage_ext = ScriptUnit.extension(self._unit, "damage_system")

	return InteractionHelper:can_request("bandage", internal) and self:_can_interact(t) and not internal:has_perk("oblivious") and damage_ext:can_heal()
end

function HumanOnground:can_trigger(t)
	local internal = self._internal

	return InteractionHelper:can_request("trigger", internal) and self:_can_interact(t)
end

function HumanOnground:can_taunt(t, settings)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and self:stamina_can_activate(t, settings.stamina_settings or {
		minimum_activation_cost = 0,
		activation_delay = 0,
		activation_cost = 0
	}) and not internal.dual_wield_attacking then
		return true
	end
end

function HumanOnground:can_place_alert_trap(t)
	local internal = self._internal

	if not internal.travel_mode and not internal.sheathing and not internal.unsheathing and not internal.throw_data and not internal.wielding and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time) and not internal.dual_wield_attacking then
		return true
	end
end
