-- chunkname: @scripts/menu/menu_containers/stat_grid_menu_container.lua

StatGridMenuContainer = class(StatGridMenuContainer, MenuContainer)

function StatGridMenuContainer:init(items)
	StatGridMenuContainer.super.init(self)

	self._items = items
	self._team_color = {
		0,
		0,
		0,
		0
	}
end

function StatGridMenuContainer:update_size(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()

	self._width = 0

	for _, column in pairs(layout_settings.columns) do
		self._width = self._width + column.size * w
	end

	self._height = layout_settings.num_rows * layout_settings.row_height * h

	for _, item in ipairs(self._items) do
		local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

		item:update_size(dt, t, gui, item_layout_settings)
	end
end

function StatGridMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	local idx = 1
	local w, h = Gui.resolution()

	for _, item in pairs(self._items) do
		if not item:removed() then
			local num_rows = layout_settings.num_rows
			local item_column = math.floor((idx - 1) / num_rows) + 1
			local item_row = (idx - 1) % num_rows + 1
			local column_settings = layout_settings.columns[item_column]
			local item_width = item:width()
			local x = self._x

			if item_column > 1 then
				for i = 1, item_column - 1 do
					x = x + layout_settings.columns[i].size * w
				end
			end

			if column_settings.align == "right" then
				x = x + column_settings.size * w - item_width
			elseif column_settings == "center" then
				x = x + column_settings.size * w * 0.5 - item_width * 0.5
			end

			local y = self._y + self._height - item:height()

			if item_row > 1 then
				for i = 2, item_row do
					y = y - layout_settings.row_height * h
				end
			end

			item:update_position(dt, t, layout_settings, x, y, z + 10)

			idx = idx + 1
		end
	end
end

function StatGridMenuContainer:render(dt, t, gui, layout_settings)
	self:_render_background(dt, t, gui, layout_settings)
	self:_render_header(dt, t, gui, layout_settings)
	self:_render_items(dt, t, gui, layout_settings)
end

function StatGridMenuContainer:_render_background(dt, t, gui, layout_settings)
	local pos = Vector3(self._x, self._y, self._z)
	local size = Vector2(self._width, self._height)

	Gui.rect(gui, pos, size, self:_color(layout_settings.background_rect_color))
	self:_render_border(gui, {
		pos[1],
		pos[2],
		size[1],
		size[2]
	}, 2, Color(0, 0, 0), 1)
end

function StatGridMenuContainer:_render_border(gui, rect, thickness, color, layer)
	Gui.rect(gui, Vector3(rect[1] - thickness, rect[2], layer or 1), Vector2(rect[3] + thickness * 2, -thickness), color)
	Gui.rect(gui, Vector3(rect[1], rect[2], layer or 1), Vector2(-thickness, rect[4]), color)
	Gui.rect(gui, Vector3(rect[1] + rect[3], rect[2], layer or 1), Vector2(thickness, rect[4]), color)
	Gui.rect(gui, Vector3(rect[1] - thickness, rect[2] + rect[4], layer or 1), Vector2(rect[3] + thickness * 2, thickness), color)
end

function StatGridMenuContainer:set_player_name(player_name)
	self._player_name = player_name
end

function StatGridMenuContainer:set_player_team_color(color)
	self._team_color = color
end

function StatGridMenuContainer:team_color()
	return self._team_color
end

function StatGridMenuContainer:_render_header(dt, t, gui, layout_settings)
	if not self._player_name then
		return
	end

	local font = layout_settings.player_name_font
	local font_size = layout_settings.player_name_font_size
	local w, h = Gui.resolution()
	local pos = Vector3(self._x + layout_settings.name_padding_left * w, self._y + self._height - layout_settings.name_padding_top * h, self._z + 2)
	local text = HUDHelper:crop_text(gui, self._player_name, font.font, font_size, layout_settings.player_name_width, "...")
	local min, max = Gui.text_extents(gui, text, font.font, font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local name_pos = pos + Vector3(0, -extents[2], 0)

	Gui.text(gui, text, font.font, font_size, font.material, name_pos, self:_color(self._team_color))
	Gui.text(gui, text, font.font, font_size, font.material, name_pos + Vector3(2, -2, -1), Color(255, 0, 0, 0))
end

function StatGridMenuContainer:_render_items(dt, t, gui, layout_settings)
	for _, item in pairs(self._items) do
		if not item:removed() then
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:render(dt, t, gui, item_layout_settings)
		end
	end
end

function StatGridMenuContainer:_color(c)
	return Color(c[1], c[2], c[3], c[4])
end

function StatGridMenuContainer.create_from_config(items)
	return StatGridMenuContainer:new(items)
end
