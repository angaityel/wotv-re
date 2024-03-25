-- chunkname: @scripts/menu/menu_items/key_mapping_menu_item.lua

KeyMappingMenuItem = class(KeyMappingMenuItem, MenuItem)

function KeyMappingMenuItem:init(config, world)
	KeyMappingMenuItem.super.init(self, config, world)
	self.config.page:set_key_item(self)
end

local function get_key_locale_name(key, config)
	if not key then
		return ""
	end

	local controller = Managers.input:get_controller(key.controller_type)
	local key_index = controller.button_index(key.key)
	local key_locale_name

	if key.controller_type == "pad" then
		local key_name = L("pad360_" .. key.key)

		if config.prefix then
			local dirty_key_name = DirtyPlayerControllerSettings.shift_function and DirtyPlayerControllerSettings.shift_function.key
			local shift_key_name = dirty_key_name or ActivePlayerControllerSettings.pad360.shift_function.key
			local prefix = L("pad360_" .. shift_key_name)

			key_locale_name = string.format("%s + %s", prefix, key_name)
		else
			key_locale_name = string.format("%s", key_name)
		end
	elseif key.controller_type == "mouse" then
		key_locale_name = string.format("%s %s", "mouse", key.key)
	else
		key_locale_name = controller.button_locale_name(key_index)
	end

	return key_locale_name
end

function KeyMappingMenuItem:update_size(dt, t, gui, layout_settings)
	self:reset_input_state()

	local config = self.config
	local highlighted = true
	local font_size = highlighted and layout_settings.highlight_font_size or layout_settings.font_size
	local font = highlighted and layout_settings.highlight_font and layout_settings.highlight_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local min_selected, max_selected = Gui.text_extents(gui, config.text, font, font_size)

	highlighted = false

	local font_size = highlighted and layout_settings.highlight_font_size or layout_settings.font_size
	local font = highlighted and layout_settings.highlight_font and layout_settings.highlight_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local min, max = Gui.text_extents(gui, config.text, font, font_size)
	local key = config.key_name
	local key_width = 0

	if self:is_using_keyboard() then
		key_width = self:_calculate_key_width_keyboard_mouse(key, gui, font, font_size)
	elseif self:is_using_pad360() then
		key_width = self:_calculate_key_width_pad360(key, layout_settings)
	end

	self._text_extents = {
		max_selected[1] - min_selected[1],
		max_selected[3] - min_selected[3]
	}
	self._diff_x = self._text_extents[1] - (max[1] - min[1])
	self._width = layout_settings.width or self._text_extents[1] + layout_settings.key_name_align + layout_settings.padding_left + key_width
	self._height = self:is_using_pad360() and layout_settings.pad_size or layout_settings.line_height + layout_settings.padding_top + layout_settings.padding_bottom
	self._min_x = min[1]
end

function KeyMappingMenuItem:_calculate_key_width_keyboard_mouse(key_name, gui, font, font_size)
	local config = self.config
	local key = DirtyPlayerControllerSettings[key_name] or ActivePlayerControllerSettings.keyboard_mouse[key_name]
	local key_locale_name = get_key_locale_name(key, config)
	local min_key, max_key = Gui.text_extents(gui, key_locale_name, font, font_size)

	return max_key[1] - min_key[1]
end

function KeyMappingMenuItem:_calculate_key_width_pad360(key_name, layout_settings)
	local key = DirtyPlayerControllerSettings[key_name] or ActivePlayerControllerSettings.pad360[key_name]
	local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(key)
	local pad_size = layout_settings.pad_size
	local config = self.config
	local prefix = config.prefix

	if prefix then
		pad_size = pad_size + layout_settings.pad_size
	end

	return pad_size
end

function KeyMappingMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x - (layout_settings.align == "center" and self._text_extents[1] or 0)
	self._y = y
	self._z = z or 1
end

function KeyMappingMenuItem:_calculate_name_position(layout_settings)
	local name_position = Vector3(math.floor(self._x + layout_settings.padding_left - self._min_x + (not self._highlighted and self._diff_x or 0)), math.floor(self._y + layout_settings.padding_bottom), self._z + 1)

	if layout_settings.text_align == "center" then
		local x = self._x + self._width / 2 - self._text_extents[1] - layout_settings.key_name_align / 2 + (not self._highlighted and self._diff_x or 0)

		name_position = Vector3(math.floor(x), math.floor(self._y + layout_settings.padding_bottom), self._z + 1)
	end

	return name_position
end

function KeyMappingMenuItem:_calculate_key_position(layout_settings, name_position)
	local key_position = name_position + Vector3(layout_settings.key_name_align, 0, 0)

	if layout_settings.text_align == "center" then
		local x = self._x + self._width / 2 + layout_settings.key_name_align / 2

		key_position = Vector3(math.floor(x), math.floor(self._y + layout_settings.padding_bottom), self._z + 1)
	end

	return key_position
end

function KeyMappingMenuItem:render(dt, t, gui, layout_settings)
	self:_render(dt, t, gui, layout_settings, false)
end

function KeyMappingMenuItem:render_from_child_page(dt, t, gui, layout_settings)
	self:_render(dt, t, gui, layout_settings, true)
end

function KeyMappingMenuItem:_render(dt, t, gui, layout_settings, rendered_from_child_page)
	local name_position = self:_calculate_name_position(layout_settings)
	local key_position = self:_calculate_key_position(layout_settings, name_position)

	self:_render_name(dt, t, gui, layout_settings, rendered_from_child_page, name_position)

	if self:is_using_keyboard() then
		self:_render_key_keyboard(dt, t, gui, layout_settings, rendered_from_child_page, key_position)
	elseif self:is_using_pad360() then
		self:_render_key_360(dt, t, gui, layout_settings, rendered_from_child_page, key_position)
	end
end

function KeyMappingMenuItem:_render_name(dt, t, gui, layout_settings, rendered_from_child_page, name_position)
	local config = self.config
	local font_size = self._highlighted and layout_settings.highlight_font_size and layout_settings.highlight_font_size or layout_settings.font_size

	self:_render_text(dt, t, gui, layout_settings, rendered_from_child_page, name_position, config.text, font_size)
end

function KeyMappingMenuItem:_render_key_keyboard(dt, t, gui, layout_settings, rendered_from_child_page, key_position)
	local config = self.config
	local font_size = self._highlighted and layout_settings.highlight_font_size and layout_settings.highlight_font_size or layout_settings.font_size
	local key = DirtyPlayerControllerSettings[config.key_name] or ActivePlayerControllerSettings.keyboard_mouse[config.key_name]
	local key_name = get_key_locale_name(key, config)

	self:_render_text(dt, t, gui, layout_settings, rendered_from_child_page, key_position, key_name, font_size)
end

function KeyMappingMenuItem:_render_key_360(dt, t, gui, layout_settings, rendered_from_child_page, key_position)
	local config = self.config
	local font_size = self._highlighted and layout_settings.highlight_font_size and layout_settings.highlight_font_size or layout_settings.font_size
	local position = key_position

	if config.prefix then
		local prefix_key = DirtyPlayerControllerSettings.shift_function or ActivePlayerControllerSettings.pad360.shift_function
		local prefix_key_name = prefix_key.key

		if X360Buttons[prefix_key_name] then
			self:_render_key_as_360_button(dt, t, gui, layout_settings, rendered_from_child_page, position, prefix_key_name)
		else
			self:_render_text(dt, t, gui, layout_settings, rendered_from_child_page, position, prefix_key_name, font_size)
		end

		position.x = position.x + layout_settings.pad_size
	end

	local key = DirtyPlayerControllerSettings[config.key_name] or ActivePlayerControllerSettings.pad360[config.key_name]
	local key_name = key.key

	if X360Buttons[key_name] then
		self:_render_key_as_360_button(dt, t, gui, layout_settings, rendered_from_child_page, position, key_name)
	else
		self:_render_text(dt, t, gui, layout_settings, rendered_from_child_page, position, key_name, font_size)
	end
end

function KeyMappingMenuItem:_render_text(dt, t, gui, layout_settings, rendered_from_child_page, position, key, font_size)
	local c = self._highlighted and layout_settings.color_highlighted or rendered_from_child_page and layout_settings.color_render_from_child_page or layout_settings.color
	local color = Color(c[1], c[2], c[3], c[4])
	local shadow_color_table = layout_settings.drop_shadow_color
	local shadow_color = (self._highlighted or not rendered_from_child_page) and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
	local shadow_offset = Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])
	local font = layout_settings.pad_font and layout_settings.pad_font.font or MenuSettings.fonts.menu_font.font
	local font_material = layout_settings.pad_font and layout_settings.pad_font.material or MenuSettings.fonts.menu_font.material

	if self:is_using_pad360() then
		position.y = position.y + font_size / 2
	end

	ScriptGUI.text(gui, key, font, font_size, font_material, position, color, shadow_color, shadow_offset)
end

function KeyMappingMenuItem:_render_key_as_360_button(dt, t, gui, layout_settings, rendered_from_child_page, key_position, key)
	local pad_size = layout_settings.pad_size
	local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(key, true)
	local c = self._highlighted and layout_settings.color_highlighted or rendered_from_child_page and layout_settings.color_render_from_child_page or layout_settings.color
	local color = Color(c[1], c[2], c[3], c[4])

	Gui.bitmap_uv(gui, material, uv00, uv11, key_position, Vector2(pad_size, pad_size), color)
end

function KeyMappingMenuItem:is_using_keyboard()
	self._is_using_keyboard = self._is_using_keyboard or Managers.input:active_mapping(1) == "keyboard_mouse"

	return self._is_using_keyboard
end

function KeyMappingMenuItem:is_using_pad360()
	self._is_using_pad_360 = self._is_using_pad_360 or Managers.input:active_mapping(1) == "pad360"

	return self._is_using_pad_360
end

function KeyMappingMenuItem:reset_input_state()
	self._is_using_keyboard = nil
	self._is_using_pad_360 = nil
end

function KeyMappingMenuItem:on_select(ignore_sound)
	KeyMappingMenuItem.super.on_select(self, ignore_sound)

	self._selected = true
end

function KeyMappingMenuItem:on_deselect()
	self._selected = false
end

function KeyMappingMenuItem:key_name()
	return self.config.key_name
end

function KeyMappingMenuItem:keys()
	return self.config.keys
end

function KeyMappingMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "key_mapping",
		page = config.page,
		disabled = config.disabled,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func),
		visible_func = config.visible_func and callback(callback_object, config.visible_func, config.keys[1]),
		prefix = config.prefix,
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		text = L(config.text),
		key_name = config.keys[1],
		keys = config.keys,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.parent_page.config.sounds.items.key_mapping
	}

	return KeyMappingMenuItem:new(config, compiler_data.world)
end
