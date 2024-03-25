-- chunkname: @scripts/menu/menu_items/selectable_text_input_menu_item.lua

SelectableTextInputMenuItem = class(SelectableTextInputMenuItem, TextInputMenuItem)

function SelectableTextInputMenuItem:init(config, world)
	SelectableTextInputMenuItem.super.init(self, config, world)

	self._border_rect = {}
	self._selected = false
end

function SelectableTextInputMenuItem:selected()
	return self._selected
end

function SelectableTextInputMenuItem:on_select()
	SelectableTextInputMenuItem.super.on_select(self)

	self._selected = true
end

function SelectableTextInputMenuItem:on_deselect()
	SelectableTextInputMenuItem.super.on_deselect(self)

	self._selected = false
end

function SelectableTextInputMenuItem:on_page_exit()
	self._selected = false
end

function SelectableTextInputMenuItem:update_size(dt, t, gui, layout_settings)
	if self._selected then
		self:_update_input_text()
	end

	if layout_settings.hidden then
		local text_length = string.len(self._text)

		self._hidden_text = string.rep("*", text_length)
	end

	local text = layout_settings.hidden and self._hidden_text or self._text
	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local min, max = Gui.text_extents(gui, text, font, layout_settings.font_size)

	self._text_width = max[1] - min[1]
	self._text_height = max[3] - min[3]

	local char_from
	local char_to = 1
	local length = 0

	for i = 1, self._input_index - 1 do
		char_from, char_to = Utf8.location(text, char_to)
		length = length + (char_to - char_from)
	end

	local marker_text = string.sub(text, 1, length)
	local min, max = Gui.text_extents(gui, marker_text, font, layout_settings.font_size)

	self._marker_offset_x = max[1] - min[1]
	self._width = layout_settings.width or self._text_width
	self._height = layout_settings.height or self._text_height
end

function SelectableTextInputMenuItem:render(dt, t, gui, layout_settings)
	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local font_material = layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
	local c = layout_settings.text_color
	local color = Color(c[1], c[2], c[3], c[4])
	local x, y = MenuHelper:align_text(self._x, self._y, self._text_width, self._text_height, layout_settings.text_alignement_x, layout_settings.text_alignement_y)

	x = x + (layout_settings.text_offset_x or 0)
	y = y + (layout_settings.text_offset_y or 0)

	if layout_settings.confine_settings then
		self:_confine_text(x, self._text_width, layout_settings)

		x = self._current_confine_position
	end

	local text = layout_settings.hidden and self._hidden_text or self._text

	ScriptGUI.text(gui, text, font, layout_settings.font_size, font_material, Vector3(math.floor(x), math.floor(y), self._z + 1), color)

	if layout_settings.masked then
		self:_render_mask(gui, dt, t, layout_settings)
	end

	if self._selected then
		self:_render_marker(gui, dt, t, x, y, layout_settings)
	end

	if layout_settings.border then
		local border_settings = layout_settings.border
		local c = border_settings.color
		local border_color = Color(c[1], c[2], c[3], c[4])

		self._border_rect[1] = self._x
		self._border_rect[2] = self._y
		self._border_rect[3] = self._width
		self._border_rect[4] = self._height

		MenuHelper:render_border(gui, self._border_rect, border_settings.thickness, border_color, self._z)
	end
end

function SelectableTextInputMenuItem:_confine_text(x, text_width, layout_settings)
	local confine_width = layout_settings.confine_settings.width

	self._current_confine_position = self._current_confine_position or x

	if confine_width < text_width then
		local marker_position = self._current_confine_position + self._marker_offset_x - layout_settings.marker_width / 2 + (layout_settings.marker_offset_x or 0)

		if marker_position < x then
			local delta = x - marker_position

			self._current_confine_position = self._current_confine_position + delta
		elseif marker_position > x + confine_width then
			local delta = marker_position - (x + confine_width)

			self._current_confine_position = self._current_confine_position - delta
		end
	else
		self._current_confine_position = x
	end
end

function SelectableTextInputMenuItem:_render_mask(gui, dt, t, layout_settings)
	local w, h = Application.resolution()

	Gui.bitmap(gui, "mask_rect_alpha", Vector3(0, 0, 0), Vector2(w, h), Color(0, 0, 0, 0))

	local pos = Vector3(self._x, self._y, 800)
	local size = Vector2(self._width, self._height)

	Gui.bitmap(gui, "mask_rect_alpha", pos, size, Color(255, 255, 255, 255))
end

function SelectableTextInputMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "selectable_text_input",
		page = config.page,
		name = config.name,
		disabled = config.disabled,
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_enter_text = config.on_enter_text,
		on_enter_text_args = config.on_enter_text_args or {},
		min_text_length = config.min_text_length or 0,
		max_text_length = config.max_text_length or math.huge,
		toggle_selection = config.toggle_selection,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.parent_page.config.sounds.items.text_input,
		needs_highlight = config.needs_highlight
	}

	return SelectableTextInputMenuItem:new(config, compiler_data.world)
end
