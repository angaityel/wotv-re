-- chunkname: @scripts/game_state/state_loading.lua

require("scripts/managers/network/loading_network_manager")
require("scripts/menu/menus/loading_screen_menu")
require("scripts/menu/menu_controller_settings/loading_screen_menu_controller_settings")
require("scripts/menu/menu_definitions/loading_screen_menu_definition")
require("scripts/menu/menu_callbacks/loading_screen_menu_callbacks")

StateLoading = class(StateLoading)

local CHAT_INPUT_DEFAULT_COMMAND = "say"
local MAX_CHAT_INPUT_CHARS = 150

StateLoading.round_start_auto_join = 10
StateLoading.round_start_join_allowed = 20

function StateLoading:on_enter(param_block)
	Managers.time:register_timer("loading", "main")
	self:setup_state_context()
	self:_init_variables()

	self._menu_world = Managers.world:create_world("menu_world", GameSettingsDevelopment.default_environment, nil, nil)
	self._viewport = ScriptWorld.create_viewport(self._menu_world, "menu_viewport", "default")
	self._gui = World.create_screen_gui(self._menu_world, "material", MenuSettings.font_group_materials.arial, "immediate")

	if not self.loading_context.disable_loading_screen_menu and not GameSettingsDevelopment.disable_loading_screen_menu then
		self:_setup_menu()
		Managers.transition:fade_out(MenuSettings.transitions.fade_out_speed)
	end

	self:_setup_package_loading()

	self._game_start_countdown = self.loading_context.game_start_countdown
	self._game_start_countdown_tick = nil

	self:_setup_chat()

	self._level_loaded = Managers.lobby.server ~= nil

	Managers.state.event:register(self, "start_game", "event_start_game")
	Managers.state.event:register(self, "loading_screen_confirm_quit", "event_loading_screen_confirm_quit")
	Managers.news_ticker:enable(self._menu_world)

	local loading_context = self.loading_context

	if loading_context.local_player_team then
		local event = "Play_battlereport_music_"

		if loading_context.local_player_team == "red" then
			event = event .. "vikings_"
		else
			event = event .. "saxxons_"
		end

		if loading_context.local_player_won then
			event = event .. "win"
		else
			event = event .. "lose"
		end

		Managers.music:trigger_event(event)
	end
end

function StateLoading:_init_variables()
	self._start_game = false
	self._loading_screen_confirm_quit = false
end

function StateLoading:_setup_chat()
	self._chat_input_blackboard = {
		text = ""
	}
	self._light_chat_shutdown = false

	Managers.state.event:trigger("event_chat_initiated", self._chat_input_blackboard)

	self._big_picture_input_handler = BigPictureInputHandler:new()
end

function StateLoading:game_start_countdown()
	return self._game_start_countdown
end

function StateLoading:update(dt)
	HUDHelper:update_resolution()
	MenuHelper:update_resolution()

	local t = Managers.time:time("loading")

	Managers.input:update(dt)

	if Managers.state.hud then
		Managers.state.hud:post_update(dt, t, "default")
		self:_handle_chat()
	end

	if self._game_start_countdown then
		self._game_start_countdown = math.max(0, self._game_start_countdown - dt)

		if self._game_start_countdown < StateLoading.round_start_auto_join then
			Managers.state.event:trigger("start_game")
		end
	end

	if self._loading_screen_confirm_quit then
		Managers.state.event:trigger("start_game")
	end

	Managers.music:update(dt)
	Managers.state.network:update(dt)

	if self._menu then
		self:_update_input(self._menu._input_source)
	end

	self:_update_loading_screen(dt, t)
	self:_update_loading_state(dt, t)

	return self._new_state
end

function StateLoading:_handle_chat()
	if self._delayed_controller_overlay_deactivate then
		self._overlay_active = self._big_picture_input_handler:is_deactivating()

		if not self._overlay_active then
			self._delayed_controller_overlay_deactivate = nil
		end
	end

	if self._overlay_active then
		local text, done, submitted = self._big_picture_input_handler:poll_text_input_done()

		if done then
			if submitted then
				self:_execute_controller_chat_input(text)
			end

			self._delayed_controller_overlay_deactivate = true
		end
	end

	if self._delayed_chat_input_deactivate then
		self._chat_input_active = false
		self._delayed_chat_input_deactivate = nil
	end
end

function StateLoading:_modify_chat_input_blackboard(input)
	local text = self._chat_input_blackboard.text
	local index = self._chat_input_blackboard.input_index
	local mode = self._chat_input_blackboard.input_mode or "insert"
	local keystrokes = Keyboard.keystrokes()
	local new_text, new_index, new_mode = KeystrokeHelper.parse_strokes(text, index, mode, keystrokes)

	if KeystrokeHelper.num_utf8chars(new_text) > MAX_CHAT_INPUT_CHARS then
		return
	end

	self._chat_input_blackboard.text = new_text
	self._chat_input_blackboard.input_index = new_index
	self._chat_input_blackboard.input_mode = new_mode
end

function StateLoading:_update_input(input_source)
	if self._chat_input_active then
		self:_modify_chat_input_blackboard(input_source)

		if input_source:get("activate_chat_input") then
			self:_execute_chat_input()
		end
	elseif input_source:get("activate_chat_input") then
		self:_activate_chat_input(input_source, Managers.command_parser:build_command_line("say", ""), false)
	end

	if self._chat_input_active and input_source:get("deactivate_chat_input") then
		Managers.state.event:trigger("event_chat_input_deactivated")
	elseif input_source:get("close_menu") then
		Managers.state.event:trigger("loading_screen_ask_for_quit")
	end
end

function StateLoading:_execute_chat_input()
	self._chat_input_active = false

	local success, msg, command = Managers.command_parser:execute(self._chat_input_blackboard.text)

	if command then
		self._chat_input_prefix = Managers.command_parser:build_command_line(command, "")
	end

	Managers.state.event:trigger("event_chat_input_deactivated")
end

function StateLoading:_activate_chat_input(input, prefix, try_big_picture)
	if GameSettingsDevelopment.network_mode ~= "steam" or not Managers.lobby.lobby or self._overlay_active then
		return
	end

	if try_big_picture then
		local reason = ""

		self._overlay_active, reason = self._big_picture_input_handler:show_text_input(L("enter_chat_message"), 0, MAX_CHAT_INPUT_CHARS)

		if self._overlay_active then
			self._disable_input = true

			local text = prefix or self._chat_input_prefix or Managers.command_parser:build_command_line(CHAT_INPUT_DEFAULT_COMMAND, "")

			self._chat_input_blackboard.text = text

			return
		elseif reason == "deactivating" then
			return
		end
	end

	self._chat_input_active = true

	local chat_bb = self._chat_input_blackboard
	local text

	if self._light_chat_shutdown then
		text = chat_bb.text
		self._light_chat_shutdown = false
	else
		text = prefix or self._chat_input_prefix or Managers.command_parser:build_command_line(CHAT_INPUT_DEFAULT_COMMAND, "")
		chat_bb.text = text
	end

	local length = string.len(text)
	local index = 1
	local utf8chars = 0
	local _

	while index <= length do
		_, index = Utf8.location(text, index)
		utf8chars = utf8chars + 1
	end

	chat_bb.input_index = utf8chars + 1

	Managers.state.event:trigger("event_chat_input_activated")
end

function StateLoading:_update_loading_state(dt, t)
	local max_ = math.random()
	local drop_in_settings = Managers.state.network:drop_in_settings()

	if drop_in_settings and not self._loading_screen_confirm_quit then
		self:_unload_level_package()

		self.parent.loading_context.level_key = drop_in_settings.level_key
		self.parent.loading_context.game_mode_key = drop_in_settings.game_mode_key
		self.parent.loading_context.time_limit = drop_in_settings.time_limit
		self.parent.loading_context.win_score = drop_in_settings.win_score
		self.parent.loading_context.level_cycle = drop_in_settings.level_cycle
		self.parent.loading_context.level_cycle_count = drop_in_settings.level_cycle_count
		self.parent.loading_context.game_start_countdown = drop_in_settings.game_start_countdown
		self.parent.loading_context.disable_loading_screen_menu = drop_in_settings.disable_loading_screen_menu
		self.enter_game = false
		self._game_start_countdown = drop_in_settings.game_start_countdown

		self:_setup_package_loading()

		if self._fading_in then
			self._fading_in = false

			Managers.transition:fade_out(MenuSettings.transitions.fade_out_speed, nil)
		end
	elseif (self.enter_game or self._loading_screen_confirm_quit) and not self._fading_in then
		self._fading_in = true

		Window.set_show_cursor(false)
		Managers.state.event:trigger("disable_menu_input")
		Managers.transition:fade_in(MenuSettings.transitions.fade_in_speed, callback(self, "cb_transition_fade_in_done"))
	end
end

function StateLoading:_update_loading_screen(dt, t)
	Profiler.start("StateLoading:_update_loading_screen - 1")
	self:_update_game_start_countdown_tick()
	self:_check_enter_game()
	self:_check_loading_done()
	Profiler.stop("StateLoading:_update_loading_screen - 1")

	if self._menu then
		Profiler.start("StateLoading:_update_loading_screen - 2")
		self._menu:update(dt, t)
		Profiler.stop("StateLoading:_update_loading_screen - 2")
	end
end

function StateLoading:_update_game_start_countdown_tick()
	local countdown = self._game_start_countdown

	if countdown then
		local countdown_tick = math.ceil(countdown)

		if countdown_tick ~= self._game_start_countdown_tick then
			self._game_start_countdown_tick = countdown_tick

			Managers.state.event:trigger("game_start_countdown_tick", countdown_tick)
		end
	end
end

function StateLoading:_check_loading_done()
	for _, name in ipairs(GameSettingsDevelopment.delayed_load_packages) do
		if not PackageManager:has_loaded(name) then
			return
		end
	end

	if self._level_loaded then
		return
	end

	if self._level_package_loaded and self.parent.permission_to_enter_game then
		Managers.state.event:trigger("level_loaded")

		self._level_loaded = true
	end
end

function StateLoading:_check_enter_game()
	if not self._level_package_loaded or self.enter_game then
		return
	end

	Managers.state.event:trigger("event_load_finished")

	if Managers.lobby.server and not self.parent.enter_game then
		for _, member in ipairs(Managers.lobby:lobby_members()) do
			if member ~= Network.peer_id() then
				RPC.rpc_permission_to_enter_game(member)
			end
		end

		self._start_game = true
		self.enter_game = true
	elseif not Managers.lobby.lobby then
		self.enter_game = true

		print("Level loaded, starting game")
	elseif self.parent.permission_to_enter_game and self._start_game then
		self.enter_game = true

		print("Level loaded, starting game")

		self.parent.permission_to_enter_game = false
	end
end

function StateLoading:_async_package_loaded_callback(package_name)
	self._level_package_loaded = true
end

function StateLoading:_setup_package_loading()
	local level_key = self.parent.loading_context.level_key
	local level_package = LevelSettings[level_key].package_name

	if EDITOR_LAUNCH then
		self:_async_package_loaded_callback(level_package)
	else
		Managers.package:load(level_package, callback(self, "_async_package_loaded_callback", level_package))
	end

	Managers.state.event:trigger("event_load_started", "menu_loading_level", "menu_level_loaded")
end

function StateLoading:_setup_menu()
	self:_setup_input()

	local loading_context = self.loading_context
	local menu_data = {
		viewport_name = "menu_viewport",
		players = loading_context.players,
		local_player_index = loading_context.local_player_index,
		local_player_won = loading_context.local_player_won,
		stats_collection = loading_context.stats_collection,
		gained_xp_and_coins = loading_context.gained_xp_and_coins,
		penalty_xp = loading_context.penalty_xp,
		awarded_prizes = loading_context.awarded_prizes,
		awarded_medals = loading_context.awarded_medals,
		awarded_ranks = loading_context.awarded_ranks,
		red_team_score = loading_context.red_team_score,
		white_team_score = loading_context.white_team_score,
		winning_team_name = loading_context.winning_team_name,
		gui_init_parameters = {
			"material",
			"materials/menu/loading_atlas",
			"material",
			MenuSettings.font_group_materials.hell_shark,
			"material",
			"materials/menu/menu",
			"material",
			MenuSettings.font_group_materials.font_gradient_100,
			"material",
			MenuSettings.font_group_materials.arial,
			"material",
			"materials/hud/buttons",
			"immediate"
		}
	}

	loading_context.stats_collection = nil

	if self.loading_context.menu_loading or not menu_data.players then
		self._menu = LoadingScreenMenu:new(self, self._menu_world, LoadingScreenMenuControllerSettings, LoadingScreenMenuSettings, LoadingScreenMenuFirstRoundDefinition, LoadingScreenMenuCallbacks, menu_data)
	else
		self._menu = LoadingScreenMenu:new(self, self._menu_world, LoadingScreenMenuControllerSettings, LoadingScreenMenuSettings, LoadingScreenMenuDuringRoundsDefinition, LoadingScreenMenuCallbacks, menu_data)
	end

	self.loading_context.menu_loading = nil

	self._menu:set_active(true)

	if GameSettingsDevelopment.enable_robot_player then
		self._menu:goto("loading_screen")

		self._start_game = true
	elseif menu_data.stats_collection then
		self._menu:goto("battle_report_scoreboard")
	else
		self._menu:goto("loading_screen")
	end

	if self.loading_context.chat_text_data then
		Managers.state.hud = HUDManager:new(self._menu_world)

		local hud_data = {
			chat_window = {
				class = "ChatOutputWindow",
				data = {
					output_window_layout_settings = "HUDSettings.chat.new_output_window_loadingscreen",
					not_ingame = true,
					input_text_layout_settings = "HUDSettings.chat.input_text",
					register_events = true,
					text_data = self.loading_context.chat_text_data,
					input_source = self._menu._input_source
				}
			}
		}

		Managers.state.hud:add_player("default", hud_data)
	end
end

function StateLoading:_destroy_menu()
	self._menu:destroy()

	self._menu = nil

	self:_release_input()
	Window.set_show_cursor(false)
end

function StateLoading:_setup_input(param_block)
	local im = Managers.input

	im:map_controller(Keyboard, 1)
	im:map_controller(Mouse, 1)

	if GameSettingsDevelopment.allow_gamepad then
		im:map_controller(Pad1, 1)
	end
end

function StateLoading:_release_input()
	local im = Managers.input

	im:unmap_controller(Keyboard)
	im:unmap_controller(Mouse)

	if GameSettingsDevelopment.allow_gamepad then
		im:unmap_controller(Pad1)
	end
end

function StateLoading:_on_exit_loading_screen()
	if self._menu then
		self:_destroy_menu()
	end

	Managers.music:trigger_event("Stop_menu_music")
	Managers.music:trigger_event("Stop_battlereport_music")

	local loading_context = self.loading_context

	loading_context.players = nil
	loading_context.local_player_index = nil
	loading_context.stats_collection = nil

	if Managers.state.hud then
		self.parent.loading_context.chat_text_data = Managers.state.hud:get_hud("default", "chat_window"):text_data()
	end

	Managers.world:destroy_world(self._menu_world)
end

function StateLoading:cb_transition_fade_in_done()
	if self._loading_screen_confirm_quit then
		if Managers.lobby.lobby then
			Managers.lobby:reset()
		end

		self._new_state = StateSplashScreen
	else
		self._new_state = StateIngame
	end
end

function StateLoading:event_start_game()
	self._start_game = true
end

function StateLoading:_unload_level_package()
	local old_level_key = self.parent.loading_context.level_key

	self._level_package_loaded = false

	local level_package = LevelSettings[old_level_key].package_name

	Managers.package:unload(level_package)
end

function StateLoading:event_loading_screen_confirm_quit()
	self._loading_screen_confirm_quit = true
	self.enter_game = false

	self:_unload_level_package()
	print("Quit selected, returning to menu")
end

function StateLoading:on_exit()
	local news_ticker_manager = Managers.news_ticker

	if news_ticker_manager:enabled() then
		news_ticker_manager:disable(self._menu_world)
	end

	Managers.time:unregister_timer("loading")
	Managers.state:destroy()
	self:_on_exit_loading_screen()

	self.parent.loading_context.game_start_countdown = self._game_start_countdown
end

function StateLoading:setup_state_context()
	local sc = self.parent

	self.loading_context = sc.loading_context

	assert(sc.loading_context)
	assert(sc.loading_context.level_key)
	assert(sc.loading_context.game_mode_key)
	print("Load level :", tostring(sc.loading_context.level_key))

	GameSettingsDevelopment.tutorial_mode = sc.loading_context.level_key == "Tutorial"
	Managers.state.event = EventManager:new()
	Managers.state.network = LoadingNetworkManager:new(self, Managers.lobby.lobby)
end
