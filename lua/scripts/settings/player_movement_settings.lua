-- chunkname: @scripts/settings/player_movement_settings.lua

require("scripts/settings/player_unit_damage_settings")

local function STAMINA_CHAIN_USE_COST_FUNCTION(self, data, t)
	local old_multiplier = data.multiplier
	local old_t = data.t
	local multiplier = math.max(1, old_multiplier - (t - old_t) * self.multiplier_decay_rate)

	return multiplier
end

local function STAMINA_CHAIN_USE_UPDATE_FUNCTION(self, data, t, old_multiplier)
	data.multiplier = old_multiplier + self.multiplier_increase
	data.t = t
end

PlayerUnitMovementSettings = PlayerUnitMovementSettings or {}
PlayerUnitMovementSettings.functions = PlayerUnitMovementSettings.functions or {}

function PlayerUnitMovementSettings.functions.SIN(t)
	return math.sin(t)
end

function PlayerUnitMovementSettings.functions.LOG(t)
	return math.log(t)
end

function PlayerUnitMovementSettings.functions.QUAD(t)
	return t * t
end

PlayerUnitMovementSettings.FWD_MOVE_SPEED_SCALE = 1
PlayerUnitMovementSettings.BWD_MOVE_SPEED_SCALE = 0.85
PlayerUnitMovementSettings.STRAFE_MOVE_SPEED_SCALE = 1
PlayerUnitMovementSettings.maximum_z_speed_swinging = 0.3 * math.pi

local ENC_LIGHT = 0.8
local ENC_METER = 18.16
local ENC_HEAVY = 34.18
local ENC_MAX = 100

PlayerUnitMovementSettings.slope_traversion = PlayerUnitMovementSettings.slope_traversion or {}
PlayerUnitMovementSettings.slope_traversion.max_angle = math.pi * 0.27
PlayerUnitMovementSettings.slope_traversion.standing_frames = 1
PlayerUnitMovementSettings.slope_traversion.jump_disallowed_frames = 10
PlayerUnitMovementSettings.slope_traversion.crouch_step_up = 0.15
PlayerUnitMovementSettings.slope_traversion.aim_step_up = 0.15
PlayerUnitMovementSettings.crouch_move_speed = 1.4
PlayerUnitMovementSettings.move_speed = 3.255
PlayerUnitMovementSettings.backward_move_scale = 0.698
PlayerUnitMovementSettings.strafe_move_scale = 0.955
PlayerUnitMovementSettings.travel_mode = PlayerUnitMovementSettings.travel_mode or {}
PlayerUnitMovementSettings.travel_mode.speed = 5
PlayerUnitMovementSettings.travel_mode.ramp_up_time = 1.6
PlayerUnitMovementSettings.travel_mode.tackle_stun_duration = 3.2
PlayerUnitMovementSettings.travel_mode.damage_stun_duration = 2.45
PlayerUnitMovementSettings.travel_mode.camera_shake = {
	{
		time = 1.8,
		shake = "travel_mode_footstep_"
	},
	{
		time = 0.8,
		shake = "travel_mode_light_footstep_"
	}
}
PlayerUnitMovementSettings.travel_mode.camera_speed_up_delay = 0.3
PlayerUnitMovementSettings.travel_mode.override_recharge_rate = 0.025
PlayerUnitMovementSettings.travel_mode.stamina_settings = PlayerUnitMovementSettings.travel_mode.stamina_settings or {}
PlayerUnitMovementSettings.travel_mode.stamina_settings.minimum_activation_cost = 0
PlayerUnitMovementSettings.travel_mode.stamina_settings.activation_cost = 0
PlayerUnitMovementSettings.travel_mode.stamina_settings.recharge_delay = 0
PlayerUnitMovementSettings.travel_mode.tackle = PlayerUnitMovementSettings.travel_mode.tackle or {}
PlayerUnitMovementSettings.travel_mode.tackle.charge_type = "tackle"
PlayerUnitMovementSettings.travel_mode.tackle.collision_filter = "tackle_sweep"
PlayerUnitMovementSettings.travel_mode.tackle.can_hit_statics = false
PlayerUnitMovementSettings.travel_mode.tackle.max_speed = 9.5
PlayerUnitMovementSettings.travel_mode.tackle.range = 4.5
PlayerUnitMovementSettings.travel_mode.tackle.duration = 3
PlayerUnitMovementSettings.travel_mode.tackle.max_at = 0.2
PlayerUnitMovementSettings.travel_mode.tackle.falloff_at = 0.5
PlayerUnitMovementSettings.travel_mode.tackle.falloff_to = PlayerUnitMovementSettings.move_speed
PlayerUnitMovementSettings.travel_mode.tackle.stun_last_chase_mode_hit_timer = 0.3
PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings = PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings or {}
PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings.minimum_activation_cost = 0
PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings.activation_cost = 0
PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings.recharge_delay = 0
PlayerUnitMovementSettings.travel_mode.tackle.animations = {}
PlayerUnitMovementSettings.travel_mode.tackle.animations.start = "charge_start"
PlayerUnitMovementSettings.travel_mode.tackle.animations.finish = "charge_finished"
PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit = PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit or {}
PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit.name = "charge_hit_hard"
PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit.variable = PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit.variable or {}
PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit.variable.name = "charge_hit_hard_penalty_time"
PlayerUnitMovementSettings.travel_mode.tackle.animations.hard_hit.variable.value = 1
PlayerUnitMovementSettings.travel_mode.tackle.animations.soft_hit = "charge_finished"
PlayerUnitMovementSettings.travel_mode.tackle.hard_hit_penalty_time = 1
PlayerUnitMovementSettings.travel_mode.tackle.soft_hit_penalty_time = 0
PlayerUnitMovementSettings.travel_mode.tackle.sounds = {}
PlayerUnitMovementSettings.travel_mode.tackle.sounds.start = "chr_vce_push"
PlayerUnitMovementSettings.chase_mode = PlayerUnitMovementSettings.chase_mode or {}
PlayerUnitMovementSettings.chase_mode.movement_multiplier = 1.1
PlayerUnitMovementSettings.chase_mode.back_max_angle = math.pi * 0.25
PlayerUnitMovementSettings.chase_mode.back_max_angle_travel_mode = math.half_pi
PlayerUnitMovementSettings.chase_mode.last_hit_timeout = 4
PlayerUnitMovementSettings.chase_mode.max_distance = 50
PlayerUnitMovementSettings.chase_mode.raycast_height_offset = 0.2

function PlayerUnitMovementSettings.movement_acceleration(dt, current_speed, target_speed, encumbrance_factor)
	local acceleration = 1.35 * (math.abs(current_speed - target_speed) + 3) * dt * encumbrance_factor

	if target_speed < current_speed then
		return math.max(current_speed - acceleration, target_speed)
	else
		return math.min(current_speed + acceleration, target_speed)
	end
end

PlayerUnitMovementSettings.double_time = PlayerUnitMovementSettings.double_time or {}
PlayerUnitMovementSettings.double_time.move_speed = 1.5
PlayerUnitMovementSettings.double_time.timer_time = 3
PlayerUnitMovementSettings.double_time.ramp_up_time = 0.5
PlayerUnitMovementSettings.double_time.ramp_down_time = 1.5
PlayerUnitMovementSettings.double_time.rotation_penalty_multiplier = 0.001
PlayerUnitMovementSettings.lock_camera_when_attacking_time = 0.3
PlayerUnitMovementSettings.jump = PlayerUnitMovementSettings.jump or {}
PlayerUnitMovementSettings.jump.stamina_cost = 0
PlayerUnitMovementSettings.jump.stamina_settings = PlayerUnitMovementSettings.jump.stamina_settings or {}
PlayerUnitMovementSettings.jump.stamina_settings.minimum_activation_cost = 0
PlayerUnitMovementSettings.jump.stamina_settings.activation_cost = 0.05
PlayerUnitMovementSettings.jump.forward_jump = PlayerUnitMovementSettings.jump.forward_jump or {}
PlayerUnitMovementSettings.jump.forward_jump.minimum_horizontal_velocity = 3
PlayerUnitMovementSettings.jump.forward_jump.initial_vertical_velocity = 4
PlayerUnitMovementSettings.jump.stationary_jump = PlayerUnitMovementSettings.jump.stationary_jump or {}
PlayerUnitMovementSettings.jump.stationary_jump.initial_vertical_velocity = 4
PlayerUnitMovementSettings.fall = PlayerUnitMovementSettings.fall or {}
PlayerUnitMovementSettings.fall.heights = PlayerUnitMovementSettings.fall.heights or {}
PlayerUnitMovementSettings.fall.heights.dead = 9
PlayerUnitMovementSettings.fall.heights.knocked_down = 6
PlayerUnitMovementSettings.fall.heights.heavy = 3
PlayerUnitMovementSettings.landing = PlayerUnitMovementSettings.landing or {}
PlayerUnitMovementSettings.landing.anim_forced_upper_body_block = 0.3
PlayerUnitMovementSettings.mounted = PlayerUnitMovementSettings.mounted or {}
PlayerUnitMovementSettings.mounted.aim_target_constraint_left = -math.pi * 0.75
PlayerUnitMovementSettings.mounted.aim_target_constraint_right = math.pi * 0.75
PlayerUnitMovementSettings.mounted.use_lean = true
PlayerUnitMovementSettings.swing = PlayerUnitMovementSettings.swing or {}
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE = 0.003
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_UP = 2.5
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_DOWN = 0
PlayerUnitMovementSettings.swing.THRUST_TIMER = 0.15
PlayerUnitMovementSettings.swing.invert_pose_control_x = false
PlayerUnitMovementSettings.swing.invert_pose_control_y = false
PlayerUnitMovementSettings.swing.keyboard_controlled = false
PlayerUnitMovementSettings.swing.mounted_lean_swing_top = 0
PlayerUnitMovementSettings.swing.mounted_lean_swing_range = 30
PlayerUnitMovementSettings.swing.maximum_aim_constraint_z = 0.6
PlayerUnitMovementSettings.swing.stamina_settings = PlayerUnitMovementSettings.swing.stamina_settings or {}
PlayerUnitMovementSettings.swing.stamina_settings.minimum_activation_cost = 0.075
PlayerUnitMovementSettings.swing.stamina_settings.activation_cost = 0.15
PlayerUnitMovementSettings.swing.stamina_settings.chain_use = PlayerUnitMovementSettings.swing.stamina_settings.chain_use or {}
PlayerUnitMovementSettings.swing.stamina_settings.chain_use.cost_multiplier_function = STAMINA_CHAIN_USE_COST_FUNCTION
PlayerUnitMovementSettings.swing.stamina_settings.chain_use.update_multiplier_function = STAMINA_CHAIN_USE_UPDATE_FUNCTION
PlayerUnitMovementSettings.swing.stamina_settings.chain_use.multiplier_decay_rate = 0.5
PlayerUnitMovementSettings.swing.stamina_settings.chain_use.multiplier_increase = 1
PlayerUnitMovementSettings.riposte = PlayerUnitMovementSettings.riposte or {}
PlayerUnitMovementSettings.riposte.charge_time_multiplier = 0.75
PlayerUnitMovementSettings.riposte.minimum_charge_time_multiplier = 0.75
PlayerUnitMovementSettings.riposte.time_window = 1
PlayerUnitMovementSettings.special_attack = PlayerUnitMovementSettings.special_attack or {}
PlayerUnitMovementSettings.special_attack.interrupt_swing_recovery = 0.1
PlayerUnitMovementSettings.special_attack.stamina_settings = PlayerUnitMovementSettings.special_attack.stamina_settings or {}
PlayerUnitMovementSettings.special_attack.stamina_settings.minimum_activation_cost = 0.3
PlayerUnitMovementSettings.special_attack.stamina_settings.activation_cost = 0.4
PlayerUnitMovementSettings.combo_special_attack = PlayerUnitMovementSettings.combo_special_attack or {}
PlayerUnitMovementSettings.combo_special_attack.stamina_settings = PlayerUnitMovementSettings.combo_special_attack.stamina_settings or {}
PlayerUnitMovementSettings.combo_special_attack.stamina_settings.minimum_activation_cost = 0.2
PlayerUnitMovementSettings.combo_special_attack.stamina_settings.activation_cost = 0.2
PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings = PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings or {}
PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings.minimum_activation_cost = 0.1
PlayerUnitMovementSettings.combo_special_attack.followup_attack_stamina_settings.activation_cost = 0.1
PlayerUnitMovementSettings.backstab = PlayerUnitMovementSettings.backstab or {}
PlayerUnitMovementSettings.backstab.charge_type = "backstab"
PlayerUnitMovementSettings.backstab.collision_filter = "tackle_sweep"
PlayerUnitMovementSettings.backstab.last_chase_mode_hit_timer = 0.1
PlayerUnitMovementSettings.backstab.max_speed = 4
PlayerUnitMovementSettings.backstab.duration = 0.4
PlayerUnitMovementSettings.backstab.max_at = 0
PlayerUnitMovementSettings.backstab.falloff_at = 0.4
PlayerUnitMovementSettings.backstab.falloff_to = PlayerUnitMovementSettings.move_speed
PlayerUnitMovementSettings.backstab.stamina_settings = PlayerUnitMovementSettings.backstab.stamina_settings or {}
PlayerUnitMovementSettings.backstab.stamina_settings.minimum_activation_cost = 0
PlayerUnitMovementSettings.backstab.stamina_settings.activation_cost = 0
PlayerUnitMovementSettings.backstab.stamina_settings.recharge_delay = 0
PlayerUnitMovementSettings.backstab.animations = PlayerUnitMovementSettings.backstab.animations or {}
PlayerUnitMovementSettings.backstab.animations.start = PlayerUnitMovementSettings.backstab.animations.start or {}
PlayerUnitMovementSettings.backstab.animations.start.name = "backstab_attack_start"
PlayerUnitMovementSettings.backstab.animations.start.variable = PlayerUnitMovementSettings.backstab.animations.start.anim_var or {}
PlayerUnitMovementSettings.backstab.animations.start.variable.name = "attack_time"
PlayerUnitMovementSettings.backstab.animations.start.variable.value = 0.4
PlayerUnitMovementSettings.backstab.animations.finish = "attack_finished"
PlayerUnitMovementSettings.backstab.animations.hard_hit = "charge_hit_hard"
PlayerUnitMovementSettings.backstab.animations.soft_hit = "attack_hit_soft"
PlayerUnitMovementSettings.backstab.hard_hit_penalty_time = 0
PlayerUnitMovementSettings.backstab.soft_hit_penalty_time = 1
PlayerUnitMovementSettings.backstab.sounds = PlayerUnitMovementSettings.backstab.sounds or {}
PlayerUnitMovementSettings.backstab.sounds.start = "chr_vce_push"
PlayerUnitMovementSettings.rush = PlayerUnitMovementSettings.rush or {}
PlayerUnitMovementSettings.rush.charge_type = "rush"
PlayerUnitMovementSettings.rush.can_hit_statics = true
PlayerUnitMovementSettings.rush.collision_filter = "melee_trigger"
PlayerUnitMovementSettings.rush.max_speed = 7
PlayerUnitMovementSettings.rush.duration = 1
PlayerUnitMovementSettings.rush.max_at = 0.4
PlayerUnitMovementSettings.rush.falloff_at = 0.6
PlayerUnitMovementSettings.rush.falloff_to = PlayerUnitMovementSettings.move_speed
PlayerUnitMovementSettings.rush.hard_hit_penalty_time = 1
PlayerUnitMovementSettings.rush.stun_front_duration = 1.5
PlayerUnitMovementSettings.rush.stun_back_duration = 1.5
PlayerUnitMovementSettings.rush.stamina_settings = PlayerUnitMovementSettings.rush.stamina_settings or {}
PlayerUnitMovementSettings.rush.stamina_settings.minimum_activation_cost = 0.6
PlayerUnitMovementSettings.rush.stamina_settings.activation_cost = 0.6
PlayerUnitMovementSettings.rush.stamina_settings.recharge_delay = 4
PlayerUnitMovementSettings.rush.animations = PlayerUnitMovementSettings.rush.animations or {}
PlayerUnitMovementSettings.rush.animations.start = "charge_start"
PlayerUnitMovementSettings.rush.animations.finish = "charge_finished"
PlayerUnitMovementSettings.rush.animations.hard_hit = PlayerUnitMovementSettings.rush.animations.hard_hit or {}
PlayerUnitMovementSettings.rush.animations.hard_hit.name = "charge_hit_hard"
PlayerUnitMovementSettings.rush.animations.hard_hit.variable = PlayerUnitMovementSettings.rush.animations.hard_hit.variable or {}
PlayerUnitMovementSettings.rush.animations.hard_hit.variable.name = "charge_hit_hard_penalty_time"
PlayerUnitMovementSettings.rush.animations.hard_hit.variable.value = 1
PlayerUnitMovementSettings.rush.animations.soft_hit = "charge_finished"
PlayerUnitMovementSettings.rush.hard_hit_penalty_time = 1
PlayerUnitMovementSettings.rush.soft_hit_penalty_time = 0
PlayerUnitMovementSettings.rush.sounds = PlayerUnitMovementSettings.rush.sounds or {}
PlayerUnitMovementSettings.rush.sounds.start = "chr_vce_push"
PlayerUnitMovementSettings.yield = PlayerUnitMovementSettings.yield or {}
PlayerUnitMovementSettings.yield.delay = 1.5
PlayerUnitMovementSettings.special_attack_interrupt_swing_recovery = 0.1
PlayerUnitMovementSettings.dodge_interrupt_swing_recovery = 0.1
PlayerUnitMovementSettings.dodge = PlayerUnitMovementSettings.dodge or {}
PlayerUnitMovementSettings.dodge.left = PlayerUnitMovementSettings.dodge.left or {}
PlayerUnitMovementSettings.dodge.left.duration = 0.83
PlayerUnitMovementSettings.dodge.left.attack_trigger_time = 0.4
PlayerUnitMovementSettings.dodge.left.attack_name = "dodge_left"
PlayerUnitMovementSettings.dodge.left.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.left.anim_time = 0.83
PlayerUnitMovementSettings.dodge.left.anim_event = "dodge_left_start"
PlayerUnitMovementSettings.dodge.left.blocking_anim_event = "dodge_block_left_start"
PlayerUnitMovementSettings.dodge.left.angle = -0.5 * math.pi
PlayerUnitMovementSettings.dodge.forward_left = PlayerUnitMovementSettings.dodge.forward_left or {}
PlayerUnitMovementSettings.dodge.forward_left.duration = 0.83
PlayerUnitMovementSettings.dodge.forward_left.attack_trigger_time = 0.4
PlayerUnitMovementSettings.dodge.forward_left.attack_name = "dodge_left"
PlayerUnitMovementSettings.dodge.forward_left.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.forward_left.anim_time = 0.83
PlayerUnitMovementSettings.dodge.forward_left.anim_event = "dodge_left_start"
PlayerUnitMovementSettings.dodge.forward_left.blocking_anim_event = "dodge_block_left_start"
PlayerUnitMovementSettings.dodge.forward_left.angle = -0.25 * math.pi
PlayerUnitMovementSettings.dodge.right = PlayerUnitMovementSettings.dodge.right or {}
PlayerUnitMovementSettings.dodge.right.duration = 0.83
PlayerUnitMovementSettings.dodge.right.attack_trigger_time = 0.4
PlayerUnitMovementSettings.dodge.right.attack_name = "dodge_right"
PlayerUnitMovementSettings.dodge.right.angle = 0.5 * math.pi
PlayerUnitMovementSettings.dodge.right.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.right.anim_time = 0.83
PlayerUnitMovementSettings.dodge.right.anim_event = "dodge_right_start"
PlayerUnitMovementSettings.dodge.right.blocking_anim_event = "dodge_block_right_start"
PlayerUnitMovementSettings.dodge.forward_right = PlayerUnitMovementSettings.dodge.forward_right or {}
PlayerUnitMovementSettings.dodge.forward_right.duration = 0.83
PlayerUnitMovementSettings.dodge.forward_right.attack_trigger_time = 0.4
PlayerUnitMovementSettings.dodge.forward_right.attack_name = "dodge_right"
PlayerUnitMovementSettings.dodge.forward_right.angle = 0.25 * math.pi
PlayerUnitMovementSettings.dodge.forward_right.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.forward_right.anim_time = 0.83
PlayerUnitMovementSettings.dodge.forward_right.anim_event = "dodge_right_start"
PlayerUnitMovementSettings.dodge.forward_right.blocking_anim_event = "dodge_block_right_start"
PlayerUnitMovementSettings.dodge.forward = PlayerUnitMovementSettings.dodge.forward or {}
PlayerUnitMovementSettings.dodge.forward.duration = 0.83
PlayerUnitMovementSettings.dodge.forward.attack_trigger_time = 0.4
PlayerUnitMovementSettings.dodge.forward.attack_name = "dodge_forward"
PlayerUnitMovementSettings.dodge.forward.angle = 0
PlayerUnitMovementSettings.dodge.forward.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.forward.anim_time = 0.83
PlayerUnitMovementSettings.dodge.forward.anim_event = "dodge_fwd_start"
PlayerUnitMovementSettings.dodge.forward.blocking_anim_event = "dodge_block_fwd_start"
PlayerUnitMovementSettings.dodge.backward = PlayerUnitMovementSettings.dodge.backward or {}
PlayerUnitMovementSettings.dodge.backward.duration = 0.76
PlayerUnitMovementSettings.dodge.backward.attack_trigger_time = 0.55
PlayerUnitMovementSettings.dodge.backward.attack_name = "dodge_backward"
PlayerUnitMovementSettings.dodge.backward.angle = math.pi
PlayerUnitMovementSettings.dodge.backward.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.backward.anim_time = 0.83
PlayerUnitMovementSettings.dodge.backward.anim_event = "dodge_bwd_start"
PlayerUnitMovementSettings.dodge.backward.blocking_anim_event = "dodge_block_bwd_start"
PlayerUnitMovementSettings.dodge.backward_left = PlayerUnitMovementSettings.dodge.backward_left or {}
PlayerUnitMovementSettings.dodge.backward_left.duration = 0.76
PlayerUnitMovementSettings.dodge.backward_left.attack_trigger_time = 0.55
PlayerUnitMovementSettings.dodge.backward_left.attack_name = "dodge_backward"
PlayerUnitMovementSettings.dodge.backward_left.angle = -math.pi * 0.75
PlayerUnitMovementSettings.dodge.backward_left.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.backward_left.anim_time = 0.83
PlayerUnitMovementSettings.dodge.backward_left.anim_event = "dodge_bwd_start"
PlayerUnitMovementSettings.dodge.backward_left.blocking_anim_event = "dodge_block_bwd_start"
PlayerUnitMovementSettings.dodge.backward_right = PlayerUnitMovementSettings.dodge.backward_right or {}
PlayerUnitMovementSettings.dodge.backward_right.duration = 0.76
PlayerUnitMovementSettings.dodge.backward_right.attack_trigger_time = 0.55
PlayerUnitMovementSettings.dodge.backward_right.attack_name = "dodge_backward"
PlayerUnitMovementSettings.dodge.backward_right.angle = math.pi * 0.75
PlayerUnitMovementSettings.dodge.backward_right.movement_multiplier = 0.7
PlayerUnitMovementSettings.dodge.backward_right.anim_time = 0.83
PlayerUnitMovementSettings.dodge.backward_right.anim_event = "dodge_bwd_start"
PlayerUnitMovementSettings.dodge.backward_right.blocking_anim_event = "dodge_block_bwd_start"

local DODGE_MIN_ACTIVATION_COST = 0.2
local DODGE_ACTIVATION_COST = 0.2
local DODGE_RECHARGE_DELAY = 0.83
local DODGE_STAMINA_SETTINGS = {
	minimum_activation_cost = DODGE_MIN_ACTIVATION_COST,
	activation_cost = DODGE_ACTIVATION_COST,
	recharge_delay = DODGE_RECHARGE_DELAY,
	chain_use = {
		multiplier_decay_rate = 0.375,
		multiplier_increase = 1.25,
		cost_multiplier_function = STAMINA_CHAIN_USE_COST_FUNCTION,
		update_multiplier_function = STAMINA_CHAIN_USE_UPDATE_FUNCTION
	}
}
local DODGE_ATTACK_STAMINA_SETTINGS = {
	activation_cost = 0,
	minimum_activation_cost = 0
}

for direction, dodge in pairs(PlayerUnitMovementSettings.dodge) do
	dodge.attack_stamina_settings = DODGE_ATTACK_STAMINA_SETTINGS
	dodge.stamina_settings = DODGE_STAMINA_SETTINGS
end

local DEFAULT_DODGE_BLOCK_SWEEP = {
	height = 0.4,
	depth = 0.2,
	forward_offset = 0.4,
	end_time = 0.5,
	node = "c_neck",
	width = 0.4,
	start_time = 0
}

PlayerUnitMovementSettings.dodge_block = table.clone(PlayerUnitMovementSettings.dodge)

for _, dodge in pairs(PlayerUnitMovementSettings.dodge_block) do
	dodge.anim_event = dodge.blocking_anim_event
end

PlayerUnitMovementSettings.stamina = PlayerUnitMovementSettings.stamina or {}
PlayerUnitMovementSettings.stamina.recharge_delay = 1
PlayerUnitMovementSettings.stamina.recharge_rate = 0.1
PlayerUnitMovementSettings.stamina.tired_threshold = 0.5
PlayerUnitMovementSettings.stamina.exhausted_threshold = 0.25

function PlayerUnitMovementSettings.stamina.minimum_pose_time_function(stamina)
	local t = math.clamp(math.auto_lerp(0.8, 0.2, 0, 1, stamina), 0, 1)

	return 1 + math.lerp(0, 0.5, t^2)
end

function PlayerUnitMovementSettings.stamina.swing_time_function(stamina)
	local t = math.clamp(math.auto_lerp(0.8, 0.2, 0, 1, stamina), 0, 1)

	return 1 + math.lerp(0, 0.25, t^2)
end

PlayerUnitMovementSettings.parry = PlayerUnitMovementSettings.parry or {}
PlayerUnitMovementSettings.parry.stamina_per_damage = 0.001375
PlayerUnitMovementSettings.parry.override_recharge_rate = 0.025
PlayerUnitMovementSettings.parry.REQUIRED_MOVEMENT_TO_POSE = 0.003
PlayerUnitMovementSettings.parry.invert_parry_control_x = false
PlayerUnitMovementSettings.parry.invert_parry_control_y = false
PlayerUnitMovementSettings.parry.keyboard_controlled = false
PlayerUnitMovementSettings.parry.raise_delay = 0.13
PlayerUnitMovementSettings.dual_wield_defend = PlayerUnitMovementSettings.dual_wield_defend or {}
PlayerUnitMovementSettings.dual_wield_defend.stamina_per_damage = 0
PlayerUnitMovementSettings.block = PlayerUnitMovementSettings.block or {}
PlayerUnitMovementSettings.block.stamina_per_damage = 0.001375
PlayerUnitMovementSettings.block.consecutive_block_impact_time = 4
PlayerUnitMovementSettings.block.consecutive_block_impact_multiplier = 1.5
PlayerUnitMovementSettings.block.override_recharge_rate = 0.025

function PlayerUnitMovementSettings.block.aim_direction_pitch_function(z)
	PlayerUnitMovementSettings.block.raise_delay = 0

	return 1.25 * (z - 0)
end

PlayerUnitMovementSettings.encumbrance = PlayerUnitMovementSettings.encumbrance or {}
PlayerUnitMovementSettings.encumbrance.functions = PlayerUnitMovementSettings.encumbrance.functions or {}

function PlayerUnitMovementSettings.encumbrance.functions.pose_time(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.reload_time(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.movement_acceleration(enc)
	return 1.4
end

function PlayerUnitMovementSettings.encumbrance.functions.double_time_speed(enc)
	if enc < ENC_LIGHT then
		return 0.97
	elseif enc < ENC_METER then
		return math.auto_lerp(ENC_LIGHT, ENC_METER, 0.97, 1, enc)
	elseif enc < ENC_HEAVY then
		return math.auto_lerp(ENC_METER, ENC_HEAVY, 1, 1.04, enc)
	else
		return math.auto_lerp(ENC_HEAVY, ENC_MAX, 1.04, 1.15, enc)
	end
end

function PlayerUnitMovementSettings.encumbrance.functions.charge_duration(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.charge_cooldown(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.charge_speed(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.climbing_ladders_speed(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.miss_penalty(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.not_penetrated_penalty(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.parried_penalty(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.hard_penalty(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.blocked_penalty(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.double_time_acceleration(enc)
	if enc < ENC_LIGHT then
		return 0.95
	elseif enc < ENC_METER then
		return math.auto_lerp(ENC_LIGHT, ENC_METER, 0.95, 1, enc)
	elseif enc < ENC_HEAVY then
		return math.auto_lerp(ENC_METER, ENC_HEAVY, 1, 1.05, enc)
	else
		return math.auto_lerp(ENC_HEAVY, ENC_MAX, 1.05, 1.15, enc)
	end
end

function PlayerUnitMovementSettings.encumbrance.functions.ammo_regen_rate(enc)
	if enc < ENC_LIGHT then
		return 1.5
	elseif enc < ENC_METER then
		return math.auto_lerp(ENC_LIGHT, ENC_METER, 1.5, 1, enc)
	elseif enc < ENC_HEAVY then
		return math.auto_lerp(ENC_METER, ENC_HEAVY, 1, 0.5, enc)
	else
		return math.auto_lerp(ENC_HEAVY, ENC_MAX, 0.5, 0.25, enc)
	end
end

function PlayerUnitMovementSettings.encumbrance.functions.stun_time(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.heavy_landing_height(enc)
	if enc < ENC_LIGHT then
		return 1.5
	elseif enc < ENC_METER then
		return math.auto_lerp(ENC_LIGHT, ENC_METER, 1.5, 1, enc)
	elseif enc < ENC_HEAVY then
		return math.auto_lerp(ENC_METER, ENC_HEAVY, 1, 0.75, enc)
	else
		return math.auto_lerp(ENC_HEAVY, ENC_MAX, 0.75, 0.65, enc)
	end
end

function PlayerUnitMovementSettings.encumbrance.functions.movement_speed_backwards(enc)
	return 1
end

function PlayerUnitMovementSettings.encumbrance.functions.movement_speed_strafe(enc)
	return 1
end

PlayerUnitMovementSettings.auto_interaction = {}
PlayerUnitMovementSettings.auto_interaction.priorities = {
	"ammo_loot"
}
PlayerUnitMovementSettings.auto_interaction.settings = {
	ammo_loot = {}
}
PlayerUnitMovementSettings.interaction = PlayerUnitMovementSettings.interaction or {}
PlayerUnitMovementSettings.interaction[1] = PlayerUnitMovementSettings.interaction[1] or {}
PlayerUnitMovementSettings.interaction[1].key = "interact"
PlayerUnitMovementSettings.interaction[1].key_hold = "interacting"
PlayerUnitMovementSettings.interaction[1].state_data_name = "interaction"
PlayerUnitMovementSettings.interaction[1].state_data_arg1 = "interaction_arg1"
PlayerUnitMovementSettings.interaction[1].state_data_arg2 = "interaction_arg2"
PlayerUnitMovementSettings.interaction[1].priorities = {
	"backstab",
	"travel_mode_tackle",
	"revive",
	"bandage",
	"climb",
	"trigger",
	"switch_item"
}
PlayerUnitMovementSettings.interaction[1].settings = {
	flag_plant = {
		duration = 5
	},
	execute = {
		begin_anim_event = "idle",
		duration = 5.3,
		duration_after_kill = 0,
		end_anim_event = "execute_attacker_end"
	},
	revive = {
		lock_player = true,
		animation_time_var = "revive_team_mate_time",
		duration = 1.2,
		begin_anim_event = "revive_team_mate",
		end_anim_event = "revive_team_mate_end"
	},
	bandage = {
		initiate_distance = 2,
		break_distance = 3,
		duration = 3,
		begin_anim_event = "bandage_team_mate",
		end_anim_event = "bandage_end"
	},
	bandage_self = {
		break_distance = 2,
		duration = 6,
		begin_anim_event = "bandage_self",
		end_anim_event = "bandage_end"
	},
	climb = {
		speed = 1
	},
	trigger = {
		duration = 2
	}
}
PlayerUnitMovementSettings.interaction[2] = PlayerUnitMovementSettings.interaction[2] or {}
PlayerUnitMovementSettings.interaction[2].priorities = {
	"loot",
	"loot_trap"
}
PlayerUnitMovementSettings.interaction[2].state_data_name = "interaction_loot"
PlayerUnitMovementSettings.interaction[2].state_data_arg1 = "interaction_loot_arg1"
PlayerUnitMovementSettings.interaction[2].state_data_arg2 = "interaction_loot_arg2"
PlayerUnitMovementSettings.interaction[2].key = "loot"
PlayerUnitMovementSettings.interaction[2].key_hold = "looting"
PlayerUnitMovementSettings.interaction[2].settings = {
	loot = {
		lock_player = true,
		animation_time_var = "revive_team_mate_time",
		duration = 0.5,
		begin_anim_event = "revive_team_mate",
		end_anim_event = "revive_team_mate_end"
	},
	loot_trap = {
		lock_player = true,
		animation_time_var = "revive_team_mate_time",
		duration = 3,
		begin_anim_event = "revive_team_mate",
		end_anim_event = "revive_team_mate_end"
	}
}
PlayerUnitMovementSettings.base_taunts = PlayerUnitMovementSettings.base_taunts or {}
PlayerUnitMovementSettings.base_taunts.techno_viking = PlayerUnitMovementSettings.base_taunts.techno_viking or {}
PlayerUnitMovementSettings.base_taunts.techno_viking.start_anim_event = "emote_technoviking"
PlayerUnitMovementSettings.base_taunts.techno_viking.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.techno_viking.duration = 11.333333333333334
PlayerUnitMovementSettings.base_taunts.techno_viking.minimum_duration = 0
PlayerUnitMovementSettings.base_taunts.techno_viking.loop = true
PlayerUnitMovementSettings.base_taunts.techno_viking.ui_texture = "emote_technoviking"
PlayerUnitMovementSettings.base_taunts.techno_viking.market_price = 36200
PlayerUnitMovementSettings.base_taunts.techno_viking.ui_sort_index = 15
PlayerUnitMovementSettings.base_taunts.techno_viking.release_name = "main"
PlayerUnitMovementSettings.base_taunts.warcry = PlayerUnitMovementSettings.base_taunts.warcry or {}
PlayerUnitMovementSettings.base_taunts.warcry.start_anim_event = "emote_warcry"
PlayerUnitMovementSettings.base_taunts.warcry.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.warcry.duration = 3.2666666666666666
PlayerUnitMovementSettings.base_taunts.warcry.ui_texture = "emote_warcry"
PlayerUnitMovementSettings.base_taunts.warcry.market_price = 22100
PlayerUnitMovementSettings.base_taunts.warcry.ui_sort_index = 10
PlayerUnitMovementSettings.base_taunts.warcry.release_name = "main"
PlayerUnitMovementSettings.base_taunts.cheer = PlayerUnitMovementSettings.base_taunts.cheer or {}
PlayerUnitMovementSettings.base_taunts.cheer.start_anim_event = "emote_cheer"
PlayerUnitMovementSettings.base_taunts.cheer.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.cheer.duration = 3
PlayerUnitMovementSettings.base_taunts.cheer.ui_texture = "emote_cheer"
PlayerUnitMovementSettings.base_taunts.cheer.market_price = 10400
PlayerUnitMovementSettings.base_taunts.cheer.ui_sort_index = 3
PlayerUnitMovementSettings.base_taunts.cheer.release_name = "main"
PlayerUnitMovementSettings.base_taunts.wolfhowl = PlayerUnitMovementSettings.base_taunts.wolfhowl or {}
PlayerUnitMovementSettings.base_taunts.wolfhowl.start_anim_event = "emote_wolfhowl"
PlayerUnitMovementSettings.base_taunts.wolfhowl.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.wolfhowl.duration = 3
PlayerUnitMovementSettings.base_taunts.wolfhowl.ui_texture = "emote_wolfhowl"
PlayerUnitMovementSettings.base_taunts.wolfhowl.market_price = 8200
PlayerUnitMovementSettings.base_taunts.wolfhowl.ui_sort_index = 1
PlayerUnitMovementSettings.base_taunts.wolfhowl.release_name = "main"
PlayerUnitMovementSettings.base_taunts.the_what = PlayerUnitMovementSettings.base_taunts.the_what or {}
PlayerUnitMovementSettings.base_taunts.the_what.start_anim_event = "emote_the_what"
PlayerUnitMovementSettings.base_taunts.the_what.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.the_what.duration = 3.6666666666666665
PlayerUnitMovementSettings.base_taunts.the_what.ui_texture = "emote_the_what"
PlayerUnitMovementSettings.base_taunts.the_what.market_price = 19200
PlayerUnitMovementSettings.base_taunts.the_what.ui_sort_index = 8
PlayerUnitMovementSettings.base_taunts.the_what.release_name = "main"
PlayerUnitMovementSettings.base_taunts.slowclap = PlayerUnitMovementSettings.base_taunts.slowclap or {}
PlayerUnitMovementSettings.base_taunts.slowclap.start_anim_event = "emote_slowclap"
PlayerUnitMovementSettings.base_taunts.slowclap.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.slowclap.duration = 4.666666666666667
PlayerUnitMovementSettings.base_taunts.slowclap.ui_texture = "emote_slowclap"
PlayerUnitMovementSettings.base_taunts.slowclap.market_price = 23600
PlayerUnitMovementSettings.base_taunts.slowclap.ui_sort_index = 11
PlayerUnitMovementSettings.base_taunts.slowclap.release_name = "main"
PlayerUnitMovementSettings.base_taunts.applause = PlayerUnitMovementSettings.base_taunts.applause or {}
PlayerUnitMovementSettings.base_taunts.applause.start_anim_event = "emote_applause"
PlayerUnitMovementSettings.base_taunts.applause.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.applause.duration = 2.6666666666666665
PlayerUnitMovementSettings.base_taunts.applause.ui_texture = "emote_applause"
PlayerUnitMovementSettings.base_taunts.applause.market_price = 11600
PlayerUnitMovementSettings.base_taunts.applause.ui_sort_index = 4
PlayerUnitMovementSettings.base_taunts.applause.release_name = "main"
PlayerUnitMovementSettings.base_taunts.bow = PlayerUnitMovementSettings.base_taunts.bow or {}
PlayerUnitMovementSettings.base_taunts.bow.start_anim_event = "emote_bow"
PlayerUnitMovementSettings.base_taunts.bow.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.bow.duration = 2.6666666666666665
PlayerUnitMovementSettings.base_taunts.bow.ui_texture = "emote_bow"
PlayerUnitMovementSettings.base_taunts.bow.market_price = 14800
PlayerUnitMovementSettings.base_taunts.bow.ui_sort_index = 6
PlayerUnitMovementSettings.base_taunts.bow.release_name = "main"
PlayerUnitMovementSettings.base_taunts.charge = PlayerUnitMovementSettings.base_taunts.charge or {}
PlayerUnitMovementSettings.base_taunts.charge.start_anim_event = "emote_charge"
PlayerUnitMovementSettings.base_taunts.charge.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.charge.duration = 2.3333333333333335
PlayerUnitMovementSettings.base_taunts.charge.ui_texture = "emote_charge"
PlayerUnitMovementSettings.base_taunts.charge.market_price = 12200
PlayerUnitMovementSettings.base_taunts.charge.ui_sort_index = 5
PlayerUnitMovementSettings.base_taunts.charge.release_name = "main"
PlayerUnitMovementSettings.base_taunts.cheers_drink = PlayerUnitMovementSettings.base_taunts.cheers_drink or {}
PlayerUnitMovementSettings.base_taunts.cheers_drink.start_anim_event = "emote_cheers_drink"
PlayerUnitMovementSettings.base_taunts.cheers_drink.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.cheers_drink.duration = 4
PlayerUnitMovementSettings.base_taunts.cheers_drink.ui_texture = "emote_cheers_drink"
PlayerUnitMovementSettings.base_taunts.cheers_drink.market_price = 28400
PlayerUnitMovementSettings.base_taunts.cheers_drink.ui_sort_index = 14
PlayerUnitMovementSettings.base_taunts.cheers_drink.release_name = "main"
PlayerUnitMovementSettings.base_taunts.cut_throat = PlayerUnitMovementSettings.base_taunts.cut_throat or {}
PlayerUnitMovementSettings.base_taunts.cut_throat.start_anim_event = "emote_cut_throat"
PlayerUnitMovementSettings.base_taunts.cut_throat.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.cut_throat.duration = 2.8333333333333335
PlayerUnitMovementSettings.base_taunts.cut_throat.ui_texture = "emote_cut_throat"
PlayerUnitMovementSettings.base_taunts.cut_throat.market_price = 24300
PlayerUnitMovementSettings.base_taunts.cut_throat.ui_sort_index = 12
PlayerUnitMovementSettings.base_taunts.cut_throat.release_name = "main"
PlayerUnitMovementSettings.base_taunts.laugh = PlayerUnitMovementSettings.base_taunts.laugh or {}
PlayerUnitMovementSettings.base_taunts.laugh.start_anim_event = "emote_laugh"
PlayerUnitMovementSettings.base_taunts.laugh.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.laugh.duration = 3.6666666666666665
PlayerUnitMovementSettings.base_taunts.laugh.ui_texture = "emote_laugh"
PlayerUnitMovementSettings.base_taunts.laugh.market_price = 15700
PlayerUnitMovementSettings.base_taunts.laugh.ui_sort_index = 7
PlayerUnitMovementSettings.base_taunts.laugh.release_name = "main"
PlayerUnitMovementSettings.base_taunts.praise_god = PlayerUnitMovementSettings.base_taunts.praise_god or {}
PlayerUnitMovementSettings.base_taunts.praise_god.start_anim_event = "emote_praise_god"
PlayerUnitMovementSettings.base_taunts.praise_god.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.praise_god.duration = 3
PlayerUnitMovementSettings.base_taunts.praise_god.ui_texture = "emote_praise_god"
PlayerUnitMovementSettings.base_taunts.praise_god.market_price = 9600
PlayerUnitMovementSettings.base_taunts.praise_god.ui_sort_index = 2
PlayerUnitMovementSettings.base_taunts.praise_god.release_name = "main"
PlayerUnitMovementSettings.base_taunts.riverdance = PlayerUnitMovementSettings.base_taunts.riverdance or {}
PlayerUnitMovementSettings.base_taunts.riverdance.start_anim_event = "emote_riverdance"
PlayerUnitMovementSettings.base_taunts.riverdance.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.riverdance.duration = 8
PlayerUnitMovementSettings.base_taunts.riverdance.ui_texture = "emote_riverdance"
PlayerUnitMovementSettings.base_taunts.riverdance.market_price = 25800
PlayerUnitMovementSettings.base_taunts.riverdance.ui_sort_index = 13
PlayerUnitMovementSettings.base_taunts.riverdance.release_name = "main"
PlayerUnitMovementSettings.base_taunts.two_finger_salute = PlayerUnitMovementSettings.base_taunts.two_finger_salute or {}
PlayerUnitMovementSettings.base_taunts.two_finger_salute.start_anim_event = "emote_two_finger_salute"
PlayerUnitMovementSettings.base_taunts.two_finger_salute.end_anim_event = "emote_finished"
PlayerUnitMovementSettings.base_taunts.two_finger_salute.duration = 2.6666666666666665
PlayerUnitMovementSettings.base_taunts.two_finger_salute.ui_texture = "emote_two_finger_salute"
PlayerUnitMovementSettings.base_taunts.two_finger_salute.market_price = 21500
PlayerUnitMovementSettings.base_taunts.two_finger_salute.ui_sort_index = 9
PlayerUnitMovementSettings.base_taunts.two_finger_salute.release_name = "main"
PlayerUnitMovementSettings.taunts = {}

for name, taunt in pairs(PlayerUnitMovementSettings.base_taunts) do
	taunt.name = name
	taunt.ui_header = name
	taunt.ui_sort_index = taunt.ui_sort_index or 1
	taunt.market_price = taunt.market_price or 3000
	taunt.entity_type = "taunt"
	taunt.minimum_duration = taunt.minimum_duration or 2
	PlayerUnitMovementSettings.taunts[name] = taunt
end

PlayerUnitMovementSettings.ghost_mode = {
	local_actors = {
		"c_hips",
		"c_leftupleg",
		"c_leftleg",
		"c_leftfoot",
		"c_rightupleg",
		"c_rightleg",
		"c_rightfoot",
		"c_spine",
		"c_spine1",
		"c_spine2",
		"c_leftarm",
		"c_leftforearm",
		"c_lefthand",
		"c_rightarm",
		"c_rightforearm",
		"c_righthand",
		"afro_projectile_trigger",
		"simple_hit_box"
	},
	husk_actors = {
		"c_hips",
		"c_leftupleg",
		"c_leftleg",
		"c_leftfoot",
		"c_rightupleg",
		"c_rightleg",
		"c_rightfoot",
		"c_spine",
		"c_spine1",
		"c_spine2",
		"c_leftarm",
		"c_leftforearm",
		"c_lefthand",
		"c_rightarm",
		"c_rightforearm",
		"c_righthand",
		"c_afro",
		"interaction_shape",
		"husk",
		"simple_hit_box"
	}
}

function default_taunt_unlocks()
	local default_unlocks = {}
	local entity_type = "taunt"

	for name, taunt in pairs(PlayerUnitMovementSettings.taunts) do
		if not taunt.market_price or taunt.unlock_this_item then
			default_unlocks[name] = {
				category = entity_type,
				name = name
			}
		end
	end

	return default_unlocks
end

PlayerUnitMovementSettings.knocked_down_anim = PlayerUnitMovementSettings.knocked_down_anim or {}
PlayerUnitMovementSettings.knocked_down_anim.names = PlayerUnitMovementSettings.knocked_down_anim.names or {}
PlayerUnitMovementSettings.knocked_down_anim.names = {
	"front_facing",
	"bleed_out",
	"back_slash",
	"back_cut",
	"front_piercing",
	"front_torso"
}
PlayerUnitMovementSettings.knocked_down_anim.front_facing = PlayerUnitMovementSettings.knocked_down_anim.front_facing or {}
PlayerUnitMovementSettings.knocked_down_anim.front_facing = {
	"knocked_down_face_left_front_cut",
	"knocked_down_face_right_front_cut",
	"knocked_down_face_front_blunt"
}
PlayerUnitMovementSettings.knocked_down_anim.bleed_out = PlayerUnitMovementSettings.knocked_down_anim.bleed_out or {}
PlayerUnitMovementSettings.knocked_down_anim.bleed_out = {
	"knocked_down_generic_fall_front",
	"knocked_down_generic_fall_right"
}
PlayerUnitMovementSettings.knocked_down_anim.back_slash = PlayerUnitMovementSettings.knocked_down_anim.back_slash or {}
PlayerUnitMovementSettings.knocked_down_anim.back_slash = {
	"knocked_down_torso_back_cut",
	"knocked_down_torso_back_cut_02",
	"knocked_down_torso_back_cut_03",
	"knocked_down_torso_back_cut_04"
}
PlayerUnitMovementSettings.knocked_down_anim.back_cut = PlayerUnitMovementSettings.knocked_down_anim.back_cut or {}
PlayerUnitMovementSettings.knocked_down_anim.back_cut = {
	"knocked_down_torso_back_cut",
	"knocked_down_torso_back_cut_02",
	"knocked_down_torso_back_cut_03",
	"knocked_down_torso_back_cut_04"
}
PlayerUnitMovementSettings.knocked_down_anim.front_piercing = PlayerUnitMovementSettings.knocked_down_anim.front_piercing or {}
PlayerUnitMovementSettings.knocked_down_anim.front_piercing = {
	"knocked_down_torso_front_stomach_pierce",
	"knocked_down_torso_front_stomach_pierce_02",
	"knocked_down_torso_front_stomach_pierce_03"
}
PlayerUnitMovementSettings.knocked_down_anim.front_torso = PlayerUnitMovementSettings.knocked_down_anim.front_torso or {}
PlayerUnitMovementSettings.knocked_down_anim.front_torso = {
	"knocked_down_torso_front_cut_02",
	"knocked_down_torso_front_cut_03",
	"knocked_down_face_front_blunt"
}
BerserkMovementSettings = table.clone(PlayerUnitMovementSettings)
BerserkMovementSettings.move_speed = 3.7432499999999997
BerserkMovementSettings.crouch_move_speed = 2
BerserkMovementSettings.backward_move_scale = math.lerp(PlayerUnitMovementSettings.backward_move_scale, 1, 0.55)
BerserkMovementSettings.strafe_move_scale = math.lerp(PlayerUnitMovementSettings.strafe_move_scale, 1, 0.55)

for direction, settings in pairs(BerserkMovementSettings.dodge) do
	local dodge_settings = PlayerUnitMovementSettings.dodge[direction]

	settings.duration = 0.5
	settings.stamina_settings.minimum_activation_cost = dodge_settings.stamina_settings.minimum_activation_cost * 0.5
	settings.stamina_settings.activation_cost = dodge_settings.stamina_settings.activation_cost * 0.5
	settings.stamina_settings.chain_use.multiplier_decay_rate = 0.3125
	settings.stamina_settings.chain_use.multiplier_increase = 1.2
	settings.stamina_settings.recharge_delay = 2.5

	if direction == "backward" or direction == "backward_left" or direction == "backward_right" then
		settings.attack_trigger_time = 0.5
	else
		settings.attack_trigger_time = 0.4
	end
end

function BerserkMovementSettings.encumbrance.functions.movement_acceleration(enc)
	return 2.8
end

BerserkMovementSettings.stamina.recharge_delay = 1.7
BerserkMovementSettings.stamina.recharge_rate = 0.4
HeavyMovementSettings = table.clone(PlayerUnitMovementSettings)

function HeavyMovementSettings.encumbrance.functions.movement_acceleration(enc)
	return 1
end
