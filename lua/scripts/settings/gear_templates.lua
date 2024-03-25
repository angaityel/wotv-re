-- chunkname: @scripts/settings/gear_templates.lua

require("scripts/settings/gear_settings")
require("scripts/settings/gear_attachments")
require("scripts/settings/projectile_settings")
require("scripts/settings/attachment_node_linking")
require("scripts/settings/player_movement_settings")

local DEFAULT_SWING_ABORT_TIME_FACTOR = 0.5
local DEFAULT_SWING_ABORT_TIME_FACTOR_UP = 0.645
local DEFAULT_SWING_ABORT_TIME_FACTOR_LEFT = 0.58
local DEFAULT_SWING_ABORT_TIME_FACTOR_RIGHT = 0.45
local DEFAULT_SWING_ABORT_TIME_FACTOR_DOWN = 0.455
local DEFAULT_DAGGER_SWING_MINIMUM_POSE_TIME = 0.25
local DEFAULT_SPEAR_SWING_MINIMUM_POSE_TIME = 0.675
local DEFAULT_AXE2H_CHARGED_ATTACK_TIME = 0.55
local DEFAULT_AXE2H_UNCHARGED_ATTACK_TIME = 0.68
local DEFAULT_AXE2H_SWING_MINIMUM_POSE_TIME = 0.275
local DEFAULT_AXE2H_DODGE_ATTACK_TIME = 0.55
local DEFAULT_SWING_MINIMUM_POSE_TIME = 0.375
local DUAL_WIELD_PENALTIES = {
	dual_wield_defended = 0.2,
	interrupt_parry = 0,
	blocked = 0.2,
	interrupt = 0.1,
	hard = 0.275,
	parried = 0.15,
	miss = 0.1,
	character_hit_animation_speed = 0.2,
	hit = 0
}
local DUAL_WIELD_DODGE_ATTACK_TIME = 0.45
local SHIELD_BREAKER_MULTIPLIER = 1.1
local DEFAULT_PENALTIES = {
	parried = 0.8,
	dual_wield_defended = 0.3,
	miss = 0.4,
	blocked = 0.5,
	character_hit_animation_speed = 0.2,
	hard = 0.275
}
local DEFAULT_PENALTIES_SPEAR = {
	parried = 0.8,
	dual_wield_defended = 0.4,
	miss = 0.3,
	blocked = 0.65,
	character_hit_animation_speed = 0.2,
	hard = 0.275
}

SHIELD_MAIDEN_SPECIAL_PENALTIES = {
	parried = 0.5,
	dual_wield_defended = 0.3,
	miss = 0.5,
	blocked = 0.5,
	hit = 0.7,
	hard = 0.5
}

local DEFAULT_PENALTIES_DAGGER = {
	parried = 0.8,
	dual_wield_defended = 0.3,
	miss = 0.1,
	blocked = 0.5,
	character_hit_animation_speed = 0.2,
	hard = 0.275
}
local DEFAULT_PENALTIES_DODGE_ATTACK = {
	parried = 0.8,
	hit = 0.4,
	blocked = 0.8,
	miss = 0.6,
	hard = 0.6,
	dual_wield_defended = 0.3
}
local MENU_STATS_MELEE_ATTACKS = {
	"left",
	"right",
	"up"
}
local DODGE_ATTACK_ROTATION_TIME = 0.05
local DEFAULT_1H_AXE_SWEEP_1 = {
	thickness = 0.01,
	outer_node = "c_pole_high_point",
	inner_node = "c_pole_low_point",
	width = 0.05,
	hit_callback = "non_damage_hit_cb"
}
local DEFAULT_1H_AXE_SWEEP_2 = {
	thickness = 0.01,
	outer_node = "c_sweep_rightforearm_high",
	inner_node = "c_sweep_rightforearm_low",
	width = 0.04,
	hit_callback = "non_damage_hit_cb"
}
local DEFAULT_1H_AXE_LEFT_2 = {
	thickness = 0.01,
	outer_node = "c_sweep_leftforearm_high",
	inner_node = "c_sweep_leftforearm_low",
	width = 0.04,
	hit_callback = "non_damage_hit_cb"
}
local DEFAULT_1H_AXE_SWEEP_3 = {
	thickness = 0.01,
	outer_node = "c_blade_low_point",
	inner_node = "c_pole_high_point",
	width = 0.05,
	hit_callback = "hit_cb"
}
local DEFAULT_1H_AXE_SWEEP_4 = {
	thickness = 0.01,
	outer_node = "c_blade_high_point",
	inner_node = "c_blade_low_point",
	width = 0.2,
	hit_callback = "hit_cb"
}
local DEFAULT_1H_SWORD_RIGHT_1 = {
	thickness = 0.01,
	outer_node = "c_sweep_rightforearm_high",
	inner_node = "c_sweep_rightforearm_low",
	width = 0.04,
	hit_callback = "non_damage_hit_cb"
}
local DEFAULT_1H_SWORD_RIGHT_2 = {
	thickness = 0.01,
	outer_node = "c_blade_high_point",
	inner_node = "c_blade_low_point",
	width = 0.08,
	hit_callback = "hit_cb"
}
local DEFAULT_2H_AXE_SWEEP_1 = {
	thickness = 0.03,
	outer_node = "c_shaft_high",
	inner_node = "c_shaft_low",
	width = 0.03,
	hit_callback = "non_damage_hit_cb"
}
local DEFAULT_2H_AXE_SWEEP_2 = {
	thickness = 0.01,
	outer_node = "c_blade_high_point",
	inner_node = "c_blade_low_point",
	width = 0.2,
	hit_callback = "hit_cb"
}
local DEFAULT_2H_AXE_SWEEP_3 = {
	thickness = 0.03,
	outer_node = "c_blade_high_point",
	inner_node = "c_shaft_high",
	width = 0.03,
	hit_callback = "hit_cb"
}

AttackNamesIndex = {
	stance_special_initial_stab = 10,
	dodge_forward = 4,
	dodge_left = 6,
	throw = 13,
	stance_special_repeated_stab = 11,
	dodge_right = 7,
	left = 2,
	shield_bash = 12,
	up = 1,
	special = 8,
	stance_shield_bash = 9,
	dodge_backward = 5,
	right = 3
}
AttackNamesLookup = {
	"up",
	"left",
	"right",
	"dodge_forward",
	"dodge_backward",
	"dodge_left",
	"dodge_right",
	"special",
	"stance_shield_bash",
	"stance_special_initial_stab",
	"stance_special_repeated_stab",
	"shield_bash",
	"throw"
}
GearTemplates = {
	dagger = {
		wield_anim = "wield_right_arm_right_hip",
		ui_texture = "default",
		wield_time = 0.6,
		stat_category = "dagger",
		reach = 1,
		armour_type = "weapon_metal",
		hand = "both_hands",
		ui_combat_log_texture = "hud_combatlog_dagger",
		encumbrance = 1,
		unwield_anim = "unwield_right_arm_right_hip",
		gear_type = "dagger",
		absorption_value = 0,
		unwield_time = 0.6,
		penetration_value = 0,
		ui_combat_log_texture_headshot = "hud_combatlog_dagger",
		sweep_collision = true,
		ui_sort_index = 1,
		ui_header = "unnamed_dagger",
		category = "dagger",
		pose_movement_multiplier = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_facehit",
		hand_anim = "right_hand/1h_sword",
		attachment_node_linking = AttachmentNodeLinking.dagger.standard,
		health = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_dagger"
			},
			unwield = {
				event = "unwield_dagger"
			}
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			up = {
				uncharged_damage = 40,
				damage_range_type = "melee",
				charged_attack_time = 0.25,
				damage_type = "slashing",
				impact_material_effects = "melee_hit_slashing",
				charge_time = 0.3,
				charged_damage = 45,
				speed_max = 20,
				uncharged_attack_time = 0.4,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_DAGGER_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES_DAGGER,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.4
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_UP
			},
			left = {
				uncharged_damage = 40,
				damage_range_type = "melee",
				charged_attack_time = 0.25,
				damage_type = "slashing",
				impact_material_effects = "melee_hit_slashing",
				charge_time = 0.3,
				charged_damage = 45,
				speed_max = 20,
				uncharged_attack_time = 0.4,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_DAGGER_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES_DAGGER,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.5
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_LEFT
			},
			right = {
				uncharged_damage = 40,
				damage_range_type = "melee",
				charged_attack_time = 0.25,
				damage_type = "slashing",
				impact_material_effects = "melee_hit_slashing",
				charge_time = 0.3,
				charged_damage = 45,
				speed_max = 20,
				uncharged_attack_time = 0.4,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_DAGGER_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES_DAGGER,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.5
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_RIGHT
			},
			dodge_forward = {
				uncharged_damage = 40,
				charged_damage = 40,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_backward = {
				uncharged_damage = 40,
				charged_damage = 40,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_left = {
				uncharged_damage = 40,
				charged_damage = 40,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_right = {
				uncharged_damage = 40,
				charged_damage = 40,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			special = {
				uncharged_damage = 0,
				stun = true,
				charged_damage = 0,
				damage_range_type = "melee",
				rotation_time = 0.23,
				impact_material_effects = "melee_hit_blunt",
				speed_max = 20,
				damage_type = "blunt",
				anim_event = "special_attack_start",
				attack_time = 0.46,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.8,
					blocked = 1,
					miss = 0.5,
					character_hit_animation_speed = 0.2,
					hard = 1
				},
				player_sweep = {
					end_delay = 0.95,
					depth = 0.2,
					height = 0.2,
					forward_offset = 0.3,
					start_delay = 0.4,
					node = "c_rightfoot",
					width = 0.2
				},
				forward_direction = Vector3Box(0, 0, 1)
			}
		}
	},
	sword_1h = {
		category = "one_handed_sword",
		wield_anim_dual_wield = "wield_dual_wield",
		gear_type = "one_handed_sword",
		encumbrance = 1,
		reach = 1,
		penetration_value = 0,
		armour_type = "weapon_metal",
		block_type = "weapon",
		ui_combat_log_texture = "hud_combatlog_sword",
		ui_texture = "default",
		unwield_time = 0.8,
		attack_time = 1,
		unwield_time_dual_wield = 0.8,
		sweep_collision = true,
		absorption_value = 0,
		wield_time = 0.6,
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		wield_time_dual_wield = 0.6,
		ui_combat_log_texture_facehit = "hud_combatlog_facehit",
		stat_category = "one_handed_sword",
		hand = "right_hand",
		wield_anim = "wield_right_arm_left_hip",
		unit = "units/weapons/wpn_1h_sword_01/wpn_1h_sword_01",
		unwield_anim = "unwield_right_arm_left_hip",
		ui_combat_log_texture_headshot = "hud_combatlog_sword",
		ui_header = "unnamed_1h_sword",
		health = 100,
		unwield_anim_dual_wield = "unwield_dual_wield",
		hand_anim = "right_hand/1h_sword",
		attachment_node_linking = AttachmentNodeLinking.one_handed_weapon.with_arm_collision,
		dual_wield_attachment_node_linking = {
			primary = AttachmentNodeLinking.one_handed_weapon.with_arm_collision,
			secondary = AttachmentNodeLinking.one_handed_weapon.offhand_with_arm_collision
		},
		dual_wield_special_attacks = {
			one_handed_axe = {
				secondary = "sword_axe_special_secondary",
				primary = "sword_axe_special_primary"
			},
			one_handed_sword = {
				secondary = "sword_sword_special_secondary",
				primary = "sword_sword_special_primary"
			}
		},
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_sword",
				parameters = {
					{
						value = "sword_1h_medium",
						name = "weapon_type_base"
					}
				}
			},
			unwield = {
				event = "unwield_sword",
				parameters = {
					{
						value = "sword_1h_medium",
						name = "weapon_type_base"
					}
				}
			}
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			up = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				damage_range_type = "melee",
				abort_on_hit = false,
				impact_material_effects = "melee_hit_cutting",
				damage_type = "slashing",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 40,
				uncharged_attack_time = 0.5,
				abort_time_factor = 0.65,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.67
				}
			},
			left = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				damage_range_type = "melee",
				abort_on_hit = false,
				impact_material_effects = "melee_hit_slashing",
				damage_type = "slashing",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 40,
				uncharged_attack_time = 0.5,
				abort_time_factor = 0.58,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.5
				}
			},
			right = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				damage_range_type = "melee",
				abort_on_hit = false,
				impact_material_effects = "melee_hit_slashing",
				damage_type = "slashing",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 40,
				uncharged_attack_time = 0.5,
				abort_time_factor = 0.45,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.5
				}
			},
			throw = {
				damage_range_type = "small_projectile",
				throw_duration = 0.75,
				camera_node = "throwing",
				damage = 70,
				pose_duration = 0.5,
				tip_node = "c_blade_high_point",
				foot_node = "c_blade_low_point",
				speed_max = 20,
				damage_type = "piercing",
				release_factor = 0.2,
				rotation_offset = math.pi / 24,
				initial_rotation_offset = QuaternionBox(-0.707107, -0, -0, 0.707107),
				sweep = {
					inner_node = "c_blade_low_point",
					width = 0.01,
					outer_node = "c_blade_high_point",
					thickness = 0.01
				}
			},
			special = {
				uncharged_damage = 140,
				charged_damage = 140,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				stun = true,
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "special_attack_start",
				attack_time = 0.75,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.7,
					blocked = 1,
					miss = 0.8,
					hard = 1
				},
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.8
				},
				forward_direction = Vector3Box(0, 0, 1)
			},
			stance_shield_bash = {
				uncharged_damage = 0,
				stun = true,
				charged_damage = 0,
				damage_range_type = "melee",
				rotation_time = 0.23,
				impact_material_effects = "melee_hit_piercing",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "special_attack_bash",
				attack_time = 0.3,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.8,
					blocked = 1,
					miss = 0.5,
					character_hit_animation_speed = 0.2,
					hard = 1
				},
				player_sweep = {
					end_delay = 0.9,
					depth = 0.4,
					height = 0.8,
					forward_offset = 0.56,
					start_delay = 0.15,
					node = "c_neck",
					width = 0.8
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			stance_special_initial_stab = {
				animation_end_delay = 0.3,
				damage_range_type = "melee",
				charged_damage = 60,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_piercing",
				stun = false,
				damage_type = "piercing",
				uncharged_damage = 60,
				movement_multiplier = 1,
				speed_max = 20,
				anim_event = "special_attack_stab",
				attack_time = 0.33,
				speed_function = "standard_melee",
				penalties = SHIELD_MAIDEN_SPECIAL_PENALTIES,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.8
				},
				max_aim_angle = math.pi * 0.125,
				stamina_settings = PlayerUnitMovementSettings.combo_special_attack.stamina_settings,
				forward_direction = Vector3Box(0, 0, 1)
			},
			stance_special_repeated_stab = {
				animation_end_delay = 0.3,
				damage_range_type = "melee",
				charged_damage = 60,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_piercing",
				stun = false,
				damage_type = "piercing",
				uncharged_damage = 60,
				movement_multiplier = 0.5,
				speed_max = 20,
				anim_event = "special_attack_stab",
				attack_time = 0.13,
				speed_function = "standard_melee",
				penalties = SHIELD_MAIDEN_SPECIAL_PENALTIES,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.8
				},
				max_aim_angle = math.pi * 0.125,
				stamina_settings = PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings,
				forward_direction = Vector3Box(0, 0, 1)
			},
			dodge_forward = {
				uncharged_damage = 65,
				charged_damage = 65,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_backward = {
				uncharged_damage = 65,
				charged_damage = 65,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_left = {
				uncharged_damage = 65,
				charged_damage = 65,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_right = {
				uncharged_damage = 65,
				charged_damage = 65,
				parry_direction = "left",
				impact_material_effects = "melee_hit_slashing",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "slashing",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_SWORD_RIGHT_1,
					DEFAULT_1H_SWORD_RIGHT_2,
					delay = 0.7
				},
				forward_direction = Vector3Box(-1, 0, 0)
			}
		}
	},
	axe_1h = {
		wield_anim_dual_wield = "wield_dual_wield",
		wield_time = 0.6,
		wield_anim = "wield_right_arm_left_hip_axe",
		penetration_value = 0,
		reach = 1,
		health = 100,
		armour_type = "weapon_wood",
		block_type = "weapon",
		ui_combat_log_texture = "hud_combatlog_axe",
		unwield_time = 0.6,
		unwield_time_dual_wield = 0.8,
		ui_texture = "default",
		wield_time_dual_wield = 0.6,
		absorption_value = 0,
		sweep_collision = true,
		gear_type = "one_handed_axe",
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_facehit",
		stat_category = "one_handed_axe",
		hand = "right_hand",
		encumbrance = 1,
		unwield_anim = "unwield_right_arm_left_hip",
		ui_combat_log_texture_headshot = "hud_combatlog_axe",
		ui_header = "unnamed_1h_axe",
		category = "one_handed_axe",
		unwield_anim_dual_wield = "unwield_dual_wield",
		hand_anim = "right_hand/1h_sword",
		attachment_node_linking = AttachmentNodeLinking.one_handed_axe.standard,
		dual_wield_attachment_node_linking = {
			primary = AttachmentNodeLinking.one_handed_axe.standard,
			secondary = AttachmentNodeLinking.one_handed_axe.off_hand
		},
		dual_wield_special_attacks = {
			one_handed_axe = {
				secondary = "axe_axe_special_secondary",
				primary = "axe_axe_special_primary"
			},
			one_handed_sword = {
				secondary = "axe_sword_special_secondary",
				primary = "axe_sword_special_primary"
			}
		},
		damage_feedback_threshold_min = math.huge,
		damage_feedback_threshold_max = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_1haxe"
			},
			unwield = {
				event = "unwield_1haxe"
			}
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		sweep_node_script_offsets = {
			c_blade_low_point = Vector3Box(0, 0, 0.5),
			c_pole_high_point = Vector3Box(0.08, 0, 0.15),
			c_pole_low_point = Vector3Box(-0.08, 0, 0)
		},
		attacks = {
			up = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				no_behind_hits = true,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_cutting",
				abort_on_hit = true,
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 20,
				uncharged_attack_time = 0.5,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.55
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_UP
			},
			left = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				damage_range_type = "melee",
				abort_on_hit = true,
				impact_material_effects = "melee_hit_cutting",
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 20,
				uncharged_attack_time = 0.5,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.62
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_LEFT
			},
			right = {
				charged_attack_time = 0.3,
				charged_damage = 80,
				damage_range_type = "melee",
				abort_on_hit = true,
				impact_material_effects = "melee_hit_cutting",
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1,
				speed_max = 20,
				uncharged_attack_time = 0.5,
				attack_time = 1,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.4
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_RIGHT
			},
			special = {
				uncharged_damage = 170,
				charged_damage = 170,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				stun = true,
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "special_attack_start",
				attack_time = 0.9,
				speed_function = "standard_melee",
				penalties = {
					parried = 1.1,
					hit = 0.7,
					blocked = 1.1,
					miss = 0.8,
					hard = 1.1
				},
				sweep = {
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.87
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_forward = {
				uncharged_damage = 65,
				charged_damage = 65,
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				parry_direction = "left",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.7
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_backward = {
				uncharged_damage = 65,
				charged_damage = 65,
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				parry_direction = "left",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.7
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_left = {
				uncharged_damage = 65,
				charged_damage = 65,
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				parry_direction = "left",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.7
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_right = {
				uncharged_damage = 65,
				charged_damage = 65,
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				parry_direction = "left",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				attack_time = 0.33,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_1H_AXE_SWEEP_1,
					DEFAULT_1H_AXE_SWEEP_2,
					DEFAULT_1H_AXE_SWEEP_3,
					DEFAULT_1H_AXE_SWEEP_4,
					delay = 0.7
				},
				shield_breaker = SHIELD_BREAKER_MULTIPLIER,
				forward_direction = Vector3Box(-1, 0, 0)
			},
			throw = {
				camera_node = "throwing",
				throw_duration = 0.75,
				damage = 60,
				damage_range_type = "small_projectile",
				pose_duration = 0.5,
				tip_node = "c_pole_low_point",
				foot_node = "c_blade_high_point",
				spin_velocity = 5000,
				speed_max = 25,
				damage_type = "cutting",
				link_node = "throw_point",
				release_factor = 0.2,
				rotation_offset = math.pi / 24,
				initial_rotation_offset = QuaternionBox(0, 0, 0.707107, 0.707107),
				sweep = {
					inner_node = "c_blade_low_point",
					width = 0.01,
					outer_node = "c_blade_high_point",
					thickness = 0.01
				}
			}
		}
	},
	axe_2h = {
		health = 100,
		ui_texture = "default",
		wield_time = 0.8,
		wield_anim = "wield_2h_axe",
		stat_category = "two_handed_axe",
		reach = 1,
		gear_type = "two_handed_axe",
		armour_type = "weapon_metal",
		encumbrance = 1,
		ui_combat_log_texture = "hud_combatlog_twohandaxe",
		unwield_time = 0.8,
		sweep_collision = true,
		absorption_value = 0,
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_facehit",
		block_type = "weapon",
		hand = "both_hands",
		penetration_value = 0,
		unwield_anim = "unwield_2h_axe",
		ui_combat_log_texture_headshot = "hud_combatlog_twohandaxe",
		ui_header = "unnamed_2h_axe",
		category = "two_handed_axe",
		hand_anim = "both_hands/empty",
		attachment_node_linking = AttachmentNodeLinking.two_handed_axe.standard,
		damage_feedback_threshold_min = math.huge,
		damage_feedback_threshold_max = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_2haxe"
			},
			unwield = {
				event = "unwield_2haxe"
			}
		},
		sweep_node_script_offsets = {
			c_blade_low_point = Vector3Box(-0.05, 0, 0.25),
			c_blade_high_point = Vector3Box(0.115, 0, 0),
			c_shaft_high = Vector3Box(0, 0, -0.1),
			c_shaft_low = Vector3Box(0, 0, 0.1)
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			up = {
				animation_value_multiplier = 0.75,
				charged_damage = 100,
				no_behind_hits = true,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_cutting",
				abort_on_hit = true,
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1.3,
				speed_max = 20,
				attack_time = 1,
				speed_function = "standard_melee",
				charged_attack_time = DEFAULT_AXE2H_CHARGED_ATTACK_TIME,
				uncharged_attack_time = DEFAULT_AXE2H_UNCHARGED_ATTACK_TIME,
				minimum_pose_time = DEFAULT_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					delay = 0.65
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_UP
			},
			left = {
				animation_value_multiplier = 0.9,
				charged_damage = 100,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_slashing",
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1.3,
				speed_max = 20,
				abort_on_hit = true,
				speed_function = "standard_melee",
				charged_attack_time = DEFAULT_AXE2H_CHARGED_ATTACK_TIME,
				uncharged_attack_time = DEFAULT_AXE2H_UNCHARGED_ATTACK_TIME,
				minimum_pose_time = DEFAULT_AXE2H_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					delay = 0.5
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_LEFT
			},
			right = {
				animation_value_multiplier = 0.9,
				charged_damage = 100,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_slashing",
				damage_type = "cutting",
				uncharged_damage = 50,
				charge_time = 1.3,
				speed_max = 20,
				abort_on_hit = true,
				speed_function = "standard_melee",
				charged_attack_time = DEFAULT_AXE2H_CHARGED_ATTACK_TIME,
				uncharged_attack_time = DEFAULT_AXE2H_UNCHARGED_ATTACK_TIME,
				minimum_pose_time = DEFAULT_AXE2H_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES,
				forward_direction = Vector3Box(-1, 0, 0),
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					delay = 0.55
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_RIGHT
			},
			special = {
				uncharged_damage = 170,
				charged_damage = 170,
				rotation_time = 0.3,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				stun = true,
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "special_attack_start",
				attack_time = 0.81,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.85,
					blocked = 1,
					miss = 1.1,
					hard = 1
				},
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					delay = 0.85
				},
				forward_direction = Vector3Box(-1, 0, 0),
				dodge_hit_zones_to_ignore = {
					"feet",
					"calfs",
					"legs"
				}
			},
			dodge_forward = {
				uncharged_damage = 75,
				charged_damage = 75,
				parry_direction = "right",
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				attack_time = DEFAULT_AXE2H_DODGE_ATTACK_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					delay = 0.72,
					end_delay = 0.95
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_backward = {
				uncharged_damage = 75,
				charged_damage = 75,
				parry_direction = "right",
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "dodge_attack_start",
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				attack_time = DEFAULT_AXE2H_DODGE_ATTACK_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					end_delay = 0.95,
					delay = 0.72
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_left = {
				uncharged_damage = 75,
				charged_damage = 75,
				parry_direction = "right",
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				attack_time = DEFAULT_AXE2H_DODGE_ATTACK_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					end_delay = 0.95,
					delay = 0.72
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			dodge_right = {
				uncharged_damage = 75,
				charged_damage = 75,
				parry_direction = "right",
				impact_material_effects = "melee_hit_cutting",
				damage_range_type = "melee",
				speed_max = 20,
				damage_type = "cutting",
				anim_event = "dodge_attack_start",
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				attack_time = DEFAULT_AXE2H_DODGE_ATTACK_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					DEFAULT_2H_AXE_SWEEP_1,
					DEFAULT_2H_AXE_SWEEP_2,
					DEFAULT_2H_AXE_SWEEP_3,
					end_delay = 0.95,
					delay = 0.72
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			throw = {
				camera_node = "throwing_axe",
				throw_duration = 1,
				damage = 75,
				damage_range_type = "small_projectile",
				pose_duration = 0.5,
				tip_node = "c_blade_high_point",
				foot_node = "c_blade_low_point",
				spin_velocity = 200,
				speed_max = 20,
				damage_type = "cutting",
				link_node = "throw_point",
				release_factor = 0.6,
				rotation_offset = math.pi / 96,
				initial_rotation_offset = QuaternionBox(0, 0, 0.707107, 0.707107),
				sweep = {
					inner_node = "c_blade_low_point",
					width = 0.01,
					outer_node = "c_blade_high_point",
					thickness = 0.01
				}
			}
		}
	},
	spear = {
		health = 100,
		ui_texture = "default",
		wield_time = 0.8,
		wield_anim = "wield_spear",
		stat_category = "spear",
		reach = 1,
		gear_type = "spear",
		armour_type = "weapon_metal",
		encumbrance = 1,
		ui_combat_log_texture = "hud_combatlog_spear",
		unwield_time = 0.8,
		sweep_collision = true,
		absorption_value = 0,
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_facehit",
		only_thrust = true,
		block_type = "weapon",
		hand = "both_hands",
		penetration_value = 0,
		unwield_anim = "unwield_spear",
		ui_combat_log_texture_headshot = "hud_combatlog_spear",
		ui_header = "unnamed_spear",
		category = "spear",
		hand_anim = "right_hand/empty",
		attachment_node_linking = AttachmentNodeLinking.spear.standard,
		damage_feedback_threshold_min = math.huge,
		damage_feedback_threshold_max = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_spear"
			},
			unwield = {
				event = "unwield_spear"
			}
		},
		swing_stamina_settings = {
			minimum_activation_cost = 0.05,
			activation_cost = 0.075,
			chain_use = PlayerUnitMovementSettings.swing.stamina_settings.chain_use
		},
		properties = {
			stun = false
		},
		sweep_node_script_offsets = {
			c_spearhead_low_point = Vector3Box(0, 0, -0.3)
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			up = {
				charged_attack_time = 0.16,
				charged_damage = 60,
				no_behind_hits = true,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_slashing",
				damage_type = "piercing",
				uncharged_damage = 50,
				charge_time = 0.8,
				speed_max = 20,
				uncharged_attack_time = 0.25,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SPEAR_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES_SPEAR,
				forward_direction = Vector3Box(0, 0, 1),
				progression_multiplier_func = function(progression)
					math.auto_lerp(0, 0.45, 0.5, 1, progression)
				end,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_pole_high_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.2
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_UP
			},
			down = {
				charged_attack_time = 0.16,
				charged_damage = 60,
				no_behind_hits = true,
				damage_range_type = "melee",
				impact_material_effects = "melee_hit_slashing",
				damage_type = "piercing",
				uncharged_damage = 50,
				charge_time = 0.8,
				speed_max = 20,
				uncharged_attack_time = 0.25,
				speed_function = "standard_melee",
				minimum_pose_time = DEFAULT_SPEAR_SWING_MINIMUM_POSE_TIME,
				penalties = DEFAULT_PENALTIES_SPEAR,
				forward_direction = Vector3Box(0, 0, 1),
				progression_multiplier_func = function(progression)
					return math.auto_lerp(0, 0.45, 0.5, 1, progression)
				end,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_pole_high_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.2
				},
				abort_time_factor = DEFAULT_SWING_ABORT_TIME_FACTOR_UP
			},
			special = {
				uncharged_damage = 0,
				stun = true,
				charged_damage = 0,
				damage_range_type = "melee",
				rotation_time = 0.23,
				impact_material_effects = "melee_hit_piercing",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "special_attack_start",
				attack_time = 0.6,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.8,
					blocked = 1,
					miss = 0.5,
					character_hit_animation_speed = 0.2,
					hard = 1
				},
				player_sweep = {
					end_delay = 0.92,
					depth = 0.4,
					height = 0.8,
					forward_offset = 0.3,
					start_delay = 0.4,
					node = "c_neck",
					width = 0.8
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			stance_shield_bash = {
				uncharged_damage = 0,
				stun = true,
				charged_damage = 0,
				damage_range_type = "melee",
				rotation_time = 0.23,
				impact_material_effects = "melee_hit_piercing",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "special_attack_bash",
				attack_time = 0.3,
				speed_function = "standard_melee",
				penalties = {
					parried = 1,
					hit = 0.8,
					blocked = 1,
					miss = 0.5,
					character_hit_animation_speed = 0.2,
					hard = 1
				},
				player_sweep = {
					end_delay = 0.9,
					depth = 0.4,
					height = 0.8,
					forward_offset = 0.56,
					start_delay = 0.15,
					node = "c_neck",
					width = 0.8
				},
				forward_direction = Vector3Box(-1, 0, 0)
			},
			stance_special_initial_stab = {
				charged_damage = 60,
				no_behind_hits = true,
				animation_end_delay = 0.3,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				stun = false,
				damage_type = "piercing",
				uncharged_damage = 60,
				movement_multiplier = 1,
				speed_max = 20,
				anim_event = "special_attack_stab",
				attack_time = 0.33,
				speed_function = "standard_melee",
				penalties = SHIELD_MAIDEN_SPECIAL_PENALTIES,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.2
				},
				stamina_settings = PlayerUnitMovementSettings.combo_special_attack.stamina_settings,
				max_aim_angle = math.pi * 0.125,
				forward_direction = Vector3Box(0, 0, 1)
			},
			stance_special_repeated_stab = {
				charged_damage = 60,
				no_behind_hits = true,
				animation_end_delay = 0.3,
				rotation_time = 0.2,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				stun = false,
				damage_type = "piercing",
				uncharged_damage = 60,
				movement_multiplier = 0.5,
				speed_max = 20,
				anim_event = "special_attack_stab",
				attack_time = 0.13,
				speed_function = "standard_melee",
				penalties = SHIELD_MAIDEN_SPECIAL_PENALTIES,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.2
				},
				stamina_settings = PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings,
				max_aim_angle = math.pi * 0.125,
				forward_direction = Vector3Box(0, 0, 1)
			},
			dodge_backward = {
				uncharged_damage = 69,
				charged_damage = 69,
				no_behind_hits = true,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				parry_direction = "down",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "dodge_attack_start",
				attack_time = 0.4,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.3
				},
				forward_direction = Vector3Box(0, 0, 1)
			},
			dodge_left = {
				uncharged_damage = 69,
				charged_damage = 69,
				no_behind_hits = true,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				parry_direction = "down",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "dodge_attack_start",
				attack_time = 0.4,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.3
				},
				forward_direction = Vector3Box(0, 0, 1)
			},
			dodge_right = {
				uncharged_damage = 69,
				charged_damage = 69,
				no_behind_hits = true,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				parry_direction = "down",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "dodge_attack_start",
				attack_time = 0.4,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.3
				},
				forward_direction = Vector3Box(0, 0, 1)
			},
			dodge_forward = {
				uncharged_damage = 69,
				charged_damage = 69,
				no_behind_hits = true,
				impact_material_effects = "melee_hit_piercing",
				damage_range_type = "melee",
				parry_direction = "down",
				speed_max = 20,
				damage_type = "piercing",
				anim_event = "dodge_attack_start",
				attack_time = 0.4,
				speed_function = "standard_melee",
				rotation_time = DODGE_ATTACK_ROTATION_TIME,
				penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
				sweep = {
					{
						thickness = 0.05,
						outer_node = "c_spearhead_low_point",
						inner_node = "c_pole_low_point",
						width = 0.05,
						hit_callback = "non_damage_hit_cb"
					},
					{
						thickness = 0.05,
						outer_node = "c_spearhead_high_point",
						inner_node = "c_spearhead_low_point",
						width = 0.05,
						hit_callback = "hit_cb"
					},
					delay = 0.3
				},
				forward_direction = Vector3Box(0, 0, 1)
			},
			throw = {
				camera_node = "throwing_javelin",
				throw_duration = 1.1,
				damage = 85,
				full_body = false,
				pose_duration = 0.5,
				tip_node = "c_spearhead_high_point",
				foot_node = "c_pole_low_point",
				damage_range_type = "small_projectile",
				speed_max = 33,
				damage_type = "piercing",
				shield_breaker = true,
				release_factor = 0.5,
				rotation_offset = math.pi / 100,
				initial_rotation_offset = QuaternionBox(-0.707107, -0, -0, 0.707107),
				sweep = {
					inner_node = "c_spearhead_low_point",
					width = 0.01,
					outer_node = "c_spearhead_high_point",
					thickness = 0.01
				}
			}
		}
	},
	throwing_spear = {
		health = 100,
		ui_texture = "default",
		wield_time = 0.8,
		encumbrance = 1,
		stat_category = "spear",
		reach = 1,
		gear_type = "throwing_spear",
		armour_type = "weapon_metal",
		wield_anim = "wield_1h_spear",
		ui_combat_log_texture = "hud_combatlog_throwspear",
		unwield_time = 0.8,
		sweep_collision = true,
		absorption_value = 0,
		ui_ammo_texture = "ammo_spear",
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_throwspear_headshot",
		only_thrust = true,
		block_type = "weapon",
		hand = "right_hand",
		ui_ammo_glow_texture = "ammo_spear_glow",
		penetration_value = 0,
		unwield_anim = "unwield_1h_spear",
		ui_combat_log_texture_headshot = "hud_combatlog_throwspear_headshot",
		ui_header = "unnamed_spear",
		category = "throwing_weapon",
		starting_ammo = 1,
		hand_anim = "right_hand/empty",
		attachment_node_linking = AttachmentNodeLinking.trowing_spear.standard,
		damage_feedback_threshold_min = math.huge,
		damage_feedback_threshold_max = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_spear"
			},
			unwield = {
				event = "unwield_spear"
			}
		},
		swing_stamina_settings = {
			minimum_activation_cost = 0.05,
			activation_cost = 0.075,
			chain_use = PlayerUnitMovementSettings.swing.stamina_settings.chain_use
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			throw = {
				damage_range_type = "small_projectile",
				full_body = false,
				camera_node = "throwing_javelin",
				foot_node = "c_pole_low_point",
				damage_type = "piercing",
				release_factor = 0.5,
				throw_duration = 1,
				damage = 85,
				shield_breaker = true,
				pose_duration = 0.5,
				tip_node = "c_spearhead_high_point",
				speed_max = 33,
				rotation_offset = math.pi / 100,
				initial_rotation_offset = QuaternionBox(-0.707107, -0, -0, 0.707107),
				sweep = {
					inner_node = "c_spearhead_low_point",
					width = 0.01,
					outer_node = "c_spearhead_high_point",
					thickness = 0.01
				},
				local_particles = {
					{
						kill = "bounced",
						node = "dropped",
						particle_name = "fx/player_throw_spear_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					},
					{
						kill = "bounced",
						node = "dropped",
						particle_name = "fx/arrow_ball",
						fade_kill = false,
						forward_direction = Vector3Box(Vector3.forward())
					}
				},
				remote_particles = {
					{
						kill = "bounced",
						node = "dropped",
						particle_name = "fx/arrow_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					}
				}
			}
		}
	},
	throwing_dagger = {
		category = "throwing_weapon",
		ui_texture = "default",
		wield_time = 0.3,
		encumbrance = 1,
		penetration_value = 0,
		reach = 1,
		gear_type = "throwing_dagger",
		armour_type = "weapon_metal",
		ui_combat_log_texture_headshot = "hud_combatlog_throwdagger_headshot",
		ui_combat_log_texture = "hud_combatlog_throwdagger",
		unwield_time = 0.3,
		absorption_value = 0,
		ui_ammo_texture = "ammo_knife",
		ui_sort_index = 1,
		pose_movement_multiplier = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_throwdagger_headshot",
		stat_category = "dagger",
		hand = "right_hand",
		ui_ammo_glow_texture = "ammo_knife_glow",
		wield_anim = "wield_throwing_dagger",
		unwield_anim = "unwield_throwing_dagger",
		sweep_collision = true,
		ui_header = "unnamed_dagger",
		starting_ammo = 4,
		hand_anim = "right_hand/1h_sword",
		attachment_node_linking = AttachmentNodeLinking.throwing_dagger.standard,
		health = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_dagger"
			},
			unwield = {
				event = "unwield_dagger"
			}
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			throw = {
				camera_node = "throwing_dagger",
				damage_range_type = "small_projectile",
				foot_node = "c_blade_low_point",
				head_shot_multiplier = 1.2,
				damage_type = "piercing",
				release_factor = 0.2,
				throw_duration = 0.5,
				damage = 30,
				pose_duration = 0.3,
				tip_node = "c_blade_high_point",
				penetration_depth = -0.1,
				speed_max = 30,
				rotation_offset = math.pi / 96,
				initial_rotation_offset = QuaternionBox(-0.5, -0.5, -0.5, 0.5),
				sweep = {
					inner_node = "c_blade_low_point",
					width = 0.01,
					outer_node = "c_blade_high_point",
					thickness = 0.01
				},
				local_particles = {
					{
						kill = "bounced",
						node = "c_blade_low_point",
						particle_name = "fx/player_throw_knife_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					}
				},
				remote_particles = {
					{
						kill = "bounced",
						node = "c_blade_low_point",
						particle_name = "fx/throw_knife_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					}
				}
			}
		}
	},
	throwing_axe = {
		health = 100,
		ui_texture = "default",
		wield_time = 0.5,
		encumbrance = 1,
		stat_category = "one_handed_axe",
		reach = 1,
		gear_type = "throwing_axe",
		armour_type = "weapon_wood",
		wield_anim = "wield_throwing_axe",
		ui_combat_log_texture = "hud_combatlog_throwaxe",
		unwield_time = 0.5,
		sweep_collision = true,
		absorption_value = 0,
		ui_ammo_texture = "ammo_axe",
		ui_sort_index = 3,
		pose_movement_multiplier = 1,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_throwaxe_headshot",
		block_type = "weapon",
		hand = "right_hand",
		ui_ammo_glow_texture = "ammo_axe_glow",
		penetration_value = 0,
		unwield_anim = "unwield_throwing_axe",
		ui_combat_log_texture_headshot = "hud_combatlog_throwaxe_headshot",
		ui_header = "throwing_axe",
		category = "throwing_weapon",
		starting_ammo = 2,
		hand_anim = "right_hand/1h_sword",
		attachment_node_linking = AttachmentNodeLinking.throwing_axe.standard,
		damage_feedback_threshold_min = math.huge,
		damage_feedback_threshold_max = math.huge,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_1haxe"
			},
			unwield = {
				event = "unwield_1haxe"
			}
		},
		properties = {
			stun = false
		},
		menu_stats_attacks = MENU_STATS_MELEE_ATTACKS,
		attacks = {
			throw = {
				camera_node = "throwing_axe",
				spin_velocity = 5000,
				damage_range_type = "small_projectile",
				foot_node = "c_blade_high_point",
				head_shot_multiplier = 1.12,
				damage_type = "cutting",
				release_factor = 0.2,
				throw_duration = 0.75,
				damage = 45,
				pose_duration = 0.5,
				tip_node = "c_pole_low_point",
				penetration_depth = 0.07,
				speed_max = 30,
				rotation_offset = math.pi / 96,
				initial_rotation_offset = QuaternionBox(0, 0, 0.707107, 0.707107),
				sweep = {
					inner_node = "c_blade_low_point",
					width = 0.01,
					outer_node = "c_blade_high_point",
					thickness = 0.01
				},
				local_particles = {
					{
						kill = "bounced",
						node = "dropped",
						particle_name = "fx/player_throw_axe_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					}
				},
				remote_particles = {
					{
						kill = "bounced",
						node = "dropped",
						particle_name = "fx/throw_axe_trail",
						fade_kill = true,
						forward_direction = Vector3Box(Vector3.forward())
					}
				}
			}
		}
	},
	small_shield = {
		penetration_value = 0,
		ui_texture = "default",
		gear_type = "shield",
		block_type = "shield",
		reach = 1,
		armour_type = "weapon_wood",
		wield_time = 0.8,
		hand = "left_hand",
		pose_movement_multiplier = 1,
		encumbrance = 1,
		wield_anim = "wield_left_arm_back",
		unwield_anim = "unwield_left_arm_back",
		attack_time = 1,
		absorption_value = 1,
		show_coat_of_arms = true,
		health = 500,
		stat_category = "shield",
		ui_sort_index = 1,
		unwield_time = 0.8,
		ui_header = "unnamed_shield",
		category = "large_shield",
		small_shield = false,
		hand_anim = "left_hand/shield",
		attachment_node_linking = AttachmentNodeLinking.shield.standard,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_shield"
			},
			unwield = {
				event = "unwield_shield"
			}
		},
		menu_stats_attacks = {},
		attacks = {
			shield_bash = {
				base_damage = 9,
				uncharged_damage_factor = 0.064,
				damage_range_type = "melee",
				quick_swing_charge_time = 0,
				charge_time = 0.75,
				speed_max = 38,
				damage_type = "blunt",
				attack_time = 0.35,
				forward_direction = Vector3Box(1, 0, 0),
				sweep = {
					inner_node = "c_shield_low_point",
					width = 0.6,
					outer_node = "c_shield_high_point",
					thickness = 0.01
				},
				penalties = {
					miss = 0.48,
					hard = 1
				}
			}
		}
	},
	large_shield = {
		penetration_value = 0,
		ui_texture = "default",
		gear_type = "shield",
		block_type = "shield",
		reach = 1,
		armour_type = "weapon_wood",
		wield_time = 0.8,
		hand = "left_hand",
		pose_movement_multiplier = 1,
		encumbrance = 1,
		wield_anim = "wield_left_arm_back",
		unwield_anim = "unwield_left_arm_back",
		attack_time = 1,
		absorption_value = 1,
		show_coat_of_arms = true,
		health = 500,
		stat_category = "shield",
		ui_sort_index = 1,
		pose_backward_movement_multiplier = 0.75,
		ui_header = "unnamed_shield",
		category = "large_shield",
		unwield_time = 0.8,
		small_shield = false,
		hand_anim = "left_hand/shield",
		attachment_node_linking = AttachmentNodeLinking.shield.standard,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_shield"
			},
			unwield = {
				event = "unwield_shield"
			}
		},
		menu_stats_attacks = {},
		attacks = {
			shield_bash = {
				base_damage = 9,
				uncharged_damage_factor = 0.064,
				damage_range_type = "melee",
				quick_swing_charge_time = 0,
				charge_time = 0.75,
				speed_max = 38,
				damage_type = "blunt",
				attack_time = 0.35,
				forward_direction = Vector3Box(1, 0, 0),
				sweep = {
					inner_node = "c_shield_low_point",
					width = 0.6,
					outer_node = "c_shield_high_point",
					thickness = 0.01
				},
				penalties = {
					miss = 0.48,
					hard = 1
				}
			}
		}
	},
	longbow = {
		health = 100,
		ui_texture = "default",
		gear_type = "longbow",
		penetration_value = 1,
		wield_time = 0.6,
		reach = 1,
		wield_anim = "wield_longbow",
		armour_type = "weapon_wood",
		sound_gear_type = "bow",
		ui_combat_log_texture = "hud_combatlog_arrow",
		unwield_time = 0.5,
		zoom_camera_node = "zoom_longbow",
		absorption_value = 1,
		ui_sort_index = 1,
		pose_movement_multiplier = 0.4,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_arrow_headshot",
		stat_category = "bow",
		hand = "both_hands",
		encumbrance = 1.8,
		unwield_anim = "unwield_longbow",
		ammo_regen_rate = 10,
		ui_combat_log_texture_headshot = "hud_combatlog_arrow_headshot",
		ui_header = "unnamed_bow",
		category = "bow",
		starting_ammo = 12,
		hand_anim = "both_hands/empty",
		attachment_node_linking = AttachmentNodeLinking.bow.standard,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_bow"
			},
			unwield = {
				event = "unwield_bow"
			}
		},
		projectiles = {
			default = ProjectileSettings.standard_arrow_long,
			fire = ProjectileSettings.fire_arrow_long
		},
		quiver = {
			unit = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather",
			attachment_node_linking = AttachmentNodeLinking.quivers.bow
		},
		menu_stats_attacks = {
			"ranged"
		},
		attacks = {
			ranged = {
				uncharged_damage = 50,
				damage_range_type = "small_projectile",
				hold_time = 0.3,
				charged_damage = 71.5,
				speed_function = "standard_bow",
				projectile_release_pitch = 0,
				projectile_release_distance = 0,
				bow_tense_time = 2,
				speed_max = 150,
				bow_shake_time = 1.2,
				tighten_sound_length = 0.11,
				reload_time = 1.3,
				bow_draw_time = 1.25,
				stamina_settings = {
					recharge_delay = 3,
					minimum_activation_cost = 0.25,
					activation_cost = 0.25
				}
			}
		}
	},
	hunting_bow = {
		category = "bow",
		ui_texture = "default",
		gear_type = "hunting_bow",
		wield_anim = "wield_huntingbow",
		wield_time = 0.6,
		reach = 1,
		encumbrance = 1,
		armour_type = "weapon_wood",
		sound_gear_type = "bow",
		ui_combat_log_texture = "hud_combatlog_arrow",
		unwield_time = 0.5,
		zoom_camera_node = "zoom_bow",
		absorption_value = 1,
		ui_sort_index = 1,
		pose_movement_multiplier = 0.6,
		attack_time = 1,
		ui_combat_log_texture_facehit = "hud_combatlog_arrow_headshot",
		stat_category = "bow",
		hand = "both_hands",
		penetration_value = 0,
		unwield_anim = "unwield_huntingbow",
		ammo_regen_rate = 10,
		ui_combat_log_texture_headshot = "hud_combatlog_arrow_headshot",
		ui_header = "unnamed_bow",
		health = 1,
		starting_ammo = 12,
		hand_anim = "both_hands/empty",
		attachment_node_linking = AttachmentNodeLinking.bow.standard,
		attachments = {},
		ui_small_attachment_icons = {},
		timpani_events = {
			wield = {
				event = "wield_bow"
			},
			unwield = {
				event = "unwield_bow"
			}
		},
		projectiles = {
			default = ProjectileSettings.standard_arrow_long,
			fire = ProjectileSettings.fire_arrow_long
		},
		quiver = {
			unit = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather",
			attachment_node_linking = AttachmentNodeLinking.quivers.bow
		},
		menu_stats_attacks = {
			"ranged"
		},
		attacks = {
			ranged = {
				uncharged_damage = 50,
				damage_range_type = "small_projectile",
				hold_time = 0.3,
				charged_damage = 65,
				speed_function = "standard_bow",
				projectile_release_pitch = 0,
				projectile_release_distance = 0,
				bow_tense_time = 1.6,
				head_shot_multiplier = 0.625,
				speed_max = 80,
				bow_shake_time = 1.8,
				tighten_sound_length = 0.11,
				reload_time = 1,
				bow_draw_time = 1.125,
				stamina_settings = {
					minimum_activation_cost = 0.3125,
					activation_cost = 0.3125
				}
			}
		}
	},
	damage_zone = {
		gear_type = "damage_zone",
		wield_time = 1,
		stat_category = "damage_zone",
		reach = 1,
		ui_combat_log_texture = "hud_combatlog_selfkilled",
		category = "damage_zone",
		attack_time = 1,
		attacks = {
			up = {
				uncharged_damage = 1,
				charged_damage = 1,
				damage_range_type = "melee",
				damage_type = "slashing",
				charged_attack_time = 1,
				uncharged_attack_time = 1,
				penalties = DEFAULT_PENALTIES_DAGGER
			}
		},
		attachments = {}
	}
}

local DUAL_WIELD_SPECIAL_ATTACKS = {
	axe_sword_special_primary = {
		uncharged_damage = 85,
		charged_damage = 85,
		rotation_time = 0.45,
		impact_material_effects = "melee_hit_piercing",
		damage_range_type = "melee",
		movement_multiplier = 0.6,
		speed_max = 20,
		damage_type = "piercing",
		anim_event = "special_attack_start",
		attack_time = 0.85,
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		sweep = {
			DEFAULT_1H_SWORD_RIGHT_1,
			DEFAULT_1H_SWORD_RIGHT_2,
			end_delay = 0.975,
			delay = 0.84
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	axe_sword_special_secondary = {
		uncharged_damage = 85,
		charged_damage = 85,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_piercing",
		speed_max = 20,
		damage_type = "piercing",
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		sweep = {
			delay = 0.84,
			end_delay = 0.975
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	axe_axe_special_primary = {
		uncharged_damage = 170,
		charged_damage = 170,
		rotation_time = 0.3,
		impact_material_effects = "melee_hit_piercing",
		damage_range_type = "melee",
		speed_max = 20,
		damage_type = "piercing",
		anim_event = "special_attack_shield_break",
		attack_time = 1.16,
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		sweep = {
			delay = 0.8
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	axe_axe_special_secondary = {
		uncharged_damage = 35,
		stun = true,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_piercing",
		damage_type = "piercing",
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		player_sweep = {
			end_delay = 0.6,
			depth = 0.4,
			height = 0.8,
			forward_offset = 0.56,
			start_delay = 0.4,
			node = "c_neck",
			width = 0.8
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	sword_axe_special_primary = {
		uncharged_damage = 120,
		charged_damage = 120,
		rotation_time = 0.3,
		impact_material_effects = "melee_hit_piercing",
		damage_range_type = "melee",
		speed_max = 20,
		damage_type = "piercing",
		anim_event = "special_attack_shield_break_sword",
		attack_time = 1.16,
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		sweep = {
			delay = 0.8
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	sword_axe_special_secondary = {
		uncharged_damage = 35,
		stun = true,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_piercing",
		damage_type = "piercing",
		speed_function = "standard_melee",
		penalties = {
			parried = 1,
			hit = 0.7,
			blocked = 1,
			miss = 0.4,
			hard = 1
		},
		player_sweep = {
			end_delay = 0.6,
			depth = 0.4,
			height = 0.8,
			forward_offset = 0.56,
			start_delay = 0.4,
			node = "c_neck",
			width = 0.8
		},
		forward_direction = Vector3Box(0, 0, 1)
	},
	dual_wield_dodge_forward_primary = {
		uncharged_damage = 35,
		charged_damage = 35,
		impact_material_effects = "melee_hit_slashing",
		damage_range_type = "melee",
		parry_direction = "left",
		speed_max = 20,
		damage_type = "slashing",
		anim_event = "dodge_attack_start",
		speed_function = "standard_melee",
		rotation_time = DODGE_ATTACK_ROTATION_TIME,
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_forward_secondary = {
		uncharged_damage = 35,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_slashing",
		damage_type = "slashing",
		speed_function = "standard_melee",
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_backward_primary = {
		uncharged_damage = 35,
		charged_damage = 35,
		impact_material_effects = "melee_hit_slashing",
		damage_range_type = "melee",
		parry_direction = "left",
		speed_max = 20,
		damage_type = "slashing",
		anim_event = "dodge_attack_start",
		speed_function = "standard_melee",
		rotation_time = DODGE_ATTACK_ROTATION_TIME,
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_backward_secondary = {
		uncharged_damage = 35,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_slashing",
		damage_type = "slashing",
		speed_function = "standard_melee",
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_left_primary = {
		uncharged_damage = 35,
		charged_damage = 35,
		impact_material_effects = "melee_hit_slashing",
		damage_range_type = "melee",
		parry_direction = "left",
		speed_max = 20,
		damage_type = "slashing",
		anim_event = "dodge_attack_start",
		speed_function = "standard_melee",
		rotation_time = DODGE_ATTACK_ROTATION_TIME,
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_left_secondary = {
		uncharged_damage = 35,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_slashing",
		damage_type = "slashing",
		speed_function = "standard_melee",
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_right_primary = {
		uncharged_damage = 35,
		charged_damage = 35,
		impact_material_effects = "melee_hit_slashing",
		damage_range_type = "melee",
		parry_direction = "left",
		speed_max = 20,
		damage_type = "slashing",
		anim_event = "dodge_attack_start",
		speed_function = "standard_melee",
		rotation_time = DODGE_ATTACK_ROTATION_TIME,
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	dual_wield_dodge_right_secondary = {
		uncharged_damage = 35,
		charged_damage = 35,
		speed_max = 20,
		damage_range_type = "melee",
		impact_material_effects = "melee_hit_slashing",
		damage_type = "slashing",
		speed_function = "standard_melee",
		attack_time = DUAL_WIELD_DODGE_ATTACK_TIME,
		penalties = DEFAULT_PENALTIES_DODGE_ATTACK,
		sweep = {
			delay = 0.6
		},
		forward_direction = Vector3Box(-1, 0, 0)
	}
}
local DUAL_WIELD_ATTACKS = {
	left_start = {
		damage_range_type = "melee",
		animation_end_delay = 0.1,
		parry_direction = "left",
		rotation_time = 1,
		impact_material_effects = "melee_hit_slashing",
		charged_damage = 50,
		stun = false,
		damage_type = "slashing",
		uncharged_damage = 50,
		speed_max = 20,
		anim_event = "swing_attack_left_start",
		speed_function = "standard_melee",
		attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.55,
		penalties = DUAL_WIELD_PENALTIES,
		abort_time_factor = 0.3 / (DEFAULT_SWING_MINIMUM_POSE_TIME + 0.45),
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		sweep = {
			delay = 0.55,
			end_delay = 0.8
		},
		forward_direction = Vector3Box(-1, 0, 0)
	},
	right_start = {
		damage_range_type = "melee",
		animation_end_delay = 0.1,
		parry_direction = "right",
		rotation_time = 1,
		impact_material_effects = "melee_hit_slashing",
		charged_damage = 50,
		stun = false,
		damage_type = "slashing",
		uncharged_damage = 50,
		speed_max = 20,
		anim_event = "swing_attack_right_start",
		speed_function = "standard_melee",
		attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.55,
		penalties = DUAL_WIELD_PENALTIES,
		abort_time_factor = 0.3 / (DEFAULT_SWING_MINIMUM_POSE_TIME + 0.45),
		stamina_settings = {
			activation_cost = 0.25,
			minimum_activation_cost = 0.2
		},
		sweep = {
			delay = 0.55,
			end_delay = 0.82
		},
		forward_direction = Vector3Box(-1, 0, 0)
	}
}

WeaponSpecialAttackComp = {
	dagger = 1.1,
	one_handed_axe = 1.5,
	one_handed_sword = 2.5,
	berserk = 2.1,
	spear = 1.4,
	two_handed_axe = 1.1
}
DUAL_WIELD_SPECIAL_ATTACKS.sword_sword_special_primary = table.clone(DUAL_WIELD_SPECIAL_ATTACKS.axe_sword_special_primary)
DUAL_WIELD_SPECIAL_ATTACKS.sword_sword_special_secondary = table.clone(DUAL_WIELD_SPECIAL_ATTACKS.axe_sword_special_secondary)
DUAL_WIELD_ATTACKS.left_alternated = table.clone(DUAL_WIELD_ATTACKS.left_start)
DUAL_WIELD_ATTACKS.left_alternated.attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.55
DUAL_WIELD_ATTACKS.left_alternated.anim_event = "swing_attack_left"
DUAL_WIELD_ATTACKS.left_alternated.sweep.delay = 0.55
DUAL_WIELD_ATTACKS.left_alternated.sweep.end_delay = 0.75
DUAL_WIELD_ATTACKS.left_repeated = table.clone(DUAL_WIELD_ATTACKS.left_start)
DUAL_WIELD_ATTACKS.left_repeated.attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.85
DUAL_WIELD_ATTACKS.left_repeated.anim_event = "swing_attack_left_repeated"
DUAL_WIELD_ATTACKS.left_repeated.sweep.delay = (DEFAULT_SWING_MINIMUM_POSE_TIME + 0.35) / DUAL_WIELD_ATTACKS.left_repeated.attack_time
DUAL_WIELD_ATTACKS.left_repeated.sweep.end_delay = 0.8
DUAL_WIELD_ATTACKS.right_alternated = table.clone(DUAL_WIELD_ATTACKS.right_start)
DUAL_WIELD_ATTACKS.right_alternated.attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.55
DUAL_WIELD_ATTACKS.right_alternated.anim_event = "swing_attack_right"
DUAL_WIELD_ATTACKS.right_alternated.sweep.delay = 0.55
DUAL_WIELD_ATTACKS.right_alternated.sweep.end_delay = 0.75
DUAL_WIELD_ATTACKS.right_repeated = table.clone(DUAL_WIELD_ATTACKS.right_start)
DUAL_WIELD_ATTACKS.right_repeated.attack_time = DEFAULT_SWING_MINIMUM_POSE_TIME + 0.85
DUAL_WIELD_ATTACKS.right_repeated.anim_event = "swing_attack_right_repeated"
DUAL_WIELD_ATTACKS.right_repeated.sweep.delay = (DEFAULT_SWING_MINIMUM_POSE_TIME + 0.22) / DUAL_WIELD_ATTACKS.right_repeated.attack_time
DUAL_WIELD_ATTACKS.right_repeated.sweep.end_delay = 0.72

local upper_body_attacks = {}

for attack, attack_settings in pairs(DUAL_WIELD_ATTACKS) do
	new_attack_settings = table.clone(attack_settings)
	new_attack_settings.anim_event = new_attack_settings.anim_event .. "_upper_body"
	upper_body_attacks[attack .. "_upper_body"] = new_attack_settings
end

for attack, attack_settings in pairs(upper_body_attacks) do
	DUAL_WIELD_ATTACKS[attack] = attack_settings
end

for _, weapon_name in ipairs({
	"axe_1h",
	"sword_1h"
}) do
	local weapon_table = GearTemplates[weapon_name].attacks

	for attack, settings in pairs(DUAL_WIELD_ATTACKS) do
		weapon_table[attack] = table.clone(settings)

		if weapon_name == "axe_1h" then
			local sweep = weapon_table[attack].sweep

			sweep[1] = DEFAULT_1H_AXE_SWEEP_1
			sweep[2] = DEFAULT_1H_AXE_SWEEP_2
			sweep[3] = DEFAULT_1H_AXE_SWEEP_3
			sweep[4] = DEFAULT_1H_AXE_SWEEP_4
			weapon_table[attack].abort_on_hit = true
		elseif weapon_name == "sword_1h" then
			local sweep = weapon_table[attack].sweep

			sweep[1] = DEFAULT_1H_SWORD_RIGHT_1
			sweep[2] = DEFAULT_1H_SWORD_RIGHT_2
			sweep[3] = nil
			sweep[4] = nil
		end
	end

	for attack, settings in pairs(DUAL_WIELD_SPECIAL_ATTACKS) do
		weapon_table[attack] = table.clone(settings)

		if weapon_name == "axe_1h" then
			local sweep = weapon_table[attack].sweep

			if sweep then
				sweep[1] = DEFAULT_1H_AXE_SWEEP_1
				sweep[2] = DEFAULT_1H_AXE_SWEEP_2
				sweep[3] = DEFAULT_1H_AXE_SWEEP_3
				sweep[4] = DEFAULT_1H_AXE_SWEEP_4
			end
		elseif weapon_name == "sword_1h" then
			local sweep = weapon_table[attack].sweep

			if sweep then
				sweep[1] = DEFAULT_1H_SWORD_RIGHT_1
				sweep[2] = DEFAULT_1H_SWORD_RIGHT_2
				sweep[3] = nil
				sweep[4] = nil
			end
		end
	end
end

if not GameSettingsDevelopment.allow_kick then
	GearTemplates.dagger.special = nil
end

for template_name, template in pairs(GearTemplates) do
	template.sound_gear_type = template.sound_gear_type or template.gear_type

	if template.sweep_collision then
		for attack_name, attack in pairs(template.attacks) do
			local sweep = attack.sweep

			fassert(sweep or attack.player_sweep, "[GearTemplates] Missing sweep/player_sweep definition for attack \"%s\" in gear template \"%s\".", attack_name, template_name)

			if type(sweep) == "table" then
				for i, sweep_table in ipairs(sweep) do
					fassert(type(sweep_table.inner_node) == "string", "[GearTemplates] Missing inner_node in sweep for sweep %i in attack \"%s\" in gear template \"%s\".", i, attack_name, template_name)
					fassert(type(sweep_table.outer_node) == "string", "[GearTemplates] Missing outer_node in sweep for sweep %i in attack \"%s\" in gear template \"%s\".", i, attack_name, template_name)
					fassert(type(sweep_table.width) == "number", "[GearTemplates] Missing width in sweep for sweep %i in attack \"%s\" in gear template \"%s\".", i, attack_name, template_name)
					fassert(type(sweep_table.thickness) == "number", "[GearTemplates] Missing thickness in sweep for sweep %i in attack \"%s\" in gear template \"%s\".", i, attack_name, template_name)
					fassert(type(sweep_table.hit_callback) == "string", "[GearTemplates] Missing hit_callback in sweep for sweep %i in attack \"%s\" in gear template \"%s\".", i, attack_name, template_name)
				end
			elseif sweep then
				fassert(type(sweep.inner_node) == "string", "[GearTemplates] Missing inner_node in sweep for attack \"%s\" in gear template \"%s\".", attack_name, template_name)
				fassert(type(sweep.outer_node) == "string", "[GearTemplates] Missing outer_node in sweep for attack \"%s\" in gear template \"%s\".", attack_name, template_name)
				fassert(type(sweep.width) == "number", "[GearTemplates] Missing width in sweep for attack \"%s\" in gear template \"%s\".", attack_name, template_name)
				fassert(type(sweep.thickness) == "number", "[GearTemplates] Missing thickness in sweep for attack \"%s\" in gear template \"%s\".", attack_name, template_name)
			end
		end
	end

	local category = template.category

	if category == "throwing_weapon" then
		template.ammo_lootable = true
	else
		template.ammo_lootable = false
	end
end

local function check_node(gear_summary_table, verbose, unit_name, gear_name, attack_name, sweep, placement, unit, node, i)
	if not Unit.has_node(unit, node) then
		if verbose then
			printf("Gear %q with unit %q is missing %s-%snode %q in sweep %q in attack %q", gear_name, unit_name, sweep, placement, node, tostring(i), attack_name)
		else
			gear_summary_table[unit_name] = gear_summary_table[unit_name] or {}
			gear_summary_table[unit_name][node] = true
		end

		return false
	end

	return true
end

function check_physics_actor(gear_summary_table, verbose, unit_name, gear_name, actor_name, unit)
	local index = Unit.find_actor(unit, actor_name)

	if not index and verbose then
		printf("Gear %q with unit %q is missing %q actor", gear_name, unit_name, actor_name)
	elseif not index then
		gear_summary_table[unit_name] = gear_summary_table[unit_name] or {}
		gear_summary_table[unit_name][actor_name] = true
	end
end

function test_weapon_collision_nodes(gear_table, verbose)
	local world = Application.main_world()
	local gear_summary_table = {}
	local all_ok = true

	for gear_name, gear_settings in pairs(gear_table) do
		local unit_name = gear_settings.unit
		local unit = World.spawn_unit(world, unit_name)

		for attack_name, attack_settings in pairs(gear_settings.attacks) do
			local sweeps = attack_settings.sweep

			if sweeps then
				for i, sweep_settings in ipairs(sweeps) do
					all_ok = all_ok and check_node(gear_summary_table, verbose, unit_name, gear_name, attack_name, "sweep", "inner", unit, sweep_settings.inner_node, i)
					all_ok = all_ok and check_node(gear_summary_table, verbose, unit_name, gear_name, attack_name, "sweep", "outer", unit, sweep_settings.outer_node, i)
				end
			end

			if attack_name == "throw" then
				check_physics_actor(gear_summary_table, verbose, unit_name, gear_name, "thrown", unit)
			end
		end

		if gear_settings.gear_type ~= "dagger" then
			check_physics_actor(gear_summary_table, verbose, unit_name, gear_name, "dropped", unit)
		end

		World.destroy_unit(world, unit)
	end

	if not verbose then
		for unit_name, nodes in pairs(gear_summary_table) do
			printf("%s is missing:", unit_name)

			for node, _ in pairs(nodes) do
				printf("\t%s", node)
			end
		end
	end

	if all_ok then
		print("All gear checks out ok.")
	end
end
