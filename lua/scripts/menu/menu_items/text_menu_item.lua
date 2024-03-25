-- chunkname: @scripts/menu/menu_items/text_menu_item.lua

require("scripts/menu/menu_items/menu_item")

TextMenuItem = class(TextMenuItem, MenuItem)

function TextMenuItem:init(config, world)
	TextMenuItem.super.init(self, config, world)
	self:set_selected(false)
end

function TextMenuItem:on_select(ignore_sound)
	if self.config.toggle_selection then
		self:set_selected(not self._selected)
	else
		self:set_selected(true)
	end

	TextMenuItem.super.on_select(self, ignore_sound)
end

function TextMenuItem:on_deselect()
	self:set_selected(false)
end

function TextMenuItem:set_selected(selected)
	self._selected = selected
end

function TextMenuItem:selected()
	return self._selected
end

function TextMenuItem:set_text(text)
	fassert(text, "Setting text to %s, this will cause a crash in update_size", text)

	self.config.text = text
end

function TextMenuItem:update_size(dt, t, gui, layout_settings)
	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local min, max = Gui.text_extents(gui, self.config.text, font, layout_settings.font_size)

	self._width = layout_settings.rect_width or max[1] - min[1] + layout_settings.padding_left + layout_settings.padding_right
	self._height = layout_settings.rect_height or layout_settings.line_height + layout_settings.padding_top + layout_settings.padding_bottom
	self._min_x = min[1]
	self._max_x = max[1]
	self._text_height = max[3] - min[3]

	TextMenuItem.super.update_size(self, dt, t, gui)
end

function TextMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	TextMenuItem.super.update_position(self, dt, t)
end

function TextMenuItem:render_from_child_page(dt, t, gui, layout_settings)
	local z = self._z + (layout_settings.offset_z or 0)

	if layout_settings.texture_disabled and self.config.disabled then
		local x, y

		if layout_settings.texture_alignment == "left" then
			x = self._x + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "center" then
			x = self._x + self._width / 2 - layout_settings.texture_disabled_width / 2 + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "right" then
			x = self._x + self._width - layout_settings.texture_disabled_width + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		end

		local c = layout_settings.texture_color_render_from_child_page
		local color = Color(c[1], c[2], c[3], c[4])

		Gui.bitmap(gui, layout_settings.texture_disabled, Vector3(math.floor(x), math.floor(y), z), Vector2(layout_settings.texture_disabled_width, layout_settings.texture_disabled_height), color)
	end

	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_material = layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
	local c = self.config.color or layout_settings.color_render_from_child_page
	local color = Color(c[1], c[2], c[3], c[4])

	ScriptGUI.text(gui, self.config.text, font, layout_settings.font_size, font_material, Vector3(math.floor(self._x + layout_settings.padding_left - self._min_x), math.floor(self._y + layout_settings.padding_bottom), z + 1), color)

	if layout_settings.background_stripe then
		local c = layout_settings.background_stripe_color
		local color = Color(c[1], c[2], c[3], c[4])
		local pos = Vector3(x, y, z + 1)

		Gui.rect(gui, pos + Vector3(0, self._text_height * 0.35 - layout_settings.background_stripe_size * 0.5 * self._text_height, -2), Vector2(self._width, layout_settings.background_stripe_size * self._text_height), color)
	end
end

function TextMenuItem:render(dt, t, gui, layout_settings)
	if self.config.no_render_outside_screen and MenuHelper.is_outside_screen(self._x, self._y, self._width, self._height, 10) then
		return
	end

	local z = self._z + (layout_settings.offset_z or 0)
	local pulse_alpha

	if layout_settings.pulse_speed then
		local amp = (layout_settings.pulse_alpha_max - layout_settings.pulse_alpha_min) / 2
		local off = layout_settings.pulse_alpha_min + amp

		pulse_alpha = amp * math.cos(t * layout_settings.pulse_speed) + off
	end

	local x, y

	if layout_settings.texture_highlighted and self._highlighted then
		if layout_settings.texture_alignment == "left" then
			x = self._x + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_highlighted_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "center" then
			x = self._x + self._width / 2 - layout_settings.texture_highlighted_width / 2 + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_highlighted_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "right" then
			x = self._x + self._width - layout_settings.texture_highlighted_width + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_highlighted_height / 2 + (layout_settings.texture_offset_y or 0)
		end

		local texture_c = layout_settings.texture_highlighted_color or {
			255,
			255,
			255,
			255
		}
		local texture_color = Color(texture_c[1], texture_c[2], texture_c[3], texture_c[4])

		Gui.bitmap(gui, layout_settings.texture_highlighted, Vector3(math.floor(x), math.floor(y), z), Vector2(layout_settings.texture_highlighted_width, layout_settings.texture_highlighted_height), texture_color)
	elseif layout_settings.texture_disabled and self.config.disabled then
		if layout_settings.texture_alignment == "left" then
			x = self._x + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "center" then
			x = self._x + self._width / 2 - layout_settings.texture_disabled_width / 2 + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "right" then
			x = self._x + self._width - layout_settings.texture_disabled_width + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		end

		local texture_c = layout_settings.texture_disabled_color or {
			255,
			255,
			255,
			255
		}
		local texture_color = Color(texture_c[1], texture_c[2], texture_c[3], texture_c[4])

		x = math.floor(x)
		y = self.config.not_pixel_perfect_y and y or math.floor(y)

		Gui.bitmap(gui, layout_settings.texture_disabled, Vector3(x, y, z), Vector2(layout_settings.texture_disabled_width, layout_settings.texture_disabled_height), texture_color)
	elseif layout_settings.texture then
		if layout_settings.texture_alignment == "left" then
			x = self._x + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_disabled_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "center" then
			x = self._x + self._width / 2 - layout_settings.texture_width / 2 + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_height / 2 + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_alignment == "right" then
			x = self._x + self._width - layout_settings.texture_width + (layout_settings.texture_offset_x or 0)
			y = self._y + self._height / 2 - layout_settings.texture_height / 2 + (layout_settings.texture_offset_y or 0)
		end

		local texture_c = layout_settings.texture_color or {
			255,
			255,
			255,
			255
		}
		local texture_color = Color(texture_c[1], texture_c[2], texture_c[3], texture_c[4])

		Gui.bitmap(gui, layout_settings.texture, Vector3(math.floor(x), math.floor(y), z), Vector2(layout_settings.texture_width, layout_settings.texture_height), texture_color)
	end

	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_material = layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
	local c = self.config.color or self.config.disabled and layout_settings.color_disabled or self._selected and layout_settings.color_selected or self._highlighted and layout_settings.color_highlighted or layout_settings.color or self:_try_callback(self.config.callback_object, layout_settings.color_callback)
	local color = Color(pulse_alpha or c[1], c[2], c[3], c[4])
	local shadow_color_table = self.config.disabled and layout_settings.drop_shadow_color_disabled or layout_settings.drop_shadow_color
	local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
	local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])
	local text_position = self:_text_position(self._x, self._y, z, layout_settings)

	ScriptGUI.text(gui, self.config.text, font, layout_settings.font_size, font_material, text_position, color, shadow_color, shadow_offset)

	if layout_settings.background_stripe then
		local c = layout_settings.background_stripe_color
		local color = Color(c[1], c[2], c[3], c[4])
		local pos = text_position

		Gui.rect(gui, pos + Vector3(0, self._text_height * 0.35 - layout_settings.background_stripe_size * 0.5 * self._text_height, -2), Vector2(self._width, layout_settings.background_stripe_size * self._text_height), color)
	end

	if layout_settings.render_rect then
		local rect_layout_settings = layout_settings.texture_background_rect

		if rect_layout_settings then
			local width = rect_layout_settings.width
			local height = rect_layout_settings.height
			local offset_x = layout_settings.rect_offset_x or 0
			local offset_y = layout_settings.rect_offset_y or 0

			MenuHelper:render_texture_background_rect(dt, t, gui, rect_layout_settings, self.config.disabled, self._highlighted, 1, self._x + self._width / 2 - width / 2 + offset_x, self._y + self._height / 2 - height / 2 + offset_y, self._z, width, height)
		else
			self:_render_rect(layout_settings, gui)
		end
	end

	TextMenuItem.super.render(self, dt, t, gui)
end

function TextMenuItem:_text_position(x, y, z, layout_settings)
	local text_alignment = layout_settings.text_alignment

	assert(not text_alignment or layout_settings.rect_width, "[TextMenuItem:_text_position()] Trying to set alignment of text without setting rect width. Without a rect width, alignment does not mean anything.")

	local y = self._y + layout_settings.padding_bottom

	if not self.config.not_pixel_perfect_y then
		y = math.floor(y)
	end

	local z = z + 1

	if not text_alignment or text_alignment == "left" then
		return Vector3(math.floor(x + layout_settings.padding_left - self._min_x), y, z)
	elseif text_alignment == "right" then
		return Vector3(math.floor(x + layout_settings.rect_width - layout_settings.padding_right - self._max_x), y, z)
	elseif text_alignment == "center" then
		local width = self._max_x - self._min_x

		return Vector3(math.floor(x + 0.5 * (layout_settings.padding_left + layout_settings.rect_width - layout_settings.padding_right - width)), y, z)
	end
end

function TextMenuItem:_render_rect(layout_settings, gui)
	local rect_color = MenuHelper:color(not (not self._selected and not self._highlighted) and layout_settings.rect_color_highlighted or layout_settings.rect_color or {
		255,
		255,
		255,
		255
	})
	local border_color = MenuHelper:color(layout_settings.border_color or {
		255,
		0,
		0,
		0
	})
	local width = layout_settings.rect_width or self._width
	local height = layout_settings.rect_height or self._height
	local offset_x = layout_settings.rect_offset_x or 0
	local offset_y = layout_settings.rect_offset_y or 0
	local border_thickness = layout_settings.border_thickness or 1

	if layout_settings.masked then
		Gui.bitmap(gui, layout_settings.masked, Vector3(self._x + offset_x, self._y + offset_y, self._z), Vector2(width, height), rect_color)
	else
		Gui.rect(gui, Vector3(self._x + offset_x, self._y + offset_y, self._z), Vector2(width, height), rect_color)
	end

	MenuHelper:render_border(gui, {
		self._x + offset_x,
		self._y + offset_y,
		width,
		height
	}, border_thickness, border_color, self._z, layout_settings.masked)
end

function TextMenuItem:on_page_enter()
	TextMenuItem.super.on_page_enter(self)

	if self:visible() and self.config.on_enter_text then
		local text = self:_try_callback(self.config.callback_object, self.config.on_enter_text, unpack(self.config.on_enter_text_args or {}))

		fassert(text, "Setting text to %s, this will cause a crash in update_size", text)

		self.config.text = text
	end
end

function TextMenuItem.create_from_config(compiler_data, config, callback_object)
	fassert(config.text, "Setting text to %s, this will cause a crash in update_size", config.text)

	local config = {
		type = "text",
		page = config.page,
		name = config.name,
		demo_icon = config.demo_icon,
		disabled = config.disabled,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		remove_args = config.remove_args or {},
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		visible_func = config.visible_func and callback(callback_object, config.visible_func, config.visible_func_args),
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_enter_text = config.on_enter_text,
		on_enter_text_args = config.on_enter_text_args or {},
		toggle_selection = config.toggle_selection,
		text = config.no_localization and config.text or L(config.text),
		color = config.color,
		tooltip_text = config.tooltip_text,
		tooltip_text_2 = config.tooltip_text_2,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		floating_tooltip = config.floating_tooltip,
		not_pixel_perfect_y = config.not_pixel_perfect_y,
		no_render_outside_screen = config.no_render_outside_screen,
		sounds = config.sounds or config.parent_page.config.sounds.items.text
	}

	return TextMenuItem:new(config, compiler_data.world)
end
