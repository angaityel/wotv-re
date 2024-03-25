-- chunkname: @scripts/settings/player_unit_damage_settings.lua

PlayerUnitDamageSettings = PlayerUnitDamageSettings or {}
PlayerUnitDamageSettings.MAX_HP = 100
PlayerUnitDamageSettings.KD_MAX_HP = 50
PlayerUnitDamageSettings.REGEN_DELAY = 6
PlayerUnitDamageSettings.REGEN_AMOUNT = 20
PlayerUnitDamageSettings.REGEN_RAMP_SPEED = 1

function PlayerUnitDamageSettings.REGEN_FUNCTION(real_t)
	local t = real_t * PlayerUnitDamageSettings.REGEN_RAMP_SPEED

	return PlayerUnitDamageSettings.REGEN_AMOUNT * t * t
end

PlayerUnitDamageSettings.INSTAKILL_THRESHOLD = 100
PlayerUnitDamageSettings.INSTAKILL_HEALTH_FACTOR = 0
PlayerUnitDamageSettings.BANDAGED_HP = 120
PlayerUnitDamageSettings.REVIVED_HP = 120
PlayerUnitDamageSettings.REVIVE_TIME = 5
PlayerUnitDamageSettings.DAMAGE_VIGNETTE_BLEND_OUT = 0.3
PlayerUnitDamageSettings.DAMAGE_VIGNETTE_THRESHOLD = 2
PlayerUnitDamageSettings.MULTIPLE_HIT_MULTIPLIER = 0.5
PlayerUnitDamageSettings.LAST_DAMAGE_DEALER_RESET_TIME = 15
PlayerUnitDamageSettings.stun = PlayerUnitDamageSettings.stun or {}
PlayerUnitDamageSettings.stun.duration = 0.9
PlayerUnitDamageSettings.stun_dismount = PlayerUnitDamageSettings.stun_dismount or {}
PlayerUnitDamageSettings.stun_dismount.duration = 1.6666666666666667
PlayerUnitDamageSettings.stun_push = PlayerUnitDamageSettings.stun_push or {}
PlayerUnitDamageSettings.stun_push.duration = 1.2
PlayerUnitDamageSettings.stun_push.hit_penalty = 0.5
PlayerUnitDamageSettings.stun_push.cooldown = 1
PlayerUnitDamageSettings.stun_shield_bash = PlayerUnitDamageSettings.stun_shield_bash or {}
PlayerUnitDamageSettings.stun_shield_bash.duration = 1.5
PlayerUnitDamageSettings.stun_shield_bash.hit_penalty = 0.1
PlayerUnitDamageSettings.stun_shield_bash.cooldown = 1
PlayerUnitDamageSettings.death_vfx = {
	decap = {
		{
			node = "Neck",
			name = "fx/impact_blood_squirt"
		}
	},
	default = {
		{
			node = "Neck",
			name = "fx/impact_blood_squirt"
		}
	}
}
PlayerUnitDamageSettings.kd_bleeding = PlayerUnitDamageSettings.kd_bleeding or {}
PlayerUnitDamageSettings.kd_bleeding.dps = 0
PlayerUnitDamageSettings.dead_player_destroy_time = 5
PlayerUnitDamageSettings.dot_types = {
	bleeding = {},
	burning = {}
}
PlayerUnitDamageSettings.hit_zones = {
	head = {
		damage_multiplier_ranged = 1.5,
		hit_stat = "hits_head",
		damage_multiplier = 1.25,
		damage_stat = "damage_head",
		ragdoll_actor = "Head",
		actors = {
			"c_head"
		},
		forward = Vector3Box(0, -1, 0)
	},
	helmet = {
		damage_multiplier_ranged = 1.5,
		hit_stat = "hits_head",
		damage_multiplier = 1.25,
		damage_stat = "damage_head",
		ragdoll_actor = "Head",
		actors = {
			"helmet"
		},
		forward = Vector3Box(0, -1, 0)
	},
	torso = {
		damage_stat = "damage_torso",
		hit_stat = "hits_torso",
		damage_multiplier = 1,
		ragdoll_actor = "Spine2",
		actors = {
			"c_spine2"
		},
		forward = Vector3Box(0, -1, 0)
	},
	stomach = {
		damage_stat = "damage_stomach",
		hit_stat = "hits_stomach",
		damage_multiplier = 1,
		ragdoll_actor = "Spine",
		actors = {
			"c_hips",
			"c_spine",
			"c_spine1"
		},
		forward = Vector3Box(0, -1, 0)
	},
	arms = {
		damage_stat = "damage_arms",
		hit_stat = "hits_arms",
		damage_multiplier = 1,
		ragdoll_actor = "RightArm",
		actors = {
			"c_leftarm",
			"c_rightarm"
		},
		forward = Vector3Box(0, -1, 0)
	},
	forearms = {
		damage_stat = "damage_arms",
		hit_stat = "hits_arms",
		damage_multiplier = 1,
		ragdoll_actor = "RightForeArm",
		actors = {
			"c_leftforearm",
			"c_rightforearm"
		},
		forward = Vector3Box(0, -1, 0)
	},
	hands = {
		damage_stat = "damage_arms",
		hit_stat = "hits_arms",
		damage_multiplier = 1,
		ragdoll_actor = "RightHand",
		actors = {
			"c_lefthand",
			"c_righthand"
		},
		forward = Vector3Box(0, -1, 0)
	},
	legs = {
		damage_stat = "damage_legs",
		hit_stat = "hits_legs",
		damage_multiplier = 1,
		ragdoll_actor = "RightUpLeg",
		actors = {
			"c_leftupleg",
			"c_rightupleg"
		},
		forward = Vector3Box(0, -1, 0)
	},
	calfs = {
		damage_stat = "damage_legs",
		hit_stat = "hits_legs",
		damage_multiplier = 0.5,
		ragdoll_actor = "RightLeg",
		actors = {
			"c_leftleg",
			"c_rightleg"
		},
		forward = Vector3Box(0, -1, 0)
	},
	feet = {
		damage_stat = "damage_legs",
		hit_stat = "hits_legs",
		damage_multiplier = 0.25,
		ragdoll_actor = "RightFoot",
		actors = {
			"c_leftfoot",
			"c_rightfoot"
		},
		forward = Vector3Box(0, -1, 0)
	}
}
