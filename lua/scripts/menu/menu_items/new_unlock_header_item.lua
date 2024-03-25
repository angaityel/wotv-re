-- chunkname: @scripts/menu/menu_items/new_unlock_header_item.lua

NewUnlockHeaderItem = class(NewUnlockHeaderItem, HeaderItem)

function NewUnlockHeaderItem:init(config, world)
	NewUnlockHeaderItem.super.init(self, config, world)

	self._has_unviewed_item = false
	self._show_required_rank = false
	self._required_rank = 0
	self._debug = false
end

function NewUnlockHeaderItem:on_page_enter()
	NewUnlockHeaderItem.super.on_page_enter(self)

	if self.config.on_enter_unviewed_item then
		self._has_unviewed_item = self:_try_callback(self.config.callback_object, self.config.on_enter_unviewed_item, unpack(self.config.on_enter_unviewed_item_args))
	end

	if self.config.on_enter_required_rank then
		self._show_required_rank, self._required_rank = self:_try_callback(self.config.callback_object, self.config.on_enter_required_rank, unpack(self.config.on_enter_required_rank_args))
		self.config.disabled = self._show_required_rank
	end
end

function NewUnlockHeaderItem:update_size(dt, t, gui, layout_settings)
	NewUnlockHeaderItem.super.update_size(self, dt, t, gui, layout_settings)

	if self._has_unviewed_item then
		local scale = layout_settings.scale or 1
		local atlas_table = HUDHelper.atlas_texture_settings(layout_settings.texture_atlas, layout_settings.texture)

		self._texture_width = atlas_table.size[1] * scale
		self._texture_height = atlas_table.size[2] * scale

		local uv_00 = atlas_table.uv00
		local uv_11 = atlas_table.uv11

		self._texture_uv_00 = Vector2(uv_00[1], uv_00[2])
		self._texture_uv_11 = Vector2(uv_11[1], uv_11[2])
	end
end

function NewUnlockHeaderItem:update_position(dt, t, layout_settings, x, y, z)
	NewUnlockHeaderItem.super.update_position(self, dt, t, layout_settings, x, y, z)

	if self._has_unviewed_item then
		if layout_settings.texture_align_x == "right" then
			self._texture_x = self._x + self._width + (layout_settings.texture_offset_x or 0)
		else
			self._texture_x = self._x - self._texture_width
		end

		if layout_settings.texture_align_y == "top" then
			self._texture_y = self._y + self._height - self._texture_height + (layout_settings.texture_offset_y or 0)
		elseif layout_settings.texture_align_y == "center" then
			self._texture_y = self._y + self._height / 2 - self._texture_height / 2 + (layout_settings.texture_offset_y or 0)
		else
			self._texture_y = self._y + (layout_settings.texture_offset_y or 0)
		end
	end
end

function NewUnlockHeaderItem:render(dt, t, gui, layout_settings)
	NewUnlockHeaderItem.super.render(self, dt, t, gui, layout_settings)

	if self._has_unviewed_item then
		local color_table = layout_settings.texture_color
		local color = color_table and Color(color_table[1], color_table[2], color_table[3], color_table[4]) or Color(255, 255, 255, 255)
		local pos = Vector3(math.floor(self._texture_x), math.floor(self._texture_y), self._z)

		Gui.bitmap_uv(gui, layout_settings.texture_atlas, self._texture_uv_00, self._texture_uv_11, pos, Vector2(self._texture_width, self._texture_height), color)
	end

	if self._show_required_rank then
		self:_render_required_rank(dt, t, gui, layout_settings.required_rank)
	end
end

function NewUnlockHeaderItem:_render_required_rank(dt, t, gui, layout_settings)
	local x = self._x + layout_settings.offset_x
	local y = self._y + layout_settings.offset_y
	local z = self._z + layout_settings.offset_z
	local font_size = layout_settings.font_size
	local font = layout_settings.font.font
	local material = layout_settings.font.material
	local shadow_offset = layout_settings.drop_shadow_offset

	if layout_settings.align == "right" then
		x = x + self._width
	end

	local text = self._required_rank
	local min, max = Gui.text_extents(gui, text, font, font_size)
	local text_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local position = Vector3(x, y, z)
	local c = layout_settings.color
	local color = Color(c[1], c[2], c[3], c[4])

	c = layout_settings.drop_shadow_color

	local drop_shadow_color = Color(c[1], c[2], c[3], c[4])
	local drop_shadow_offset = Vector3(shadow_offset[1], shadow_offset[2], -1)

	ScriptGUI.text(gui, text, font, font_size, material, position, color, drop_shadow_color, drop_shadow_offset)

	if layout_settings.icon_atlas then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.icon_atlas, layout_settings.icon_material, layout_settings.masked)

		size = size * (layout_settings.icon_scale or 1)

		local icon_pos = Vector3(position[1] - size[1] + layout_settings.icon_offset[1], position[2] + text_extents[2] * 0.5 - size[2] * 0.5 + layout_settings.icon_offset[2], z)

		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos, size)
		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos + drop_shadow_offset, size, Color(0, 0, 0))

		if layout_settings.background_rect then
			local width = size[1] + text_extents[1] + layout_settings.icon_offset[1] + shadow_offset[1] * 2
			local height = size[2] > text_extents[2] and size[2] or text_extents[2]

			self:_render_required_rank_background(gui, icon_pos[1], icon_pos[2], width, height, layout_settings.background_rect)
		end
	end
end

function NewUnlockHeaderItem:_render_required_rank_background(gui, x, y, width, height, layout_settings)
	local x = x + layout_settings.offset_x
	local y = y + layout_settings.offset_y
	local size_x = width + (layout_settings.size_offset_x or 0)
	local size_y = height + (layout_settings.size_offset_y or 0)

	Gui.bitmap(gui, "rect_masked", Vector3(x, y, layout_settings.z or 0), Vector2(size_x, size_y), MenuHelper:color(layout_settings.color or {
		255,
		255,
		255
	}))

	if layout_settings.border_color then
		MenuHelper:render_border(gui, {
			x,
			y,
			size_x,
			size_y
		}, layout_settings.border_thickness, MenuHelper:color(layout_settings.border_color), layout_settings.z, "rect_masked")
	end
end

function NewUnlockHeaderItem.create_from_config(compiler_data, config, callback_object)
	local item_config = {
		type = "new_unlock_header_item",
		name = config.name,
		text = config.text,
		page = config.page,
		disabled = config.disabled,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func, config.disabled_func_args),
		callback_object = callback_object,
		layout_settings = config.layout_settings,
		text_func = config.text_func,
		no_localization = config.no_localization,
		on_select = config.on_select,
		on_select_args = config.on_select_args or {},
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args or {},
		on_enter_text = config.on_enter_text,
		on_enter_text_args = config.on_enter_text_args or {},
		on_enter_unviewed_item = config.on_enter_unviewed_item,
		on_enter_unviewed_item_args = config.on_enter_unviewed_item_args or {},
		on_enter_required_rank = config.on_enter_required_rank,
		on_enter_required_rank_args = config.on_enter_required_rank_args or {},
		sounds = config.sounds or MenuSettings.sounds.default.items.header_item
	}

	return NewUnlockHeaderItem:new(item_config, compiler_data.world)
end
