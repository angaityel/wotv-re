-- chunkname: @scripts/network_lookup/network_lookup.lua

require("scripts/settings/archetypes")
require("scripts/settings/gear_require")
require("scripts/settings/ai_profiles")
require("scripts/settings/player_profiles")
require("scripts/settings/robot_profiles")
require("scripts/settings/mount_profiles")
require("scripts/settings/level_settings")
require("scripts/settings/game_mode_settings")
require("scripts/settings/experience_settings")
require("scripts/settings/heads")
require("scripts/settings/helmets")
require("scripts/settings/cloaks")
require("scripts/settings/armours")
require("scripts/settings/execution_definitions")
require("scripts/settings/coat_of_arms")
require("scripts/settings/player_data")
require("scripts/settings/prizes")
require("scripts/settings/inventory_slots")
require("scripts/settings/medals")
require("scripts/settings/material_effect_mappings")
require("scripts/managers/voting/voting_manager")
require("scripts/settings/announcements")
require("scripts/hud/heraldry_base")
require("scripts/hud/heraldry_vikings")
require("scripts/hud/heraldry_saxons")

NetworkLookup = {}
NetworkLookup.husks = {
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_barbed",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_cresent_moon",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_fire",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_long_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_short_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_standard",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_swallow_tail",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_barbed",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_cresent_moon",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_fire",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_long_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_short_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_standard",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_medium_arrow_swallow_tail",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_barbed",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_cresent_moon",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_fire",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_long_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_short_bodkin",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_standard",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_short_arrow_swallow_tail",
	"units/weapons/wpn_projectiles/wpn_crossbow_bolt_standard/wpn_crossbow_bolt_standard",
	"units/weapons/wpn_projectiles/wpn_crossbow_bolt_firebolt/wpn_crossbow_bolt_firebolt",
	"units/weapons/wpn_projectiles/wpn_crossbow_bolt_frogleg/wpn_crossbow_bolt_frogleg",
	"units/weapons/wpn_projectiles/wpn_crossbow_bolt_hammerbolt/wpn_crossbow_bolt_hammerbolt",
	"units/weapons/wpn_projectiles/wpn_crossbow_bolt_whalerhead/wpn_crossbow_bolt_whalerhead",
	"units/weapons/wpn_capture_flag/wpn_capture_flag_red",
	"units/weapons/wpn_capture_flag/wpn_capture_flag_white",
	"units/weapons/wpn_squad_flag/wpn_squad_flag_red",
	"units/weapons/wpn_squad_flag/wpn_squad_flag_white",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_standard_rough",
	"units/weapons/wpn_projectiles/wpn_arrow/wpn_long_arrow_standard_ornamented"
}
NetworkLookup.squad_spawn_modes = {
	"off",
	"on",
	"no_combat"
}
NetworkLookup.voice = {
	"husk_vce_charge_swing",
	"husk_vce_swing",
	"chr_vce_finish_off",
	"chr_vce_health_boost",
	"chr_vce_perk_adrenalin_rush",
	"chr_vce_perk_bloodthirst_swing",
	"chr_vce_perk_niding_backstab_enemy",
	"chr_vce_perk_fake_death"
}
NetworkLookup.stamina_state = {
	"normal",
	"tired"
}
NetworkLookup.loot_actors = {
	"thrown",
	"dropped"
}
NetworkLookup.game_object_functions = {
	"cb_player_stats_created",
	"cb_player_stats_destroyed",
	"cb_player_damage_extension_game_object_created",
	"cb_player_damage_extension_game_object_destroyed",
	"cb_generic_damage_extension_game_object_created",
	"cb_generic_damage_extension_game_object_destroyed",
	"cb_generic_unit_interactable_created",
	"cb_generic_unit_interactable_destroyed",
	"cb_spawn_unit",
	"cb_spawn_gear",
	"cb_spawn_flag",
	"cb_spawn_projectile",
	"cb_destroy_object",
	"cb_destroy_player_unit",
	"cb_destroy_squad_flag_unit",
	"cb_destroy_unit",
	"cb_destroy_gear",
	"cb_do_nothing",
	"cb_local_unit_spawned",
	"cb_migrate_object",
	"cb_local_gear_unit_spawned",
	"cb_local_projectile_spawned",
	"cb_spawn_point_created",
	"cb_player_game_object_created",
	"cb_player_game_object_destroyed",
	"cb_team_created",
	"cb_team_destroyed",
	"cb_spawn_point_game_object_created",
	"cb_capture_point_created",
	"cb_capture_point_destroyed",
	"cb_payload_created",
	"cb_payload_destroyed",
	"cb_projectile_game_object_destroyed",
	"cb_spawn_thrown_projectile",
	"cb_thrown_projectile_game_object_destroyed",
	"cb_coat_of_arms_created",
	"cb_area_buff_game_object_destroyed",
	"cb_vote_destroyed",
	"cb_vote_created",
	"cb_spawn_squad_flag",
	"cb_spawn_player_unit",
	"cb_spawn_ai_unit",
	"cb_squad_object_created",
	"cb_squad_object_destroyed"
}
NetworkLookup.perks = {}

for name, _ in pairs(Perks) do
	NetworkLookup.perks[#NetworkLookup.perks + 1] = name
end

NetworkLookup.movement_states = {
	"bandaging_teammate",
	"bandaging_self",
	"charging",
	"climbing",
	"dead",
	"dodging",
	"dual_wield_attack",
	"executing",
	"fakedeath",
	"collapse",
	"falling_attack",
	"heal_on_taunting",
	"inair",
	"jumping",
	"knocked_down",
	"landing",
	"looting",
	"looting_trap",
	"mounted",
	"onground",
	"onground/idle",
	"onground/moving",
	"planting_flag",
	"placing_trap",
	"pushing",
	"reviving_teammate",
	"shield_bashing",
	"special_attack",
	"dual_wield_special_attack",
	"special_attack_stance",
	"stunned",
	"taunting",
	"triggering"
}
NetworkLookup.anims = {
	"attack_finished",
	"attack_hit_hard",
	"attack_hit_soft",
	"backstab_attack_start",
	"backstab_pose",
	"bandage_end",
	"bandage_self",
	"bandage_self_block",
	"bandage_team_mate",
	"banner_bonus_action",
	"banner_bonus_charge",
	"banner_bonus_finished",
	"both_hands/empty",
	"bow_aim",
	"bow_draw",
	"bow_action_cancel",
	"bow_action_finished",
	"bow_aim_cancel",
	"bow_empty",
	"bow_ready",
	"bow_release",
	"bow_release_reload",
	"bow_reload",
	"bow_tense",
	"cavalry_whistle_end",
	"cavalry_whistle_start",
	"charge_finished",
	"charge_hit_hard",
	"charge_start",
	"climb_end",
	"climb_enter",
	"climb_idle",
	"climb_idle_left",
	"climb_idle_mid",
	"climb_idle_right",
	"climb_move",
	"climb_top_enter",
	"climb_top_exit",
	"crossbow_aim",
	"crossbow_empty",
	"crossbow_hand_reload",
	"crossbow_hand_reload_finished",
	"crossbow_ready",
	"crossbow_recoil",
	"crossbow_unaim",
	"death",
	"death_backstab",
	"death_decap",
	"dodge_attack_start",
	"dodge_block_bwd_start",
	"dodge_block_fwd_start",
	"dodge_block_left_start",
	"dodge_block_right_start",
	"dodge_finished",
	"dodge_bwd_start",
	"dodge_fwd_start",
	"dodge_left_start",
	"dodge_right_start",
	"emote_finished",
	"execute_attacker_1h_sword_shield_front",
	"execute_attacker_2h_axe",
	"execute_attacker_club",
	"execute_attacker_dagger",
	"execute_attacker_dagger_kneeling",
	"execute_attacker_end",
	"execute_attacker_shield",
	"execute_attacker_sword_omni",
	"execute_victim_1h_sword_shield_front",
	"execute_victim_2h_axe",
	"execute_victim_club",
	"execute_victim_dagger",
	"execute_victim_dagger_kneeling",
	"execute_victim_shield",
	"execute_victim_sword_omni",
	"falling_attack",
	"grenade_light_1h",
	"grenade_light_2h",
	"grenade_light_finished_1h",
	"grenade_light_finished_2h",
	"grenade_ready",
	"grenade_throw_1h",
	"grenade_throw_2h",
	"handgonne_aim",
	"handgonne_ignite",
	"handgonne_ready",
	"handgonne_recoil",
	"idle",
	"inair_attack",
	"inair_attack_land",
	"interaction_end",
	"interaction_fire_cannon",
	"interaction_generic",
	"interaction_pull_lever",
	"interaction_raise_flag",
	"jump_fwd",
	"jump_idle",
	"knocked_down",
	"knocked_down_face_front_blunt",
	"knocked_down_face_left_front_cut",
	"knocked_down_face_right_front_cut",
	"knocked_down_generic_fall_front",
	"knocked_down_generic_fall_right",
	"knocked_down_torso_back_cut",
	"knocked_down_torso_back_cut_02",
	"knocked_down_torso_back_cut_03",
	"knocked_down_torso_back_cut_04",
	"knocked_down_torso_front_cut_02",
	"knocked_down_torso_front_cut_03",
	"knocked_down_torso_front_stomach_pierce",
	"knocked_down_torso_front_stomach_pierce_02",
	"knocked_down_torso_front_stomach_pierce_03",
	"lance_couch",
	"lance_uncouch",
	"land_knocked_down",
	"land_heavy_moving_bwd",
	"land_heavy_moving_fwd",
	"land_heavy_moving_still",
	"land_heavy_still",
	"land_moving_bwd",
	"land_moving_fwd",
	"land_moving_still",
	"land_still",
	"lean",
	"left_hand/empty",
	"left_hand/shield",
	"mounted_stun_backward",
	"mounted_stun_forward",
	"mounted_stun_land",
	"mounted_stun_left",
	"mounted_stun_right",
	"stun_spawn",
	"move_bwd",
	"move_fwd",
	"parry_pose",
	"parry_pose_exit",
	"parry_pose_down",
	"parry_pose_left",
	"parry_pose_right",
	"parry_pose_up",
	"pickup_left",
	"pickup_right",
	"push_finished",
	"push_hit",
	"push_hit_hard",
	"push_miss",
	"push_start",
	"reset",
	"revive_complete",
	"revive_abort",
	"revive_start",
	"revive_team_mate",
	"revive_team_mate_block",
	"revive_team_mate_end",
	"right_hand/empty",
	"right_hand/1h_sword",
	"rush_fwd",
	"shield_bash_finished",
	"shield_bash_hit",
	"shield_bash_hit_hard",
	"shield_bash_miss",
	"shield_bash_pose_start",
	"shield_bash_start",
	"shield_up",
	"shield_down",
	"special_attack_bash",
	"special_attack_end",
	"special_attack_shield_break",
	"special_attack_shield_break_sword",
	"special_attack_stab",
	"special_attack_stance",
	"special_attack_start",
	"stun_back_head_down",
	"stun_back_head_left",
	"stun_back_head_right",
	"stun_back_head_up",
	"stun_back_legs_down",
	"stun_back_legs_left",
	"stun_back_legs_right",
	"stun_back_legs_up",
	"stun_back_stomach_down",
	"stun_back_stomach_left",
	"stun_back_stomach_right",
	"stun_back_stomach_up",
	"stun_back_torso_down",
	"stun_back_torso_left",
	"stun_back_torso_right",
	"stun_back_torso_up",
	"stun_end",
	"stun_front_head_down",
	"stun_front_head_left",
	"stun_front_head_right",
	"stun_front_head_up",
	"stun_front_legs_down",
	"stun_front_legs_left",
	"stun_front_legs_right",
	"stun_front_legs_up",
	"stun_front_stomach_down",
	"stun_front_stomach_left",
	"stun_front_stomach_right",
	"stun_front_stomach_up",
	"stun_front_torso_down",
	"stun_front_torso_left",
	"stun_front_torso_right",
	"stun_front_torso_up",
	"stun_horse_back",
	"stun_horse_front",
	"stun_travel_back",
	"stun_travel_front",
	"swing_attack_down",
	"swing_attack_finished",
	"swing_attack_interrupt",
	"swing_attack_left",
	"swing_attack_left_repeated",
	"swing_attack_left_start",
	"swing_attack_right",
	"swing_attack_right_repeated",
	"swing_attack_right_start",
	"swing_attack_left_upper_body",
	"swing_attack_left_repeated_upper_body",
	"swing_attack_left_start_upper_body",
	"swing_attack_right_upper_body",
	"swing_attack_right_repeated_upper_body",
	"swing_attack_right_start_upper_body",
	"swing_attack_up",
	"swing_attack_penalty_finished",
	"swing_attack_penalty_start",
	"swing_attack_pommel_bash",
	"swing_pose_down",
	"swing_pose_left",
	"swing_pose_right",
	"swing_pose_up",
	"swing_pose_blend",
	"swing_pose_exit",
	"throw_pose_exit",
	"throw_pose_start",
	"throw",
	"to_1h_axe",
	"to_1h_sword",
	"to_2h_axe",
	"to_2h_swpod",
	"to_dagger",
	"to_dual_wield",
	"to_longbow",
	"to_crossbow",
	"to_crouch",
	"to_huntingbow",
	"to_inair",
	"to_javelin",
	"to_onground",
	"to_shield",
	"to_shortbow",
	"to_spear",
	"to_unarmed",
	"to_uncrouch",
	"to_unshield",
	"unlean",
	"wield_1h_spear",
	"wield_2h_axe",
	"wield_dual_wield",
	"wield_finished",
	"wield_huntingbow",
	"wield_left_arm_back",
	"wield_longbow",
	"wield_right_arm_right_hip",
	"wield_right_arm_left_hip",
	"wield_right_arm_left_hip_axe",
	"wield_shortbow",
	"wield_spear",
	"wield_throwing_axe",
	"wield_throwing_dagger",
	"weapon_unflip",
	"weapon_flip",
	"unwield_1h_spear",
	"unwield_2h_axe",
	"unwield_dual_wield",
	"unwield_finished",
	"unwield_huntingbow",
	"unwield_left_arm_back",
	"unwield_longbow",
	"unwield_spear",
	"unwield_right_arm_right_hip",
	"unwield_right_arm_left_hip",
	"unwield_shortbow",
	"unwield_throwing_axe",
	"unwield_throwing_dagger",
	"yield",
	"attack_time",
	"backstab_pose_time",
	"bow_draw_time",
	"bow_reload_time",
	"bow_shake",
	"bow_tense_time",
	"bow_hold_time",
	"charge_hit_hard_penalty_time",
	"climb_enter_exit_speed",
	"dodge_time",
	"grenade_light_time",
	"lance_couch_time",
	"lance_uncouch_time",
	"pickup_time",
	"push_hit_hard_penalty_time",
	"push_miss_penalty_time",
	"push_time",
	"revive_team_mate_time",
	"revive_time",
	"shield_bash_hit_hard_penalty_time",
	"shield_bash_miss_penalty_time",
	"shield_bash_pose_time",
	"shield_bash_time",
	"stun_time",
	"swing_pose_time",
	"throw_pose_time",
	"throw_time",
	"weapon_penetration",
	"wield_time"
}

for _, taunt in pairs(PlayerUnitMovementSettings.base_taunts) do
	NetworkLookup.anims[#NetworkLookup.anims + 1] = taunt.start_anim_event
end

NetworkLookup.weapon_hit_parameters = {
	"nil",
	"parrying",
	"blocking",
	"dual_wield_defending",
	"up",
	"left",
	"right",
	"down",
	"soft",
	"hard",
	"not_penetrated",
	"prop",
	"gear",
	"blocking_gear",
	"character",
	"special",
	"axe_axe_special_primary",
	"sword_axe_special_primary",
	"axe_sword_special_primary",
	"sword_sword_special_primary",
	"axe_axe_special_secondary",
	"sword_axe_special_secondary",
	"axe_sword_special_secondary",
	"sword_sword_special_secondary",
	"backstab",
	"dual_wield_dodge_right_primary",
	"dual_wield_dodge_left_primary",
	"dual_wield_dodge_forward_primary",
	"dual_wield_dodge_backward_primary",
	"dual_wield_dodge_right_secondary",
	"dual_wield_dodge_left_secondary",
	"dual_wield_dodge_forward_secondary",
	"dual_wield_dodge_backward_secondary",
	"dodge_right",
	"dodge_left",
	"dodge_forward",
	"dodge_backward",
	"ranged",
	"throw",
	"falling",
	"pommel_bash",
	"stance_shield_bash",
	"stance_special_repeated_stab",
	"stance_special_initial_stab",
	"right_repeated",
	"right_repeated_upper_body",
	"right_start",
	"right_start_upper_body",
	"right_alternated",
	"right_alternated_upper_body",
	"left_repeated",
	"left_repeated_upper_body",
	"left_start",
	"left_start_upper_body",
	"left_alternated",
	"left_alternated_upper_body"
}
NetworkLookup.attack_names = {}
NetworkLookup.attack_index = {}

for i, v in ipairs(NetworkLookup.weapon_hit_parameters) do
	NetworkLookup.attack_names[#NetworkLookup.attack_names + 1] = v

	table.insert(NetworkLookup.attack_index, v)
end

NetworkLookup.callback_names = {
	"gear_cb_abort_swing"
}
NetworkLookup.callback_index = {}

for i, v in ipairs(NetworkLookup.callback_names) do
	table.insert(NetworkLookup.attack_index, v)
end

NetworkLookup.damage_types = {
	"yield",
	"kinetic",
	"cutting",
	"piercing",
	"slashing",
	"blunt",
	"piercing_projectile",
	"damage_over_time",
	"death_zone",
	"crush",
	"backstab",
	"endless_stamina",
	"n/a"
}
NetworkLookup.voices = {
	"commoner",
	"noble",
	"brian_blessed_commoner",
	"brian_blessed_noble",
	"light_saxon",
	"medium_saxon",
	"heavy_saxon",
	"female_saxon",
	"light_viking",
	"medium_viking",
	"heavy_viking",
	"female_viking"
}
NetworkLookup.objective_point_order_ids = {
	"none",
	"objective_point1",
	"objective_point2",
	"objective_point3",
	"objective_point4",
	"objective_point5"
}
NetworkLookup.damage_over_time_types = {
	"bleeding",
	"burning"
}
NetworkLookup.weapon_properties = {
	"bleeding",
	"burning",
	"stun",
	"penetration"
}
NetworkLookup.buff_types = {
	"courage"
}
NetworkLookup.debuff_types = {
	"burning",
	"bleeding",
	"last_stand",
	"arrow"
}
NetworkLookup.trap_names = {
	"n/a",
	"trap_1",
	"trap_2",
	"trap_3",
	"trap_4"
}
NetworkLookup.inventory_slots = {}

for name, _ in pairs(InventorySlots) do
	NetworkLookup.inventory_slots[#NetworkLookup.inventory_slots + 1] = name
end

NetworkLookup.armour_types = {
	"none",
	"armour_cloth",
	"armour_leather",
	"armour_mail",
	"armour_plate",
	"weapon_wood",
	"weapon_metal"
}
NetworkLookup.executions = {}

for name, _ in pairs(ExecutionDefinitions) do
	NetworkLookup.executions[#NetworkLookup.executions + 1] = name
end

NetworkLookup.level_keys = {}

for name, _ in pairs(LevelSettings) do
	NetworkLookup.level_keys[#NetworkLookup.level_keys + 1] = name
end

local unique_server_map_names = {}

for _, map in pairs(LevelSettings) do
	if map.game_server_map_name then
		unique_server_map_names[map.game_server_map_name] = true
	end
end

NetworkLookup.server_map_names = {}

for map_name, _ in pairs(unique_server_map_names) do
	NetworkLookup.server_map_names[#NetworkLookup.server_map_names + 1] = map_name:lower()
end

NetworkLookup.game_mode_keys = {}

for name, _ in pairs(GameModeSettings) do
	NetworkLookup.game_mode_keys[#NetworkLookup.game_mode_keys + 1] = name
end

NetworkLookup.inventory_gear = {}

for name, _ in pairs(Gear) do
	NetworkLookup.inventory_gear[#NetworkLookup.inventory_gear + 1] = name
end

NetworkLookup.mount_profiles = {}

for name, _ in pairs(MountProfiles) do
	NetworkLookup.mount_profiles[#NetworkLookup.mount_profiles + 1] = name
end

NetworkLookup.damage_range_types = {}

for name, _ in pairs(AttackDamageRangeTypes) do
	NetworkLookup.damage_range_types[#NetworkLookup.damage_range_types + 1] = name
end

NetworkLookup.damage_range_types[#NetworkLookup.damage_range_types + 1] = "n/a"
NetworkLookup.heads = {}

for name, _ in pairs(Heads) do
	NetworkLookup.heads[#NetworkLookup.heads + 1] = name
end

NetworkLookup.helmets = {}

for name, _ in pairs(Helmets) do
	NetworkLookup.helmets[#NetworkLookup.helmets + 1] = name
end

NetworkLookup.cloaks = {}

for name, _ in pairs(Cloaks) do
	NetworkLookup.cloaks[#NetworkLookup.cloaks + 1] = name
end

NetworkLookup.cloak_patterns = {}

for name, _ in pairs(CloakPatterns) do
	NetworkLookup.cloak_patterns[#NetworkLookup.cloak_patterns + 1] = name
end

NetworkLookup.cloak_patterns[#NetworkLookup.cloak_patterns + 1] = "n/a"
NetworkLookup.helmet_attachments = {}

for _, attachments in pairs(HelmetAttachments) do
	for attachment_name, _ in pairs(attachments) do
		if not table.contains(NetworkLookup.helmet_attachments, attachment_name) then
			NetworkLookup.helmet_attachments[#NetworkLookup.helmet_attachments + 1] = attachment_name
		end
	end
end

NetworkLookup.helmet_variations = {}

for _, helmets in pairs(Helmets) do
	for _, variation in pairs(helmets.material_variations) do
		if not table.contains(NetworkLookup.helmet_variations, variation.material_variation) then
			NetworkLookup.helmet_variations[#NetworkLookup.helmet_variations + 1] = variation.material_variation
		end
	end
end

NetworkLookup.helmet_variations[#NetworkLookup.helmet_variations + 1] = "n/a"
NetworkLookup.armours = {}

for name, _ in pairs(Armours) do
	NetworkLookup.armours[#NetworkLookup.armours + 1] = name
end

NetworkLookup.beards = {}

for _, beard in ipairs(Beards) do
	NetworkLookup.beards[#NetworkLookup.beards + 1] = beard.name
end

NetworkLookup.beards[#NetworkLookup.beards + 1] = "n/a"
NetworkLookup.beard_colors = {}

for _, color in pairs(BeardColors) do
	NetworkLookup.beard_colors[#NetworkLookup.beard_colors + 1] = color.name
end

NetworkLookup.beard_colors[#NetworkLookup.beard_colors + 1] = "n/a"
NetworkLookup.directions = {
	"up",
	"down",
	"left",
	"right"
}
NetworkLookup.team = {
	"red",
	"white",
	"attackers",
	"defenders",
	"unassigned",
	"neutral",
	"draw",
	false
}
NetworkLookup.effects = {
	"fx/handgonne_muzzle_flash",
	"fx/impact_blood",
	"fx/bullet_sand"
}
NetworkLookup.projectiles = {
	"default",
	"fire"
}
NetworkLookup.localized_strings = {
	"attackers_win",
	"flag_captured",
	"flag_lost_fallback",
	"defenders_win",
	"attackers_zone",
	"defenders_zone",
	"neutral_zone"
}
NetworkLookup.chat_channels = {
	"all",
	"dead",
	"team_red",
	"dead_team_red",
	"team_white",
	"dead_team_white",
	"team_unassigned",
	"dead_team_unassigned"
}
NetworkLookup.duel_winner = {
	"attacker",
	"defender",
	"draw"
}
NetworkLookup.hit_zones = {
	"helmet",
	"head",
	"torso",
	"stomach",
	"forearms",
	"arms",
	"legs",
	"hands",
	"calfs",
	"feet",
	"body",
	"n/a"
}
NetworkLookup.surface_material_effects = {}

for name, _ in pairs(MaterialEffectMappings) do
	NetworkLookup.surface_material_effects[#NetworkLookup.surface_material_effects + 1] = name
end

NetworkLookup.gear_names = {}

for name, _ in pairs(Gear) do
	NetworkLookup.gear_names[#NetworkLookup.gear_names + 1] = name
end

NetworkLookup.gear_names[#NetworkLookup.gear_names + 1] = "n/a"
NetworkLookup.coat_of_arms_materials = {}

for key, value in pairs(heraldry_base) do
	NetworkLookup.coat_of_arms_materials[#NetworkLookup.coat_of_arms_materials + 1] = key
end

for key, value in pairs(heraldry_vikings) do
	NetworkLookup.coat_of_arms_materials[#NetworkLookup.coat_of_arms_materials + 1] = key
end

for key, value in pairs(heraldry_saxons) do
	NetworkLookup.coat_of_arms_materials[#NetworkLookup.coat_of_arms_materials + 1] = key
end

NetworkLookup.prizes = {}

for name, _ in pairs(Prizes.COLLECTION) do
	NetworkLookup.prizes[#NetworkLookup.prizes + 1] = name
end

NetworkLookup.medals = {}

for name, _ in pairs(Medals.COLLECTION) do
	NetworkLookup.medals[#NetworkLookup.medals + 1] = name
end

NetworkLookup.announcements = {}

for name, _ in pairs(Announcements) do
	NetworkLookup.announcements[#NetworkLookup.announcements + 1] = name
end

NetworkLookup.network_dump_tags = {
	"LAG!"
}

local xp_reason = {}

for reason, _ in pairs(ExperienceSettings) do
	xp_reason[#xp_reason + 1] = reason
end

NetworkLookup.xp_reason = xp_reason
NetworkLookup.penalty_reason = {
	"team_kill",
	"team_damage"
}
NetworkLookup.voting_types = {}

for name, _ in pairs(VotingTypes) do
	local index = #NetworkLookup.voting_types + 1

	NetworkLookup.voting_types[index] = name
end

NetworkLookup.gate_states = {
	"open",
	"closed"
}
NetworkLookup.zone_lock_reasons = {
	"game_mode",
	"activated"
}
NetworkLookup.archetypes = {}

for _, archetype in ipairs(ArchetypeList) do
	NetworkLookup.archetypes[#NetworkLookup.archetypes + 1] = archetype
end

local function init(self, name)
	for index, str in ipairs(self) do
		assert(not self[str], "[NetworkLookup.lua] Duplicate entry in " .. name .. ".")

		self[str] = index
	end

	local index_error_print = "[NetworkLookup.lua] Table " .. name .. " does not contain key: "
	local meta = {
		__index = function(_, key)
			assert(false, index_error_print .. tostring(key))
		end
	}

	setmetatable(self, meta)
end

for key, lookup_table in pairs(NetworkLookup) do
	init(lookup_table, key)
end
