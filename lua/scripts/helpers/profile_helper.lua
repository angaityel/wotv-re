-- chunkname: @scripts/helpers/profile_helper.lua

ProfileHelper = ProfileHelper or {}

function ProfileHelper:find_gear_by_slot(gear_table, slot_name)
	return gear_table[slot_name]
end

function ProfileHelper:find_gear_by_name(gear_table, gear_name)
	for i, gear in ipairs(gear_table) do
		if gear.name == gear_name then
			return gear, i
		end
	end
end

function ProfileHelper:find_gear_by_type(gear_table, gear_type)
	for i, gear in ipairs(gear_table) do
		if Gear[gear.name].gear_type == gear_type then
			return gear, i
		end
	end
end

function ProfileHelper:remove_gear_by_slot(gear_table, gear_slot)
	gear_table[gear_slot] = nil
end

function ProfileHelper:remove_gear_by_type(gear_table, gear_type)
	local gear, index = self:find_gear_by_type(gear_table, gear_type)

	if index then
		table.remove(gear_table, index)
	end
end

function ProfileHelper:gear_slot(gear_name)
	return GearTypes[Gear[gear_name].gear_type].inventory_slot
end

function ProfileHelper:find_complementing_gear(slot, gear_table, archetype)
	local solo_gear = Gear[gear_table[slot].name]
	local solo_gear_type = GearTypes[solo_gear.gear_type]
	local shield_maiden = archetype == "shield_maiden"

	if slot == "shield" then
		if primary and GearTypes[Gear[primary.name].gear_type].allows_shield then
			return primary
		end

		local secondary = gear_table.secondary

		if secondary and GearTypes[Gear[secondary.name].gear_type].allows_shield then
			return secondary
		end
	elseif (shield_maiden and solo_gear.gear_type == "spear" or solo_gear_type.allows_shield) and gear_table.shield then
		return gear_table.shield
	end
end

function ProfileHelper:set_gear_patterns(unit, meshes, pattern, material_variation)
	if material_variation then
		Unit.set_material_variation(unit, material_variation)
	end

	for mesh_name, materials in pairs(meshes) do
		if script_data.pattern_debug then
			print("MESH", mesh_name)
		end

		local mesh = Unit.mesh(unit, mesh_name)

		for _, material_name in ipairs(materials) do
			if script_data.pattern_debug then
				print("MATERIAL", material_name)
			end

			local material = Mesh.material(mesh, material_name)

			Material.set_scalar(material, "pattern_variation", pattern.pattern_variation)
			Material.set_scalar(material, "atlas_variation", pattern.atlas_variation)
		end
	end
end

function ProfileHelper:build_profile_from_game_object(game, profile_obj_id, inventory)
	local profile = {}
	local armour = NetworkLookup.armours[GameSession.game_object_field(game, profile_obj_id, "armour")]
	local helmet_name = NetworkLookup.helmets[GameSession.game_object_field(game, profile_obj_id, "helmet")]

	profile.armour = armour

	local gear_table = {}

	for slot_name, slot in pairs(inventory:slots()) do
		local gear = slot.gear

		if gear then
			gear_table[#gear_table + 1] = {
				name = gear:name(),
				attachments = {}
			}
		end
	end

	profile.gear = gear_table
	profile.helmet = {
		name = helmet_name
	}

	local perk_table = {}

	for _, slot in ipairs(PerkSlots) do
		local perk_lookup = GameSession.game_object_field(game, profile_obj_id, slot.game_object_field)

		if perk_lookup ~= 0 then
			local perk = NetworkLookup.perks[perk_lookup]

			perk_table[slot.name] = perk
		end
	end

	profile.perks = perk_table
	profile.display_name = L("your_killers_profile")

	return profile
end

function ProfileHelper:is_entity_avalible(unlock_type, unlock_key, entity_type, entity_name, release_name, developer_item, required_dlc)
	if GameSettingsDevelopment.unlock_all then
		return true
	end

	local release_setting = ReleaseSettings[release_name or "default"]

	fassert(release_setting, "Invalid release setting %q", release_name)

	if release_setting == "test" then
		return true
	end

	local profile_data = Managers.persistence:profile_data()

	if not profile_data then
		if unlock_type == "profile" and unlock_key == PlayerProfiles[1].unlock_key then
			return true
		else
			return false, "rank_not_met"
		end
	end

	if required_dlc and DLCSettings[required_dlc] and not DLCSettings[required_dlc]() then
		return false, "dlc_not_equiped"
	end

	local entity_rank_met = self:entity_rank_met(unlock_type, unlock_key, profile_data)
	local profile_attributes = profile_data and profile_data.attributes
	local developer = profile_attributes and profile_attributes.developer and profile_attributes.developer > 0
	local hide_dev_gear = developer_item and not developer

	if IS_DEMO then
		local available_in_demo = self:available_in_demo(entity_type, entity_name)

		if available_in_demo then
			return true
		else
			return false, "locked_in_demo"
		end
	elseif hide_dev_gear then
		return false, "not_a_developer"
	elseif entity_rank_met then
		local entity_owned = self:entity_owned(entity_type, entity_name, profile_data)

		if entity_owned then
			return true
		else
			return false, "not_owned"
		end
	else
		return false, "rank_not_met"
	end
end

function ProfileHelper:entity_rank_met(unlock_type, unlock_key, profile_data)
	local required_rank = ProfileHelper:required_entity_rank(unlock_type, unlock_key)
	local rank = profile_data.attributes.rank

	if not required_rank then
		return true
	elseif not rank then
		return false
	end

	return required_rank <= rank
end

function ProfileHelper:available_in_demo(unlock_category, unlock_key)
	for _, demo_unlocks in ipairs(DemoSettings.unlocks) do
		if demo_unlocks.category_name == unlock_category and demo_unlocks.name == unlock_key then
			return true
		end
	end
end

function ProfileHelper:required_entity_rank(unlock_type, unlock_key)
	local required_rank

	for i = 0, #RANKS do
		local rank = RANKS[i]

		for _, unlock in ipairs(rank.unlocks) do
			if unlock.category == unlock_type and unlock.name == unlock_key then
				required_rank = i

				return i
			end
		end
	end
end

function ProfileHelper:entity_owned(entity_type, entity_name, profile_data)
	if DLCSettings.premium() and (entity_type ~= "helmet" or Helmets[entity_name].required_dlc ~= DLCSettings.yogscast) then
		return true
	end

	for _, e in ipairs(profile_data.entities) do
		if e.type == entity_type and e.name == entity_name then
			return true
		end
	end
end

function ProfileHelper:exists_in_market(market_item_name)
	local market_item = Managers.persistence:market().items[market_item_name]

	return market_item and true or false
end

function ProfileHelper:xp_left_to_rank(rank)
	local profile_data = Managers.persistence:profile_data()

	if profile_data then
		local xp = math.floor(profile_data.attributes.experience)
		local xp_rank = RANKS[rank].xp.base

		return math.max(xp_rank - xp, 0)
	end
end

function ProfileHelper:has_perk(perk_name, character_profile)
	for _, profile_perk_name in pairs(character_profile.perks) do
		if perk_name == profile_perk_name then
			return true
		end
	end
end

function ProfileHelper:perk_multiplier(perk_name, perk_multiplier, character_profile)
	if ProfileHelper:has_perk(perk_name, character_profile) then
		return Perks[perk_name][perk_multiplier]
	else
		return 1
	end
end

function bit_encode(value_1, bits_1, value_2, bits_2)
	local part_1 = value_1
	local part_2 = value_2 * 2^bits_1

	return part_1 + part_2
end

function bit_decode(total_value, bits_1, bits_2)
	local value_2 = math.floor(total_value / 2^bits_1)
	local value_1 = total_value % 2^bits_1

	return value_1, value_2
end

function log2(value)
	local bits = 0
	local new_value = value

	repeat
		new_value = new_value / 2
		bits = bits + 1
	until new_value <= 1

	return bits
end

function ProfileHelper:merge_beard_and_color(beard, color)
	local bits_1 = log2(#Beards)
	local bits_2 = log2(#BeardColors)

	return bit_encode(beard, bits_1, color, bits_2)
end

function ProfileHelper:get_beard_and_color(merged_value)
	local bits_1 = log2(#Beards)
	local bits_2 = log2(#BeardColors)

	return bit_decode(merged_value, bits_1, bits_2)
end
