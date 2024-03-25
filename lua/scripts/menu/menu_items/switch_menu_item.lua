-- chunkname: @scripts/menu/menu_items/switch_menu_item.lua

SwitchMenuItem = class(SwitchMenuItem, MenuItem)

function SwitchMenuItem:init(config, world)
	SwitchMenuItem.super.init(self, config, world)

	self._world = world
	self._team_name = "red"
	self._rotate_time = 0
end

function SwitchMenuItem:update_size(dt, t, gui, layout_settings)
	local _, _, _, switch_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.switch_icon)
	local _, _, _, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.texture_red)

	self._width = (icon_size[1] + switch_size[1]) * (layout_settings.scale or 1) + layout_settings.active_offset[1] * icon_size[1]
	self._height = icon_size[2] * (layout_settings.scale or 1)
end

function SwitchMenuItem:on_select(ignore_sound)
	SwitchMenuItem.super.on_select(self, ignore_sound)

	self._team_name = self._team_name == "red" and "white" or "red"
	self._rotate_time = 0.25
end

function SwitchMenuItem:set_team_name(team_name)
	self._team_name = team_name
end

function SwitchMenuItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x - (layout_settings.align == "right" and self._width or 0)
	self._y = y
	self._z = (z or 0) + (layout_settings.z or 0) + (self.config.z or 0)
end

function SwitchMenuItem:render(dt, t, gui, layout_settings)
	if layout_settings.align == "right" then
		local material, uv00, uv11, switch_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.switch_icon)

		switch_size = switch_size * (layout_settings.scale or 1)

		local pos = Vector3(self._x + self._width, self._y, self._z)
		local tm = Rotation2D(Vector3(0, 0, 0), math.degrees_to_radians(self._rotate_time / 0.25 * -360), Vector3(pos[1] + switch_size[1] * 0.5 - switch_size[1], pos[2] + switch_size[2] * 0.5, pos[3]))

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, tm, pos - Vector3(switch_size[1], 0, 0), pos[3], switch_size)

		self._rotate_time = math.max(self._rotate_time - dt, 0)

		local percentage = self._rotate_time / 0.25

		if self._highlighted and layout_settings["texture_" .. self._team_name .. "_highlighted"] then
			local offset_x = math.lerp(layout_settings.active_offset[1], layout_settings.inactive_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.active_offset[2], layout_settings.inactive_offset[2], percentage)
			local alpha = math.lerp(255, 64, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. self._team_name .. "_highlighted"])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(-(icon_size[1] + icon_size[1] * offset_x), icon_size[2] * offset_y, 1), icon_size, Color(alpha, 255, 255, 255))
		else
			local offset_x = math.lerp(layout_settings.active_offset[1], layout_settings.inactive_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.active_offset[2], layout_settings.inactive_offset[2], percentage)
			local alpha = math.lerp(255, 64, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. self._team_name])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(-(icon_size[1] + icon_size[1] * offset_x), icon_size[2] * offset_y, 1), icon_size, Color(alpha, 255, 255, 255))
		end

		local opposite_side = self._team_name == "red" and "white" or "red"

		if self._highlighted and layout_settings["texture_" .. opposite_side .. "_highlighted"] then
			local offset_x = math.lerp(layout_settings.inactive_offset[1], layout_settings.active_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.inactive_offset[2], layout_settings.active_offset[2], percentage)
			local alpha = math.lerp(64, 255, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. opposite_side .. "_highlighted"])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(-(icon_size[1] + icon_size[1] * offset_x), icon_size[2] * offset_y, 0), icon_size, Color(alpha, 255, 255, 255))
		else
			local offset_x = math.lerp(layout_settings.inactive_offset[1], layout_settings.active_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.inactive_offset[2], layout_settings.active_offset[2], percentage)
			local alpha = math.lerp(64, 255, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. opposite_side])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(-(icon_size[1] + icon_size[1] * offset_x), icon_size[2] * offset_y, 0), icon_size, Color(alpha, 255, 255, 255))
		end
	else
		local pos = Vector3(self._x, self._y, self._z)
		local material, uv00, uv11, switch_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.switch_icon)

		switch_size = switch_size * (layout_settings.scale or 1)

		local tm = Rotation2D(Vector3(0, 0, 0), math.degrees_to_radians(self._rotate_time / 0.25 * -360), Vector3(pos[1] + switch_size[1] * 0.5, pos[2] + switch_size[2] * 0.5, pos[3]))

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, tm, pos, pos[3], switch_size)

		self._rotate_time = math.max(self._rotate_time - dt, 0)

		local percentage = self._rotate_time / 0.25

		if self._highlighted and layout_settings["texture_" .. self._team_name .. "_highlighted"] then
			local offset_x = math.lerp(layout_settings.active_offset[1], layout_settings.inactive_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.active_offset[2], layout_settings.inactive_offset[2], percentage)
			local alpha = math.lerp(255, 64, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. self._team_name .. "_highlighted"])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(icon_size[1] * offset_x, icon_size[2] * offset_y, 1), icon_size, Color(alpha, 255, 255, 255))
		else
			local offset_x = math.lerp(layout_settings.active_offset[1], layout_settings.inactive_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.active_offset[2], layout_settings.inactive_offset[2], percentage)
			local alpha = math.lerp(255, 64, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. self._team_name])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(icon_size[1] * offset_x, icon_size[2] * offset_y, 1), icon_size, Color(alpha, 255, 255, 255))
		end

		local opposite_side = self._team_name == "red" and "white" or "red"

		if self._highlighted and layout_settings["texture_" .. opposite_side .. "_highlighted"] then
			local offset_x = math.lerp(layout_settings.inactive_offset[1], layout_settings.active_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.inactive_offset[2], layout_settings.active_offset[2], percentage)
			local alpha = math.lerp(64, 255, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. opposite_side .. "_highlighted"])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(icon_size[1] * offset_x, icon_size[2] * offset_y, 0), icon_size, Color(alpha, 255, 255, 255))
		else
			local offset_x = math.lerp(layout_settings.inactive_offset[1], layout_settings.active_offset[1], percentage)
			local offset_y = math.lerp(layout_settings.inactive_offset[2], layout_settings.active_offset[2], percentage)
			local alpha = math.lerp(64, 255, math.smoothstep(percentage, 0, 1))
			local material, uv00, uv11, icon_size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings["texture_" .. opposite_side])

			icon_size = icon_size * (layout_settings.scale or 1)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(icon_size[1] * offset_x, icon_size[2] * offset_y, 0), icon_size, Color(alpha, 255, 255, 255))
		end
	end
end

function SwitchMenuItem.create_from_config(compiler_data, config, callback_object)
	local item_config = {
		type = "switch_item",
		page = config.page,
		name = config.name,
		layout_settings = config.layout_settings,
		callback_object = callback_object,
		z = config.z,
		sounds = config.sounds or MenuSettings.sounds.default.items.switch_item,
		on_select = config.on_select,
		on_select_args = config.on_select_args
	}

	return SwitchMenuItem:new(item_config, compiler_data.world)
end
