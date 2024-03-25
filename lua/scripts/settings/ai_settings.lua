-- chunkname: @scripts/settings/ai_settings.lua

AISettings = {
	locomotion = {
		walk_threshold = 0.57,
		rotation_speed = 15,
		aim_speed = 8,
		run_threshold = 7.14,
		jog_threshold = 5.23
	},
	steering = {
		arrive_threshold_far = 3,
		arrive_time = 2,
		avoid_force_multiplier = 1.5,
		arrive_threshold = 1,
		avoid_force_threshold = 0.1
	},
	navigation = {
		renavigate_threshold = 0.1,
		search_focus = 1.25
	},
	behaviour = {
		height_avoid_distance = 2
	},
	group = {
		locomotion = {
			min_speed = 1,
			max_speed = 3.23,
			rotation_speed = 4
		},
		formation = {
			block = {
				default_rank_distance = 1.8,
				default_file_distance = 1.8
			},
			staggered = {
				default_rank_distance = 1.8,
				default_file_distance = 1.8
			}
		}
	},
	weapon_distance = {
		medium_one_handed_sword = 1.2,
		throwing_dagger = 1.2,
		main_one_handed_club = 1.2,
		longbow = 15,
		main_throwing_spear = 1.2,
		medium_one_handed_axe = 1.2,
		two_handed_weapon = 1.5,
		medium_two_handed_sword = 1.5,
		main_one_handed_axe = 1.2,
		medium_throwing_axe = 1.2,
		one_handed_sword = 1.2,
		one_handed_axe = 1.2,
		medium_two_handed_axe = 1.5,
		one_handed_club = 1.2,
		polearm = 1.7,
		two_handed_club = 1.5,
		two_handed_sword = 1.5,
		main_one_handed_sword = 1.2,
		medium_longbow = 15,
		medium_spear = 1.7,
		medium_hunting_bow = 15,
		medium_short_bow = 15,
		dagger = 1,
		lance = 1.2,
		hunting_bow = 15,
		shield = 1.2,
		medium_throwing_spear = 1.2,
		dual_wield = 1.2,
		throwing_axe = 1.2,
		crossbow = 15,
		spear = 1.7,
		medium_throwing_dagger = 1.2,
		throwing_spear = 1.2,
		short_bow = 15,
		two_handed_axe = 1.5,
		handgonne = 10
	}
}
AIProperties = {
	difficulty = {
		easy = {
			charge_time_max = 2,
			ranged_attack_cooldown = 15,
			max_horizontal_spread = 5,
			charge_time_min = 1,
			max_vertical_spread = 5,
			block_chance = 0.4,
			accuracy = 0.6
		},
		medium = {
			charge_time_max = 1,
			ranged_attack_cooldown = 10,
			max_horizontal_spread = 1,
			charge_time_min = 0.5,
			max_vertical_spread = 3,
			block_chance = 0.7,
			accuracy = 0.9
		},
		hard = {
			charge_time_max = 1,
			ranged_attack_cooldown = 8,
			max_horizontal_spread = 0.75,
			charge_time_min = 0.5,
			max_vertical_spread = 0.75,
			block_chance = 0.85,
			accuracy = 0.95
		},
		impossible = {
			charge_time_max = 1,
			ranged_attack_cooldown = 8,
			max_horizontal_spread = 0.75,
			charge_time_min = 0.5,
			max_vertical_spread = 0.75,
			block_chance = 1,
			accuracy = 1
		}
	}
}
