﻿-- chunkname: @scripts/boot.lua

require("foundation/scripts/boot/boot")

Boot.foundation_update = Boot.update

function Boot:update(dt)
	local old_profiler_stop = Profiler.stop
	local old_profiler_start = Profiler.start
	local starts = 0
	local stops = 0

	function Profiler.start(...)
		starts = starts + 1

		old_profiler_start(...)
	end

	function Profiler.stop(...)
		stops = stops + 1

		old_profiler_stop(...)
	end

	Managers.perfhud:update(dt)
	Boot:foundation_update(dt)
	Managers.transition:update(dt)
	Managers.changelog:update(dt)
	Managers.news_ticker:update(dt)
	Managers.invite:update(dt)
	assert(starts == stops, "Profiling scope mismatch")

	Profiler.stop = old_profiler_stop
	Profiler.start = old_profiler_start
end

Postman = Postman or {}

function project_setup()
	Postman:setup()

	return Postman.entrypoint()
end

function Postman:setup()
	script_data.settings = Application.settings()

	local args = {
		Application.argv()
	}

	if table.find(args, "-debug-content-revision") then
		script_data.settings.content_revision = 4711
	end

	self:_require_scripts()

	if script_data.settings.dedicated_server then
		Application.set_time_step_policy("no_smoothing", "throttle", script_data.settings.dedicated_server_fps or 30)
		CommandWindow.open(self:_server_window_name())
		CommandWindow.print("Starting dedicated server")
	else
		Application.set_time_step_policy("no_smoothing")
		Application.set_time_step_policy("throttle", 60)
		self:_load_user_settings()
	end

	Application.set_time_step_policy("external_step_range", 0, 100)
	Application.set_time_step_policy("system_step_range", 0, 100)

	if GameSettingsDevelopment.remove_debug_stuff then
		DebugHelper.remove_debug_stuff()
	end

	if script_data.settings.physics_dump then
		DebugHelper.enable_physics_dump()
	end

	script_data.build_identifier = Application.build_identifier()
	script_data.ping_comp_limit = 100

	self:_init_random()
	self:_init_mouse()
	self:_init_demo()
	self:_init_managers()

	if rawget(_G, "Steam") then
		print("User ID:", Steam.user_id(), Steam.user_name())
	end

	print("Engine revision:", script_data.build_identifier)
	print("Content revision:", script_data.settings.content_revision)
end

function Postman:_server_window_name()
	local settings = script_data.settings.steam.game_server_settings.server_init_settings
	local name = "WOTV - " .. settings.server_name .. ", process:" .. Application.process_id()

	name = name .. ", auth:" .. (settings.authentication_port or "8766")
	name = name .. ", query:" .. (settings.query_port or "27016")
	name = name .. ", game:" .. (settings.server_port or "27015")
	name = name .. ", rev:" .. (script_data.settings.content_revision or "?")
	name = name .. ", eng:" .. (Application.build_identifier() or "?")

	if rawget(_G, "Steam") then
		name = name .. ", appid: " .. Steam.app_id()
	end

	return name
end

function Postman:_localhost_window_name()
	local name = "WOTV - " .. Application.process_id()

	return name
end

function Postman:_require_scripts()
	local function core_require(path, ...)
		for _, s in ipairs({
			...
		}) do
			require("core/" .. path .. "/" .. s)
		end
	end

	local function game_require(path, ...)
		for _, s in ipairs({
			...
		}) do
			require("scripts/" .. path .. "/" .. s)
		end
	end

	local function foundation_require(path, ...)
		for _, s in ipairs({
			...
		}) do
			require("foundation/scripts/" .. path .. "/" .. s)
		end
	end

	Managers.package:load("resource_packages/script")
	core_require("bitsquid_splash", "bitsquid_splash")
	foundation_require("managers", "localization/localization_manager", "event/event_manager")
	game_require("settings", "dlc_settings", "ai_settings", "game_settings", "game_settings_development", "controller_settings")
	game_require("game_state", "state_context", "state_splash_screen", "state_menu", "state_menu_main", "state_loading", "state_ingame", "state_ingame_running", "state_dedicated_server_init", "state_automatic_dedicated_server_join", "state_invite_join", "state_automatic_localhost_host", "state_automatic_localhost_join")
	game_require("entity_system", "entity_system")
	game_require("managers", "command_parser/command_parser_manager", "player/player_manager", "save/save_manager", "save/save_data", "perfhud/perfhud_manager", "backend/backend_manager", "music/music_manager", "admin/admin_manager", "persistence/persistence_manager_server", "persistence/persistence_manager_server_offline", "persistence/persistence_manager_client", "persistence/persistence_manager_client_offline", "persistence/persistence_manager_common", "transition/transition_manager", "changelog/changelog_manager", "changelog/changelog_manager_offline", "news_ticker/news_ticker_manager", "invite/invite_manager", "invite/invite_stub_manager", "paradox_os/pdx_accounts", "paradox_os/pdx_accounts_offline", "paradox_os/pdx_telemetry", "paradox_os/pdx_telemetry_offline")
	game_require("settings", "localizer_tweak_data", "sound_bus_settings", "hardcoded_limits")

	local args = {
		Application.argv()
	}

	for i = 1, #args do
		if args[i] == "-robot" then
			GameSettingsDevelopment.enable_robot_player = true
		end
	end

	if GameSettingsDevelopment.enable_robot_player then
		game_require("managers", "input/input_manager")
	end

	game_require("utils", "util")
end

function Postman:_init_random()
	local seed = os.clock() * 10000 % 1000

	math.randomseed(seed)
	math.random(5, 30000)
end

function Postman:_init_mouse()
	Window.set_cursor("gui/cursors/mouse_cursor")
	Window.set_clip_cursor(true)
end

function Postman:_init_demo()
	IS_DEMO = not DLCSettings.full_game()
end

function Postman:_init_managers()
	self:_init_localizer()
	self:_init_lobby_manager()
	local args = {
		Application.argv()
	}

	local has_steam = rawget(_G, "Steam")
	local is_dedicated_server = script_data.settings.dedicated_server

	if is_dedicated_server then
		local server_settings = Managers.lobby.game_server_settings or {
			server_init_settings = {}
		}

		Managers.admin = AdminManager:new(server_settings)
	elseif GameSettingsDevelopment.anti_cheat_enabled then
		Postman.anti_cheat_key = AntiCheatClient.generate_key()

		AntiCheatClient.initialize(11, Postman.anti_cheat_key)
	else
		Postman.anti_cheat_key = Application.make_hash()
	end

	if table.find(args, "-autohost") then
		local server_settings = Managers.lobby.game_server_settings or {
			server_init_settings = {}
		}
		Managers.admin = AdminManager:new(server_settings)
	end

	self:_init_backend()

	Managers.input = InputManager:new()
	Managers.command_parser = CommandParserManager:new()
	Managers.save = SaveManager:new(script_data.settings.disable_cloud_save)
	Managers.perfhud = PerfhudManager:new()
	Managers.music = MusicManager:new()
	Managers.transition = TransitionManager:new()
	Managers.changelog = rawget(_G, "UrlLoader") ~= nil and ChangelogManager:new() or ChangelogManagerOffline:new()
	Managers.news_ticker = NewsTickerManager:new(MainMenuSettings.containers.news_ticker)

	if has_steam and rawget(_G, "Friends") then
		Managers.invite = InviteManager:new()
	else
		Managers.invite = InviteStubManager:new()
	end

	if has_steam and GameSettingsDevelopment.network_mode == "steam" and GameSettingsDevelopment.enable_paradox_os then
		Managers.pdx_accounts = PdxAccounts:new()
		Managers.pdx_telemetry = PdxTelemetry:new()
	else
		Managers.pdx_accounts = PdxAccountsOffline:new()
		Managers.pdx_telemetry = PdxTelemetryOffline:new()
	end
end

function Postman:_init_backend()
	Managers.backend = BackendManager:new()

	if script_data.settings.dedicated_server then
		if Managers.backend:available() then
			local backend_settings = table.clone(Managers.admin:settings().backend)

			backend_settings.connection = GameSettingsDevelopment.backend
			Managers.persistence = PersistenceManagerServer:new(backend_settings)
		else
			Managers.persistence = PersistenceManagerServerOffline:new()
		end
	elseif rawget(_G, "Steam") and Managers.backend:available() and GameSettingsDevelopment.network_mode == "steam" then
		local backend_settings = {
			connection = GameSettingsDevelopment.backend
		}

		Managers.persistence = PersistenceManagerClient:new(backend_settings)
	else
		Managers.persistence = PersistenceManagerClientOffline:new()
	end
end

function Postman:_load_user_settings()
	local show_hud_saved = Application.win32_user_setting("show_hud")

	if show_hud_saved ~= nil then
		HUDSettings.show_hud = show_hud_saved
	end

	local show_xp_awards = Application.user_setting("show_xp_awards")

	if show_xp_awards ~= nil then
		HUDSettings.show_xp_awards = show_xp_awards
	end

	local show_parry_helper = Application.user_setting("show_parry_helper")

	if show_parry_helper ~= nil then
		HUDSettings.show_parry_helper = show_parry_helper
	end

	local show_pose_charge_helper = Application.user_setting("show_pose_charge_helper")

	if show_pose_charge_helper ~= nil then
		HUDSettings.show_pose_charge_helper = show_pose_charge_helper
	end

	local invert_pose_control_x_saved = Application.win32_user_setting("invert_pose_control_x")

	if invert_pose_control_x_saved ~= nil then
		PlayerUnitMovementSettings.swing.invert_pose_control_x = invert_pose_control_x_saved
	end

	local invert_pose_control_y_saved = Application.win32_user_setting("invert_pose_control_y")

	if invert_pose_control_y_saved ~= nil then
		PlayerUnitMovementSettings.swing.invert_pose_control_y = invert_pose_control_y_saved
	end

	local invert_parry_control_x_saved = Application.win32_user_setting("invert_parry_control_x")

	if invert_parry_control_x_saved ~= nil then
		PlayerUnitMovementSettings.parry.invert_parry_control_x = invert_parry_control_x_saved
	end

	local invert_parry_control_y_saved = Application.win32_user_setting("invert_parry_control_y")

	if invert_parry_control_y_saved ~= nil then
		PlayerUnitMovementSettings.parry.invert_parry_control_y = invert_parry_control_y_saved
	end

	local mouse_sensitivity_saved = Application.win32_user_setting("mouse_sensitivity")

	if mouse_sensitivity_saved ~= nil then
		ActivePlayerControllerSettings.sensitivity = mouse_sensitivity_saved
	end

	local aim_multiplier_saved = Application.win32_user_setting("aim_multiplier")

	if aim_multiplier_saved ~= nil then
		ActivePlayerControllerSettings.aim_multiplier = aim_multiplier_saved
	end

	local keyboard_parry_saved = Application.win32_user_setting("keyboard_parry")

	if keyboard_parry_saved ~= nil then
		PlayerUnitMovementSettings.parry.keyboard_controlled = keyboard_parry_saved
	end

	local keyboard_pose_saved = Application.win32_user_setting("keyboard_pose")

	if keyboard_pose_saved ~= nil then
		PlayerUnitMovementSettings.swing.keyboard_controlled = keyboard_pose_saved
	end

	local show_combat_text_saved = Application.win32_user_setting("show_combat_text")

	if show_combat_text_saved ~= nil then
		HUDSettings.show_combat_text = show_combat_text_saved
	end

	local music_volume = Application.win32_user_setting("music_volume") or SoundBusSettings.music_volume.default

	if music_volume then
		Timpani.set_bus_volume("music", music_volume)
	end

	local sfx_volume = Application.win32_user_setting("sfx_volume") or SoundBusSettings.sfx_volume.default

	Timpani.set_bus_volume("sfx", sfx_volume)
	Timpani.set_bus_volume("special", sfx_volume)

	local master_volume = Application.win32_user_setting("master_volume") or SoundBusSettings.master_volume.default

	Timpani.set_bus_volume("Master Bus", master_volume)

	local argv = {
		Application.argv()
	}

	if Application.build() ~= "release" and table.find(argv, "-nosound") then
		Timpani.set_bus_volume("Master Bus", -99)
	end

	local voice_over = Application.win32_user_setting("voice_over") or SoundBusSettings.voice_over.default

	Timpani.set_bus_volume("voice_over", voice_over)

	local autojoin_squad_saved = Application.user_setting("autojoin_squad")

	if autojoin_squad_saved ~= nil then
		SquadSettings.autojoin_squad = autojoin_squad_saved
	end

	local max_frames = Application.win32_user_setting("max_stacking_frames")

	if max_frames then
		Application.set_max_frame_stacking(max_frames)
	end

	local announcement_voice_over = Application.user_setting("announcement_voice_over")

	if announcement_voice_over then
		if announcement_voice_over == "brian_blessed" and DLCSettings.brian_blessed() then
			HUDSettings.announcement_voice_over = announcement_voice_over
		else
			HUDSettings.announcement_voice_over = "normal"
		end
	end

	local squadless_scoreboard = Application.user_setting("squadless_scoreboard")

	if squadless_scoreboard == nil then
		Application.set_user_setting("squadless_scoreboard", true)
	end

	self:_load_graphics_quality()

	local current_revision = script_data.settings.content_revision

	printf("Content-revision: %s", current_revision)

	if current_revision then
		local last_user_revision = Application.user_setting("user_revision") or 0

		if last_user_revision < current_revision or last_user_revision > 50000 then
			print("Updating user revision.")

			local max_fps = Application.user_setting("max_fps") or 0

			if last_user_revision < 88 and (max_fps == 0 or max_fps > 60) then
				print("Changing user setting max_fps to 60")
				Application.set_user_setting("max_fps", 60)
			end

			Application.set_user_setting("user_revision", current_revision)
			Application.save_user_settings()
		end
	end
end

function Postman:_graphics_quality_setting_has_changed(old_value, value)
	local value_type = type(value)
	local epsilon = 0.0001

	if value_type == "number" then
		return not old_value or epsilon < math.abs(old_value - value)
	elseif value_type == "table" then
		if old_value then
			for k, v in pairs(value) do
				if v ~= old_value[k] then
					return true
				end
			end
		else
			return true
		end
	elseif value_type == "string" or value_type == "boolean" then
		return old_value ~= value
	end

	return false
end

function Postman:_load_graphics_quality()
	local graphics_quality = Application.user_setting("graphics_quality")

	if not graphics_quality or graphics_quality == "custom" or EDITOR_LAUNCH then
		return
	end

	local graphics_quality_settings = GraphicsQuality[graphics_quality]

	if not graphics_quality_settings then
		return
	end

	local needs_apply = false
	local user_settings = graphics_quality_settings.user_settings

	if user_settings then
		for key, value in pairs(user_settings) do
			local old_value = Application.user_setting(key)
			local changed = self:_graphics_quality_setting_has_changed(old_value, value)

			if changed then
				Application.set_user_setting(key, value)

				needs_apply = true

				printf("Setting user setting %s, new: %s, old: %s", key, value, old_value)
			end
		end
	end

	local render_settings = graphics_quality_settings.render_settings

	if render_settings then
		for key, value in pairs(render_settings) do
			local old_value = Application.user_setting("render_settings", key)
			local changed = self:_graphics_quality_setting_has_changed(old_value, value)

			if changed then
				Application.set_user_setting("render_settings", key, value)

				needs_apply = true

				printf("Setting render setting %s, new: %s, old: %s", key, value, old_value)
			end
		end
	end

	if needs_apply then
		print("Reloading video settings")
		Application.save_user_settings()
		Application.apply_user_settings()
	end
end

function Postman:_init_lobby_manager(network_mode)
	local network_mode = GameSettingsDevelopment.network_mode
	local options = {
		project_hash = "",
		port = GameSettingsDevelopment.network_port
	}

	if network_mode == "lan" then
		require("foundation/scripts/managers/network/lobby_manager_lan")

		Managers.lobby = LobbyManagerLan:new(options)
	elseif network_mode == "steam" then
		require("foundation/scripts/managers/network/lobby_manager_steam")

		Managers.lobby = LobbyManagerSteam:new(options)
	else
		ferror("Unknown network mode %q", network_mode)
	end
end

function Postman:_init_localizer()
	local language_id = "en"

	if rawget(_G, "Steam") then
		language_id = Steam:language()

		if language_id == "plhungarian" then
			language_id = "pl"
		elseif language_id == "ja" then
			language_id = "jp"
		end
	end

	Application.set_resource_property_preference_order(language_id)
	Managers.package:load("resource_packages/strings")
	Managers.package:load("resource_packages/post_localization_boot")
	Managers.package:load("resource_packages/splash_package")
	Managers.package:load("resource_packages/buttons")

	Managers.localizer = LocalizationManager:new("localization/game_strings", language_id)

	for _, profile in pairs(PlayerProfiles) do
		profile.display_name = Managers.localizer:exists(profile.display_name) and L(profile.display_name) or profile.display_name
	end

	local function key_parser(key_name)
		local key = ActivePlayerControllerSettings[Managers.input:active_mapping(1)][key_name]

		if not key then
			print("MISSING CONTROLLER BUTTON: ", key_name)

			return
		end

		local key_locale_name

		if key.controller_type == "mouse" then
			key_locale_name = string.format("%s %s", "mouse", key.key)
		elseif key.controller_type == "pad" then
			key_locale_name = L("pad360_" .. key.key)
		else
			local controller = Managers.input:get_controller(key.controller_type)
			local key_index = controller.button_index(key.key)

			key_locale_name = controller.button_locale_name(key_index)
		end

		return key_locale_name
	end

	Managers.localizer:add_macro("KEY", key_parser)

	local function tweak_parser(tweak_name)
		return LocalizerTweakData[tweak_name] or "<missing LocalizerTweakData \"" .. tweak_name .. "\">"
	end

	Managers.localizer:add_macro("TWEAK", tweak_parser)
end

function Postman.entrypoint()
	local application_settings = Application.settings()
	local args = {
		Application.argv()
	}
	local flythrough_command_line = false
	local localhost_auto_settings

	for i = 1, #args do
		if args[i] == "-flythrough" then
			flythrough_command_line = true
		elseif args[i] == "-autohost" or args[i] == "-auto-host" then
			localhost_auto_settings = "host"
		elseif args[i] == "-autoclient" or args[i] == "-auto-client" then
			localhost_auto_settings = "client"
		elseif args[i] == "-robot" then
			GameSettingsDevelopment.enable_robot_player = true
		elseif args[i] == "-reset-save" then
			RESET_SAVE_DATA = true
		end
	end

	local function parse_lan_invite(args)
		for i = 1, #args do
			if args[i] == "+connect" then
				return "lobby2", args[i + 1]
			end
		end
	end

	local invite_type, invite_id

	if GameSettingsDevelopment.network_mode == "lan" then
		invite_type, invite_id = parse_lan_invite(args)
	elseif rawget(_G, "Steam") and rawget(_G, "Friends") then
		invite_type, invite_id = Friends.boot_invite()
	end

	print("INVITE INFO:", invite_type, GameSettingsDevelopment.network_mode, rawget(_G, "Steam"), rawget(_G, "Friends"), rawget(_G, "Friends") and Friends.INVITE_SERVER)

	if invite_type and invite_type == Friends.INVITE_SERVER then
		local loading_context = {}

		loading_context.invite_type = "server"
		loading_context.invite_ip = invite_id
		loading_context.show_splash_screens = true
		loading_context.load_changelog = false
		Boot.loading_context = loading_context

		return StateSplashScreen
	elseif invite_type and invite_type == Friends.INVITE_LOBBY then
		local loading_context = {}

		loading_context.invite_type = "lobby"
		loading_context.invite_ip = invite_id
		loading_context.show_splash_screens = true
		loading_context.load_changelog = false
		Boot.loading_context = loading_context

		return StateSplashScreen
	elseif invite_type and invite_type == "lobby2" then
		local loading_context = {}

		loading_context.invite_type = "lobby2"
		loading_context.invite_ip = invite_id
		loading_context.show_splash_screens = true
		loading_context.load_changelog = false
		Boot.loading_context = loading_context

		return StateSplashScreen
	elseif application_settings.invite_debug_ip then
		Postman._load_ingame_packages()

		local loading_context = {}

		loading_context.invite_type = "server"
		loading_context.invite_ip = application_settings.invite_debug_ip
		loading_context.show_splash_screens = true
		loading_context.load_changelog = false
		Boot.loading_context = loading_context

		return StateSplashScreen
	elseif GameSettingsDevelopment.start_state == "fly_through" or flythrough_command_line then
		Postman._load_ingame_packages()

		Boot.loading_context = {}
		Boot.loading_context.level_key = "village_02"
		Boot.loading_context.game_mode_key = "fly_through"
		Boot.loading_context.win_score = GameSettingsDevelopment.default_win_score
		Boot.loading_context.time_limit = GameSettingsDevelopment.default_time_limit
		Boot.loading_context.number_players = GameSettingsDevelopment.quicklaunch_params.number_players

		return StateLoading
	elseif GameSettingsDevelopment.start_state == "gpu_prof" then
		Postman._load_ingame_packages()

		Boot.loading_context = {}
		Boot.loading_context.level_key = "village_02"
		Boot.loading_context.game_mode_key = "gpu_prof"
		Boot.loading_context.win_score = GameSettingsDevelopment.default_win_score
		Boot.loading_context.time_limit = GameSettingsDevelopment.default_time_limit
		Boot.loading_context.number_players = GameSettingsDevelopment.quicklaunch_params.number_players

		return StateLoading
	elseif GameSettingsDevelopment.start_state == "game" then
		Postman._load_ingame_packages()

		local level_key = GameSettingsDevelopment.quicklaunch_params.level_key
		local game_mode_key = GameSettingsDevelopment.quicklaunch_params.game_mode_key

		Boot.loading_context = {}
		Boot.loading_context.level_key = level_key
		Boot.loading_context.game_mode_key = game_mode_key
		Boot.loading_context.win_score = GameSettingsDevelopment.default_win_score
		Boot.loading_context.time_limit = GameSettingsDevelopment.default_time_limit
		Boot.loading_context.number_players = GameSettingsDevelopment.quicklaunch_params.number_players

		return StateLoading
	elseif localhost_auto_settings and localhost_auto_settings == "host" then
		Postman._load_ingame_packages()

		local i = table.find(args, "-level")
		local level = args[i + 1] or "whitebox"

		i = table.find(args, "-game-mode")

		local game_mode = args[i + 1] or "tdm"
		local i = table.find(args, "-network-hash")
		local network_hash = args[i + 1] or "auto"

		Boot.loading_context = {}
		Boot.loading_context.network_hash = network_hash
		Boot.loading_context.level_key = level
		Boot.loading_context.game_mode_key = game_mode
		Boot.loading_context.win_score = GameSettingsDevelopment.default_win_score
		Boot.loading_context.time_limit = GameSettingsDevelopment.default_time_limit

		return StateAutomaticLocalhostHost
	elseif localhost_auto_settings and localhost_auto_settings == "client" then
		Postman._load_ingame_packages()

		local i = table.find(args, "-network-hash")
		local network_hash = args[i + 1] or "auto"

		Boot.loading_context = {}
		Boot.loading_context.network_hash = network_hash

		return StateAutomaticLocalhostJoin
	elseif application_settings.dedicated_server == true then
		Postman._load_ingame_packages()

		return StateDedicatedServerInit
	elseif application_settings.auto_join_server_name then
		Postman._load_ingame_packages()

		return StateAutomaticDedicatedServerJoin
	elseif GameSettingsDevelopment.start_state == "menu" then
		Boot.loading_context = {}
		Boot.loading_context.show_splash_screens = true
		Boot.loading_context.load_changelog = true

		return StateSplashScreen
	elseif GameSettingsDevelopment.start_state == "cpu_prof" then
		Postman._load_ingame_packages()

		Boot.loading_context = {}
		Boot.loading_context.level_key = "village_02"
		Boot.loading_context.game_mode_key = "cpu_prof"
		Boot.loading_context.win_score = GameSettingsDevelopment.default_win_score
		Boot.loading_context.time_limit = GameSettingsDevelopment.default_time_limit
		Boot.loading_context.number_players = GameSettingsDevelopment.quicklaunch_params.number_players

		return StateLoading
	end

	return StateSplashScreen
end

function Postman:_load_ingame_packages()
	if script_data.settings.dedicated_server then
		CommandWindow.print("Loading packages")
	end

	Managers.package:load_multiple(GameSettingsDevelopment.ingame_packages)
	Managers.package:load_multiple(GameSettingsDevelopment.delayed_load_packages)
end

script_data = script_data or {}
