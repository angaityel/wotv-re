-- chunkname: @scripts/menu/menu_items/team_scoreboard_menu_item.lua

require("scripts/menu/menu_items/menu_item")
require("scripts/menu/menu_items/squad_score_menu_item")

TeamScoreboardMenuItem = class(TeamScoreboardMenuItem, MenuItem)

function TeamScoreboardMenuItem:init(config, world)
	TeamScoreboardMenuItem.super.init(self, config, world)

	self._squads = config.squads
	self._lone_wolves = config.lone_wolves or {
		players = {}
	}
	self._current_scroll_offset = 0
	self._scroll_offset_amount = 0
	self._render_mode = "normal"

	self:_setup_squad_items()
end

function TeamScoreboardMenuItem:_setup_squad_items()
	self._squad_items = {}

	if self._squads then
		for squad_index, squad in pairs(self._squads) do
			local config = {
				page = self.config.page,
				squad_index = squad_index,
				squad_data = squad,
				expand = self.config.expand_all,
				squad_name = squad.name,
				local_team = self.config.local_team,
				team_name = self.config.team_name,
				sounds = self.config.sounds,
				local_player = self.config.local_player,
				layout_settings = BattleReportSettings.items.squad_score
			}

			self._squad_items[#self._squad_items + 1] = SquadScoreMenuItem.create_from_config({
				world = self._world
			}, config, self)
		end
	end

	if self._lone_wolves then
		local config = {
			lone_wolves = true,
			squad_name = "scoreboard_no_squad",
			squad_index = 0,
			page = self.config.page,
			squad_data = self._lone_wolves,
			expand = self.config.expand_all,
			local_team = self.config.local_team,
			team_name = self.config.team_name,
			sounds = self.config.sounds,
			local_player = self.config.local_player,
			layout_settings = BattleReportSettings.items.squad_score
		}

		self._squad_items[#self._squad_items + 1] = SquadScoreMenuItem.create_from_config({
			world = self._world
		}, config, self)
	end

	self:_sort_squads()
	self:_setup_normal_mode_squad()
end

function TeamScoreboardMenuItem:_sort_squads()
	local function sort_function(item1, item2)
		if item1:score() ~= item2:score() then
			return item1:score() > item2:score()
		else
			return item1:cb_squad_name() > item2:cb_squad_name()
		end
	end

	table.sort(self._squad_items, sort_function)
end

function TeamScoreboardMenuItem:_setup_normal_mode_squad()
	local data = {
		players = {}
	}

	if self._squads then
		for _, squad in pairs(self._squads) do
			local players = squad.players

			for player_id, player in pairs(players) do
				data.players[player_id] = player
			end
		end
	end

	if self._lone_wolves then
		local players = self._lone_wolves.players

		for player_id, player in pairs(players) do
			data.players[player_id] = player
		end
	end

	if false then
		for i = 1, 25 do
			for player_id, player in pairs(self._lone_wolves.players) do
				data.players[i] = player
			end
		end
	end

	local config = {
		no_header = true,
		layout_settings = "BattleReportSettings.items.squad_score",
		squad_index = -1,
		expand = true,
		page = self.config.page,
		squad_data = data,
		local_team = self.config.local_team,
		team_name = self.config.team_name,
		sounds = self.config.sounds,
		local_player = self.config.local_player
	}

	self._normal_mode_squad = SquadScoreMenuItem.create_from_config({
		world = self._world
	}, config, self)
end

function TeamScoreboardMenuItem:set_render_mode(render_mode)
	self._render_mode = render_mode
end

function TeamScoreboardMenuItem:render_mode()
	return self._render_mode
end

function TeamScoreboardMenuItem:add_player_to_team(player)
	local lone_wolf_squad = self:_lone_wolf_squad() or self:_create_squad(0, "scoreboard_no_squad", nil, true)

	lone_wolf_squad:add_player(player)
	self._normal_mode_squad:add_player(player)
end

function TeamScoreboardMenuItem:remove_player_from_team(player)
	local squad_index = player.squad_index
	local squad = squad_index and self:_squad_from_index(squad_index) or self:_lone_wolf_squad()

	squad:remove_player(player)
	self._normal_mode_squad:remove_player(player)
end

function TeamScoreboardMenuItem:add_player_to_squad(player, squad_index)
	local squad = self:_squad_from_index(squad_index) or self:_create_squad(squad_index, player.squad_name)

	squad:add_player(player)

	local lone_wolf_squad = self:_lone_wolf_squad()

	if lone_wolf_squad then
		lone_wolf_squad:remove_player(player)
	end
end

function TeamScoreboardMenuItem:remove_player_from_squad(player, squad_index)
	local squad = self:_squad_from_index(squad_index) or self:_create_squad(squad_index, player.squad_name)

	squad:remove_player(player)

	local lone_wolf_squad = self:_lone_wolf_squad() or self:_create_squad(0, "scoreboard_no_squad", nil, true)

	lone_wolf_squad:add_player(player)
end

function TeamScoreboardMenuItem:_lone_wolf_squad()
	if self._squad_items then
		for _, squad_item in ipairs(self._squad_items) do
			if squad_item.config.lone_wolves then
				return squad_item
			end
		end
	end
end

function TeamScoreboardMenuItem:_squad_from_index(squad_index)
	if self._squad_items then
		for _, squad_item in ipairs(self._squad_items) do
			if squad_item.config.squad_index == squad_index then
				return squad_item
			end
		end
	end
end

function TeamScoreboardMenuItem:_create_squad(squad_index, squad_name, squad_data, lone_wolf_squad)
	local config = {
		page = self.config.page,
		squad_index = squad_index,
		squad_data = squad_data or {
			players = {}
		},
		expand = self.config.expand_all,
		squad_name = squad_name,
		local_team = self.config.local_team,
		team_name = self.config.team_name,
		sounds = self.config.sounds,
		local_player = self.config.local_player,
		layout_settings = BattleReportSettings.items.squad_score,
		lone_wolves = lone_wolf_squad
	}
	local squad = SquadScoreMenuItem.create_from_config({
		world = self._world
	}, config, self)

	self._squad_items[#self._squad_items + 1] = squad

	self:_sort_squads()

	return squad
end

function TeamScoreboardMenuItem:update_size(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()

	self._width = w * (layout_settings.screen_width or 0) + (layout_settings.width or 0)
	self._height = h * (layout_settings.screen_height or 0) + (layout_settings.height or 0)

	if self._render_mode == "normal" then
		self:_update_size_normal(dt, t, gui, layout_settings)
	elseif self._render_mode == "squads" then
		self:_update_size_squads(dt, t, gui, layout_settings)
	else
		ferror("[TeamScoreboardMenuItem] Render mode not supported: %q", self._render_mode)
	end
end

function TeamScoreboardMenuItem:_update_size_normal(dt, t, gui, layout_settings)
	self._squad_items_height = 0

	local squad = self._normal_mode_squad
	local layout_settings = MenuHelper:layout_settings(squad.config.layout_settings)

	squad:update_size(dt, t, gui, layout_settings)

	self._squad_items_height = squad:height()
end

function TeamScoreboardMenuItem:_update_size_squads(dt, t, gui, layout_settings)
	if self._squad_items then
		self._squad_items_height = 0

		for _, squad_item in ipairs(self._squad_items) do
			local layout_settings = MenuHelper:layout_settings(squad_item.config.layout_settings)

			squad_item:update_size(dt, t, gui, layout_settings)

			self._squad_items_height = self._squad_items_height + squad_item:height()
		end
	end
end

function TeamScoreboardMenuItem:update_position(dt, t, layout_settings, x, y, z)
	local diff = self._current_scroll_offset - self._scroll_offset_amount

	self._current_scroll_offset = self._current_scroll_offset - diff * dt * 5
	self._x = x
	self._y = y
	self._z = layout_settings.z + (z or 0)

	if self._render_mode == "normal" then
		self:_update_position_normal(dt, t, layout_settings, x, y, z)
	elseif self._render_mode == "squads" then
		self:_update_position_squads(dt, t, layout_settings, x, y, z)
	else
		ferror("[TeamScoreboardMenuItem] Render mode not supported: %q", self._render_mode)
	end
end

function TeamScoreboardMenuItem:_update_position_normal(dt, t, layout_settings, x, y, z)
	local squad = self._normal_mode_squad
	local item_y = self._y + self._height - layout_settings.padding_top + self._current_scroll_offset
	local layout_settings = MenuHelper:layout_settings(squad.config.layout_settings)

	squad:update_position(dt, t, layout_settings, self._x, item_y, self._z, self._y)
end

function TeamScoreboardMenuItem:_update_position_squads(dt, t, layout_settings, x, y, z)
	local item_y = self._y + self._height - layout_settings.padding_top + self._current_scroll_offset

	if self._squad_items then
		for _, squad_item in ipairs(self._squad_items) do
			local layout_settings = MenuHelper:layout_settings(squad_item.config.layout_settings)

			squad_item:update_position(dt, t, layout_settings, self._x, item_y, self._z, self._y)

			item_y = item_y - squad_item:height()
		end
	end

	self._lone_wolves_start_y = item_y
end

function TeamScoreboardMenuItem:render(dt, t, gui, layout_settings)
	if self._render_mode == "normal" then
		self:_render_normal_mode(dt, t, gui, layout_settings)
	elseif self._render_mode == "squads" then
		self:_render_squads_mode(dt, t, gui, layout_settings)
	else
		ferror("[TeamScoreboardMenuItem] Render mode not supported: %q", self._render_mode)
	end
end

function TeamScoreboardMenuItem:_render_normal_mode(dt, t, gui, layout_settings)
	self:_render_masks(dt, t, gui, layout_settings)
	self:_render_header(dt, t, gui, layout_settings)
	self:_render_background(dt, t, gui, layout_settings)
	self:_render_normal_mode_squad(dt, t, gui, layout_settings)
	self:_render_scrollbar(dt, t, gui, layout_settings)
end

function TeamScoreboardMenuItem:_render_squads_mode(dt, t, gui, layout_settings)
	self:_render_masks(dt, t, gui, layout_settings)
	self:_render_header(dt, t, gui, layout_settings)
	self:_render_background(dt, t, gui, layout_settings)
	self:_render_scoreboards(dt, t, gui, layout_settings)
	self:_render_scrollbar(dt, t, gui, layout_settings)
end

function TeamScoreboardMenuItem:_render_scrollbar(dt, t, gui, layout_settings)
	if self._squad_items then
		local max_value = math.max(self._squad_items_height - (self._height - layout_settings.padding_top - layout_settings.padding_top), 0)

		if max_value > 0 then
			local height = self._height - layout_settings.padding_top * 2
			local base_pos = Vector3(self._x + self._width - layout_settings.scrollbar_offset_x, self._y + layout_settings.padding_top, self._z + 10)

			Gui.rect(gui, base_pos, Vector2(layout_settings.scrollbar_line_width, height), Color(192, 128, 128, 128))

			local current_percentage = self._current_scroll_offset / max_value
			local scroller_height = layout_settings.scroller_height * height
			local current_offset = math.clamp((height - scroller_height) * current_percentage, 0, height - scroller_height)
			local base_pos = base_pos + Vector3(-math.floor(layout_settings.scroller_width * 0.5), height - scroller_height - current_offset, 1)

			Gui.rect(gui, base_pos, Vector2(layout_settings.scroller_width, layout_settings.scroller_height * (self._height - layout_settings.padding_top * 2)), Color(255, 192, 192, 192))
		end
	end
end

function TeamScoreboardMenuItem:_render_scoreboards(dt, t, gui, layout_settings)
	if self._squad_items then
		for _, squad_item in ipairs(self._squad_items) do
			local layout_settings = MenuHelper:layout_settings(squad_item.config.layout_settings)

			squad_item:render(dt, t, gui, layout_settings)
		end
	end
end

function TeamScoreboardMenuItem:_render_normal_mode_squad(dt, t, gui, layout_settings)
	local squad = self._normal_mode_squad
	local layout_settings = MenuHelper:layout_settings(squad.config.layout_settings)

	squad:render(dt, t, gui, layout_settings)
end

function TeamScoreboardMenuItem:_render_masks(dt, t, gui, layout_settings)
	local pos = Vector3(self._x, self._y, self._z)
	local w, h = Gui.resolution()

	Gui.bitmap(gui, "mask_rect", Vector3(pos[1], self._y, pos[3]), Vector2(self._width, layout_settings.padding_top), Color(0, 0, 0, 0))
	Gui.bitmap(gui, "mask_rect", pos + Vector3(0, self._height - layout_settings.padding_top, 0), Vector2(self._width, h), Color(0, 0, 0, 0))
end

function TeamScoreboardMenuItem:_render_header(dt, t, gui, layout_settings)
	local base_pos = Vector3(self._x, self._y + self._height, self._z)

	if layout_settings.header then
		for _, header_data in pairs(layout_settings.header) do
			local pos = base_pos + Vector3(header_data.padding_left * self._width, header_data.padding_top, 2)
			local text = header_data.text and L(header_data.text) or self[header_data.text_func](self)
			local extents_x = 0

			if header_data.align == "right" then
				local min, max = Gui.text_extents(gui, text, header_data.font.font, header_data.font_size)

				extents_x = max[1] - min[1]
			end

			Gui.text(gui, text, header_data.font.font, header_data.font_size, header_data.font.material, pos + Vector3(-extents_x, 0, 0), self:_team_color())
			Gui.text(gui, text, header_data.font.font, header_data.font_size, header_data.font.material, pos + Vector3(2 - extents_x, -2, -1), Color(255, 0, 0, 0))
		end
	end
end

function TeamScoreboardMenuItem:_team_color()
	local team_name = self.config.team_name

	if team_name == "red" then
		return Color(255, 200, 200, 255)
	else
		return Color(255, 255, 128, 0)
	end
end

function TeamScoreboardMenuItem:update_mouse_inside(position, value)
	if math.abs(value) > 0 then
		local extents = {
			self._x,
			self._y,
			self._x + self._width,
			self._y + self._height
		}

		if position[1] > extents[1] and position[1] < extents[3] and position[2] > extents[2] and position[2] < extents[4] then
			local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

			self._scroll_offset_amount = math.clamp(self._scroll_offset_amount - value * 50, 0, math.max(self._squad_items_height - (self._height - layout_settings.padding_top - layout_settings.padding_top), 0))
		end
	end
end

function TeamScoreboardMenuItem:update_pad_inside(value)
	if self._squad_items_height and value and math.abs(value) > 0 then
		local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

		self._scroll_offset_amount = math.clamp(self._scroll_offset_amount - value * 50, 0, math.max(self._squad_items_height - (self._height - layout_settings.padding_top - layout_settings.padding_top), 0))
	end
end

function TeamScoreboardMenuItem:cb_update_scroll()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:update_size(0, 0, nil, layout_settings)

	self._scroll_offset_amount = math.clamp(self._scroll_offset_amount, 0, math.max(self._squad_items_height - (self._height - layout_settings.padding_top - layout_settings.padding_top), 0))
end

function TeamScoreboardMenuItem:update_item_input(input, gui)
	if not self._squad_items then
		return
	end

	if self._render_mode == "normal" then
		self._normal_mode_squad:update_input(input, gui)
	elseif self._render_mode == "squads" then
		for _, squad in pairs(self._squad_items) do
			squad:update_input(input, gui)
		end
	end
end

function TeamScoreboardMenuItem:cb_team_name()
	return self.config.team_name == "red" and L("lancastrians") or L("yorkists")
end

function TeamScoreboardMenuItem:cb_show_ping()
	if Managers.state.network.game then
		return L("menu_ping_lower")
	else
		return ""
	end
end

function TeamScoreboardMenuItem:_render_background(dt, t, gui, layout_settings)
	local pos = Vector3(self._x, self._y, self._z)
	local size = Vector2(self._width, self._height)

	Gui.rect(gui, pos, size, Color(192, 0, 0, 0))
	Gui.bitmap(gui, "mask_rect_alpha", pos + Vector3(0, layout_settings.padding_top, 0), size + Vector2(0, -layout_settings.padding_top * 2), Color(255, 0, 0, 0))
	self:_try_callback(self.config.callback_object, "cb_render_border", gui, {
		pos[1],
		pos[2],
		size[1],
		size[2]
	}, 2, Color(0, 0, 0), 1)
end

function TeamScoreboardMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "team_scoreboard",
		page = config.page,
		callback_object = callback_object,
		layout_settings = config.layout_settings,
		team_name = config.team_name,
		sounds = config.sounds,
		local_team = config.local_team,
		squads = config.squads,
		expand_all = config.expand_all,
		lone_wolves = config.lone_wolves,
		local_player = config.local_player
	}

	return TeamScoreboardMenuItem:new(config, compiler_data.world)
end
