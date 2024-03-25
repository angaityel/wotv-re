-- chunkname: @scripts/menu/menu_items/arrow_menu_item.lua

require("scripts/menu/menu_items/menu_item")

ArrowMenuItem = class(ArrowMenuItem, MenuItem)

function ArrowMenuItem:init(config, world)
	ArrowMenuItem.super.init(self, config, world)
end

function ArrowMenuItem:update_size(dt, t, gui, layout_settings)
	self._width = layout_settings.arrow_size_x
	self._height = layout_settings.arrow_size_y

	ArrowMenuItem.super.update_size(self, dt, t, gui)
end

function ArrowMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x + (layout_settings.offset_x or 0)
	self._y = y + (layout_settings.offset_y or 0)
	self._z = z

	ArrowMenuItem.super.update_position(self, dt, t)
end

function ArrowMenuItem:render_from_child_page(dt, t, gui, layout_settings)
	return
end

function ArrowMenuItem:start_pulse(speed)
	self._pulse = {
		speed = speed
	}
end

function ArrowMenuItem:stop_pulse()
	self._pulse = nil
end

function ArrowMenuItem:pulse()
	return self._pulse
end

function ArrowMenuItem:render(dt, t, gui, layout_settings)
	local pulse_color_multiplier = self._pulse and 0.5 * math.cos(t * self._pulse.speed) + 0.5 or 1
	local center = Vector3(self._x + layout_settings.arrow_size_x * 0.5, self._z, self._y + layout_settings.arrow_size_y * 0.5)
	local pos1, pos2, pos3, shadow1, shadow2, shadow3

	if layout_settings.arrow_facing == "left" then
		pos1 = center + Vector3(-layout_settings.arrow_size_x * 0.5, 0, 0)
		pos2 = center + Vector3(layout_settings.arrow_size_x * 0.5, 0, -layout_settings.arrow_size_y * 0.5)
		pos3 = center + Vector3(layout_settings.arrow_size_x * 0.5, 0, layout_settings.arrow_size_y * 0.5)

		if layout_settings.drop_shadow then
			shadow1 = pos1 + Vector3(-layout_settings.drop_shadow_offset[1], 0, 0)
			shadow2 = pos2 + Vector3(layout_settings.drop_shadow_offset[1] * 0.5, 0, -layout_settings.drop_shadow_offset[2])
			shadow3 = pos3 + Vector3(layout_settings.drop_shadow_offset[1] * 0.5, 0, layout_settings.drop_shadow_offset[2])
		end
	elseif layout_settings.arrow_facing == "right" then
		pos1 = center + Vector3(layout_settings.arrow_size_x * 0.5, 0, 0)
		pos2 = center + Vector3(-layout_settings.arrow_size_x * 0.5, 0, -layout_settings.arrow_size_y * 0.5)
		pos3 = center + Vector3(-layout_settings.arrow_size_x * 0.5, 0, layout_settings.arrow_size_y * 0.5)

		if layout_settings.drop_shadow then
			shadow1 = pos1 + Vector3(layout_settings.drop_shadow_offset[1], 0, 0)
			shadow2 = pos2 + Vector3(-layout_settings.drop_shadow_offset[1] * 0.5, 0, -layout_settings.drop_shadow_offset[2])
			shadow3 = pos3 + Vector3(-layout_settings.drop_shadow_offset[1] * 0.5, 0, layout_settings.drop_shadow_offset[2])
		end
	elseif layout_settings.arrow_facing == "up" then
		pos1 = center + Vector3(0, 0, layout_settings.arrow_size_y * 0.5)
		pos2 = center + Vector3(-layout_settings.arrow_size_x * 0.5, 0, -layout_settings.arrow_size_y * 0.5)
		pos3 = center + Vector3(layout_settings.arrow_size_x * 0.5, 0, -layout_settings.arrow_size_y * 0.5)

		if layout_settings.drop_shadow then
			shadow1 = pos1 + Vector3(0, 0, layout_settings.drop_shadow_offset[2])
			shadow2 = pos2 + Vector3(-layout_settings.drop_shadow_offset[1], 0, -layout_settings.drop_shadow_offset[2] * 0.5)
			shadow3 = pos3 + Vector3(layout_settings.drop_shadow_offset[1], 0, -layout_settings.drop_shadow_offset[2] * 0.5)
		end
	elseif layout_settings.arrow_facing == "down" then
		pos1 = center + Vector3(0, 0, -layout_settings.arrow_size_y * 0.5)
		pos2 = center + Vector3(-layout_settings.arrow_size_x * 0.5, 0, layout_settings.arrow_size_y * 0.5)
		pos3 = center + Vector3(layout_settings.arrow_size_x * 0.5, 0, layout_settings.arrow_size_y * 0.5)

		if layout_settings.drop_shadow then
			shadow1 = pos1 + Vector3(0, 0, -layout_settings.drop_shadow_offset[2])
			shadow2 = pos2 + Vector3(-layout_settings.drop_shadow_offset[1], 0, layout_settings.drop_shadow_offset[2] * 0.5)
			shadow3 = pos3 + Vector3(layout_settings.drop_shadow_offset[1], 0, layout_settings.drop_shadow_offset[2] * 0.5)
		end
	end

	local c = self._highlighted and layout_settings.color_highlighted or layout_settings.color
	local color = Color(c[1], c[2] * pulse_color_multiplier, c[3] * pulse_color_multiplier, c[4] * pulse_color_multiplier)

	Gui.triangle(gui, pos1, pos2, pos3, layout_settings.z or self._z, color)

	if layout_settings.drop_shadow then
		local c = layout_settings.drop_shadow_color
		local color = Color(c[1], c[2], c[3], c[4])

		Gui.triangle(gui, shadow1, shadow2, shadow3, (layout_settings.z or self._z) - 1, color)
	end
end

function ArrowMenuItem.create_from_config(compiler_data, config, callback_object)
	local config = {
		type = "arrow",
		page = config.page,
		name = config.name,
		disabled = config.disabled,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		visible_func = config.visible_func and callback(callback_object, config.visible_func, config.visible_func_args),
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		color = config.color,
		layout_settings = config.layout_settings,
		parent_page = config.parent_page,
		floating_tooltip = config.floating_tooltip,
		sounds = config.parent_page.config.sounds.items.text
	}

	return ArrowMenuItem:new(config, compiler_data.world)
end
