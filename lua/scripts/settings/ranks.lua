-- chunkname: @scripts/settings/ranks.lua

require("scripts/settings/prizes_medals_unlocks_ui_settings")
require("scripts/managers/save/unviewed_unlocked_items")

RANKS = RANKS or {
	[0] = {
		xp = {
			span = 400
		},
		unlocks = {
			{
				name = "profile_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			}
		}
	},
	{
		xp = {
			span = 1100
		},
		unlocks = {}
	},
	{
		xp = {
			span = 1900
		},
		unlocks = {
			{
				name = "profile_2",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			}
		}
	},
	{
		xp = {
			span = 2600
		},
		unlocks = {
			{
				name = "profile_3",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			}
		}
	},
	{
		xp = {
			span = 3400
		},
		unlocks = {
			{
				name = "helmet_shield_maiden_ornamented_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_warrior_maiden_02_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "profile_custom_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_4",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_5",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "helmet_viking_hawk_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_basic_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_viking_hawk_medium",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_basic_medium",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_vendel_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_basic_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "empty",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "chase_faster",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "no_knockdown",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "dodge_block",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "dodge_attack",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "bow_zoom",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "faster_bow_charge",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "heal_on_taunt",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "faster_melee_charge",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "piercing_shots",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "revive_yourself",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "wolfhowl",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "praise_god",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "cheer",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "applause",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "charge",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "bow",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "the_what",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "two_finger_salute",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "warcry",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "slowclap",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "cut_throat",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "riverdance",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "cheers_drink",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "techno_viking",
				category = "taunt",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_taunt
			},
			{
				name = "viking_top_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_1",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_2",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_3",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_4",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_01_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_43",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_33",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_23",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_13",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_53",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "round_shield",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "round_shield_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "longbow",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_01",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_41",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_42",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_32",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_22",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_12",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_52",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_01_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "hunting_bow_rough",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "longbow_rough",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_21",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "hunting_bow",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_51",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_11",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_31",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "snowflake_shield",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 4100
		},
		unlocks = {}
	},
	{
		xp = {
			span = 4900
		},
		unlocks = {
			{
				name = "profile_custom_2",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			}
		}
	},
	{
		xp = {
			span = 5600
		},
		unlocks = {
			{
				name = "viking_mid_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 6400
		},
		unlocks = {
			{
				name = "profile_custom_3",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "saxon_beard_04",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_04_brown",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_15",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_15_brown",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_26",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 7100
		},
		unlocks = {}
	},
	{
		xp = {
			span = 7900
		},
		unlocks = {
			{
				name = "saxon_berserk_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "profile_custom_vanguard_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_vanguard_owner_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_vanguard_owner_2",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_4",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_berserker_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_berserker_owner_1",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "profile_custom_berserker_owner_2",
				category = "profile",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_profile
			},
			{
				name = "saxon_light_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_5",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_6",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_7",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_8",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_spear",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "are_you_not_entertained",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "training_wheels",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "stamina_on_kill",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "heal_on_kill",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "backstab",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "flaming_arrows",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "blade_master",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "tag_on_bow_shot",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "throw_all_weps",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "fake_death",
				category = "perk",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_perk
			},
			{
				name = "viking_mid_heraldry_base20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base56",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base57",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base58",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base59",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base60",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base61",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base62",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base63",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base64",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base65",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base66",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base67",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base68",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base69",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base70",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base71",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base72",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base73",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base74",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base75",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base76",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base77",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base78",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base79",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base80",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base81",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base82",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base83",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base84",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base85",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base86",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base87",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_mid_heraldry_base88",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base56",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base57",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base58",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base59",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base60",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base61",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base62",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base63",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base64",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base65",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base66",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base67",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base68",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base69",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base70",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base71",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base72",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base73",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base74",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base75",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base76",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base77",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base78",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base79",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base80",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base81",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base82",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base83",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base84",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base85",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base86",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base87",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_mid_heraldry_base88",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 8600
		},
		unlocks = {}
	},
	{
		xp = {
			span = 9400
		},
		unlocks = {
			{
				name = "viking_beard_06",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_28",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_05",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_16",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_01",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_viking_brown",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 10100
		},
		unlocks = {
			{
				name = "helmet_saxon_heavy_worn",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 10900
		},
		unlocks = {
			{
				name = "helmet_viking_basic_heavy_leather",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 11600
		},
		unlocks = {
			{
				name = "helmet_viking_basic_medium",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 12400
		},
		unlocks = {
			{
				name = "saxon_beard_06",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_17",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_30",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 13100
		},
		unlocks = {
			{
				name = "helmet_saxon_cone_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 13900
		},
		unlocks = {
			{
				name = "helmet_viking_checker_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 14600
		},
		unlocks = {
			{
				name = "saxon_beard_09",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_20",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_31",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 15500
		},
		unlocks = {
			{
				name = "viking_berserk_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_9",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_10",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_11",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_12",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_13",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_14",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_15",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_16",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_17",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_18",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_19",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_21",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_22",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_23",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_25",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_26",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_27",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_20",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_24",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_28",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base56",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base57",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base58",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base59",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base60",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base61",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base62",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base63",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base64",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base65",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base66",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base67",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base68",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base69",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base70",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base71",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base72",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base73",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base74",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base75",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base76",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base77",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base78",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base79",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base80",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base81",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base82",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base83",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base84",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base85",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base86",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base87",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_top_heraldry_base88",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base56",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base57",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base58",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base59",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base60",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base61",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base62",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base63",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base64",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base65",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base66",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base67",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base68",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base69",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base70",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base71",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base72",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base73",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base74",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base75",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base76",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base77",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base78",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base79",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base80",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base81",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base82",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base83",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base84",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base85",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base86",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base87",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_top_heraldry_base88",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 16300
		},
		unlocks = {
			{
				name = "helmet_saxon_cone_cross_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 17200
		},
		unlocks = {
			{
				name = "twohanded_axe_21",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_22",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_23",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 19000
		},
		unlocks = {
			{
				name = "sword_kit_sword_02_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_02",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_02_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_viking_basic_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 19900
		},
		unlocks = {
			{
				name = "viking_axe_11",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_12",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_13",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_07",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_18",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_05",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_berserker",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserker_beard_01",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_02",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 20700
		},
		unlocks = {
			{
				name = "sword_kit_sword_03_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_03_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_03",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 21600
		},
		unlocks = {
			{
				name = "viking_spear_11",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_12",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_13",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_viking_basic_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 22400
		},
		unlocks = {
			{
				name = "viking_axe_32",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_33",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_31",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_04_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_04_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_04",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 23300
		},
		unlocks = {
			{
				name = "twohanded_axe_31",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_32",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_33",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_11",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_22",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_27",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 24100
		},
		unlocks = {
			{
				name = "helmet_vendel_1",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 25000
		},
		unlocks = {
			{
				name = "viking_beard_12",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_39",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon",
				category = "cloak",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking",
				category = "cloak",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_1",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_1",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_20",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_20",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_24",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_24",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_28",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_28",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_2",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_2",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_3",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_3",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_4",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_4",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_5",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_5",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_6",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_6",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_7",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_7",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_8",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_8",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_9",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_9",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_10",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_10",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_11",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_11",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_12",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_12",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_13",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_13",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_14",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_14",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_15",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_15",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_16",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_16",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_17",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_17",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_18",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_18",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_19",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_19",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_21",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_21",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_22",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_22",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_23",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_23",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_25",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_25",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_26",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_26",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_saxon_cloak_pattern_27",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_27",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "round_shield_leather_iron",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_21",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_22",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_axe_23",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_41",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_42",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "throwing_dagger_43",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "munin_axe",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "hugin_axe",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_29",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking56",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon01",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon02",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon03",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon04",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon05",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon06",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon07",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon08",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon09",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon10",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon11",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon12",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon13",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon14",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon15",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon16",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon17",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon18",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon19",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon20",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon21",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon22",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon23",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon24",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon25",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon26",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon27",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon28",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon29",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon30",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon31",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon32",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon33",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon34",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon35",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon36",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon37",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon38",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon39",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon40",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon41",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon42",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon43",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon44",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon45",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon46",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon47",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon48",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 26250
		},
		unlocks = {
			{
				name = "sword_kit_sword_05_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_05",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_05_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 27560
		},
		unlocks = {
			{
				name = "saxon_beard_12",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_23",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_09",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_leather_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_03",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_viking_white",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 28940
		},
		unlocks = {
			{
				name = "helmet_saxon_heavy_normal",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_06_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_06",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_06_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 30380
		},
		unlocks = {
			{
				name = "viking_spear_32",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_31",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_33",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 31900
		},
		unlocks = {
			{
				name = "viking_charge_heraldry_viking57",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking58",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon49",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_viking_snakeye_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_jarl",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_51",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_52",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_53",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_42",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_43",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_41",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 33500
		},
		unlocks = {
			{
				name = "saxon_beard_14",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_25",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_29",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "hunting_bow_ornamented",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "longbow_ornamented",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 35170
		},
		unlocks = {
			{
				name = "sword_kit_sword_07",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_07_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_07_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 36930
		},
		unlocks = {
			{
				name = "saxon_beard_08",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_19",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 38780
		},
		unlocks = {
			{
				name = "viking_beard_10",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 40720
		},
		unlocks = {
			{
				name = "long_cloak_saxon_cloak_pattern_29",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_29",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_30",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking59",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking60",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon50",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "snowflake_shield_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "round_shield_leather",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 44790
		},
		unlocks = {
			{
				name = "viking_spear_32",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_31",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_33",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 49270
		},
		unlocks = {
			{
				name = "sword_kit_sword_08_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_08",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_08_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 54200
		},
		unlocks = {
			{
				name = "twohanded_axe_11",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_12",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "twohanded_axe_13",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 59620
		},
		unlocks = {
			{
				name = "helmet_berserk_saxon_04",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_37",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_10",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_21",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 65580
		},
		unlocks = {
			{
				name = "viking_charge_heraldry_viking61",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon51",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 72140
		},
		unlocks = {
			{
				name = "helmet_viking_hood_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_hood_light",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 84410
		},
		unlocks = {
			{
				name = "helmet_mask_of_hel_medium",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_mask_of_hel",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_saxon_heavy_fancy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_shield_maiden_extravagant_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_warrior_maiden_heavy",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 102010
		},
		unlocks = {
			{
				name = "viking_beard_11",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_33",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_35",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_32",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 126020
		},
		unlocks = {
			{
				name = "sword_kit_sword_09",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_09_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_09_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 152270
		},
		unlocks = {
			{
				name = "long_cloak_saxon_cloak_pattern_30",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_30",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_23",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_22",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_axe_21",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_31",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon52",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking62",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 178990
		},
		unlocks = {
			{
				name = "saxon_beard_13",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_24",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 207490
		},
		unlocks = {
			{
				name = "viking_spear_41",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_42",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_spear_43",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 234840
		},
		unlocks = {
			{
				name = "viking_beard_08",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 266230
		},
		unlocks = {
			{
				name = "sword_kit_sword_10_worn",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_10_gold",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "sword_kit_sword_010",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon53",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 290850
		},
		unlocks = {
			{
				name = "long_cloak_saxon_cloak_pattern_31",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_31",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking63",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 325050
		},
		unlocks = {
			{
				name = "helmet_berserk_saxon_05",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_viking_black",
				category = "helmet",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_34",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_36",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 370700
		},
		unlocks = {
			{
				name = "saxon_charge_heraldry_saxon54",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_07",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_38",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 412600
		},
		unlocks = {
			{
				name = "ulfberht_sword",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = 466200
		},
		unlocks = {
			{
				name = "viking_beard_04",
				category = "beard",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	},
	{
		xp = {
			span = math.huge
		},
		unlocks = {
			{
				name = "long_cloak_saxon_cloak_pattern_32",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "long_cloak_viking_cloak_pattern_32",
				category = "cloak_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_berserk_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserk_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_light_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_medium_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_heavy_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_light_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_medium_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_heavy_pattern_32",
				category = "armour_pattern",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_04_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_05_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_06_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_07_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_08_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_09_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_10_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_11_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_12_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_13_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_14_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_34_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_15_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_16_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_17_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_18_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_19_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_20_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_21_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_22_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_23_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_24_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_25_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_36_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_26_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_27_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_28_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_29_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_30_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_31_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_32_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_37_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_38_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_beard_39_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_04_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_05_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_06_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_07_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_08_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_09_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_10_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_11_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_12_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_berserker_beard_01_gray_02",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_beard_berserker_gray",
				category = "beard_color",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "viking_charge_heraldry_viking64",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "saxon_charge_heraldry_saxon55",
				category = "coat_of_arms",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "ulfberht_sword_02",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "broadsword",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "agile_axe",
				category = "gear",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_01_gray",
				category = "helmet_variation",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_02_gray",
				category = "helmet_variation",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_03_gray",
				category = "helmet_variation",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_04_gray",
				category = "helmet_variation",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			},
			{
				name = "helmet_berserk_saxon_05_gray",
				category = "helmet_variation",
				ui_settings = PrizesMedalsUnlocksUISettings.unlock_gear
			}
		}
	}
}

local base = 0

for i = 0, #RANKS do
	local settings = RANKS[i]

	settings.xp.base = base
	base = base + settings.xp.span
end

function xp_to_rank(xp)
	Profiler.start("Ranks.lua xp_to_rank()")

	for i = 0, #RANKS do
		local rank = RANKS[i]

		if xp >= rank.xp.base and xp <= rank.xp.base + rank.xp.span - 1 then
			Profiler.stop()

			return i
		end
	end

	Profiler.stop()

	return 0
end

if Application.build() ~= "release" then
	require("scripts/settings/gear")
	require("scripts/settings/armours")
	require("scripts/settings/helmets")
	require("scripts/settings/perk_settings")

	for rank, props in pairs(RANKS) do
		for _, unlock in pairs(props.unlocks) do
			if unlock.category == "gear" then
				if Gear[unlock.name] == nil then
					Application.warning("Unlockable gear %q doesn't exist", unlock.name)
				end
			elseif unlock.category == "armour" then
				if Armours[unlock.name] == nil then
					Application.warning("Unlockable armour %q doesn't exist", unlock.name)
				end
			elseif unlock.category == "helmet" then
				if Helmets[unlock.name] == nil then
					Application.warning("Unlockable helmet %q doesn't exist", unlock.name)
				end
			elseif unlock.category == "perk" then
				if Perks[unlock.name] == nil then
					Application.warning("Unlockable perk %q doesn't exist", unlock.name)
				end
			else
				fassert("Undefined unlock category %q", unlock.category)
			end
		end
	end
end

function default_rank_unlocks(current_rank)
	local default_unlocks = {}

	for i = 0, current_rank do
		for _, unlock in pairs(RANKS[i].unlocks) do
			if Managers.persistence:is_unlock_owned(unlock) then
				default_unlocks[unlock.category .. "|" .. unlock.name] = unlock
			end
		end
	end

	return default_unlocks
end

Ranks = class(Ranks)

function Ranks:init(stats_collection)
	self._stats = stats_collection
end

function Ranks:register_player(player)
	local network_id = player:network_id()
	local current_rank = self._stats:get(network_id, "rank")

	for rank, props in pairs(RANKS) do
		if current_rank < rank then
			local function condition(value, comp_value)
				local current_xp = self._stats:get(network_id, "experience")
				local xp = value + current_xp

				return xp >= comp_value.base and xp <= comp_value.base + comp_value.span - 1
			end

			local callback = callback(self, "_cb_ranked_up", player, rank)

			self._stats:register_callback(network_id, "experience_round", condition, props.xp, callback)
		end
	end
end

function Ranks:_cb_ranked_up(player, rank)
	if Managers.state.network:game() and Managers.state.team:stats_requirement_fulfilled() and rank > self._stats:get(player:network_id(), "rank") then
		printf("%q has reached rank %d", player:network_id(), rank)

		local unlocks = RANKS[rank].unlocks

		Managers.persistence:process_unlocks(player.backend_profile_id, unlocks)
		Managers.persistence:save_partial_player_progress(player)
		self._stats:set(player:network_id(), "rank", rank)
		RPC.rpc_rank_up(player:network_id(), player.game_object_id, rank)
	end
end
