-- chunkname: @scripts/settings/game_mode_objectives.lua

require("scripts/settings/hud_settings")

GameModeObjectives = GameModeObjectives or {}
GameModeObjectives = {
	[""] = {},
	capture_level = {
		announcement = "capture_level",
		param1 = "current_level_name"
	},
	interact_with_attackers_objective = {
		announcement = "interact_with_attackers_objective",
		param1 = "attackers_objectives_grouped_on_interaction"
	},
	defend_attackers_objective = {
		announcement = "defend_attackers_objective",
		param1 = "attackers_objective_ui_names"
	},
	kill_tagged_enemy = {
		announcement = "kill_tagged_enemy",
		param1 = "name_of_player_tagged_by_squad_corporal"
	},
	execute_tagged_enemy = {
		announcement = "execute_tagged_enemy",
		param1 = "name_of_player_tagged_by_squad_corporal"
	},
	defend_tagged_team_member = {
		announcement = "defend_tagged_team_member",
		param1 = "name_of_player_tagged_by_squad_corporal"
	},
	revive_tagged_team_member = {
		announcement = "revive_tagged_team_member",
		param1 = "name_of_player_tagged_by_squad_corporal"
	},
	attack_tagged_objective = {
		announcement = "attack_tagged_objective",
		param2 = "name_of_objective_tagged_by_squad_corporal",
		param1 = "interaction_of_objective_tagged_by_squad_corporal"
	},
	defend_tagged_objective = {
		announcement = "defend_tagged_objective",
		param1 = "name_of_objective_tagged_by_squad_corporal"
	},
	pitched_battle_tiebreak_objective = {
		announcement = "pitched_battle_tiebreak"
	},
	sp_interact_with_objective = {
		announcement = "interact_with_attackers_objective",
		param1 = "sp_objectives_grouped_on_interaction"
	},
	sp_tutorial_description_objective_battle = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_description_objective_push = {
		announcement = "sp_tutorial_description_objective_push"
	},
	sp_tutorial_name_objective_5enemies = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_name_objective_10enemies = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_name_objective_25enemies = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_description_objective_assault = {
		param1 = "attackers_objectives_grouped_on_interaction"
	},
	sp_tutorial_name_tournament_sc_event = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_name_tournament_pasdarmes_event = {
		announcement = "interact_with_attackers_objective"
	},
	sp_tutorial_name_tournament_koth_event = {
		announcement = "defend_attackers_objective",
		param1 = "attackers_objective_ui_names"
	},
	sp_tutorial_name_tournament_arena_event = {
		announcement = "kill_the_enemy_team",
		param1 = "enemy_team_ui_name_definite_plural"
	},
	sp_tutorial_name_tournament_archery_event = {},
	sp_tutorial_name_tournament_ride_event = {},
	sp_tutorial_description_objective_capture = {},
	sp_tutorial_name_objective_completed = {
		announcement = "sp_tutorial_name_objective_completed"
	}
}
