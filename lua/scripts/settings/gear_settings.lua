-- chunkname: @scripts/settings/gear_settings.lua

require("scripts/settings/ai_settings")

GearTypes = {
	throwing_spear = {
		wield_main_body_state = "to_javelin",
		grants_shield = false,
		allows_shield = true,
		cd_wield_main_body_state = "cd_throwing_spear"
	},
	throwing_dagger = {
		wield_main_body_state = "to_dagger",
		grants_shield = false,
		allows_shield = true,
		cd_wield_main_body_state = "cd_throwing_dagger"
	},
	throwing_axe = {
		wield_main_body_state = "to_1h_axe",
		allows_shield = true,
		cd_wield_main_body_state = "cd_throwing_axe"
	},
	dagger = {
		wield_main_body_state = "to_dagger",
		cd_wield_main_body_state = "cd_dagger"
	},
	one_handed_sword = {
		grants_shield = true,
		wield_main_body_state = "to_1h_sword",
		cd_wield_main_body_state = "cd_1h_sword",
		allows_shield = true,
		dual_wielding = {
			primary = {
				wield_main_body_state = "to_dual_wield",
				grants_shield = false,
				allows_shield = false,
				cd_wield_main_body_state = "cd_dual_wield"
			},
			secondary = {}
		}
	},
	one_handed_axe = {
		grants_shield = true,
		wield_main_body_state = "to_1h_axe",
		cd_wield_main_body_state = "cd_1h_axe",
		allows_shield = true,
		dual_wielding = {
			primary = {
				wield_main_body_state = "to_dual_wield",
				grants_shield = false,
				allows_shield = false,
				cd_wield_main_body_state = "cd_dual_wield"
			},
			secondary = {}
		}
	},
	two_handed_axe = {
		wield_main_body_state = "to_2h_axe",
		cd_wield_main_body_state = "cd_2h_axe"
	},
	spear = {
		wield_main_body_state = "to_spear",
		cd_wield_main_body_state = "cd_spear"
	},
	longbow = {
		wield_main_body_state = "to_longbow",
		wield_reload_anim = "bow_reload",
		cd_wield_main_body_state = "cd_longbow"
	},
	hunting_bow = {
		wield_main_body_state = "to_huntingbow",
		wield_reload_anim = "bow_reload",
		cd_wield_main_body_state = "cd_huntingbow"
	},
	short_bow = {
		wield_main_body_state = "to_shortbow",
		wield_reload_anim = "bow_reload",
		cd_wield_main_body_state = "cd_shortbow"
	},
	shield = {
		wield_main_body_state = "to_shield",
		unwield_main_body_state = "to_unshield",
		cd_wield_main_body_state = "cd_shield"
	}
}

for gear_type, _ in pairs(GearTypes) do
	fassert(AISettings.weapon_distance[gear_type], "Missing weapon distance value in AISettings.lua for new gear type %q.", gear_type)
end

GearCategories = {
	two_handed_weapon = {
		bow = {
			ui_description = "gear_category_description_bow",
			ui_texture = "gear_longbow_mockup",
			ui_header = "gear_category_name_bow",
			ui_sort_index = 1
		},
		crossbow = {
			ui_description = "gear_category_description_crossbow",
			ui_texture = "gear_crossbow_mockup",
			ui_header = "gear_category_name_crossbow",
			ui_sort_index = 2
		},
		two_handed_club = {
			ui_description = "gear_category_description_two_handed_club",
			ui_texture = "gear_two_handed_club_mockup",
			ui_header = "gear_category_name_two_handed_club",
			ui_sort_index = 6
		},
		two_handed_sword = {
			ui_description = "gear_category_description_two_handed_sword",
			ui_texture = "gear_sword_2h_mockup",
			ui_header = "gear_category_name_two_handed_sword",
			ui_sort_index = 7
		},
		spear = {
			ui_description = "gear_category_description_spear",
			ui_texture = "gear_spear_mockup",
			ui_header = "gear_category_name_spear",
			ui_sort_index = 8
		},
		none = {
			ui_texture = "gear_none_mockup",
			ui_header = "gear_none",
			ui_sort_index = 9
		}
	},
	dagger = {
		dagger = {
			ui_description = "gear_category_description_dagger",
			ui_texture = "gear_dagger_mockup",
			ui_header = "gear_category_name_dagger",
			ui_sort_index = 1
		}
	},
	shield = {
		large_shield = {
			ui_description = "gear_category_description_large_shield",
			ui_texture = "gear_shield_mockup",
			ui_header = "gear_category_name_large_shield",
			ui_sort_index = 1
		},
		none = {
			ui_texture = "gear_none_mockup",
			ui_header = "gear_none",
			ui_sort_index = 2
		}
	},
	one_handed_weapon = {
		one_handed_sword = {
			ui_description = "gear_category_description_one_handed_sword",
			ui_texture = "gear_sword_1h_mockup",
			ui_header = "gear_category_name_one_handed_sword",
			ui_sort_index = 1
		},
		one_handed_axe = {
			ui_description = "gear_category_description_one_handed_axe",
			ui_texture = "gear_one_handed_axe_mockup",
			ui_header = "gear_category_name_one_handed_axe",
			ui_sort_index = 2
		},
		one_handed_club = {
			ui_description = "gear_category_description_one_handed_club",
			ui_texture = "gear_one_handed_club_mockup",
			ui_header = "gear_category_name_one_handed_club",
			ui_sort_index = 3
		}
	}
}
DamageTypes = {
	blunt = {
		penetration_modifiers = {
			armour_mail = 1,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		},
		absorption_modifiers = {
			armour_mail = 1,
			weapon_metal = 0.3,
			weapon_wood = 0.3,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		}
	},
	piercing = {
		penetration_modifiers = {
			armour_mail = 1,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		},
		absorption_modifiers = {
			armour_mail = 1,
			weapon_metal = 0.3,
			weapon_wood = 0.3,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		}
	},
	cutting = {
		penetration_modifiers = {
			armour_mail = 1,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		},
		absorption_modifiers = {
			armour_mail = 1,
			weapon_metal = 0.3,
			weapon_wood = 0.3,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		}
	},
	slashing = {
		penetration_modifiers = {
			armour_mail = 1,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		},
		absorption_modifiers = {
			armour_mail = 1,
			weapon_metal = 0.3,
			weapon_wood = 0.3,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		}
	},
	piercing_projectile = {
		penetration_modifiers = {
			armour_mail = 1,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1.1,
			none = 1
		},
		absorption_modifiers = {
			armour_mail = 1,
			weapon_metal = 1.75,
			weapon_wood = 1,
			armour_cloth = 1,
			armour_plate = 1,
			armour_leather = 1,
			none = 1
		}
	}
}
PenetrationPropertyMultipliers = {
	blunt = {
		penetration_multipliers = {
			armour_mail = 0.75,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 0.75,
			armour_plate = 0.75,
			armour_leather = 0.75,
			none = 1
		}
	},
	piercing = {
		penetration_multipliers = {
			armour_mail = 0.75,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 0.75,
			armour_plate = 0.75,
			armour_leather = 0.75,
			none = 1
		}
	},
	cutting = {
		penetration_multipliers = {
			armour_mail = 0.75,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 0.75,
			armour_plate = 0.75,
			armour_leather = 0.75,
			none = 1
		}
	},
	slashing = {
		penetration_multipliers = {
			armour_mail = 0.75,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 0.75,
			armour_plate = 0.75,
			armour_leather = 0.75,
			none = 1
		}
	},
	piercing_projectile = {
		penetration_multipliers = {
			armour_mail = 0.75,
			weapon_metal = 1,
			weapon_wood = 1,
			armour_cloth = 0.75,
			armour_plate = 0.75,
			armour_leather = 0.75,
			none = 1
		}
	}
}
DamageLevels = {
	penetrated = {
		medium = 30,
		heavy = 80
	},
	no_damage = {
		heavy = 100
	}
}
BlockTypes = {
	shield = {
		priority = 1
	},
	weapon = {
		priority = 3
	}
}
AttackDamageRangeTypes = {
	melee = {
		friendly_fire_multiplier = 0.5,
		mirrored = true
	},
	small_projectile = {
		friendly_fire_multiplier = 0.25,
		mirrored = true
	}
}
AttackSpeedFunctions = {
	standard_melee = function(t, speed_max)
		local p1 = 0.001
		local p2 = 0.999

		return speed_max
	end,
	high_1h_sword_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.3275
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_1h_sword_melee = function(t, speed_max)
		local p1 = 0.6399999999999999
		local p2 = 0.72

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_1h_sword_melee = function(t, speed_max)
		local p1 = 0.49
		local p2 = 0.635

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_1h_sword_melee = function(t, speed_max)
		local p0 = 0.6
		local p1 = p0 - 0.1
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_1h_club_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.302
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_1h_club_melee = function(t, speed_max)
		local p1 = 0.6599999999999999
		local p2 = 0.72

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_1h_club_melee = function(t, speed_max)
		local p1 = 0.5449999999999999
		local p2 = 0.645

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_1h_club_melee = function(t, speed_max)
		local p0 = 0.68
		local p1 = p0 - 0.05
		local p2 = p0 + 0.02

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_1h_axe_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.32
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_1h_axe_melee = function(t, speed_max)
		local p1 = 0.6599999999999999
		local p2 = 0.72

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_1h_axe_melee = function(t, speed_max)
		local p1 = 0.5449999999999999
		local p2 = 0.645

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_1h_axe_melee = function(t, speed_max)
		local p0 = 0.675
		local p1 = p0 - 0.04
		local p2 = p0 + 0.02

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_2h_sword_melee = function(t, speed_max)
		local p0 = 0.815
		local p1 = p0
		local p2 = p0

		if t < p1 then
			return speed_max * t^4 / p1^4
		elseif t < p2 then
			return speed_max
		else
			return speed_max * (t - 1)^2 / (p2 - 1)^2
		end
	end,
	left_2h_sword_melee = function(t, speed_max)
		local p0 = 0.67
		local p1 = p0
		local p2 = p0

		if t < p1 then
			return speed_max * t^4 / p1^4
		elseif t < p2 then
			return speed_max
		else
			return speed_max * (t - 1)^2 / (p2 - 1)^2
		end
	end,
	right_2h_sword_melee = function(t, speed_max)
		local p0 = 0.84
		local p1 = p0
		local p2 = p0

		if t < p1 then
			return speed_max * t^4 / p1^4
		elseif t < p2 then
			return speed_max
		else
			return speed_max * (t - 1)^2 / (p2 - 1)^2
		end
	end,
	low_2h_sword_melee = function(t, speed_max)
		local p0 = 0.625
		local p1 = p0
		local p2 = p0

		if t < p1 then
			return speed_max * t^4 / p1^4
		elseif t < p2 then
			return speed_max
		else
			return speed_max * (t - 1)^2 / (p2 - 1)^2
		end
	end,
	high_spear_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.235
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_spear_melee = function(t, speed_max)
		local p1 = 0.71
		local p2 = 0.7835

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_spear_melee = function(t, speed_max)
		local p1 = 0.77
		local p2 = 0.8400000000000001

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_spear_melee = function(t, speed_max)
		local p0 = 0.875
		local p1 = p0 - 0.12
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_polearm_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.26
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_polearm_melee = function(t, speed_max)
		local p1 = 0.6799999999999999
		local p2 = 0.76

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_polearm_melee = function(t, speed_max)
		local p1 = 0.76
		local p2 = 0.8300000000000001

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_polearm_melee = function(t, speed_max)
		local p0 = 0.875
		local p1 = p0 - 0.12
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_2h_axe_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.2725
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		else
			return speed_max
		end
	end,
	left_2h_axe_melee = function(t, speed_max)
		local p0 = 0.695
		local p1 = p0 - 0.07
		local p2 = p0 + 0.06

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_2h_axe_melee = function(t, speed_max)
		local p0 = 0.7675
		local p1 = p0 - 0.06
		local p2 = p0 + 0.05

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_2h_axe_melee = function(t, speed_max)
		local p0 = 0.775
		local p1 = p0 - 0.17
		local p2 = p0 + 0.04

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_2h_club_melee = function(t, speed_max)
		local p0 = 1
		local p1 = p0 - 0.265
		local p2 = p0

		if t < p1 then
			return speed_max * t^4 / p1^4
		else
			return speed_max
		end
	end,
	left_2h_club_melee = function(t, speed_max)
		local p0 = 0.71
		local p1 = p0 - 0.02
		local p2 = p0 + 0.01

		if t < p1 then
			return speed_max * t^4 / p1^4
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_2h_club_melee = function(t, speed_max)
		local p0 = 0.778
		local p1 = p0 - 0.012
		local p2 = p0 + 0.01

		if t < p1 then
			return speed_max * t^3 / p1^3
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_2h_club_melee = function(t, speed_max)
		local p0 = 0.775
		local p1 = p0 - 0.07
		local p2 = p0 + 0.07

		if t < p1 then
			return speed_max * t^2 / p1^2
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	high_1h_dagger_melee = function(t, speed_max)
		local p0 = 0.48
		local p1 = p0 - 0.1
		local p2 = p0 + 0.25

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	left_1h_dagger_melee = function(t, speed_max)
		local p0 = 0.48
		local p1 = p0 - 0.125
		local p2 = p0 + 0.16

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	right_1h_dagger_melee = function(t, speed_max)
		local p0 = 0.75
		local p1 = p0 - 0.125
		local p2 = p0 + 0.1

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	low_1h_dagger_melee = function(t, speed_max)
		local p0 = 0.4
		local p1 = p0 - 0.2
		local p2 = p0

		if t < p1 then
			return speed_max / p1 * t
		elseif t < p2 then
			return speed_max
		else
			return speed_max / (p2 - 1) * (t - p2) + speed_max
		end
	end,
	standard_bow = function(t, speed_max)
		local min_speed = 0.4 * speed_max

		return speed_max
	end
}
DamageDirectionDebugMultipliers = {
	down = 1,
	up = 1,
	left = 1,
	right = 1
}
