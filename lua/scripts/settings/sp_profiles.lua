-- chunkname: @scripts/settings/sp_profiles.lua

require("scripts/settings/perk_settings")

SPProfiles = {
	{
		voice_white = "medium_saxon",
		cloak_white = "no_cloak",
		display_name = "Tutorial Plebster",
		unlock_key = "custom_1",
		armour_red = "armour_viking_padded",
		no_editing = true,
		cloak_red = "no_cloak",
		voice_red = "medium_viking",
		archetype = "heavy",
		demo_unlocked = true,
		head_white = "knight",
		head_red = "viking_1",
		armour_white = "armour_saxon_chainmail",
		head_attachments_red = {},
		perks = {
			perk_1 = "empty",
			perk_2 = "empty",
			perk_4 = "empty",
			perk_3 = "empty"
		},
		helmet_red = {
			name = "helmet_viking_hawk_light",
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
				name = "sword_kit_sword_02_worn"
			},
			dagger = {
				name = "viking_dagger"
			},
			secondary = {
				name = "viking_axe_51"
			}
		}
	}
}
