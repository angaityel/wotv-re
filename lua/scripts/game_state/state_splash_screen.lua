-- chunkname: @scripts/game_state/state_splash_screen.lua

StateSplashScreen = class(StateSplashScreen)
StateSplashScreen.packages_to_load = GameSettingsDevelopment.ingame_packages

function StateSplashScreen:on_enter()
	Managers.time:register_timer("splash_screen", "main")
	Managers.transition:force_fade_in()

	self._camera_dummy_units = {}
	self._alignment_dummy_units = {}
	self._num_loaded_packages = 0

	self:_setup_state_context()
	self:_setup_splash_screen_menu()

	if self.parent.loading_context.reload_packages then
		self:_unload_packages()
	end

	if self.parent.loading_context.leave_reason then
		self._splash_screen_menu:goto("disconnect_reason_popup")
	end

	self:_load_packages()
	self:_load_save_data()

	if self:_get_wanted_state() == StateInviteJoin then
		-- block empty
	elseif GameSettingsDevelopment.enforce_tutorial and not Application.user_setting("started_tutorial") then
		self._start_tutorial = true
	else
		self:_load_menu_level()
	end

	Managers.persistence:connect(callback(self, "cb_backend_setup"))
	Managers.state.event:trigger("load_started")

	local event_manager = Managers.state.event

	event_manager:register(self, "menu_camera_dummy_spawned", "event_menu_camera_dummy_spawned")
	event_manager:register(self, "menu_alignment_dummy_spawned", "event_menu_alignment_dummy_spawned")
	event_manager:register(self, "event_add_menu_banner", "add_menu_banner")
	Managers.state.event:register(self, "add_shield_dummy", "add_shield_dummy")
	Managers.state.event:register(self, "add_main_shield_dummy", "add_main_shield_dummy")
end

function StateSplashScreen:add_shield_dummy(unit, team_name)
	self._menu_shield_units = self._menu_shield_units or {}
	self._menu_shield_units[team_name] = self._menu_shield_units[team_name] or {}
	self._menu_shield_units[team_name][#self._menu_shield_units[team_name] + 1] = unit

	local mesh = Unit.mesh(unit, "g_heraldry_projector")
	local material = Mesh.material(mesh, "heraldry_projector")
	local settings = PlayerCoatOfArms[team_name]

	for variable_name, value in pairs(settings) do
		if type(value) == "string" then
			local atlas_name = CoatOfArmsAtlasVariants[team_name][variable_name]
			local _, uv00, uv11 = HUDHelper.atlas_material(atlas_name, value)

			Material.set_vector2(material, variable_name .. "_uv_offset", uv00)
			Material.set_vector2(material, variable_name .. "_uv_scale", uv11 - uv00)
		else
			Material.set_scalar(material, variable_name, value)
		end
	end
end

function StateSplashScreen:add_main_shield_dummy(unit)
	self._menu_main_shield_unit = unit
end

function StateSplashScreen:add_menu_banner(unit)
	self._menu_banner_unit = unit
end

function StateSplashScreen:banner_unit()
	return self._menu_banner_unit
end

function StateSplashScreen:event_menu_camera_dummy_spawned(name, unit)
	self._camera_dummy_units[name] = unit
end

function StateSplashScreen:event_menu_alignment_dummy_spawned(name, unit)
	self._alignment_dummy_units[name] = unit
end

function StateSplashScreen:_setup_state_context()
	Managers.state.event = EventManager:new()
end

function StateSplashScreen:_setup_splash_screen_menu()
	require("scripts/menu/menus/splash_screen")

	local show_videos = self.parent.loading_context.show_splash_screens

	self:_setup_input()
	self:_setup_menu(show_videos)

	if show_videos then
		self._splash_screen_menu:goto("splash_screen_start")
	else
		Managers.news_ticker:enable(self._splash_screen_world)

		self._wanted_state = self:_get_wanted_state()

		local music_events = SplashScreenSettings.music_events.return_to_menu

		if music_events then
			for _, music_event in ipairs(music_events) do
				Managers.music:trigger_event(music_event)
			end
		end
	end
end

function StateSplashScreen:_setup_input()
	local im = Managers.input

	im:map_controller(Keyboard, 1)
	im:map_controller(Mouse, 1)

	if GameSettingsDevelopment.allow_gamepad then
		im:map_controller(Pad1, 1)
	end
end

function StateSplashScreen:_release_input()
	local im = Managers.input

	im:unmap_controller(Keyboard)
	im:unmap_controller(Mouse)

	if GameSettingsDevelopment.allow_gamepad then
		im:unmap_controller(Pad1)
	end
end

function StateSplashScreen:_setup_menu(show_videos)
	self._splash_screen_world = Managers.world:create_world("splash_screen_world", GameSettingsDevelopment.default_environment, nil, 991, Application.DISABLE_PHYSICS)

	ScriptWorld.create_viewport(self._splash_screen_world, "splash_screen_viewport", "overlay", 1)

	local menu_data

	if show_videos then
		Managers.package:load("resource_packages/splash_videos")
		Managers.state.event:trigger("video_loaded")

		menu_data = {
			viewport_name = "splash_screen_viewport",
			gui_init_parameters = {
				"material",
				"materials/menu/loading_atlas",
				"material",
				MenuSettings.font_group_materials.arial,
				"material",
				MenuSettings.videos.fatshark_splash.material,
				"material",
				MenuSettings.videos.paradox_splash.material,
				"material",
				MenuSettings.videos.wotv_splash.material,
				"material",
				"materials/menu/splash_screen",
				"material",
				"materials/fonts/hell_shark_font",
				"material",
				"materials/hud/buttons",
				"immediate"
			}
		}
	else
		menu_data = {
			viewport_name = "splash_screen_viewport",
			gui_init_parameters = {
				"material",
				"materials/menu/loading_atlas",
				"material",
				MenuSettings.font_group_materials.arial,
				"material",
				"materials/menu/splash_screen",
				"material",
				"materials/fonts/hell_shark_font",
				"material",
				"materials/hud/buttons",
				"immediate"
			}
		}
	end

	self._splash_screen_menu = SplashScreen:new(self, self._splash_screen_world, SplashScreenControllerSettings, SplashScreenSettings, SplashScreenDefinition, SplashScreenCallbacks, menu_data)

	self._splash_screen_menu:set_active(true)
end

function StateSplashScreen:_destroy_menu()
	if self._splash_screen_menu then
		self._splash_screen_menu:destroy()

		self._splash_screen_menu = nil
	end

	if self._splash_screen_world then
		Managers.world:destroy_world(self._splash_screen_world)

		self._splash_screen_world = nil
	end
end

function StateSplashScreen:update(dt, t)
	HUDHelper:update_resolution()
	MenuHelper:update_resolution()
	Managers.input:update(dt)

	local t = Managers.time:time("splash_screen")

	if self._splash_screen_menu then
		self._splash_screen_menu:update(dt, t)
	end

	if self:_load_finished() and not self._load_finished_event then
		Managers.state.event:trigger("load_finished")
		print("LOAD FINISHED!")
		self:_handle_unviewed_unlocks()

		self._load_finished_event = true
	end

	local state = self:_next_state()

	if state and state ~= StateMenu then
		Managers.music:trigger_event("Stop_main_menu_ambience")
	end

	return state
end

function StateSplashScreen:render()
	if self._splash_screen_menu:current_page().application_render then
		self._splash_screen_menu:current_page():application_render()
	end
end

function StateSplashScreen:_next_state()
	if not self:_load_finished() or not self._wanted_state then
		return
	end

	if not self._dependencies_checked then
		if self:_check_dependencies() then
			return self._wanted_state
		end

		self._wanted_state = nil
		self._dependencies_checked = true
	end

	if self._dependencies_checked then
		return self._wanted_state
	end
end

function StateSplashScreen:_check_dependencies()
	local is_fatal = self._is_fatal
	local dependency_error = self._dependency_error

	if GameSettingsDevelopment.network_mode == "steam" and not script_data.settings.dedicated_server and (not self._dependency_error or not is_fatal) then
		if not rawget(_G, "Steam") then
			dependency_error = "error_steam_not_initialized"
			is_fatal = true
		elseif not Steam.connected() then
			dependency_error = "error_no_connection_to_steam_servers"
			is_fatal = true
		elseif self._need_pdx_login then
			dependency_error = "error_need_pdx_login"
			is_fatal = false
		elseif GameSettingsDevelopment.show_nda_in_splash_screen and not SaveData.nda_confirm then
			dependency_error = "error_need_nda_confirm"
			is_fatal = false
			SaveData.nda_confirm = true
		end
	end

	if dependency_error then
		self._dependency_error = dependency_error

		if is_fatal then
			if dependency_error == "error_no_connection_to_backend" then
				self._splash_screen_menu:goto("fatal_error_with_http_link_popup")
			else
				self._splash_screen_menu:goto("fatal_error_popup")
			end
		elseif dependency_error == "error_need_pdx_login" then
			self._splash_screen_menu:goto("pdx_os_login_popup")
		elseif dependency_error == "error_need_nda_confirm" then
			self._splash_screen_menu:goto("nda_confirm_popup")
		else
			self._splash_screen_menu:goto("error_popup")
		end

		return false
	end

	if self:_show_changelog() then
		return false
	end

	return true
end

local LOAD_DEBUG_PRINT_T = 0

function StateSplashScreen:_load_finished()
	local needs_menu_level_load = self:_get_wanted_state() == StateMenu
	local finished = self._packages_loaded and self._save_data_loaded and self._profile_data_loaded and (not needs_menu_level_load or self._menu_level_loaded) and self._market_loaded and self._store_loaded and self._changelog_loaded and self._pdx_account_loaded

	return finished
end

function StateSplashScreen:_unload_packages()
	for i, name in ipairs(GameSettingsDevelopment.delayed_load_packages) do
		if PackageManager:has_loaded(name) then
			PackageManager:unload(name)
		end
	end

	for i, name in ipairs(StateSplashScreen.packages_to_load) do
		if PackageManager:has_loaded(name) then
			PackageManager:unload(name)
		end
	end
end

function StateSplashScreen:_load_packages()
	for i, name in ipairs(StateSplashScreen.packages_to_load) do
		if PackageManager:has_loaded(name) then
			self:cb_package_loaded()
		else
			PackageManager:load(name, callback(self, "cb_package_loaded"))
		end
	end
end

function StateSplashScreen:cb_package_loaded()
	self._num_loaded_packages = self._num_loaded_packages + 1

	printf("Package loaded #%i %q.", self._num_loaded_packages, StateSplashScreen.packages_to_load[self._num_loaded_packages])

	if self._num_loaded_packages == #StateSplashScreen.packages_to_load then
		self._packages_loaded = true

		printf("All packages loaded.")

		for _, name in ipairs(GameSettingsDevelopment.delayed_load_packages) do
			if not PackageManager:has_loaded(name) then
				PackageManager:load(name, function()
					return
				end)
			end
		end
	end
end

function StateSplashScreen:_load_save_data()
	Managers.save:auto_load(SaveFileName, callback(self, "cb_save_data_loaded"))
end

function StateSplashScreen:cb_save_data_loaded(info)
	if info.error then
		create_save_data(SaveData)
		Application.warning("Load error %q", info.error)
	else
		populate_save_data(info.data)
	end

	self._save_data_loaded = true
end

function StateSplashScreen:cb_backend_setup(error_code)
	if error_code == nil then
		Managers.persistence:load_profile(callback(self, "cb_profile_loaded"))
		Managers.persistence:load_market(callback(self, "cb_market_loaded"))
		Managers.persistence:load_store(callback(self, "cb_store_loaded"))
		self:_load_pdx_account()
	else
		if GameSettingsDevelopment.backend_enforce_connection_in_splash_screen then
			self._is_fatal = true
		end

		self._dependency_error = "error_no_connection_to_backend"
		self._profile_data_loaded = true
		self._market_loaded = true
		self._store_loaded = true
		self._pdx_account_loaded = true
	end

	self:_load_changelog()
end

function StateSplashScreen:cb_profile_loaded(profile_data)
	if profile_data == nil then
		self._is_fatal = true
		self._dependency_error = "error_profile"
	end

	self._profile_data_loaded = true
end

function StateSplashScreen:cb_market_loaded(market)
	if market == nil then
		self._is_fatal = true
		self._dependency_error = "error_market"
	end

	self._market_loaded = true
end

function StateSplashScreen:cb_store_loaded(store)
	if store == nil then
		self._is_fatal = false
		self._dependency_error = "store_error"
	end

	self._store_loaded = true
end

function StateSplashScreen:_set_tutorial_context_data(context)
	context.state = StateLoading
	context.level_key = "Tutorial"
	context.game_mode_key = LevelSettings.Tutorial.single_player_game_mode or "sp"
	context.win_score = GameSettingsDevelopment.default_win_score
	context.time_limit = GameSettingsDevelopment.default_time_limit
	context.disable_loading_screen_menu = true
end

function StateSplashScreen:_load_menu_level()
	local level_settings = MainMenuSettings.level

	self._level_name = LevelSettings[level_settings.level_name].level_name
	self._level_package_name = LevelSettings[level_settings.level_name].package_name
	self._level_world = Managers.world:create_world("menu_level_world", GameSettingsDevelopment.default_environment, MenuHelper.light_adaption_fix_shading_callback, 1, Application.DISABLE_APEX_CLOTH)

	print("LEVEL NAME: ", self._level_name)
	print("PACKAGE NAME: ", self._level_package_name)
	PackageManager:load(self._level_package_name, callback(self, "cb_menu_level_package_loaded"))
end

function StateSplashScreen:cb_menu_level_package_loaded()
	self._level = ScriptWorld.load_level(self._level_world, self._level_name)

	Level.spawn_background(self._level)
	Level.trigger_level_loaded(self._level)

	local nested_levels = Level.nested_levels(self._level)

	for _, level in ipairs(nested_levels) do
		Level.trigger_level_loaded(level)
	end

	self._level_viewport = ScriptWorld.create_viewport(self._level_world, "menu_level_viewport", "default", 1)
	self._menu_level_loaded = true
end

function StateSplashScreen:_load_changelog()
	if self.parent.loading_context.load_changelog then
		Managers.changelog:get_changelog(callback(self, "cb_changelog_loaded"))
	else
		self._changelog_loaded = true
	end
end

function StateSplashScreen:cb_changelog_loaded(info)
	self._changelog_loaded = true

	local text = info.body

	if text == "" then
		text = nil
	end

	self._changelog_text = text or info.error or "Error"
end

function StateSplashScreen:_load_pdx_account()
	local account_credentials = SaveData.pdx_account_credentials

	if account_credentials and not Managers.pdx_accounts:accounts_id() then
		local account_name = account_credentials.account_name
		local password = account_credentials.password

		self:_try_pdx_login(account_name, password, "cb_pdx_account_authenticated_auto_login")
	else
		self._pdx_account_loaded = true

		if not Managers.pdx_accounts:accounts_id() and GameSettingsDevelopment.enable_paradox_os then
			self._need_pdx_login = true
		end
	end
end

function StateSplashScreen:_try_pdx_login(email, password, callback_name)
	local callback = callback(self, callback_name)

	Managers.pdx_accounts:authenticate(email, password, callback)
end

function StateSplashScreen:cb_error_popup_enter(args)
	Window.set_show_cursor(true)

	local reason = self.parent.loading_context.leave_reason or L(self._dependency_error)

	args.popup_page:find_item_by_name("popup_text"):set_text(reason)
end

function StateSplashScreen:cb_error_popup_item_selected(args)
	if args.action == "quit_game" then
		self.parent.quit_game = true
	elseif args.action == "continue" then
		if self.parent.loading_context.leave_reason then
			self.parent.loading_context.leave_reason = nil
		end

		if not self:_show_changelog() then
			self._wanted_state = self:_get_wanted_state()
		end
	end
end

function StateSplashScreen:_show_changelog()
	if self._changelog_text then
		local omit_revision = Application.user_setting("omit_revision_changelog")
		local current_revision = script_data.settings.content_revision

		if current_revision and (not omit_revision or omit_revision < current_revision) then
			self._splash_screen_menu:goto("changelog_popup")

			return true
		end
	end

	return false
end

function StateSplashScreen:_save_pdx_account_credentials()
	SaveData.pdx_account_credentials = self._pdx_account_credentials

	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_pdx_account_credentials_saved"))
end

function StateSplashScreen:cb_pdx_account_credentials_saved()
	self._pdx_account_credentials_saved = true
end

function StateSplashScreen:cb_changelog_popup_enter(args)
	Window.set_show_cursor(true)

	local header = string.format(L("latest_updates_in_revision"), script_data.settings.content_revision)

	args.popup_page:find_item_by_name("popup_header"):set_text(header)
	args.popup_page:find_item_by_name("popup_text"):set_text(self._changelog_text)
end

function StateSplashScreen:cb_changelog_popup_item_selected(args)
	local checkbox = args.popup_page:find_item_by_name("omit_changelog_checkbox")
	local current_revision = script_data.settings.content_revision

	if checkbox:selected() then
		Application.set_user_setting("omit_revision_changelog", current_revision)
		Application.save_user_settings()
	end

	self._wanted_state = self:_get_wanted_state()
end

function StateSplashScreen:cb_pdx_login_popup_enter(args)
	Window.set_show_cursor(true)

	local popup_email = args.popup_page:find_item_by_name("popup_email")
	local popup_password = args.popup_page:find_item_by_name("popup_password")
	local error_message = args.popup_page:find_item_by_name("error_message")
	local account_credentials = SaveData.pdx_account_credentials
	local account_name = account_credentials and account_credentials.account_name or popup_email:text() ~= "" and popup_email:text() or ""
	local password = ""
	local error_text = self._pdx_error_message or ""

	popup_email:set_text(account_name)
	popup_password:set_text(password)
	error_message:set_text(error_text)
end

function StateSplashScreen:cb_pdx_login_popup_item_selected(args)
	if args.action == "login" then
		local email = args.popup_page:find_item_by_name("popup_email"):text()
		local password = args.popup_page:find_item_by_name("popup_password"):text()

		self:_try_pdx_login(email, password, "cb_pdx_account_authenticated")

		self._pdx_account_credentials = {
			account_name = email,
			password = password
		}
	elseif args.action == "quit_game" then
		self.parent.quit_game = true
	end
end

function StateSplashScreen:cb_pdx_account_login_button_disabled(args)
	local email_item = args.popup_page:find_item_by_name("popup_email")
	local password_item = args.popup_page:find_item_by_name("popup_password")
	local disabled = not email_item:validate_text_length() or not password_item:validate_text_length()

	return disabled
end

function StateSplashScreen:cb_pdx_account_authenticated(info)
	local failed = info.failed or info.body == ""

	if not failed then
		local parsed_body = JSONParser.parse_string(info.body)

		print("pdx_os_login", parsed_body.result)

		local result = parsed_body.result

		if result == "Failure" then
			self._splash_screen_menu:goto("pdx_os_login_popup")

			self._pdx_error_message = parsed_body.errorMessage
		elseif result == "OK" then
			Managers.pdx_accounts:set_accounts_id(parsed_body.id)
			Managers.pdx_telemetry:set_id(parsed_body.id)
			self:_send_start_game_telemetry()
			self:_save_pdx_account_credentials()

			if not self:_show_changelog() then
				self._wanted_state = self:_get_wanted_state()
			end
		end
	else
		table.dump(info)
		self._splash_screen_menu:goto("pdx_os_login_popup")

		self._pdx_error_message = sprintf("Curl Failed: %s", tostring(info.code))
	end
end

function StateSplashScreen:cb_pdx_account_authenticated_auto_login(info)
	local failed = info.failed or info.body == ""

	if not failed then
		local parsed_body = JSONParser.parse_string(info.body)

		print("pdx_os_auto_login", parsed_body.result)

		if parsed_body.result == "OK" then
			Managers.pdx_accounts:set_accounts_id(parsed_body.id)
			Managers.pdx_telemetry:set_id(parsed_body.id)
			self:_send_start_game_telemetry()
		elseif parsed_body.result == "Failure" and parsed_body.errorCode == "not-authorized" and GameSettingsDevelopment.enable_paradox_os then
			self._need_pdx_login = true
		end
	end

	if failed then
		table.dump(info)
	end

	self._pdx_account_loaded = true
end

function StateSplashScreen:_send_start_game_telemetry()
	local pdx_telemetry = Managers.pdx_telemetry
	local timestamp = pdx_telemetry:timestamp()
	local events = {}

	events[#events + 1] = pdx_telemetry:add_start_game_event()

	pdx_telemetry:send_telemetry(events, callback(self, "cb_telemetry_sent"))
end

function StateSplashScreen:cb_telemetry_sent(info)
	table.dump(info, "telemetry")
end

function StateSplashScreen:cb_goto(id)
	self._splash_screen_menu:cb_goto(id)
end

function StateSplashScreen:cb_goto_next_splash_screen()
	self._splash_screen_menu:current_page():goto_first_items_page()
end

function StateSplashScreen:cb_goto_main_menu()
	self._wanted_state = self:_get_wanted_state()

	if not Managers.news_ticker:enabled() then
		Managers.news_ticker:enable(self._splash_screen_world)
	end

	if Managers.package:has_loaded("resource_packages/splash_videos") then
		Managers.state.event:trigger("video_unloaded")
		Managers.package:unload("resource_packages/splash_videos")
	end
end

function StateSplashScreen:_get_wanted_state()
	return self.parent.loading_context.invite_type and StateInviteJoin or self._start_tutorial and StateLoading or StateMenu
end

function StateSplashScreen:_handle_unviewed_unlocks()
	local profile_data = Managers.persistence:profile_data()

	if profile_data then
		local xp = profile_data.attributes.experience
		local rank = profile_data.attributes.rank

		UnviewedUnlockedItemsHelper:fill_unviewed_table(rank, SaveData)

		for idx, profile in ipairs(PlayerProfiles) do
			if profile.no_editing then
				UnviewedUnlockedItems[profile.unlock_key] = nil
			end
		end
	end
end

function StateSplashScreen:on_exit()
	local loading_context = {}

	if self._wanted_state == StateMenu then
		loading_context.level_package_name = self._level_package_name
		loading_context.level_world = self._level_world
		loading_context.level = self._level
		loading_context.level_viewport = self._level_viewport
		loading_context.camera_dummy_units = self._camera_dummy_units
		loading_context.menu_banner_unit = self._menu_banner_unit
		loading_context.menu_shield_units = self._menu_shield_units
		loading_context.menu_main_shield_unit = self._menu_main_shield_unit
		loading_context.alignment_dummy_units = self._alignment_dummy_units
	elseif self._wanted_state == StateInviteJoin then
		loading_context.invite_type = self.parent.loading_context.invite_type
		loading_context.invite_lobby_id = self.parent.loading_context.invite_lobby_id
		loading_context.invite_ip = self.parent.loading_context.invite_ip
	elseif self._start_tutorial then
		Managers.transition:force_fade_in()
		self:_set_tutorial_context_data(loading_context)
	end

	self.parent.loading_context = loading_context

	local news_ticker_manager = Managers.news_ticker

	if news_ticker_manager:enabled() then
		news_ticker_manager:disable(self._splash_screen_world)
	end

	self:_release_input()
	self:_destroy_menu()
	Managers.time:unregister_timer("splash_screen")
end
