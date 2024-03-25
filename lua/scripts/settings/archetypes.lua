-- chunkname: @scripts/settings/archetypes.lua

ArchetypeList = {
	"light",
	"medium",
	"heavy",
	"shield_maiden",
	"berserk"
}

require("scripts/settings/gear")
require("scripts/settings/helmets")
require("scripts/settings/armours")
require("scripts/settings/cloaks")
require("scripts/settings/heads")
require("scripts/settings/perk_settings")
require("scripts/settings/player_movement_settings")

Archetypes = {}
Archetypes.light = Archetypes.light or {}
Archetypes.light.name = "archetype_light"
Archetypes.light.release_name = "main"
Archetypes.light.cosmetics = Archetypes.light.cosmetics or {
	red = {},
	white = {}
}
Archetypes.light.cosmetics.red.helmet_names = {
	"helmet_viking_hawk_light",
	"helmet_viking_hood_light",
	"helmet_viking_basic_light",
	"helmet_viking_checker_light",
	"yogscast_helmet_viking",
	"dev_helmet"
}
Archetypes.light.cosmetics.red.armour_names = {
	"armour_viking_padded"
}
Archetypes.light.cosmetics.white.helmet_names = {
	"helmet_saxon_basic_light",
	"helmet_saxon_hood_light",
	"helmet_saxon_cone_light",
	"helmet_saxon_cone_cross_light",
	"helmet_saxon_leather_light",
	"yogscast_helmet_saxon",
	"dev_helmet"
}
Archetypes.light.cosmetics.white.armour_names = {
	"armour_saxon_cloth"
}
Archetypes.light.cosmetics.red.head_names = {
	"viking_1",
	"viking_2",
	"viking_3",
	"viking_4",
	"viking_5",
	"viking_7",
	"viking_8",
	"viking_9",
	"viking_10",
	"viking_11",
	"viking_12",
	"viking_13",
	"viking_14",
	"viking_15",
	"viking_16",
	"viking_17",
	"viking_18"
}
Archetypes.light.cosmetics.white.head_names = {
	"knight",
	"peasant",
	"squire",
	"saxon_5",
	"knight_painted",
	"knight_scarred",
	"knight_bandage",
	"peasant_scarred",
	"peasant_bandage",
	"peasant_painted",
	"squire_scarred",
	"squire_painted",
	"squire_bandage",
	"lady",
	"lady_painted",
	"lady_scarred",
	"lady_eyepatch"
}
Archetypes.light.cosmetics.red.cloak_names = {
	"long_cloak_viking",
	"no_cloak"
}
Archetypes.light.cosmetics.white.cloak_names = {
	"long_cloak_saxon",
	"no_cloak"
}
Archetypes.light.perks = {
	"backstab",
	"blade_master",
	"stamina_on_kill",
	"dodge_attack",
	"throw_all_weps",
	"heal_on_kill",
	"chase_faster",
	"dodge_block",
	"empty",
	"bow_zoom",
	"flaming_arrows",
	"heal_on_taunt",
	"faster_melee_charge",
	"training_wheels",
	"no_knockdown",
	"tag_on_bow_shot",
	"piercing_shots",
	"faster_bow_charge",
	"fake_death",
	"revive_yourself"
}
Archetypes.light.taunts = {
	"applause",
	"bow",
	"charge",
	"cheer",
	"cheers_drink",
	"cut_throat",
	"praise_god",
	"riverdance",
	"slowclap",
	"techno_viking",
	"the_what",
	"two_finger_salute",
	"warcry",
	"wolfhowl"
}
Archetypes.light.locked_perks = {
	perk_1 = true,
	perk_3 = false,
	perk_2 = true,
	perk_4 = false
}
Archetypes.light.weapon_category_names = {
	"spears",
	"one_handed_swords",
	"one_handed_axes",
	"bows"
}
Archetypes.light.gear = {
	primary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe",
			"spear",
			"bow"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		},
		spear = {
			Gear.viking_spear_11,
			Gear.viking_spear_12,
			Gear.viking_spear_13,
			Gear.viking_spear_21,
			Gear.viking_spear_22,
			Gear.viking_spear_23,
			Gear.viking_spear_31,
			Gear.viking_spear_32,
			Gear.viking_spear_33,
			Gear.viking_spear_41,
			Gear.viking_spear_42,
			Gear.viking_spear_43
		},
		bow = {
			Gear.hunting_bow,
			Gear.hunting_bow_rough,
			Gear.hunting_bow_ornamented,
			Gear.longbow,
			Gear.longbow_rough,
			Gear.longbow_ornamented
		}
	},
	secondary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		}
	},
	shield = {
		Gear.round_shield_worn,
		Gear.round_shield,
		Gear.round_shield_leather_iron,
		Gear.round_shield_leather
	}
}
Archetypes.light.movement_settings = PlayerUnitMovementSettings
Archetypes.light.voice = "light"
Archetypes.medium = Archetypes.medium or {}
Archetypes.medium.name = "archetype_medium"
Archetypes.medium.release_name = "main"
Archetypes.medium.cosmetics = Archetypes.medium.cosmetics or {
	red = {},
	white = {}
}
Archetypes.medium.cosmetics.red.helmet_names = {
	"helmet_vendel_1",
	"helmet_viking_hawk_medium",
	"helmet_viking_valhalla",
	"helmet_viking_basic_medium",
	"helmet_viking_basic_medium_early_access",
	"yogscast_helmet_viking",
	"helmet_mask_of_hel_medium",
	"helmet_mask_of_hel_hood_medium",
	"helmet_viking_hird",
	"dev_helmet"
}
Archetypes.medium.cosmetics.red.armour_names = {
	"armour_viking_scalemail"
}
Archetypes.medium.cosmetics.red.head_names = {
	"viking_1",
	"viking_2",
	"viking_3",
	"viking_4",
	"viking_5",
	"viking_7",
	"viking_8",
	"viking_9",
	"viking_10",
	"viking_11",
	"viking_12",
	"viking_13",
	"viking_14",
	"viking_15",
	"viking_16",
	"viking_17",
	"viking_18"
}
Archetypes.medium.cosmetics.white.head_names = {
	"knight",
	"peasant",
	"squire",
	"saxon_5",
	"knight_painted",
	"knight_scarred",
	"knight_bandage",
	"peasant_scarred",
	"peasant_bandage",
	"peasant_painted",
	"squire_scarred",
	"squire_painted",
	"squire_bandage",
	"lady",
	"lady_painted",
	"lady_scarred",
	"lady_eyepatch"
}
Archetypes.medium.cosmetics.white.helmet_names = {
	"helmet_sutton_hoo_medium",
	"helmet_saxon_basic_medium",
	"helmet_saxon_basic_medium_early_access",
	"helmet_saxon_jarl",
	"yogscast_helmet_saxon",
	"helmet_saxon_aide",
	"dev_helmet"
}
Archetypes.medium.cosmetics.white.armour_names = {
	"armour_saxon_chainmail_shirt"
}
Archetypes.medium.cosmetics.red.cloak_names = {
	"long_cloak_viking",
	"no_cloak"
}
Archetypes.medium.cosmetics.white.cloak_names = {
	"long_cloak_saxon",
	"no_cloak"
}
Archetypes.medium.perk_names = {}
Archetypes.medium.perks = {
	"backstab",
	"blade_master",
	"stamina_on_kill",
	"dodge_attack",
	"throw_all_weps",
	"heal_on_kill",
	"chase_faster",
	"dodge_block",
	"empty",
	"bow_zoom",
	"flaming_arrows",
	"heal_on_taunt",
	"faster_melee_charge",
	"training_wheels",
	"no_knockdown",
	"tag_on_bow_shot",
	"piercing_shots",
	"faster_bow_charge",
	"fake_death",
	"revive_yourself"
}
Archetypes.medium.taunts = {
	"applause",
	"bow",
	"charge",
	"cheer",
	"cheers_drink",
	"cut_throat",
	"praise_god",
	"riverdance",
	"slowclap",
	"techno_viking",
	"the_what",
	"two_finger_salute",
	"warcry",
	"wolfhowl"
}
Archetypes.medium.locked_perks = {
	perk_1 = true,
	perk_3 = false,
	perk_2 = false,
	perk_4 = false
}
Archetypes.medium.gear = {
	primary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe",
			"two_handed_axe",
			"throwing_weapon",
			"spear",
			"bow"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		},
		two_handed_axe = {
			Gear.twohanded_axe_11,
			Gear.twohanded_axe_12,
			Gear.twohanded_axe_13,
			Gear.twohanded_axe_21,
			Gear.twohanded_axe_22,
			Gear.twohanded_axe_23,
			Gear.twohanded_axe_31,
			Gear.twohanded_axe_32,
			Gear.twohanded_axe_33,
			Gear.twohanded_axe_41,
			Gear.twohanded_axe_42,
			Gear.twohanded_axe_43,
			Gear.twohanded_axe_51,
			Gear.twohanded_axe_52,
			Gear.twohanded_axe_53
		},
		spear = {
			Gear.viking_spear_11,
			Gear.viking_spear_12,
			Gear.viking_spear_13,
			Gear.viking_spear_21,
			Gear.viking_spear_22,
			Gear.viking_spear_23,
			Gear.viking_spear_31,
			Gear.viking_spear_32,
			Gear.viking_spear_33,
			Gear.viking_spear_41,
			Gear.viking_spear_42,
			Gear.viking_spear_43
		},
		throwing_weapon = {
			Gear.throwing_spear,
			Gear.throwing_dagger_11,
			Gear.throwing_dagger_12,
			Gear.throwing_dagger_13,
			Gear.throwing_dagger_41,
			Gear.throwing_dagger_42,
			Gear.throwing_dagger_43,
			Gear.throwing_axe_21,
			Gear.throwing_axe_22,
			Gear.throwing_axe_23,
			Gear.throwing_axe_31,
			Gear.throwing_axe_32,
			Gear.throwing_axe_33,
			Gear.mjolnir
		},
		bow = {
			Gear.hunting_bow,
			Gear.hunting_bow_rough,
			Gear.hunting_bow_ornamented
		}
	},
	secondary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe",
			"two_handed_axe",
			"throwing_weapon",
			"spear",
			"bow"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		},
		throwing_weapon = {
			Gear.throwing_spear,
			Gear.throwing_dagger_11,
			Gear.throwing_dagger_12,
			Gear.throwing_dagger_13,
			Gear.throwing_dagger_41,
			Gear.throwing_dagger_42,
			Gear.throwing_dagger_43,
			Gear.throwing_axe_21,
			Gear.throwing_axe_22,
			Gear.throwing_axe_23,
			Gear.throwing_axe_31,
			Gear.throwing_axe_32,
			Gear.throwing_axe_33,
			Gear.mjolnir
		},
		two_handed_axe = {
			Gear.twohanded_axe_11,
			Gear.twohanded_axe_12,
			Gear.twohanded_axe_13,
			Gear.twohanded_axe_21,
			Gear.twohanded_axe_22,
			Gear.twohanded_axe_23,
			Gear.twohanded_axe_31,
			Gear.twohanded_axe_32,
			Gear.twohanded_axe_33,
			Gear.twohanded_axe_41,
			Gear.twohanded_axe_42,
			Gear.twohanded_axe_43,
			Gear.twohanded_axe_51,
			Gear.twohanded_axe_52,
			Gear.twohanded_axe_53
		},
		spear = {
			Gear.viking_spear_11,
			Gear.viking_spear_12,
			Gear.viking_spear_13,
			Gear.viking_spear_21,
			Gear.viking_spear_22,
			Gear.viking_spear_23,
			Gear.viking_spear_31,
			Gear.viking_spear_32,
			Gear.viking_spear_33,
			Gear.viking_spear_41,
			Gear.viking_spear_42,
			Gear.viking_spear_43
		},
		bow = {
			Gear.hunting_bow,
			Gear.hunting_bow_rough,
			Gear.hunting_bow_ornamented
		}
	},
	shield = {
		Gear.round_shield_worn,
		Gear.round_shield,
		Gear.round_shield_leather_iron,
		Gear.round_shield_leather
	}
}
Archetypes.medium.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.medium.movement_settings = PlayerUnitMovementSettings
Archetypes.medium.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.medium.voice = "medium"
Archetypes.heavy = Archetypes.heavy or {}
Archetypes.heavy.name = "archetype_heavy"
Archetypes.heavy.cosmetics = Archetypes.heavy.cosmetics or {
	red = {},
	white = {}
}
Archetypes.heavy.release_name = "main"
Archetypes.heavy.cosmetics.red.helmet_names = {
	"helmet_vendel_heavy",
	"helmet_viking_basic_heavy",
	"helmet_viking_basic_heavy_leather",
	"helmet_mask_of_hel",
	"helmet_mask_of_hel_hood",
	"helmet_viking_snakeye_heavy",
	"yogscast_helmet_viking",
	"dev_helmet"
}
Archetypes.heavy.cosmetics.red.armour_names = {
	"armour_viking_chainmail"
}
Archetypes.heavy.cosmetics.white.helmet_names = {
	"helmet_sutton_hoo_heavy",
	"helmet_saxon_basic_heavy",
	"helmet_saxon_heavy_worn",
	"helmet_saxon_heavy_normal",
	"helmet_saxon_heavy_fancy",
	"yogscast_helmet_saxon",
	"dev_helmet"
}
Archetypes.heavy.cosmetics.white.armour_names = {
	"armour_saxon_chainmail"
}
Archetypes.heavy.cosmetics.red.head_names = {
	"viking_1",
	"viking_2",
	"viking_3",
	"viking_4",
	"viking_5",
	"viking_7",
	"viking_8",
	"viking_9",
	"viking_10",
	"viking_11",
	"viking_12",
	"viking_13",
	"viking_14",
	"viking_15",
	"viking_16",
	"viking_17",
	"viking_18"
}
Archetypes.heavy.cosmetics.white.head_names = {
	"knight",
	"peasant",
	"squire",
	"knight_painted",
	"knight_scarred",
	"knight_bandage",
	"peasant_scarred",
	"peasant_bandage",
	"peasant_painted",
	"squire_scarred",
	"squire_painted",
	"squire_bandage",
	"lady",
	"lady_painted",
	"lady_scarred",
	"lady_eyepatch",
	"saxon_6"
}
Archetypes.heavy.cosmetics.red.cloak_names = {
	"long_cloak_viking",
	"no_cloak"
}
Archetypes.heavy.cosmetics.white.cloak_names = {
	"long_cloak_saxon",
	"no_cloak"
}
Archetypes.heavy.perk_names = {}
Archetypes.heavy.perks = {
	"backstab",
	"blade_master",
	"stamina_on_kill",
	"dodge_attack",
	"throw_all_weps",
	"heal_on_kill",
	"chase_faster",
	"dodge_block",
	"empty",
	"heal_on_taunt",
	"faster_melee_charge",
	"training_wheels",
	"no_knockdown",
	"fake_death",
	"revive_yourself"
}
Archetypes.heavy.taunts = {
	"applause",
	"bow",
	"charge",
	"cheer",
	"cheers_drink",
	"cut_throat",
	"praise_god",
	"riverdance",
	"slowclap",
	"techno_viking",
	"the_what",
	"two_finger_salute",
	"warcry",
	"wolfhowl"
}
Archetypes.heavy.locked_perks = {
	perk_1 = true,
	perk_3 = false,
	perk_2 = true,
	perk_4 = false
}
Archetypes.heavy.gear = {
	primary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe",
			"two_handed_axe",
			"spear"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		},
		two_handed_axe = {
			Gear.twohanded_axe_11,
			Gear.twohanded_axe_12,
			Gear.twohanded_axe_13,
			Gear.twohanded_axe_21,
			Gear.twohanded_axe_22,
			Gear.twohanded_axe_23,
			Gear.twohanded_axe_31,
			Gear.twohanded_axe_32,
			Gear.twohanded_axe_33,
			Gear.twohanded_axe_41,
			Gear.twohanded_axe_42,
			Gear.twohanded_axe_43,
			Gear.twohanded_axe_51,
			Gear.twohanded_axe_52,
			Gear.twohanded_axe_53
		},
		spear = {
			Gear.viking_spear_11,
			Gear.viking_spear_12,
			Gear.viking_spear_13,
			Gear.viking_spear_21,
			Gear.viking_spear_22,
			Gear.viking_spear_23,
			Gear.viking_spear_31,
			Gear.viking_spear_32,
			Gear.viking_spear_33,
			Gear.viking_spear_41,
			Gear.viking_spear_42,
			Gear.viking_spear_43
		}
	},
	secondary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe",
			"throwing_weapon"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.viking_axe_test
		},
		throwing_weapon = {
			Gear.throwing_spear,
			Gear.throwing_dagger_11,
			Gear.throwing_dagger_12,
			Gear.throwing_dagger_13,
			Gear.throwing_dagger_41,
			Gear.throwing_dagger_42,
			Gear.throwing_dagger_43,
			Gear.throwing_axe_21,
			Gear.throwing_axe_22,
			Gear.throwing_axe_23,
			Gear.throwing_axe_31,
			Gear.throwing_axe_32,
			Gear.throwing_axe_33,
			Gear.mjolnir
		}
	},
	shield = {
		Gear.round_shield_worn,
		Gear.round_shield,
		Gear.round_shield_leather_iron,
		Gear.round_shield_leather
	}
}
Archetypes.heavy.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.heavy.movement_settings = HeavyMovementSettings
Archetypes.heavy.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.heavy.voice = "heavy"
Archetypes.shield_maiden = Archetypes.shield_maiden or {}
Archetypes.shield_maiden.name = "archetype_shield_maiden"
Archetypes.shield_maiden.release_name = "vanguard"
Archetypes.shield_maiden.required_dlc = "vanguard"
Archetypes.shield_maiden.cosmetics = Archetypes.shield_maiden.cosmetics or {
	red = {},
	white = {}
}
Archetypes.shield_maiden.cosmetics.red.helmet_names = {
	"helmet_shield_maiden_ornamented_heavy",
	"helmet_shield_maiden_extravagant_heavy"
}
Archetypes.shield_maiden.cosmetics.red.armour_names = {
	"armour_viking_shieldmaiden"
}
Archetypes.shield_maiden.cosmetics.white.helmet_names = {
	"helmet_warrior_maiden_heavy",
	"helmet_warrior_maiden_02_heavy"
}
Archetypes.shield_maiden.cosmetics.white.armour_names = {
	"armour_saxon_warrior_maiden"
}
Archetypes.shield_maiden.cosmetics.red.head_names = {
	"viking_5"
}
Archetypes.shield_maiden.cosmetics.white.head_names = {
	"saxon_5"
}
Archetypes.shield_maiden.cosmetics.red.cloak_names = {
	"long_cloak_viking",
	"no_cloak"
}
Archetypes.shield_maiden.cosmetics.white.cloak_names = {
	"long_cloak_saxon",
	"no_cloak"
}
Archetypes.shield_maiden.perk_names = {}
Archetypes.shield_maiden.perks = {
	"backstab",
	"blade_master",
	"stamina_on_kill",
	"dodge_attack",
	"throw_all_weps",
	"heal_on_kill",
	"chase_faster",
	"dodge_block",
	"empty",
	"heal_on_taunt",
	"faster_melee_charge",
	"training_wheels",
	"no_knockdown",
	"fake_death",
	"revive_yourself"
}
Archetypes.shield_maiden.taunts = {
	"applause",
	"bow",
	"charge",
	"cheer",
	"cheers_drink",
	"cut_throat",
	"praise_god",
	"riverdance",
	"slowclap",
	"techno_viking",
	"the_what",
	"two_finger_salute",
	"warcry",
	"wolfhowl"
}
Archetypes.shield_maiden.locked_perks = {
	perk_1 = true,
	perk_3 = false,
	perk_2 = true,
	perk_4 = false
}
Archetypes.shield_maiden.gear = {
	primary = {
		categories = {
			"one_handed_sword",
			"spear"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		spear = {
			Gear.shield_maiden_spear,
			Gear.warrior_maiden_spear,
			Gear.viking_spear_11,
			Gear.viking_spear_12,
			Gear.viking_spear_13,
			Gear.viking_spear_21,
			Gear.viking_spear_22,
			Gear.viking_spear_23,
			Gear.viking_spear_31,
			Gear.viking_spear_32,
			Gear.viking_spear_33,
			Gear.viking_spear_41,
			Gear.viking_spear_42,
			Gear.viking_spear_43
		}
	},
	secondary = {
		categories = {
			"one_handed_sword",
			"throwing_weapon"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		throwing_weapon = {
			Gear.throwing_spear,
			Gear.throwing_dagger_11,
			Gear.throwing_dagger_12,
			Gear.throwing_dagger_13,
			Gear.throwing_dagger_41,
			Gear.throwing_dagger_42,
			Gear.throwing_dagger_43,
			Gear.throwing_axe_21,
			Gear.throwing_axe_22,
			Gear.throwing_axe_23,
			Gear.throwing_axe_31,
			Gear.throwing_axe_32,
			Gear.throwing_axe_33,
			Gear.mjolnir
		}
	},
	shield = {
		Gear.round_shield_worn,
		Gear.round_shield,
		Gear.round_shield_leather_iron,
		Gear.round_shield_leather,
		Gear.snowflake_shield,
		Gear.snowflake_shield_gold
	}
}
Archetypes.shield_maiden.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.shield_maiden.movement_settings = PlayerUnitMovementSettings
Archetypes.shield_maiden.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.shield_maiden.voice = "female"
Archetypes.berserk = Archetypes.berserk or {}
Archetypes.berserk.name = "archetype_berserk"
Archetypes.berserk.cosmetics = Archetypes.berserk.cosmetics or {
	red = {},
	white = {}
}
Archetypes.berserk.release_name = "berserk"
Archetypes.berserk.required_dlc = "berserk"
Archetypes.berserk.cosmetics.red.helmet_names = {
	"helmet_berserk_bareheaded_viking",
	"helmet_berserk_viking_brown",
	"helmet_berserk_viking_white",
	"helmet_berserk_viking_black"
}
Archetypes.berserk.cosmetics.red.armour_names = {
	"armour_viking_berserk"
}
Archetypes.berserk.cosmetics.white.helmet_names = {
	"helmet_berserk_bareheaded_saxon",
	"helmet_berserk_saxon_01",
	"helmet_berserk_saxon_02",
	"helmet_berserk_saxon_03",
	"helmet_berserk_saxon_04",
	"helmet_berserk_saxon_05"
}
Archetypes.berserk.cosmetics.white.armour_names = {
	"armour_viking_berserk"
}
Archetypes.berserk.cosmetics.red.head_names = {
	"viking_6"
}
Archetypes.berserk.cosmetics.white.head_names = {
	"saxon_berserk"
}
Archetypes.berserk.cosmetics.red.cloak_names = {
	"long_cloak_viking",
	"no_cloak"
}
Archetypes.berserk.cosmetics.white.cloak_names = {
	"long_cloak_saxon",
	"no_cloak"
}
Archetypes.berserk.perk_names = {}
Archetypes.berserk.perks = {
	"backstab",
	"stamina_on_kill",
	"dodge_attack",
	"heal_on_kill",
	"chase_faster",
	"empty",
	"heal_on_taunt",
	"no_knockdown",
	"fake_death",
	"revive_yourself"
}
Archetypes.berserk.taunts = {
	"applause",
	"bow",
	"charge",
	"cheer",
	"cheers_drink",
	"cut_throat",
	"praise_god",
	"riverdance",
	"slowclap",
	"techno_viking",
	"the_what",
	"two_finger_salute",
	"warcry",
	"wolfhowl"
}
Archetypes.berserk.locked_perks = {
	perk_1 = true,
	perk_3 = false,
	perk_2 = true,
	perk_4 = false
}
Archetypes.berserk.gear = {
	primary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.munin_axe,
			Gear.hugin_axe,
			Gear.viking_axe_test
		}
	},
	secondary = {
		categories = {
			"one_handed_sword",
			"one_handed_axe"
		},
		one_handed_sword = {
			Gear.sword_kit_sword_01_worn,
			Gear.sword_kit_sword_02_worn,
			Gear.sword_kit_sword_03_worn,
			Gear.sword_kit_sword_04_worn,
			Gear.sword_kit_sword_05_worn,
			Gear.sword_kit_sword_06_worn,
			Gear.sword_kit_sword_07_worn,
			Gear.sword_kit_sword_08_worn,
			Gear.sword_kit_sword_09_worn,
			Gear.sword_kit_sword_10_worn,
			Gear.sword_kit_sword_01,
			Gear.sword_kit_sword_02,
			Gear.sword_kit_sword_03,
			Gear.sword_kit_sword_04,
			Gear.sword_kit_sword_05,
			Gear.sword_kit_sword_06,
			Gear.sword_kit_sword_07,
			Gear.sword_kit_sword_08,
			Gear.sword_kit_sword_09,
			Gear.sword_kit_sword_010,
			Gear.sword_kit_sword_01_gold,
			Gear.sword_kit_sword_02_gold,
			Gear.sword_kit_sword_03_gold,
			Gear.sword_kit_sword_04_gold,
			Gear.sword_kit_sword_05_gold,
			Gear.sword_kit_sword_06_gold,
			Gear.sword_kit_sword_07_gold,
			Gear.sword_kit_sword_08_gold,
			Gear.sword_kit_sword_09_gold,
			Gear.sword_kit_sword_10_gold,
			Gear.ulfberht_sword,
			Gear.ulfberht_sword_02,
			Gear.broadsword
		},
		one_handed_axe = {
			Gear.viking_axe_11,
			Gear.viking_axe_12,
			Gear.viking_axe_13,
			Gear.viking_axe_21,
			Gear.viking_axe_22,
			Gear.viking_axe_23,
			Gear.viking_axe_31,
			Gear.viking_axe_32,
			Gear.viking_axe_33,
			Gear.viking_axe_41,
			Gear.viking_axe_42,
			Gear.viking_axe_43,
			Gear.viking_axe_51,
			Gear.viking_axe_52,
			Gear.viking_axe_53,
			Gear.agile_axe,
			Gear.munin_axe,
			Gear.hugin_axe,
			Gear.viking_axe_test
		}
	}
}
Archetypes.berserk.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.berserk.movement_settings = BerserkMovementSettings
Archetypes.berserk.weapon_category_names = table.clone(Archetypes.light.weapon_category_names)
Archetypes.berserk.voice = "heavy"

for name, archetype in pairs(Archetypes) do
	archetype.archetype_id = name
end
