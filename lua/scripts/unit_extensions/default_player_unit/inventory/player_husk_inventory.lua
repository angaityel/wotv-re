-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/player_husk_inventory.lua

require("scripts/unit_extensions/default_player_unit/inventory/player_base_inventory")
require("scripts/unit_extensions/default_player_unit/inventory/husk_gear")
require("scripts/utils/disable_reasons")

PlayerHuskInventory = class(PlayerHuskInventory, PlayerBaseInventory)
PlayerHuskInventory.GEAR_CLASS = "HuskGear"

local function set_actor_collision_enabled(actor, enabled)
	Actor.set_collision_enabled(actor, enabled)
	Actor.set_scene_query_enabled(actor, enabled)
end

local function copy_lod_object(source_unit, dest_unit, lod_object_name)
	if GameSettingsDevelopment.disable_uniform_lod then
		return
	end

	local source_lod_object = Unit.lod_object(source_unit, lod_object_name)
	local dest_lod_object = Unit.lod_object(dest_unit, lod_object_name)
	local source_bounding_volume = LODObject.bounding_volume(source_lod_object)

	LODObject.set_bounding_volume(dest_lod_object, source_bounding_volume)
	LODObject.set_orientation_node(dest_lod_object, source_unit, Unit.node(source_unit, "c_afro"))
end

function PlayerHuskInventory:init(world, user_unit, player)
	self._voice_type = "husk_voice"

	PlayerBaseInventory.init(self, world, user_unit, player)

	self._helmet_physics_disabled_reasons = DisableReasons:new()
end

function PlayerHuskInventory:enable_hit_detection(reason)
	PlayerBaseInventory.enable_hit_detection(self, reason)
	self:_enable_helmet_collisions(reason)
end

function PlayerHuskInventory:disable_hit_detection(reason)
	PlayerBaseInventory.disable_hit_detection(self, reason)
	self:_disable_helmet_collisions(reason)
end

function PlayerHuskInventory:update(dt, t)
	for name, slot in pairs(self._slots) do
		if slot.gear then
			slot.gear:update(dt, t)
		end
	end
end

function PlayerHuskInventory:enter_ghost_mode()
	self.ghost_mode = true

	local slots = self._slots

	for slot_name, slot in pairs(slots) do
		local gear = slot.gear

		if gear then
			gear:enter_ghost_mode()
		end
	end

	local armour_unit = self._armour_unit

	if Unit.alive(armour_unit) then
		Unit.set_unit_visibility(armour_unit, false)
	end

	local head_unit = self._head_unit

	if Unit.alive(head_unit) then
		Unit.set_unit_visibility(head_unit, false)
	end

	for _, head_attachment in ipairs(self._head_attachments) do
		if Unit.alive(head_attachment) then
			Unit.set_unit_visibility(head_attachment, false)
		end
	end

	local helmet_unit = self._helmet_unit

	if Unit.alive(helmet_unit) then
		Unit.set_unit_visibility(helmet_unit, false)
		self:_disable_helmet_collisions("ghost_mode")
	end

	for attachment_type, attachment_unit in pairs(self._helmet_attachment_units) do
		Unit.set_unit_visibility(attachment_unit, false)
	end

	local cloak_unit = self._cloak_unit

	if Unit.alive(cloak_unit) then
		self:_set_cloth_visibility(cloak_unit, false)
	end
end

function PlayerHuskInventory:_set_cloth_visibility(unit, visible)
	if not self._cloak_unit_uses_apex then
		Unit.set_unit_visibility(unit, visible)
	else
		for i = 0, Unit.num_cloths(unit) - 1 do
			Unit.set_cloth_visibility(unit, i, visible)
		end
	end
end

function PlayerHuskInventory:set_gear_wielded(slot_name, wielded, ignore_sound, dual_wielding)
	local gear = self._slots[slot_name].gear

	assert(gear, "[PlayerHuskInventory:wield_gear] Tried to wield slot without gear! slot_name: " .. tostring(slot_name))
	gear:set_wielded(wielded, slot_name, dual_wielding)

	if slot_name ~= "shield" then
		self.wielded_weapon_type = gear._settings.gear_type
	end

	local main_body_state, hand_anim = self:player_unit_gear_anims(gear, slot_name, dual_wielding)

	if main_body_state then
		Unit.animation_event(self._user_unit, main_body_state)
	end

	if hand_anim then
		Unit.animation_event(self._user_unit, hand_anim)
	end

	local locomotion = ScriptUnit.has_extension(self._user_unit, "locomotion_system") and ScriptUnit.extension(self._user_unit, "locomotion_system")

	if (not locomotion or not locomotion:has_perk("backstab")) and not ignore_sound and wielded and Gear[gear:name()].timpani_events and Gear[gear:name()].timpani_events.wield then
		gear:trigger_timpani_event("wield", false)
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
end

function PlayerHuskInventory:sheathe_wielded_weapon(slot_name)
	local gear = self._slots[slot_name].gear
	local locomotion = ScriptUnit.has_extension(self._user_unit, "locomotion_system") and ScriptUnit.extension(self._user_unit, "locomotion_system")

	assert(gear, "[PlayerHuskInventory:wield_gear] Tried to wield slot without gear! slot_name: " .. tostring(slot_name))

	if not locomotion or not locomotion:has_perk("backstab") then
		gear:trigger_timpani_event("unwield", false)
	end
end

function PlayerHuskInventory:set_gear_sheathed(slot_name, sheathed, ignore_sound, dual_wielding)
	local gear = self._slots[slot_name].gear

	assert(gear, "[PlayerHuskInventory:wield_gear] Tried to wield slot without gear! slot_name: " .. tostring(slot_name))
	gear:set_sheathed(sheathed, slot_name)

	local off_hand_gear

	if dual_wielding and slot_name == "primary" then
		local off_hand_slot_name = "secondary"
		local off_hand_slot = self._slots[off_hand_slot_name]

		if off_hand_slot then
			off_hand_gear = off_hand_slot.gear

			off_hand_gear:set_sheathed(sheathed, off_hand_slot_name)
		end
	end

	local main_body_state, hand_anim = self:player_unit_gear_anims(gear, slot_name, dual_wielding)

	if main_body_state then
		Unit.animation_event(self._user_unit, main_body_state)
	end

	if hand_anim then
		Unit.animation_event(self._user_unit, hand_anim)
	end

	local locomotion = ScriptUnit.has_extension(self._user_unit, "locomotion_system") and ScriptUnit.extension(self._user_unit, "locomotion_system")

	if (not locomotion or not locomotion:has_perk("backstab")) and not ignore_sound and not sheathed then
		gear:trigger_timpani_event("wield", false)
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
end

function PlayerHuskInventory:exit_ghost_mode()
	self.ghost_mode = false

	local slots = self._slots

	for slot_name, slot in pairs(slots) do
		local gear = slot.gear

		if gear then
			gear:exit_ghost_mode()
		end
	end

	local armour_unit = self._armour_unit

	if Unit.alive(armour_unit) then
		Unit.set_unit_visibility(armour_unit, true)
		Unit.set_visibility(armour_unit, "decapitated", false)
	end

	local head_unit = self._head_unit

	if Unit.alive(head_unit) then
		Unit.set_unit_visibility(head_unit, true)
		Unit.set_visibility(head_unit, "head_decap", false)
	end

	for _, head_attachment in ipairs(self._head_attachments) do
		if Unit.alive(head_attachment) then
			Unit.set_unit_visibility(head_attachment, true)
		end
	end

	local helmet_unit = self._helmet_unit

	if Unit.alive(helmet_unit) then
		Unit.set_unit_visibility(helmet_unit, true)
		self:_enable_helmet_collisions("ghost_mode")

		local helmet_settings = Helmets[self:helmet_name()]

		if helmet_settings.hide_head_visibility_group then
			assert(head_unit, "[PlayerHuskInventory:exit_ghost_mode] set_visibility self._head_unit = nil")
			Unit.set_visibility(head_unit, helmet_settings.hide_head_visibility_group, false)
		end
	end

	for attachment_type, attachment_unit in pairs(self._helmet_attachment_units) do
		Unit.set_unit_visibility(attachment_unit, true)
	end

	local cloak_unit = self._cloak_unit

	if Unit.alive(cloak_unit) then
		self:_set_cloth_visibility(cloak_unit, true)
	end
end

function PlayerHuskInventory:add_gear(gear_name, obj_id, slot_name, user_locomotion)
	local gear_unit, gear = PlayerHuskInventory.super.add_gear(self, gear_name, obj_id, slot_name, user_locomotion)

	if self.ghost_mode then
		gear:enter_ghost_mode()
	end

	copy_lod_object(self._armour_unit, gear_unit, "LOD")

	return gear_unit
end

local function calculate_misc_items(attachment_items, value)
	local items = {}

	for i = 1, NetworkConstants.max_attachments do
		local result = value % 2

		value = (value - result) / 2

		if result ~= 0 then
			items[#items + 1] = attachment_items[i].name
		end
	end

	return items
end

function PlayerHuskInventory:_calculate_items(gear_name, index, attachment_ids)
	local category, items
	local gear_settings = Gear[gear_name]
	local potential_attachments = gear_settings.attachments
	local value = attachment_ids[index]

	if value ~= 0 then
		local attachment = potential_attachments[index]

		category = attachment.category

		local attachment_items = WeaponHelper:attachment_items_by_category(gear_name, category) or {}

		if attachment.menu_page_type == "checkbox" then
			items = calculate_misc_items(attachment_items, value)
		else
			items = {
				attachment_items[value].name
			}
		end
	end

	return category, items
end

function PlayerHuskInventory:add_armour(armour_name, pattern_index)
	PlayerHuskInventory.super.add_armour(self, armour_name, pattern_index)

	if self.ghost_mode then
		Unit.set_unit_visibility(self._armour_unit, false)
	end
end

function PlayerHuskInventory:add_head(head_name, voice, beard, beard_color)
	PlayerHuskInventory.super.add_head(self, head_name, voice, beard, beard_color)
	copy_lod_object(self._armour_unit, self._head_unit, "LOD")

	if self.ghost_mode then
		local head_unit = self._head_unit

		Unit.set_unit_visibility(head_unit, false)

		for i, attachment_unit in ipairs(self._head_attachments) do
			Unit.set_unit_visibility(attachment_unit, false)
		end
	end
end

function PlayerHuskInventory:add_cloak(cloak_name, pattern, team_name)
	PlayerHuskInventory.super.add_cloak(self, cloak_name, pattern, team_name)

	local cloak_unit = self._cloak_unit

	if cloak_unit and self.ghost_mode then
		self:_set_cloth_visibility(cloak_unit, false)
	end
end

function PlayerHuskInventory:add_helmet(helmet_name, team_name, helmet_variation)
	PlayerHuskInventory.super.add_helmet(self, helmet_name, team_name, helmet_variation)
	copy_lod_object(self._armour_unit, self._helmet_unit, "LOD")

	if self.ghost_mode then
		local helmet_unit = self._helmet_unit

		Unit.set_unit_visibility(helmet_unit, false)
		self:_disable_helmet_collisions("ghost_mode")
	end
end

function PlayerHuskInventory:_disable_helmet_collisions(reason)
	local became_disabled = self._helmet_physics_disabled_reasons:disable(reason)

	if became_disabled then
		self:_set_helmet_collision_enabled(false)
	end
end

function PlayerHuskInventory:_enable_helmet_collisions(reason)
	local became_enabled = self._helmet_physics_disabled_reasons:enable(reason)

	if became_enabled then
		self:_set_helmet_collision_enabled(true)
	end
end

function PlayerHuskInventory:_set_helmet_collision_enabled(enabled)
	local helmet_unit = self._helmet_unit

	if not helmet_unit then
		return
	end

	local neck_actor = Unit.actor(helmet_unit, "c_neck")

	if neck_actor then
		set_actor_collision_enabled(neck_actor, enabled)
	end

	local head_actor = Unit.actor(helmet_unit, "c_head")

	if head_actor then
		set_actor_collision_enabled(head_actor, enabled)
	end

	local helmet_actor = Unit.actor(helmet_unit, "c_helmet")

	if helmet_actor then
		set_actor_collision_enabled(helmet_actor, enabled)
	end

	local index = 1

	helmet_actor = Unit.actor(helmet_unit, "c_helmet" .. index)

	while helmet_actor do
		set_actor_collision_enabled(helmet_actor, enabled)

		index = index + 1
		helmet_actor = Unit.actor(helmet_unit, "c_helmet" .. index)
	end
end

function PlayerHuskInventory:add_helmet_attachment(helmet_name, attachment_type, attachment_name, team_name)
	PlayerHuskInventory.super.add_helmet_attachment(self, helmet_name, attachment_type, attachment_name, team_name)

	if self.ghost_mode and attachment_type ~= "pattern" then
		Unit.set_unit_visibility(self._helmet_attachment_units[attachment_type], false)
	end
end

function PlayerHuskInventory:add_helmet_crest(crest_name, team_name)
	PlayerHuskInventory.super.add_helmet_crest(self, crest_name, team_name)

	if self.ghost_mode then
		Unit.set_unit_visibility(self._helmet_attachment_units.crest, false)
	end
end

function PlayerHuskInventory:helmet()
	return self._helmet_unit
end
