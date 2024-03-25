-- chunkname: @scripts/menu/menu_items/category_item.lua

CategoryItem = class(CategoryItem, MenuItem)

function CategoryItem:init(config, world)
	CategoryItem.super.init(self, config, world)

	self._alpha = 1
	self._new_item = config.new_item
end

function CategoryItem:alpha()
	return self._alpha
end

function CategoryItem:on_page_enter(on_cancel)
	CategoryItem.super.on_page_enter(self, on_cancel)

	if self.config.on_enter_new_item then
		self._new_item = self:_try_callback(self.config.callback_object, self.config.on_enter_new_item, unpack(self.config.on_enter_new_item_args))
	end
end

function CategoryItem:update_size(dt, t, gui, layout_settings, width, height)
	local min, max = Gui.text_extents(gui, L(self.config.text), layout_settings.font.font, layout_settings.font_size)

	self._text_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	self._width = layout_settings.width or self._text_extents[1]
	self._height = layout_settings.height or self._text_extents[2]
end

function CategoryItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z or 0
end

function CategoryItem:is_mouse_inside(mouse_x, mouse_y)
	self._mouse_pos = self._mouse_pos or {
		0,
		0
	}
	self._mouse_pos[1] = mouse_x
	self._mouse_pos[2] = mouse_y

	local x1 = self._mouse_area_x or self._x - self.config.item_padding[1] * 0.5
	local y1 = self._mouse_area_y or self._y - self.config.item_padding[2] * 0.5
	local x2 = x1 + (self._mouse_area_width or self._width) + self.config.item_padding[1]
	local y2 = y1 + (self._mouse_area_height or self._height) + self.config.item_padding[2]
	local inside = x1 <= mouse_x and mouse_x <= x2 and y1 <= mouse_y and mouse_y <= y2

	return inside
end

function CategoryItem:render(dt, t, gui, layout_settings, render_from_child_page)
	MenuHelper:render_border(gui, {
		self._x,
		self._y,
		self._width,
		self._height
	}, layout_settings.border_thickness, self:_color(self._highlighted and layout_settings.highlighted_border_color or layout_settings.border_color))
	Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), self:_color(self._highlighted and layout_settings.highlighted_rect_color or layout_settings.rect_color))
	Gui.text(gui, L(self.config.text), layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(self._x + layout_settings.text_offset_x, self._y + layout_settings.height * 0.5 - self._text_extents[2] * 0.5 + (layout_settings.text_offset_y or 0), self._z + 1), self:_color(self.config.disabled and layout_settings.disabled_text_color or self._highlighted and layout_settings.highlighted_text_color or layout_settings.text_color))

	if self._new_item then
		self:_render_new_item(dt, t, gui, layout_settings)
	end

	if self.config.disabled and layout_settings.disabled_text then
		self:_render_disabled_text(dt, t, gui, layout_settings.disabled_text)
	end

	if layout_settings.mouse_over and not render_from_child_page then
		self:_render_mouse_over(dt, t, gui, layout_settings.mouse_over)
	end
end

function CategoryItem:_render_new_item(dt, t, gui, layout_settings)
	local scale = layout_settings.scale or 1
	local atlas_table = HUDHelper.atlas_texture_settings(layout_settings.texture_atlas, layout_settings.texture)
	local uv00 = Vector2(atlas_table.uv00[1], atlas_table.uv00[2])
	local uv11 = Vector2(atlas_table.uv11[1], atlas_table.uv11[2])
	local x = self._x + layout_settings.text_offset_x + self._text_extents[1] + layout_settings.texture_offset_x
	local y = self._y + layout_settings.height * 0.5 - self._text_extents[2] * 0.5 + (layout_settings.text_offset_y or 0) + layout_settings.texture_offset_y
	local z = self._z + 10
	local pos = Vector3(x, y, z)
	local size = Vector2(atlas_table.size[1] * scale, atlas_table.size[2] * scale)
	local color = self:_color(layout_settings.texture_color)

	Gui.bitmap_uv(gui, layout_settings.texture_atlas, uv00, uv11, pos, size, color)
end

function CategoryItem:_render_disabled_text(dt, t, gui, layout_settings)
	local text = L(self.config.disabled_text)
	local font = layout_settings.font.font
	local material = layout_settings.font.material
	local font_size = layout_settings.font_size
	local min, max = Gui.text_extents(gui, text, font, font_size)
	local width = max[1] - min[1]
	local height = max[3] - min[3]
	local x = self._x + layout_settings.text_offset_x
	local y = self._y + layout_settings.text_offset_y
	local z = self._z + 10

	if layout_settings.align == "left" then
		x = x - width
	end

	local position = Vector3(math.floor(x), math.floor(y), z)
	local color = self:_color(layout_settings.color)
	local drop_shadow_color = self:_color(layout_settings.drop_shadow_color)
	local drop_shadow_offset = Vector3(1, -1, -1)

	ScriptGUI.text(gui, text, font, font_size, material, position, color, drop_shadow_color, drop_shadow_offset)
end

function CategoryItem:_render_mouse_over(dt, t, gui, layout_settings)
	local mouse_pos = self._mouse_pos

	if self._highlighted and mouse_pos then
		self._mouse_over_timer = math.max((self._mouse_over_timer or 0) - dt, 0)

		if self._mouse_over_timer == 0 then
			local layer = layout_settings.z or self._z + 50
			local header = self.config.ui_header
			local text = self.config.ui_description
			local w, h = Gui.resolution()
			local alignment_offset_x = 0
			local align_towards_center = layout_settings.alignment == "towards_center"

			if align_towards_center and mouse_pos[1] > w * 0.5 or not align_towards_center and mouse_pos[1] < w * 0.5 then
				alignment_offset_x = -(layout_settings.width + (layout_settings.spacing or 0) * 1.5 + (layout_settings.offset_x or 0))
			end

			local mouse_pos_vec = Vector3(mouse_pos[1], mouse_pos[2], 0)
			local pos = mouse_pos_vec - Vector3(-(layout_settings.spacing or 0), layout_settings.spacing or 0, 0) - Vector3(layout_settings.offset_x or 0, layout_settings.offset_y or 0, 0) + Vector3(alignment_offset_x, 0, layer)

			Gui.text(gui, L(header), layout_settings.header_font.font, layout_settings.header_font_size, layout_settings.header_font.material, pos, MenuHelper:color(self:_try_callback(self.config.callback_object, layout_settings.header_color_func)))

			pos[2] = pos[2] - layout_settings.header_spacing

			local description_texts = MenuHelper:format_text(L(text), gui, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.text_width or layout_settings.width)

			for i, text in ipairs(description_texts) do
				Gui.text(gui, text, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.text_font.material, pos + Vector3(0, 0, layer))

				pos[2] = pos[2] - layout_settings.spacing
			end

			local rect_pos = mouse_pos_vec + Vector3(alignment_offset_x, 0, layer - 1)
			local rect_size = Vector2(layout_settings.width + (layout_settings.spacing or 0) * 1.5 + (layout_settings.offset_x or 0), pos[2] - rect_pos[2] - (layout_settings.spacing or 0) + (layout_settings.offset_y or 0))

			Gui.rect(gui, rect_pos, rect_size, MenuHelper:color(layout_settings.background_color))
			MenuHelper:render_border(gui, {
				rect_pos[1],
				rect_pos[2],
				rect_size[1],
				rect_size[2]
			}, layout_settings.border_thickness, MenuHelper:color(layout_settings.border_color), layer)
		end
	else
		self._mouse_over_timer = layout_settings.highlight_timer
	end
end

function CategoryItem:_color(c, alpha_multiplier)
	return Color(c[1] * (alpha_multiplier or 1), c[2], c[3], c[4])
end

function CategoryItem.create_from_config(compiler_data, config, callback_object)
	local category_config = {
		type = "category_item",
		name = config.name,
		text = config.name,
		ui_header = config.ui_header,
		ui_description = config.ui_description,
		layout_settings = config.layout_settings,
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args,
		sounds = config.sounds.items.category_item or MenuSettings.sounds.default.items.category_item,
		item_padding = config.item_padding,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		remove_args = config.remove_args,
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func),
		disabled_args = config.disabled_args,
		on_enter_new_item = config.on_enter_new_item,
		on_enter_new_item_args = config.on_enter_new_item_args or {},
		new_item = config.new_item,
		disabled_text = config.disabled_text
	}

	return CategoryItem:new(category_config, compiler_data.world)
end
