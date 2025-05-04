-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/player_unit_inventory.lua

require("scripts/unit_extensions/default_player_unit/inventory/player_base_inventory")
require("scripts/unit_extensions/default_player_unit/inventory/player_gear")

PlayerUnitInventory = class(PlayerUnitInventory, PlayerBaseInventory)
PlayerUnitInventory.GEAR_CLASS = "PlayerGear"

function PlayerUnitInventory:init(world, user_unit, player, player_unit_game_object_id, secondary_counts_as_primary)
	PlayerBaseInventory.init(self, world, user_unit, player)

	self._player = player
	self._game_object_id = player_unit_game_object_id
	self._encumbrance = 0
	self._voice_type = "voice"
	self._fallback_slot = nil
	self._secondary_counts_as_primary = true
	self._dual_wielding = false
end

function PlayerUnitInventory:is_dual_wielding()
	return self._dual_wielding
end

function PlayerUnitInventory:add_ammo(slot_name, amount)
	local gear = self:gear(slot_name)

	gear:add_ammo(amount)
end

function PlayerUnitInventory:fallback_slot()
	local fallback_slot = self._fallback_slot

	if fallback_slot and self:can_wield(fallback_slot) then
		return fallback_slot
	end

	for _, slot_name in ipairs(InventorySlotPriority) do
		if self:can_wield(slot_name) then
			return slot_name
		end
	end

	assert(false, "[PlayerUnitInventory:fallback_slot()] No fallback slot available, did the dagger break?")
end

function PlayerUnitInventory:best_one_handed_weapon_slot()
	local use_one_handed_slot = self:is_one_handed("primary") and self:is_wielded("primary") and true
	local use_two_handed_slot = self:is_one_handed("secondary") and self:is_wielded("secondary") and true

	return use_one_handed_slot and "primary" or use_two_handed_slot and "secondary" or self:is_one_handed("primary") and self:can_wield("primary") and "primary" or self:is_one_handed("secondary") and self:can_wield("secondary") and "secondary" or "dagger"
end

function PlayerUnitInventory:add_armour(armour_name, pattern_index)
	self._encumbrance = self._encumbrance + Armours[armour_name].encumbrance

	PlayerUnitInventory.super.add_armour(self, armour_name, pattern_index)
end

function PlayerUnitInventory:can_ammo_loot(unit)
	local gear_name = Unit.get_data(unit, "gear_name")
	local gear_settings = Gear[gear_name]

	if not gear_settings.ammo_lootable then
		return false
	end

	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			local settings = gear:settings()

			if gear_settings.gear_type == settings.gear_type and gear:can_ammo_loot() then
				return true, slot_name
			end
		end
	end

	return false
end

function PlayerUnitInventory:drop_wielded_gear()
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() then
			self:drop_gear(slot_name)
		end
	end
end

function PlayerUnitInventory:gear_dead(slot_name)
	local gear_name = self:gear(slot_name):name()

	PlayerUnitInventory.super.gear_dead(self, slot_name)
end

function PlayerUnitInventory:update(dt, t)
	for name, slot in pairs(self._slots) do
		if slot.gear then
			slot.gear:update(dt, t)
		end
	end
end

function PlayerUnitInventory:replace_gear(slot_name, force_remove)
	local occupied_gear = self:gear(slot_name)

	if occupied_gear and occupied_gear:out_of_ammo() or force_remove then
		self:remove_gear(slot_name)
	elseif occupied_gear then
		self:drop_gear(slot_name)
	end
end

function PlayerUnitInventory:add_gear(gear_name, obj_id, wanted_slot_name, user_locomotion, ammo, force_remove)
	local gear_settings = Gear[gear_name]

	fassert(gear_settings, "No gear found with name %q", gear_name)
	self:replace_gear(wanted_slot_name, force_remove)

	local unit, gear = PlayerUnitInventory.super.add_gear(self, gear_name, obj_id, wanted_slot_name, user_locomotion, ammo)
	local encumbrance = gear_settings.encumbrance

	self._encumbrance = self._encumbrance + encumbrance

	return unit, gear, wanted_slot_name
end

function PlayerUnitInventory:remove_gear(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()
	local encumbrance = gear_settings.encumbrance

	self._encumbrance = self._encumbrance - encumbrance

	PlayerUnitInventory.super.remove_gear(self, slot_name)
end

function PlayerUnitInventory:add_helmet(helmet_name, team_name, helmet_variation)
	PlayerUnitInventory.super.add_helmet(self, helmet_name, team_name, helmet_variation)

	local helmet = Helmets[helmet_name]

	self._encumbrance = self._encumbrance + helmet.encumbrance
end

function PlayerUnitInventory:add_helmet_attachment(helmet_name, attachment_type, attachment_name, team_name)
	PlayerUnitInventory.super.add_helmet_attachment(self, helmet_name, attachment_type, attachment_name, team_name)

	local helmet = Helmets[helmet_name]
	local helmet_attachment = helmet.attachments[attachment_name]

	self._encumbrance = self._encumbrance + helmet_attachment.encumbrance
end

function PlayerUnitInventory:add_helmet_crest(crest_name, team_name)
	PlayerUnitInventory.super.add_helmet_crest(self, crest_name, team_name)

	local crest_settings = HelmetCrests[crest_name]

	self._encumbrance = self._encumbrance + crest_settings.encumbrance
end

function PlayerUnitInventory:encumbrance()
	return 0.8
end

function PlayerUnitInventory:can_wield(slot_name, player_state_name)
	local gear = self:gear(slot_name)

	if not gear then
		return false
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions and extensions.base
	local weapon_can_wield = true

	if weapon_ext then
		weapon_can_wield = weapon_ext:can_wield(player_state_name)
	end

	local weapon_specific_can_wield = true

	if slot_name == "shield" then
		weapon_specific_can_wield = self:_can_wield_shield()
	end

	return not gear:wielded() and weapon_can_wield and weapon_specific_can_wield
end

function PlayerUnitInventory:_can_wield_shield()
	local locomotion = ScriptUnit.has_extension(self._user_unit, "locomotion_system") and ScriptUnit.extension(self._user_unit, "locomotion_system")

	if locomotion then
		local best_one_handed = self:best_one_handed_weapon_slot()
		local best_wielded = self:wielded_weapon_slot()

		return best_one_handed ~= "dagger" and best_wielded ~= "dagger"
	end

	return self:wielded_weapon_slot() ~= "dagger"
end

function PlayerUnitInventory:can_throw(has_perk)
	local wielded_weapon_slot = self:wielded_weapon_slot()
	local wielded_gear = wielded_weapon_slot and self:gear(wielded_weapon_slot)
	local wielded_weapon_ext = wielded_gear and wielded_gear:extensions().base

	if has_perk and wielded_weapon_slot and wielded_weapon_ext:can_throw() and wielded_weapon_slot ~= "dagger" then
		return true, wielded_weapon_slot
	elseif wielded_weapon_slot and wielded_weapon_ext:can_throw() and wielded_gear:settings().category == "throwing_weapon" then
		return true, wielded_weapon_slot
	else
		local throwing_gear_slot = "primary"
		local throwing_gear = self:gear(throwing_gear_slot)

		if throwing_gear and throwing_gear:extensions().base:can_throw() and throwing_gear:settings().category == "throwing_weapon" then
			return true, throwing_gear_slot
		end

		throwing_gear_slot = "secondary"
		throwing_gear = self:gear(throwing_gear_slot)

		if throwing_gear and throwing_gear:extensions().base:can_throw() and throwing_gear:settings().category == "throwing_weapon" then
			return true, throwing_gear_slot
		end
	end

	return false
end

function PlayerUnitInventory:can_unwield(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:wielded()
end

function PlayerUnitInventory:can_toggle(slot_name)
	return InventorySlots[slot_name].wield_toggle
end

function PlayerUnitInventory:is_wielded(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:wielded()
end

function PlayerUnitInventory:is_sheathed(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:sheathed()
end

function PlayerUnitInventory:is_equipped(slot_name)
	local gear = self:gear(slot_name)

	return gear and true
end

function PlayerUnitInventory:is_two_handed(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:is_two_handed()
end

function PlayerUnitInventory:is_one_handed(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear and gear:settings()
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")

	return gear and (locomotion:has_perk("shield_maiden01") and gear_settings.gear_type == "spear" or gear:is_one_handed())
end

function PlayerUnitInventory:is_left_handed(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:is_left_handed()
end

function PlayerUnitInventory:is_right_handed(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:is_right_handed()
end

function PlayerUnitInventory:wielded_weapon_slot()
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() and not gear:is_shield() then
			return slot_name
		end
	end
end

function PlayerUnitInventory:wielded_melee_weapon_slot()
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() and gear:is_melee_weapon() then
			return slot_name
		end
	end
end

function PlayerUnitInventory:wielded_block_slot()
	local block_priority = math.huge
	local block_slot_name

	for slot_name, slot in pairs(self._slots) do
		if self:can_block(slot_name) and block_priority > self:block_priority(slot_name) then
			block_priority = self:block_priority(slot_name)
			block_slot_name = slot_name
		end
	end

	return block_slot_name
end

function PlayerUnitInventory:allows_couch()
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() and gear:settings().allows_couch then
			return slot_name
		end
	end
end

function PlayerUnitInventory:gear_couch_settings(slot_name)
	return self:gear(slot_name):settings().attacks.couch
end

function PlayerUnitInventory:gear_unit(slot_name)
	local gear = self:gear(slot_name)

	if gear then
		return self:gear(slot_name):unit()
	end
end

function PlayerUnitInventory:start_couch(slot_name, abort_func)
	local gear = self:gear(slot_name)

	gear:start_couch(abort_func)
end

function PlayerUnitInventory:end_couch(slot_name)
	local gear = self:gear(slot_name)

	gear:end_couch()
end

function PlayerUnitInventory:end_melee_attack(slot_name, reason)
	local gear = self:gear(slot_name)
	local swing_direction, hit, swing_time_left = gear:end_melee_attack()
	local attack_tweak_data = Gear[gear:name()].attacks[swing_direction]
	local swing_recovery, parry_recovery
	local penalty_animation_speed = 0

	if attack_tweak_data == nil then
		return
	end

	if reason == "not_penetrated" then
		swing_recovery = attack_tweak_data.penalties.not_penetrated
		parry_recovery = attack_tweak_data.penalties.not_penetrated_parry or attack_tweak_data.penalties.not_penetrated
	elseif reason == "hit_character" then
		swing_recovery = swing_time_left
		parry_recovery = swing_time_left
		penalty_animation_speed = attack_tweak_data.penalties.character_hit_animation_speed
	elseif reason == "hard" then
		swing_recovery = attack_tweak_data.penalties.hard
		parry_recovery = attack_tweak_data.penalties.hard_parry or attack_tweak_data.penalties.hard
	elseif reason == "blocking" then
		swing_recovery = attack_tweak_data.penalties.blocked
		parry_recovery = attack_tweak_data.penalties.blocked_parry or attack_tweak_data.penalties.blocked
	elseif reason == "parrying" then
		swing_recovery = attack_tweak_data.penalties.parried
		parry_recovery = attack_tweak_data.penalties.parried_parry or attack_tweak_data.penalties.parried
	elseif reason == "dual_wield_defending" then
		swing_recovery = attack_tweak_data.penalties.dual_wield_defended
		parry_recovery = attack_tweak_data.penalties.dual_wield_defended_parry or attack_tweak_data.penalties.dual_wield_defended
	elseif reason == "interrupt" then
		swing_recovery = attack_tweak_data.penalties.interrupt or 0
		parry_recovery = attack_tweak_data.penalties.interrupt_parry or attack_tweak_data.penalties.interrupt or 0
	elseif not hit then
		swing_recovery = attack_tweak_data.penalties.miss
		parry_recovery = attack_tweak_data.penalties.miss_parry or attack_tweak_data.penalties.miss
	else
		parry_recovery = 0
		swing_recovery = 0
	end

	if script_data.damage_debug then
		Managers.state.hud:output_console_text(" [Hit type = " .. (hit and (reason or "hit") or "miss") .. ", Base Swing Recovery = " .. swing_recovery .. "]", Vector3(255, 30, 0))
	end

	return swing_recovery, parry_recovery, penalty_animation_speed
end

function PlayerUnitInventory:can_block(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:wielded() and gear:can_block()
end

function PlayerUnitInventory:can_reload(slot_name)
	local gear = self:gear(slot_name)
	local extensions = gear:extensions()
	local weapon_ext = extensions and extensions.base
	local return_value = true

	if weapon_ext then
		return_value = weapon_ext:can_reload()
	end

	return return_value
end

function PlayerUnitInventory:block_priority(slot_name)
	local gear = self:gear(slot_name)
	local block_type = self:block_type(slot_name)

	return BlockTypes[block_type].priority
end

function PlayerUnitInventory:block_type(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()

	return gear_settings.block_type
end

function PlayerUnitInventory:sheathe_wielded_weapon()
	local slots = self._slots
	local dual_wielding = self:is_dual_wielding()

	for slot_name, slot in pairs(slots) do
		local gear = slot.gear

		if gear and slot_name ~= "shield" and gear:wielded() and (not dual_wielding or slot_name ~= "secondary") then
			local unwield_anim = self:weapon_unwield_anim(slot_name)
			local unwield_time = self:weapon_unwield_time(slot_name)
			local user_unit = self._user_unit
			local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

			ScriptUnit.extension(user_unit, "locomotion_system")
			gear:trigger_timpani_event("unwield", locomotion and locomotion:has_perk("backstab") or false)

			local network_manager = Managers.state.network
			local game_object_id = self._game_object_id

			if game_object_id and network_manager:game() then
				if Managers.lobby.server then
					network_manager:send_rpc_clients("rpc_sheathe_wielded_weapon", game_object_id, NetworkLookup.inventory_slots[slot_name])
				else
					network_manager:send_rpc_server("rpc_sheathe_wielded_weapon", game_object_id, NetworkLookup.inventory_slots[slot_name])
				end
			end

			return slot_name, unwield_anim, unwield_time
		end
	end
end

function PlayerUnitInventory:weapon_unwield_anim(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = Gear[gear:name()]

	if gear:dual_wielded() then
		return gear_settings.unwield_anim_dual_wield
	else
		return gear_settings.unwield_anim
	end
end

function PlayerUnitInventory:weapon_unwield_time(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()

	if gear:dual_wielded() then
		return gear_settings.unwield_time_dual_wield
	else
		return gear_settings.unwield_time
	end
end

function PlayerUnitInventory:weapon_wield_time(slot_name, can_dual_wield)
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()
	local wield_time

	if can_dual_wield and slot_name == "primary" then
		wield_time = gear_settings.wield_time_dual_wield
	else
		wield_time = gear_settings.wield_time
	end

	wield_time = locomotion:has_perk("light_01") and Perks.light_01.wield_time_multiplier * wield_time or wield_time

	return wield_time
end

function PlayerUnitInventory:weapon_wield_anim(slot_name, can_dual_wield)
	local gear = self:gear(slot_name)
	local gear_settings = Gear[gear:name()]

	if can_dual_wield and slot_name == "primary" then
		return gear_settings.wield_anim_dual_wield
	else
		return gear_settings.wield_anim
	end
end

function PlayerUnitInventory:weapon_pose_movement_multiplier(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()

	return gear_settings.pose_movement_multiplier or 1, gear_settings.pose_backward_movement_multiplier or 1
end

function PlayerUnitInventory:ranged_weapon_draw_time(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()
	local attack_settings = gear_settings.attacks.ranged

	return attack_settings.bow_draw_time or 0
end

function PlayerUnitInventory:ranged_weapon_reload_time(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()

	return gear_settings.attacks.ranged.reload_time * PlayerUnitMovementSettings.encumbrance.functions.reload_time(self:encumbrance())
end

function PlayerUnitInventory:stance_special_attack_requirements_met(slot_name)
	local required_wielded_slot = "shield"
	local gear = self:gear(slot_name)
	local gear_settings = gear:settings()
	local gear_type = gear_settings.gear_type

	return required_wielded_slot and self:is_wielded(required_wielded_slot) and (gear_type == "spear" or gear_type == "one_handed_sword")
end

function PlayerUnitInventory:pick_best_equip_slot(gear_name)
	local gear = Gear[gear_name]
	local gear_type_name = gear.gear_type

	if gear_type_name == "shield" or gear_type_name == "dagger" then
		return gear_type_name
	end

	local gear_type = GearTypes[gear_type_name]
	local wielded_slot = self:wielded_weapon_slot()
	local primary_gear = self:gear("primary")
	local secondary_gear = self:gear("secondary")
	local primary_wielded = wielded_slot == "primary"
	local secondary_wielded = wielded_slot == "secondary"
	local primary_empty = not primary_gear or primary_gear:out_of_ammo()
	local secondary_empty = not secondary_gear or secondary_gear:out_of_ammo()
	local primary_gear_type = not primary_empty and self:gear_settings("primary").gear_type or nil
	local secondary_gear_type = not secondary_empty and self:gear_settings("secondary").gear_type or nil
	local slot_name

	if secondary_gear_type == gear_type_name then
		slot_name = "secondary"
	elseif primary_gear_type == gear_type_name then
		slot_name = "primary"
	elseif (secondary_wielded and not primary_empty or secondary_empty) and self:_slot_compatible(gear_type_name, "secondary") then
		slot_name = "secondary"
	elseif self:_slot_compatible(gear_type_name, "primary") then
		slot_name = "primary"
	end

	return slot_name
end

function PlayerUnitInventory:resolve_shield_conflict(slot_name, new_gear_settings)
	local gear_type = GearTypes[new_gear_settings.gear_type]
	local secondary_viable = self._secondary_counts_as_primary
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
	local primary_gear = self:gear("primary")
	local secondary_gear = self:gear("secondary")
	local shield_gear = self:gear("shield")
	local primary_gear_settings = primary_gear and primary_gear:settings()
	local primary_gear_type = primary_gear_settings and primary_gear_settings.gear_type

	if slot_name == "shield" then
		local grants_shield = false

		grants_shield = grants_shield or not primary_gear or GearTypes[primary_gear_type].grants_shield or primary_gear_type and primary_gear_type == "spear" and locomotion:has_perk("shield_maiden01")

		if not grants_shield and secondary_viable then
			grants_shield = grants_shield or not secondary_gear or GearTypes[secondary_gear:settings().gear_type].grants_shield
		end

		if not grants_shield then
			if secondary_viable and secondary_gear:out_of_ammo() then
				return "secondary"
			elseif primary_gear:out_of_ammo() then
				return "primary"
			elseif secondary_viable then
				return "secondary"
			else
				return "primary"
			end
		end
	elseif shield_gear and slot_name == "primary" and not gear_type.grants_shield and (new_gear_settings.gear_type ~= "spear" or not locomotion:has_perk("shield_maiden01")) then
		if not secondary_viable then
			return "shield"
		elseif not secondary_gear or GearTypes[secondary_gear:settings().gear_type].grants_shield then
			return
		elseif secondary_gear:out_of_ammo() then
			return "secondary"
		else
			return "shield"
		end
	elseif shield_gear and slot_name == "secondary" and (not gear_type.grants_shield or not secondary_viable) then
		if not primary_gear or GearTypes[primary_gear_type].grants_shield or primary_gear_type == "spear" and locomotion:has_perk("shield_maiden01") then
			return
		elseif primary_gear:out_of_ammo() then
			return "primary"
		else
			return "shield"
		end
	end
end

function PlayerUnitInventory:_slot_compatible(gear_type_name, slot_name)
	return true
end

function PlayerUnitInventory:unwield_slots_on_wield(wield_slot_name)
	local unwield = {}
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
	local is_shield_maiden = locomotion:has_perk("shield_maiden01")

	if wield_slot_name == "shield" then
		local wielded_weapon_slot = self:wielded_weapon_slot()

		if wielded_weapon_slot then
			local gear_type_name = self:gear_settings(wielded_weapon_slot).gear_type
			local allows_shield = gear_type_name == "spear" and is_shield_maiden or GearTypes[gear_type_name].allows_shield

			if not allows_shield then
				unwield[#unwield + 1] = wielded_weapon_slot
			end
		end
	else
		local gear_type_name = self:gear_settings(wield_slot_name).gear_type
		local allows_shield = gear_type_name == "spear" and is_shield_maiden or GearTypes[gear_type_name].allows_shield

		for name, slot in pairs(self._slots) do
			if (name ~= "shield" or not allows_shield) and slot.gear and slot.gear:wielded() then
				unwield[#unwield + 1] = name
			end
		end
	end

	return unwield
end

function PlayerUnitInventory:set_gear_sheathed(slot_name, sheathed, ignore_sound)
	local gear = self:gear(slot_name)

	gear:set_sheathed(sheathed, slot_name)

	local dual_wielding = self:is_dual_wielding()
	local off_hand_gear = dual_wielding and slot_name == "primary" and self:gear("secondary")

	if off_hand_gear then
		off_hand_gear:set_sheathed(sheathed, "secondary")
	end

	local game_object_id = self._game_object_id
	local network_manager = Managers.state.network

	if game_object_id and network_manager:game() then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_set_gear_sheathed", game_object_id, NetworkLookup.inventory_slots[slot_name], sheathed, ignore_sound, dual_wielding)
		else
			network_manager:send_rpc_server("rpc_set_gear_sheathed", game_object_id, NetworkLookup.inventory_slots[slot_name], sheathed, ignore_sound, dual_wielding)
		end
	end

	local user_unit = self._user_unit
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

	if not ignore_sound and not sheathed then
		gear:trigger_timpani_event("unwield", locomotion and locomotion:has_perk("backstab") or false)
	end

	if self._anim_wielded_weapons_hidden then
		if sheathed then
			gear:unhide_gear("animation")

			if off_hand_gear then
				off_hand_gear:unhide_gear("animation")
			end
		else
			gear:hide_gear("animation")

			if off_hand_gear then
				off_hand_gear:hide_gear("animation")
			end
		end
	end

	if not sheathed then
		local main_body_state, hand_anim = self:player_unit_gear_anims(gear, slot_name, dual_wielding)

		return main_body_state, hand_anim
	else
		return "to_unarmed"
	end
end

function PlayerUnitInventory:set_gear_wielded(slot_name, wielded, ignore_sound, can_dual_wield)
	local dual_wielding = false
	local other_slot = slot_name == "primary" and "secondary" or slot_name == "secondary" and "primary"

	if can_dual_wield and other_slot then
		dual_wielding = true
	end
	
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if game_mode_key == "headhunter" then
		dual_wielding = false
	end

	local gear = self:gear(slot_name)

	gear:set_wielded(wielded, slot_name, dual_wielding)

	if wielded and slot_name == self._fallback_slot then
		self._fallback_slot = nil
	elseif not wielded and slot_name ~= "shield" then
		self._fallback_slot = slot_name
	end

	local game_object_id = self._game_object_id
	local network_manager = Managers.state.network

	if game_object_id and network_manager:game() then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_set_gear_wielded", game_object_id, NetworkLookup.inventory_slots[slot_name], wielded, ignore_sound, dual_wielding)
		else
			network_manager:send_rpc_server("rpc_set_gear_wielded", game_object_id, NetworkLookup.inventory_slots[slot_name], wielded, ignore_sound, dual_wielding)
		end
	end

	local user_unit = self._user_unit
	local locomotion = ScriptUnit.has_extension(user_unit, "locomotion_system") and ScriptUnit.extension(user_unit, "locomotion_system")

	if not ignore_sound and wielded and Gear[gear:name()].timpani_events and Gear[gear:name()].timpani_events.wield then
		gear:trigger_timpani_event("wield", locomotion and locomotion:has_perk("backstab") or false)
	end

	if self._anim_wielded_weapons_hidden then
		if wielded then
			gear:hide_gear("animation")
		else
			gear:unhide_gear("animation")
		end
	end

	if slot_name == "shield" then
		self:_set_hand_collision(not wielded)
	end

	local main_body_state, hand_anim, hand_anim_2 = self:player_unit_gear_anims(gear, slot_name, dual_wielding)

	if dual_wielding and self:gear(other_slot):wielded() ~= wielded then
		self:set_gear_wielded(other_slot, wielded, true, true)

		self._dual_wielding = wielded
	end

	return main_body_state, hand_anim, hand_anim_2
end

function PlayerUnitInventory:enter_ghost_mode()
	local slots = self._slots

	for slot_name, slot in pairs(slots) do
		local gear = slot.gear

		if gear then
			gear:enter_ghost_mode()
		end
	end
end

function PlayerUnitInventory:exit_ghost_mode()
	local slots = self._slots

	for slot_name, slot in pairs(slots) do
		local gear = slot.gear

		if gear then
			gear:exit_ghost_mode()
		end
	end
end

function PlayerUnitInventory:wield_reload_anim(slot_name)
	local gear = self:gear(slot_name)
	local gear_settings = Gear[gear:name()]

	return GearTypes[gear_settings.gear_type].wield_reload_anim
end

function PlayerUnitInventory:weapon_grip_switched()
	return self._weapon_grip_switched
end

function PlayerUnitInventory:set_grip_switched(switched)
	self._weapon_grip_switched = switched
end

function PlayerUnitInventory:can_switch_weapon_grip()
	return false
end

function PlayerUnitInventory:player_dead()
	self:drop_wielded_gear()

	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			local extensions = gear:extensions()

			for key, ext in pairs(extensions) do
				ext:player_dead()
			end
		end
	end
end
