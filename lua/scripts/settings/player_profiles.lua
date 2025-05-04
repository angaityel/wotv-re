-- chunkname: @scripts/settings/player_profiles.lua

require("scripts/settings/archetypes")
require("scripts/settings/perk_settings")
require("scripts/settings/script_input_settings")

function populate_player_profiles_from_save(save_data)
	local saved_profiles = save_data.profiles or {}

	for i, profile in ipairs(PlayerProfiles) do
		local saved_profile = saved_profiles[i]

		if not saved_profile then
			-- block empty
		elseif profile.no_editing and saved_profile.no_editing then
			-- block empty
		elseif profile.no_editing and not saved_profile.no_editing then
			table.insert(saved_profiles, i, {})
		elseif not profile.no_editing and saved_profile.no_editing then
			-- block empty
		elseif not profile.no_editing and not saved_profile.no_editing then
			local unlock_key = profile.unlock_key

			saved_profile.unlock_key = unlock_key
			PlayerProfiles[i] = saved_profile
		end

		profile.display_name = profile.display_name or ""
	end

	save_data.profiles = PlayerProfiles

	create_headhunter_profiles(table.clone(PlayerProfiles))
end

function create_headhunter_profiles(profiles)
	for key, profile in ipairs(profiles) do
		local profile_gear = profile.gear

		for gear_slot, gear in ipairs(profile_gear) do
			gear.wielded = false
		end

		local shield = profile_gear.shield

		if shield then
			profile_gear.shield = nil
		end

		local secondary = profile_gear.secondary

		if secondary then
			profile_gear.secondary = nil
		end

		local primary = profile_gear.primary

		if primary then
			primary.name = "headhunter_throwing_spear"
			primary.wielded = true
		end

		HeadHunterProfiles[key] = profile
	end
end

DefaultUnits = {
	standard = {
		preview = "units/beings/chr_wotr_man/preview_base/preview_base",
		ai = "units/beings/chr_wotr_man/ai_base/ai_base",
		husk = "units/beings/chr_wotr_man/husk_base/husk_base",
		player = "units/beings/chr_wotr_man/player_base/player_base"
	}
}
PlayerProfiles = PlayerProfiles or {
	{
		voice_white = "medium_saxon",
		voice_red = "medium_viking",
		display_name = "Default Warrior",
		unlock_key = "profile_1",
		release_name = "main",
		armour_red = "armour_viking_scalemail",
		no_editing = true,
		cloak_white = "no_cloak",
		taunt_white = "praise_god",
		cloak_red = "no_cloak",
		archetype = "medium",
		taunt_red = "praise_god",
		demo_unlocked = true,
		head_white = "squire",
		head_red = "viking_1",
		armour_white = "armour_saxon_chainmail_shirt",
		head_attachments_red = {},
		perks = {
			perk_1 = "medium",
			perk_2 = "dodge_attack",
			perk_4 = "chase_faster",
			perk_3 = "stamina_on_kill"
		},
		helmet_red = {
			name = "helmet_viking_hawk_medium",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		head_attachments_white = {},
		armour_attachments_red = {
			patterns = 1
		},
		helmet_white = {
			name = "helmet_saxon_basic_medium",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		armour_attachments_white = {
			patterns = 1
		},
		gear = {
			secondary = {
				name = "throwing_axe_31"
			},
			primary = {
				wielded = true,
				name = "sword_kit_sword_01"
			},
			dagger = {
				name = "viking_dagger"
			},
			shield = {
				wielded = true,
				name = "round_shield_worn"
			}
		}
	},
	{
		voice_white = "heavy_saxon",
		cloak_white = "no_cloak",
		display_name = "Default Champion",
		unlock_key = "profile_2",
		release_name = "main",
		armour_red = "armour_viking_chainmail",
		no_editing = true,
		taunt_white = "charge",
		cloak_red = "no_cloak",
		voice_red = "heavy_viking",
		archetype = "heavy",
		taunt_red = "charge",
		demo_unlocked = true,
		head_white = "squire",
		head_red = "viking_1",
		armour_white = "armour_saxon_chainmail",
		head_attachments_red = {},
		perks = {
			perk_1 = "heavy_01",
			perk_2 = "heavy_02",
			perk_4 = "faster_melee_charge",
			perk_3 = "dodge_attack"
		},
		helmet_red = {
			name = "helmet_vendel_heavy",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		head_attachments_white = {},
		armour_attachments_red = {
			patterns = 1
		},
		armour_attachments_white = {
			patterns = 1
		},
		helmet_white = {
			name = "helmet_saxon_basic_heavy",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		gear = {
			primary = {
				wielded = true,
				name = "twohanded_axe_21"
			},
			dagger = {
				name = "viking_dagger"
			},
			secondary = {
				name = "throwing_dagger_11"
			}
		}
	},
	{
		voice_white = "light_saxon",
		voice_red = "light_viking",
		display_name = "Default Skirmisher",
		unlock_key = "profile_3",
		release_name = "main",
		armour_red = "armour_viking_padded",
		no_editing = true,
		cloak_white = "no_cloak",
		cloak_red = "no_cloak",
		taunt_white = "bow",
		archetype = "light",
		taunt_red = "bow",
		demo_unlocked = true,
		head_white = "squire",
		head_red = "viking_1",
		armour_white = "armour_saxon_cloth",
		head_attachments_red = {},
		perks = {
			perk_1 = "light_01",
			perk_2 = "light_02",
			perk_4 = "piercing_shots",
			perk_3 = "bow_zoom"
		},
		helmet_red = {
			name = "helmet_viking_hawk_light",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		head_attachments_white = {},
		helmet_white = {
			name = "helmet_saxon_basic_light",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		armour_attachments_red = {
			patterns = 1
		},
		armour_attachments_white = {
			patterns = 1
		},
		gear = {
			primary = {
				name = "longbow",
				wielded = true
			},
			dagger = {
				name = "viking_dagger",
				wielded = false
			},
			secondary = {
				name = "viking_axe_11",
				wielded = false
			}
		}
	},
	{
		voice_white = "female_saxon",
		cloak_white = "no_cloak",
		display_name = "Default Shield Maiden",
		unlock_key = "profile_4",
		release_name = "vanguard",
		armour_red = "armour_viking_shieldmaiden",
		no_editing = true,
		taunt_white = "applause",
		cloak_red = "no_cloak",
		voice_red = "female_viking",
		archetype = "shield_maiden",
		taunt_red = "applause",
		demo_unlocked = true,
		head_white = "saxon_5",
		head_red = "viking_5",
		armour_white = "armour_saxon_warrior_maiden",
		head_attachments_red = {},
		perks = {
			perk_1 = "shield_maiden01",
			perk_3 = "dodge_block",
			perk_2 = "shield_maiden02",
			perk_4 = "revive_yourself"
		},
		helmet_red = {
			name = "helmet_shield_maiden_ornamented_heavy",
			show_crest = false,
			attachments = {
				pattern = "rough"
			}
		},
		head_attachments_white = {},
		armour_attachments_red = {
			patterns = 1
		},
		armour_attachments_white = {
			patterns = 1
		},
		helmet_white = {
			name = "helmet_warrior_maiden_02_heavy",
			show_crest = false,
			attachments = {
				pattern = "maiden_03"
			}
		},
		gear = {
			primary = {
				wielded = true,
				name = "shield_maiden_spear"
			},
			dagger = {
				name = "viking_dagger"
			},
			secondary = {
				name = "throwing_spear"
			},
			shield = {
				wielded = true,
				name = "snowflake_shield"
			}
		}
	},
	{
		voice_white = "heavy_saxon",
		cloak_white = "no_cloak",
		display_name = "Default Berserker",
		unlock_key = "profile_5",
		release_name = "berserk",
		armour_red = "armour_viking_berserk",
		no_editing = true,
		taunt_white = "wolfhowl",
		cloak_red = "no_cloak",
		voice_red = "heavy_viking",
		archetype = "berserk",
		taunt_red = "wolfhowl",
		demo_unlocked = true,
		head_white = "saxon_berserk",
		head_red = "viking_6",
		armour_white = "armour_saxon_berserk",
		head_attachments_red = {},
		perks = {
			perk_1 = "berserk_01",
			perk_2 = "last_stand",
			perk_4 = "heal_on_kill",
			perk_3 = "dodge_attack"
		},
		helmet_red = {
			name = "helmet_berserk_bareheaded_viking",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		head_attachments_white = {},
		armour_attachments_red = {
			patterns = 1
		},
		armour_attachments_white = {
			patterns = 1
		},
		helmet_white = {
			name = "helmet_berserk_bareheaded_saxon",
			show_crest = false,
			attachments = {
				pattern = "pattern_standard"
			}
		},
		gear = {
			primary = {
				wielded = true,
				name = "sword_kit_sword_02_worn"
			},
			dagger = {
				name = "viking_dagger"
			},
			secondary = {
				name = "sword_kit_sword_02_worn"
			}
		}
	}
}

local EMPTY_CUSTOM = {
	voice_white = "medium_saxon",
	head_white = "squire",
	display_name = "Custom 1",
	unlock_key = "profile_custom_1",
	release_name = "main",
	armour_red = "armour_viking_scalemail",
	cloak_white = "no_cloak",
	no_editing = false,
	cloak_red = "no_cloak",
	original_display_name = "Custom 1",
	archetype = "medium",
	demo_unlocked = true,
	voice_red = "medium_viking",
	head_red = "viking_1",
	armour_white = "armour_saxon_chainmail_shirt",
	perks = {
		perk_1 = "medium",
		perk_2 = "empty",
		perk_4 = "empty",
		perk_3 = "empty"
	},
	helmet_red = {
		name = "helmet_viking_hawk_medium",
		show_crest = false,
		attachments = {
			pattern = "pattern_standard"
		}
	},
	head_attachments_white = {},
	helmet_white = {
		name = "helmet_saxon_basic_medium",
		show_crest = false,
		attachments = {
			pattern = "pattern_standard"
		}
	},
	armour_attachments_red = {
		patterns = 1
	},
	armour_attachments_white = {
		patterns = 1
	},
	head_attachments_red = {},
	gear = {
		primary = {
			wielded = true,
			name = "sword_kit_sword_02_worn"
		},
		dagger = {
			name = "viking_dagger"
		}
	}
}
local EMPTY_CUSTOM_VANGUARD = table.clone(EMPTY_CUSTOM)

EMPTY_CUSTOM_VANGUARD.release_name = "vanguard"

local EMPTY_CUSTOM_VANGUARD_DLC = table.clone(EMPTY_CUSTOM_VANGUARD)

EMPTY_CUSTOM_VANGUARD_DLC.required_dlc = "vanguard"

local EMPTY_CUSTOM_BERSERKER = table.clone(EMPTY_CUSTOM)

EMPTY_CUSTOM_BERSERKER.release_name = "berserk"

local EMPTY_CUSTOM_BERSERKER_DLC = table.clone(EMPTY_CUSTOM_BERSERKER)

EMPTY_CUSTOM_BERSERKER_DLC.required_dlc = "berserk"

local LOCKED_SLOTS = 5

local function add_custom_profile(profile_template, display_name, unlock_key, index)
	local profile = table.clone(profile_template)

	profile.unlock_key = unlock_key
	profile.display_name = display_name
	profile.original_display_name = profile.display_name
	PlayerProfiles[index] = profile
end

local CUSTOM_SLOTS = 4
local CUSTOM_SLOTS_VANGUARD = 1
local CUSTOM_SLOTS_VANGUARD_OWNER = 2
local CUSTOM_SLOTS_BERSERKER = 1
local CUSTOM_SLOTS_BERSERKER_OWNER = 2

for i = 1, CUSTOM_SLOTS do
	local index = LOCKED_SLOTS + i

	add_custom_profile(EMPTY_CUSTOM, "Custom " .. i, "profile_custom_" .. i, index)
end

for i = 1, CUSTOM_SLOTS_VANGUARD do
	local index = LOCKED_SLOTS + CUSTOM_SLOTS + i

	add_custom_profile(EMPTY_CUSTOM_VANGUARD, "Custom 5", "profile_custom_vanguard_" .. i, index)
end

for i = 1, CUSTOM_SLOTS_BERSERKER do
	local index = LOCKED_SLOTS + CUSTOM_SLOTS + CUSTOM_SLOTS_VANGUARD + i

	add_custom_profile(EMPTY_CUSTOM_BERSERKER, "Custom 6", "profile_custom_berserker_" .. i, index)
end

for i = 1, CUSTOM_SLOTS_VANGUARD_OWNER do
	local index = LOCKED_SLOTS + CUSTOM_SLOTS + CUSTOM_SLOTS_VANGUARD + CUSTOM_SLOTS_BERSERKER + i

	add_custom_profile(EMPTY_CUSTOM_VANGUARD_DLC, "Extra Custom " .. i, "profile_custom_vanguard_owner_" .. i, index)
end

for i = 1, CUSTOM_SLOTS_BERSERKER_OWNER do
	local index = LOCKED_SLOTS + CUSTOM_SLOTS + CUSTOM_SLOTS_VANGUARD + CUSTOM_SLOTS_BERSERKER + CUSTOM_SLOTS_VANGUARD_OWNER + i

	add_custom_profile(EMPTY_CUSTOM_BERSERKER_DLC, "Extra Custom " .. i + 2, "profile_custom_berserker_owner_" .. i, index)
end

function profile_index_by_unlock(unlock_key)
	for index, profile in pairs(PlayerProfiles) do
		if profile.unlock_key == unlock_key then
			return index
		end
	end
end

PlayerProfilesDefault = PlayerProfilesDefault or table.clone(PlayerProfiles)
DefaultArchetypeProfileSettings = DefaultArchetypeProfileSettings or {}
DefaultArchetypeProfileSettings.medium = DefaultArchetypeProfileSettings.medium or table.clone(PlayerProfilesDefault[1])
DefaultArchetypeProfileSettings.medium.no_editing = false
DefaultArchetypeProfileSettings.medium.demo_unlocked = false
DefaultArchetypeProfileSettings.medium.perks.perk_2 = "empty"
DefaultArchetypeProfileSettings.medium.perks.perk_3 = "empty"
DefaultArchetypeProfileSettings.medium.perks.perk_4 = "empty"
DefaultArchetypeProfileSettings.medium.taunt_red = nil
DefaultArchetypeProfileSettings.medium.taunt_white = nil
DefaultArchetypeProfileSettings.medium.gear = table.clone(EMPTY_CUSTOM.gear)
DefaultArchetypeProfileSettings.heavy = DefaultArchetypeProfileSettings.heavy or table.clone(PlayerProfilesDefault[2])
DefaultArchetypeProfileSettings.heavy.no_editing = false
DefaultArchetypeProfileSettings.heavy.demo_unlocked = false
DefaultArchetypeProfileSettings.heavy.perks.perk_3 = "empty"
DefaultArchetypeProfileSettings.heavy.perks.perk_4 = "empty"
DefaultArchetypeProfileSettings.heavy.taunt_red = nil
DefaultArchetypeProfileSettings.heavy.taunt_white = nil
DefaultArchetypeProfileSettings.heavy.gear = table.clone(EMPTY_CUSTOM.gear)
DefaultArchetypeProfileSettings.light = DefaultArchetypeProfileSettings.light or table.clone(PlayerProfilesDefault[3])
DefaultArchetypeProfileSettings.light.no_editing = false
DefaultArchetypeProfileSettings.light.demo_unlocked = false
DefaultArchetypeProfileSettings.light.perks.perk_3 = "empty"
DefaultArchetypeProfileSettings.light.perks.perk_4 = "empty"
DefaultArchetypeProfileSettings.light.taunt_red = nil
DefaultArchetypeProfileSettings.light.taunt_white = nil
DefaultArchetypeProfileSettings.light.gear = table.clone(EMPTY_CUSTOM.gear)
DefaultArchetypeProfileSettings.shield_maiden = table.clone(PlayerProfilesDefault[4])
DefaultArchetypeProfileSettings.shield_maiden.no_editing = false
DefaultArchetypeProfileSettings.shield_maiden.demo_unlocked = false
DefaultArchetypeProfileSettings.shield_maiden.taunt_red = nil
DefaultArchetypeProfileSettings.shield_maiden.taunt_white = nil
DefaultArchetypeProfileSettings.shield_maiden.perks.perk_3 = "empty"
DefaultArchetypeProfileSettings.shield_maiden.perks.perk_4 = "empty"
DefaultArchetypeProfileSettings.berserk = DefaultArchetypeProfileSettings.berserk or table.clone(PlayerProfilesDefault[5])
DefaultArchetypeProfileSettings.berserk.no_editing = false
DefaultArchetypeProfileSettings.berserk.demo_unlocked = false
DefaultArchetypeProfileSettings.berserk.perks.perk_3 = "empty"
DefaultArchetypeProfileSettings.berserk.perks.perk_4 = "empty"
DefaultArchetypeProfileSettings.berserk.taunt_red = nil
DefaultArchetypeProfileSettings.berserk.taunt_white = nil
DefaultArchetypeProfileSettings.berserk.gear = {
	primary = {
		wielded = true,
		name = "viking_axe_11"
	},
	dagger = {
		name = "viking_dagger"
	},
	secondary = {
		name = "viking_axe_11"
	}
}
HeadHunterProfiles = table.clone(PlayerProfiles)
DefaultArchetypeProfileSettings.clone_ignore_list = {
	no_editing = true,
	unlock_key = true,
	display_name = true,
	demo_unlocked = true
}
