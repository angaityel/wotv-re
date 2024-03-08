-- chunkname: @scripts/settings/game_settings_development.lua

require("scripts/helpers/debug_helper")
require("scripts/settings/app_id_settings")

GameSettingsDevelopment = GameSettingsDevelopment or {}

local argv = {
	Application.argv()
}

UNLOCK_DLC = 230940
IS_DEMO = false
GameSettingsDevelopment.version_state = "full_game"
GameSettingsDevelopment.version_states = {
	full_game = {},
	alpha = {
		tag = {
			material = "alpha_logo",
			size = {
				256,
				128
			},
			offset = {
				0,
				-128,
				2
			}
		}
	},
	early_access = {
		tag = {
			material = "early_access",
			size = {
				256,
				128
			},
			offset = {
				0,
				-128,
				2
			}
		},
		version = {
			font = "materials/fonts/arial_16",
			align = "right",
			font_size = 16,
			version = "v1.0.0",
			material = "arial_16",
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				208,
				-75,
				3
			}
		}
	}
}
GameSettingsDevelopment.ingame_packages = {
	"resource_packages/menu",
	"resource_packages/weapons",
	"resource_packages/helmets",
	"resource_packages/character"
}

if script_data.settings.dedicated_server then
	GameSettingsDevelopment.delayed_load_packages = {
		"resource_packages/ingame"
	}
else
	GameSettingsDevelopment.delayed_load_packages = {
		"resource_packages/ingame",
		"resource_packages/ingame_sound"
	}
end

GameSettingsDevelopment.default_time_limit = 25920000
GameSettingsDevelopment.default_win_score = 100
GameSettingsDevelopment.buy_game_url = "http://www.waroftherosesvikings.com/buy"
GameSettingsDevelopment.twitter_url = "http://twitter.com/WaroftheVikings"
GameSettingsDevelopment.facebook_url = "http://www.facebook.com/WaroftheVikings"
GameSettingsDevelopment.survey_url = "http://steamcommunity.com/app/234530/guides/"
GameSettingsDevelopment.quicklaunch_params = GameSettingsDevelopment.quicklaunch_params or {}
GameSettingsDevelopment.quicklaunch_params.level_key = EDITOR_LAUNCH and "editor_level" or "castle_01"
GameSettingsDevelopment.quicklaunch_params.game_mode_key = "tdm"
GameSettingsDevelopment.quicklaunch_params.number_players = EDITOR_LAUNCH and 1 or 1
GameSettingsDevelopment.quicklaunch_params.spawn_clones = nil
GameSettingsDevelopment.start_state = EDITOR_LAUNCH and "game" or "menu"
GameSettingsDevelopment.disable_singleplayer = false
GameSettingsDevelopment.disable_coat_of_arms_editor = false
GameSettingsDevelopment.disable_character_sheet = false
GameSettingsDevelopment.disable_key_mappings = false
GameSettingsDevelopment.disable_uniform_lod = false
GameSettingsDevelopment.allow_old_join_game = true
GameSettingsDevelopment.network_timeout = 10
GameSettingsDevelopment.backend_timeout = 10
GameSettingsDevelopment.show_version_info = true
GameSettingsDevelopment.show_nda_in_splash_screen = false
GameSettingsDevelopment.server_license_check = true
GameSettingsDevelopment.enable_robot_player = false
GameSettingsDevelopment.robot_player_profile = "random"
GameSettingsDevelopment.all_on_same_team = false
GameSettingsDevelopment.allow_multiple_dot_effects = false
GameSettingsDevelopment.default_environment = "rendering/mercury_default"
GameSettingsDevelopment.debug_outlines = false
GameSettingsDevelopment.squad_first = false
GameSettingsDevelopment.hide_unavailable_gear_categories = false
GameSettingsDevelopment.use_bar_digits = false
GameSettingsDevelopment.allow_gamepad = true
GameSettingsDevelopment.allow_kick = true
GameSettingsDevelopment.debug_xp_gain = false
GameSettingsDevelopment.sp_spawn_in_ghost_mode = false
GameSettingsDevelopment.idle_kick_time = math.huge
GameSettingsDevelopment.tdm_spawning_debug = false
GameSettingsDevelopment.enum_slider_move_value = 20
GameSettingsDevelopment.override_navmesh_spawn = true
GameSettingsDevelopment.dev_build = false
GameSettingsDevelopment.backend = GameSettingsDevelopment.backend or {}
GameSettingsDevelopment.backend.test_backend = "0.0.0.0"
GameSettingsDevelopment.backend.live_backend = "0.0.0.0"
GameSettingsDevelopment.backend.testing_1_backend = "0.0.0.0"

GameSettingsDevelopment.enable_paradox_os = false

GameSettingsDevelopment.anti_cheat_enabled = false

if table.find(argv, "-no-tutorial") then
	GameSettingsDevelopment.enforce_tutorial = false
else
	GameSettingsDevelopment.enforce_tutorial = true
end

GameSettingsDevelopment.paradox_api = "https://0.0.0.0/%s"
GameSettingsDevelopment.paradox_api_key = "64DC4DC6508F4A9D823179D4D99DB4EE"
GameSettingsDevelopment.paradox_telemetry_api = "https://0.0.0.0/%s"

function GameSettingsDevelopment.game_server_created_callback()
	local app_id = SteamGameServer.app_id()

	if app_id == AppIDSettings.app_ids.main then
		if GameSettingsDevelopment.dev_build then
			GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.test_backend

			DebugHelper.debug_positions_and_rotations(true)
		else
			GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.live_backend

			DebugHelper.debug_positions_and_rotations(false)
		end
	else
		GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.testing_1_backend
	end
end

if script_data.settings.dedicated_server then
	GameSettingsDevelopment.network_mode = "steam"

	DebugHelper.debug_entity_manager(true)
elseif script_data.settings.content_revision then
	GameSettingsDevelopment.network_mode = "steam"

	if rawget(_G, "Steam") then
		local app_id = Steam.app_id()

		if app_id == AppIDSettings.app_ids.main then
			GameSettingsDevelopment.enable_micro_transactions = true
			GameSettingsDevelopment.allow_host_game = false
			GameSettingsDevelopment.unlock_all = false
			GameSettingsDevelopment.show_fps = Application.user_setting("show_fps") or false
			GameSettingsDevelopment.hide_lan_tab = false
			GameSettingsDevelopment.disable_singleplayer = false
			GameSettingsDevelopment.disable_coat_of_arms_editor = false
			GameSettingsDevelopment.disable_character_sheet = true
			GameSettingsDevelopment.disable_key_mappings = false
			GameSettingsDevelopment.disable_uniform_lod = not script_data.settings.uniform_lod
			GameSettingsDevelopment.allow_old_join_game = false
			GameSettingsDevelopment.hide_duel_mode = true
			GameSettingsDevelopment.show_version_info = false

			DebugHelper.debug_positions_and_rotations(false)

			GameSettingsDevelopment.disable_character_profiles_editor = false
			GameSettingsDevelopment.network_timeout = 6
			GameSettingsDevelopment.idle_kick_time = 300

			if GameSettingsDevelopment.dev_build then
				GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.test_backend
			else
				GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.live_backend
			end
		elseif app_id == AppIDSettings.app_ids.alpha then
			GameSettingsDevelopment.enable_micro_transactions = true
			GameSettingsDevelopment.allow_host_game = false
			GameSettingsDevelopment.unlock_all = false
			GameSettingsDevelopment.show_fps = Application.user_setting("show_fps") or false
			GameSettingsDevelopment.hide_lan_tab = false
			GameSettingsDevelopment.disable_singleplayer = false
			GameSettingsDevelopment.disable_coat_of_arms_editor = false
			GameSettingsDevelopment.disable_character_sheet = true
			GameSettingsDevelopment.disable_key_mappings = false
			GameSettingsDevelopment.disable_uniform_lod = not script_data.settings.uniform_lod
			GameSettingsDevelopment.allow_old_join_game = false
			GameSettingsDevelopment.hide_duel_mode = true
			GameSettingsDevelopment.show_version_info = false

			DebugHelper.debug_positions_and_rotations(true)
			DebugHelper.debug_rpcs(true)

			GameSettingsDevelopment.disable_character_profiles_editor = false
			GameSettingsDevelopment.network_timeout = 6
			GameSettingsDevelopment.idle_kick_time = 300
			GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.testing_1_backend
		end
	end
elseif Application.build() == "dev" or Application.build() == "debug" then
	if rawget(_G, "Steam") then
		local app_id = Steam.app_id()

		if app_id == AppIDSettings.app_ids.main then
			if GameSettingsDevelopment.dev_build then
				GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.test_backend
			else
				GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.live_backend
			end
		elseif app_id == AppIDSettings.app_ids.alpha then
			GameSettingsDevelopment.backend.address = GameSettingsDevelopment.backend.testing_1_backend
		end
	end

	GameSettingsDevelopment.disable_full_game_licence_check = false
	GameSettingsDevelopment.network_mode = EDITOR_LAUNCH and "lan" or table.find(argv, "-force-steam") and "steam" or "lan"
	GameSettingsDevelopment.unlock_all = true
	GameSettingsDevelopment.all_on_same_team = true
	GameSettingsDevelopment.allow_host_game = true
	GameSettingsDevelopment.show_fps = true
	GameSettingsDevelopment.enable_micro_transactions = false
	GameSettingsDevelopment.enable_debug_parry_stance = true

	DebugHelper.debug_positions_and_rotations(true)
	DebugHelper.debug_rpcs(true)

	GameSettingsDevelopment.disable_character_profiles_editor = false

	DebugHelper.debug_entity_manager(true)
else
	print("Running release game without content revision, quitting.")
	Application.quit()
end

GameSettingsDevelopment.network_port = 10000
GameSettingsDevelopment.network_revision_check_enabled = true
GameSettingsDevelopment.disable_loading_screen_menu = EDITOR_LAUNCH and true or false
GameSettingsDevelopment.exit_ingame_character_editor_round_time = -10
GameSettingsDevelopment.game_start_countdown = 1
GameSettingsDevelopment.prototype_spawn_fallback = false
GameSettingsDevelopment.lowest_resolution = 1024
GameSettingsDevelopment.disable_level_bar = false
GameSettingsDevelopment.physics_cull_husks = GameSettingsDevelopment.physics_cull_husks or {}
GameSettingsDevelopment.physics_cull_husks.cull_range = 15
GameSettingsDevelopment.physics_cull_husks.uncull_range = 10
GameSettingsDevelopment.bone_lod_husks = GameSettingsDevelopment.bone_lod_husks or {}
GameSettingsDevelopment.bone_lod_husks.lod_out_range = 16
GameSettingsDevelopment.bone_lod_husks.lod_in_range = 15
GameSettingsDevelopment.bone_lod_ais = GameSettingsDevelopment.bone_lod_ais or {}
GameSettingsDevelopment.bone_lod_ais.lod_out_range = 16
GameSettingsDevelopment.bone_lod_ais.lod_in_range = 15
GameSettingsDevelopment.min_team_size_to_save_stats = 1
GameSettingsDevelopment.backend_save_timeout = 5
GameSettingsDevelopment.backend_enforce_connection_in_splash_screen = false
GameSettingsDevelopment.allow_decapitation = true
GameSettingsDevelopment.enable_battle_chatter = true
GameSettingsDevelopment.shield_parry_indicator = false
GameSettingsDevelopment.allow_pommel_bash = false

if Application.build() == "release" or script_data.settings.content_revision and not table.find(argv, "-debug-stuff") then
	GameSettingsDevelopment.remove_debug_stuff = true
else
	GameSettingsDevelopment.remove_debug_stuff = false
end

script_data.extrapolation_debug = true

if script_data.settings.debug_mode then
	script_data.network_debug = true

	Network.log(Network.MESSAGES)
end

GameSettingsDevelopment.performance_profiling = GameSettingsDevelopment.performance_profiling or {}
GameSettingsDevelopment.performance_profiling.active = false
GameSettingsDevelopment.performance_profiling.frames_between_print = 10
GameSettingsDevelopment.tutorial_mode = false
