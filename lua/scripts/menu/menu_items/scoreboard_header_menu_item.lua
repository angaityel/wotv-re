-- chunkname: @scripts/menu/menu_items/scoreboard_header_menu_item.lua

ScoreboardHeaderMenuItem = class(ScoreboardHeaderMenuItem, MenuItem)

function ScoreboardHeaderMenuItem:init(config)
	ScoreboardHeaderMenuItem.super.init(self, config)
end

function ScoreboardHeaderMenuItem:update_size(dt, t, gui, layout_settings)
	return
end

function ScoreboardHeaderMenuItem:update_position(dt, t, layout_settings, x, y, z)
	local w, h = Gui.resolution()
	local offset_x, offset_y = 0, 0

	if layout_settings.screen_width then
		offset_x = -w * layout_settings.screen_width * 0.5
	elseif layout_settings.width then
		offset_x = -layout_settings.width * 0.5
	end

	self._x = x + offset_x + (layout_settings.offset_x or 0)
	self._y = y + offset_y + (layout_settings.offset_y or 0)
	self._z = z
end

function ScoreboardHeaderMenuItem:render(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()
	local width, height = 0, 0

	if layout_settings.screen_width then
		width = w * layout_settings.screen_width
	elseif layout_settings.width then
		width = layout_settings.width
	end

	if layout_settings.screen_height then
		height = h * layout_settings.screen_height
	elseif layout_settings.height then
		height = -layout_settings.height
	end

	local size = Vector2(width, height)
	local pos = Vector3(self._x, self._y, self._z)

	Gui.rect(gui, pos, size, self:_color(layout_settings.color))
	self:_try_callback(self.config.callback_object, "cb_render_border", gui, {
		pos[1],
		pos[2],
		size[1],
		size[2]
	}, 2, Color(0, 0, 0), 1)

	if self:_try_callback(self.config.callback_object, "cb_player_team") == "red" then
		Gui.bitmap(gui, layout_settings.viking_texture, pos + Vector3(0, -layout_settings.texture_size[2], 1), Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2]))
		Gui.bitmap(gui, layout_settings.saxon_texture, pos + Vector3(size[1] - layout_settings.texture_size[1], -layout_settings.texture_size[2], 1), Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2]))
	else
		Gui.bitmap(gui, layout_settings.saxon_texture, pos + Vector3(0, -layout_settings.texture_size[2], 1), Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2]))
		Gui.bitmap(gui, layout_settings.viking_texture, pos + Vector3(size[1] - layout_settings.texture_size[1], -layout_settings.texture_size[2], 1), Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2]))
	end

	local my_team_score = math.floor(self:_try_callback(self.config.callback_object, "cb_my_team_score") + 0.5)
	local min, max = Gui.text_extents(gui, my_team_score, layout_settings.left_team_score.font.font, layout_settings.left_team_score.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}

	Gui.text(gui, my_team_score, layout_settings.left_team_score.font.font, layout_settings.left_team_score.font_size, layout_settings.left_team_score.font.material, pos + Vector3(layout_settings.texture_size[1] + layout_settings.left_team_score.padding_x, -extents[2] + layout_settings.left_team_score.padding_y, 0))

	local other_team_score = math.floor(self:_try_callback(self.config.callback_object, "cb_other_team_score") + 0.5)
	local min, max = Gui.text_extents(gui, other_team_score, layout_settings.right_team_score.font.font, layout_settings.right_team_score.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}

	Gui.text(gui, other_team_score, layout_settings.left_team_score.font.font, layout_settings.left_team_score.font_size, layout_settings.left_team_score.font.material, pos + Vector3(size[1] - layout_settings.texture_size[1] - extents[1] - layout_settings.right_team_score.padding_x, -extents[2] + layout_settings.left_team_score.padding_y, 0))
end

function ScoreboardHeaderMenuItem:_color(color_table)
	return Color(unpack(color_table))
end

function ScoreboardHeaderMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "scoreboard_header",
		name = config.name,
		page = config.page,
		disabled = config.disabled,
		sounds = config.parent_page.config.sounds.items.text,
		callback_object = callback_object,
		layout_settings = config.layout_settings
	}

	return ScoreboardHeaderMenuItem:new(config, compiler_data.world)
end
