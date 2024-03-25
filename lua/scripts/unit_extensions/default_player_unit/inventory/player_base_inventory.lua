-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/player_base_inventory.lua

require("scripts/settings/inventory_slots")
require("scripts/settings/armours")

PlayerBaseInventory = class(PlayerBaseInventory)

function PlayerBaseInventory:init(world, user_unit, player)
	self._world = world
	self._user_unit = user_unit
	self._player = player
	self._slots = {}
	self._helmet_attachment_units = {}
	self._head_attachments = {}
	self._eye_constraint_target = nil
	self._visor_open = true
	self._weapon_grip_switched = false
	self._visor_name = nil
	self._helmet_name = nil

	self:_setup_slots()

	self._armour_definition = nil
	self._built_in_overlay = nil
	self._decap_allowed = true
	self._anim_wielded_weapons_hidden = false
end

local function set_gear_collisons(slots, func_name, reason)
	for slot_name, gear_data in pairs(slots) do
		local gear = gear_data.gear

		if gear then
			gear[func_name](gear, reason)
		end
	end
end

function PlayerBaseInventory:enable_hit_detection(reason)
	set_gear_collisons(self._slots, "enable_collisions", reason)
end

function PlayerBaseInventory:disable_hit_detection(reason)
	set_gear_collisons(self._slots, "disable_collisions", reason)
end

function PlayerBaseInventory:_set_material_variation(unit, definition)
	local var = definition.material_variation

	if var then
		Unit.set_material_variation(unit, var)
	end
end

function PlayerBaseInventory:anim_cb_hide_wielded_weapons(hide)
	self._anim_wielded_weapons_hidden = hide

	local func_name = hide and "hide_gear" or "unhide_gear"

	for name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() then
			gear[func_name](gear, "animation")
		end
	end
end

function PlayerBaseInventory:voice()
	return self._voice
end

function PlayerBaseInventory:armour_unit()
	return self._armour_unit
end

function PlayerBaseInventory:add_armour(armour_name, pattern_index)
	self._armour_name = armour_name
	self._pattern_index = pattern_index

	local armour_unit_name = Armours[armour_name].armour_unit

	self:_spawn_armour(armour_unit_name)
	self:_load_armour_data(armour_name, pattern_index)
end

function PlayerBaseInventory:_spawn_armour(armour_unit_name)
	self._armour_unit = World.spawn_unit(self._world, armour_unit_name)

	self:_attachment_node_linking(self._user_unit, self._armour_unit, AttachmentNodeLinking.full_body.standard)
end

function PlayerBaseInventory:_load_armour_data(armour, pattern_index)
	local armour_definition = Armours[armour]
	local user_unit = self._user_unit
	local armour_unit = self._armour_unit

	Unit.set_data(user_unit, "armour_type", armour_definition.armour_type)
	Unit.set_data(user_unit, "armour_sound_type", armour_definition.armour_sound_type)
	Unit.set_data(user_unit, "armour_sound_material", armour_definition.armour_sound_material)
	Unit.set_data(user_unit, "penetration_value", armour_definition.penetration_value)
	Unit.set_data(user_unit, "absorption_value", armour_definition.absorption_value)

	local pattern = armour_definition.attachment_definitions.patterns[pattern_index]
	local meshes = armour_definition.meshes
	local secondary_tint = pattern.secondary_tint
	local meshes_2 = armour_definition.meshes_2

	ProfileHelper:set_gear_patterns(armour_unit, meshes, pattern)

	if meshes_2 and secondary_tint then
		ProfileHelper:set_gear_patterns(armour_unit, meshes_2, pattern.secondary_tint)
	end

	self:_set_material_variation(self._user_unit, pattern)

	self._armour_definition = armour_definition

	if armour_definition.armour_anim_event then
		Unit.animation_event(self._user_unit, armour_definition.armour_anim_event)
	end
end

function PlayerBaseInventory:reload_armour_data()
	self:_load_armour_data(self._armour_name, self._pattern_index)
end

function PlayerBaseInventory:armour_values(hit_zone)
	if hit_zone == "helmet" then
		local helmet = self._helmet_definition

		if helmet then
			if script_data.armour_debug then
				print("helmet", helmet.armour_type, helmet.penetration_value, helmet.absorption_value)
			end

			return helmet.armour_type, helmet.penetration_value, helmet.absorption_value
		else
			error("PlayerBaseInventory:armour_values, no helmet definition set")
		end
	end

	local armour = self._armour_definition
	local user_unit = self._user_unit
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local perk_settings = Perks.shield_maiden02
	local shield_maiden_blocking = locomotion:has_perk("shield_maiden02") and locomotion.blocking

	if armour then
		local hit_zone_armour = shield_maiden_blocking and perk_settings.blocking_hit_zones[hit_zone] or armour.hit_zones[hit_zone]

		if hit_zone_armour then
			if script_data.armour_debug then
				print("hit zone armour", hit_zone, hit_zone_armour.armour_type, hit_zone_armour.penetration_value, hit_zone_armour.absorption_value)
			end

			return hit_zone_armour.armour_type, hit_zone_armour.penetration_value, hit_zone_armour.absorption_value
		else
			local absorption_value = shield_maiden_blocking and perk_settings.blocking_absorption_value or armour.absorption_value

			if script_data.armour_debug then
				print("armour", hit_zone, armour.armour_type, armour.penetration_value, absorption_value)
			end

			return armour.armour_type, armour.penetration_value, absorption_value
		end
	else
		error("PlayerBaseInventory:armour_values, no armour definition set")
	end
end

function PlayerBaseInventory:_setup_slots()
	for name, settings in pairs(InventorySlots) do
		self._slots[name] = {
			settings = settings
		}
	end
end

function PlayerBaseInventory:find_slot_by_unit(unit)
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			local gear_unit = gear:unit()

			if gear_unit == unit then
				return slot_name
			end
		end
	end
end

function PlayerBaseInventory:find_gear_by_unit(unit)
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			local gear_unit = gear:unit()

			if gear_unit == unit then
				return gear
			end
		end
	end
end

function PlayerBaseInventory:slots()
	return self._slots
end

function PlayerBaseInventory:gear(slot_name)
	return self._slots[slot_name].gear
end

function PlayerBaseInventory:_set_gear(slot_name, gear)
	self._slots[slot_name].gear = gear
end

function PlayerBaseInventory:add_gear(gear_name, obj_id, slot_name, user_locomotion, ammo)
	local gear_settings = Gear[gear_name]
	local current_gear = self:gear(slot_name)

	fassert(not current_gear, "[PlayerBaseInventory:add_gear] Tried to add gear %q in occupied slot %q. Occupied by %q", gear_name, slot_name, current_gear and current_gear:name() or nil)

	local gear_class = rawget(_G, self.GEAR_CLASS)
	local gear = gear_class:new(self._world, self._user_unit, self._player, gear_name, obj_id, slot_name, user_locomotion, ammo)

	self:_set_gear(slot_name, gear)

	if self._coat_of_arms_settings then
		gear:set_coat_of_arms(self._coat_of_arms_settings, self._coat_of_arms_team_name)
	end

	local unit = gear:unit()

	self:_set_material_variation(unit, gear_settings)

	return unit, gear
end

function PlayerBaseInventory:remove_gear(slot_name)
	local gear = self:gear(slot_name)

	gear:destroy()
	self:_set_gear(slot_name, nil)

	if slot_name == "shield" then
		self:_set_hand_collision(true)
	end
end

function PlayerBaseInventory:drop_gear(slot_name)
	local gear = self:gear(slot_name)

	gear:drop()
	self:remove_gear(slot_name)
end

function PlayerBaseInventory:gear_dead(slot_name)
	local gear = self:gear(slot_name)

	gear:die()
	self:remove_gear(slot_name)
end

function PlayerBaseInventory:player_unit_gear_anims(gear, slot_name, dual_wielding)
	local gear_settings = gear:settings()
	local hand = gear_settings.hand
	local main_body_state
	local gear_type_settings = GearTypes[gear_settings.gear_type]

	if dual_wielding then
		gear_type_settings = gear_type_settings.dual_wielding[slot_name]
	end

	if gear:wielded() then
		main_body_state = gear_type_settings.wield_main_body_state
	else
		main_body_state = gear_type_settings.unwield_main_body_state
	end

	local hand_anim = hand .. "/empty"

	if gear:wielded() and gear_settings.hand_anim then
		hand_anim = gear_settings.hand_anim
	end

	return main_body_state, hand_anim
end

function PlayerBaseInventory:gear_unit(slot_name)
	local gear = self:gear(slot_name)
	local unit = gear and gear:unit()

	return unit
end

function PlayerBaseInventory:gear_settings(slot_name)
	local gear = self:gear(slot_name)

	return gear:settings()
end

function PlayerBaseInventory:wielded_slots()
	local wielded = {}

	for name, slot in pairs(self._slots) do
		if slot.gear and slot.gear:wielded() then
			wielded[name] = slot
		end
	end

	return wielded
end

function PlayerBaseInventory:is_ranged_weapon(slot_name)
	local gear = self:gear(slot_name)

	return gear and gear:is_ranged_weapon()
end

function PlayerBaseInventory:wielded_ranged_weapon_slot()
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() and gear:is_ranged_weapon() then
			return slot_name
		end
	end
end

function PlayerBaseInventory:head()
	return self._head_unit
end

function PlayerBaseInventory:head_attachments()
	return self._head_attachments
end

function PlayerBaseInventory:add_head(head_name, voice, beard_name, beard_color)
	Unit.set_data(self._user_unit, "head", head_name)

	local head_settings = Heads[head_name]

	fassert(head_settings, "Head %q not found", head_name)

	local unit = World.spawn_unit(self._world, head_settings.unit)

	self:_set_material_variation(unit, head_settings)
	self:_attachment_node_linking(self._user_unit, unit, head_settings.attachment_node_linking)

	local beard = Beards[beard_name]

	if beard then
		local beard_color = beard.material_variations[beard_color] or {}

		for _, attachment in ipairs(beard.attachments) do
			local attachment_unit = World.spawn_unit(self._world, attachment.unit)

			self._head_attachments[#self._head_attachments + 1] = attachment_unit

			self:_attachment_node_linking(self._user_unit, attachment_unit, attachment.node_linking)
			self:_set_material_variation(attachment_unit, beard_color)
		end
	else
		for _, attachment in ipairs(head_settings.attachments) do
			local attachment_unit = World.spawn_unit(self._world, attachment.unit)

			self._head_attachments[#self._head_attachments + 1] = attachment_unit

			self:_attachment_node_linking(self._user_unit, attachment_unit, attachment.node_linking)
			self:_set_material_variation(attachment_unit, attachment)
		end
	end

	Unit.set_animation_merge_options(unit)

	self._head_unit = unit

	Unit.set_visibility(unit, "head_decap", false)

	if Unit.has_animation_state_machine(unit) then
		self._eye_constraint_target = Unit.animation_find_constraint_target(unit, "eye_target")
	end

	self._voice = head_settings[self._voice_type] or voice

	Unit.set_flow_variable(self._user_unit, "character_vo", self._voice)
end

function PlayerBaseInventory:cloak()
	return self._cloak_unit
end

function PlayerBaseInventory:add_cloak(cloak_name, pattern, team_name)
	if string.find(cloak_name, "no_cloak") then
		return
	end

	local cloak_pattern = CloakPatterns[pattern]
	local cloak = Cloaks[cloak_name]
	local unit_name = cloak.unit
	local attachment_node_linking = cloak.attachment_node_linking
	local unit = World.spawn_unit(self._world, unit_name)

	self:_attachment_node_linking(self._user_unit, unit, attachment_node_linking)

	self._cloak_unit = unit
	self._cloak_unit_uses_apex = World.get_data(self._world, "has_apex")

	if cloak_pattern then
		local material_variation = unit_name .. "_" .. team_name

		ProfileHelper:set_gear_patterns(self._cloak_unit, cloak.mesh_names, cloak_pattern, material_variation)
	end
end

function PlayerBaseInventory:add_helmet(helmet_name, team_name, helmet_variation)
	local user_unit = self._user_unit

	Unit.set_data(user_unit, "helmet", helmet_name)

	local helmet_definition = Helmets[helmet_name]

	Unit.set_data(user_unit, "helmet_armour_type", helmet_definition.armour_type)
	Unit.set_data(user_unit, "helmet_penetration_value", helmet_definition.penetration_value)
	Unit.set_data(user_unit, "helmet_absorption_value", helmet_definition.absorption_value)

	local settings = Helmets[helmet_name]
	local unit_name = helmet_definition[team_name] or helmet_definition.unit
	local unit = World.spawn_unit(self._world, unit_name)
	local variation = {}

	for name, settings_variation in pairs(helmet_definition.material_variations) do
		if settings_variation.material_variation == helmet_variation then
			variation = settings_variation

			break
		end
	end

	self:_set_material_variation(unit, variation)

	self._decap_allowed = self._decap_allowed and not settings.no_decapitation

	self:_attachment_node_linking(self._user_unit, unit, helmet_definition.attachment_node_linking)

	if helmet_definition.hide_head_visibility_group then
		Unit.set_visibility(self._head_unit, helmet_definition.hide_head_visibility_group, false)
	end

	self._helmet_unit = unit
	self._helmet_name = helmet_name

	Unit.set_data(unit, "armour_owner", self._user_unit)

	local head_actor = Unit.actor(user_unit, "c_head")
	local neck_actor = Unit.actor(user_unit, "helmet")

	Actor.set_scene_query_enabled(head_actor, false)
	Actor.set_scene_query_enabled(neck_actor, false)

	self._helmet_definition = helmet_definition

	if helmet_definition.built_in_visor then
		self._visor_name = helmet_definition.built_in_visor
	end

	if helmet_definition.built_in_overlay then
		self._built_in_overlay = helmet_definition.built_in_overlay
	end
end

function PlayerBaseInventory:built_in_overlay()
	return self._built_in_overlay
end

function PlayerBaseInventory:add_helmet_attachment(helmet_name, attachment_type, attachment_name, team_name)
	local helmet_unit = self._helmet_unit
	local helmet = Helmets[helmet_name]
	local helmet_attachment = helmet.attachments[attachment_name]
	local unit_name = helmet_attachment.unit
	local unit = World.spawn_unit(self._world, unit_name)

	self:_attachment_node_linking(helmet_unit, unit, helmet_attachment.attachment_node_linking)

	self._helmet_attachment_units[attachment_type] = unit

	if attachment_type == "visor" then
		self._visor_name = helmet_attachment.hud_overlay_texture
	end

	Unit.set_data(unit, "armour_owner", self._user_unit)

	self._decap_allowed = self._decap_allowed and not helmet_attachment.no_decapitation
end

function PlayerBaseInventory:allow_decapitation()
	return self._decap_allowed
end

function PlayerBaseInventory:add_helmet_crest(crest_name, team_name)
	local crest = HelmetCrests[crest_name]
	local unit_name = crest.unit
	local unit = World.spawn_unit(self._world, unit_name)

	self:_attachment_node_linking(self._helmet_unit, unit, crest.attachment_node_linking)

	self._helmet_attachment_units.crest = unit

	Unit.set_data(self._user_unit, "crest_name", crest_name)
end

local HACK_COA = {
	red = {
		charge_heraldry = "viking01",
		mid_heraldry = "base05",
		top_heraldry = "base07",
		base_heraldry_index = 255,
		charge_heraldry_color_index = 3,
		top_heraldry_color_index = 9,
		mid_heraldry_color_index = 13,
		base_color_index = 1
	},
	white = {
		charge_heraldry = "saxon01",
		mid_heraldry = "base03",
		top_heraldry = "base04",
		base_heraldry_index = 255,
		charge_heraldry_color_index = 7,
		top_heraldry_color_index = 11,
		mid_heraldry_color_index = 7,
		base_color_index = 0
	}
}

function PlayerBaseInventory:add_coat_of_arms(settings, team_name)
	local hack_settings = HACK_COA[team_name]

	if GameSettingsDevelopment.use_armour_heraldry_projection then
		CoatOfArmsHelper:set_material_properties(hack_settings, self._armour_unit, "g_heraldry_projection", "heraldry_projection", team_name)

		local extra_coat_of_arms = self._armour_definition.extra_coat_of_arms

		if extra_coat_of_arms then
			CoatOfArmsHelper:set_material_properties(hack_settings, self._armour_unit, extra_coat_of_arms.mesh, extra_coat_of_arms.material, team_name)
		end
	end

	for name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			gear:set_coat_of_arms(settings, team_name)
		end
	end

	self._coat_of_arms_settings = settings
	self._coat_of_arms_team_name = team_name
end

function PlayerBaseInventory:update_coat_of_arms(coat_of_arms, team_name)
	local settings = coat_of_arms or self._coat_of_arms_settings
	local team_name = team_name or self._coat_of_arms_team_name

	self._squad_coat_of_arms = coat_of_arms

	if GameSettingsDevelopment.use_armour_heraldry_projection then
		CoatOfArmsHelper:set_material_properties(settings, self._armour_unit, "g_heraldry_projection", "heraldry_projection", team_name)

		local extra_coat_of_arms = self._armour_definition.extra_coat_of_arms

		if extra_coat_of_arms then
			CoatOfArmsHelper:set_material_properties(settings, self._armour_unit, extra_coat_of_arms.mesh, extra_coat_of_arms.material, team_name)
		end
	end

	for name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			gear:set_coat_of_arms(settings, team_name)
		end
	end
end

function PlayerBaseInventory:_set_hand_collision(enabled)
	local user_unit = self._user_unit
	local actor = Unit.actor(user_unit, "c_lefthand")

	if actor then
		Actor.set_scene_query_enabled(actor, enabled)
	end
end

function PlayerBaseInventory:_attachment_node_linking(source_unit, target_unit, linking_setup)
	for i, attachment_nodes in ipairs(linking_setup) do
		local source_node = attachment_nodes.source
		local target_node = attachment_nodes.target
		local source_node_index = type(source_node) == "string" and Unit.node(source_unit, source_node) or source_node
		local target_node_index = type(target_node) == "string" and Unit.node(target_unit, target_node) or target_node

		World.link_unit(self._world, target_unit, target_node_index, source_unit, source_node_index)
	end
end

function PlayerBaseInventory:set_eye_target(aim_target)
	if self._head_unit and Unit.alive(self._head_unit) and self._eye_constraint_target and aim_target then
		Unit.animation_set_constraint_target(self._head_unit, self._eye_constraint_target, aim_target)
	end
end

function PlayerBaseInventory:visor_open()
	return self._visor_open
end

function PlayerBaseInventory:visor_name()
	return self._visor_name
end

function PlayerBaseInventory:helmet_name()
	return self._helmet_name
end

function PlayerBaseInventory:helmet_unit()
	return self._helmet_unit
end

function PlayerBaseInventory:helmet_attachment_unit(name)
	return self._helmet_attachment_units[name]
end

function PlayerBaseInventory:hot_join_synch(sender, player, player_object_id)
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear then
			if gear:wielded() then
				RPC.rpc_set_gear_wielded(sender, player_object_id, NetworkLookup.inventory_slots[slot_name], true, true, gear:dual_wielded())
			end

			if gear:sheathed() then
				RPC.rpc_set_gear_sheathed(sender, player_object_id, NetworkLookup.inventory_slots[slot_name], true, false, gear:dual_wielded())
			end

			local extensions = gear:extensions()

			for _, extension in pairs(extensions) do
				extension:hot_join_synch(sender, player, player_object_id, slot_name)
			end
		end
	end
end

function PlayerBaseInventory:destroy()
	for slot_name, slot in pairs(self._slots) do
		if slot.gear then
			self:remove_gear(slot_name, true)
		end
	end

	self._slots = {}

	if self._helmet_unit and Unit.alive(self._helmet_unit) then
		World.destroy_unit(self._world, self._helmet_unit)

		self._helmet_unit = nil
		self._helmet_name = nil
	end

	for _, attachment_unit in ipairs(self._head_attachments) do
		if Unit.alive(attachment_unit) then
			World.destroy_unit(self._world, attachment_unit)
		end
	end

	for _, attachment_unit in pairs(self._helmet_attachment_units) do
		if Unit.alive(attachment_unit) then
			World.destroy_unit(self._world, attachment_unit)
		end
	end

	self._helmet_attachment_units = {}
	self._visor_name = nil

	if self._head_unit and Unit.alive(self._head_unit) then
		World.destroy_unit(self._world, self._head_unit)

		self._head_unit = nil
	end

	if self._armour_unit and Unit.alive(self._armour_unit) then
		World.destroy_unit(self._world, self._armour_unit)

		self._armour_unit = nil
	end

	if Unit.alive(self._cloak_unit) then
		World.destroy_unit(self._world, self._cloak_unit)

		self._cloak_unit = nil
	end
end

function PlayerBaseInventory:set_kinematic_wielded_gear(kinematic)
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() then
			gear:set_kinematic(kinematic, slot_name)
		end
	end
end

function PlayerBaseInventory:set_faux_unwielded(bool)
	for slot_name, slot in pairs(self._slots) do
		local gear = slot.gear

		if gear and gear:wielded() then
			gear:set_faux_unwielded(bool, slot_name)
		end
	end
end
