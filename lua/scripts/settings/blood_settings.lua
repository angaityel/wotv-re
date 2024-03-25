-- chunkname: @scripts/settings/blood_settings.lua

BloodSettings = {
	max_num_decals = 30,
	fighting_blood = {
		kill = 0.1,
		instakill = 0.1,
		enabled = true,
		threshold_hack = 0.9,
		hit = 0.05,
		weapon_blood = {
			kill = 0.1,
			instakill = 0.1,
			enabled = true,
			weapon_threshold_hack = 0.53,
			hit = 0.05
		}
	},
	environment_blood = {
		blood_speed_multiplier = 10,
		distance_fade_threshold = 25,
		enabled = true,
		base_scale = 1,
		angular_threshold = 0.68,
		life_time = 30,
		dynamic_scale = 0,
		distance_spawn_threshold = 20
	},
	finish_off_blood = {
		dynamic_scale = 2,
		distance_fade_threshold = 25,
		enabled = true,
		base_scale = 1,
		life_time = 10,
		distance_spawn_threshold = 20
	},
	limb_blood = {
		dynamic_scale = 0,
		enabled = false,
		base_scale = 1
	},
	wounds = {
		enabled = true
	},
	blood_zones = {
		left_leg = {
			bit_value = "0x00000001",
			actors = {
				"c_leftfoot",
				"c_leftleg",
				"c_leftupleg"
			}
		},
		right_leg = {
			bit_value = "0x00000010",
			actors = {
				"c_rightfoot",
				"c_rightleg",
				"c_rightupleg"
			}
		},
		back = {
			bit_value = "0x00001100",
			actors = {
				"c_spine",
				"c_spine1",
				"c_spine2",
				"c_hips"
			}
		},
		arms = {
			bit_value = "0x00010000",
			actors = {
				"c_lefthand",
				"c_leftforearm",
				"c_leftarm",
				"c_righthand",
				"c_rightforearm",
				"c_rightarm"
			}
		}
	}
}
