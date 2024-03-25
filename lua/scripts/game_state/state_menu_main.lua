-- chunkname: @scripts/game_state/state_menu_main.lua

require("scripts/menu/menus/main_menu")
require("scripts/menu/menu_controller_settings/main_menu_controller_settings")
require("scripts/menu/menu_definitions/main_menu_settings_1920")
require("scripts/menu/menu_definitions/main_menu_settings_1366")
require("scripts/menu/menu_definitions/profile_editor_settings_1920")
require("scripts/menu/menu_definitions/profile_editor_settings_1366")
require("scripts/menu/menu_definitions/main_menu_settings_low")
require("scripts/menu/menu_definitions/main_menu_definition")
require("scripts/menu/menu_callbacks/main_menu_callbacks")

StateMenuMain = class(StateMenuMain)

function StateMenuMain:on_enter(params)
	self._menu_world = Managers.world:create_world("menu_world", GameSettingsDevelopment.default_environment, nil, 3)

	ScriptWorld.create_viewport(self._menu_world, "menu_viewport", "overlay", 3)

	self._gui = World.create_screen_gui(self._menu_world, "material", "materials/fonts/arial", "immediate")

	Managers.news_ticker:enable(self._menu_world)

	local menu_data = {
		viewport_name = "menu_viewport",
		level_world = self.parent.level_world,
		camera_dummy_units = self.parent.camera_dummy_units,
		menu_banner_unit = self.parent.menu_banner_unit,
		menu_shield_units = self.parent.menu_shield_units,
		menu_main_shield_unit = self.parent.menu_main_shield_unit,
		gui_init_parameters = {
			"material",
			"materials/menu/loading_atlas",
			"material",
			"materials/menu/menu",
			"material",
			"materials/menu/outfit_previews",
			"material",
			"materials/menu/cloak_previews",
			"material",
			MenuSettings.font_group_materials.font_gradient_100,
			"material",
			MenuSettings.font_group_materials.arial,
			"material",
			MenuSettings.font_group_materials.hell_shark,
			"material",
			"materials/hud/buttons",
			"immediate"
		}
	}

	self._menu = MainMenu:new(self, self._menu_world, MainMenuControllerSettings, MainMenuSettings, MainMenuDefinition, MainMenuCallbacks, menu_data)

	self._menu:set_active(true)

	local event_manager = Managers.state.event

	event_manager:register(self, "restart_game", "event_restart_game")

	local has_steam = rawget(_G, "Steam")

	if has_steam and GameSettingsDevelopment.network_mode == "steam" then
		Managers.lobby:refresh_server_browser()
	end

	self._exit_game_fade_out_done = false
	self._exit_game_telemetry_sent = false
end

function StateMenuMain:on_exit()
	self._menu:destroy()

	self._menu = nil

	local news_ticker_manager = Managers.news_ticker

	if news_ticker_manager:enabled() then
		news_ticker_manager:disable(self._menu_world)
	end

	World.destroy_gui(self._menu_world, self._gui)
	Managers.world:destroy_world(self._menu_world)
end

function StateMenuMain:update(dt, t)
	HUDHelper:update_resolution()
	MenuHelper:update_resolution()

	if self.parent.parent.goto_menu_node then
		self._menu:goto(self.parent.parent.goto_menu_node)

		self.parent.parent.goto_menu_node = nil
	end

	self._menu:update(dt, t)

	if GameSettingsDevelopment.show_version_info then
		HUDHelper:render_version_info(self._gui)
	end

	if GameSettingsDevelopment.show_fps then
		HUDHelper:render_fps(self._gui, dt)
	end

	if self._exit_game_fade_out_done and self._exit_game_telemetry_sent then
		self.parent.parent.quit_game = not EDITOR_LAUNCH
	end
end

function StateMenuMain:event_restart_game()
	self:_stop_all_sounds()

	self.parent.parent.loading_context.reload_packages = true

	self.parent:set_new_state(StateSplashScreen)
end

function StateMenuMain:_stop_all_sounds()
	local menu_timpani_world = World.timpani_world(self._menu_world)

	menu_timpani_world:stop_all()

	local level_timpani_world = World.timpani_world(self.parent.level_world)

	level_timpani_world:stop_all()
	Managers.music:stop_all_sounds()
end

function StateMenuMain:exit_game()
	if not EDITOR_LAUNCH then
		self:_send_telemetry()
		self._menu:set_active(false)
		Managers.transition:fade_in(MenuSettings.transitions.fade_in_speed, callback(self, "cb_exit_game_fade_out"))
	end
end

function StateMenuMain:_send_telemetry()
	local pdx_telemetry = Managers.pdx_telemetry
	local events = {}

	events[#events + 1] = pdx_telemetry:add_exit_game_event()

	pdx_telemetry:send_telemetry(events, callback(self, "cb_exit_game_telemetry_sent"))
end

function StateMenuMain:cb_exit_game_fade_out()
	self._exit_game_fade_out_done = true
end

function StateMenuMain:cb_exit_game_telemetry_sent(info)
	table.dump(info)

	self._exit_game_telemetry_sent = true
end

function StateMenuMain:single_player_start(level_key)
	self.parent.single_player_loading_context = {}
	self.parent.single_player_loading_context.state = StateLoading
	self.parent.single_player_loading_context.level_key = level_key
	self.parent.single_player_loading_context.game_mode_key = LevelSettings[level_key].single_player_game_mode or "sp"
	self.parent.single_player_loading_context.win_score = GameSettingsDevelopment.default_win_score
	self.parent.single_player_loading_context.time_limit = GameSettingsDevelopment.default_time_limit
	self.parent.single_player_loading_context.disable_loading_screen_menu = true
end

function StateMenuMain:menu_cancel_to(page_id)
	self._menu:cancel_to(page_id)
end
