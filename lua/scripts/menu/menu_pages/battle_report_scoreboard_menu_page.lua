-- chunkname: @scripts/menu/menu_pages/battle_report_scoreboard_menu_page.lua

require("scripts/menu/menu_containers/item_grid_menu_container")
require("scripts/menu/menu_containers/stat_grid_menu_container")
require("scripts/menu/menu_items/team_scoreboard_menu_item")

BattleReportScoreboardMenuPage = class(BattleReportScoreboardMenuPage, BattleReportBaseMenuPage)

function BattleReportScoreboardMenuPage:init(config, item_groups, world)
	BattleReportScoreboardMenuPage.super.init(self, config, item_groups, world)

	self._world = world
	self._local_player_index = config.local_player_index
	self._background_level_texture = TextureMenuContainer.create_from_config(self)

	self:_setup_scoreboards(config.stats_collection, config.players, config.local_player_index, true)

	self._player_details = StatGridMenuContainer.create_from_config(item_groups.player_details)
end

function BattleReportScoreboardMenuPage:on_enter(on_cancel)
	BattleReportScoreboardMenuPage.super.on_enter(self, on_cancel)

	self._w = nil
	self._h = nil

	Managers.state.event:register(self, "loading_screen_ask_for_quit", "event_loading_screen_ask_for_quit")
end

function BattleReportScoreboardMenuPage:event_loading_screen_ask_for_quit()
	local popup_item = self:find_item_by_name("quit_to_lobby")

	self._menu_logic:change_page(popup_item.config.page)
end

function BattleReportScoreboardMenuPage:cb_quit_to_lobby(args)
	if args.action == "yes" then
		Managers.state.event:trigger("loading_screen_confirm_quit")
	end
end

function BattleReportScoreboardMenuPage:cb_render_border(gui, rect, thickness, color, layer)
	Gui.rect(gui, Vector3(rect[1] - thickness, rect[2], layer or 1), Vector2(rect[3] + thickness * 2, -thickness), color)
	Gui.rect(gui, Vector3(rect[1], rect[2], layer or 1), Vector2(-thickness, rect[4]), color)
	Gui.rect(gui, Vector3(rect[1] + rect[3], rect[2], layer or 1), Vector2(thickness, rect[4]), color)
	Gui.rect(gui, Vector3(rect[1] - thickness, rect[2] + rect[4], layer or 1), Vector2(rect[3] + thickness * 2, thickness), color)
end

function BattleReportScoreboardMenuPage:_add_player_to_team(player_item)
	local team_scoreboard_player_item = self:_create_team_scoreboard_player_item(player_item, self.config.local_player_index)
	local team_name = team_scoreboard_player_item.team_name
	local local_player_team = self:cb_player_team()
	local own_team = team_name == local_player_team and true or false
	local team_scoreboard = own_team and self._left_team_scoreboard or self._right_team_scoreboard

	team_scoreboard:add_player_to_team(team_scoreboard_player_item)
end

function BattleReportScoreboardMenuPage:_remove_player_from_team(player_item)
	local team_scoreboard_player_item = self:_create_team_scoreboard_player_item(player_item, self.config.local_player_index)
	local team_name = team_scoreboard_player_item.team_name
	local local_player_team = self:cb_player_team()
	local own_team = team_name == local_player_team and true or false
	local team_scoreboard = own_team and self._left_team_scoreboard or self._right_team_scoreboard

	team_scoreboard:remove_player_from_team(team_scoreboard_player_item)
end

function BattleReportScoreboardMenuPage:_add_player_to_squad(player_item, squad_index)
	local team_scoreboard_player_item = self:_create_team_scoreboard_player_item(player_item, self.config.local_player_index)
	local team_name = team_scoreboard_player_item.team_name
	local local_player_team = self:cb_player_team()
	local own_team = team_name == local_player_team and true or false
	local team_scoreboard = own_team and self._left_team_scoreboard or self._right_team_scoreboard

	team_scoreboard:add_player_to_squad(team_scoreboard_player_item, squad_index)
end

function BattleReportScoreboardMenuPage:_remove_player_from_squad(player_item, squad_index)
	local team_scoreboard_player_item = self:_create_team_scoreboard_player_item(player_item, self.config.local_player_index)
	local team_name = team_scoreboard_player_item.team_name
	local local_player_team = self:cb_player_team()
	local own_team = team_name == local_player_team and true or false
	local team_scoreboard = own_team and self._left_team_scoreboard or self._right_team_scoreboard

	team_scoreboard:remove_player_from_squad(team_scoreboard_player_item, squad_index)
end

function BattleReportScoreboardMenuPage:_create_player_item(player)
	local player_item = {
		player_index = player.index,
		network_id = player:network_id(),
		player_name = player:name(),
		team_name = player.team and player.team.name,
		squad_index = player.squad_index,
		player_game_object_id = player.game_object_id,
		squad_name = player.squad_index and player.team and player.team.squads[player.squad_index]:name()
	}

	return player_item
end

function BattleReportScoreboardMenuPage:_create_team_scoreboard_player_item(player_item, local_player_index)
	local stats = self.config.stats_collection
	local team_scoreboard_player_item = {
		name = player_item.player_index,
		player_index = player_item.player_index,
		network_id = player_item.network_id,
		player_name = player_item.player_name,
		team_name = player_item.team_name,
		stats = stats,
		player_game_object_id = player_item.player_game_object_id,
		is_player = player_item.player_index == local_player_index,
		squad_name = player_item.squad_name
	}

	return team_scoreboard_player_item
end

function BattleReportScoreboardMenuPage:_setup_scoreboards(stats, players, local_player_index, expand_all)
	local player_team = self:cb_player_team() or "red"
	local other_team = player_team == "red" and "white" or "red"
	local squads = {}
	local lone_wolves = {}

	for player_index, player in pairs(players) do
		local team_name = player.team_name

		if team_name then
			if player.squad_index then
				squads[team_name] = squads[team_name] or {}
				squads[team_name][player.squad_index] = squads[team_name][player.squad_index] or {}
				squads[team_name][player.squad_index].name = squads[team_name][player.squad_index].name or player.squad_name
				squads[team_name][player.squad_index].players = squads[team_name][player.squad_index].players or {}
				squads[team_name][player.squad_index].players[player.network_id] = self:_create_team_scoreboard_player_item(player, local_player_index)
			else
				lone_wolves[team_name] = lone_wolves[team_name] or {}
				lone_wolves[team_name].players = lone_wolves[team_name].players or {}
				lone_wolves[team_name].players[player.network_id] = self:_create_team_scoreboard_player_item(player, local_player_index)
			end
		end
	end

	local left_team_config = {
		layout_settings = "BattleReportSettings.items.scoreboard_left",
		page = self,
		team_name = player_team,
		squads = squads[player_team],
		lone_wolves = lone_wolves[player_team],
		expand_all = expand_all,
		local_team = player_team,
		sounds = self.config.sounds,
		local_player = self.config.local_player
	}

	self._left_team_scoreboard = TeamScoreboardMenuItem.create_from_config({
		world = self._world
	}, left_team_config, self)

	local right_team_config = {
		layout_settings = "BattleReportSettings.items.scoreboard_right",
		page = self,
		team_name = other_team,
		squads = squads[other_team],
		lone_wolves = lone_wolves[other_team],
		expand_all = expand_all,
		local_team = player_team,
		local_player = self.config.local_player,
		sounds = self.config.sounds
	}

	self._right_team_scoreboard = TeamScoreboardMenuItem.create_from_config({
		world = self._world
	}, right_team_config, self)
end

function BattleReportScoreboardMenuPage:_update_container_size(dt, t)
	BattleReportScoreboardMenuPage.super._update_container_size(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._player_details:update_size(dt, t, self._gui, layout_settings.player_details)
end

function BattleReportScoreboardMenuPage:_update_scoreboards_render_mode()
	local squadless_scoreboard = Application.user_setting("squadless_scoreboard")
	local current_mode = self._right_team_scoreboard:render_mode()

	if squadless_scoreboard and current_mode == "squads" then
		self._right_team_scoreboard:set_render_mode("normal")
		self._left_team_scoreboard:set_render_mode("normal")
	elseif not squadless_scoreboard and current_mode == "normal" then
		self._right_team_scoreboard:set_render_mode("squads")
		self._left_team_scoreboard:set_render_mode("squads")
	end
end

function BattleReportScoreboardMenuPage:_update_scoreboards(dt, t)
	local layout_settings_left = MenuHelper:layout_settings(self._left_team_scoreboard.config.layout_settings)
	local layout_settings_right = MenuHelper:layout_settings(self._right_team_scoreboard.config.layout_settings)

	self._left_team_scoreboard:update_size(dt, t, self._gui, layout_settings_left)
	self._right_team_scoreboard:update_size(dt, t, self._gui, layout_settings_right)

	local x, y = MenuHelper:container_position(self._left_team_scoreboard, layout_settings_left)

	self._left_team_scoreboard:update_position(dt, t, layout_settings_left, x, y, self.config.z)

	local x, y = MenuHelper:container_position(self._left_team_scoreboard, layout_settings_right)

	self._right_team_scoreboard:update_position(dt, t, layout_settings_right, x, y, self.config.z)

	local w, h = Gui.resolution()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x = self._right_team_scoreboard:x() + self._right_team_scoreboard:width() - self._player_details:width()
	local y = self._right_team_scoreboard:y() - self._player_details:height() - (layout_settings.player_details.padding_top or 0) * h

	self._player_details:update_position(dt, t, layout_settings.player_details, x, y, self.config.z)
end

function BattleReportScoreboardMenuPage:update(dt, t)
	self.super.update(self, dt, t)
	self:_update_scoreboards_render_mode()
	self:_update_scoreboards(dt, t)

	local controller_active = Managers.input:pad_active(1)

	if controller_active and not self._current_highlight then
		local potential_items = self:find_items_of_type("battle_report_scoreboard")
		local min_y = math.huge
		local potential_item

		for _, item in ipairs(potential_items) do
			if min_y > item._y then
				potential_item = item
				min_y = item._y
			end
		end

		for _, item in ipairs(self._items) do
			if item == potential_item then
				self:_highlight_item(index)
			end
		end
	end
end

function BattleReportScoreboardMenuPage:_update_input(input)
	BattleReportScoreboardMenuPage.super._update_input(self, input)
	self:_update_item_input(input)

	if input:get("next_battle") then
		self:cb_goto_menu_page("loading_screen")
	end
end

function BattleReportScoreboardMenuPage:_update_item_input(input)
	local controller = Managers.input:active_mapping(1)

	if controller == "pad360" then
		self:_update_item_controller_input(input)
	elseif controller == "keyboard_mouse" then
		self:_update_item_mouse_input(input)
	else
		fassert(nil, "[BattleReportScoreboardMenuPage] Implement support for other controllers, ya dummy!")
	end

	self._left_team_scoreboard:update_item_input(input, self._gui)
	self._right_team_scoreboard:update_item_input(input, self._gui)
end

function BattleReportScoreboardMenuPage:_update_item_controller_input(input)
	local left_stick = input:has("wheel") and input:get("wheel")[2]
	local right_stick = input:has("wheel_right") and input:get("wheel_right")[2]

	self._left_team_scoreboard:update_pad_inside(left_stick)
	self._right_team_scoreboard:update_pad_inside(right_stick)
end

function BattleReportScoreboardMenuPage:_update_item_mouse_input(input)
	local mouse_scroll = input:has("mouse_scroll") and input:get("mouse_scroll")[2]
	local cursor = input:has("cursor") and input:get("cursor")

	self._left_team_scoreboard:update_mouse_inside(cursor, mouse_scroll)
	self._right_team_scoreboard:update_mouse_inside(cursor, mouse_scroll)
end

function BattleReportScoreboardMenuPage:render(dt, t)
	BattleReportScoreboardMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local layout_settings_left = MenuHelper:layout_settings(self._left_team_scoreboard.config.layout_settings)
	local layout_settings_right = MenuHelper:layout_settings(self._right_team_scoreboard.config.layout_settings)

	self._left_team_scoreboard:render(dt, t, self._gui, layout_settings_left)
	self._right_team_scoreboard:render(dt, t, self._gui, layout_settings_right)
	self._player_details:render(dt, t, self._gui, layout_settings.player_details)
	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)
end

function BattleReportScoreboardMenuPage:move_up()
	local controller_active = Managers.input:pad_active(1)

	if controller_active then
		local potential_items = self:find_items_of_type("battle_report_scoreboard")
		local current_item = self._items[self._current_highlight]

		if not current_item then
			return
		end

		local y = current_item._y
		local min_diff = math.huge
		local potential_item

		for _, test_item in ipairs(potential_items) do
			local diff = math.abs(test_item._y - y)

			if test_item:highlightable() and current_item ~= test_item and y < test_item._y and diff < min_diff then
				potential_item = test_item
				min_diff = diff
			end
		end

		if potential_item then
			for index, item in ipairs(self._items) do
				if item == potential_item then
					self:_highlight_item(index)

					break
				end
			end
		end
	else
		BattleReportScoreboardMenuPage.super.move_up(self)
	end
end

function BattleReportScoreboardMenuPage:move_down()
	local controller_active = Managers.input:pad_active(1)

	if controller_active then
		local potential_items = self:find_items_of_type("battle_report_scoreboard")
		local current_item = self._items[self._current_highlight]

		if not current_item then
			return
		end

		local y = current_item._y
		local min_diff = math.huge
		local potential_item

		for _, test_item in ipairs(potential_items) do
			local diff = math.abs(test_item._y - y)

			if test_item:highlightable() and current_item ~= test_item and y > test_item._y and diff < min_diff then
				potential_item = test_item
				min_diff = diff
			end
		end

		if potential_item then
			for index, item in ipairs(self._items) do
				if item == potential_item then
					self:_highlight_item(index)

					break
				end
			end
		end
	else
		BattleReportScoreboardMenuPage.super.move_down(self)
	end
end

function BattleReportScoreboardMenuPage:_render_button_info(layout_settings)
	local button_config = layout_settings.default_buttons
	local text_data = layout_settings.text_data
	local w, h = Gui.resolution()
	local x = text_data.offset_x or 0
	local y = text_data.offset_y or 0
	local offset_x = 0

	for _, button in ipairs(button_config) do
		local material, uv00, uv11, size = HUDHelper:get_360_button_bitmap(button.button_name)

		Gui.bitmap_uv(self._button_gui, material, uv00, uv11, Vector3(x + offset_x, y - size[2], 999), size)

		local text = string.upper(L(button.text))

		Gui.text(self._button_gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + size[1] + offset_x, y - size[2] * 0.62, 999))

		if text_data.drop_shadow then
			local drop_x, drop_y = unpack(text_data.drop_shadow)

			Gui.text(self._button_gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + size[1] + offset_x, y - size[2] * 0.62, 998), Color(0, 0, 0))
		end

		local min, max = Gui.text_extents(self._button_gui, text, text_data.font.font, text_data.font_size)

		offset_x = offset_x + (max[1] - min[1]) + size[2]
	end
end

function BattleReportScoreboardMenuPage:_select_item()
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		BattleReportBaseMenuPage._select_item(self)
	end
end

function BattleReportScoreboardMenuPage:cb_goto_menu_page(id)
	self._menu_logic:goto(id)
end

function BattleReportScoreboardMenuPage:cb_server_name()
	return Managers.lobby:server_name()
end

function BattleReportScoreboardMenuPage:cb_player_team()
	local player_team = self.config.players[self._local_player_index].team_name or "red"

	if player_team == "unassigned" then
		return "red"
	else
		return player_team or "red"
	end
end

function BattleReportScoreboardMenuPage:cb_my_team_score()
	local team_name = self.config.players[self._local_player_index].team_name or "red"

	if team_name == "unassigned" then
		team_name = "red"
	end

	local score = self.config[team_name .. "_team_score"]

	return score
end

function BattleReportScoreboardMenuPage:cb_team_color()
	return self._player_details:team_color()
end

function BattleReportScoreboardMenuPage:cb_is_alpha()
	return true
end

function BattleReportScoreboardMenuPage:cb_is_not_alpha()
	return false
end

function BattleReportScoreboardMenuPage:cb_update_player_details(player)
	local player_name = player.player_name
	local kills = player.stats:get(player.network_id, "enemy_kills")
	local deaths = player.stats:get(player.network_id, "deaths")
	local headshots = player.stats:get(player.network_id, "headshots")
	local kills_item = self:find_item_by_name_in_group("player_details", "kills_value")
	local deaths_item = self:find_item_by_name_in_group("player_details", "deaths_value")
	local headshots_item = self:find_item_by_name_in_group("player_details", "headshots_value")

	self._player_details:set_player_name(player_name)
	self._player_details:set_player_team_color(player.team_name == "white" and {
		255,
		255,
		128,
		0
	} or {
		255,
		200,
		200,
		255
	})
	kills_item:set_text(tostring(kills))
	deaths_item:set_text(tostring(deaths))
	headshots_item:set_text(tostring(headshots))
end

function BattleReportScoreboardMenuPage:cb_other_team_score()
	local team_name = self.config.players[self._local_player_index].team_name or "red"

	if team_name == "unassigned" then
		team_name = "red"
	end

	local other_team_name = team_name == "red" and "white" or "red"
	local score = self.config[other_team_name .. "_team_score"]

	return score
end

function BattleReportScoreboardMenuPage:cb_background_texture()
	return self:_try_callback(self.config.callback_object, "cb_level_texture")
end

function BattleReportScoreboardMenuPage:on_exit(on_cancel)
	BattleReportScoreboardMenuPage.super.on_exit(self, on_cancel)
	Managers.state.event:unregister("loading_screen_ask_for_quit", self)
end

function BattleReportScoreboardMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "battle_report_scoreboard",
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_page = page_config.on_enter_page,
		on_exit_page = page_config.on_exit_page,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		music_events = page_config.music_events,
		players = compiler_data.menu_data.players,
		local_player_index = compiler_data.menu_data.local_player_index,
		local_player = compiler_data.menu_data.local_player,
		stats_collection = compiler_data.menu_data.stats_collection,
		red_team_score = compiler_data.menu_data.red_team_score,
		white_team_score = compiler_data.menu_data.white_team_score,
		winning_team_name = compiler_data.menu_data.winning_team_name,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return BattleReportScoreboardMenuPage:new(config, item_groups, compiler_data.world)
end
