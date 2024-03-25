-- chunkname: @scripts/menu/menu_items/text_box_menu_item.lua

TextBoxMenuItem = class(TextBoxMenuItem, MenuItem)
TextBoxMenuItem.TOP_ROW = 1

function TextBoxMenuItem:init(config, world)
	TextBoxMenuItem.super.init(self, config, world)

	self._scroll_y = TextBoxMenuItem.TOP_ROW
	self._rendered_textrows = 1
end

function TextBoxMenuItem:on_page_enter()
	TextMenuItem.super.on_page_enter(self)

	if self:visible() and self.config.on_enter_text then
		self.config.text = self:_try_callback(self.config.callback_object, self.config.on_enter_text, unpack(self.config.on_enter_text_args or {}))
	end
end

function TextBoxMenuItem:set_text(text)
	self.config.text = text
end

function TextBoxMenuItem:update_size(dt, t, gui, layout_settings)
	if self.config.text then
		self:_update_text_table(self.config.text, gui, layout_settings)
	end

	self._width = layout_settings.width + (layout_settings.padding_left or 0) + (layout_settings.padding_right or 0)

	local height

	if self._text_table then
		height = #self._text_table * layout_settings.line_height + (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0)
	else
		height = 0
	end

	local layout_min = layout_settings.min_height
	local layout_max = layout_settings.max_height
	local min_height = layout_min and math.max(height, layout_min)
	local max_height = layout_max and math.min(min_height or height, layout_max)

	if min_height and min_height == layout_min then
		self._height = min_height
	elseif max_height and max_height == max_height then
		self._height = max_height
	else
		self._height = height
	end

	if layout_settings.can_scroll then
		local height_diff = height - max_height - (layout_settings.padding_bottom or 0) - (layout_settings.padding_top or 0)

		if height_diff < 0 then
			return
		end

		local rendered_textrows = #self._text_table - height_diff / layout_settings.line_height

		self._rendered_textrows = rendered_textrows
	else
		self._rendered_textrows = nil
	end
end

function TextBoxMenuItem:_update_text_table(text, gui, layout_settings)
	local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
	local formatted_text = MenuHelper:format_text(text, gui, font, layout_settings.font_size, layout_settings.width)

	self._text_table = {}

	for i, text in ipairs(formatted_text) do
		local min, max = Gui.text_extents(gui, text, font, layout_settings.font_size)

		self._text_table[i] = {
			width = max[1] - min[1],
			text = text
		}
	end
end

function TextBoxMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z or 1
end

function TextBoxMenuItem:_update_input()
	self._scroll_y = self._scroll_y - Mouse.axis(Mouse.axis_index("wheel")).y
end

function TextBoxMenuItem:get_scroll_data()
	local top_visible_row = self._scroll_y
	local num_visible_rows = self._rendered_textrows
	local total_num_of_rows = self._text_table and #self._text_table

	return top_visible_row, num_visible_rows, total_num_of_rows
end

function TextBoxMenuItem:set_current_row(row)
	local diff = self._scroll_y - row

	self._scroll_y = self._scroll_y - diff
end

function TextBoxMenuItem:render(dt, t, gui, layout_settings)
	if self.config.no_render_outside_screen and MenuHelper.is_outside_screen(self._x, self._y, self._width, self._height, 10) then
		return
	end

	if layout_settings.can_scroll then
		self:_update_input()

		self._scroll_y = math.max(TextBoxMenuItem.TOP_ROW, self._scroll_y)
		self._scroll_y = math.min(self._scroll_y, #self._text_table - self._rendered_textrows + 1)
	end

	if self._text_table and #self._text_table > 0 then
		local y

		if layout_settings.min_height and layout_settings.render_from_top then
			y = self._y + self._height - layout_settings.padding_top
		else
			y = self._y + #self._text_table * layout_settings.line_height + layout_settings.padding_bottom
		end

		local y_offset = layout_settings.line_height
		local color = Color(layout_settings.color[1], layout_settings.color[2], layout_settings.color[3], layout_settings.color[4])
		local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
		local font_material = layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
		local shadow_color_table = self.config.disabled and layout_settings.drop_shadow_color_disabled or layout_settings.drop_shadow_color
		local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
		local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])
		local first_row = self.config.can_scroll and math.floor(self._scroll_y) or 1
		local last_row = self._rendered_textrows and math.min(#self._text_table, self._rendered_textrows + first_row) or #self._text_table

		for i = first_row, last_row do
			local x

			if layout_settings.text_align == "left" then
				x = self._x + (layout_settings.padding_left or 0)
			elseif layout_settings.text_align == "right" then
				x = self._x + self._width - self._text_table[i].width - (layout_settings.padding_right or 0)
			elseif layout_settings.text_align == "center" then
				x = self._x + self._width / 2 - self._text_table[i].width / 2 - (layout_settings.padding_right or 0)
			end

			local text_x = math.floor(x)
			local text_y = self.config.not_pixel_perfect_y and y - y_offset or math.floor(y - y_offset)

			ScriptGUI.text(gui, self._text_table[i].text, font, layout_settings.font_size, font_material, Vector3(text_x, text_y, self._z), color, shadow_color, shadow_offset)

			y_offset = y_offset + layout_settings.line_height
		end
	end
end

function TextBoxMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "text_box",
		page = config.page,
		name = config.name,
		disabled = config.disabled,
		callback_object = callback_object,
		on_enter_text = config.on_enter_text,
		on_enter_text_args = config.on_enter_text_args or {},
		text = config.text and (config.no_localization and config.text or L(config.text)),
		can_scroll = config.can_scroll,
		not_pixel_perfect_y = config.not_pixel_perfect_y,
		no_render_outside_screen = config.no_render_outside_screen,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.parent_page.config.sounds.items.text_box
	}

	return TextBoxMenuItem:new(config, compiler_data.world)
end
