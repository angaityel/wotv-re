-- chunkname: @scripts/menu/menu_pages/loading_screen_menu_page.lua

require("scripts/menu/menu_containers/tip_of_the_day_menu_container")

DefaultMessageOfTheDay = "This is a generic Message of the day"
LoadingScreenMenuPage = class(LoadingScreenMenuPage, Level1MenuPage)

function LoadingScreenMenuPage:init(config, item_groups, world)
	LoadingScreenMenuPage.super.init(self, config, item_groups, world)

	self._local_player = config.local_player

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._background_level_texture = TextureMenuContainer.create_from_config()
	self._tip_of_the_day = TipOfTheDayMenuContainer.create_from_config(world)
	self._message_of_the_day = TextBoxMenuContainer.create_from_config(world)

	local message_of_the_day = L("message_of_the_day") .. ": " .. (Managers.lobby.lobby and Managers.lobby:get_lobby_data("message_of_the_day") or DefaultMessageOfTheDay)

	self._message_of_the_day:set_text(message_of_the_day, layout_settings.message_of_the_day, self._gui)

	if layout_settings.arrow_list and item_groups.arrow_list then
		self._arrow_list = ItemListMenuContainer.create_from_config(item_groups.arrow_list)
	end
end

function LoadingScreenMenuPage:event_game_start_countdown_tick(t)
	self._game_start_countdown = t
end

function LoadingScreenMenuPage:event_loading_screen_ask_for_quit()
	local popup_item = self:find_item_by_name("quit_to_lobby")

	self._menu_logic:change_page(popup_item.config.page)
end

function LoadingScreenMenuPage:on_enter(on_cancel)
	LoadingScreenMenuPage.super.on_enter(self, on_cancel)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._game_data = self:_try_callback(self.config.callback_object, "cb_game_data")
	self:find_item_by_name("game_mode_name").config.text = L(GameModeSettings[self._game_data.game_mode].display_name)
	self:find_item_by_name("level_name").config.text = L(LevelSettings[self._game_data.level].display_name)

	local tip_of_the_day = Application.user_setting("tip_of_the_day")

	if tip_of_the_day then
		self._tip_num = tip_of_the_day

		self:_next_tip()
	else
		local tip_name = self:_randomize_tip(self._game_data.level, self._game_data.game_mode)

		self._tip_of_the_day:load_tip(tip_name, self._game_data.level, layout_settings.tip_of_the_day, self._gui)
	end

	Managers.state.event:register(self, "game_start_countdown_tick", "event_game_start_countdown_tick")
	Managers.state.event:register(self, "level_loaded", "event_level_loaded")
	Managers.state.event:register(self, "loading_screen_ask_for_quit", "event_loading_screen_ask_for_quit")
end

function LoadingScreenMenuPage:on_exit(on_cancel)
	LoadingScreenMenuPage.super.on_exit(self, on_cancel)
	Managers.state.event:unregister("loading_screen_ask_for_quit", self)
	Application.set_user_setting("tip_of_the_day", self._tip_num)
	Application.save_user_settings()
end

function LoadingScreenMenuPage:_next_tip()
	local game_data = self:_try_callback(self.config.callback_object, "cb_game_data")
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local tip_name = self:_pick_next_tip(game_data.level, game_data.game_mode)

	self._tip_of_the_day:load_tip(tip_name, game_data.level, layout_settings.tip_of_the_day, self._gui)
end

function LoadingScreenMenuPage:_prev_tip()
	local game_data = self:_try_callback(self.config.callback_object, "cb_game_data")
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local tip_name = self:_pick_prev_tip(game_data.level, game_data.game_mode)

	self._tip_of_the_day:load_tip(tip_name, game_data.level, layout_settings.tip_of_the_day, self._gui)
end

function LoadingScreenMenuPage:_update_input(input)
	Level1MenuPage._update_input(self, input)

	if input:get("next_tip") then
		self:_next_tip()
	end

	if not self:cb_round_not_ready() and input:get("select") then
		self:cb_start_game()
	end
end

function LoadingScreenMenuPage:cb_next_tip()
	self:_next_tip()
end

function LoadingScreenMenuPage:cb_previous_tip()
	self:_prev_tip()
end

function LoadingScreenMenuPage:cb_quit_to_lobby(args)
	if args.action == "yes" then
		Managers.state.event:trigger("loading_screen_confirm_quit")
	end
end

function LoadingScreenMenuPage:_randomize_tip(level, game_mode)
	local num_game_mode_tips = #GameModeSettings[game_mode].tip_of_the_day
	local num_level_tips = #LevelSettings[level].tip_of_the_day

	self._tip_num = math.random(1, num_game_mode_tips + num_level_tips)

	local tip

	if num_game_mode_tips >= self._tip_num then
		tip = GameModeSettings[game_mode].tip_of_the_day[self._tip_num]
	else
		tip = LevelSettings[level].tip_of_the_day[self._tip_num - num_game_mode_tips]
	end

	return tip
end

function LoadingScreenMenuPage:_pick_next_tip(level, game_mode)
	local num_game_mode_tips = #GameModeSettings[game_mode].tip_of_the_day
	local num_level_tips = #LevelSettings[level].tip_of_the_day

	self._tip_num = math.max((self._tip_num + 1) % (num_game_mode_tips + num_level_tips), 1)

	local tip

	if num_game_mode_tips >= self._tip_num then
		tip = GameModeSettings[game_mode].tip_of_the_day[self._tip_num]
	else
		tip = LevelSettings[level].tip_of_the_day[self._tip_num - num_game_mode_tips]
	end

	return tip
end

function LoadingScreenMenuPage:_pick_prev_tip(level, game_mode)
	local num_game_mode_tips = #GameModeSettings[game_mode].tip_of_the_day
	local num_level_tips = #LevelSettings[level].tip_of_the_day

	self._tip_num = self._tip_num - 1

	if self._tip_num < 1 then
		self._tip_num = num_game_mode_tips + num_level_tips
	end

	local tip

	if num_game_mode_tips >= self._tip_num then
		tip = GameModeSettings[game_mode].tip_of_the_day[self._tip_num]
	else
		tip = LevelSettings[level].tip_of_the_day[self._tip_num - num_game_mode_tips]
	end

	return tip
end

function LoadingScreenMenuPage:_update_container_size(dt, t)
	LoadingScreenMenuPage.super._update_container_size(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local message_of_the_day = L("message_of_the_day") .. ": " .. (Managers.lobby.lobby and Managers.lobby:get_lobby_data("message_of_the_day") or DefaultMessageOfTheDay)

	self._message_of_the_day:set_text(message_of_the_day, layout_settings.message_of_the_day, self._gui)
	self._background_level_texture:update_size(dt, t, self._gui, layout_settings.background_level_texture)
	self._tip_of_the_day:update_size(dt, t, self._gui, layout_settings.tip_of_the_day)
	self._message_of_the_day:update_size(dt, t, self._gui, layout_settings.message_of_the_day)
	self._arrow_list:update_size(dt, t, self._gui, layout_settings.arrow_list)
end

function LoadingScreenMenuPage:_update_container_position(dt, t)
	LoadingScreenMenuPage.super._update_container_position(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._background_level_texture, layout_settings.background_level_texture)

	self._background_level_texture:update_position(dt, t, layout_settings.background_level_texture, x, y, self.config.z)

	local x, y = MenuHelper:container_position(self._tip_of_the_day, layout_settings.tip_of_the_day)

	self._tip_of_the_day:update_position(dt, t, layout_settings.tip_of_the_day, x, y, self.config.z + 5)

	local x, y = MenuHelper:container_position(self._message_of_the_day, layout_settings.message_of_the_day)

	self._message_of_the_day:update_position(dt, t, layout_settings.message_of_the_day, x, y, self.config.z + 5)

	local x, y = MenuHelper:container_position(self._arrow_list, layout_settings.arrow_list)

	self._arrow_list:update_position(dt, t, layout_settings.arrow_list, x, y, self.config.z + 5)
end

function LoadingScreenMenuPage:update(...)
	LoadingScreenMenuPage.super.update(self, ...)

	if self._game_start_countdown then
		local start_time = math.max(0, self._game_start_countdown)
		local countdown_item = self:find_item_by_name("countdown")
		local link_item = self:find_item_by_name("next_page_link")
		local m = math.floor(start_time / 60)
		local s = start_time % 60

		countdown_item.config.text = L("battle_starts_in") .. " " .. string.format("%02.f:%02.f", m, s)

		if start_time > StateLoading.round_start_join_allowed then
			if link_item and link_item:pulse() then
				link_item:stop_pulse()
			end
		elseif link_item and not link_item:pulse() then
			link_item:start_pulse(5, 0, 70)
		end
	end
end

function LoadingScreenMenuPage:render(dt, t)
	LoadingScreenMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local res_width, res_height = Gui.resolution()
	local bgr_texture_width = layout_settings.background_level_texture.texture_width
	local bgr_texture_height = layout_settings.background_level_texture.texture_height

	layout_settings.background_level_texture.stretch_height = res_height
	layout_settings.background_level_texture.stretch_width = res_width
	layout_settings.background_level_texture.texture = LevelSettings[self._game_data.level].loading_background or "loading_screen_wip"

	if not IS_DEMO then
		self._background_level_texture:render(dt, t, self._gui, layout_settings.background_level_texture)
		self._tip_of_the_day:render(dt, t, self._gui, layout_settings.tip_of_the_day)
		self._message_of_the_day:render(dt, t, self._gui, layout_settings.message_of_the_day)
	else
		Gui.rect(self._gui, Vector3(0, 0, self.config.z - 1), Vector2(res_width, res_height), Color(0, 0, 0))
	end

	self._arrow_list:render(dt, t, self._gui, layout_settings.arrow_list)
	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)
end

function LoadingScreenMenuPage:destroy()
	LoadingScreenMenuPage.super.destroy(self)
	self._tip_of_the_day:destroy()

	if self._tip_num then
		Application.set_user_setting("tip_of_the_day", self._tip_num)
		Application.save_user_settings()
		print("Saving...", self._tip_num, Application.user_setting("tip_of_the_day"))
	end
end

function LoadingScreenMenuPage:_render_page_links(dt, t, gui, layout_settings)
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		Level1MenuPage._render_page_links(self, dt, t, gui, layout_settings)
	end
end

function LoadingScreenMenuPage:event_level_loaded()
	self._loading_done = true
end

function LoadingScreenMenuPage:cb_loading_done()
	return self._loading_done
end

function LoadingScreenMenuPage:cb_round_not_ready()
	local disabled = not self._game_start_countdown or self._game_start_countdown > StateLoading.round_start_join_allowed

	return disabled
end

function LoadingScreenMenuPage:cb_start_game()
	Managers.state.event:trigger("start_game")
end

function LoadingScreenMenuPage:cb_is_server()
	return Managers.lobby.server
end

function LoadingScreenMenuPage:_select_item()
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		Level1MenuPage._select_item(self)
	end
end

function LoadingScreenMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "loading_screen",
		parent_page = parent_page,
		callback_object = callback_object,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		local_player = compiler_data.menu_data.local_player,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return LoadingScreenMenuPage:new(config, item_groups, compiler_data.world)
end
