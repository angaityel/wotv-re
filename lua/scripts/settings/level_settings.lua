-- chunkname: @scripts/settings/level_settings.lua

require("scripts/settings/game_mode_settings")
require("scripts/settings/menu_settings")

local DEFAULT_TIP_LIST = {
	"tip_1",
	"tip_2",
	"tip_3",
	"tip_4",
	"tip_5",
	"tip_6",
	"tip_7",
	"tip_8",
	"tip_9",
	"tip_10",
	"tip_11",
	"tip_12",
	"tip_13",
	"tip_14",
	"tip_15",
	"tip_16",
	"tip_17",
	"tip_18",
	"tip_19",
	"tip_20",
	"tip_21",
	"tip_22",
	"tip_23",
	"tip_24",
	"tip_25",
	"tip_26",
	"tip_27",
	"tip_28"
}

LevelSettings = {
	editor_level = {
		package_name = "resource_packages/levels/whitebox",
		ghost_mode_setting = "ghost_mode",
		map_id = 1,
		deserter_setting = "deserting",
		display_name = "level_editor",
		game_server_map_name = "Editor Level",
		sort_index = 999,
		last_stand_setting = "bleeding",
		visible = false,
		loading_background = "loading_screen_wip",
		single_player = true,
		ui_description = "level_description_missing",
		executed_setting = "executed",
		knocked_down_setting = "knocked_down",
		level_name = "__level_editor_test",
		sp_progression_id = 0,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "mockup_loading_1920",
			texture_1366 = "mockup_loading_1920"
		}
	},
	whitebox = {
		package_name = "resource_packages/levels/whitebox",
		ghost_mode_setting = "ghost_mode",
		map_id = 2,
		deserter_setting = "deserting",
		display_name = "level_whitebox",
		sort_index = 1,
		last_stand_setting = "bleeding",
		visible = true,
		loading_background = "loading_screen_wip",
		single_player = false,
		game_server_map_name = "Whitebox",
		ui_description = "level_description_whitebox",
		executed_setting = "executed",
		knocked_down_setting = "knocked_down",
		level_name = "levels/whitebox/world",
		sp_progression_id = 0,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con,
			GameModeSettings.battle
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "mockup_loading_1920",
			texture_1366 = "mockup_loading_1920"
		},
		con = {
			capture_speeds = {
				0.1,
				0.2,
				0.2,
				0.1
			}
		}
	},
	Cliff = {
		package_name = "resource_packages/levels/cliff_new",
		game_server_map_name = "cliff",
		map_id = 3,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 2,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_cliff",
		stop_music = "Stop_cliff_battle_music",
		ui_description = "level_description_mp_cliff_01",
		loading_background = "cliff_load_wip",
		executed_setting = "executed",
		music = "Play_cliff_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/cliff_new/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con,
			GameModeSettings.battle,
			GameModeSettings.arena,
			GameModeSettings.ass
		},
		level_particle_effects = {
			"fx/rain_cylinder"
		},
		level_screen_effects = {
			"fx/screenspace_raindrops"
		},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Forest = {
		package_name = "resource_packages/levels/forest_01",
		game_server_map_name = "forest",
		map_id = 4,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 3,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_forest",
		stop_music = "Stop_forest_battle_music",
		ui_description = "level_description_mp_forest_01",
		loading_background = "forest_load",
		executed_setting = "executed",
		music = "Play_forest_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/forest_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con,
			GameModeSettings.battle,
			GameModeSettings.ass
		},
		level_particle_effects = {
			"fx/camera_effect_forest"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Docks = {
		package_name = "resource_packages/levels/york_01",
		game_server_map_name = "docks",
		map_id = 5,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 4,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_docks",
		stop_music = "Stop_york_battle_music",
		ui_description = "level_description_mp_forest_01",
		loading_background = "york_loading_screen",
		executed_setting = "executed",
		music = "Play_york_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/york_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con,
			GameModeSettings.battle,
			GameModeSettings.arena,
			GameModeSettings.headhunter
		},
		level_particle_effects = {
			"fx/camera_effect_docks"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Gauntlet = {
		package_name = "resource_packages/levels/gauntlet_01",
		game_server_map_name = "gauntlet",
		map_id = 6,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 5,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_gauntlet",
		stop_music = "Stop_holmgang_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "holmgang_load_wip",
		executed_setting = "executed",
		music = "Play_holmgang_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/gauntlet_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.arena
		},
		level_particle_effects = {
			"fx/camera_effect_gauntlet"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Monastery = {
		package_name = "resource_packages/levels/monastery_01",
		game_server_map_name = "monastery",
		map_id = 7,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 6,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_monastery",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "monastery_load_wip",
		executed_setting = "executed",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/monastery_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.arena
		},
		level_particle_effects = {
			"fx/camera_effect_monastery"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Crag = {
		package_name = "resource_packages/levels/crag_01",
		game_server_map_name = "crag",
		map_id = 8,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 7,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_crag",
		stop_music = "Stop_holmgang_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "crag_load",
		executed_setting = "executed",
		music = "Play_holmgang_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/crag_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.arena,
			GameModeSettings.tdm
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Sanctuary = {
		package_name = "resource_packages/levels/sanctuary_01",
		game_server_map_name = "sanctuary",
		map_id = 9,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 8,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_sanctuary",
		stop_music = "Stop_cliff_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "haven_load",
		executed_setting = "executed",
		music = "Play_cliff_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/sanctuary_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.arena
		},
		level_particle_effects = {
			"fx/camera_effect_sanctuary"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Tutorial = {
		level_name = "levels/tutorial_01/world",
		game_server_map_name = "tutorial",
		map_id = 10,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		single_player_game_mode = "sp",
		show_in_server_browser = false,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = true,
		sort_index = 9,
		display_name = "level_tutorial",
		ui_description = "level_description_mp_island_01",
		loading_background = "tutorial_load",
		executed_setting = "executed",
		knocked_down_setting = "knocked_down",
		package_name = "resource_packages/levels/tutorial_01",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Icefloe = {
		package_name = "resource_packages/levels/iceflow_01",
		game_server_map_name = "icefloe",
		map_id = 11,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_activate",
		show_in_server_browser = true,
		sort_index = 10,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_iceflow",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "iceflow_loading_screen",
		executed_setting = "executed",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/iceflow_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.arena
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Stronghold = {
		package_name = "resource_packages/levels/stronghold_01",
		game_server_map_name = "stronghold",
		map_id = 12,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 11,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_stronghold",
		stop_music = "Stop_york_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "brekka_loading_screen",
		executed_setting = "executed",
		music = "Play_york_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/stronghold_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.con,
			GameModeSettings.battle,
			GameModeSettings.tdm
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Village = {
		package_name = "resource_packages/levels/village_01",
		game_server_map_name = "village",
		map_id = 13,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 12,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_village",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_monastery_battle_music",
		executed_setting = "executed",
		loading_background = "village_load",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/village_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.domination,
			GameModeSettings.tdm
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		},
		minimap = {
			scale = 1,
			rotation = 1.7,
			anchor = {
				89,
				-10
			},
			fade = {
				outer = 85,
				inner = 60
			},
			spawn_points = {
				red = Vector3Box(88, -83, 30),
				white = Vector3Box(110, 55, 29)
			}
		}
	},
	Ravine = {
		package_name = "resource_packages/levels/grove_01",
		game_server_map_name = "ravine",
		map_id = 14,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 13,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_grove",
		stop_music = "Stop_forest_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "grove_load",
		executed_setting = "executed",
		music = "Play_forest_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/grove_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.con,
			GameModeSettings.battle
		},
		level_particle_effects = {
			"fx/camera_effect_grove"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Tide = {
		package_name = "resource_packages/levels/tide_01",
		game_server_map_name = "tide",
		map_id = 15,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 14,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_tide",
		stop_music = "Stop_cliff_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "tide_load",
		executed_setting = "executed",
		music = "Play_cliff_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/tide_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.arena,
			GameModeSettings.tdm
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Ruins = {
		package_name = "resource_packages/levels/forest_02",
		game_server_map_name = "Ruins",
		map_id = 16,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 15,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_ForestArena",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "ruins_loading_screen",
		executed_setting = "executed",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/forest_02/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.arena
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Northbound = {
		package_name = "resource_packages/levels/northbound_01",
		game_server_map_name = "northbound",
		map_id = 17,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_activate",
		sort_index = 16,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_northbound",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "northbound_load",
		executed_setting = "executed",
		show_in_server_browser = true,
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/northbound_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.battle,
			GameModeSettings.con
		},
		level_particle_effects = {
			"fx/snow_test"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		},
		con = {
			capture_speeds = {
				0.0625,
				0.0625,
				0.05,
				0.0625,
				0.0625
			}
		}
	},
	Strand = {
		package_name = "resource_packages/levels/wip_01",
		game_server_map_name = "strand",
		map_id = 18,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 17,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_strand",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "strand_load",
		executed_setting = "executed",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/wip_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle
		},
		level_particle_effects = {},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Outpost = {
		package_name = "resource_packages/levels/dom_whitebox_1",
		game_server_map_name = "outpost",
		map_id = 19,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_activate",
		show_in_server_browser = true,
		sort_index = 18,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_outpost",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_monastery_battle_music",
		executed_setting = "executed",
		loading_background = "outpost_load",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/dom_whitebox_1/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.domination,
			GameModeSettings.tdm
		},
		level_particle_effects = {
			"fx/snow_test"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		},
		minimap = {
			scale = 1,
			rotation = 3.93 - math.pi * 0.5,
			anchor = {
				46,
				-41
			},
			fade = {
				outer = 85,
				inner = 60
			},
			spawn_points = {
				red = Vector3Box(36.05, -92.018, 48.324),
				white = Vector3Box(-4, -53, 42)
			}
		}
	},
	Mire = {
		package_name = "resource_packages/levels/newlevel",
		game_server_map_name = "mire",
		map_id = 20,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 19,
		last_stand_setting = "bleeding",
		visible = true,
		ghost_mode_setting = "ghost_mode",
		single_player = false,
		display_name = "level_mire",
		stop_music = "Stop_monastery_battle_music",
		ui_description = "level_description_mp_island_01",
		loading_background = "mire_load",
		executed_setting = "executed",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/newlevel/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle
		},
		level_particle_effects = {
			"fx/camera_effect_gauntlet"
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	dom_whitebox_2 = {
		package_name = "resource_packages/levels/dom_whitebox_2",
		game_server_map_name = "dom_whitebox_2",
		map_id = 21,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_activate",
		show_in_server_browser = true,
		sort_index = 20,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_dom_whitebox_2",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_monastery_battle_music",
		executed_setting = "executed",
		loading_background = "outpost_load",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/dom_whitebox_2/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.domination,
			GameModeSettings.tdm,
			GameModeSettings.con
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	dom_whitebox_3 = {
		package_name = "resource_packages/levels/dom_whitebox_3",
		game_server_map_name = "dom_whitebox_3",
		map_id = 22,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_activate",
		show_in_server_browser = true,
		sort_index = 21,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_dom_whitebox_3",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_monastery_battle_music",
		executed_setting = "executed",
		loading_background = "outpost_load",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/dom_whitebox_3/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.domination,
			GameModeSettings.tdm,
			GameModeSettings.con
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Market = {
		package_name = "resource_packages/levels/market_01",
		game_server_map_name = "market",
		map_id = 23,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 22,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_market",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_york_battle_music",
		executed_setting = "executed",
		loading_background = "market_loading_screen",
		music = "Play_york_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/market_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle,
			GameModeSettings.arena,
			GameModeSettings.con
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Holmgang = {
		package_name = "resource_packages/levels/holmgang_01",
		game_server_map_name = "holmgang",
		map_id = 24,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 23,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_holmgang",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_holmgang_battle_music",
		executed_setting = "executed",
		loading_background = "holmgang_loading_screen",
		music = "Play_holmgang_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/holmgang_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Desert = {
		package_name = "resource_packages/levels/desert_01",
		game_server_map_name = "desert",
		map_id = 25,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 24,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_desert",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_cliff_battle_music",
		executed_setting = "executed",
		loading_background = "desert_loading_screen",
		music = "Play_cliff_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/desert_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Cove = {
		package_name = "resource_packages/levels/cove_01",
		game_server_map_name = "cove",
		map_id = 26,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 25,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_cove",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_york_battle_music",
		executed_setting = "executed",
		loading_background = "cove_loading_screen",
		music = "Play_york_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/cove_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle,
			GameModeSettings.con
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Entryway = {
		package_name = "resource_packages/levels/entryway_01",
		game_server_map_name = "entryway",
		map_id = 27,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 26,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_entryway",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_monastery_battle_music",
		executed_setting = "executed",
		loading_background = "outpost_load",
		music = "Play_monastery_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/entryway_01/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.domination,
			GameModeSettings.tdm,
			GameModeSettings.battle,
			GameModeSettings.arena,
			GameModeSettings.con
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	Victor = {
		package_name = "resource_packages/levels/victor",
		game_server_map_name = "victor",
		map_id = 28,
		deserter_setting = "deserting",
		on_spawn_flow_event = "cold_breath_deactivate",
		show_in_server_browser = true,
		sort_index = 27,
		last_stand_setting = "bleeding",
		visible = true,
		single_player = false,
		display_name = "level_victor",
		ghost_mode_setting = "ghost_mode",
		ui_description = "level_description_mp_island_01",
		stop_music = "Stop_cliff_battle_music",
		executed_setting = "executed",
		loading_background = "victor_loading_screen",
		music = "Play_cliff_battle_music",
		knocked_down_setting = "knocked_down",
		level_name = "levels/victor/world",
		sp_progression_id = 6,
		sp_requirement_id = 0,
		tip_of_the_day = DEFAULT_TIP_LIST,
		game_modes = {
			GameModeSettings.tdm,
			GameModeSettings.battle
		},
		level_particle_effects = {
		},
		level_screen_effects = {},
		loading_screen_preview = {
			texture_1920 = "ravenspurn_loading_1920",
			texture_1366 = "ravenspurn_loading_1920"
		}
	},
	main_menu_whitebox = {
		ui_description = "level_description_missing",
		level_name = "levels/menu/main_menu_whitebox/world",
		display_name = "",
		sort_index = 999,
		visible = false,
		package_name = "resource_packages/levels/menu/main_menu_whitebox",
		game_modes = {}
	},
	main_menu_release = {
		ui_description = "level_description_missing",
		level_name = "levels/menu/main_menu_release/world",
		display_name = "",
		sort_index = 999,
		visible = false,
		package_name = "resource_packages/levels/menu/main_menu_release",
		game_modes = {}
	},
	main_menu_early_access = {
		ui_description = "level_description_missing",
		level_name = "levels/menu/main_menu_early_access/world",
		display_name = "",
		sort_index = 999,
		visible = false,
		package_name = "resource_packages/levels/menu/main_menu_early_access",
		game_modes = {}
	}
}

function server_map_name_to_level_key(name)
	for level_key, level_settings in pairs(LevelSettings) do
		if level_settings.game_server_map_name and level_settings.game_server_map_name:lower() == name:lower() then
			return level_key
		end
	end
end
