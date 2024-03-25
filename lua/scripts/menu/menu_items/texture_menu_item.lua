-- chunkname: @scripts/menu/menu_items/texture_menu_item.lua

TextureMenuItem = class(TextureMenuItem, MenuItem)

function TextureMenuItem:init(config, world)
	TextureMenuItem.super.init(self, config, world)
	self:set_selected(false)
end

function TextureMenuItem:set_selected(selected)
	self._selected = selected
end

function TextureMenuItem:selected()
	return self._selected
end

function TextureMenuItem:removed()
	return self.config.removed
end

function TextureMenuItem:on_lowlight()
	TextureMenuItem.super.on_lowlight(self)

	if self.config.on_lowlight then
		self:_try_callback(self.config.callback_object, self.config.on_lowlight, unpack(self.config.on_lowlight_args or {}))
	end
end

function TextureMenuItem:update_size(dt, t, gui, layout_settings)
	if layout_settings.texture_atlas then
		local atlas_table = HUDHelper.atlas_texture_settings(layout_settings.texture_atlas, self:_texture_name(layout_settings))
		local width_scale_of_gui = layout_settings.width_scale_of_gui

		if width_scale_of_gui then
			local w, h = Gui.resolution()

			self._texture_width = w * width_scale_of_gui
			self._texture_height = self._texture_width / atlas_table.size[1] * atlas_table.size[2]
		else
			self._texture_width = atlas_table.size[1]
			self._texture_height = atlas_table.size[2]
		end

		local uv_00 = atlas_table.uv00
		local uv_11 = atlas_table.uv11

		self._texture_uv_00 = Vector2(uv_00[1], uv_00[2])
		self._texture_uv_11 = Vector2(uv_11[1], uv_11[2])
		self._width = self._texture_width + layout_settings.padding_left + layout_settings.padding_right
		self._height = self._texture_height + layout_settings.padding_top + layout_settings.padding_bottom
	else
		local width_scale_of_gui = layout_settings.width_scale_of_gui

		if width_scale_of_gui then
			local w, h = Gui.resolution()

			self._texture_width = w * width_scale_of_gui
			self._texture_height = self._texture_width / layout_settings.texture_width * layout_settings.texture_height
		else
			self._texture_width = layout_settings.texture_width
			self._texture_height = layout_settings.texture_height
		end

		self._width = self._texture_width + layout_settings.padding_left + layout_settings.padding_right
		self._height = self._texture_height + layout_settings.padding_top + layout_settings.padding_bottom
	end
end

function TextureMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z or 1

	if layout_settings.align == "center" then
		self._texture_x = math.floor(x + layout_settings.padding_left - self._texture_width * 0.5)
	else
		self._texture_x = math.floor(x + layout_settings.padding_left)
	end

	if self.config.not_pixel_perfect_y then
		self._texture_y = y + layout_settings.padding_bottom
	else
		self._texture_y = math.floor(y + layout_settings.padding_bottom)
	end
end

function TextureMenuItem:_texture_name(layout_settings)
	return layout_settings.texture or self.config.texture
end

function TextureMenuItem:_render_texture(gui, layout_settings, color)
	if layout_settings.texture_atlas then
		Gui.bitmap_uv(gui, layout_settings.texture_atlas, self._texture_uv_00, self._texture_uv_11, Vector2(self._texture_x, self._texture_y, self._z), Vector2(self._texture_width, self._texture_height), color)
	else
		Gui.bitmap(gui, self:_texture_name(layout_settings), Vector2(self._texture_x, self._texture_y, self._z), Vector2(self._texture_width, self._texture_height), color)
	end
end

function TextureMenuItem:render_from_child_page(dt, t, gui, layout_settings)
	if layout_settings.render_from_child_page then
		local color
		local color_table = layout_settings.color_render_from_child_page

		if color_table then
			color = Color(color_table[1], color_table[2], color_table[3], color_table[4])
		else
			color = Color(255, 255, 255, 255)
		end

		self:_render_texture(gui, layout_settings, color)
	end
end

function TextureMenuItem:render(dt, t, gui, layout_settings)
	if self.config.no_render_outside_screen and MenuHelper.is_outside_screen(self._x, self._y, self._width, self._height, 10) then
		return
	end

	local color_table = self.config.disabled and layout_settings.color_disabled or self._highlighted and layout_settings.color_highlighted or layout_settings.color or self.config.color
	local color = color_table and Color(color_table[1], color_table[2], color_table[3], color_table[4]) or Color(255, 255, 255, 255)
	local texture_x = self._texture_x
	local texture_y = self._texture_y

	if not self.config.hide then
		self:_render_texture(gui, layout_settings, color)

		if layout_settings.texture_background then
			local x, y, z

			if layout_settings.texture_background_alignment == "left" then
				x = self._x + (layout_settings.texture_background_offset_x or 0)
				y = self._y + (layout_settings.texture_background_offset_y or 0)
				z = self._z + (layout_settings.texture_background_offset_z or -1)
			elseif layout_settings.texture_background_alignment == "center" then
				x = self._x + self._width / 2 - layout_settings.texture_background_width / 2 + (layout_settings.texture_background_offset_x or 0)
				y = self._y + self._height / 2 - layout_settings.texture_background_height / 2 + (layout_settings.texture_background_offset_y or 0)
				z = self._z + (layout_settings.texture_background_offset_z or -1)
			elseif layout_settings.texture_background_alignment == "right" then
				x = self._x + self._width - layout_settings.texture_background_width + (layout_settings.texture_background_offset_x or 0)
				y = self._y + self._height / 2 - layout_settings.texture_background_height / 2 + (layout_settings.texture_background_offset_y or 0)
				z = self._z + (layout_settings.texture_background_offset_z or -1)
			end

			local bg_color_table = layout_settings.texture_background_color
			local bg_color = bg_color_table and Color(bg_color_table[1], bg_color_table[2], bg_color_table[3], bg_color_table[4]) or Color(255, 255, 255, 255)

			Gui.bitmap(gui, layout_settings.texture_background, Vector3(math.floor(x), math.floor(y), z), Vector2(layout_settings.texture_background_width, layout_settings.texture_background_height), bg_color)
		end

		if self._highlighted and layout_settings.texture_highlighted then
			if layout_settings.texture_atlas then
				local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.texture_highlighted)

				Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(texture_x, texture_y, self._z), size)
			else
				Gui.bitmap(gui, layout_settings.texture_highlighted, Vector3(math.floor(texture_x + (layout_settings.texture_highlighted_offset_x or 0)), math.floor(texture_y + (layout_settings.texture_highlighted_offset_y or 0)), self._z + (layout_settings.texture_highlighted_offset_z or 1)), Vector2(math.floor(layout_settings.texture_highlighted_width), math.floor(layout_settings.texture_highlighted_height)))
			end
		end

		if self.config.disabled and layout_settings.texture_disabled then
			if layout_settings.texture_atlas then
				local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.texture_disabled)

				Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(texture_x, texture_y, self._z), size)
			else
				Gui.bitmap(gui, layout_settings.texture_disabled, Vector3(math.floor(texture_x + (layout_settings.texture_disabled_offset_x or 0)), math.floor(texture_y + (layout_settings.texture_disabled_offset_y or 0)), self._z + (layout_settings.texture_disabled_offset_z or 1)), Vector2(math.floor(layout_settings.texture_disabled_width), math.floor(layout_settings.texture_disabled_height)))
			end
		end
	end
end

function TextureMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "texture",
		page = config.page,
		name = config.name,
		disabled = config.disabled,
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_lowlight = config.on_lowlight,
		on_lowlight_args = config.on_lowlight_args or {},
		texture = config.texture,
		not_pixel_perfect_y = config.not_pixel_perfect_y,
		no_render_outside_screen = config.no_render_outside_screen,
		color = config.color,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.sounds and config.sounds.items and config.sounds.items.texture or config.parent_page.config.sounds and config.parent_page.config.sounds.items and config.parent_page.config.sounds.items.texture or MenuSettings.sounds.default.items.texture
	}

	return TextureMenuItem:new(config, compiler_data.world)
end
