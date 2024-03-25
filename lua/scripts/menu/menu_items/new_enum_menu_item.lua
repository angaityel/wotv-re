-- chunkname: @scripts/menu/menu_items/new_enum_menu_item.lua

NewEnumMenuItem = class(NewEnumMenuItem, MenuItem)

function NewEnumMenuItem:init(config, world)
	NewEnumMenuItem.super.init(self, config, world)

	if self:visible() and self.config.on_init_options then
		local entries, selection = self:_try_callback(self.config.callback_object, self.config.on_init_options)

		self._selection = selection
		self.config.entries = entries
		self.config.selected_entry = self.config.entries[self._selection]
	end

	self._extents = {
		0,
		0
	}
	self._total_width = 0
end

function NewEnumMenuItem:update_size(dt, t, gui, layout_settings)
	local config = self.config
	local font_size = self._highlighted and layout_settings.highlighted_font_size or layout_settings.font_size
	local font = self._highlighted and layout_settings.highlighted_font and layout_settings.highlighted_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local min, max = Gui.text_extents(gui, config.text, font, font_size)

	self._extents = {
		max[1] - min[1],
		max[3] - min[1]
	}

	local min, max = Gui.text_extents(gui, self.config.entries[self._selection].value, font, font_size)
	local value_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}

	self._total_width = self._extents[1] + (layout_settings.spacing or 0) + value_extents[1]
	self._width = 0
	self._height = layout_settings.line_height + layout_settings.padding_top + layout_settings.padding_bottom
end

function NewEnumMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function NewEnumMenuItem:is_mouse_inside(mouse_x, mouse_y)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x = math.floor(self._x + layout_settings.padding_left) - self._extents[1]

	return x < mouse_x and mouse_x < x + self._total_width and mouse_y > self._y and mouse_y < self._y + self._extents[2]
end

function NewEnumMenuItem:render(dt, t, gui, layout_settings)
	local config = self.config
	local color = config.disabled and layout_settings.color_disabled or self._highlighted and layout_settings.color_highlighted or layout_settings.color
	local font = self._highlighted and layout_settings.highlighted_font and layout_settings.highlighted_font.font or layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_material = self._highlighted and layout_settings.highlighted_font and layout_settings.highlighted_font.material or layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
	local font_size = self._highlighted and layout_settings.highlighted_font_size or layout_settings.font_size
	local shadow_color_table = self.config.disabled and layout_settings.drop_shadow_color_disabled or layout_settings.drop_shadow_color
	local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
	local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])

	ScriptGUI.text(gui, config.text, font, font_size, font_material, Vector3(math.floor(self._x + layout_settings.padding_left) - self._extents[1], math.floor(self._y + layout_settings.padding_bottom), self._z + 1), Color(color[1], color[2], color[3], color[4]), shadow_color, shadow_offset)

	if layout_settings.checkbox then
		local pos = Vector3(math.floor(self._x + layout_settings.padding_left) + layout_settings.spacing, math.floor(self._y + layout_settings.padding_bottom), self._z + 1)

		Gui.rect(gui, pos, Vector2(layout_settings.checkbox_size[1], layout_settings.checkbox_size[2]), MenuHelper:color(layout_settings.checkbox_bg_color))
		MenuHelper:render_border(gui, {
			pos[1],
			pos[2],
			layout_settings.checkbox_size[1],
			layout_settings.checkbox_size[2]
		}, layout_settings.border_thickness, Color(255, 0, 0, 0))

		if self.config.entries[self._selection].key == true then
			Gui.rect(gui, pos, Vector2(layout_settings.checkbox_size[1], layout_settings.checkbox_size[2]), MenuHelper:color(layout_settings.checkbox_checked_color))
		end
	else
		local value = self.config.entries[self._selection].value

		ScriptGUI.text(gui, value, font, font_size, font_material, Vector3(math.floor(self._x + layout_settings.padding_left) + layout_settings.spacing, math.floor(self._y + layout_settings.padding_bottom), self._z + 1), Color(color[1], color[2], color[3], color[4]), shadow_color, shadow_offset)
	end
end

function NewEnumMenuItem:select_entry_by_key(entry_key)
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

function NewEnumMenuItem:on_left_click(ignore_sound)
	self:on_move_right()

	if not ignore_sound then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end
end

function NewEnumMenuItem:on_right_click(ignore_sound)
	self:on_move_left()

	if not ignore_sound then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end
end

function NewEnumMenuItem:on_select(ignore_sound)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if layout_settings.checkbox then
		self._selection = self._selection == 1 and 2 or 1

		local new_entry = self.config.entries[self._selection]

		self:_update_and_notify_value(new_entry)
	end

	if not ignore_sound then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end
end

function NewEnumMenuItem:on_move_left()
	self._selection = self._selection - 1

	if self._selection == 0 then
		self._selection = #self.config.entries
	end

	local new_entry = self.config.entries[self._selection]

	self:_update_and_notify_value(new_entry)
end

function NewEnumMenuItem:on_move_right()
	self._selection = self._selection + 1

	if self._selection > #self.config.entries then
		self._selection = 1
	end

	local new_entry = self.config.entries[self._selection]

	self:_update_and_notify_value(new_entry)
end

function NewEnumMenuItem:on_page_enter()
	NewEnumMenuItem.super.on_page_enter(self)

	if self:visible() and self.config.on_enter_options then
		local entries, selection = self:_try_callback(self.config.callback_object, self.config.on_enter_options)

		self._selection = selection
		self.config.entries = entries
		self.config.selected_entry = self.config.entries[self._selection]
	end
end

function NewEnumMenuItem:_update_and_notify_value(new_entry)
	if self.config.selected_entry ~= new_entry then
		self:_try_callback(self.config.callback_object, self.config.on_option_changed, new_entry)
	end

	self.config.selected_entry = new_entry
end

function NewEnumMenuItem:notify_value(...)
	self:_try_callback(self.config.callback_object, self.config.on_option_changed, self.config.selected_entry, ...)
end

function NewEnumMenuItem.create_from_config(compiler_data, config, callback_object)
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

	return NewEnumMenuItem:new(config, compiler_data.world)
end
