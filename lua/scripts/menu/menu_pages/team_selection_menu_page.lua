-- chunkname: @scripts/menu/menu_pages/team_selection_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")
require("scripts/menu/menu_pages/teams_menu_page")

TeamSelectionMenuPage = class(TeamSelectionMenuPage, TeamsMenuPage)

function TeamSelectionMenuPage:init(config, item_groups, world)
	TeamSelectionMenuPage.super.init(self, config, item_groups, world)

	self._local_player = config.local_player
	self._friends = {}

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if layout_settings.back_list and item_groups.back_list then
		self._back_list = ItemListMenuContainer.create_from_config(item_groups.back_list)
	end

	if layout_settings.page_links and item_groups.page_links then
		self._page_links = ItemListMenuContainer.create_from_config(item_groups.page_links)
	end

	if layout_settings.auto_join_items and item_groups.auto_join_items then
		self._auto_join = ItemListMenuContainer.create_from_config(item_groups.auto_join_items)
	end

	if layout_settings.page_name then
		self._page_name = ItemListMenuContainer.create_from_config(item_groups.page_name)
	end

	local event_manager = Managers.state.event

	event_manager:register(self, "join_team_confirmed", "event_join_team_confirmed")
	event_manager:register(self, "join_team_denied", "event_join_team_denied")
end

function TeamSelectionMenuPage:event_join_team_confirmed()
	return
end

function TeamSelectionMenuPage:event_join_team_denied()
	self._joining_team = false
end

function TeamSelectionMenuPage:on_enter()
	TeamSelectionMenuPage.super.on_enter(self)

	self._joining_team = false

	if self.config.on_enter_page then
		self:_try_callback(self.config.callback_object, self.config.on_enter_page, unpack(self.config.on_enter_page_args))
	end

	if GameSettingsDevelopment.enable_robot_player then
		self:cb_auto_join_team()
	end

	if rawget(_G, "Steam") then
		self:_refresh_friends()
	end
end

function TeamSelectionMenuPage:_refresh_friends()
	local friends = SteamHelper.friends()

	for id, data in pairs(self._friends) do
		if not friends[id] then
			self._friends[id] = nil
		end
	end

	for id, data in pairs(friends) do
		if not self._friends[id] then
			self._friends[id] = data
		end
	end
end

function TeamSelectionMenuPage:move_left()
	local team_item = self:find_item_by_name_in_group("left_team_items", "red_team_rose")

	for index, item in ipairs(self._items) do
		if item == team_item then
			self:_highlight_item(index, true)
		end
	end
end

function TeamSelectionMenuPage:move_right()
	local team_item = self:find_item_by_name_in_group("right_team_items", "white_team_rose")

	for index, item in ipairs(self._items) do
		if item == team_item then
			self:_highlight_item(index, true)
		end
	end
end

function TeamSelectionMenuPage:move_up()
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		self.super.move_up(self)
	end
end

function TeamSelectionMenuPage:move_down()
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		self.super.move_down(self)
	end
end

function TeamSelectionMenuPage:update(dt, t)
	TeamSelectionMenuPage.super.update(self, dt, t)

	local red_team = Managers.state.team:team_by_name("red")
	local red_team_score_item = self:find_item_by_name("red_num_members")

	red_team_score_item.config.text = red_team.num_members

	local white_team = Managers.state.team:team_by_name("white")
	local white_team_score_item = self:find_item_by_name("white_num_members")

	white_team_score_item.config.text = white_team.num_members

	local round_time = Managers.time:time("round")
	local controller_active = Managers.input:pad_active(1)

	if controller_active and not self._current_highlight then
		local selected_item
		local team_item = self:find_item_by_name_in_group("left_team_items", "red_team_rose")

		if team_item and team_item:highlightable() then
			selected_item = team_item
		end

		team_item = self:find_item_by_name_in_group("left_team_items", "white_team_rose")

		if not selected_item and team_item and team_item:highlightable() then
			selected_item = team_item
		end

		if selected_item then
			for index, item in ipairs(self._items) do
				if item == selected_item then
					self:_highlight_item(index, true)
				end
			end
		end
	end
end

function TeamSelectionMenuPage:_update_input(input)
	self.super._update_input(self, input)

	local controller_active = Managers.input:pad_active(1)

	if controller_active then
		if input:get("auto_join_team") then
			self:cb_auto_join_team()
		elseif input:get("leave_battle") then
			local child_page = self._item_groups.back_list[1]:page()

			self._menu_logic:change_page(child_page)
		end
	end
end

function TeamSelectionMenuPage:_update_container_size(dt, t)
	TeamSelectionMenuPage.super._update_container_size(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if self._back_list then
		self._back_list:update_size(dt, t, self._gui, layout_settings.back_list)
	end

	if self._page_links then
		self._page_links:update_size(dt, t, self._gui, layout_settings.page_links)
	end

	if self._auto_join then
		self._auto_join:update_size(dt, t, self._gui, layout_settings.auto_join_items)
	end

	if self._red_players then
		self._red_players:update_size(dt, t, self._gui, layout_settings.red_players)
	end

	if self._white_players then
		self._white_players:update_size(dt, t, self._gui, layout_settings.white_players)
	end

	if self._page_name then
		self._page_name:update_size(dt, t, self._gui, layout_settings.page_name)
	end
end

function TeamSelectionMenuPage:_update_container_position(dt, t)
	TeamSelectionMenuPage.super._update_container_position(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if self._back_list then
		local x, y = MenuHelper:container_position(self._back_list, layout_settings.back_list)

		self._back_list:update_position(dt, t, layout_settings.back_list, x, y, self.config.z + 15)
	end

	if self._page_links then
		local x, y = MenuHelper:container_position(self._page_links, layout_settings.page_links)

		self._page_links:update_position(dt, t, layout_settings.page_links, x, y, self.config.z + 15)
	end

	if self._auto_join then
		local x, y = MenuHelper:container_position(self._auto_join, layout_settings.auto_join_items)

		self._auto_join:update_position(dt, t, layout_settings.auto_join_items, x, y, self.config.z + 15)
	end

	if self._red_players then
		local x, y = MenuHelper:container_position(self._red_players, layout_settings.red_players)

		self._red_players:update_position(dt, t, layout_settings.red_players, x, y, self.config.z + 15)
	end

	if self._white_players then
		local x, y = MenuHelper:container_position(self._white_players, layout_settings.white_players)

		self._white_players:update_position(dt, t, layout_settings.white_players, x, y, self.config.z + 15)
	end

	if self._page_name then
		local x, y = MenuHelper:container_position(self._page_name, layout_settings.page_name)

		self._page_name:update_position(dt, t, layout_settings.page_name, x, y, self.config.z + 15)
	end
end

function TeamSelectionMenuPage:render(dt, t, rendered_from_child_page)
	TeamSelectionMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local controller_active = Managers.input:pad_active(1)

	if not controller_active then
		if self._back_list then
			self._back_list:render(dt, t, self._gui, layout_settings.back_list)
		end

		if self._page_links then
			self._page_links:render(dt, t, self._gui, layout_settings.page_links)
		end
	end

	if self._auto_join then
		self._auto_join:render(dt, t, self._gui, layout_settings.auto_join_items)
	end

	if self._red_players then
		self._red_players:render(dt, t, self._gui, layout_settings.red_players)
	end

	if self._white_players then
		self._white_players:render(dt, t, self._gui, layout_settings.white_players)
	end

	if self._page_name then
		self._page_name:render(dt, t, self._gui, layout_settings.page_name)
	end

	self._rendered_from_child_page = rendered_from_child_page

	local layout_settings

	if self.config.layout_settings then
		layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	end

	if controller_active and (not layout_settings or not layout_settings.do_not_render_buttons) then
		local button_info

		if layout_settings and layout_settings.button_info then
			button_info = layout_settings.button_info
		else
			button_info = MenuHelper:layout_settings(MainMenuSettings.default_button_info)
		end

		self:_render_button_info(button_info)
	end
end

function TeamSelectionMenuPage:_render_button_info(layout_settings)
	if not self._rendered_from_child_page then
		self.super._render_button_info(self, layout_settings)
	end
end

function TeamSelectionMenuPage:cb_quote_text()
	return L("team_selection_quote")
end

function TeamSelectionMenuPage:cb_join_team_selected(team_name)
	Managers.state.team:request_join_team(self._local_player, team_name)

	self._joining_team = true
end

function TeamSelectionMenuPage:cb_join_team_selection_disabled(team_name)
	return self._joining_team or not Managers.state.team:verify_join_team(self._local_player, team_name)
end

function TeamSelectionMenuPage:cb_observer_team_selected()
	local team = self._local_player.team

	if team and team.name == "unassigned" then
		Managers.state.event:trigger("join_team_confirmed")
	elseif team then
		Managers.state.team:request_join_team(self._local_player, "unassigned")

		self._joining_team = true
	end
end

function TeamSelectionMenuPage:is_friend(player)
	local network_id = player:network_id()

	return player.local_player or is_friend
end

function TeamSelectionMenuPage:cb_show_red_team()
	do return end

	local items = self:items_in_group("right_team_items")

	for _, item in pairs(items) do
		item.config.visible = false
	end

	local red_team = Managers.state.team:team_by_name("red")
	local members = red_team.members
	local config = {
		name = "header",
		layout_settings = "SquadMenuSettings.items.player_text_header",
		disabled = true,
		no_localization = true,
		text = #members .. " " .. L("menu_team_players")
	}
	local item = HeaderItem.create_from_config({
		world = self._world
	}, config, self)

	self:add_item(item, "red_players")

	for _, member in ipairs(members) do
		local player = Managers.player:player(member.index)
		local name = rawget(_G, "Steam") and Steam.user_name(player:network_id()) or player:network_id()
		local config = {
			disabled = true,
			no_localization = true,
			name = name,
			text = name,
			layout_settings = self:is_friend(player) and "SquadMenuSettings.items.player_text_friend" or "SquadMenuSettings.items.player_text"
		}
		local item = HeaderItem.create_from_config({
			world = self._world
		}, config, self)

		self:add_item(item, "red_players")
	end

	self._red_players = ItemListMenuContainer.create_from_config(self._item_groups.red_players)
end

function TeamSelectionMenuPage:cb_hide_red_team()
	do return end

	local items = self:items_in_group("right_team_items")

	for _, item in pairs(items) do
		item.config.visible = true
	end

	self._red_players = nil

	self:remove_items("red_players")
end

function TeamSelectionMenuPage:cb_show_white_team()
	do return end

	local items = self:items_in_group("left_team_items")

	for _, item in pairs(items) do
		item.config.visible = false
	end

	local white_team = Managers.state.team:team_by_name("white")
	local members = white_team.members
	local config = {
		name = "header",
		layout_settings = "SquadMenuSettings.items.player_text_header",
		disabled = true,
		no_localization = true,
		text = #members .. " " .. L("menu_team_players")
	}
	local item = HeaderItem.create_from_config({
		world = self._world
	}, config, self)

	self:add_item(item, "white_players")

	local tmep = 0

	for _, member in ipairs(members) do
		local player = Managers.player:player(member.index)
		local name = rawget(_G, "Steam") and Steam.user_name(player:network_id()) or player:network_id()
		local config = {
			disabled = true,
			no_localization = true,
			name = name,
			text = name,
			layout_settings = self:is_friend(player) and "SquadMenuSettings.items.player_text_friend" or "SquadMenuSettings.items.player_text"
		}
		local item = HeaderItem.create_from_config({
			world = self._world
		}, config, self)

		self:add_item(item, "white_players")
	end

	self._white_players = ItemListMenuContainer.create_from_config(self._item_groups.white_players)
end

function TeamSelectionMenuPage:cb_hide_white_team()
	do return end

	local items = self:items_in_group("left_team_items")

	for _, item in pairs(items) do
		item.config.visible = true
	end

	self._white_players = nil

	self:remove_items("white_players")
end

function TeamSelectionMenuPage:cb_team_color()
	if self._white_players then
		return {
			255,
			255,
			128,
			0
		}
	else
		return {
			255,
			87,
			163,
			199
		}
	end
end

function TeamSelectionMenuPage:cb_auto_join_team()
	local red_verified = Managers.state.team:verify_join_team(self._local_player, "red")
	local white_verified = Managers.state.team:verify_join_team(self._local_player, "white")
	local join_team

	if red_verified and white_verified then
		join_team = Math.random(1, 2) == 1 and "red" or "white"
	elseif red_verified then
		join_team = "red"
	elseif white_verified then
		join_team = "white"
	end

	if join_team then
		Managers.state.team:request_join_team(self._local_player, join_team)

		self._joining_team = true
	end
end

function TeamSelectionMenuPage:_auto_highlight_first_item()
	return
end

function TeamSelectionMenuPage:cb_auto_join_team_disabled()
	return self._joining_team
end

function TeamSelectionMenuPage:cb_page_name()
	return self.config.name or "No name specified"
end

function TeamSelectionMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "team_selection",
		name = page_config.name,
		parent_page = parent_page,
		callback_object = callback_object,
		z = page_config.z,
		on_enter_page = page_config.on_enter_page,
		on_enter_page_args = page_config.on_enter_page_args,
		do_not_select_first_index = page_config.do_not_select_first_index,
		layout_settings = page_config.layout_settings,
		local_player = compiler_data.menu_data.local_player,
		on_enter_highlight_item = page_config.on_enter_highlight_item,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return TeamSelectionMenuPage:new(config, item_groups, compiler_data.world)
end
