-- chunkname: @scripts/settings/announcements.lua

require("scripts/settings/hud_settings")

DefaultAnnouncementSettings = {
	discard_time = 7
}
Announcements = {
	[""] = {},
	kill_the_enemy_team = {
		show_max_times = 1,
		unique_id = "objective_description",
		param1 = "enemy_team_ui_name_definite_plural",
		layout_settings = HUDSettings.announcements.objective
	},
	capture_level = {
		show_max_times = 1,
		unique_id = "objective_description",
		param1 = "current_level_name",
		layout_settings = HUDSettings.announcements.objective
	},
	interact_with_attackers_objective = {
		show_max_times = 1,
		unique_id = "objective_description",
		param1 = "attackers_objectives_grouped_on_interaction",
		layout_settings = HUDSettings.announcements.objective
	},
	defend_attackers_objective = {
		show_max_times = 1,
		unique_id = "objective_description",
		param1 = "attackers_objective_ui_names",
		layout_settings = HUDSettings.announcements.objective
	},
	kill_tagged_enemy = {
		unique_id = "objective_description",
		no_text = true
	},
	execute_tagged_enemy = {
		unique_id = "objective_description",
		no_text = true
	},
	defend_tagged_team_member = {
		unique_id = "objective_description",
		no_text = true
	},
	revive_tagged_team_member = {
		unique_id = "objective_description",
		no_text = true,
		layout_settings = HUDSettings.announcements.objective
	},
	attack_tagged_objective = {
		unique_id = "objective_description",
		no_text = true
	},
	defend_tagged_objective = {
		unique_id = "objective_description",
		no_text = true
	},
	pitched_battle_tiebreak = {
		unique_id = "objective_description",
		show_max_times = 1,
		layout_settings = HUDSettings.announcements.objective
	},
	pitched_battle_last_man_standing = {
		sound_event = "vo_announcement_pitched_battle_last_one_standing",
		no_text = true
	},
	tdm_time_running_out = {
		sound_event = "vo_announcement_tdm_time_running_out",
		show_max_times = 1,
		no_text = true
	},
	tdm_taken_the_lead = {
		sound_event = "vo_announcement_tdm_taken_the_lead",
		unique_id = "tdm_lead",
		interrupt_prio = 5,
		no_text = true
	},
	tdm_lost_the_lead = {
		sound_event = "vo_announcement_tdm_lost_the_lead",
		unique_id = "tdm_lead",
		interrupt_prio = 5,
		no_text = true
	},
	conq_pull_back = {
		sound_event = "vo_announcement_lost_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	conq_move_forward = {
		sound_event = "vo_announcement_new_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	conq_losing_objective = {
		sound_event = "vo_announcement_capture_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	conq_taking_objective = {
		sound_event = "vo_announcement_taking_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	domination_winning = {
		sound_event = "vo_announcement_domination_winning",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	domination_losing = {
		sound_event = "vo_announcement_domination_losing",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	domination_win_by_domination_imminent_them = {
		sound_event = "vo_announcement_domination_lost_all_objectives",
		layout_settings = HUDSettings.announcements.objective
	},
	domination_win_by_domination_imminent_you = {
		sound_event = "vo_announcement_domination_captured_all_objectives",
		layout_settings = HUDSettings.announcements.objective
	},
	domination_captured_objective_you = {
		localize_parameters = true,
		no_text = true,
		sound_events = {
			default = "vo_announcement_conquest_captured_objective",
			objective_shipyard = "vo_announcement_conquest_captured_shipyard",
			objective_meadhall = "vo_announcement_conquest_captured_mead_hall",
			objective_south_gate = "vo_announcement_conquest_captured_south_gate",
			objective_cairnstones = "vo_announcement_conquest_captured_cairn_stones",
			objective_longhouse = "vo_announcement_conquest_captured_longhouse",
			objective_hollow = "vo_announcement_conquest_captured_hollow",
			objective_clearing = "vo_announcement_conquest_captured_clearing",
			objective_beach = "vo_announcement_conquest_captured_beach",
			objective_town_gate = "vo_announcement_conquest_captured_town_gate",
			objective_grove = "vo_announcement_conquest_captured_grove",
			objective_village_square = "vo_announcement_conquest_captured_village_square",
			objective_tower_dom = "vo_announcement_domination_captured_tower",
			objective_road = "vo_announcement_conquest_captured_road",
			objective_cairn_stones_dom = "vo_announcement_domination_captured_cairn_stones",
			objective_wall = "vo_announcement_conquest_captured_wall",
			objective_cliffside = "vo_announcement_conquest_captured_cliffside",
			objective_river_crossing = "vo_announcement_conquest_captured_river_crossing",
			objective_ruins = "vo_announcement_conquest_captured_ruins",
			objective_beachhead = "vo_announcement_conquest_captured_beachhead",
			objective_blacksmith = "vo_announcement_conquest_captured_blacksmith",
			objective_lodge = "vo_announcement_conquest_captured_lodge",
			objective_tavern_dom = "vo_announcement_domination_captured_tavern",
			objective_stockade_dom = "vo_announcement_domination_captured_stockade",
			objective_tavern = "vo_announcement_conquest_captured_tavern",
			objective_shipyard_dom = "vo_announcement_domination_captured_shipyard",
			objective_ravine = "vo_announcement_conquest_captured_ravine",
			objective_riverbank = "vo_announcement_conquest_captured_riverbank",
			objective_tower = "vo_announcement_conquest_captured_tower",
			objective_hilltop = "vo_announcement_conquest_captured_hilltop",
			objective_bridge = "vo_announcement_conquest_captured_bridge",
			objective_southern_gate = "vo_announcement_conquest_captured_southern_gate",
			objective_stockade = "vo_announcement_conquest_captured_stockade",
			objective_lakeside = "vo_announcement_conquest_captured_lakeside",
			objective_storehouse = "vo_announcement_conquest_captured_storehouse",
			objective_foundry = "vo_announcement_conquest_captured_foundry",
			objective_landing = "vo_announcement_conquest_captured_landing",
			objective_landing_dom = "vo_announcement_domination_captured_landing"
		},
		sound_event_function = function(local_player, announcement_settings, capture_point_name, team_ui_name)
			local events = announcement_settings.sound_events

			return events[capture_point_name] or events.default
		end,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	domination_captured_objective_them = {
		localize_parameters = true,
		no_text = true,
		sound_events = {
			default = "vo_announcement_conquest_lost_objective",
			objective_shipyard = "vo_announcement_conquest_lost_shipyard",
			objective_meadhall = "vo_announcement_conquest_lost_mead_hall",
			objective_south_gate = "vo_announcement_conquest_lost_south_gate",
			objective_cairnstones = "vo_announcement_conquest_lost_cairn_stones",
			objective_longhouse = "vo_announcement_conquest_lost_longhouse",
			objective_hollow = "vo_announcement_conquest_lost_hollow",
			objective_clearing = "vo_announcement_conquest_lost_clearing",
			objective_beach = "vo_announcement_conquest_lost_beach",
			objective_town_gate = "vo_announcement_conquest_lost_town_gate",
			objective_grove = "vo_announcement_conquest_lost_grove",
			objective_village_square = "vo_announcement_conquest_lost_village_square",
			objective_tower_dom = "vo_announcement_domination_lost_tower",
			objective_road = "vo_announcement_conquest_lost_road",
			objective_cairn_stones_dom = "vo_announcement_domination_lost_cairn_stones",
			objective_wall = "vo_announcement_conquest_lost_wall",
			objective_cliffside = "vo_announcement_conquest_lost_cliffside",
			objective_river_crossing = "vo_announcement_conquest_lost_river_crossing",
			objective_ruins = "vo_announcement_conquest_lost_ruins",
			objective_beachhead = "vo_announcement_conquest_lost_beachhead",
			objective_blacksmith = "vo_announcement_conquest_lost_blacksmith",
			objective_lodge = "vo_announcement_conquest_lost_lodge",
			objective_tavern_dom = "vo_announcement_domination_lost_tavern",
			objective_stockade_dom = "vo_announcement_domination_lost_stockade",
			objective_tavern = "vo_announcement_conquest_lost_tavern",
			objective_shipyard_dom = "vo_announcement_domination_lost_shipyard",
			objective_ravine = "vo_announcement_conquest_lost_ravine",
			objective_riverbank = "vo_announcement_conquest_lost_riverbank",
			objective_tower = "vo_announcement_conquest_lost_tower",
			objective_hilltop = "vo_announcement_conquest_lost_hilltop",
			objective_bridge = "vo_announcement_conquest_lost_bridge",
			objective_southern_gate = "vo_announcement_conquest_lost_southern_gate",
			objective_stockade = "vo_announcement_conquest_lost_stockade",
			objective_lakeside = "vo_announcement_conquest_lost_lakeside",
			objective_storehouse = "vo_announcement_conquest_lost_storehouse",
			objective_foundry = "vo_announcement_conquest_lost_foundry",
			objective_landing = "vo_announcement_conquest_lost_landing",
			objective_landing_dom = "vo_announcement_domination_lost_landing"
		},
		sound_event_function = function(local_player, announcement_settings, capture_point_name, team_ui_name)
			local events = announcement_settings.sound_events

			return events[capture_point_name] or events.default
		end,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	conquest_captured_objective_you = {
		localize_parameters = true,
		sound_events = {
			default = "vo_announcement_conquest_captured_objective",
			objective_hollow = "vo_announcement_conquest_captured_hollow",
			objective_grove = "vo_announcement_conquest_captured_grove",
			objective_south_gate = "vo_announcement_conquest_captured_south_gate",
			objective_cairnstones = "vo_announcement_conquest_captured_cairn_stones",
			objective_longhouse = "vo_announcement_conquest_captured_longhouse",
			objective_tavern = "vo_announcement_conquest_captured_tavern",
			objective_river_crossing = "vo_announcement_conquest_captured_river_crossing",
			objective_beach = "vo_announcement_conquest_captured_beach",
			objective_meadhall = "vo_announcement_conquest_captured_mead_hall",
			objective_riverbank = "vo_announcement_conquest_captured_riverbank",
			objective_tower = "vo_announcement_conquest_captured_tower",
			objective_hilltop = "vo_announcement_conquest_captured_hilltop",
			objective_road = "vo_announcement_conquest_captured_road",
			objective_foundry = "vo_announcement_conquest_captured_foundry",
			objective_stockade = "vo_announcement_conquest_captured_stockade",
			objective_bridge = "vo_announcement_conquest_captured_bridge",
			objective_ravine = "vo_announcement_conquest_captured_ravine",
			objective_shipyard = "vo_announcement_conquest_captured_shipyard",
			objective_southern_gate = "vo_announcement_conquest_captured_southern_gate",
			objective_cliffside = "vo_announcement_conquest_captured_cliffside",
			objective_town_gate = "vo_announcement_conquest_captured_town_gate",
			objective_lakeside = "vo_announcement_conquest_captured_lakeside",
			objective_ruins = "vo_announcement_conquest_captured_ruins",
			objective_storehouse = "vo_announcement_conquest_captured_storehouse",
			objective_village_square = "vo_announcement_conquest_captured_village_square",
			objective_wall = "vo_announcement_conquest_captured_wall",
			objective_beachhead = "vo_announcement_conquest_captured_beachhead",
			objective_clearing = "vo_announcement_conquest_captured_clearing",
			objective_blacksmith = "vo_announcement_conquest_captured_blacksmith",
			objective_landing = "vo_announcement_conquest_captured_landing",
			objective_lodge = "vo_announcement_conquest_captured_lodge"
		},
		sound_event_function = function(local_player, announcement_settings, capture_point_name, team_ui_name)
			local events = announcement_settings.sound_events

			return events[capture_point_name] or events.default
		end,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	conquest_captured_objective_them = {
		localize_parameters = true,
		sound_events = {
			default = "vo_announcement_conquest_lost_objective",
			objective_hollow = "vo_announcement_conquest_lost_hollow",
			objective_grove = "vo_announcement_conquest_lost_grove",
			objective_south_gate = "vo_announcement_conquest_lost_south_gate",
			objective_cairnstones = "vo_announcement_conquest_lost_cairn_stones",
			objective_longhouse = "vo_announcement_conquest_lost_longhouse",
			objective_tavern = "vo_announcement_conquest_lost_tavern",
			objective_river_crossing = "vo_announcement_conquest_lost_river_crossing",
			objective_beach = "vo_announcement_conquest_lost_beach",
			objective_meadhall = "vo_announcement_conquest_lost_mead_hall",
			objective_riverbank = "vo_announcement_conquest_lost_riverbank",
			objective_tower = "vo_announcement_conquest_lost_tower",
			objective_hilltop = "vo_announcement_conquest_lost_hilltop",
			objective_road = "vo_announcement_conquest_lost_road",
			objective_foundry = "vo_announcement_conquest_lost_foundry",
			objective_stockade = "vo_announcement_conquest_lost_stockade",
			objective_bridge = "vo_announcement_conquest_lost_bridge",
			objective_ravine = "vo_announcement_conquest_lost_ravine",
			objective_shipyard = "vo_announcement_conquest_lost_shipyard",
			objective_southern_gate = "vo_announcement_conquest_lost_southern_gate",
			objective_cliffside = "vo_announcement_conquest_lost_cliffside",
			objective_town_gate = "vo_announcement_conquest_lost_town_gate",
			objective_lakeside = "vo_announcement_conquest_lost_lakeside",
			objective_ruins = "vo_announcement_conquest_lost_ruins",
			objective_storehouse = "vo_announcement_conquest_lost_storehouse",
			objective_village_square = "vo_announcement_conquest_lost_village_square",
			objective_wall = "vo_announcement_conquest_lost_wall",
			objective_beachhead = "vo_announcement_conquest_lost_beachhead",
			objective_clearing = "vo_announcement_conquest_lost_clearing",
			objective_blacksmith = "vo_announcement_conquest_lost_blacksmith",
			objective_landing = "vo_announcement_conquest_lost_landing",
			objective_lodge = "vo_announcement_conquest_lost_lodge"
		},
		sound_event_function = function(local_player, announcement_settings, capture_point_name, team_ui_name)
			local events = announcement_settings.sound_events

			return events[capture_point_name] or events.default
		end,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	conquest_capturing_objective_them = {
		localize_parameters = true,
		cooldown = 30,
		sound_events = {
			default = "vo_announcement_conquest_losing_objective",
			objective_hollow = "vo_announcement_conquest_losing_hollow",
			objective_grove = "vo_announcement_conquest_losing_grove",
			objective_south_gate = "vo_announcement_conquest_losing_south_gate",
			objective_cairnstones = "vo_announcement_conquest_losing_cairn_stones",
			objective_longhouse = "vo_announcement_conquest_losing_longhouse",
			objective_tavern = "vo_announcement_conquest_losing_tavern",
			objective_river_crossing = "vo_announcement_conquest_losing_river_crossing",
			objective_beach = "vo_announcement_conquest_losing_beach",
			objective_meadhall = "vo_announcement_conquest_losing_mead_hall",
			objective_riverbank = "vo_announcement_conquest_losing_riverbank",
			objective_tower = "vo_announcement_conquest_losing_tower",
			objective_hilltop = "vo_announcement_conquest_losing_hilltop",
			objective_road = "vo_announcement_conquest_losing_road",
			objective_foundry = "vo_announcement_conquest_losing_foundry",
			objective_stockade = "vo_announcement_conquest_losing_stockade",
			objective_bridge = "vo_announcement_conquest_losing_bridge",
			objective_ravine = "vo_announcement_conquest_losing_ravine",
			objective_shipyard = "vo_announcement_conquest_losing_shipyard",
			objective_southern_gate = "vo_announcement_conquest_losing_southern_gate",
			objective_cliffside = "vo_announcement_conquest_losing_cliffside",
			objective_town_gate = "vo_announcement_conquest_losing_town_gate",
			objective_lakeside = "vo_announcement_conquest_losing_lakeside",
			objective_ruins = "vo_announcement_conquest_losing_ruins",
			objective_storehouse = "vo_announcement_conquest_losing_storehouse",
			objective_village_square = "vo_announcement_conquest_losing_village_square",
			objective_wall = "vo_announcement_conquest_losing_wall",
			objective_beachhead = "vo_announcement_conquest_losing_beachhead",
			objective_clearing = "vo_announcement_conquest_losing_clearing",
			objective_blacksmith = "vo_announcement_conquest_losing_blacksmith",
			objective_landing = "vo_announcement_conquest_losing_landing",
			objective_lodge = "vo_announcement_conquest_losing_lodge"
		},
		sound_event_function = function(local_player, announcement_settings, capture_point_name, team_ui_name)
			local events = announcement_settings.sound_events

			return events[capture_point_name] or events.default
		end,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	conquest_objective_unlocked_by_time_them = {
		sound_event = "vo_announcement_conquest_new_capture_objective",
		localize_parameters = true,
		layout_settings = HUDSettings.announcements.winning_losing
	},
	conquest_objective_unlocked_by_time_you = {
		sound_event = "vo_announcement_conquest_new_defend_objective",
		no_text = true
	},
	team_interacted_with_objective = {
		layout_settings = HUDSettings.announcements.winning_losing
	},
	raid_defend_gates = {
		sound_event = "vo_announcement_lost_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	raid_breach_gates = {
		sound_event = "vo_announcement_taking_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	raid_locate_loot = {
		sound_event = "vo_announcement_taking_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	raid_defend_loot = {
		sound_event = "vo_announcement_lost_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	raid_escape = {
		sound_event = "vo_announcement_taking_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	raid_guard = {
		sound_event = "vo_announcement_lost_objective_temp",
		unique_id = "objective_description",
		layout_settings = HUDSettings.announcements.objective
	},
	new_squad_leader = {
		unique_id = "squad_leader_notification",
		layout_settings = HUDSettings.announcements.objective
	},
	only_time_left = {
		sound_event = "hud_countdown",
		unique_id = "timer",
		param1 = "round_time_left",
		layout_settings = HUDSettings.announcements.round_timer
	},
	own_team_is_winning = {
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	own_team_have_nearly_won = {
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	own_team_is_losing = {
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	own_team_have_nearly_lost = {
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	own_team_only_need_last_point = {
		param2 = "last_objective_ui_name",
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	own_team_have_captured_all_points = {
		param1 = "own_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	enemy_team_only_need_last_point = {
		param2 = "last_objective_enemy_ui_name",
		param1 = "enemy_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	enemy_team_have_captured_all_points = {
		param1 = "enemy_team_ui_name",
		layout_settings = HUDSettings.announcements.winning_losing
	},
	headshot = {
		discard_time = 4,
		layout_settings = HUDSettings.announcements.achievement
	},
	longshot = {
		layout_settings = HUDSettings.announcements.achievement
	},
	killstreak = {
		discard_time = 4,
		layout_settings = HUDSettings.announcements.achievement
	},
	multi_killstreak = {
		layout_settings = HUDSettings.announcements.achievement
	},
	mega_killstreak = {
		layout_settings = HUDSettings.announcements.achievement
	},
	last_stand_activated = {
		layout_settings = HUDSettings.announcements.achievement
	},
	deserter_out_of_bonds = {
		sound_event = "vo_announcement_out_of_bounds",
		unique_id = "timer",
		interrupt_prio = 10,
		layout_settings = HUDSettings.announcements.deserter_timer
	},
	traitor_out_of_bonds = {
		sound_event = "hud_countdown",
		unique_id = "timer",
		layout_settings = HUDSettings.announcements.deserter_timer
	},
	sp_tutorial_name_objective_completed = {
		sound_event = "Play_objective_win",
		layout_settings = HUDSettings.announcements.objective
	},
	sp_tutorial_description_objective_push = {
		layout_settings = HUDSettings.announcements.objective
	},
	team_request_revive_notification = {
		layout_settings = HUDSettings.announcements.team_help_request
	},
	squad_request_revive_notification = {
		layout_settings = HUDSettings.announcements.squad_help_request
	},
	squad_received_bandage_notification = {
		layout_settings = HUDSettings.announcements.squad_help_request
	},
	duel_challenge_notification = {
		layout_settings = HUDSettings.announcements.duel_challenge
	},
	duel_win = {
		sound_event = "Play_objective_win",
		layout_settings = HUDSettings.announcements.objective
	},
	duel_loss = {
		sound_event = "Play_objective_fail",
		layout_settings = HUDSettings.announcements.objective
	},
	duel_draw = {
		sound_event = "Play_objective_fail",
		layout_settings = HUDSettings.announcements.objective
	},
	team_deathmatch_description = {
		show_max_times = 1,
		container = true,
		interrupt_prio = 50,
		unique_id = "game_mode_description",
		layout_settings = HUDSettings.announcements.game_description_container,
		elements = {
			{
				text = "game_mode_description_tdm_header",
				layout_settings = HUDSettings.announcements.game_description_header_text
			},
			{
				text = "game_mode_description_tdm_sub_text",
				layout_settings = HUDSettings.announcements.game_description_sub_text
			}
		},
		container_sound_events = {
			{
				start_time = 0.1,
				sound_func = function(player)
					local parameters = {}

					parameters[1] = "character_announcer"

					local team_name = player.team.name

					if team_name == "red" then
						parameters[2] = "vikings"
					else
						parameters[2] = "saxons"
					end

					return "vo_announcement_tdm_start", parameters
				end
			}
		}
	},
	battle_description = {
		show_max_times = 1,
		container = true,
		interrupt_prio = 50,
		unique_id = "game_mode_description",
		layout_settings = HUDSettings.announcements.game_description_container,
		elements = {
			{
				text = "game_mode_description_battle_header",
				layout_settings = HUDSettings.announcements.game_description_header_text
			},
			{
				text = "game_mode_description_battle_sub_text",
				layout_settings = HUDSettings.announcements.game_description_sub_text
			}
		},
		container_sound_events = {
			{
				start_time = 0.1,
				sound_func = function(player)
					local parameters = {}

					parameters[1] = "character_announcer"

					local team_name = player.team.name

					if team_name == "red" then
						parameters[2] = "vikings"
					else
						parameters[2] = "saxons"
					end

					return "vo_announcement_pitched_battle_start", parameters
				end
			}
		}
	},
	arena_description = {
		show_max_times = 1,
		container = true,
		interrupt_prio = 50,
		unique_id = "game_mode_description",
		layout_settings = HUDSettings.announcements.game_description_container,
		elements = {
			{
				text = "game_mode_description_arena_header",
				layout_settings = HUDSettings.announcements.game_description_header_text
			},
			{
				text = "game_mode_description_arena_sub_text",
				layout_settings = HUDSettings.announcements.game_description_sub_text
			}
		},
		container_sound_events = {
			{
				start_time = 0.1,
				sound_func = function(player)
					local parameters = {}

					parameters[1] = "character_announcer"

					local team_name = player.team.name

					if team_name == "red" then
						parameters[2] = "vikings"
					else
						parameters[2] = "saxons"
					end

					return "vo_announcement_arena_start", parameters
				end
			}
		}
	},
	conquest_description = {
		show_max_times = 1,
		container = true,
		interrupt_prio = 50,
		unique_id = "game_mode_description",
		layout_settings = HUDSettings.announcements.game_description_container,
		elements = {
			{
				text = "game_mode_description_con_header",
				layout_settings = HUDSettings.announcements.game_description_header_text
			},
			{
				text = "game_mode_description_con_sub_text",
				layout_settings = HUDSettings.announcements.game_description_sub_text
			}
		},
		container_sound_events = {
			{
				start_time = 0.1,
				sound_func = function(player)
					local parameters = {}

					parameters[1] = "character_announcer"

					local team_name = player.team.name

					if team_name == "red" then
						parameters[2] = "vikings"
					else
						parameters[2] = "saxons"
					end

					return "vo_announcement_conquest_start", parameters
				end
			}
		}
	},
	domination_description = {
		show_max_times = 1,
		container = true,
		interrupt_prio = 50,
		unique_id = "game_mode_description",
		layout_settings = HUDSettings.announcements.game_description_container,
		elements = {
			{
				text = "game_mode_description_dom_header",
				layout_settings = HUDSettings.announcements.game_description_header_text
			},
			{
				text = "game_mode_description_dom_sub_text",
				layout_settings = HUDSettings.announcements.game_description_sub_text
			}
		},
		container_sound_events = {
			{
				start_time = 0.1,
				sound_func = function(player)
					local parameters = {}

					parameters[1] = "character_announcer"

					local team_name = player.team.name

					if team_name == "red" then
						parameters[2] = "vikings"
					else
						parameters[2] = "saxons"
					end

					return "vo_announcement_domination_start", parameters
				end
			}
		}
	},
	rank_up = {
		show_max_times = 60,
		container = true,
		interrupt_prio = 60,
		unique_id = "rank_up",
		layout_settings = HUDSettings.announcements.rank_up_container,
		discard_time = math.huge,
		elements = {
			{
				text = "you_have_reached",
				layout_settings = HUDSettings.announcements.rank_up_header_text
			},
			{
				text_func = "rank_up_level_reached_text",
				layout_settings = HUDSettings.announcements.rank_up_text
			},
			{
				text_func = "rank_up_unlock_text",
				layout_settings = HUDSettings.announcements.rank_up_footer_text
			}
		},
		container_sound_events = {}
	},
	short_term_goal_achieved = {
		container = true,
		unique_id = "short_term_goal_achieved",
		layout_settings = HUDSettings.announcements.short_term_goal_achieved_container,
		discard_time = math.huge,
		elements = {
			{
				text_func = "short_term_goal_achieved",
				layout_settings = HUDSettings.announcements.short_term_goal_achieved_text
			},
			{
				text_func = "coin_bonus_gained",
				layout_settings = HUDSettings.announcements.short_term_goal_achieved_footer_text
			}
		},
		container_sound_events = {}
	}
}
