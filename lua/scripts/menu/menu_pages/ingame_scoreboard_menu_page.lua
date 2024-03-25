-- chunkname: @scripts/menu/menu_pages/ingame_scoreboard_menu_page.lua

require("scripts/menu/menu_containers/item_grid_menu_container")
require("scripts/menu/menu_containers/stat_grid_menu_container")
require("scripts/menu/menu_items/team_scoreboard_menu_item")

IngameScoreboardMenuPage = class(IngameScoreboardMenuPage, BattleReportScoreboardMenuPage)

function IngameScoreboardMenuPage:init(config, item_groups, world)
	MenuPage.init(self, config, item_groups, world)

	self.config.stats_collection = Managers.state.stats_collection
	self._world = world
	self._local_player_index = config.local_player_index
	self.config.players = {}

	for player_index, player in pairs(Managers.player:players()) do
		self.config.players[player_index] = self:_create_player_item(player)
	end

	self:_setup_scoreboards(config.stats_collection, config.players, config.local_player_index, true)

	self._header_items = ItemGridMenuContainer.create_from_config(item_groups.header_items)
	self._player_details = StatGridMenuContainer.create_from_config(item_groups.player_details)

	Managers.state.event:register(self, "player_joined_squad", "event_player_joined_squad")
	Managers.state.event:register(self, "player_left_squad", "event_player_left_squad")
	Managers.state.event:register(self, "player_joined_team", "event_player_joined_team")
	Managers.state.event:register(self, "player_left_team", "event_player_left_team")
end

function IngameScoreboardMenuPage:event_rebuild_scoreboard()
	self.config.stats_collection = Managers.state.stats_collection
	self.config.players = {}

	for player_index, player in pairs(Managers.player:players()) do
		self.config.players[player_index] = self:_create_player_item(player)
	end

	self:_setup_scoreboards(self.config.stats_collection, self.config.players, self.config.local_player_index, true)
end

function IngameScoreboardMenuPage:event_player_joined_team(player)
	if player.team and player.team.name ~= "unassigned" then
		local player_item = self:_create_player_item(player)

		self.config.players[player.index] = player_item

		self:_add_player_to_team(player_item)
	end
end

function IngameScoreboardMenuPage:event_player_left_team(player)
	local player_item = self:_create_player_item(player)

	self:_remove_player_from_team(player_item)
end

function IngameScoreboardMenuPage:event_player_left_squad(player, squad_index)
	local player_item = self:_create_player_item(player)

	self:_remove_player_from_squad(player_item, squad_index)
end

function IngameScoreboardMenuPage:event_player_joined_squad(player, squad_index)
	local player_item = self:_create_player_item(player)

	self:_add_player_to_squad(player_item, squad_index)
end

function IngameScoreboardMenuPage:on_enter(on_cancel)
	MenuPage.on_enter(self, on_cancel)

	self._w = nil
	self._h = nil

	self:event_rebuild_scoreboard()
end

function IngameScoreboardMenuPage:_update_container_size(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._player_details:update_size(dt, t, self._gui, layout_settings.player_details)
	self._header_items:update_size(dt, t, self._gui, layout_settings.header_items)
end

function IngameScoreboardMenuPage:_update_container_position(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._header_items, layout_settings.header_items)

	self._header_items:update_position(dt, t, layout_settings.header_items, x, y, self.config.z + 20)
end

function IngameScoreboardMenuPage:_update_input(input)
	IngameScoreboardMenuPage.super._update_input(self, input)
end

function IngameScoreboardMenuPage:update(dt, t)
	MenuPage.update(self, dt, t)
	self:_update_container_size(dt, t)
	self:_update_container_position(dt, t)
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

function IngameScoreboardMenuPage:render(dt, t)
	MenuPage.render(self, dt, t)

	local countdown_item = self:find_item_by_name("countdown")

	countdown_item.config.text = Managers.state.game_mode:hud_timer_text()

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local layout_settings_left = MenuHelper:layout_settings(self._left_team_scoreboard.config.layout_settings)
	local layout_settings_right = MenuHelper:layout_settings(self._right_team_scoreboard.config.layout_settings)

	self._left_team_scoreboard:render(dt, t, self._gui, layout_settings_left)
	self._right_team_scoreboard:render(dt, t, self._gui, layout_settings_right)
	self._player_details:render(dt, t, self._gui, layout_settings.player_details)
	self._header_items:render(dt, t, self._gui, layout_settings.header_items)
end

function IngameScoreboardMenuPage:on_exit(on_cancel)
	MenuPage.on_exit(self, on_cancel)
end

function IngameScoreboardMenuPage:cb_my_team_score()
	local team_name = self.config.players[self._local_player_index].team_name or "red"

	if team_name == "unassigned" then
		team_name = "red"
	end

	local team = Managers.state.team:team_by_name(team_name)
	local score = team.score

	return score
end

function IngameScoreboardMenuPage:cb_other_team_score()
	local team_name = self.config.players[self._local_player_index].team_name or "red"

	if team_name == "unassigned" then
		team_name = "red"
	end

	local other_team_name = team_name == "red" and "white" or "red"
	local team = Managers.state.team:team_by_name(other_team_name)
	local score = team.score

	return score
end

function IngameScoreboardMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "ingame_scoreboard",
		red_team_score = 0,
		white_team_score = 0,
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_page = page_config.on_enter_page,
		on_exit_page = page_config.on_exit_page,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		music_events = page_config.music_events,
		local_player_index = compiler_data.menu_data.local_player.index,
		local_player = compiler_data.menu_data.local_player,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return IngameScoreboardMenuPage:new(config, item_groups, compiler_data.world)
end
