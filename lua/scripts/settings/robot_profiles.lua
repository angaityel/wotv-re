-- chunkname: @scripts/settings/robot_profiles.lua

RobotProfiles = RobotProfiles or {
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
		taunt_white = "light_bow",
		archetype = "light",
		demo_unlocked = true,
		head_white = "squire",
		head_red = "viking_1",
		armour_white = "armour_saxon_cloth",
		head_attachments_red = {
			beard = 36
		},
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
		head_attachments_white = {
			beard = 36
		},
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
				name = "viking_axe_21",
				wielded = false
			}
		},
		script_input = ScriptInputSettings.archer
	},
	{
		voice_white = "medium_saxon",
		voice_red = "medium_viking",
		display_name = "Default Warrior",
		unlock_key = "profile_1",
		release_name = "main",
		armour_red = "armour_viking_scalemail",
		no_editing = true,
		cloak_white = "no_cloak",
		cloak_red = "no_cloak",
		archetype = "medium",
		demo_unlocked = true,
		head_white = "squire",
		head_red = "viking_1",
		armour_white = "armour_saxon_chainmail_shirt",
		head_attachments_red = {
			beard = 36
		},
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
		head_attachments_white = {
			beard = 36
		},
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
		},
		script_input = ScriptInputSettings.melee
	}
}
