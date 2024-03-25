-- chunkname: @scripts/menu/menu_containers/profile_editor_container.lua

ProfileEditorContainer = class(ProfileEditorContainer, MenuContainer)

function ProfileEditorContainer:init(config)
	ProfileEditorContainer.super.init(self)

	self.config = config
	self._available = false
	self._visible = true
	self._alpha = 1
	self._locked = config.locked
	self._text = config.text
	self._new_item = false
end

function ProfileEditorContainer:name()
	return self.config.name
end

function ProfileEditorContainer:set_visibility(visible)
	self._visible = visible
end

function ProfileEditorContainer:visible()
	return self._visible
end

function ProfileEditorContainer:set_highlight_func(highlight_func, highlight_func_args)
	self._current_highlight_func = highlight_func
	self._current_highlight_func_args = highlight_func_args
end

function ProfileEditorContainer:highlighted()
	return self._highlighted
end

function ProfileEditorContainer:mouse_highlight()
	return self._mouse_highlight
end

function ProfileEditorContainer:disabled()
	return self:locked()
end

function ProfileEditorContainer:locked()
	return self._locked
end

function ProfileEditorContainer:set_locked(locked)
	self._locked = locked
end

function ProfileEditorContainer:set_text(text)
	self._text = text
end

function ProfileEditorContainer:set_new_item(new_item)
	self._new_item = new_item
end

function ProfileEditorContainer:on_select()
	if self.config.sounds.select then
		local timpani_world = World.timpani_world(self.config.world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end
end

function ProfileEditorContainer:set_page_data(page, data_table)
	self.config.page_data = nil

	if data_table then
		self.config.page_data = {
			page = page,
			data_table = table.clone(data_table)
		}
	else
		self._current_texture = nil
	end

	self._available = self.config.page_data
end

function ProfileEditorContainer:page_data()
	return self.config.page_data
end

function ProfileEditorContainer:update_size(dt, t, gui, layout_settings)
	local w, h = Gui.resolution()

	self._width = layout_settings.rect.width or w
	self._height = layout_settings.rect.height or h
end

function ProfileEditorContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z or 0
end

function ProfileEditorContainer:render(dt, t, gui, layout_settings, render_from_child_page)
	if not self._current_texture and not self._available and GameSettingsDevelopment.hide_unavailable_gear_categories then
		return
	end

	if self._current_highlight_func then
		self._highlighted = self._current_highlight_func and self.config.callback_object[self._current_highlight_func](self.config.callback_object, self, self._current_highlight_func_args)
	else
		self._highlighted = self._mouse_highlight
	end

	self._alpha = self._visible and math.min(self._alpha + dt * 10, 1) or math.clamp(self._alpha - dt * 10, 0, 1)

	self:_render_header(dt, t, gui, layout_settings.header)
	MenuHelper:render_texture_background_rect(dt, t, gui, layout_settings.rect, self._available, self._highlighted, self._alpha, self._x, self._y, self._z, self._width, self._height)
	self:_render_arrow(dt, t, gui, layout_settings.arrow)
	self:_render_lock(dt, t, gui, layout_settings.lock)
	self:_render_texture(dt, t, gui, layout_settings.texture)
	self:_render_text(dt, t, gui, layout_settings.text)
	self:_render_new_item(dt, t, gui, layout_settings.new_item)
	self:_render_mouse_over(dt, t, gui, layout_settings.mouse_over, render_from_child_page)
end

function ProfileEditorContainer:_render_text(dt, t, gui, layout_settings)
	if self._text then
		local text = L(self._text)
		local font = layout_settings.font.font
		local material = layout_settings.font.material
		local font_size = layout_settings.font_size
		local min, max = Gui.text_extents(gui, text, font, font_size)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}
		local x, y = self:_align_text(layout_settings, extents)
		local pos = Vector3(math.floor(x), math.floor(y), self._z + 5)

		Gui.text(gui, text, font, font_size, material, pos, self:_color(layout_settings.color))
	end
end

function ProfileEditorContainer:_render_texture(dt, t, gui, layout_settings)
	if self._current_simple_texture then
		local offset = not (not self._highlighted and not self._locked) and (layout_settings.highlight_offset or 2) or layout_settings.offset or 4
		local size = Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2])

		size = size * (layout_settings.scale or 1)

		local pos = Vector3(self._x + self._width * 0.5 - size[1] * 0.5 - offset, self._y + self._height * 0.5 - size[2] * 0.5 + offset, self._z + 2)

		Gui.bitmap(gui, self._current_simple_texture, pos, size, self:_color(layout_settings.texture_color or {
			255,
			255,
			255,
			255
		}))

		if not layout_settings or not layout_settings.hide_shadow then
			Gui.bitmap(gui, self._current_simple_texture, Vector3(self._x + self._width * 0.5 - size[1] * 0.5 + offset, self._y + self._height * 0.5 - size[2] * 0.5 - offset, self._z + 1), size, self:_color(layout_settings and layout_settings.drop_shadow_color or {
				175,
				0,
				0,
				0
			}))
		end

		self:_render_mask(gui, pos, size)
	elseif self._current_texture then
		local offset = not (not self._highlighted and not self._locked) and 2 or 4
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.atlas, self._current_texture, layout_settings.masked, "perk_icon_no_perk_menu")

		size = size * (layout_settings.scale or 1)

		local pos = Vector3(self._x + self._width * 0.5 - size[1] * 0.5 - offset, self._y + self._height * 0.5 - size[2] * 0.5 + offset, self._z + 2)

		Gui.bitmap_uv(gui, material, uv00, uv11, pos, size, self:_color(layout_settings.texture_color or {
			255,
			255,
			255,
			255
		}))

		if not layout_settings or not layout_settings.hide_shadow then
			Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(self._x + self._width * 0.5 - size[1] * 0.5 + offset, self._y + self._height * 0.5 - size[2] * 0.5 - offset, self._z + 1), size, self:_color(layout_settings and layout_settings.drop_shadow_color or {
				175,
				0,
				0,
				0
			}))
		end

		self:_render_mask(gui, pos, size)
	elseif self._current_texture_func then
		local offset = not (not self._highlighted and not self._locked) and 1 or 3
		local material, size, color, uv00, uv11 = self.config.callback_object[self._current_texture_func](self.config.callback_object, self._gear)

		size = size * (layout_settings and layout_settings.scale or 1)

		local pos = Vector3(self._x + self._width * 0.5 - size[1] * 0.5 - offset, self._y + self._height * 0.5 - size[2] * 0.5 + offset, self._z + 2)

		if uv00 and uv11 then
			Gui.bitmap_uv(gui, material, uv00, uv11, pos, size, color or self:_color(layout_settings and layout_settings.texture_color or {
				255,
				255,
				255,
				255
			}))
		else
			Gui.bitmap(gui, material, pos, size, color or self:_color(layout_settings and layout_settings.texture_color or {
				255,
				255,
				255,
				255
			}))
		end

		if not layout_settings or not layout_settings.hide_shadow then
			if uv00 and uv11 then
				Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(self._x + self._width * 0.5 - size[1] * 0.5 + offset, self._y + self._height * 0.5 - size[2] * 0.5 - offset, self._z + 1), size, self:_color(layout_settings and layout_settings.drop_shadow_color or {
					176,
					0,
					0,
					0
				}))
			else
				Gui.bitmap(gui, material, Vector3(self._x + self._width * 0.5 - size[1] * 0.5 + offset, self._y + self._height * 0.5 - size[2] * 0.5 - offset, self._z + 1), size, self:_color(layout_settings and layout_settings.drop_shadow_color or {
					176,
					0,
					0,
					0
				}))
			end
		end

		self:_render_mask(gui, pos, size)
	end
end

function ProfileEditorContainer:_render_mask(gui, pos, size)
	if self._current_mask then
		Gui.bitmap(gui, self._current_mask, pos, size)
	elseif self._current_mask_func then
		local material, size, color = self.config.callback_object[self._current_mask_func](self.config.callback_object, self._gear)

		Gui.bitmap(gui, material, pos, size, color)
	end
end

function ProfileEditorContainer:_render_new_item(dt, t, gui, layout_settings)
	if self._new_item and layout_settings then
		local scale = layout_settings.scale or 1
		local atlas_table = HUDHelper.atlas_texture_settings(layout_settings.texture_atlas, layout_settings.texture)
		local uv00 = Vector2(atlas_table.uv00[1], atlas_table.uv00[2])
		local uv11 = Vector2(atlas_table.uv11[1], atlas_table.uv11[2])
		local x = self._x + layout_settings.texture_offset_x
		local y = self._y + layout_settings.texture_offset_y
		local z = self._z + 10
		local pos = Vector3(x, y, z)
		local size = Vector2(atlas_table.size[1] * scale, atlas_table.size[2] * scale)
		local color = self:_color(layout_settings.texture_color)

		Gui.bitmap_uv(gui, layout_settings.texture_atlas, uv00, uv11, pos, size, color)
	end
end

function ProfileEditorContainer:_render_mouse_over(dt, t, gui, layout_settings, render_from_child_page)
	if render_from_child_page then
		return
	end

	local z_offset = 10

	if self._highlighted and self._gear and layout_settings and not layout_settings.avoid_mouse_over and self._current_mouse_pos then
		self._highlight_timer = math.max((self._highlight_timer or 0) - dt, 0)

		if self._highlight_timer == 0 then
			local gear = self._gear
			local w, h = Gui.resolution()
			local alignment_offset_x = 0
			local align_towards_center = layout_settings.alignment == "towards_center"
			local description_texts = MenuHelper:format_text(L(gear.ui_description), gui, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.width)
			local spacing_offset = Vector3(-(layout_settings.spacing or 0), layout_settings.spacing or 0, 0)
			local layout_setting_offset = Vector3(-(layout_settings.offset_x or 0), layout_settings.offset_y or 0, 0)
			local alignment_offset = Vector3(alignment_offset_x, 0, self._z + z_offset)
			local margin_offset = spacing_offset + layout_setting_offset
			local position = self._current_mouse_pos:unbox() - margin_offset + alignment_offset
			local header_position = position
			local text_height = (#description_texts + 2) * layout_settings.spacing
			local text_position = position
			local frame_yoffset = (layout_settings.spacing or 0) + (layout_settings.offset_y or 0)
			local frame_position = self._current_mouse_pos:unbox() + Vector3(alignment_offset_x, -frame_yoffset, self._z + z_offset - 1)
			local frame_size = Vector2(layout_settings.width + (layout_settings.spacing or 0) * 1.5 + (layout_settings.offset_x or 0), text_height + frame_yoffset)

			frame_position[2] = frame_position[2] - text_height
			frame_position[1] = math.clamp(frame_position[1], 0, w - frame_size[1])
			header_position[1] = math.clamp(header_position[1], 0, w - frame_size[1] - margin_offset[1])
			text_position[1] = math.clamp(header_position[1], 0, w - frame_size[1] - margin_offset[1])
			frame_position[2] = math.clamp(frame_position[2], 0, h - frame_size[2])
			header_position[2] = math.clamp(header_position[2], text_height, h - text_height)
			text_position[2] = math.clamp(text_position[2], text_height, h - text_height)

			Gui.text(gui, L(gear.ui_header), layout_settings.header_font.font, layout_settings.header_font_size, layout_settings.header_font.material, header_position, MenuHelper:color(self.config.callback_object[layout_settings.header_color_func](self.config.callback_object)))

			text_position[2] = text_position[2] - layout_settings.header_spacing

			for i, text in ipairs(description_texts) do
				Gui.text(gui, text, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.text_font.material, text_position + Vector3(0, 0, self._z + z_offset))

				text_position[2] = text_position[2] - layout_settings.spacing
			end

			Gui.rect(gui, frame_position, frame_size, MenuHelper:color(layout_settings.background_color))
			MenuHelper:render_border_alternative(gui, frame_position, frame_size, layout_settings.border_thickness, MenuHelper:color(layout_settings.border_color), self._z + z_offset)
		end
	else
		self._highlight_timer = layout_settings and layout_settings.highlight_timer or 0.5
		self._current_mouse_pos = nil
	end
end

function ProfileEditorContainer:is_mouse_inside(mouse_pos)
	local x1 = self._x
	local x2 = self._x + self._width
	local y1 = self._y
	local y2 = self._y + self._height
	local is_inside = x1 < mouse_pos[1] and x2 > mouse_pos[1] and y1 < mouse_pos[2] and y2 > mouse_pos[2]

	if is_inside and not self._mouse_highlight and self.config.sounds.hover then
		local timpani_world = World.timpani_world(self.config.world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.hover)
	end

	self._mouse_highlight = is_inside
	self._current_mouse_pos = Vector3Box(mouse_pos)

	return is_inside
end

function ProfileEditorContainer:set_info(texture_atlas_material, gear, texture_func, mask, mask_func, simple_material)
	self._current_texture = texture_atlas_material
	self._current_simple_texture = simple_material
	self._current_mask = mask
	self._current_texture_func = texture_func
	self._current_mask_func = mask_func
	self._gear = gear
end

function ProfileEditorContainer:_render_header(dt, t, gui, layout_settings)
	if not layout_settings then
		return
	end

	local name = self.config.name
	local localized_text = L(name)
	local min, max = Gui.text_extents(gui, localized_text, layout_settings.font.font, layout_settings.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local x, y = self:_align_text(layout_settings, extents)
	local pos = Vector3(x, y, self._z + 1)

	Gui.text(gui, localized_text, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, pos, self:_color(layout_settings.color))
end

function ProfileEditorContainer:_render_arrow(dt, t, gui, layout_settings)
	if not self._available then
		return
	end

	local top_left, bottom, top_right = self:_get_arrow_position(layout_settings)

	Gui.triangle(gui, top_left, bottom, top_right, 1, self:_color(layout_settings.color))

	local bt = layout_settings.border_thickness

	Gui.triangle(gui, top_left + Vector3(-bt * 2, 0, bt), bottom + Vector3(0, 0, -bt * 2), top_right + Vector3(bt * 2, 0, bt), 0, self:_color(layout_settings.border_color))
end

function ProfileEditorContainer:_render_lock(dt, t, gui, layout_settings)
	if self._locked then
		if layout_settings.lock_texture then
			local width = layout_settings.texture_width
			local height = layout_settings.texture_height
			local size = Vector2(width, height)

			size = size * (layout_settings.scale or 1)

			local pos = Vector3(self._x + self._width - width * 0.5, self._y - height * 0.5, self._z + 5)

			Gui.bitmap(gui, layout_settings.lock_texture, pos, size, self:_color(layout_settings.lock_color))
		elseif layout_settings.lock_atlas then
			local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.lock_atlas, layout_settings.lock_material)

			size = size * (layout_settings.scale or 1)

			local pos = Vector3(self._x + self._width - size[1] * 0.5, self._y - size[2] * 0.5, self._z + 5)

			Gui.bitmap_uv(gui, material, uv00, uv11, pos, size, self:_color(layout_settings.lock_color))
		else
			local width = 20
			local height = 20
			local pos = Vector3(self._x + self._width - width * 0.5, self._y - height * 0.5, self._z + 5)

			Gui.rect(gui, pos, Vector2(width, height), self:_color(layout_settings.lock_color))
		end
	end
end

function ProfileEditorContainer:_get_arrow_position(layout_settings)
	local offset_x = layout_settings.offset_x or 0
	local offset_y = layout_settings.offset_y or 0
	local top_left, bottom, top_right

	if layout_settings.align == "right" then
		top_left = Vector3(self._x + self._width + offset_x - layout_settings.size[1], 0, self._y + offset_y)
		top_right = Vector3(self._x + self._width + offset_x, 0, self._y + offset_y)
		bottom = Vector3(self._x + self._width + offset_x - layout_settings.size[1] * 0.5, 0, self._y + offset_y - layout_settings.size[2])
	elseif layout_settings.align == "left" then
		top_left = Vector3(self._x + offset_x, 0, self._y + offset_y)
		top_right = Vector3(self._x + offset_x + layout_settings.size[1], 0, self._y + offset_y)
		bottom = Vector3(self._x + offset_x + layout_settings.size[1] * 0.5, 0, self._y + offset_y - layout_settings.size[2])
	else
		top_left = Vector3(self._x + self._width * 0.5 + offset_x - layout_settings.size[1] * 0.5, 0, self._y + offset_y)
		top_right = Vector3(self._x + self._width * 0.5 + offset_x + layout_settings.size[1] * 0.5, 0, self._y + offset_y)
		bottom = Vector3(self._x + self._width * 0.5 + offset_x, 0, self._y + offset_y - layout_settings.size[2])
	end

	return top_left, bottom, top_right
end

function ProfileEditorContainer:_color(c)
	return Color(c[1] * self._alpha, c[2], c[3], c[4])
end

function ProfileEditorContainer:_align_text(layout_settings, extents)
	local x, y

	if layout_settings.align_x == "left" then
		x = self._x + layout_settings.offset_x - extents[1]
	elseif layout_settings.align_x == "right" then
		x = self._x + self._width + layout_settings.offset_x
	else
		x = self._x + layout_settings.offset_x
	end

	if layout_settings.align_y == "top" then
		y = self._y + self._height + layout_settings.offset_y
	elseif layout_settings.align_y == "bottom" then
		y = self._y - extents[2] + layout_settings.offset_y
	else
		y = self._y + self._height * 0.5 - extents[2] * 0.5 + layout_settings.offset_y
	end

	return x, y
end

function ProfileEditorContainer.create_from_config(config)
	local container_config = {
		callback_object = config.callback_object,
		name = config.name,
		world = config.world,
		sounds = MenuSettings.sounds.default.items.profile_container,
		locked = config.locked
	}

	return ProfileEditorContainer:new(container_config)
end
