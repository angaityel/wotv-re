-- chunkname: @scripts/settings/armours.lua

require("gui/textures/outfit_atlas")

local CHARACTER_TINT_MATERIALS = {
	g_body_lod0 = {
		"mtr_leather",
		"mtr_cloth",
		"mtr_metal"
	},
	g_body_lod1 = {
		"mtr_leather",
		"mtr_cloth",
		"mtr_metal"
	},
	g_body_lod2 = {
		"mtr_leather",
		"mtr_cloth",
		"mtr_metal"
	},
	g_body_lod3 = {
		"mtr_leather",
		"mtr_cloth"
	}
}
local berserk_TINT_MATERIALS = {
	g_body_lod0 = {
		"mtr_leather",
		"mtr_cloth",
		"mtr_metal"
	},
	g_body_lod1 = {
		"mtr_leather",
		"mtr_cloth",
		"mtr_metal"
	},
	g_body_lod2 = {
		"mtr_leather",
		"mtr_cloth"
	},
	g_body_lod3 = {
		"mtr_leather",
		"mtr_cloth"
	}
}
local berserk_and_celt_TINT_MATERIALS_2 = {
	g_body_lod0 = {
		"mtr_skin"
	},
	g_body_lod1 = {
		"mtr_skin"
	},
	g_body_lod2 = {
		"mtr_skin"
	},
	g_body_lod3 = {
		"mtr_skin"
	}
}
local CELT_TINT_MATERIALS = {
	g_body_lod0 = {
		"mtr_cloth"
	},
	g_body_lod1 = {
		"mtr_cloth"
	},
	g_body_lod2 = {
		"mtr_cloth"
	}
}

SaxonBerserkerPatterns = {}

for i = 1, 32 do
	SaxonBerserkerPatterns["pattern_" .. i] = {}
	SaxonBerserkerPatterns["pattern_" .. i].name = "pattern_" .. i
	SaxonBerserkerPatterns["pattern_" .. i].ui_header = "Pattern test " .. i .. " UI Header"
	SaxonBerserkerPatterns["pattern_" .. i].ui_description = "This is pattern test " .. i
	SaxonBerserkerPatterns["pattern_" .. i].ui_fluff_text = nil
	SaxonBerserkerPatterns["pattern_" .. i].pattern_variation = 2
	SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
		atlas_variation = 0,
		pattern_variation = 0
	}
	SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = i - 1
	SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
	SaxonBerserkerPatterns["pattern_" .. i].index = i
	SaxonBerserkerPatterns["pattern_" .. i].texture_func = "cb_pattern_material"

	if i == 32 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 9750
		SaxonBerserkerPatterns["pattern_" .. i].tier = 5
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 25
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 31 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 7780
		SaxonBerserkerPatterns["pattern_" .. i].tier = 5
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 30 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 6990
		SaxonBerserkerPatterns["pattern_" .. i].tier = 5
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 26
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 29 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 6240
		SaxonBerserkerPatterns["pattern_" .. i].tier = 5
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 23
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 28 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 13900
		SaxonBerserkerPatterns["pattern_" .. i].tier = 4
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 28
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 27 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 11600
		SaxonBerserkerPatterns["pattern_" .. i].tier = 4
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 29
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 26 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 9450
		SaxonBerserkerPatterns["pattern_" .. i].tier = 4
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 31
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 25 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 7110
		SaxonBerserkerPatterns["pattern_" .. i].tier = 4
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 24 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 640
		SaxonBerserkerPatterns["pattern_" .. i].tier = 2
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].atlas_variation = 27
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i > 15 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = i * 130
		SaxonBerserkerPatterns["pattern_" .. i].tier = 3
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
		SaxonBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 14,
			pattern_variation = 2
		}
	elseif i > 8 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 125 + i * 26
		SaxonBerserkerPatterns["pattern_" .. i].tier = 2
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
	elseif i > 4 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 60 + i * 6
		SaxonBerserkerPatterns["pattern_" .. i].tier = 1
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
	elseif i > 1 then
		SaxonBerserkerPatterns["pattern_" .. i].market_price = 60 + i * 6
		SaxonBerserkerPatterns["pattern_" .. i].tier = 1
		SaxonBerserkerPatterns["pattern_" .. i].required_dlc = DLCSettings.beagle
		SaxonBerserkerPatterns["pattern_" .. i].release_name = "main"
	else
		SaxonBerserkerPatterns["pattern_" .. i].market_price = nil
		SaxonBerserkerPatterns["pattern_" .. i].tier = 1
	end

	SaxonBerserkerPatterns["pattern_" .. i].entity_type = "armour_pattern"
end

VikingBerserkerPatterns = {}

for i = 1, 32 do
	VikingBerserkerPatterns["pattern_" .. i] = {}
	VikingBerserkerPatterns["pattern_" .. i].name = "pattern_" .. i
	VikingBerserkerPatterns["pattern_" .. i].ui_header = "Pattern test " .. i .. " UI Header"
	VikingBerserkerPatterns["pattern_" .. i].ui_description = "This is pattern test " .. i
	VikingBerserkerPatterns["pattern_" .. i].ui_fluff_text = nil
	VikingBerserkerPatterns["pattern_" .. i].pattern_variation = 2
	VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
		atlas_variation = 0,
		pattern_variation = 0
	}
	VikingBerserkerPatterns["pattern_" .. i].atlas_variation = i - 1
	VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
	VikingBerserkerPatterns["pattern_" .. i].index = i
	VikingBerserkerPatterns["pattern_" .. i].texture_func = "cb_pattern_material"

	if i == 32 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 9750
		VikingBerserkerPatterns["pattern_" .. i].tier = 5
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 31
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 31 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 7780
		VikingBerserkerPatterns["pattern_" .. i].tier = 5
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 30 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 6990
		VikingBerserkerPatterns["pattern_" .. i].tier = 5
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 28
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 29 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 6240
		VikingBerserkerPatterns["pattern_" .. i].tier = 5
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].pattern_variation = 0
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 23
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 6,
			pattern_variation = 0
		}
	elseif i == 28 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 13900
		VikingBerserkerPatterns["pattern_" .. i].tier = 4
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 25
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 27 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 11600
		VikingBerserkerPatterns["pattern_" .. i].tier = 4
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 29
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 26 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 9450
		VikingBerserkerPatterns["pattern_" .. i].tier = 4
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 27
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 25 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 7110
		VikingBerserkerPatterns["pattern_" .. i].tier = 4
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i == 24 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 640
		VikingBerserkerPatterns["pattern_" .. i].tier = 2
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].atlas_variation = 26
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 10,
			pattern_variation = 2
		}
	elseif i > 15 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = i * 130
		VikingBerserkerPatterns["pattern_" .. i].tier = 3
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
		VikingBerserkerPatterns["pattern_" .. i].secondary_tint = {
			atlas_variation = 14,
			pattern_variation = 2
		}
	elseif i > 8 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 125 + i * 26
		VikingBerserkerPatterns["pattern_" .. i].tier = 2
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
	elseif i > 4 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 60 + i * 6
		VikingBerserkerPatterns["pattern_" .. i].tier = 1
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
	elseif i > 1 then
		VikingBerserkerPatterns["pattern_" .. i].market_price = 60 + i * 6
		VikingBerserkerPatterns["pattern_" .. i].tier = 1
		VikingBerserkerPatterns["pattern_" .. i].required_dlc = DLCSettings.beagle
		VikingBerserkerPatterns["pattern_" .. i].release_name = "main"
	else
		VikingBerserkerPatterns["pattern_" .. i].market_price = nil
		VikingBerserkerPatterns["pattern_" .. i].tier = 1
	end

	VikingBerserkerPatterns["pattern_" .. i].entity_type = "armour_pattern"
end

BasePatterns = {}

for i = 1, 32 do
	BasePatterns["pattern_" .. i] = {}
	BasePatterns["pattern_" .. i].name = "pattern_" .. i
	BasePatterns["pattern_" .. i].ui_header = "Pattern test " .. i .. " UI Header"
	BasePatterns["pattern_" .. i].ui_description = "This is pattern test " .. i
	BasePatterns["pattern_" .. i].ui_fluff_text = nil
	BasePatterns["pattern_" .. i].pattern_variation = 0
	BasePatterns["pattern_" .. i].atlas_variation = i - 1
	BasePatterns["pattern_" .. i].release_name = "main"
	BasePatterns["pattern_" .. i].index = i
	BasePatterns["pattern_" .. i].texture_func = "cb_pattern_material"

	if i == 32 then
		BasePatterns["pattern_" .. i].market_price = 9750
		BasePatterns["pattern_" .. i].tier = 5
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 31 then
		BasePatterns["pattern_" .. i].market_price = 7780
		BasePatterns["pattern_" .. i].tier = 5
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 30 then
		BasePatterns["pattern_" .. i].market_price = 6990
		BasePatterns["pattern_" .. i].tier = 5
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 29 then
		BasePatterns["pattern_" .. i].market_price = 6240
		BasePatterns["pattern_" .. i].tier = 5
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 28 then
		BasePatterns["pattern_" .. i].market_price = 13900
		BasePatterns["pattern_" .. i].tier = 4
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 27 then
		BasePatterns["pattern_" .. i].market_price = 11600
		BasePatterns["pattern_" .. i].tier = 4
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 26 then
		BasePatterns["pattern_" .. i].market_price = 9450
		BasePatterns["pattern_" .. i].tier = 4
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i == 25 then
		BasePatterns["pattern_" .. i].market_price = 7110
		BasePatterns["pattern_" .. i].tier = 4
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i > 16 then
		BasePatterns["pattern_" .. i].market_price = i * 130
		BasePatterns["pattern_" .. i].tier = 3
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i > 8 then
		BasePatterns["pattern_" .. i].market_price = 125 + i * 26
		BasePatterns["pattern_" .. i].tier = 2
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i > 4 then
		BasePatterns["pattern_" .. i].market_price = 60 + i * 6
		BasePatterns["pattern_" .. i].tier = 1
		BasePatterns["pattern_" .. i].release_name = "main"
	elseif i > 1 then
		BasePatterns["pattern_" .. i].market_price = 60 + i * 6
		BasePatterns["pattern_" .. i].tier = 1
		BasePatterns["pattern_" .. i].required_dlc = DLCSettings.beagle
		BasePatterns["pattern_" .. i].release_name = "main"
	else
		BasePatterns["pattern_" .. i].market_price = nil
		BasePatterns["pattern_" .. i].tier = 1
	end

	BasePatterns["pattern_" .. i].entity_type = "armour_pattern"
end

ArmourPatterns = {}

for name, pattern in pairs(BasePatterns) do
	local team_names = {
		"saxon",
		"viking"
	}

	for _, team_name in ipairs(team_names) do
		for _, archetype_name in pairs(ArchetypeList) do
			if archetype_name ~= "berserk" then
				local pattern_name = team_name .. "_" .. archetype_name .. "_" .. name

				ArmourPatterns[pattern_name] = table.clone(pattern)
				ArmourPatterns[pattern_name].name = pattern_name
			end
		end
	end
end

for name, pattern in pairs(VikingBerserkerPatterns) do
	local pattern_name = "viking_" .. "berserk" .. "_" .. name

	ArmourPatterns[pattern_name] = table.clone(pattern)
	ArmourPatterns[pattern_name].name = pattern_name
end

for name, pattern in pairs(SaxonBerserkerPatterns) do
	local pattern_name = "saxon_" .. "berserk" .. "_" .. name

	ArmourPatterns[pattern_name] = table.clone(pattern)
	ArmourPatterns[pattern_name].name = pattern_name
end

DefaultHitZones = {
	heavy = {
		head = {
			penetration_value = 0,
			absorption_value = 0,
			armour_type = "none"
		}
	},
	medium = {
		head = {
			penetration_value = 0,
			absorption_value = 0,
			armour_type = "none"
		}
	},
	light = {
		head = {
			penetration_value = 0,
			absorption_value = 0,
			armour_type = "none"
		}
	}
}
DefaultArmour = {
	market_price = 18000,
	ui_texture = "default",
	penetration_value = 0.5,
	release_name = "BloodEagle",
	armour_type = "armour_mail",
	ui_sort_index = 1,
	category = "light",
	encumbrance = 0,
	armour_sound_type = "light",
	ui_unit = {
		rotation = {
			{
				x = -90
			},
			{
				y = 190
			}
		},
		camera_position = Vector3Box(0, 1, 1.15)
	},
	attachments = {
		{
			ui_header = "armour_light_tabard_patterns_header",
			menu_page_type = "text",
			category = "patterns"
		}
	},
	attachment_definitions = {
		patterns = {}
	},
	meshes = CHARACTER_TINT_MATERIALS,
	preview_unit_meshes = CHARACTER_TINT_MATERIALS
}

function get_patterns(team, archetype_name)
	local patterns = {}

	for i = 1, 32 do
		patterns[i] = ArmourPatterns[team .. "_" .. archetype_name .. "_pattern_" .. i]
	end

	return patterns
end

Armours = Armours or {}
Armours.armour_saxon_chainmail = Armours.armour_saxon_chainmail or table.clone(DefaultArmour)
Armours.armour_saxon_chainmail.armour_unit = "units/armour/armours/chr_be_saxon_chainmail/chr_be_saxon_chainmail"
Armours.armour_saxon_chainmail.ui_header = "armour_name_saxon_chainmail"
Armours.armour_saxon_chainmail.ui_description = "armour_description_saxon_chainmail"
Armours.armour_saxon_chainmail.ui_fluff_text = "armour_fluff_saxon_chainmail"
Armours.armour_saxon_chainmail.no_decapitation = true
Armours.armour_saxon_chainmail.hit_zones = DefaultHitZones.heavy
Armours.armour_saxon_chainmail.armour_sound_type = "heavy"
Armours.armour_saxon_chainmail.attachment_definitions.patterns = get_patterns("saxon", "heavy")
Armours.armour_saxon_chainmail.armour_sound_material = "mail"
Armours.armour_saxon_chainmail.absorption_value = 0.4
Armours.armour_viking_chainmail = Armours.armour_viking_chainmail or table.clone(DefaultArmour)
Armours.armour_viking_chainmail.armour_unit = "units/armour/armours/chr_be_viking_chainmail/chr_be_viking_chainmail"
Armours.armour_viking_chainmail.ui_header = "armour_name_viking_chainmail"
Armours.armour_viking_chainmail.ui_description = "armour_description_viking_chainmail"
Armours.armour_viking_chainmail.ui_fluff_text = "armour_fluff_viking_chainmail"
Armours.armour_viking_chainmail.no_decapitation = false
Armours.armour_viking_chainmail.hit_zones = DefaultHitZones.heavy
Armours.armour_viking_chainmail.armour_sound_type = "heavy"
Armours.armour_viking_chainmail.attachment_definitions.patterns = get_patterns("viking", "heavy")
Armours.armour_viking_chainmail.armour_sound_material = "mail"
Armours.armour_viking_chainmail.absorption_value = 0.4
Armours.armour_saxon_warrior_maiden = Armours.armour_saxon_warrior_maiden or table.clone(DefaultArmour)
Armours.armour_saxon_warrior_maiden.armour_unit = "units/armour/armours/chr_be_saxon_warrior_maiden/chr_be_saxon_warrior_maiden"
Armours.armour_saxon_warrior_maiden.ui_header = "armour_name_saxon_warrior_maiden"
Armours.armour_saxon_warrior_maiden.ui_description = "armour_description_saxon_warrior_maiden"
Armours.armour_saxon_warrior_maiden.ui_fluff_text = "armour_fluff_saxon_warrior_maiden"
Armours.armour_saxon_warrior_maiden.no_decapitation = false
Armours.armour_saxon_warrior_maiden.hit_zones = DefaultHitZones.medium
Armours.armour_saxon_warrior_maiden.armour_sound_type = "medium"
Armours.armour_saxon_warrior_maiden.attachment_definitions.patterns = get_patterns("saxon", "heavy")
Armours.armour_saxon_warrior_maiden.armour_sound_material = "mail"
Armours.armour_saxon_warrior_maiden.absorption_value = 0.3
Armours.armour_viking_shieldmaiden = Armours.armour_viking_shieldmaiden or table.clone(DefaultArmour)
Armours.armour_viking_shieldmaiden.armour_unit = "units/armour/armours/chr_be_viking_shieldmaiden/chr_be_viking_shieldmaiden"
Armours.armour_viking_shieldmaiden.ui_header = "armour_name_viking_shieldmaiden"
Armours.armour_viking_shieldmaiden.ui_description = "armour_description_viking_shieldmaiden"
Armours.armour_viking_shieldmaiden.ui_fluff_text = "armour_fluff_viking_shieldmaiden"
Armours.armour_viking_shieldmaiden.no_decapitation = false
Armours.armour_viking_shieldmaiden.hit_zones = DefaultHitZones.medium
Armours.armour_viking_shieldmaiden.armour_sound_type = "medium"
Armours.armour_viking_shieldmaiden.attachment_definitions.patterns = get_patterns("viking", "heavy")
Armours.armour_viking_shieldmaiden.armour_sound_material = "mail"
Armours.armour_viking_shieldmaiden.absorption_value = 0.3
Armours.armour_viking_padded = Armours.armour_viking_padded or table.clone(DefaultArmour)
Armours.armour_viking_padded.armour_unit = "units/armour/armours/chr_be_viking_padded/chr_be_viking_padded"
Armours.armour_viking_padded.ui_header = "armour_name_viking_padded"
Armours.armour_viking_padded.ui_description = "armour_description_viking_padded"
Armours.armour_viking_padded.ui_fluff_text = "armour_fluff_viking_padded"
Armours.armour_viking_padded.no_decapitation = false
Armours.armour_viking_padded.hit_zones = DefaultHitZones.light
Armours.armour_viking_padded.armour_sound_type = "light"
Armours.armour_viking_padded.attachment_definitions.patterns = get_patterns("viking", "light")
Armours.armour_viking_padded.armour_sound_material = "cloth"
Armours.armour_viking_padded.absorption_value = 0.125
Armours.armour_saxon_cloth = Armours.armour_saxon_cloth or table.clone(DefaultArmour)
Armours.armour_saxon_cloth.armour_unit = "units/armour/armours/chr_be_saxon_cloth/chr_be_saxon_cloth"
Armours.armour_saxon_cloth.ui_header = "armour_name_saxon_cloth"
Armours.armour_saxon_cloth.ui_description = "armour_description_saxon_cloth"
Armours.armour_saxon_cloth.ui_fluff_text = "armour_fluff_saxon_cloth"
Armours.armour_saxon_cloth.no_decapitation = false
Armours.armour_saxon_cloth.hit_zones = DefaultHitZones.light
Armours.armour_saxon_cloth.armour_sound_type = "light"
Armours.armour_saxon_cloth.armour_sound_material = "cloth"
Armours.armour_saxon_cloth.attachment_definitions.patterns = get_patterns("saxon", "light")
Armours.armour_saxon_cloth.absorption_value = 0.125
Armours.armour_viking_scalemail = Armours.armour_viking_scalemail or table.clone(DefaultArmour)
Armours.armour_viking_scalemail.armour_unit = "units/armour/armours/chr_be_viking_scalemail/chr_be_viking_scalemail"
Armours.armour_viking_scalemail.ui_header = "armour_name_viking_scalemail"
Armours.armour_viking_scalemail.ui_description = "armour_description_viking_scalemail"
Armours.armour_viking_scalemail.ui_fluff_text = "armour_fluff_viking_scalemail"
Armours.armour_viking_scalemail.no_decapitation = false
Armours.armour_viking_scalemail.hit_zones = DefaultHitZones.medium
Armours.armour_viking_scalemail.armour_sound_type = "medium"
Armours.armour_viking_scalemail.attachment_definitions.patterns = get_patterns("viking", "medium")
Armours.armour_viking_scalemail.armour_sound_material = "mail"
Armours.armour_viking_scalemail.absorption_value = 0.3
Armours.armour_saxon_chainmail_shirt = Armours.armour_saxon_chainmail_shirt or table.clone(DefaultArmour)
Armours.armour_saxon_chainmail_shirt.armour_unit = "units/armour/armours/chr_be_saxon_chainmail_shirt/chr_be_saxon_chainmail_shirt"
Armours.armour_saxon_chainmail_shirt.ui_header = "armour_name_saxon_chainmail_shirt"
Armours.armour_saxon_chainmail_shirt.ui_description = "armour_description_saxon_chainmail_shirt"
Armours.armour_saxon_chainmail_shirt.ui_fluff_text = "armour_fluff_saxon_chainmail_shirt"
Armours.armour_saxon_chainmail_shirt.no_decapitation = false
Armours.armour_saxon_chainmail_shirt.hit_zones = DefaultHitZones.medium
Armours.armour_saxon_chainmail_shirt.armour_sound_type = "medium"
Armours.armour_saxon_chainmail_shirt.attachment_definitions.patterns = get_patterns("saxon", "medium")
Armours.armour_saxon_chainmail_shirt.armour_sound_material = "mail"
Armours.armour_saxon_chainmail_shirt.absorption_value = 0.3
Armours.armour_saxon_berserk = Armours.armour_saxon_berserk or table.clone(DefaultArmour)
Armours.armour_saxon_berserk.armour_unit = "units/armour/armours/chr_be_saxon_berserk/chr_saxon_berserk"
Armours.armour_saxon_berserk.ui_header = "armour_name_saxon_berserk"
Armours.armour_saxon_berserk.ui_description = "armour_description_saxon_berserk"
Armours.armour_saxon_berserk.ui_fluff_text = "armour_fluff_saxon_berserk"
Armours.armour_saxon_berserk.no_decapitation = false
Armours.armour_saxon_berserk.hit_zones = DefaultHitZones.light
Armours.armour_saxon_berserk.armour_sound_type = "berserk"
Armours.armour_saxon_berserk.attachment_definitions.patterns = get_patterns("saxon", "berserk")
Armours.armour_saxon_berserk.armour_sound_material = "cloth"
Armours.armour_saxon_berserk.absorption_value = 0.125
Armours.armour_saxon_berserk.meshes = CELT_TINT_MATERIALS
Armours.armour_saxon_berserk.meshes_2 = berserk_and_celt_TINT_MATERIALS_2
Armours.armour_saxon_berserk.preview_unit_meshes = CELT_TINT_MATERIALS
Armours.armour_saxon_berserk.preview_unit_meshes_2 = berserk_and_celt_TINT_MATERIALS_2
Armours.armour_viking_berserk = Armours.armour_viking_berserk or table.clone(DefaultArmour)
Armours.armour_viking_berserk.armour_unit = "units/armour/armours/chr_be_viking_berserk/chr_viking_berserk"
Armours.armour_viking_berserk.ui_header = "armour_name_viking_berserk"
Armours.armour_viking_berserk.ui_description = "armour_description_viking_berserk"
Armours.armour_viking_berserk.ui_fluff_text = "armour_fluff_viking_berserk"
Armours.armour_viking_berserk.no_decapitation = false
Armours.armour_viking_berserk.hit_zones = DefaultHitZones.light
Armours.armour_viking_berserk.armour_sound_type = "berserk"
Armours.armour_viking_berserk.attachment_definitions.patterns = get_patterns("viking", "berserk")
Armours.armour_viking_berserk.armour_sound_material = "cloth"
Armours.armour_viking_berserk.absorption_value = 0.125
Armours.armour_viking_berserk.meshes = berserk_TINT_MATERIALS
Armours.armour_viking_berserk.meshes_2 = berserk_and_celt_TINT_MATERIALS_2
Armours.armour_viking_berserk.preview_unit_meshes = berserk_TINT_MATERIALS
Armours.armour_viking_berserk.preview_unit_meshes_2 = berserk_and_celt_TINT_MATERIALS_2

for name, armour in pairs(Armours) do
	armour.name = name
	armour.market_price = armour.market_price or 5000
	armour.entity_type = armour.entity_type or "armour"
end

local attachment_to_key = {}

for armour_name, props in pairs(Armours) do
	for cat_name, category in pairs(props.attachment_definitions) do
		for _, attachment in pairs(category) do
			attachment_to_key[attachment.name] = attachment.unlock_key
		end
	end

	local meshes = props.meshes

	fassert(meshes, "Missing meshes in armour: %s", armour_name)

	local preview_meshes = props.preview_unit_meshes

	fassert(preview_meshes, "Missing preview_unit_meshes in armour: %s", armour_name)
	fassert(props.ui_header, "Missing ui_header in armour: %s", armour_name)
	fassert(props.ui_description, "Missing ui_description in armour: %s", armour_name)
	fassert(props.ui_fluff_text, "Missing ui_fluff_text in armour: %s", armour_name)
	fassert(props.ui_texture, "Missing ui_texture in armour: %s", armour_name)
	fassert(outfit_atlas[props.ui_texture], "ui_texture %q in armour %q missing in outfit_atlas", props.ui_texture, armour_name)
	fassert(props.ui_sort_index, "Missing ui_sort_index in armour: %s", armour_name)
	fassert(props.category, "Missing category in armour: %s", armour_name)
end

local key_to_attachment = {}

for attachment_name, unlock_key in pairs(attachment_to_key) do
	if key_to_attachment[unlock_key] then
		local colliding_attachment = table.find(attachment_to_key, unlock_key)

		ferror("Attachment %q with key %d collides with %q", attachment_name, unlock_key, colliding_attachment)
	end

	key_to_attachment[unlock_key] = true
end

key_to_attachment = nil
attachment_to_key = nil

function default_armour_attachment_unlocks()
	local default_unlocks = {}

	for armour_name, props in pairs(Armours) do
		for _, categories in pairs(props.attachment_definitions) do
			for index, attachment in pairs(categories) do
				if attachment.unlock_this_item ~= false and (index == 1 or attachment.required_dlc) then
					local entity_type = "armour_attachment"

					default_unlocks[entity_type .. "|" .. attachment.name] = {
						category = entity_type,
						name = attachment.name,
						attachment = attachment
					}
				end
			end
		end
	end

	return default_unlocks
end
