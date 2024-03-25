﻿-- chunkname: @scripts/menu/menu_items/texture_link_button_menu_item.lua

require("scripts/menu/menu_items/menu_item")

TextureLinkButtonMenuItem = class(TextureLinkButtonMenuItem, MenuItem)

function TextureLinkButtonMenuItem:init(config, world)
	TextureLinkButtonMenuItem.super.init(self, config, world)

	self._highlight_multiplier = 0
end

function TextureLinkButtonMenuItem:update_size(dt, t, gui, layout_settings)
	if self._highlighted then
		self._highlight_multiplier = math.clamp(self._highlight_multiplier + dt / layout_settings.highlight_time, 0, layout_settings.highlight_multiplier)
	else
		self._highlight_multiplier = math.clamp(self._highlight_multiplier - dt / layout_settings.highlight_time, 0, layout_settings.highlight_multiplier)
	end

	self._width = layout_settings.texture_width + layout_settings.texture_width * self._highlight_multiplier
	self._height = layout_settings.texture_height + layout_settings.texture_height * self._highlight_multiplier
end

function TextureLinkButtonMenuItem:update_position(dt, t, layout_settings, x, y, z)
	local w, h = Gui.resolution()

	if layout_settings.texture_align == "bottom_left" then
		x = w * (layout_settings.indentation or 0) + (layout_settings.texture_extra_offset or 0)
		y = w * (layout_settings.indentation or 0)
	elseif layout_settings.texture_align == "bottom_right" then
		x = w - w * (layout_settings.indentation or 0) - self._width - (layout_settings.texture_extra_offset or 0)
		y = w * (layout_settings.indentation or 0)
	elseif layout_settings.texture_align == "top_left" then
		x = w * (layout_settings.indentation or 0) + (layout_settings.texture_extra_offset or 0)
		y = h - w * (layout_settings.indentation or 0) - self._height
	elseif layout_settings.texture_align == "top_right" then
		x = w - w * (layout_settings.indentation or 0) - self._width - (layout_settings.texture_extra_offset or 0)
		y = h - w * (layout_settings.indentation or 0) - self._height
	else
		x = x + (layout_settings.texture_extra_offset or 0)
	end

	self._x = x - self._highlight_multiplier * layout_settings.texture_width * 0.5
	self._y = y - self._highlight_multiplier * layout_settings.texture_height * 0.5
	self._z = z
end

function TextureLinkButtonMenuItem:render_from_child_page(dt, t, gui, layout_settings)
	Gui.bitmap(gui, layout_settings.texture, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), Color(128, 128, 128, 128))
end

function TextureLinkButtonMenuItem:render(dt, t, gui, layout_settings)
	Gui.bitmap(gui, layout_settings.texture, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height))
end

function TextureLinkButtonMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "link_button",
		name = config.name,
		page = config.page,
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		disabled = config.disabled,
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		visible_func = config.visible_func and callback(callback_object, config.visible_func, config.visible_func_args),
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		sounds = config.parent_page.config.sounds.items.texture_button
	}

	return TextureLinkButtonMenuItem:new(config, compiler_data.world)
end
