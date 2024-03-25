-- chunkname: @scripts/menu/menu_items/experience_menu_item.lua

require("scripts/settings/ranks")

ExperienceMenuItem = class(ExperienceMenuItem, MenuItem)

function ExperienceMenuItem:init(config, world)
	ExperienceMenuItem.super.init(self, config, world)
end

function ExperienceMenuItem:update_size(dt, t, gui, layout_settings)
	self._width = layout_settings.current_level_box.rect_size[1] + layout_settings.level_bar.rect_size[1] + layout_settings.spacing_x * 2 + layout_settings.offset_x
	self._height = layout_settings.current_level_box.rect_size[2] + layout_settings.offset_y
end

function ExperienceMenuItem:update_position(dt, t, layout_settings, x, y, z)
	local align_offset = 0

	if layout_settings.align_x == "center" then
		align_offset = -self._width * 0.5
	elseif layout_settings.align_x == "right" then
		align_offset = -self._width
	end

	self._x = x + align_offset
	self._y = y
	self._z = z or layout_settings.z or 0
end

function ExperienceMenuItem:render(dt, t, gui, layout_settings)
	local profile_data = self.config.experience_callback()

	self:_render_current_level(dt, t, gui, layout_settings, profile_data)
	self:_render_level_bar(dt, t, gui, layout_settings, profile_data)
	self:_render_next_level(dt, t, gui, layout_settings, profile_data)
	self:_render_loot(dt, t, gui, layout_settings, profile_data)
	self:_render_buy_loot(dt, t, gui, layout_settings)
	self:_render_frame(dt, t, gui, layout_settings)
	self:_render_background(dt, t, gui, layout_settings)
end

function ExperienceMenuItem:_render_frame(dt, t, gui, item_layout_settings)
	local layout_settings = item_layout_settings.frame

	if layout_settings and layout_settings.border_texture_atlas then
		local x = self._x + layout_settings.x_offset
		local y = self._y + item_layout_settings.spacing_y + layout_settings.y_offset
		local z = self._z
		local width = item_layout_settings.current_level_box.rect_size[1] + item_layout_settings.spacing_x + item_layout_settings.level_bar.rect_size[1] + item_layout_settings.spacing_x + item_layout_settings.next_level_box.rect_size[1] + layout_settings.width_offset
		local height = self._height - item_layout_settings.spacing_y + layout_settings.height_offset

		self:_render_border_piece(gui, layout_settings, x, y + height, z, width, layout_settings.border_thickness, nil, true)
		self:_render_border_piece(gui, layout_settings, x + width, y, z, width, layout_settings.border_thickness, -180)
		self:_render_border_piece(gui, layout_settings, x, y, self._z, height, layout_settings.border_thickness, -90, true)
		self:_render_border_piece(gui, layout_settings, x + width, y + height, z, height, layout_settings.border_thickness, 90)
		self:_render_border_corners(gui, layout_settings, x, y, z + 1, width, height)
	end
end

function ExperienceMenuItem:_render_background(dt, t, gui, item_layout_settings)
	local layout_settings = item_layout_settings.background_texture

	if layout_settings then
		local x = self._x + item_layout_settings.frame.x_offset
		local y = self._y + item_layout_settings.spacing_y + item_layout_settings.frame.y_offset
		local z = 0
		local width = item_layout_settings.current_level_box.rect_size[1] + item_layout_settings.spacing_x + item_layout_settings.level_bar.rect_size[1] + item_layout_settings.spacing_x + item_layout_settings.next_level_box.rect_size[1] + item_layout_settings.frame.width_offset
		local height = self._height - item_layout_settings.spacing_y + item_layout_settings.frame.height_offset
		local color = layout_settings.color:unbox()
		local atlas = layout_settings.texture_atlas

		if atlas then
			ScriptGUI.bitmap_uv_tiled(gui, atlas, HUDHelper.atlas_texture_settings(atlas, layout_settings.texture), Vector3(x, y, z), Vector2(width, height), color)
		else
			local tile_x = math.ceil(width / layout_settings.texture_size[1])
			local tile_y = math.ceil(height / layout_settings.texture_size[2])

			for i = 1, tile_x do
				for j = 1, tile_y do
					local uv11 = Vector2(math.min((width - (i - 1) * layout_settings.texture_size[1]) / layout_settings.texture_size[1], 1), math.min((height - (j - 1) * layout_settings.texture_size[2]) / layout_settings.texture_size[2], 1))
					local pos = Vector3(x + (i - 1) * layout_settings.texture_size[1], y + (j - 1) * layout_settings.texture_size[2], z)
					local size = Vector2(layout_settings.texture_size[1] * uv11[1], layout_settings.texture_size[2] * uv11[2])

					Gui.bitmap_uv(gui, layout_settings.texture, Vector2(0, 0), uv11, pos, size, color)
				end
			end
		end
	end
end

function ExperienceMenuItem:_render_border_corners(gui, layout_settings, x, y, z, width, height)
	if not layout_settings.border_corner_material then
		return
	end

	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_corner_material)
	local offset = layout_settings.border_corner_offset or {
		0,
		0
	}
	local pos = Vector3(x + offset[1], y + height + offset[2], z - 1)
	local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)

	Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

	if layout_settings.border_corner_small_material then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_corner_small_material)
		local offset = layout_settings.border_corner_small_offset or {
			0,
			0
		}
		local pos = Vector3(x + offset[1], y + offset[2], 0)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

		local pos = Vector3(x + width - offset[2], y + offset[1], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(-180), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)

		local pos = Vector3(x + width - offset[1], y + height - offset[2], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(90), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size)
	else
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x - size[1], y - layout_settings.border_thickness, 0), size)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + self._width - size[1], y - layout_settings.border_thickness, z - 1), size)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + self._width - size[1], y + self._height, z), size)
	end
end

function ExperienceMenuItem:_render_border_piece(gui, layout_settings, x, y, z, width, height, rotate_angle, flip)
	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_material)
	local uv_size = uv11 - uv00
	local size_diff = width / size[1]
	local curr_x = x

	repeat
		local new_uv11 = Vector2(uv11[1], uv11[2])

		new_uv11[1] = uv00[1] + math.min(size_diff, 1) * uv_size[1]

		local new_size = Vector2(size[1], size[2])

		new_size[1] = size[1] * math.min(size_diff, 1)

		if rotate_angle then
			local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(rotate_angle), Vector2(curr_x, y))

			if flip then
				Gui.bitmap_3d_uv(gui, material, uv00, new_uv11, rot, Vector3(curr_x + new_size[1], y, z), z, Vector2(-new_size[1], new_size[2]))
			else
				Gui.bitmap_3d_uv(gui, material, uv00, new_uv11, rot, Vector3(curr_x, y, z), z, new_size)
			end

			if flip then
				curr_x = curr_x + size[1]
			else
				curr_x = curr_x - size[1]
			end
		elseif flip then
			Gui.bitmap_uv(gui, material, uv00, new_uv11, Vector3(curr_x + new_size[1], y, z), Vector2(-new_size[1], new_size[2]))

			curr_x = curr_x + size[1]
		else
			Gui.bitmap_uv(gui, material, uv00, new_uv11, Vector3(curr_x, y, z), new_size)

			curr_x = curr_x - size[1]
		end

		size_diff = size_diff - 1
	until size_diff <= 0
end

function ExperienceMenuItem:_render_current_level(dt, t, gui, item_layout_settings, profile_data)
	local layout_settings = item_layout_settings.current_level_box
	local experience = profile_data.experience
	local rank = tostring(xp_to_rank(experience))

	Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]), MenuHelper:color(layout_settings.rect_color))

	local min, max = Gui.text_extents(gui, rank, layout_settings.font.font, layout_settings.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local color = self:_try_callback(self.config.callback_object, layout_settings.text_color_func) or {
		255,
		255,
		255,
		255
	}

	Gui.text(gui, rank, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(self._x + layout_settings.rect_size[1] * 0.5 - extents[1] * 0.5, self._y + layout_settings.rect_size[2] * 0.5 - extents[2] * 0.5, self._z + 1), MenuHelper:color(color))
	Gui.text(gui, L(layout_settings.header), layout_settings.header_font.font, layout_settings.header_font_size, layout_settings.header_font.material, Vector3(self._x, self._y + layout_settings.rect_size[2] + layout_settings.header_spacing, self._z), MenuHelper:color(layout_settings.header_text_color))
end

function ExperienceMenuItem:_render_level_bar(dt, t, gui, item_layout_settings, profile_data)
	local layout_settings = item_layout_settings.level_bar
	local x = self._x + item_layout_settings.current_level_box.rect_size[1] + item_layout_settings.spacing_x
	local y = self._y
	local z = self._z
	local experience = profile_data.experience
	local rank = xp_to_rank(experience)
	local xp_data = RANKS[rank] and RANKS[rank].xp or {}
	local current_experience, next_rank_experience, percentage

	if xp_data.span < math.huge and experience - xp_data.base < xp_data.span then
		current_experience = experience - xp_data.base
		next_rank_experience = xp_data.span
		percentage = current_experience / xp_data.span
	else
		current_experience = experience
		next_rank_experience = experience
		percentage = 1
	end

	Gui.rect(gui, Vector3(x, y, z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]), MenuHelper:color(layout_settings.rect_color))
	Gui.rect(gui, Vector3(x + layout_settings.rect_size[1] * 0.5 - layout_settings.inner_rect_size[1] * 0.5, y + layout_settings.rect_size[2] * 0.5 - layout_settings.inner_rect_size[2] * 0.5, z + 1), Vector2(layout_settings.inner_rect_size[1], layout_settings.inner_rect_size[2]), MenuHelper:color(layout_settings.bg_color))

	local color = self:_try_callback(self.config.callback_object, layout_settings.bar_color_func) or {
		255,
		255,
		255,
		255
	}
	local bar_pos = Vector3(x + layout_settings.rect_size[1] * 0.5 - layout_settings.inner_rect_size[1] * 0.5, y + layout_settings.rect_size[2] * 0.5 - layout_settings.inner_rect_size[2] * 0.5, z + 3)

	Gui.rect(gui, bar_pos, Vector2(layout_settings.inner_rect_size[1] * percentage, layout_settings.inner_rect_size[2]), MenuHelper:color(color))
	Gui.bitmap(gui, "mask_rect_alpha", bar_pos, Vector2(layout_settings.inner_rect_size[1] * percentage, layout_settings.inner_rect_size[2]), Color(255, 0, 0, 0))

	local xp_text = current_experience .. " / " .. next_rank_experience
	local min, max = Gui.text_extents(gui, xp_text, layout_settings.xp_font.font, layout_settings.xp_font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local text_pos = Vector3(bar_pos[1] + layout_settings.xp_text_offset[1], bar_pos[2] + layout_settings.inner_rect_size[2] * 0.5 - extents[2] * 0.5 + layout_settings.xp_text_offset[2], bar_pos[3] + 4)

	Gui.text(gui, xp_text, layout_settings.xp_font.font, layout_settings.xp_font_size, layout_settings.xp_font.material, text_pos, MenuHelper:color(layout_settings.xp_text_color))

	local color = self:_try_callback(self.config.callback_object, layout_settings.back_color_func) or {
		255,
		255,
		255,
		255
	}

	Gui.text(gui, xp_text, layout_settings.back_font.font, layout_settings.xp_font_size, layout_settings.back_font.material, text_pos + Vector3(0, 0, -5), MenuHelper:color(color))
	Gui.text(gui, L(layout_settings.header), layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(x, y + layout_settings.rect_size[2] + layout_settings.header_spacing, self._z), MenuHelper:color(layout_settings.header_text_color))
end

function ExperienceMenuItem:_render_next_level(dt, t, gui, item_layout_settings, profile_data)
	local layout_settings = item_layout_settings.next_level_box
	local x = self._x + item_layout_settings.current_level_box.rect_size[1] + item_layout_settings.spacing_x + item_layout_settings.level_bar.rect_size[1] + item_layout_settings.spacing_x
	local y = self._y
	local z = self._z
	local experience = profile_data.experience
	local current_rank = xp_to_rank(experience)
	local next_rank_text = RANKS[current_rank + 1] and tostring(current_rank + 1) or "_"

	Gui.rect(gui, Vector3(x, y, z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]), MenuHelper:color(layout_settings.rect_color))

	local min, max = Gui.text_extents(gui, next_rank_text, layout_settings.font.font, layout_settings.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}

	Gui.text(gui, next_rank_text, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(x + layout_settings.rect_size[1] * 0.5 - extents[1] * 0.5, y + layout_settings.rect_size[2] * 0.5 - extents[2] * 0.5, z + 1), MenuHelper:color(layout_settings.level_color))
end

function ExperienceMenuItem:_render_loot(dt, t, gui, item_layout_settings, profile_data)
	local layout_settings = item_layout_settings.coins_bar
	local x = self._x
	local y = self._y + item_layout_settings.spacing_y
	local z = self._z
	local coins = profile_data.coins

	Gui.rect(gui, Vector3(x, y, z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]), MenuHelper:color(layout_settings.rect_color))

	local icon_pos, icon_size

	if layout_settings.icon_atlas then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.icon_atlas, layout_settings.icon)

		icon_size = size * (layout_settings.icon_scale or 1)
		icon_pos = Vector3(x + layout_settings.rect_size[1] - icon_size[1], y + layout_settings.rect_size[2] * 0.5 - icon_size[2] * 0.5, z + 1)

		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos, icon_size)
	elseif layout_settings.icon then
		icon_pos = Vector3(x + layout_settings.rect_size[1] - layout_settings.icon_size[1], y + layout_settings.rect_size[2] * 0.5 - layout_settings.icon_ize[2] * 0.5, z + 1)
		icon_size = Vector2(layout_settings.icon_size[1], layout_settings.icon_size[2]) * (layout_settings.icon_scale or 1)

		Gui.bitmap_uv(gui, layout_settings.icon, icon_pos, icon_size)
	end

	local min, max = Gui.text_extents(gui, tostring(coins), layout_settings.coin_font.font, layout_settings.coin_font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local text_pos = Vector3(icon_pos[1] - extents[1], y + layout_settings.rect_size[2] * 0.5 - extents[2] * 0.5, z + 1)

	Gui.text(gui, tostring(coins), layout_settings.coin_font.font, layout_settings.coin_font_size, layout_settings.coin_font.material, text_pos)
	Gui.text(gui, L(layout_settings.header), layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(x, y + layout_settings.rect_size[2] + layout_settings.header_spacing, self._z), MenuHelper:color(layout_settings.header_text_color))
end

function ExperienceMenuItem:_render_buy_loot(dt, t, gui, item_layout_settings)
	if not GameSettingsDevelopment.enable_micro_transactions then
		return
	end

	local layout_settings = item_layout_settings.buy_loot
	local x = self._x + item_layout_settings.coins_bar.rect_size[1] + item_layout_settings.spacing_x
	local y = self._y + item_layout_settings.spacing_y
	local z = self._z

	if layout_settings.texture_atlas then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, self._highlighted and layout_settings.highlighted_material or layout_settings.material)

		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x, y, z), size)
	elseif layout_settings.texture then
		Gui.bitmap(gui, layout_settings.texture, Vector3(x, y, z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]))
	else
		Gui.rect(gui, Vector3(x, y, z), Vector2(layout_settings.rect_size[1], layout_settings.rect_size[2]), MenuHelper:color(self._highlighted and layout_settings.highlighted_rect_color or layout_settings.rect_color))
	end

	local min, max = Gui.text_extents(gui, L(layout_settings.text), layout_settings.font.font, layout_settings.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[1]
	}

	Gui.text(gui, L(layout_settings.text), layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(x + layout_settings.rect_size[1] * 0.5 - extents[1] * 0.5, y + layout_settings.rect_size[2] * 0.5 - extents[2] * 0.5, z + 1), MenuHelper:color(self._highlighted and layout_settings.highlighted_text_color or layout_settings.text_color))
end

function ExperienceMenuItem:is_mouse_inside(mouse_x, mouse_y)
	local item_layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local layout_settings = item_layout_settings.buy_loot
	local x1 = self._x + item_layout_settings.coins_bar.rect_size[1] + item_layout_settings.spacing_x
	local y1 = self._y + item_layout_settings.spacing_y
	local x2 = x1 + layout_settings.rect_size[1]
	local y2 = y1 + layout_settings.rect_size[2]

	return x1 <= mouse_x and mouse_x <= x2 and y1 <= mouse_y and mouse_y <= y2
end

function ExperienceMenuItem.create_from_config(compiler_data, config, callback_object)
	local item_config = {
		type = "experience_bar",
		experience_callback = config.experience_callback and callback(callback_object, config.experience_callback),
		on_select = config.on_select,
		callback_object = callback_object,
		layout_settings = config.layout_settings,
		sounds = config.sounds or MenuSettings.sounds.items.text,
		disabled_func = config.disabled_func
	}

	return ExperienceMenuItem:new(item_config, compiler_data.world)
end
