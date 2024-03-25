-- chunkname: @scripts/menu/menu_items/header_item.lua

HeaderItem = class(HeaderItem, MenuItem)

function HeaderItem:init(config, world)
	HeaderItem.super.init(self, config, world)

	self._highlight_time = 0
	self._extents = {
		0,
		0
	}
end

function HeaderItem:on_page_enter()
	HeaderItem.super.on_page_enter(self)

	if self.config.on_enter_text then
		self.config.text = self:_try_callback(self.config.callback_object, self.config.on_enter_text, unpack(self.config.on_enter_text_args or {}))
	end
end

function HeaderItem:on_deselect()
	self._selected = false
end

function HeaderItem:is_mouse_inside(mouse_x, mouse_y)
	return mouse_x > self._x and mouse_x < self._x + self._extents[1] and mouse_y > self._y and mouse_y < self._y + self._extents[2]
end

function HeaderItem:update_size(dt, t, gui, layout_settings)
	self.config.text = self.config.text_func and self:_try_callback(self.config.callback_object, self.config.text_func) or self.config.text

	local text = self.config.text or ""

	if not self.config.no_localization then
		text = L(text)
	end

	if not self.config.disabled and self._highlighted and layout_settings.highlight_font then
		local min, max = Gui.text_extents(gui, text, layout_settings.font.font, layout_settings.font_size)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}
		local min, max = Gui.text_extents(gui, text, layout_settings.highlight_font.font, layout_settings.highlight_font_size)
		local highlight_extents = {
			max[1] - min[1],
			max[3] - min[3]
		}
		local diff_y = extents[2] - highlight_extents[2]

		self._extents = highlight_extents
		self._width = highlight_extents[1] + (layout_settings.padding_left or 0) + (layout_settings.padding_right or 0)
		self._height = highlight_extents[2] + (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0) + diff_y
	else
		local min, max = Gui.text_extents(gui, text, layout_settings.font.font, layout_settings.font_size)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}

		self._extents = extents
		self._width = extents[1] + (layout_settings.padding_left or 0) + (layout_settings.padding_right or 0)
		self._height = extents[2] + (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0)
	end
end

function HeaderItem:render_from_child_page()
	return
end

function HeaderItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x + (layout_settings.padding_left or 0) - (layout_settings.padding_right or 0)

	if layout_settings.align == "right" then
		self._x = self._x - self._width
	elseif layout_settings.align == "left" then
		self._x = self._x
	else
		self._x = self._x - self._width * 0.5
	end

	self._y = y - (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0)
	self._z = z or 0
end

function HeaderItem:render(dt, t, gui, layout_settings)
	local color = layout_settings.color and layout_settings.color or {
		255,
		255,
		255,
		255
	}

	if self.config.disabled then
		color = layout_settings.disabled_color and layout_settings.disabled_color or {
			128,
			255,
			255,
			255
		}

		if layout_settings.disabled_color_func then
			color = self:_try_callback(self.config.callback_object, layout_settings.disabled_color_func) or color
		end
	elseif layout_settings.color_func then
		color = self:_try_callback(self.config.callback_object, layout_settings.color_func) or color
	elseif self._highlighted then
		color = layout_settings.highlight_color or {
			255,
			255,
			255,
			255
		}
		color = layout_settings.highlighted_color_func and self:_try_callback(self.config.callback_object, layout_settings.highlighted_color_func) or color
	end

	local font = layout_settings.font
	local font_size = layout_settings.font_size

	if self._highlighted then
		font = layout_settings.highlight_font and layout_settings.highlight_font or font
		font_size = layout_settings.highlight_font_size and layout_settings.highlight_font_size or font_size
	end

	local color = self:_color(color)
	local shadow_color_table = self.config.disabled and layout_settings.drop_shadow_color_disabled or layout_settings.drop_shadow_color
	local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
	local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])

	ScriptGUI.text(gui, self.config.no_localization and self.config.text or L(self.config.text), font.font, font_size, font.material, Vector3(self._x, self._y, self._z), color, shadow_color, shadow_offset)
end

function HeaderItem:_color(c)
	return Color(c[1], c[2], c[3], c[4])
end

function HeaderItem.create_from_config(compiler_data, config, callback_object)
	local item_config = {
		type = "header_item",
		name = config.name,
		text = config.text,
		page = config.page,
		disabled = config.disabled,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		callback_object = callback_object,
		layout_settings = config.layout_settings,
		text_func = config.text_func,
		no_localization = config.no_localization,
		on_enter_text = config.on_enter_text,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_enter_text = config.on_enter_text,
		on_enter_text_args = config.on_enter_text_args or {},
		sounds = config.sounds or MenuSettings.sounds.default.items.header_item
	}

	return HeaderItem:new(item_config, compiler_data.world)
end
