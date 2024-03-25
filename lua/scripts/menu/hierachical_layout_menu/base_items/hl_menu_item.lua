-- chunkname: @scripts/menu/hierachical_layout_menu/base_items/hl_menu_item.lua

HLMenuItem = class(HLMenuItem, HLMenuComponent)

function HLMenuItem:init(world, config)
	HLMenuItem.super.init(self, world, config)

	self._highlighted = false
end

function HLMenuItem:has_components()
	return false
end

function HLMenuItem:on_highlight()
	self._highlighted = true

	local config = self.config

	self:_try_callback(config.callback_object, config.on_highlight, unpack(config.on_highlight_args or {}))

	if config.sounds and config.sounds.hover then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, config.sounds.hover)
	end
end

function HLMenuItem:on_lowlight()
	self._highlighted = false
end

function HLMenuItem:on_select()
	local config = self.config

	self:_try_callback(config.callback_object, config.on_select, unpack(config.on_select_args or {}))

	if config.sounds and config.sounds.select then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, config.sounds.select)
	end
end

function HLMenuItem:calculate_highlighted_item(mouse_x, mouse_y)
	if self:is_mouse_inside(mouse_x, mouse_y) and self:highlightable() then
		return self
	end

	return nil
end

function HLMenuItem:highlightable()
	local config = self.config

	return self:_try_callback(config.callback_object, config.highlightable_func)
end

function HLMenuItem:_color()
	local config = self.config
	local layout_settings = self:layout_settings()
	local color = self:_try_callback(config.callback_object, config.color_func)

	color = color or self:default_colour()
	color = self._highlighted and layout_settings.highlighted_color or color

	return color
end

function HLMenuItem:default_colour()
	local layout_settings = self:layout_settings()

	return layout_settings.color
end

function HLMenuItem:_try_callback(callback_object, callback_name, ...)
	if callback_object and callback_name and callback_object[callback_name] then
		fassert(self:name(), "trying to call callback function %q with a menu component without a name", callback_name)

		return callback_object[callback_name](callback_object, self:name(), self:namespace_path(), ...)
	end
end
