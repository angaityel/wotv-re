-- chunkname: @scripts/settings/ai_profiles.lua

AIProfiles = {
	debug_ai_profile = {
		display_name = "Militia",
		head = "peasant",
		armour = "armour_light_viking_padded",
		armour_attachments = {
			patterns = 3
		},
		perks = {
			movement_basic = "infantry",
			officer_basic = "officer_training",
			offensive_basic = "man_at_arms",
			defensive_basic = "armour_training"
		},
		wielded_gear = {
			{
				name = "peasant_polearm"
			}
		},
		gear = {
			{
				name = "peasant_polearm",
				attachments = {
					fighting_style = {
						"english_style"
					},
					wooden_shaft = {
						"standard"
					},
					edge_grind = {
						"flat"
					},
					head = {
						"steel"
					}
				}
			},
			{
				name = "mace",
				attachments = {
					fighting_style = {
						"english_style"
					},
					wooden_shaft = {
						"standard"
					},
					head = {
						"steel"
					}
				}
			},
			{
				name = "pointed_stick",
				attachments = {
					fighting_style = {
						"english_style"
					}
				}
			}
		},
		helmet = {
			name = "helmet_light_peasant_cap",
			attachments = {}
		},
		perception = {
			filter = "ai_player_scan",
			radius = 20
		},
		brain = {
			behaviours = {
				{
					avoidance = "default_avoidance"
				},
				{
					targeting = "default_targeting"
				},
				{
					pathing = "default_pathing"
				},
				{
					morale_manager = "nil_tree"
				},
				{
					main = "ranged"
				}
			}
		},
		morale = {
			times = {
				max = 10,
				min = 5
			},
			states = {
				active = {
					value = 100,
					state_percents = {
						80,
						19,
						1
					}
				},
				passive = {
					value = 50,
					state_percents = {
						35,
						60,
						5
					}
				},
				panic = {
					value = 15,
					state_percents = {
						20,
						70,
						10
					}
				}
			}
		},
		properties = {
			tethered = false,
			tether_time = 5,
			difficulty = AIProperties.difficulty.medium
		}
	},
	torsten = {
		head = "viking_1",
		display_name = "Militia",
		archetype = "medium",
		voice = "medium_viking",
		armour = "armour_viking_scalemail",
		armour_attachments = {
			patterns = 1
		},
		head_attachments = {},
		perks = {},
		gear = {
			primary = {
				wielded = true,
				name = "sword_kit_sword_01"
			},
			dagger = {
				name = "viking_dagger"
			},
			shield = {
				name = "round_shield"
			}
		},
		helmet = {
			name = "helmet_vendel_1",
			attachments = {
				pattern = "pattern_standard"
			}
		},
		perception = {
			filter = "ai_player_scan",
			radius = 100
		},
		brain = {
			behaviours = {
				{
					avoidance = "default_avoidance"
				},
				{
					targeting = "default_targeting"
				},
				{
					morale_manager = "nil_tree"
				},
				{
					main = "torsten_idle"
				}
			}
		},
		properties = {
			tethered = false,
			tether_time = 5,
			difficulty = AIProperties.difficulty.impossible
		}
	}
}

require("scripts/settings/profiling_profiles")
