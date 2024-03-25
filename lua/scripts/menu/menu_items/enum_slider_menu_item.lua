-- chunkname: @scripts/menu/menu_items/enum_slider_menu_item.lua

EnumSliderMenuItem = class(EnumSliderMenuItem, MenuItem)

function EnumSliderMenuItem:init(config, world)
	EnumSliderMenuItem.super.init(self, config, world)

	if self:visible() and self.config.on_init_options then
		local entries, selection = self:_try_callback(self.config.callback_object, self.config.on_init_options)

		self._selection = selection
		self.config.entries = entries
		self.config.selected_entry = self.config.entries[self._selection]

		self:_calc_min_max_value()
	end

	self._text_extents = {
		0,
		0
	}
end

function EnumSliderMenuItem:_calc_min_max_value()
	local max_value = 0
	local min_value = math.huge

	for i = 1, #self.config.entries do
		if max_value < self.config.entries[i].value then
			max_value = self.config.entries[i].value
		end

		if min_value > self.config.entries[i].value then
			min_value = self.config.entries[i].value
		end
	end

	self._min_value = min_value
	self._max_value = max_value
end

function EnumSliderMenuItem:update_size(dt, t, gui, layout_settings)
	local config = self.config
	local font = self._highlighted and layout_settings.highlight_font and layout_settings.highlight_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_size = self._highlighted and layout_settings.highlight_font_size or layout_settings.font_size
	local min, max = Gui.text_extents(gui, config.text, font, font_size)

	self._text_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	self._width = max[1] - min[1] + (layout_settings.padding_left or 0) + (layout_settings.padding_right or 0)
	self._height = (layout_settings.line_height or max[3] - min[3]) + (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0)
end

function EnumSliderMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function EnumSliderMenuItem:is_mouse_inside(mouse_x, mouse_y, mouse_down)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local slider_extra_highlight_size_x = layout_settings.slider_extra_highlight_size_x or 0
	local slider_extra_highlight_size_y = layout_settings.slider_extra_highlight_size_y or 0
	local pos = self:_slider_position()
	local width = layout_settings.slider_size[1] + slider_extra_highlight_size_x
	local height = layout_settings.slider_size[2] + slider_extra_highlight_size_y

	pos[1] = pos[1] - slider_extra_highlight_size_x * 0.5
	pos[2] = pos[2] - slider_extra_highlight_size_y * 0.5

	if self._mouse_down and (mouse_down and mouse_down == 1 or false) then
		self:on_update_slider({
			mouse_x,
			mouse_y
		})
	elseif self._mouse_down and mouse_down and mouse_down < 1 then
		self._mouse_down = false

		local new_entry = self.config.entries[self._selection]

		self:_update_and_notify_value(new_entry)

		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end

	return mouse_x > pos[1] and mouse_x < pos[1] + width and mouse_y > pos[2] and mouse_y < pos[2] + height
end

function EnumSliderMenuItem:render(dt, t, gui, layout_settings)
	local config = self.config
	local color = config.disabled and layout_settings.color_disabled or self._highlighted and layout_settings.highlight_color or layout_settings.color
	local font = self._highlighted and layout_settings.highlight_font and layout_settings.highlight_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_material = self._highlighted and layout_settings.highlight_font and layout_settings.highlight_font.material or layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
	local font_size = self._highlighted and layout_settings.highlight_font_size or layout_settings.font_size
	local shadow_color_table = self.config.disabled and layout_settings.drop_shadow_color_disabled or layout_settings.drop_shadow_color
	local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
	local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])
	local pos = Vector3(self._x - self._width * 0.5 + (layout_settings.padding_left or 0), self._y + (layout_settings.padding_bottom or 0), self._z + 1)

	ScriptGUI.text(gui, config.text, font, font_size, font_material, pos, Color(color[1], color[2], color[3], color[4]), shadow_color, shadow_offset)

	local config = self.config
	local min, max = Gui.text_extents(gui, config.text, font, font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[1]
	}
	local rect_pos = self:_slider_position()

	Gui.rect(gui, rect_pos, Vector2(layout_settings.slider_size[1], layout_settings.slider_size[2]), Color(255, 90, 90, 90))
	MenuHelper:render_border(gui, {
		rect_pos[1],
		rect_pos[2],
		layout_settings.slider_size[1],
		layout_settings.slider_size[2]
	}, 2, Color(255, 0, 0, 0))

	local selected_entry = tonumber(self.config.entries[self._selection].value)
	local percentage = (selected_entry - self._min_value) / (self._max_value - self._min_value)

	Gui.rect(gui, rect_pos, Vector2(layout_settings.slider_size[1] * percentage, layout_settings.slider_size[2]))
end

function EnumSliderMenuItem:select_entry_by_key(entry_key)
	local selection

	for key, value in ipairs(self.config.entries) do
		if entry_key == value.key then
			selection = key

			break
		end
	end

	self._selection = selection

	local new_entry = self.config.entries[selection]

	self:_update_and_notify_value(new_entry)
end

function EnumSliderMenuItem:on_update_slider(mouse_pos)
	local _, closest_key = self:_closest_value(mouse_pos[1])
	local selected_key

	for key, entry in ipairs(self.config.entries) do
		if key == closest_key then
			selected_key = key

			break
		end
	end

	if selected_key then
		self._selection = selected_key
	end
end

function EnumSliderMenuItem:_closest_value(position_x)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local slider_pos = self:_slider_position()
	local width = layout_settings.slider_size[1]
	local percentage = math.clamp((position_x - slider_pos[1]) / width, 0, 1)
	local value = self._min_value + (self._max_value - self._min_value) * percentage
	local current_delta = math.huge
	local closest_key, closest_value
	local entries = self.config.entries
	local num_entries = #entries

	for i = 1, num_entries do
		local entry = entries[i]
		local delta = math.abs(entry.value - value)

		if delta < current_delta then
			closest_key = i
			closest_value = entry.value
			current_delta = delta
		end
	end

	return closest_value, closest_key
end

function EnumSliderMenuItem:_slider_position()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x = self._x - self._width * 0.5 + (layout_settings.padding_left or 0) + self._text_extents[1] + layout_settings.spacing
	local y = self._y + (layout_settings.padding_bottom or 0) + ((layout_settings.line_height or self._text_extents[2]) * 0.3 - layout_settings.slider_size[2] * 0.5)

	return Vector3(x, y, self._z)
end

function EnumSliderMenuItem:on_move_left()
	self._selection = self._selection and math.max(self._selection - GameSettingsDevelopment.enum_slider_move_value, 1)
end

function EnumSliderMenuItem:on_move_right()
	self._selection = self._selection and math.min(self._selection + GameSettingsDevelopment.enum_slider_move_value, #self.config.entries)
end

function EnumSliderMenuItem:on_left_click()
	self._mouse_down = true
end

function EnumSliderMenuItem:on_page_enter()
	EnumSliderMenuItem.super.on_page_enter(self)

	if self:visible() and self.config.on_enter_options then
		local entries, selection = self:_try_callback(self.config.callback_object, self.config.on_enter_options)

		self._selection = selection
		self.config.entries = entries
		self.config.selected_entry = self.config.entries[self._selection]

		self:_calc_min_max_value()
	end
end

function EnumSliderMenuItem:_update_and_notify_value(new_entry)
	if self.config.selected_entry ~= new_entry then
		self:_try_callback(self.config.callback_object, self.config.on_option_changed, new_entry)
	end

	self.config.selected_entry = new_entry
end

function EnumSliderMenuItem:notify_value(...)
	self:_try_callback(self.config.callback_object, self.config.on_option_changed, self.config.selected_entry, ...)
end

function EnumSliderMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "enum",
		page = config.page,
		name = config.name,
		disabled = config.disabled,
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_init_options = config.on_init_options,
		on_enter_options = config.on_enter_options,
		on_option_changed = config.on_option_changed,
		values = config.values,
		text = config.no_localization and config.text or L(config.text) .. ": ",
		tooltip_text = config.tooltip_text,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.parent_page.config.sounds.items.enum
	}

	return EnumSliderMenuItem:new(config, compiler_data.world)
end
