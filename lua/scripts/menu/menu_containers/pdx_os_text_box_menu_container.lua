-- chunkname: @scripts/menu/menu_containers/pdx_os_text_box_menu_container.lua

require("scripts/menu/menu_containers/text_box_menu_container")

PdxOsTextBoxMenuContainer = class(PdxOsTextBoxMenuContainer, TextBoxMenuContainer)

function PdxOsTextBoxMenuContainer:init()
	PdxOsTextBoxMenuContainer.super.init(self)
end

function PdxOsTextBoxMenuContainer:render(dt, t, gui, layout_settings)
	if self._text then
		local y = self._y + (layout_settings.padding_bottom or 0)
		local y_offset = 0
		local color = Color(layout_settings.color[1], layout_settings.color[2], layout_settings.color[3], layout_settings.color[4])
		local font = layout_settings.font and layout_settings.font.font or MenuSettings.fonts.menu_font.font
		local font_material = layout_settings.font and layout_settings.font.material or MenuSettings.fonts.menu_font.material
		local shadow_color_table = layout_settings.drop_shadow_color
		local shadow_color = shadow_color_table and Color(shadow_color_table[1], shadow_color_table[2], shadow_color_table[3], shadow_color_table[4])
		local shadow_offset = layout_settings.drop_shadow_offset and Vector2(layout_settings.drop_shadow_offset[1], layout_settings.drop_shadow_offset[2])

		for i = 1, #self._text do
			local x

			if layout_settings.text_align == "left" then
				x = self._x + (layout_settings.padding_left or 0)
			elseif layout_settings.text_align == "right" then
				x = self._x + self._width - self._text[i].width - (layout_settings.padding_right or 0)
			elseif layout_settings.text_align == "center" then
				x = self._x + self._width * 0.5 - self._text[i].width * 0.5 - (layout_settings.padding_right or 0)
			end

			ScriptGUI.text(gui, self._text[i].text, font, layout_settings.font_size, font_material, Vector3(math.floor(x), math.floor(y - y_offset), self._z), color, shadow_color, shadow_offset)

			y_offset = y_offset + layout_settings.line_height
		end

		if layout_settings.background_rect then
			local c = layout_settings.background_color
			local color = Color(c[1], c[2], c[3], c[4])
			local size = Vector2(layout_settings.background_width, layout_settings.line_height * #self._text + (layout_settings.background_height_bottom_padding or 0))
			local position = Vector3(math.floor(self._x + layout_settings.background_rect_offset_x), math.floor(self._y - size[2] + layout_settings.line_height + layout_settings.background_rect_offset_y), self._z - 2)

			Gui.rect(gui, position, size, color)

			if layout_settings.render_border then
				local c = layout_settings.border_color
				local color = Color(c[1], c[2], c[3], c[4])

				MenuHelper:render_border(gui, {
					position[1],
					position[2],
					size[1],
					size[2]
				}, layout_settings.border_size, color, position[3] + 1)
			end
		end
	end
end

function PdxOsTextBoxMenuContainer.create_from_config()
	return PdxOsTextBoxMenuContainer:new()
end
