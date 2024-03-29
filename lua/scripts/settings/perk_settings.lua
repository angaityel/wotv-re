﻿-- chunkname: @scripts/settings/perk_settings.lua

PerkSlots = {
	{
		game_object_field = "perk_1",
		name = "perk_1"
	},
	{
		game_object_field = "perk_2",
		name = "perk_2"
	},
	{
		game_object_field = "perk_3",
		name = "perk_3"
	},
	{
		game_object_field = "perk_4",
		name = "perk_4"
	}
}
Perks = Perks or {}
Perks.backstab = Perks.backstab or {}
Perks.backstab.damage = 120
Perks.backstab.attack_range = 1.5
Perks.backstab.charge_range = 2
Perks.backstab.charge_time = 1
Perks.backstab.ui_texture_bgr = "perk_basic_dummy"
Perks.backstab.ui_texture = "perk_icon_assassin_menu"
Perks.backstab.hud_texture_default = "perk_icon_assassin"
Perks.backstab.hud_texture_active = "perk_icon_assassin_lit"
Perks.backstab.default_state = "default"
Perks.backstab.market_price = 400
Perks.backstab.tier = 2
Perks.backstab.ui_sort_index = 4
Perks.backstab.activatable = true
Perks.backstab.release_name = "main"
Perks.blade_master = Perks.blade_master or {}
Perks.blade_master.ui_texture_bgr = "perk_basic_dummy"
Perks.blade_master.ui_texture = "perk_icon_blademaster_menu"
Perks.blade_master.hud_texture_default = "perk_icon_blademaster"
Perks.blade_master.hud_texture_active = "perk_icon_blademaster_lit"
Perks.blade_master.default_state = "inactive"
Perks.blade_master.speed_boost = {
	threshold_1 = 0.2,
	multiplier_y = 1.3,
	threshold_2 = 0.3,
	duration = 0,
	multiplier_x = 1.7
}
Perks.blade_master.heal_amount = 0
Perks.blade_master.stamina_amount = 0
Perks.blade_master.market_price = 400
Perks.blade_master.parry_attacker_stamina_loss = 0.075
Perks.blade_master.combat_text = "combat_text_blade_master"
Perks.blade_master.tier = 1
Perks.blade_master.ui_sort_index = 4
Perks.blade_master.release_name = "main"
Perks.stamina_on_kill = Perks.stamina_on_kill or {}
Perks.stamina_on_kill.stamina_back_on_kill = 1
Perks.stamina_on_kill.ui_texture_bgr = "perk_basic_dummy"
Perks.stamina_on_kill.ui_texture = "perk_icon_adrenaline_rush_menu"
Perks.stamina_on_kill.hud_texture_default = "perk_icon_adrenaline_rush"
Perks.stamina_on_kill.hud_texture_active = "perk_icon_adrenaline_rush_lit"
Perks.stamina_on_kill.default_state = "default"
Perks.stamina_on_kill.combat_text = "combat_text_stamina_on_kill"
Perks.stamina_on_kill.market_price = 400
Perks.stamina_on_kill.tier = 1
Perks.stamina_on_kill.ui_sort_index = 6
Perks.stamina_on_kill.release_name = "main"
Perks.dodge_attack = Perks.dodge_attack or {}
Perks.dodge_attack.ui_texture_bgr = "perk_basic_dummy"
Perks.dodge_attack.ui_texture = "perk_icon_agile_fighter_menu"
Perks.dodge_attack.hud_texture_default = "perk_icon_agile_fighter"
Perks.dodge_attack.hud_texture_active = "perk_icon_agile_fighter_lit"
Perks.dodge_attack.default_state = "default"
Perks.dodge_attack.market_price = 250
Perks.dodge_attack.tier = 2
Perks.dodge_attack.ui_sort_index = 1
Perks.dodge_attack.release_name = "main"
Perks.fake_death = Perks.fake_death or {}
Perks.fake_death.ui_texture_bgr = "perk_basic_dummy"
Perks.fake_death.ui_texture = "perk_icon_feign_death_menu"
Perks.fake_death.hud_texture_default = "perk_icon_feign_death"
Perks.fake_death.hud_texture_active = "perk_icon_feign_death_lit"
Perks.fake_death.default_state = "inactive"
Perks.fake_death.combat_text = "combat_text_fake_death"
Perks.fake_death.duration_before_controll = 2
Perks.fake_death.duration_getting_up = 1
Perks.fake_death.duration_exp_after_up = 6
Perks.fake_death.market_price = 400
Perks.fake_death.tier = 2
Perks.fake_death.ui_sort_index = 2
Perks.fake_death.activatable = true
Perks.fake_death.release_name = "main"
Perks.throw_all_weps = Perks.throw_all_weps or {}
Perks.throw_all_weps.ui_texture_bgr = "perk_basic_dummy"
Perks.throw_all_weps.ui_texture = "perk_icon_blind_fury_menu"
Perks.throw_all_weps.hud_texture_default = "perk_icon_blind_fury"
Perks.throw_all_weps.hud_texture_active = "perk_icon_blind_fury_lit"
Perks.throw_all_weps.default_state = "inactive"
Perks.throw_all_weps.market_price = 400
Perks.throw_all_weps.tier = 2
Perks.throw_all_weps.ui_sort_index = 7
Perks.throw_all_weps.release_name = "main"
Perks.heal_on_kill = Perks.heal_on_kill or {}
Perks.heal_on_kill.health_per_sec = 5
Perks.heal_on_kill.duration = 5
Perks.heal_on_kill.ui_texture_bgr = "perk_basic_dummy"
Perks.heal_on_kill.ui_texture = "perk_icon_bloodthurst_menu"
Perks.heal_on_kill.hud_texture_default = "perk_icon_blood_thirst"
Perks.heal_on_kill.hud_texture_active = "perk_icon_blood_thirst_lit"
Perks.heal_on_kill.default_state = "default"
Perks.heal_on_kill.xp_heal_requirement = 30
Perks.heal_on_kill.market_price = 400
Perks.heal_on_kill.tier = 1
Perks.heal_on_kill.ui_sort_index = 2
Perks.heal_on_kill.release_name = "main"
Perks.chase_faster = Perks.chase_faster or {}
Perks.chase_faster.chase_mode_speed_multiplier = 1.2
Perks.chase_faster.chase_mode_range_multiplier = 2
Perks.chase_faster.chase_angle_multiplier = 1.2
Perks.chase_faster.ui_texture_bgr = "perk_basic_dummy"
Perks.chase_faster.ui_texture = "perk_icon_chaser_menu"
Perks.chase_faster.hud_texture_default = "perk_icon_chaser"
Perks.chase_faster.hud_texture_active = "perk_icon_chaser_lit"
Perks.chase_faster.default_state = "default"
Perks.chase_faster.market_price = 250
Perks.chase_faster.tier = 1
Perks.chase_faster.ui_sort_index = 5
Perks.chase_faster.release_name = "main"
Perks.dodge_block = Perks.dodge_block or {}
Perks.dodge_block.block_stamina_multiplier = 0.5
Perks.dodge_block.ui_texture_bgr = "perk_basic_dummy"
Perks.dodge_block.ui_texture = "perk_icon_defender_menu"
Perks.dodge_block.hud_texture_default = "perk_icon_defender"
Perks.dodge_block.hud_texture_active = "perk_icon_defender_lit"
Perks.dodge_block.default_state = "default"
Perks.dodge_block.market_price = 250
Perks.dodge_block.tier = 2
Perks.dodge_block.ui_sort_index = 5
Perks.dodge_block.release_name = "main"
Perks.bow_zoom = Perks.bow_zoom or {}
Perks.bow_zoom.minimum_yards_before_bonus = 45.72
Perks.bow_zoom.damage_multiplier_tweak = 1
Perks.bow_zoom.ui_texture_bgr = "perk_basic_dummy"
Perks.bow_zoom.ui_texture = "perk_icon_eagle_eye_menu"
Perks.bow_zoom.hud_texture_default = "perk_icon_eagle_eye"
Perks.bow_zoom.hud_texture_active = "perk_icon_eagle_eye_lit"
Perks.bow_zoom.default_state = "default"
Perks.bow_zoom.market_price = 250
Perks.bow_zoom.tier = 3
Perks.bow_zoom.ui_sort_index = 3
Perks.bow_zoom.activatable = true
Perks.bow_zoom.release_name = "main"
Perks.flaming_arrows = Perks.flaming_arrows or {}
Perks.flaming_arrows.arrows_required_to_destroy_shield = 2
Perks.flaming_arrows.damage_multiplier = 1.2
Perks.flaming_arrows.percentage_done_as_dot = 0.5
Perks.flaming_arrows.duration = 10
Perks.flaming_arrows.ui_texture_bgr = "perk_basic_dummy"
Perks.flaming_arrows.ui_texture = "perk_icon_flaming_arrow_menu"
Perks.flaming_arrows.hud_texture_default = "perk_icon_flaming_arrow"
Perks.flaming_arrows.hud_texture_active = "perk_icon_flaming_arrow_lit"
Perks.flaming_arrows.default_state = "default"
Perks.flaming_arrows.market_price = 400
Perks.flaming_arrows.tier = 3
Perks.flaming_arrows.ui_sort_index = 4
Perks.flaming_arrows.release_name = "main"
Perks.heal_on_taunt = Perks.heal_on_taunt or {}
Perks.heal_on_taunt.ui_texture_bgr = "perk_basic_dummy"
Perks.heal_on_taunt.ui_texture = "perk_icon_gloater_menu"
Perks.heal_on_taunt.hud_texture_default = "perk_icon_gloater"
Perks.heal_on_taunt.hud_texture_active = "perk_icon_gloater_lit"
Perks.heal_on_taunt.default_state = "inactive"
Perks.heal_on_taunt.animation_name = "laugh"
Perks.heal_on_taunt.heal_amount = 100
Perks.heal_on_taunt.length = 10
Perks.heal_on_taunt.market_price = 250
Perks.heal_on_taunt.tier = 2
Perks.heal_on_taunt.ui_sort_index = 3
Perks.heal_on_taunt.release_name = "main"
Perks.faster_melee_charge = Perks.faster_melee_charge or {}
Perks.faster_melee_charge.charge_buffer_multiplier = 5
Perks.faster_melee_charge.charge_speed_multiplier = 0.5
Perks.faster_melee_charge.ui_texture_bgr = "perk_basic_dummy"
Perks.faster_melee_charge.ui_texture = "perk_icon_hard_hitter_menu"
Perks.faster_melee_charge.hud_texture_default = "perk_icon_hard_hitter"
Perks.faster_melee_charge.hud_texture_active = "perk_icon_hard_hitter_lit"
Perks.faster_melee_charge.default_state = "default"
Perks.faster_melee_charge.market_price = 250
Perks.faster_melee_charge.tier = 1
Perks.faster_melee_charge.ui_sort_index = 3
Perks.faster_melee_charge.release_name = "main"
Perks.auto_parry = Perks.auto_parry or {}
Perks.auto_parry.default_direction = nil
Perks.auto_parry.directions = {
	up = true,
	left = true,
	right = true
}
Perks.auto_parry.ui_texture_bgr = "perk_basic_dummy"
Perks.auto_parry.ui_texture = "perk_icon_parrey_menu"
Perks.auto_parry.hud_texture_default = "perk_icon_parrey"
Perks.auto_parry.hud_texture_active = "perk_icon_parrey_lit"
Perks.auto_parry.default_state = "default"
Perks.auto_parry.market_price = 250
Perks.auto_parry.tier = 1
Perks.auto_parry.ui_sort_index = 8
Perks.auto_parry.release_name = "main"
Perks.training_wheels = Perks.training_wheels or {}
Perks.training_wheels.ui_texture_bgr = "perk_basic_dummy"
Perks.training_wheels.ui_texture = "perk_icon_parrey_menu"
Perks.training_wheels.hud_texture_default = "perk_icon_parrey"
Perks.training_wheels.hud_texture_active = "perk_icon_parrey_lit"
Perks.training_wheels.default_state = "default"
Perks.training_wheels.market_price = 400
Perks.training_wheels.tier = 1
Perks.training_wheels.ui_sort_index = 8
Perks.training_wheels.damage_melee_total_multiplier = 0.8
Perks.training_wheels.release_name = "berserk"
Perks.no_knockdown = Perks.no_knockdown or {}
Perks.no_knockdown.combat_text = "perk_combat_text_no_knockdown"
Perks.no_knockdown.ui_texture_bgr = "perk_basic_dummy"
Perks.no_knockdown.ui_texture = "perk_icon_juggernaut_menu"
Perks.no_knockdown.hud_texture_default = "perk_icon_juggernaut"
Perks.no_knockdown.hud_texture_active = "perk_icon_juggernaut_lit"
Perks.no_knockdown.default_state = "default"
Perks.no_knockdown.market_price = 250
Perks.no_knockdown.tier = 1
Perks.no_knockdown.ui_sort_index = 7
Perks.no_knockdown.release_name = "main"
Perks.tag_on_bow_shot = Perks.tag_on_bow_shot or {}
Perks.tag_on_bow_shot.ui_texture_bgr = "perk_basic_dummy"
Perks.tag_on_bow_shot.ui_texture = "perk_icon_spotter_menu"
Perks.tag_on_bow_shot.hud_texture_default = "perk_icon_spotter"
Perks.tag_on_bow_shot.hud_texture_active = "perk_icon_spotter_lit"
Perks.tag_on_bow_shot.default_state = "default"
Perks.tag_on_bow_shot.market_price = 400
Perks.tag_on_bow_shot.tier = 3
Perks.tag_on_bow_shot.ui_sort_index = 2
Perks.tag_on_bow_shot.release_name = "main"
Perks.shield_bash = Perks.shield_bash or {}
Perks.shield_bash.ui_texture_bgr = "perk_basic_dummy"
Perks.shield_bash.ui_texture = "perk_icon_shield_fighter_menu"
Perks.shield_bash.hud_texture_default = "perk_icon_stone_wall"
Perks.shield_bash.hud_texture_active = "perk_icon_stone_wall_lit"
Perks.shield_bash.default_state = "default"
Perks.shield_bash.market_price = 250
Perks.shield_bash.tier = 2
Perks.shield_bash.ui_sort_index = 1
Perks.shield_bash.release_name = "main"
Perks.piercing_shots = Perks.piercing_shots or {}
Perks.piercing_shots.charge_buffer_multiplier = 5
Perks.piercing_shots.hit_enemies = 2
Perks.piercing_shots.ui_texture_bgr = "perk_basic_dummy"
Perks.piercing_shots.ui_texture = "perk_icon_piercing_shot_menu"
Perks.piercing_shots.hud_texture_default = "perk_icon_piercing_shot"
Perks.piercing_shots.hud_texture_active = "perk_icon_piercing_shot_lit"
Perks.piercing_shots.default_state = "default"
Perks.piercing_shots.market_price = 250
Perks.piercing_shots.tier = 3
Perks.piercing_shots.ui_sort_index = 5
Perks.piercing_shots.release_name = "main"
Perks.faster_bow_charge = Perks.faster_bow_charge or {}
Perks.faster_bow_charge.charge_speed_multiplier = 0.5
Perks.faster_bow_charge.charge_speed_duration = 5
Perks.faster_bow_charge.ui_texture_bgr = "perk_basic_dummy"
Perks.faster_bow_charge.ui_texture = "perk_icon_sure_shot_menu"
Perks.faster_bow_charge.hud_texture_default = "perk_icon_sure_shot"
Perks.faster_bow_charge.hud_texture_active = "perk_icon_sure_shot_lit"
Perks.faster_bow_charge.default_state = "default"
Perks.faster_bow_charge.market_price = 250
Perks.faster_bow_charge.tier = 3
Perks.faster_bow_charge.ui_sort_index = 1
Perks.faster_bow_charge.release_name = "main"
Perks.auto_aim = Perks.auto_aim or {}
Perks.auto_aim.ui_texture_bgr = "perk_basic_dummy"
Perks.auto_aim.ui_texture = "perk_shield_mockup"
Perks.auto_aim.hud_texture_default = "perk_shield_mockup"
Perks.auto_aim.hud_texture_active = "perk_shield_mockup"
Perks.auto_aim.default_state = "default"
Perks.auto_aim.market_price = 250
Perks.auto_aim.tier = 3
Perks.auto_aim.ui_sort_index = 7
Perks.auto_aim.release_name = "main"
Perks.revive_yourself = Perks.revive_yourself or {}
Perks.revive_yourself.ui_texture_bgr = "perk_basic_dummy"
Perks.revive_yourself.ui_texture = "perk_icon_strong_will_menu"
Perks.revive_yourself.hud_texture_default = "perk_icon_strong_will"
Perks.revive_yourself.hud_texture_active = "perk_icon_strong_will_lit"
Perks.revive_yourself.default_state = "default"
Perks.revive_yourself.time_start_revive = 5
Perks.revive_yourself.time_revived_and_kill_exp_bonus = 7
Perks.revive_yourself.voice_unit_first_revive = "chr_vce_finish_off"
Perks.revive_yourself.voice_husk_first_revive = "chr_vce_finish_off"
Perks.revive_yourself.voice_unit_successful_revive = "chr_vce_finish_off"
Perks.revive_yourself.voice_husk_successful_revive = "chr_vce_finish_off"
Perks.revive_yourself.market_price = 250
Perks.revive_yourself.tier = 2
Perks.revive_yourself.ui_sort_index = 8
Perks.revive_yourself.release_name = "main"
Perks.are_you_not_entertained = Perks.are_you_not_entertained or {}
Perks.are_you_not_entertained.ui_texture_bgr = "perk_basic_dummy"
Perks.are_you_not_entertained.ui_texture = "perk_icon_no_perk"
Perks.are_you_not_entertained.hud_texture_default = "perk_icon_no_perk"
Perks.are_you_not_entertained.hud_texture_active = "perk_icon_no_perk"
Perks.are_you_not_entertained.default_state = "default"
Perks.are_you_not_entertained.developer_item = true
Perks.are_you_not_entertained.market_price = 250
Perks.are_you_not_entertained.tier = 1
Perks.are_you_not_entertained.ui_sort_index = 9
Perks.are_you_not_entertained.activatable = true
Perks.are_you_not_entertained.release_name = "main"
Perks.light_01 = Perks.light_01 or {}
Perks.light_01.health_change_amount = 0
Perks.light_01.head_shot_multiplier = 1.3333333333333333
Perks.light_01.bow_stamina_multiplier = 0.7
Perks.light_01.wield_time_multiplier = 0.8
Perks.light_01.ui_texture_bgr = "perk_basic_dummy"
Perks.light_01.ui_texture = "perk_icon_skirmisher_menu"
Perks.light_01.hud_texture_default = "perk_icon_skirmisher"
Perks.light_01.hud_texture_active = "perk_icon_skirmisher_lit"
Perks.light_01.default_state = "default"
Perks.light_02 = Perks.light_02 or {}
Perks.light_02.bow_charge_time_multiplier = 0.8
Perks.light_02.travel_mode_stamina_recharge_rate_multiplier = 2
Perks.light_02.ui_texture_bgr = "perk_basic_dummy"
Perks.light_02.ui_texture = "perk_icon_quick_blood_menu"
Perks.light_02.hud_texture_default = "perk_icon_quick_blood"
Perks.light_02.hud_texture_active = "perk_icon_quick_blood_lit"
Perks.light_02.default_state = "default"
Perks.heavy_01 = Perks.heavy_01 or {}
Perks.heavy_01.health_change_amount = 0
Perks.heavy_01.stamina_recharge_multiplier = 0.9
Perks.heavy_01.ui_texture_bgr = "perk_basic_dummy"
Perks.heavy_01.ui_texture = "perk_icon_stubborn_menu"
Perks.heavy_01.hud_texture_default = "perk_icon_stubborn"
Perks.heavy_01.hud_texture_active = "perk_icon_stubborn_lit"
Perks.heavy_01.default_state = "default"
Perks.heavy_02 = Perks.heavy_02 or {}
Perks.heavy_02.damage_interupt_threshold = math.huge
Perks.heavy_02.combat_text = "perk_combat_text_heavy_02"
Perks.heavy_02.ui_texture_bgr = "perk_basic_dummy"
Perks.heavy_02.ui_texture = "perk_icon_brawler_menu"
Perks.heavy_02.hud_texture_default = "perk_icon_brawler"
Perks.heavy_02.hud_texture_active = "perk_icon_brawler_lit"
Perks.heavy_02.default_state = "default"
Perks.medium = Perks.medium or {}
Perks.medium.ui_texture_bgr = "perk_basic_dummy"
Perks.medium.ui_texture = "perk_icon_jack_of_all_trades_menu"
Perks.medium.hud_texture_default = "perk_icon_jack_of_all_trades"
Perks.medium.hud_texture_active = "perk_icon_jack_of_all_trades_lit"
Perks.medium.default_state = "default"
Perks.shield_maiden01 = Perks.shield_maiden01 or {}
Perks.shield_maiden01.ui_texture_bgr = "perk_basic_dummy"
Perks.shield_maiden01.ui_texture = "perk_icon_shield_fighter_menu"
Perks.shield_maiden01.hud_texture_default = "perk_icon_shield_fighter"
Perks.shield_maiden01.hud_texture_active = "perk_icon_shield_fighter_lit"
Perks.shield_maiden01.default_state = "default"
Perks.shield_maiden01.combat_text = "perk_combat_text_shield_maiden01"
Perks.shield_maiden01.stance_settings = {
	stance_duration = 1,
	shield_bash = "stance_shield_bash",
	minimum_time = 0.5,
	repeated_attack = "stance_special_repeated_stab",
	first_attack = "stance_special_initial_stab"
}
Perks.shield_maiden01.market_price = 300
Perks.shield_maiden01.tier = 2
Perks.shield_maiden02 = Perks.shield_maiden02 or {}
Perks.shield_maiden02.ui_texture_bgr = "perk_basic_dummy"
Perks.shield_maiden02.ui_texture = "perk_icon_maiden_of_war_menu"
Perks.shield_maiden02.hud_texture_default = "perk_icon_maiden_of_war"
Perks.shield_maiden02.hud_texture_active = "perk_icon_maiden_of_war_lit"
Perks.shield_maiden02.default_state = "default"
Perks.shield_maiden02.protective_bandage_self_animation = "bandage_self_block"
Perks.shield_maiden02.protective_revive_animation = "revive_team_mate_block"
Perks.shield_maiden02.combat_text = "perk_combat_text_shield_maiden02"
Perks.shield_maiden02.blocking_hit_zones = {
	head = {
		penetration_value = 0,
		absorption_value = 0,
		armour_type = "none"
	}
}
Perks.shield_maiden02.blocking_absorption_value = 0.4
Perks.shield_maiden02.market_price = 300
Perks.shield_maiden02.tier = 2
Perks.berserk_01 = Perks.berserk_01 or {}
Perks.berserk_01.ui_texture_bgr = "perk_basic_dummy"
Perks.berserk_01.ui_texture = "perk_icon_born_warrior"
Perks.berserk_01.hud_texture_default = "perk_icon_born_warrior"
Perks.berserk_01.hud_texture_active = "perk_icon_born_warrior_lit"
Perks.berserk_01.default_state = "default"
Perks.berserk_01.market_price = 300
Perks.berserk_01.tier = 2
Perks.berserk_01.release_name = "main"
Perks.last_stand = Perks.last_stand or {}
Perks.last_stand.disallow_defending = true
Perks.last_stand.movement_speed_multiplier = 1.1
Perks.last_stand.back_movement_speed_multiplier = 0.9090909090909091
Perks.last_stand.strafe_movement_speed_multiplier = 0.9302325581395349
Perks.last_stand.damage_multiplier = 1.2
Perks.last_stand.ignore_ranged_damage = true
Perks.last_stand.health_back_on_kill = 50
Perks.last_stand.duration = 12
Perks.last_stand.combat_text = "combat_text_last_stand"
Perks.last_stand.ui_texture_bgr = "perk_basic_dummy"
Perks.last_stand.ui_texture = "perk_icon_furious_rage_manu"
Perks.last_stand.hud_texture_default = "perk_icon_furious_rage"
Perks.last_stand.hud_texture_active = "perk_icon_furious_rage_lit"
Perks.last_stand.default_state = "default"
Perks.last_stand.market_price = 250
Perks.last_stand.tier = 1
Perks.last_stand.release_name = "main"
Perks.endless_stamina = Perks.endless_stamina or {}
Perks.endless_stamina.damage_per_stamina = 100
Perks.endless_stamina.ui_texture_bgr = "perk_basic_dummy"
Perks.endless_stamina.ui_texture = "perk_icon_bleeder_menu"
Perks.endless_stamina.hud_texture_default = "perk_icon_bleeder"
Perks.endless_stamina.hud_texture_active = "perk_icon_bleeder_lit"
Perks.endless_stamina.default_state = "default"
Perks.endless_stamina.market_price = 250
Perks.endless_stamina.tier = 2
Perks.endless_stamina.release_name = "berserk"
Perks.empty = Perks.empty or {}
Perks.empty.ui_texture_bgr = "perk_basic_dummy"
Perks.empty.ui_texture = "perk_icon_no_perk"
Perks.empty.hud_texture_default = "perk_icon_no_perk"
Perks.empty.hud_texture_active = "perk_icon_no_perk"
Perks.empty.default_state = "inactive"
Perks.empty.market_price = nil
Perks.empty.tier = 1
Perks.empty.ui_sort_index = 1
Perks.empty.release_name = "main"
UIPerkModifications = {}
DefaultPerkUnlocks = {
	"empty"
}
PerkUnlocks = {}

for name, perk in pairs(Perks) do
	perk.name = name
	perk.perk_name = name
	perk.tier = perk.tier or 1
	perk.ui_header = "perk_header_" .. name
	perk.ui_description = "perk_desc_" .. name
	perk.ui_sort_index = perk.ui_sort_index or 1
	perk.market_price = perk.market_price
	perk.entity_type = "perk"
	PerkUnlocks[name] = perk
end

PerkCategories = {
	"melee_perk_category",
	"other_perk_category",
	"ranged_perk_category"
}
DEFAULT_PERK_UNLOCK_LIST = {
	"medium",
	"heavy_01",
	"heavy_02",
	"light_01",
	"light_02"
}

function default_perk_unlocks()
	local default_unlocks = {}

	for perk_name, props in pairs(PerkUnlocks) do
		if props.required_dlc or table.contains(DEFAULT_PERK_UNLOCK_LIST, perk_name) then
			props.market_price = nil

			local entity_type = "perk"

			default_unlocks[entity_type .. "|" .. props.name] = {
				category = entity_type,
				name = perk_name
			}
		end
	end

	return default_unlocks
end
