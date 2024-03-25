-- chunkname: @scripts/menu/hierachical_layout_menu/base_items/hl_text_menu_item.lua

HLTextMenuItem = class(HLTextMenuItem, HLMenuItem)

function HLTextMenuItem:init(world, config)
	HLTextMenuItem.super.init(self, world, config)
end

function HLTextMenuItem:calculate_width(dt, t, gui, parent)
	local layout_settings = self:layout_settings()
	local text = self:_text()
	local width_policy = self:width_policy()
	local font = layout_settings.font
	local scale = layout_settings.scale
	local font_size = font.size * scale
	local min, max = Gui.text_extents(gui, text, font.font, font_size)
	local width

	if width_policy == "defined" then
		width = layout_settings.width
	elseif width_policy == "auto" then
		width = max[1] - min[1]
	end

	fassert(width, "Invalid width policy %q or width value %q : in text menu item %q", width_policy, width, self:name())

	return width
end

function HLTextMenuItem:calculate_height(dt, t, gui, parent)
	local layout_settings = self:layout_settings()
	local height_policy = self:height_policy()
	local font = layout_settings.font
	local scale = layout_settings.scale
	local height

	if height_policy == "defined" then
		height = layout_settings.height
	elseif height_policy == "auto" then
		height = font.base_size
	end

	fassert(height, "Invalid height policy %q or height value %q : in text menu item %q", height_policy, height, self:name())

	return height * scale
end

function HLTextMenuItem:render(dt, t, gui)
	HLTextMenuItem.super.render(self, dt, t, gui)

	local layout_settings = self:layout_settings()
	local color = self:_color()
	local text = self:_text()
	local font = layout_settings.font
	local scale = layout_settings.scale
	local font_size = font.size * self:_highlighted_scale()

	if layout_settings.truncate_text then
		text = self:_truncate_text(gui, text, font, font_size, self._width, "...")
	end

	local x = self:x() - self:_highlighted_offset_x(gui, text, font, scale) + self:_text_alignment_offset(gui, text, font)
	local y = self:y() + self:height() * 0.5 - font.base_size * 0.5 - self:_highlighted_offset_y(gui, text, font, scale)
	local z = self:z()
	local position = Vector3(x, y, z)

	ScriptGUI.text(gui, text, font.font, font_size, font.material, position, MenuHelper:color(color))
end

function HLTextMenuItem:_text()
	local config = self.config
	local layout_settings = self:layout_settings()
	local text = self:_try_callback(config.callback_object, config.text_func)

	text = text or layout_settings.text
	text = layout_settings.localize_text and L(text) or text

	return text
end

function HLTextMenuItem:_truncate_text(gui, text, font, font_size, max_width, crop_suffix)
	return HUDHelper:crop_text(gui, text, font.font, font_size, max_width, crop_suffix)
end

function HLTextMenuItem:_highlighted_offset_x(gui, text, font, scale)
	local layout_settings = self:layout_settings()
	local default_min, default_max = Gui.text_extents(gui, text, font.font, font.size * scale)
	local default_width = default_max[1] - default_min[1]
	local highlighted_scale = self:_highlighted_scale()
	local highlighted_min, highlighted_max = Gui.text_extents(gui, text, font.font, font.size * highlighted_scale)
	local highlighted_width = highlighted_max[1] - highlighted_min[1]

	return (highlighted_width - default_width) * 0.5
end

function HLTextMenuItem:_highlighted_offset_y(gui, text, font, scale)
	local default_height = font.base_size * scale
	local highlighted_scale = self:_highlighted_scale()
	local highlighted_height = font.base_size * highlighted_scale

	return (highlighted_height - default_height) * 0.5
end

function HLTextMenuItem:_highlighted_scale()
	local layout_settings = self:layout_settings()

	return self._highlighted and layout_settings.highlighted_scale or layout_settings.scale
end

function HLTextMenuItem:_text_alignment_offset(gui, text, font)
	local layout_settings = self:layout_settings()
	local text_alignment = layout_settings.text_alignment
	local min, max = Gui.text_extents(gui, text, font.font, font.size)
	local width = max[1] - min[1]
	local offset = 0

	if text_alignment == "center" then
		offset = self:width() * 0.5 - width * 0.5
	end

	return offset
end

function HLTextMenuItem.create_from_config(world, config, callback_object)
	config.callback_object = callback_object

	return HLTextMenuItem:new(world, config)
end
