-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_looting.lua

require("scripts/unit_extensions/human/base/states/human_interacting")

PlayerLooting = class(PlayerLooting, HumanInteracting)

function PlayerLooting:init(unit, internal, world)
	PlayerLooting.super.init(self, unit, internal, world, "loot")
end

function PlayerLooting:enter(old_state, loot, t, interaction)
	self._loot_unit = loot

	PlayerLooting.super.enter(self, old_state, t)

	local internal = self._internal

	self._ammo_looted = nil
	self._gear_name = Unit.get_data(loot, "gear_name")

	if internal.id and internal.game then
		local loot_id = Managers.state.network:unit_game_object_id(loot)

		self._loot_unit_id = loot_id

		InteractionHelper:request("loot", internal, internal.id, loot_id)
	end
end

function PlayerLooting:interaction_confirmed(ammo)
	PlayerLooting.super.interaction_confirmed(self, ammo)

	self._ammo_looted = ammo
end

function PlayerLooting:_exit_on_fail()
	PlayerLooting.super._exit_on_fail(self)

	local internal = self._internal

	if internal.id and internal.game then
		InteractionHelper:abort("loot", internal, internal.id, self._loot_unit_id)
	end
end

function PlayerLooting:_exit_on_complete()
	PlayerLooting.super._exit_on_complete(self)

	local internal = self._internal
	local inventory = internal:inventory()
	local gear_name = self._gear_name
	local slot_name = inventory:pick_best_equip_slot(gear_name)
	local gear_settings = Gear[gear_name]
	local replace_slot = inventory:resolve_shield_conflict(slot_name, gear_settings)

	if replace_slot then
		self:_set_slot_wielded_instant(replace_slot, false)
		inventory:replace_gear(replace_slot)
	end

	local _, _, _ = inventory:add_gear(gear_name, nil, slot_name, self._internal, self._ammo_looted)

	if inventory:can_wield(slot_name, "onground") then
		self:_unwield_slots_on_wield(slot_name)
		self:_wield_weapon(slot_name, true)
	end

	local wielded_weapon = inventory:wielded_weapon_slot()

	if not wielded_weapon then
		local fallback_slot = inventory:fallback_slot()

		self:_unwield_slots_on_wield(fallback_slot)
		self:_wield_weapon(fallback_slot, true)
	end

	InteractionHelper:complete("loot", internal, internal.id, self._loot_unit_id)
end

function PlayerLooting:destroy()
	return
end
