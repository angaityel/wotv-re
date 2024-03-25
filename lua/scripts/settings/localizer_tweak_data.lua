﻿-- chunkname: @scripts/settings/localizer_tweak_data.lua

LocalizerTweakData = {
	bow_zoom_minimum_yards = string.format("%2.0f", Perks.bow_zoom.minimum_yards_before_bonus),
	bow_zoom_multiplier = Perks.bow_zoom.damage_multiplier_tweak,
	faster_melee_charge_buffer_multiplier = Perks.faster_melee_charge.charge_buffer_multiplier,
	faster_melee_charge_speed_multiplier = string.format("%0.0f", (1 - Perks.faster_melee_charge.charge_speed_multiplier) * 100),
	chase_faster_speed_multiplier = string.format("%2.0f", (Perks.chase_faster.chase_mode_speed_multiplier - 1) * 100),
	chase_faster_angle_multiplier = string.format("%2.0f", (Perks.chase_faster.chase_angle_multiplier - 1) * 100),
	faster_bow_charge_speed_multiplier = string.format("%2.0f", Perks.faster_bow_charge.charge_speed_multiplier * 100),
	faster_bow_charge_speed_duration = Perks.faster_bow_charge.charge_speed_duration,
	flaming_arrows_duration = Perks.flaming_arrows.duration,
	heal_on_kill_health = Perks.heal_on_kill.health_per_sec,
	heal_on_kill_duration = Perks.heal_on_kill.duration,
	armour_heavy = string.format("%0.0f", Armours.armour_saxon_chainmail.absorption_value * 100),
	armour_medium = string.format("%0.0f", Armours.armour_viking_scalemail.absorption_value * 100),
	armour_light = string.format("%0.0f", Armours.armour_viking_padded.absorption_value * 100),
	armour_berserk = string.format("%0.0f", Armours.armour_viking_berserk.absorption_value * 100),
	heavy_stamina_recharge_multiplier = string.format("%0.0f", (1 - Perks.heavy_01.stamina_recharge_multiplier) * 100),
	light_head_shot_multiplier = string.format("%0.0f", (Perks.light_01.head_shot_multiplier - 1) * 100),
	light_stamina_multiplier = string.format("%0.0f", (1 - Perks.light_01.bow_stamina_multiplier) * 100),
	light_wield_time_multiplier = string.format("%0.0f", (1 / Perks.light_01.wield_time_multiplier - 1) * 100),
	light_travel_mode_stamina_rate = string.format("%0.0f", Perks.light_02.travel_mode_stamina_recharge_rate_multiplier * 100),
	piercing_shots_charge = Perks.piercing_shots.charge_buffer_multiplier,
	piercing_shots_enemies = Perks.piercing_shots.hit_enemies,
	heal_on_kill_duration = string.format("%0.0f", Perks.heal_on_kill.duration),
	heal_on_kill_heal = string.format("%0.0f", Perks.heal_on_kill.health_per_sec * Perks.heal_on_kill.duration),
	revive_yourself_delay = string.format("%0.0f", Perks.revive_yourself.time_start_revive),
	berserk_move_speed = string.format("%0.0f", (BerserkMovementSettings.move_speed / PlayerUnitMovementSettings.move_speed - 1) * 100),
	berserk_stamina_rate = string.format("%0.0f", (BerserkMovementSettings.stamina.recharge_rate / PlayerUnitMovementSettings.stamina.recharge_rate - 1) * 100),
	last_stand_duration = string.format("%0.0f", Perks.last_stand.duration),
	last_stand_damage_multiplier = string.format("%0.0f", (Perks.last_stand.damage_multiplier - 1) * 100),
	last_stand_move_speed = string.format("%0.0f", (Perks.last_stand.movement_speed_multiplier - 1) * 100),
	last_stand_heal = string.format("%0.0f", Perks.last_stand.health_back_on_kill)
}