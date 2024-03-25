-- chunkname: @scripts/menu/menu_containers/simple_grid_menu_container.lua

require("scripts/menu/menu_containers/menu_container")

SimpleGridMenuContainer = class(SimpleGridMenuContainer, MenuContainer)

function SimpleGridMenuContainer:init(items)
	SimpleGridMenuContainer.super.init(self, items)

	self._items = items or {}

	self:reset()
end

function SimpleGridMenuContainer:reset()
	self._scroll_offset = 0
	self._current_scroll_offset = 0
	self._max_item_height = 0
	self._total_item_height = 0
	self._scroll_percentage = 0
	self._calculated_max_shown_items = 0
	self._min_x = 0
	self._current_height = 0
	self._current_width = 0
	self._z = 0
end

function SimpleGridMenuContainer:item(idx)
	return self._items[idx]
end

function SimpleGridMenuContainer:is_item_inside(item_idx)
	if self._items[item_idx] then
		return self:_item_inside(nil, self._items[item_idx])
	end

	return false
end

function SimpleGridMenuContainer:is_inside(pos)
	return pos[1] >= self._x and pos[1] <= self._x + self._current_width and pos[2] >= self._y and pos[2] <= self._y + self._current_height
end

function SimpleGridMenuContainer:update_size(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()

	if layout_settings.max_shown_items_func then
		self._calculated_max_shown_items = layout_settings.max_shown_items_func()
	elseif layout_settings.max_shown_items then
		self._calculated_max_shown_items = layout_settings.max_shown_items
	end

	for idx, item in ipairs(self._items) do
		local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

		item:update_size(dt, t, gui, item_layout_settings)
	end

	self._width = 0
	self._height = 0

	self:_calculate_size(dt, t, gui, layout_settings)
end

function SimpleGridMenuContainer:current_width()
	return self._current_width or 0
end

function SimpleGridMenuContainer:current_height()
	return self._current_height or 0
end

function SimpleGridMenuContainer:is_inside_scroller(mouse_pos, layout_settings)
	if not layout_settings.max_shown_items then
		return false
	end

	local num_columns = layout_settings.num_columns and layout_settings.num_columns > 0 and layout_settings.num_columns or 1
	local num_rows = 1
	local num_visible_items = self:num_visible_items()

	if num_visible_items > 0 then
		num_rows = math.ceil(num_visible_items / num_columns)
	end

	local spacing_x = layout_settings.spacing_x or layout_settings.spacing or 0
	local spacing_x = layout_settings.spacing_y or layout_settings.spacing or 0
	local x = self._x - spacing_x
	local scroll_x = self._x - spacing_x

	if layout_settings.align == "right" then
		x = self._min_x - spacing_x
		scroll_x = x + self._current_width + spacing_x

		if layout_settings.border then
			scroll_x = scroll_x - layout_settings.border.thickness
		end
	elseif layout_settings.border then
		x = x - layout_settings.border.thickness
		scroll_x = x
	end

	local visible_percentage = self._calculated_max_shown_items / num_rows
	local scroller_size = Vector2((layout_settings.scroller_thickness or 0) + spacing_x + (layout_settings.border and layout_settings.border.thickness or 0), self._current_height * visible_percentage)
	local scroller_pos = Vector3(scroll_x, self._y + (self._height - scroller_size[2]) * (1 - self._scroll_percentage), self._z)

	if mouse_pos[1] >= scroller_pos[1] and mouse_pos[1] <= scroller_pos[1] + scroller_size[1] and mouse_pos[2] >= scroller_pos[2] and mouse_pos[2] <= scroller_pos[2] + scroller_size[2] then
		return true
	end
end

function SimpleGridMenuContainer:num_visible_items()
	local count = 0

	for _, item in pairs(self._items) do
		if not item:removed() then
			count = count + 1
		end
	end

	return count
end

function SimpleGridMenuContainer:_num_rows(layout_settings)
	local num_columns = layout_settings.num_columns

	return math.ceil(self:num_visible_items() / num_columns)
end

function SimpleGridMenuContainer:update_input(input, layout_settings)
	if self._calculated_max_shown_items then
		if self:num_visible_items() > self._calculated_max_shown_items then
			local y = input:get("wheel")[2]

			self._scroll_offset = math.clamp(self._scroll_offset - y * 50, 0, self._total_item_height - self._max_item_height)

			if self._total_item_height - self._max_item_height > 0 then
				self._scroll_percentage = self._current_scroll_offset / (self._total_item_height - self._max_item_height)
			end

			local diff = self._scroll_offset - self._current_scroll_offset

			self._current_scroll_offset = self._current_scroll_offset + diff * 0.1
		else
			self._scroll_offset = 0

			local diff = self._scroll_offset - self._current_scroll_offset

			self._current_scroll_offset = self._current_scroll_offset + diff * 0.1
		end
	end
end

function SimpleGridMenuContainer:set_scroller_pos(scroller_position)
	self._scroll_offset = math.clamp(scroller_position, 0, self._total_item_height - self._max_item_height)
	self._current_scroll_offset = self._scroll_offset
end

function SimpleGridMenuContainer:update_scroller_position(scroller_offset)
	self._scroll_offset = math.clamp(self._scroll_offset + scroller_offset, 0, self._total_item_height - self._max_item_height)
	self._current_scroll_offset = self._scroll_offset
end

function SimpleGridMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x + (layout_settings.offset_x or 0)
	self._y = y + (layout_settings.offset_y or 0)
	self._z = z + (layout_settings.z or 0)

	local w, h = Gui.resolution()
	local num_columns = layout_settings.num_columns or 1
	local spacing_x = layout_settings.spacing_x or layout_settings.spacing or 0
	local spacing_y = layout_settings.spacing_y or layout_settings.spacing or 0
	local expand_x = layout_settings.expand_x == "right" and -1 or 1
	local expand_y = layout_settings.expand_y == "up" and 1 or -1
	local curr_pos = {
		self._x + spacing_x * expand_x,
		self._y + self._height + spacing_y * expand_y
	}
	local idx = 1
	local max_item_y = math.huge
	local min_x = math.huge

	for _, item in ipairs(self._items) do
		if not item:removed() then
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)
			local item_y, item_x

			if layout_settings.item_position == "centered" then
				local width, height

				if layout_settings.num_columns == 1 then
					width, height = self._width, item:height()
				else
					width, height = item:width(), item:height()
				end

				item_x = curr_pos[1] + width / 2
				item_y = curr_pos[2] + height * expand_y + self._current_scroll_offset + height / 2
			elseif layout_settings.item_position == "right" then
				local width, height

				if layout_settings.num_columns == 1 then
					width, height = self._width, item:height()
				else
					width, height = item:width(), item:height()
				end

				item_x = curr_pos[1] + width
				item_y = curr_pos[2] + height * expand_y + self._current_scroll_offset + height
			else
				item_y = curr_pos[2] + item:height() * expand_y + self._current_scroll_offset
				item_x = curr_pos[1]
			end

			item:update_position(dt, t, item_layout_settings, item_x, item_y, self._z)

			local curr_column = (idx - 1) % num_columns + 1
			local new_column = idx % num_columns + 1

			if new_column <= curr_column then
				curr_pos[1] = self._x + spacing_x * expand_x
			else
				curr_pos[1] = curr_pos[1] + (item:width() + spacing_x) * expand_x
			end

			local curr_row = math.floor((idx - 1) / num_columns) + 1
			local new_row = math.floor(idx / num_columns) + 1

			if curr_row < new_row then
				curr_pos[2] = curr_pos[2] + (item:height() + spacing_y) * expand_y
			end

			idx = idx + 1
			min_x = min_x > item:x() and item:x() or min_x
		end
	end

	self._min_x = min_x

	self:_update_item_visibility(dt, t, layout_settings)
end

function SimpleGridMenuContainer:render(dt, t, gui, layout_settings)
	self:_render_masks(dt, t, gui, layout_settings)
	self:_render_container(dt, t, gui, layout_settings)
	self:_render_items(dt, t, gui, layout_settings)
end

function SimpleGridMenuContainer:render_from_child_page(dt, t, gui, layout_settings)
	self:_render_masks(dt, t, gui, layout_settings)
	self:_calculate_size(dt, t, gui, layout_settings)
	self:_render_container(dt, t, gui, layout_settings)
	self:_render_items(dt, t, gui, layout_settings, true)
	Gui.bitmap(gui, "mask_rect_alpha", Vector3(self._min_x, self._y - self._height, self._z), Vector2(self._width, self._height), Color(255, 0, 0, 0))
end

function SimpleGridMenuContainer:_update_item_visibility(dt, t, gui, layout_settings)
	for idx, item in pairs(self._items) do
		item.config.visible = self:_item_inside(gui, item)
	end
end

function SimpleGridMenuContainer:_render_masks(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()
	local num_rows = self:_num_rows(layout_settings)

	if self._calculated_max_shown_items and num_rows > self._calculated_max_shown_items then
		Gui.bitmap(gui, "mask_rect_alpha", Vector3(0, 0, 0), Vector2(w, h), Color(0, 0, 0, 0))
	end
end

function SimpleGridMenuContainer:_render_container(dt, t, gui, layout_settings)
	local num_rows = self:_num_rows(layout_settings)

	if self._calculated_max_shown_items and num_rows > self._calculated_max_shown_items then
		Gui.bitmap(gui, "mask_rect_alpha", Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), Color(255, 0, 0, 0))

		local spacing_x = layout_settings.spacing_x or layout_settings.spacing or 0
		local spacing_y = layout_settings.spacing_y or layout_settings.spacing or 0
		local x = self._x - spacing_x
		local width = self._width
		local separator = self._x
		local scroll_x = self._x - spacing_x

		if layout_settings.align == "right" then
			x = self._min_x - spacing_x
			separator = self._min_x + self._width
			width = self._width + spacing_x
			scroll_x = x + self._width + (layout_settings.spacing_x or layout_settings.spacing or 0)

			if layout_settings.border then
				separator = separator - layout_settings.border.thickness
				scroll_x = scroll_x - layout_settings.border.thickness
			end
		elseif layout_settings.border then
			x = x - layout_settings.border.thickness
			scroll_x = x
		end

		if layout_settings.rect then
			Gui.rect(gui, Vector3(x, self._y, self._z), Vector2(width + math.abs(self._x - x), self._height), MenuHelper:color(layout_settings.rect.color and layout_settings.rect.color or {
				128,
				0,
				0,
				0
			}))
		end

		local border = layout_settings.border

		if border and border.material then
			local y = self._y
			local z = self._z
			local height = self._height
			local width = self._width

			self:_render_border_piece(gui, layout_settings.border, x, y + height, z, width, layout_settings.thickness, 0)
			self:_render_border_piece(gui, layout_settings.border, x + width, y, z, width, layout_settings.thickness, 180)
			self:_render_border_piece(gui, layout_settings.border, x, y, z, height, layout_settings.thickness, 270)
			self:_render_border_piece(gui, layout_settings.border, x + width, y + height, z, height, layout_settings.thickness, 90)
			self:_render_border_corners(gui, layout_settings.border, x, y, z + 1, width, height)
			self:_render_scroll_bar(gui, layout_settings, scroll_x, separator, spacing_x, num_rows)
		elseif border then
			MenuHelper:render_border(gui, {
				x,
				self._y,
				width + math.abs(self._x - x),
				self._height
			}, layout_settings.border.thickness or 1, MenuHelper:color(layout_settings.border.color or {
				255,
				0,
				0,
				0
			}), self._z)
			self:_render_scroll_bar(gui, layout_settings, scroll_x, separator, spacing_x, num_rows)
		else
			local visible_percentage = self._calculated_max_shown_items / self:num_visible_items()
			local scroller_size = Vector2((layout_settings.scroller_thickness or 0) + spacing_x, self._height * visible_percentage)
			local scroller_pos = Vector3(scroll_x, self._y + (self._height - scroller_size[2]) * (1 - self._scroll_percentage), self._z)

			Gui.rect(gui, scroller_pos, scroller_size, MenuHelper:color(layout_settings.scroller_color or layout_settings.border and not self._scroller_highlighted and layout_settings.border.color or {
				255,
				0,
				0,
				0
			}))
		end
	else
		if layout_settings.rect then
			Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), MenuHelper:color(layout_settings.rect.color or {
				128,
				0,
				0,
				0
			}))
		end

		if layout_settings.render_mask then
			Gui.bitmap(gui, "mask_rect_alpha", Vector3(self._min_x, self._y, self._z), Vector2(self._width, self._height), Color(255, 0, 0, 0))
		end

		local border = layout_settings.border

		if border and border.material then
			local y = self._y
			local x = self._x
			local z = self._z
			local height = self._height
			local width = self._width

			self:_render_border_piece(gui, layout_settings.border, x, y + height, z, width, layout_settings.thickness, 0)
			self:_render_border_piece(gui, layout_settings.border, x + width, y, z, width, layout_settings.thickness, 180)
			self:_render_border_piece(gui, layout_settings.border, x, y, z, height, layout_settings.thickness, 270)
			self:_render_border_piece(gui, layout_settings.border, x + width, y + height, z, height, layout_settings.thickness, 90)
			self:_render_border_corners(gui, layout_settings.border, x, y, z + 1, width, height)
		elseif border then
			MenuHelper:render_border(gui, {
				self._x,
				self._y,
				self._width,
				self._height
			}, layout_settings.border.thickness or 1, MenuHelper:color(layout_settings.border.color or {
				255,
				0,
				0,
				0
			}), self._z)
		end
	end

	local texture = layout_settings.texture

	if texture then
		local position = Vector3(self._x, self._y, self._z)
		local size = Vector2(self._width, self._height)
		local color = MenuHelper:color(layout_settings.texture.color)
		local atlas = texture.texture_atlas

		if atlas then
			ScriptGUI.bitmap_uv_tiled(gui, atlas, HUDHelper.atlas_texture_settings(atlas, texture.material), position, size, color)
		else
			Gui.bitmap(gui, texture.material, position, size, color)
		end
	end
end

function SimpleGridMenuContainer:_render_scroll_bar(gui, layout_settings, scroll_x, separator, spacing_x, num_rows)
	local multiplier = 1 - (layout_settings.rect and layout_settings.rect.color and layout_settings.rect.color[1] or 128) / 255
	local b_c = layout_settings.border.color or {
		255,
		0,
		0,
		0
	}
	local c = Color(b_c[1] * multiplier, b_c[2] * multiplier, b_c[3] * multiplier, b_c[4] * multiplier)

	Gui.rect(gui, Vector3(separator, self._y, self._z), Vector2(layout_settings.border.thickness, self._height), c, self._z)

	local visible_percentage = self._calculated_max_shown_items / num_rows
	local scroller_size = Vector2((layout_settings.scroller_thickness or 0) + layout_settings.border.thickness, self._height * visible_percentage)
	local scroller_pos = Vector3(scroll_x, self._y + (self._height - scroller_size[2]) * (1 - self._scroll_percentage), self._z)

	if scroll_x == 369 then
		local temp = 0
	end

	Gui.rect(gui, scroller_pos, scroller_size, MenuHelper:color(layout_settings.scroller_color or layout_settings.border and not self._scroller_highlighted and layout_settings.border.color or {
		255,
		0,
		0,
		0
	}))
end

function SimpleGridMenuContainer:_render_border_piece(gui, layout_settings, x, y, z, width, height, rotate_angle)
	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.material)
	local uv_size = uv11 - uv00
	local size_diff = width / size[1]
	local x_offset = 0
	local rads = math.degrees_to_radians(rotate_angle)

	repeat
		local new_uv11 = Vector2(uv00[1] + math.min(size_diff, 1) * uv_size[1], uv11[2])
		local new_size = Vector2(size[1] * math.min(size_diff, 1), size[2])

		if rotate_angle then
			local rot = Rotation2D(Vector2(x, y), rads)

			Gui.bitmap_3d_uv(gui, material, uv00, new_uv11, rot, Vector3(x_offset, 0, z), z, new_size)

			x_offset = x_offset + size[1]
		end

		size_diff = size_diff - 1
	until size_diff <= 0
end

function SimpleGridMenuContainer:_render_border_corners(gui, layout_settings, x, y, z, width, height)
	if not layout_settings.corner_material then
		return
	end

	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.corner_material)
	local offset = layout_settings.corner_offset or {
		0,
		0
	}
	local pos = Vector3(x + offset[1], y + self._height + offset[2], z - 1)
	local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)

	Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

	if layout_settings.corner_small_material then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.corner_small_material)
		local offset = layout_settings.corner_small_offset or {
			0,
			0
		}
		local pos = Vector3(x + offset[1], y + offset[2], 0)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

		local pos = Vector3(x + self._width - offset[2], y + offset[1], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(-180), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

		local pos = Vector3(x + self._width - offset[1], y + self._height - offset[2], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(90), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)
	else
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x - size[1], y - layout_settings.thickness, 0), size)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + self._width - size[1], y - layout_settings.thickness, z - 1), size)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + self._width - size[1], y + self._height, z), size)
	end
end

function SimpleGridMenuContainer:_calculate_size(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()
	local width, height = 0, 0
	local total_item_height = 0
	local spacing_x = layout_settings.spacing_x or layout_settings.spacing or 0
	local spacing_y = layout_settings.spacing_y or layout_settings.spacing or 0
	local num_columns = layout_settings.num_columns
	local num_spacing_x = 0
	local max_spacing_x = 0
	local max_width = 0
	local num_items = 0
	local idx = 1

	for _, item in ipairs(self._items) do
		local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

		item:update_size(dt, t, gui, item_layout_settings)

		if not item:removed() then
			if idx <= num_columns then
				width = width + item:width()
				num_spacing_x = num_spacing_x + 1
			else
				width = width > 0 and width or item:width()
				max_width = max_width < width and width or max_width
				max_spacing_x = max_spacing_x < num_spacing_x and num_spacing_x or max_spacing_x
				width = 0
				num_spacing_x = 0
			end

			if (idx - 1) % num_columns == 0 then
				num_items = num_items + 1

				if not layout_settings.max_shown_items or num_items <= self._calculated_max_shown_items then
					height = height + item:height()
				end

				total_item_height = total_item_height + item:height()
			end

			idx = idx + 1
		end
	end

	local num_spacing_y = math.ceil(num_items / num_columns)

	max_width = max_width < width and width or max_width
	max_spacing_x = max_spacing_x < num_spacing_x and num_spacing_x or max_spacing_x

	if layout_settings.max_shown_items then
		local items = num_spacing_y > self._calculated_max_shown_items and self._calculated_max_shown_items or num_spacing_y

		self._width = max_width + spacing_x * (2 + (max_spacing_x - 1))
		self._height = height + spacing_y * (2 + items - 1)
		self._max_item_height = height + spacing_y * (items - 1)
		self._total_item_height = total_item_height + spacing_y * (num_spacing_y - 1)
	else
		self._width = max_width + spacing_x * (2 + (max_spacing_x - 1))
		self._height = height + spacing_y * (2 + num_spacing_y - 1)
	end

	self._current_width = self._width
	self._current_height = self._height
end

function SimpleGridMenuContainer:_render_items(dt, t, gui, layout_settings, render_from_child_page)
	for idx, item in pairs(self._items) do
		if not item:removed() then
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			if self:_item_inside(gui, item) then
				item:render(dt, t, gui, item_layout_settings, render_from_child_page)
			end
		end
	end
end

function SimpleGridMenuContainer:_item_inside(gui, item)
	local test = 0
	local item_min_y = item:y()
	local item_max_y = item_min_y + item:height()
	local container_min_y = self._y
	local container_max_y = self._y + self._current_height

	return container_min_y <= item_max_y and item_min_y <= container_max_y
end

function SimpleGridMenuContainer.create_from_config(items)
	return SimpleGridMenuContainer:new(items)
end
