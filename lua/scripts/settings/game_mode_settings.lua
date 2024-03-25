-- chunkname: @scripts/settings/game_mode_settings.lua

GameModeMusicSettings = GameModeMusicSettings or {}
GameModeMusicSettings.normal = GameModeMusicSettings.normal or {}
GameModeMusicSettings.normal.minimum_play_time = 10
GameModeMusicSettings.intense = GameModeMusicSettings.intense or {}
GameModeMusicSettings.intense.minimum_play_time = 10
GameModeMusicSettings.intense.fade_out_time = 0
GameModeMusicSettings.intense.win_scale_criteria = 0.7
GameModeMusicSettings.critical = GameModeMusicSettings.critical or {}
GameModeMusicSettings.critical.minimum_play_time = 10
GameModeMusicSettings.critical.fade_out_time = 0
GameModeMusicSettings.critical.win_scale_criteria = 0.7
GameModeSettings = GameModeSettings or {}
GameModeSettings.base = {
	allow_flag_spawn = false,
	deserter_timer = 5,
	tagging_objectives = true,
	win_announcement_threshold = 0.95,
	time_limit_alert = 30,
	team_scoring_hud = false,
	visible = false,
	class_name = "GameModeBase",
	allow_ghost_talking = true,
	object_sets = {},
	objectives = {
		damage_multiplier = {
			melee = 1,
			default = 1,
			small_projectile = 0
		},
		friendly_damage_multiplier = {
			default = 1
		}
	},
	spawn_settings = {
		minimum_pulse_time = 5,
		pulse_offset_for_side = "attackers",
		type = "pulse",
		squad_screen = true,
		pulse_length = 0.1
	},
	allowed_spawning = {
		pulse = true,
		single_player = false,
		personal = true,
		battle = false
	},
	ui_description = {
		unassigned = "gm_description_unassigned_missing",
		defenders = "gm_description_defenders_missing",
		attackers = "gm_description_attackers_missing"
	},
	battle_details = {
		lost = "battle_details_missing",
		lost_round = "battle_details_missing",
		draw_round = "battle_details_missing",
		won = "battle_details_missing",
		draw = "battle_details_missing",
		won_round = "battle_details_missing"
	},
	tip_of_the_day = {},
	rewards = {}
}
GameModeSettings.sp = table.clone(GameModeSettings.base)
GameModeSettings.sp.key = "sp"
GameModeSettings.sp.class_name = "GameModeSP"
GameModeSettings.sp.display_name = "gm_single_player"
GameModeSettings.sp.object_sets = {
	gm_sp = true
}
GameModeSettings.sp.spawn_settings.type = "single_player"
GameModeSettings.sp.allowed_spawning.single_player = true
GameModeSettings.sp.allowed_spawning.pulse = false
GameModeSettings.sp.allowed_spawning.personal = false
GameModeSettings.sp.allowed_spawning.battle = false
GameModeSettings.sp.spawn_settings.pulse_length = 0
GameModeSettings.sp.has_ai = true
GameModeSettings.sp.spawn_settings.squad_screen = false
GameModeSettings.sp.player_team = "attackers"
GameModeSettings.sp.objectives.damage_multiplier.small_projectile = 1
GameModeSettings.tdm = table.clone(GameModeSettings.base)
GameModeSettings.tdm.key = "tdm"
GameModeSettings.tdm.class_name = "GameModeTDM"
GameModeSettings.tdm.time_limit = 60
GameModeSettings.tdm.display_name = "gm_team_deathmatch"
GameModeSettings.tdm.battle_details = {
	lost = "battle_details_tdm_lost",
	won = "battle_details_tdm_won",
	draw = "battle_details_tdm_draw"
}
GameModeSettings.tdm.object_sets = {
	gm_tdm = true
}
GameModeSettings.tdm.visible = true
GameModeSettings.tdm.show_in_server_browser = true
GameModeSettings.tdm.team_scoring_hud = true
GameModeSettings.tdm.score_announcement = {
	announcement_delay = 15,
	critical_mode = {
		time_left = 120,
		score_fraction = 0.85
	}
}
GameModeSettings.tdm.ui_description = {
	unassigned = "gm_description_unassigned_tdm",
	defenders = "gm_description_defenders_tdm",
	attackers = "gm_description_attackers_tdm"
}
GameModeSettings.tdm.rewards.confirmed_kill = "tdm_confirmed_kill"
GameModeSettings.tdm.rewards.match_played = "tdm_match_played"
GameModeSettings.tdm.rewards.match_won = "tdm_match_won"
GameModeSettings.battle = table.clone(GameModeSettings.base)
GameModeSettings.battle.key = "battle"
GameModeSettings.battle.class_name = "GameModeBattle"
GameModeSettings.battle.spawn_settings = {
	squad_screen = true,
	spawn_timer = 15,
	type = "battle"
}
GameModeSettings.battle.allow_ghost_talking = false
GameModeSettings.battle.allowed_spawning.single_player = false
GameModeSettings.battle.allowed_spawning.pulse = false
GameModeSettings.battle.allowed_spawning.personal = false
GameModeSettings.battle.allowed_spawning.battle = true
GameModeSettings.battle.battle_details = {
	lost = "battle_details_missing",
	lost_round = "battle_details_pitched_battle",
	draw_round = "battle_details_pitched_battle",
	won = "battle_details_missing",
	draw = "battle_details_missing",
	won_round = "battle_details_pitched_battle"
}
GameModeSettings.battle.time_limit = 1200
GameModeSettings.battle.display_name = "gm_pitched_battle"
GameModeSettings.battle.object_sets = {
	gm_pitched_battle = true,
	gm_battle = true
}
GameModeSettings.battle.visible = true
GameModeSettings.battle.show_in_server_browser = true
GameModeSettings.battle.ui_description = {
	unassigned = "gm_description_unassigned_battle",
	defenders = "gm_description_defenders_battle",
	attackers = "gm_description_attackers_battle"
}
GameModeSettings.battle.rewards.confirmed_kill = "battle_confirmed_kill"
GameModeSettings.battle.rewards.round_won = "battle_round_won"
GameModeSettings.battle.rewards.round_played = "battle_round_played"
GameModeSettings.battle.rewards.round_survived = "battle_round_survived"
GameModeSettings.battle.rewards.match_won = "battle_match_won"
GameModeSettings.battle.rewards.match_played = "battle_match_played"
GameModeSettings.arena = table.clone(GameModeSettings.battle)
GameModeSettings.arena.key = "arena"
GameModeSettings.arena.battle_details = {
	lost = "arena_details_missing",
	lost_round = "arena_details_pitched_battle",
	draw_round = "arena_details_pitched_battle",
	won = "arena_details_missing",
	draw = "arena_details_missing",
	won_round = "battle_details_pitched_arena"
}
GameModeSettings.arena.display_name = "gm_arena"
GameModeSettings.arena.object_sets = {
	gm_arena = true,
	gm_battle = true
}
GameModeSettings.arena.ui_description = {
	unassigned = "gm_description_unassigned_arena",
	defenders = "gm_description_defenders_arena",
	attackers = "gm_description_attackers_arena"
}
GameModeSettings.arena.rewards.confirmed_kill = "arena_confirmed_kill"
GameModeSettings.arena.rewards.round_won = "arena_round_won"
GameModeSettings.arena.rewards.round_played = "arena_round_played"
GameModeSettings.arena.rewards.round_survived = "arena_round_survived"
GameModeSettings.arena.rewards.match_won = "arena_match_won"
GameModeSettings.arena.rewards.match_played = "arena_match_played"
GameModeSettings.headhunter = table.clone(GameModeSettings.arena)
GameModeSettings.headhunter.key = "headhunter"
GameModeSettings.headhunter.display_name = "gm_headhunter"
GameModeSettings.headhunter.show_in_server_browser = false

table.clear(GameModeSettings.headhunter.rewards)

GameModeSettings.con = table.clone(GameModeSettings.base)
GameModeSettings.con.key = "con"
GameModeSettings.con.display_name = "gm_conquest"
GameModeSettings.con.class_name = "GameModeConquest"
GameModeSettings.con.time_limit = 900
GameModeSettings.con.object_sets = {
	gm_conquest = true
}
GameModeSettings.con.visible = true
GameModeSettings.con.show_in_server_browser = true
GameModeSettings.con.allow_flag_spawn = false
GameModeSettings.con.ui_description = {
	unassigned = "gm_description_unassigned_con",
	defenders = "gm_description_defenders_con",
	attackers = "gm_description_attackers_con"
}
GameModeSettings.con.capture_point_lock_duration = 30
GameModeSettings.con.rewards.match_played = "conquest_match_played"
GameModeSettings.con.rewards.match_won = "conquest_match_won"
GameModeSettings.con.rewards.match_total_victory = "conquest_total_victory"
GameModeSettings.domination = table.clone(GameModeSettings.base)
GameModeSettings.domination.key = "domination"
GameModeSettings.domination.display_name = "gm_domination"
GameModeSettings.domination.class_name = "GameModeDomination"
GameModeSettings.domination.time_limit = 900
GameModeSettings.domination.object_sets = {
	gm_conquest = true
}
GameModeSettings.domination.visible = true
GameModeSettings.domination.show_in_server_browser = true
GameModeSettings.domination.allow_flag_spawn = false
GameModeSettings.domination.team_scoring_hud = false
GameModeSettings.domination.dom_minimap = true
GameModeSettings.domination.instant_capture = true
GameModeSettings.domination.capture_speed_multiplier = 1.7
GameModeSettings.domination.domination_timer = 45
GameModeSettings.domination.start_score = 100
GameModeSettings.domination.ui_description = {
	unassigned = "gm_description_unassigned_con",
	defenders = "gm_description_defenders_con",
	attackers = "gm_description_attackers_con"
}
GameModeSettings.domination.rewards.match_played = "domination_match_played"
GameModeSettings.domination.rewards.match_won = "domination_match_won"
GameModeSettings.grail = table.clone(GameModeSettings.base)
GameModeSettings.grail.key = "grail"
GameModeSettings.grail.display_name = "gm_grail"
GameModeSettings.grail.battle_details = {
	lost = "battle_details_grail_lost",
	won = "battle_details_grail_won",
	draw = "battle_details_grail_draw"
}
GameModeSettings.grail.object_sets = {
	gm_grail = true
}
GameModeSettings.gpu_prof = table.clone(GameModeSettings.base)
GameModeSettings.gpu_prof.class_name = "GameModeGpuProf"
GameModeSettings.gpu_prof.key = "gpu_prof"
GameModeSettings.gpu_prof.display_name = "gm_gpu_profile"
GameModeSettings.gpu_prof.object_sets = {
	gm_gpu_prof = true
}
GameModeSettings.gpu_prof.has_ai = true
GameModeSettings.gpu_prof.spawn_settings.squad_screen = false
GameModeSettings.gpu_prof.player_team = "defenders"
GameModeSettings.cpu_prof = table.clone(GameModeSettings.base)
GameModeSettings.cpu_prof.class_name = "GameModeCpuProf"
GameModeSettings.cpu_prof.key = "cpu_prof"
GameModeSettings.cpu_prof.display_name = "gm_cpu_profile"
GameModeSettings.cpu_prof.object_sets = {
	gm_cpu_prof = true
}
GameModeSettings.cpu_prof.has_ai = true
GameModeSettings.cpu_prof.spawn_settings.squad_screen = false
GameModeSettings.fly_through = table.clone(GameModeSettings.base)
GameModeSettings.fly_through.class_name = "GameModeFlyThrough"
GameModeSettings.fly_through.key = "fly_through"
GameModeSettings.fly_through.display_name = "gm_fly_through"
GameModeSettings.fly_through.object_sets = {
	gm_fly_through = true
}
GameModeSettings.fly_through.has_ai = true
GameModeSettings.fly_through.spawn_settings.squad_screen = false

for table_key, settings in pairs(GameModeSettings) do
	if table_key ~= "base" then
		fassert(settings.key, "[GameModeSettings] game mode %q is missing parameter \"key\".", table_key)
		fassert(settings.display_name, "[GameModeSettings] game mode %q is missing parameter \"display_name\".", table_key)
	end
end
