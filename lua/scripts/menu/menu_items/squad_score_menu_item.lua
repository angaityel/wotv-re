-- chunkname: @scripts/menu/menu_items/squad_score_menu_item.lua

require("scripts/menu/menu_items/menu_item")

SquadScoreMenuItem = class(SquadScoreMenuItem, MenuItem)

function SquadScoreMenuItem:init(config, world)
	SquadScoreMenuItem.super.init(self, config, world)

	self._expanded = self.config.expand

	self:_sort_squads()
end

function SquadScoreMenuItem:_sort_squads()
	self._squad_score = 0
	self._squad_kills = 0
	self._squad_deaths = 0
	self._squad_assists = 0
	self._squad_average_level = 0
	self._player_items = {}

	local config = self.config
	local page = config.page
	local group_name = config.team_name .. "_" .. config.squad_index .. "_player_items"

	if group_name then
		if page:items_in_group(group_name) then
			page:remove_items(group_name)
		else
			page:add_item_group(group_name)
		end
	end

	local player_count = 0

	if config.squad.players then
		for player_id, player in pairs(self.config.squad.players) do
			self._squad_score = self._squad_score + player.stats:get(player.network_id, "score_round")
			self._squad_kills = self._squad_kills + player.stats:get(player.network_id, "enemy_kills")
			self._squad_deaths = self._squad_deaths + player.stats:get(player.network_id, "deaths")
			self._squad_assists = self._squad_assists + player.stats:get(player.network_id, "assists")
			self._squad_average_level = self._squad_average_level + player.stats:get(player.network_id, "rank")
			self._expanded = self._expanded or player.is_player

			local drop_down_list_item_groups = {
				items = {}
			}
			local drop_down_list_config = {
				show_revision = false,
				on_enter_options = "cb_player_options",
				on_option_changed = "cb_player_option_changed",
				z = 200,
				on_option_changed_args = {
					player = player
				},
				layout_settings = BattleReportSettings.pages.player_options_drop_down_list,
				sounds = config.sounds
			}
			local drop_down_list_page = DropDownListMenuPage.create_from_config({
				world = self._world
			}, drop_down_list_config, page, drop_down_list_item_groups, self)
			local player_count = #self._player_items + 1
			local player_item_config = {
				on_highlight = "cb_update_player_details",
				layout_settings = "BattleReportSettings.items.player_score",
				name = config.team_name .. config.squad_index .. "_player_" .. player_count,
				player = player,
				local_team = config.local_team,
				sounds = config.sounds,
				page = drop_down_list_page,
				on_highlight_args = {
					player
				}
			}
			local player_item = PlayerScoreboardMenuItem.create_from_config({
				world = self._world
			}, player_item_config, self.config.page)

			self._player_items[player_count] = player_item

			page:add_item(player_item, group_name)
		end
	end

	self._squad_score = math.floor(self._squad_score + 0.5)

	if player_count > 0 then
		self._squad_average_level = self._squad_average_level / player_count
		self._squad_average_level = math.floor(self._squad_average_level + 0.5)
	end

	local function sort_function(item1, item2)
		local player1 = item1.config.player
		local player2 = item2.config.player
		local score1 = player1.stats:get(player1.network_id, "score_round")
		local score2 = player2.stats:get(player2.network_id, "score_round")

		if score1 ~= score2 then
			return score2 < score1
		else
			return player1.player_name < player2.player_name
		end
	end

	table.sort(self._player_items, sort_function)
end

function SquadScoreMenuItem:add_player(player)
	local network_id = player.network_id

	self.config.squad.players[network_id] = player

	self:_sort_squads()
end

function SquadScoreMenuItem:remove_player(player)
	local network_id = player.network_id

	self.config.squad.players[network_id] = nil

	self:_sort_squads()
end

function SquadScoreMenuItem:update_size(dt, t, gui, layout_settings)
	local height = layout_settings.item_height

	for _, player_item in ipairs(self._player_items) do
		local item_layout_settings = MenuHelper:layout_settings(player_item.config.layout_settings)
		local width = self._width - layout_settings.padding_left - layout_settings.padding_right

		player_item:update_size(dt, t, gui, item_layout_settings, width)

		local item_height = player_item:height() + (layout_settings.player_padding or 0)

		height = self._expanded and height + item_height or height
	end

	self._height = height + (layout_settings.padding or 0)
	self._width = self:_try_callback(self.config.callback_object, "width")
end

function SquadScoreMenuItem:update_position(dt, t, layout_settings, x, y, z, parent_y)
	self._x = x + layout_settings.padding_left
	self._y = y - layout_settings.item_height
	self._z = z + (layout_settings.z or 0)
	self._parent_y = parent_y

	local pos = Vector3(self._x, self._y - layout_settings.player_padding, self._z + 3)

	for idx, player_item in ipairs(self._player_items) do
		local item_layout_settings = MenuHelper:layout_settings(player_item.config.layout_settings)
		local item_x = pos[1]
		local item_y = pos[2]
		local item_z = pos[3]

		player_item:update_position(dt, t, item_layout_settings, item_x, item_y, item_z, parent_y)

		pos = pos + Vector3(0, -layout_settings.item_height - layout_settings.player_padding, 0)
	end
end

function SquadScoreMenuItem:update_input(input, gui)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if not self.config.no_header then
		self:_update_expand(input, gui, layout_settings)
	end
end

function SquadScoreMenuItem:_update_expand(input, gui, layout_settings)
	if input:get("select_left_click") and input:has("cursor") then
		local mouse_pos = input:get("cursor")
		local extents = {
			self._x - layout_settings.expand_rect_size * 0.5,
			self._y,
			self._x + self._width - layout_settings.padding_left - layout_settings.padding_right,
			self._y + layout_settings.item_height
		}

		if mouse_pos[1] >= extents[1] and mouse_pos[1] <= extents[3] and mouse_pos[2] >= extents[2] and mouse_pos[2] <= extents[4] then
			self._expanded = not self._expanded

			self:_try_callback(self.config.callback_object, "cb_update_scroll")
		end
	end
end

function SquadScoreMenuItem:render(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()

	Gui.triangle(gui, Vector3(0, 0, 0), Vector3(0, 0, h), Vector3(w, 0, 0), -1, Color(0, 0, 0, 0), "clear_mask")
	Gui.triangle(gui, Vector3(0, 0, h), Vector3(w, 0, 0), Vector3(w, 0, h), -1, Color(0, 0, 0, 0), "clear_mask")

	if #self._player_items > 0 then
		self:_render_squad_header(dt, t, gui, layout_settings)
		self:_render_players(dt, t, gui, layout_settings)
	end
end

function SquadScoreMenuItem:_render_squad_header(dt, t, gui, layout_settings)
	if self._y < self._parent_y or self.config.no_header then
		return
	end

	local header_color = self.config.lone_wolves and layout_settings.header.lone_wolves_color or layout_settings.header.color

	Gui.bitmap(gui, "rect_masked", Vector3(self._x, self._y, self._z or 0), Vector2(self._width - layout_settings.padding_left - layout_settings.padding_right, layout_settings.item_height), self:_color(header_color))
	Gui.bitmap(gui, "rect_masked", Vector3(self._x - layout_settings.expand_rect_size * 0.5, self._y + layout_settings.item_height * 0.5 - layout_settings.expand_rect_size * 0.5, (self._z or 0) + layout_settings.expand_rect_z), Vector2(layout_settings.expand_rect_size, layout_settings.expand_rect_size), self:_color(layout_settings.expand_rect_color))
	Gui.bitmap(gui, "rect_masked", Vector3(self._x - layout_settings.expand_rect_size * 0.5 - layout_settings.expand_rect_frame_size, self._y + layout_settings.item_height * 0.5 - layout_settings.expand_rect_size * 0.5 - layout_settings.expand_rect_frame_size, (self._z or 0) + layout_settings.expand_rect_z - 1), Vector2(layout_settings.expand_rect_size + layout_settings.expand_rect_frame_size * 2, layout_settings.expand_rect_size + layout_settings.expand_rect_frame_size * 2), self:_color(layout_settings.expand_rect_frame_color))

	if self._expanded then
		Gui.bitmap(gui, "rect_masked", Vector3(self._x - layout_settings.expand_rect_size * 0.5 + 2, self._y + layout_settings.item_height * 0.5 - 1, (self._z or 0) + layout_settings.expand_rect_z + 1), Vector2(layout_settings.expand_rect_size - 4, 2), self:_color(layout_settings.expand_rect_frame_color))
	else
		Gui.bitmap(gui, "rect_masked", Vector3(self._x - 1, self._y + layout_settings.item_height * 0.5 - 3, (self._z or 0) + layout_settings.expand_rect_z + 1), Vector2(2, layout_settings.expand_rect_size - 4), self:_color(layout_settings.expand_rect_frame_color))
		Gui.bitmap(gui, "rect_masked", Vector3(self._x - layout_settings.expand_rect_size * 0.5 + 2, self._y + layout_settings.item_height * 0.5 - 1, (self._z or 0) + layout_settings.expand_rect_z + 1), Vector2(layout_settings.expand_rect_size - 4, 2), self:_color(layout_settings.expand_rect_frame_color))
	end

	local width = self._width - layout_settings.padding_left - layout_settings.padding_right

	for idx, text_item in ipairs(layout_settings.header.items) do
		local text = self[text_item.text_func](self)
		local extents_x = 0

		if text_item.align == "right" then
			local min, max = Gui.text_extents(gui, text, text_item.font.font, text_item.font_size)

			extents_x = max[1] - min[1]
		end

		Gui.text(gui, text, text_item.font.font, text_item.font_size, text_item.font.material, Vector3(self._x + text_item.padding_left * width - extents_x, self._y + text_item.padding_bottom, self._z + 1), self:_color(layout_settings.header.text_color))

		if self.config.lone_wolves and idx > 0 then
			return
		end
	end
end

function SquadScoreMenuItem:_render_players(dt, t, gui, layout_settings)
	if not self._expanded then
		return
	end

	for _, player_item in ipairs(self._player_items) do
		local item_layout_settings = MenuHelper:layout_settings(player_item.config.layout_settings)

		player_item:render(dt, t, gui, item_layout_settings)
	end
end

function SquadScoreMenuItem:cb_squad_name()
	return L(self.config.squad_name or "Squad Name (" .. self.config.squad_index .. ")")
end

function SquadScoreMenuItem:cb_squad_kills()
	return self._squad_kills
end

function SquadScoreMenuItem:cb_squad_deaths()
	return self._squad_deaths
end

function SquadScoreMenuItem:cb_squad_assists()
	return self._squad_assists
end

function SquadScoreMenuItem:cb_squad_average_level()
	return self._squad_average_level
end

function SquadScoreMenuItem:cb_player_options()
	local options = {}

	options[#options + 1] = {
		key = "vote_kick",
		value = L("vote_kick")
	}

	local network_manager = Managers.state.network
	local game = network_manager:game()
	local super_admin_mode

	if game and network_manager.is_super_admin() then
		super_admin_mode = true
	end

	if super_admin_mode or self.config.local_player and self.config.local_player.rcon_admin then
		options[#options + 1] = {
			key = "rcon_kick",
			value = L("kick")
		}
		options[#options + 1] = {
			key = "rcon_ban",
			value = L("ban")
		}
	end

	return options
end

function SquadScoreMenuItem:cb_player_option_changed(option, args)
	local local_player = self.config.local_player
	local player_to_kick = args.player
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if option.key == "vote_kick" then
		local network_manager = Managers.state.network
		local game = network_manager:game()

		if game then
			network_manager:send_rpc_server("rpc_vote_kick", player_to_kick.network_id, local_player:player_id())
		end
	elseif option.key == "rcon_kick" then
		local rcon_command = "/kick_player " .. player_to_kick.network_id

		Managers.state.hud:output_console_text(sprintf("[rcon]: ***** %s", rcon_command))
		Managers.state.network:send_rpc_server("rpc_rcon", "", rcon_command)
	elseif option.key == "rcon_ban" then
		local rcon_command = "/ban_player " .. player_to_kick.network_id

		Managers.state.hud:output_console_text(sprintf("[rcon]: ***** %s", rcon_command))
		Managers.state.network:send_rpc_server("rpc_rcon", "", rcon_command)
	end
end

function SquadScoreMenuItem:score()
	if self.config.lone_wolves then
		return -math.huge
	end

	return self._squad_score
end

function SquadScoreMenuItem:_color(c)
	return Color(c[1], c[2], c[3], c[4])
end

function SquadScoreMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "squad_score",
		page = config.page,
		name = config.name,
		squad_name = config.squad_name,
		callback_object = callback_object,
		lone_wolves = config.lone_wolves,
		squad = config.squad_data,
		expand = config.expand,
		squad_index = config.squad_index,
		local_team = config.local_team,
		team_name = config.team_name,
		layout_settings = config.layout_settings,
		no_header = config.no_header,
		sounds = config.sounds,
		local_player = config.local_player
	}

	return SquadScoreMenuItem:new(config, compiler_data.world)
end
