-- chunkname: @scripts/menu/menu_items/player_scoreboard_menu_item.lua

require("scripts/menu/menu_items/menu_item")

PlayerScoreboardMenuItem = class(PlayerScoreboardMenuItem, MenuItem)

function PlayerScoreboardMenuItem:init(config, world)
	PlayerScoreboardMenuItem.super.init(self, config, world)
end

function PlayerScoreboardMenuItem:update_size(dt, t, gui, layout_settings, width)
	self._width = width
	self._height = layout_settings.item_height
end

function PlayerScoreboardMenuItem:update_position(dt, t, layout_settings, x, y, z, parent_y)
	self._parent_y = parent_y
	self._x = x
	self._y = y
	self._z = z
end

function PlayerScoreboardMenuItem:render(dt, t, gui, layout_settings)
	for _, item in pairs(layout_settings.items) do
		if item.text_func then
			self:_render_text(dt, t, gui, layout_settings, item)
		elseif item.bitmap_ex_func then
			self:_render_bitmap_ex(dt, t, gui, layout_settings, item)
		end
	end
end

function PlayerScoreboardMenuItem:_render_text(dt, t, gui, layout_settings, item)
	local player = self.config.player
	local pos = Vector3(self._x, self._y, self._z)
	local width = self._width
	local text = self[item.text_func](self, player)

	if item.crop_text then
		text = HUDHelper:crop_text(gui, text, item.font.font, item.font_size, item.max_text_width, "...")
	end

	local extents_x = 0
	local min, max = Gui.text_extents(gui, text, item.font.font, item.font_size)
	local extents_y = max[3] - min[3]

	if item.align == "right" then
		extents_x = max[1] - min[1]
	end

	local text_pos = Vector3(pos[1] + item.padding_left * width - extents_x, pos[2] + layout_settings.item_padding_bottom + self._height * 0.5 - extents_y * 0.7, pos[3] + 1)

	if text_pos[2] < self._parent_y + layout_settings.player_padding then
		return
	end

	if player.is_player then
		local text_color = self[item.local_text_color_func](self, player)

		if self._highlighted then
			Gui.text(gui, text, item.font.font, item.font_size, item.font.material, text_pos, Color(0, 0, 0))
			Gui.bitmap(gui, "rect_masked", pos + Vector3(0, layout_settings.item_padding_bottom - layout_settings.player_padding, 0), Vector2(self._width, layout_settings.item_height), Color(255, 255, 255))
		else
			Gui.text(gui, text, item.font.font, item.font_size, item.font.material, text_pos, self:_color(text_color))
			Gui.text(gui, text, item.font.font, item.font_size, item.font.material, Vector3(pos[1] + item.padding_left * width + 2 - extents_x, pos[2] + layout_settings.item_padding_bottom - 2, pos[3]), self:_color(item.shadow_color))
			Gui.bitmap(gui, "rect_masked", pos + Vector3(0, layout_settings.item_padding_bottom - layout_settings.player_padding, 0), Vector2(self._width, layout_settings.item_height), Color(0, 0, 0))
		end
	elseif self._highlighted then
		Gui.bitmap(gui, "rect_masked", pos + Vector3(0, layout_settings.item_padding_bottom - layout_settings.player_padding, 0), Vector2(self._width, layout_settings.item_height), Color(255, 255, 255))
		Gui.text(gui, text, item.font.font, item.font_size, item.font.material, text_pos, Color(0, 0, 0))
	else
		Gui.text(gui, text, item.font.font, item.font_size, item.font.material, text_pos, self:_color(item.text_color))
		Gui.text(gui, text, item.font.font, item.font_size, item.font.material, Vector3(pos[1] + item.padding_left * width + 2 - extents_x, pos[2] + layout_settings.item_padding_bottom - 2, pos[3]), self:_color(item.shadow_color))
	end
end

function PlayerScoreboardMenuItem:is_mouse_inside(mouse_x, mouse_y)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x1 = self._x
	local y1 = self._y - layout_settings.player_padding + layout_settings.item_padding_bottom
	local x2 = x1 + self._width
	local y2 = y1 + self._height

	return x1 <= mouse_x and mouse_x <= x2 and y1 <= mouse_y and mouse_y <= y2
end

function PlayerScoreboardMenuItem:_render_bitmap_ex(dt, t, gui, layout_settings, item)
	local player = self.config.player
	local pos = Vector3(self._x, self._y, self._z)
	local width = self._width
	local image_atlas, image_texture, image_material, image_size = self[item.bitmap_ex_func](self, item, player)

	if not image_atlas then
		return
	end

	local image_pos = Vector3(pos[1] + item.padding_left * width - image_size.x / 2, pos[2] + layout_settings.item_padding_bottom + self._height * 0.5 - image_size.y * 0.7, pos[3] + 1)

	if image_pos[2] < self._parent_y + layout_settings.player_padding then
		return
	end

	local material_table = HUDHelper.atlas_texture_settings(image_atlas, image_texture)
	local uv00 = material_table.uv00
	local uv11 = material_table.uv11

	Gui.bitmap_uv(gui, image_material, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), image_pos, image_size, Color(255, 255, 255, 255))
end

function PlayerScoreboardMenuItem:cb_empty_string()
	return ""
end

function PlayerScoreboardMenuItem:cb_player_name(item)
	return item.player_name
end

function PlayerScoreboardMenuItem:cb_player_score(item)
	return math.floor(item.stats:get(item.network_id, "score_round") + 0.5)
end

function PlayerScoreboardMenuItem:cb_player_kills(item)
	return item.stats:get(item.network_id, "enemy_kills")
end

function PlayerScoreboardMenuItem:cb_player_deaths(item)
	return item.stats:get(item.network_id, "deaths")
end

function PlayerScoreboardMenuItem:cb_player_assists(item)
	return item.stats:get(item.network_id, "assists")
end

function PlayerScoreboardMenuItem:cb_player_level(item)
	return item.stats:get(item.network_id, "rank")
end

function PlayerScoreboardMenuItem:cb_local_player_color(item)
	return item.team_name == "red" and {
		255,
		200,
		200,
		255
	} or {
		255,
		255,
		128,
		0
	}
end

function PlayerScoreboardMenuItem:cb_player_ping(item)
	if not Managers.state.network.game then
		return ""
	end

	local ping = "?"
	local game = Managers.state.network:game()
	local game_object_id = item.player_game_object_id

	if game and game_object_id then
		if GameSession.game_object_exists(game, game_object_id) then
			ping = GameSession.game_object_field(game, game_object_id, "ping")
		else
			print("[ScoreboardPlayerMenuItem] Game object does not exist! game_object_id:", game_object_id)
		end
	end

	return ping
end

function PlayerScoreboardMenuItem:cb_player_is_dead(item, player)
	local item_player = Managers.player:player_from_network_id(player.network_id)

	if not item_player then
		return nil, nil, nil
	end

	local local_client_team = self.config.local_team
	local item_player_team = item_player.team.name
	local allow_ghost_talking = Managers.state.game_mode:allow_ghost_talking()
	local show_enemy_info = allow_ghost_talking or item_player_team == local_client_team

	if show_enemy_info and (Unit.alive(item_player.player_unit) == false or ScriptUnit.extension(item_player.player_unit, "damage_system"):is_dead()) then
		return item.bitmap_ex_atlas, item.bitmap_ex_texture, item.bitmap_ex_material, Vector2(item.bitmap_size[1], item.bitmap_size[2])
	end

	return nil, nil, nil
end

function PlayerScoreboardMenuItem:_color(c)
	return Color(c[1], c[2], c[3], c[4])
end

function PlayerScoreboardMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "player_scoreboard_item",
		page = config.page,
		name = config.name,
		player = config.player,
		local_team = config.local_team,
		callback_object = callback_object,
		sounds = config.sounds,
		layout_settings = config.layout_settings,
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args
	}

	return PlayerScoreboardMenuItem:new(config, compiler_data.world)
end
