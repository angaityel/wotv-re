-- chunkname: @scripts/settings/sound_ducking_settings.lua

BusVolumeDefaults = {
	vce_tired = 0,
	game_group = 0,
	level_intro = 0,
	music = 0
}
DuckingConfigs = {}
DuckingConfigs.defaults = {
	fade_out_time = 0,
	volume = 0,
	bus_name = "game_group",
	fade_in_time = 0,
	delay = 0
}
DuckingConfigs.Play_objective_fail = {
	fade_out_time = 0.2,
	volume = -12,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 1.5
}
DuckingConfigs.Play_objective_fail = {
	fade_out_time = 0.2,
	volume = -12,
	bus_name = "level_intro",
	fade_in_time = 0.1,
	delay = 0,
	duration = 1.5
}
DuckingConfigs.Play_objective_win = {
	fade_out_time = 0.2,
	volume = -12,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2
}
DuckingConfigs.Play_objective_win = {
	fade_out_time = 0.2,
	volume = -12,
	bus_name = "level_intro",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2
}
DuckingConfigs.Play_cliff_battle_music = {
	fade_out_time = 0.2,
	volume = -40,
	bus_name = "level_intro",
	fade_in_time = 0.2,
	delay = 0,
	duration = 0
}
DuckingConfigs.Play_forest_battle_music = {
	fade_out_time = 0.2,
	volume = -40,
	bus_name = "level_intro",
	fade_in_time = 0.2,
	delay = 0,
	duration = 0
}
DuckingConfigs.Play_holmgang_battle_music = {
	fade_out_time = 0.2,
	volume = -40,
	bus_name = "level_intro",
	fade_in_time = 0.2,
	delay = 0,
	duration = 0
}
DuckingConfigs.Play_monastery_battle_music = {
	fade_out_time = 0.2,
	volume = -40,
	bus_name = "level_intro",
	fade_in_time = 0.2,
	delay = 0,
	duration = 0
}
DuckingConfigs.Play_york_battle_music = {
	fade_out_time = 0.2,
	volume = -40,
	bus_name = "level_intro",
	fade_in_time = 0.2,
	delay = 0,
	duration = 0
}
DuckingConfigs.hud_low_stamina = {
	fade_out_time = 0.1,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0,
	delay = 0,
	duration = 0.3
}
DuckingConfigs.perk_generic = {
	fade_out_time = 0,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0,
	delay = 0,
	duration = 0.3
}
DuckingConfigs.perk_health_recharge = {
	fade_out_time = 0,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0,
	delay = 0,
	duration = 0.3
}
DuckingConfigs.perk_backstab_self = {
	fade_out_time = 0.1,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.menu_battle_report_level_up = {
	fade_out_time = 0.2,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2.5
}
DuckingConfigs.hud_level_up = {
	fade_out_time = 0.2,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 1
}
DuckingConfigs.chr_heartbeat_loop = {
	fade_out_time = 0.1,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0
}
DuckingConfigs.melee_hit_heavy = {
	fade_out_time = 0.1,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0.5
}
DuckingConfigs.cannon_fire_near = {
	fade_out_time = 0.5,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 1
}
DuckingConfigs.projectile_hit_self = {
	fade_out_time = 0.4,
	volume = -15,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0.6
}
DuckingConfigs.stunned_player_long = {
	fade_out_time = 1,
	volume = -16,
	bus_name = "game_group",
	fade_in_time = 0.2,
	delay = 0.3,
	duration = 2
}
DuckingConfigs.stunned_player_medium = {
	fade_out_time = 1,
	volume = -16,
	bus_name = "game_group",
	fade_in_time = 0.2,
	delay = 0.3,
	duration = 1
}
DuckingConfigs.stunned_player_short = {
	fade_out_time = 1,
	volume = -16,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.1,
	duration = 0.7
}
DuckingConfigs.vo_announcement_victory = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 1
}
DuckingConfigs.vo_announcement_defeat = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´1
}
DuckingConfigs.vo_announcement_out_of_bounds = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0
}
DuckingConfigs.vo_announcement_arena_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_conquest_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_duel_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_pitched_battle_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_domination_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_seige_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_tdm_start = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0.5,
	duration = 2.5
}
DuckingConfigs.vo_announcement_conquest_new_capture_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_new_defend_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capture_final_objective_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_defend_final_objective_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_beach = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_blacksmith = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_clearing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_foundry = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_grove = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_hilltop = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_hollow = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_keep = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_lodge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_mead_hall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_ravine = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_river_crossing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_road = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_ruins = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_southern_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_storehouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_captured_village_square = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_beach = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_blacksmith = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_clearing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_foundry = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_grove = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_hilltop = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_hollow = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_keep = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_lodge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_mead_hall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_ravine = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_river_crossing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_road = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_ruins = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_southern_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_storehouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_village_square = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_capturing_wall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_beach = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_blacksmith = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_clearing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_foundry = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_grove = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_hilltop = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_hollow = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_keep = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_lodge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_mead_hall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_ravine = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_river_crossing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_road = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_ruins = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_southern_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_storehouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_village_square = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_losing_wall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_beach = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_beachhead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_blacksmith = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_bridge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_clearing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_cliffside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_foundry = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_grove = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_hilltop = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_hollow = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_keep = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_lakeside = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_lodge = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_longhouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_mead_hall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_objective = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_ravine = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_river_crossing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_riverbank = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_road = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_ruins = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_south_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_southern_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_storehouse = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_town_gate = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_village_square = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_conquest_lost_wall = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_pitched_battle_last_one_standing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2.5
}
DuckingConfigs.vo_announcement_tdm_lost_the_lead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2.5
}
DuckingConfigs.vo_announcement_tdm_taken_the_lead = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2.5
}
DuckingConfigs.vo_announcement_tdm_time_running_out = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.vo_announcement_domination_captured_all_objectives = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2
}
DuckingConfigs.vo_announcement_domination_lost_all_objectives = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_winning = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = 2
}
DuckingConfigs.vo_announcement_domination_captured_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_captured_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_captured_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_captured_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_captured_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_captured_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_losing_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_cairn_stones = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_landing = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_shipyard = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_stockade = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_tavern = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.vo_announcement_domination_lost_tower = {
	fade_out_time = 0.3,
	volume = -10,
	bus_name = "game_group",
	fade_in_time = 0.1,
	delay = 0,
	duration = ´0
}
DuckingConfigs.chr_vce_swing = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_charge_swing = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_hurt = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_jump = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_special_attack = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_land = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_land_hard = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
DuckingConfigs.chr_vce_special_attack = {
	fade_out_time = 0.1,
	volume = -100,
	bus_name = "vce_tired",
	fade_in_time = 0.1,
	delay = 0,
	duration = 0
}
