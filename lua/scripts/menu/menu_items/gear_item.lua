-- chunkname: @scripts/menu/menu_items/gear_item.lua

GearItem = class(GearItem, MenuItem)

function GearItem:init(config, world)
	GearItem.super.init(self, config, world)

	self._highlight_timer = 0
	self._mouse_over_timer = 0
	self._new_item = config.new_item
end

function GearItem:on_page_enter(on_cancel)
	GearItem.super.on_page_enter(self, on_cancel)

	local new_item = self:_try_callback(self.config.callback_object, self.config.on_highlight_new_item, unpack(self.config.on_highlight_new_item_args))

	if new_item ~= nil then
		self._new_item = new_item
	end
end

function GearItem:on_highlight(ignore_sound)
	GearItem.super.on_highlight(self, ignore_sound)

	self._new_item = self:_try_callback(self.config.callback_object, self.config.on_highlight_new_item, unpack(self.config.on_highlight_new_item_args)) or false
end

function GearItem:on_select(ignore_sound)
	if not self._available and Managers.persistence:profile_data() then
		local market_item_name = self.config.gear.entity_type .. "|" .. self.config.gear.name

		if self._reason == "rank_not_met" then
			self.config.page = MenuHelper:create_rank_not_met_popup_page(self._world, self.config.callback_object, self.config.gear.entity_type, self.config.gear.name, self.config.gear.ui_header, self.config.callback_object.config.z or 50, self.config.callback_object.config.sounds, self.config.reset_callback)
		elseif self._reason == "not_owned" then
			if ProfileHelper:exists_in_market(market_item_name) then
				self.config.page = MenuHelper:create_purchase_market_item_popup_page(self._world, self.config.callback_object, self.config.gear.entity_type, market_item_name, {
					self.config.gear.name,
					L(self.config.gear.ui_header)
				}, self.config.callback_object.config.z or 50, self.config.callback_object.config.sounds, self.config.reset_callback, callback(self.config.callback_object, self.config.on_select, unpack(self.config.on_select_args or {})))
			else
				Application.error("[GearItem] Gear " .. self.config.gear.entity_type .. "|" .. self.config.gear.name .. " doesn't exist in the market")
			end
		end
	else
		GearItem.super.on_select(self, ignore_sound)
	end
end

function GearItem:update_size(dt, t, gui, layout_settings)
	local min, max = Gui.text_extents(gui, L(self.config.name or ""), layout_settings.font.font, layout_settings.font_size)

	self._text_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}

	local material, uv00, uv11, size

	if layout_settings.atlas or layout_settings.atlas_func then
		local atlas_name = layout_settings.atlas

		if layout_settings.atlas_func then
			atlas_name = self:_try_callback(self.config.callback_object, layout_settings.atlas_func)
		end

		local material_name = self.config.on_select_args[1].ui_texture

		material, uv00, uv11, size = HUDHelper.atlas_material(atlas_name, material_name, nil, layout_settings.atlas_default_material or "default")
		size = size * (layout_settings.scale or 1)
	elseif layout_settings.texture_func then
		material, size = self:_try_callback(self.config.callback_object, layout_settings.texture_func, self.config.on_select_args[1], layout_settings)
		size = size * (layout_settings.scale or 1)
	end

	local padding_width = (layout_settings.padding_left or 0) + (layout_settings.padding_right or 0)
	local padding_height = (layout_settings.padding_top or 0) + (layout_settings.padding_bottom or 0)

	self._width = layout_settings.texture_background_rect and layout_settings.texture_background_rect.width + padding_width or layout_settings.texture_size and layout_settings.texture_size[1] + padding_width or size[1] + padding_width
	self._height = layout_settings.texture_background_rect and layout_settings.texture_background_rect.height + padding_height or layout_settings.texture_size and layout_settings.texture_size[2] + padding_height or size[2] + padding_height
end

function GearItem:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z or 0
	self._padded_x = x + (layout_settings.padding_left or 0)
	self._padded_y = y + (layout_settings.padding_bottom or 0)
end

function GearItem:is_mouse_inside(mouse_x, mouse_y)
	self._current_mouse_pos = Vector3Box(mouse_x, mouse_y, 0)

	local x1 = self._mouse_area_x or self._x - self.config.item_padding[1] * 0.5
	local y1 = self._mouse_area_y or self._y - self.config.item_padding[2] * 0.5
	local x2 = x1 + (self._mouse_area_width or self._width) + self.config.item_padding[1]
	local y2 = y1 + (self._mouse_area_height or self._height) + self.config.item_padding[2]
	local inside = x1 <= mouse_x and mouse_x <= x2 and y1 <= mouse_y and mouse_y <= y2

	return inside
end

function GearItem:_verify_item()
	if self.config.gear.market_price then
		local gear_data = self.config.gear
		local available, reason = ProfileHelper:is_entity_avalible(gear_data.entity_type, gear_data.name, gear_data.entity_type, gear_data.name, gear_data.release_name, gear_data.developer_item)

		self._available = available
		self._reason = reason
	else
		self._available = true
	end
end

function GearItem:render(dt, t, gui, layout_settings, render_from_child_page)
	self:_verify_item()
	self:_render_texture(dt, t, gui, layout_settings)
	self:_render_text(dt, t, gui, layout_settings)

	if layout_settings.texture_background_rect and self.config.gear.extravagance then
		self:_render_extravagance_background_rect(dt, t, gui, layout_settings)
	else
		self:_render_rect(dt, t, gui, layout_settings)
	end

	self:_render_mouse_over(dt, t, gui, layout_settings.mouse_over, render_from_child_page)
	self:_render_price(dt, t, gui, layout_settings.price)
	self:_render_new_item(dt, t, gui, layout_settings.new_item)
	self:_render_required_rank(dt, t, gui, layout_settings.required_rank)
end

function GearItem:render_from_child_page(dt, t, gui, layout_settings)
	self:render(dt, t, gui, layout_settings, true)
end

function GearItem:_render_new_item(dt, t, gui, layout_settings)
	if self._new_item and layout_settings then
		local scale = layout_settings.scale or 1
		local atlas_table = HUDHelper.atlas_texture_settings(layout_settings.texture_atlas, layout_settings.texture)
		local uv00 = Vector2(atlas_table.uv00[1], atlas_table.uv00[2])
		local uv11 = Vector2(atlas_table.uv11[1], atlas_table.uv11[2])
		local x = self._x + layout_settings.texture_offset_x
		local y = self._y + layout_settings.texture_offset_y
		local z = self._z + 5
		local pos = Vector3(x, y, z)
		local size = Vector2(atlas_table.size[1] * scale, atlas_table.size[2] * scale)
		local color_table = layout_settings.texture_color
		local color = Color(color_table[1], color_table[2], color_table[3], color_table[4])

		Gui.bitmap_uv(gui, layout_settings.texture_atlas_masked or layout_settings.texture_atlas, uv00, uv11, pos, size, color)
	end
end

function GearItem:_render_price(dt, t, gui, layout_settings, x, y, z, width, height)
	local profile_data = Managers.persistence:profile_data()

	if self._available or DLCSettings.premium() or not profile_data then
		return
	end

	local x = x or self._padded_x
	local y = y or self._padded_y
	local z = z or self._z
	local height = height or self._height
	local width = width or self._width
	local gear = self.config.gear
	local font_size = layout_settings.font_size
	local layer = layout_settings.z or z + 2
	local price = tostring(gear.market_price)
	local font = layout_settings.font.font
	local material = layout_settings.font.material
	local offset_x = layout_settings.offset_x
	local offset_y = layout_settings.offset_y
	local spacing = layout_settings.spacing
	local shadow_offset = layout_settings.shadow_offset
	local min, max = Gui.text_extents(gui, price, font, font_size)
	local price_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local shadow_offset_pos = Vector3(shadow_offset[1], shadow_offset[2], -1)
	local profile_coins = profile_data.attributes.coins
	local price_pos = Vector3(x + width + offset_x - price_extents[1], y + height + offset_y - price_extents[2], layer)

	if layout_settings.align_y == "bottom" then
		price_pos[2] = y + offset_y
	end

	local text_color = profile_coins < gear.market_price and layout_settings.disabled_text_color or layout_settings.text_color or {
		255,
		255,
		255,
		255
	}

	Gui.text(gui, price, font, font_size, material, price_pos, MenuHelper:color(text_color))
	Gui.text(gui, price, font, font_size, material, price_pos + shadow_offset_pos, Color(0, 0, 0))

	if layout_settings.icon_atlas then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.icon_atlas, layout_settings.icon_material, layout_settings.masked)

		size = size * (layout_settings.icon_scale or 1)

		local icon_pos = Vector3(price_pos[1] - size[1] + layout_settings.icon_offset[1], price_pos[2] + price_extents[2] * 0.5 - size[2] * 0.5 + layout_settings.icon_offset[2], layer)

		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos, size)
		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos + shadow_offset_pos, size, Color(0, 0, 0))

		if layout_settings.background_rect then
			local rect_size = {
				size[1] + price_extents[1] + layout_settings.icon_offset[1] + shadow_offset[1] * 2,
				size[2] > price_extents[2] and size[2] or price_extents[2]
			}

			self:_render_price_background(gui, icon_pos[1], icon_pos[2], rect_size[1], rect_size[2], layout_settings.background_rect)
		end
	else
		local icon_pos = Vector3(price_pos[1] - layout_settings.icon_size[1] + layout_settings.icon_offset[1], price_pos[2] + price_extents[2] * 0.5 - layout_settings.icon_size[2] * 0.5 + layout_settings.icon_offset[2], layer)

		Gui.bitmap(gui, layout_settings.icon_material, icon_pos, Vector2(layout_settings.icon_size[1], layout_settings.icon_size[2]))
		Gui.bitmap(gui, layout_settings.icon_material, icon_pos + shadow_offset_pos, Vector2(layout_settings.icon_size[1], layout_settings.icon_size[2]), Color(0, 0, 0))
	end
end

function GearItem:_render_required_rank(dt, t, gui, layout_settings, x, y, z, width, height)
	if self._available or not self._avaialable and self._reason == "not_owned" then
		return
	end

	local x = x or self._padded_x
	local y = y or self._padded_y
	local z = z or self._z
	local height = height or self._height
	local width = width or self._width
	local gear = self.config.gear
	local font_size = layout_settings.font_size
	local layer = layout_settings.z or z + 2
	local required_rank = tostring(ProfileHelper:required_entity_rank(self.config.gear.entity_type, self.config.gear.name))
	local font = layout_settings.font.font
	local material = layout_settings.font.material
	local offset_x = layout_settings.offset_x
	local offset_y = layout_settings.offset_y
	local spacing = layout_settings.spacing
	local shadow_offset = layout_settings.shadow_offset
	local min, max = Gui.text_extents(gui, required_rank, font, font_size)
	local required_rank_extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local shadow_offset_pos = Vector3(shadow_offset[1], shadow_offset[2], -1)
	local required_rank_pos = Vector3(x + width + offset_x - required_rank_extents[1], y + height + offset_y - required_rank_extents[2], layer)

	if layout_settings.align_y == "bottom" then
		required_rank_pos[2] = y + offset_y
	end

	local text_color = layout_settings.text_color or {
		255,
		255,
		255,
		255
	}

	Gui.text(gui, required_rank, font, font_size, material, required_rank_pos, MenuHelper:color(text_color))
	Gui.text(gui, required_rank, font, font_size, material, required_rank_pos + shadow_offset_pos, Color(0, 0, 0))

	if layout_settings.icon_atlas then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.icon_atlas, layout_settings.icon_material, layout_settings.masked)

		size = size * (layout_settings.icon_scale or 1)

		local icon_pos = Vector3(required_rank_pos[1] - size[1] + layout_settings.icon_offset[1], required_rank_pos[2] + required_rank_extents[2] * 0.5 - size[2] * 0.5 + layout_settings.icon_offset[2], layer)

		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos, size)
		Gui.bitmap_uv(gui, material, uv00, uv11, icon_pos + shadow_offset_pos, size, Color(0, 0, 0))

		if layout_settings.background_rect then
			local rect_size = {
				size[1] + required_rank_extents[1] + layout_settings.icon_offset[1] + shadow_offset[1] * 2,
				size[2] > required_rank_extents[2] and size[2] or required_rank_extents[2]
			}

			self:_render_price_background(gui, icon_pos[1], icon_pos[2], rect_size[1], rect_size[2], layout_settings.background_rect)
		end
	else
		local icon_pos = Vector3(required_rank_pos[1] - layout_settings.icon_size[1] + layout_settings.icon_offset[1], required_rank_pos[2] + required_rank_extents[2] * 0.5 - layout_settings.icon_size[2] * 0.5 + layout_settings.icon_offset[2], layer)

		Gui.bitmap(gui, layout_settings.icon_material, icon_pos, Vector2(layout_settings.icon_size[1], layout_settings.icon_size[2]))
		Gui.bitmap(gui, layout_settings.icon_material, icon_pos + shadow_offset_pos, Vector2(layout_settings.icon_size[1], layout_settings.icon_size[2]), Color(0, 0, 0))
	end
end

function GearItem:_render_price_background(gui, x, y, size_x, size_y, layout_settings)
	local x = x + layout_settings.offset_x
	local y = y + layout_settings.offset_y
	local size_x = size_x + (layout_settings.size_offset_x or 0)
	local size_y = size_y + (layout_settings.size_offset_y or 0)

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

function GearItem:_render_mouse_over(dt, t, gui, layout_settings, render_from_child_page)
	if not layout_settings or render_from_child_page then
		return
	end

	local layer = layout_settings.z or self._z + 50
	local gear = self.config.on_select_args[1]

	if gear and layout_settings and self._highlighted and self._current_mouse_pos then
		self._mouse_over_timer = math.max((self._mouse_over_timer or 0) - dt, 0)

		if self._mouse_over_timer == 0 then
			local w, h = Gui.resolution()
			local alignment_offset_x = 0
			local align_towards_center = layout_settings.alignment == "towards_center"

			if align_towards_center and self._current_mouse_pos[1] > w * 0.5 or not align_towards_center and self._current_mouse_pos[1] < w * 0.5 then
				alignment_offset_x = -(layout_settings.width + (layout_settings.spacing or 0) * 1.5 + (layout_settings.offset_x or 0))
			end

			local pos = self._current_mouse_pos:unbox() - Vector3(-(layout_settings.spacing or 0), layout_settings.spacing or 0, 0) - Vector3(layout_settings.offset_x or 0, layout_settings.offset_y or 0, 0) + Vector3(alignment_offset_x, 0, layer)

			Gui.text(gui, L(gear.ui_header), layout_settings.header_font.font, layout_settings.header_font_size, layout_settings.header_font.material, pos, MenuHelper:color(self:_try_callback(self.config.callback_object, layout_settings.header_color_func)))

			pos[2] = pos[2] - layout_settings.header_spacing

			if gear.ui_description then
				local description_texts = MenuHelper:format_text(L(gear.ui_description), gui, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.text_width or layout_settings.width)

				for i, text in ipairs(description_texts) do
					Gui.text(gui, text, layout_settings.text_font.font, layout_settings.text_font_size, layout_settings.text_font.material, pos + Vector3(0, 0, layer))

					pos[2] = pos[2] - layout_settings.spacing
				end
			end

			local rect_pos = self._current_mouse_pos:unbox() + Vector3(alignment_offset_x, 0, layer - 1)
			local rect_size = Vector2(layout_settings.width + (layout_settings.spacing or 0) * 1.5 + (layout_settings.offset_x or 0), pos[2] - rect_pos[2] - (layout_settings.spacing or 0) + (layout_settings.offset_y or 0))

			Gui.rect(gui, rect_pos, rect_size, MenuHelper:color(layout_settings.background_color))
			MenuHelper:render_border(gui, {
				rect_pos[1],
				rect_pos[2],
				rect_size[1],
				rect_size[2]
			}, layout_settings.border_thickness, MenuHelper:color(layout_settings.border_color), layer)

			local price_offset_x = 0
			local spacing = 0

			if gear.market_price and not self._available then
				self:_render_price(dt, t, gui, layout_settings.price, rect_pos[1], rect_pos[2] + rect_size[2], nil, rect_size[1], -rect_size[2])
			end

			if not self._available and self._reason == "rank_not_met" then
				-- block empty
			end
		end
	else
		self._mouse_over_timer = layout_settings.highlight_timer
	end
end

function GearItem:_render_texture(dt, t, gui, layout_settings)
	local c = self._highlighted and layout_settings.highlighted_texture_color or self.config.disabled and layout_settings.disabled_texture_colour or layout_settings.texture_color or {
		255,
		255,
		255,
		255
	}
	local color = MenuHelper:color(c)

	if layout_settings.atlas or layout_settings.atlas_func then
		local atlas = layout_settings.atlas

		if layout_settings.atlas_func then
			atlas = self:_try_callback(self.config.callback_object, layout_settings.atlas_func)
		end

		local material_name = self.config.on_select_args[1].ui_texture
		local material, uv00, uv11, size = HUDHelper.atlas_material(atlas, material_name, true, layout_settings.atlas_default_material or "default")
		local pos = Vector3(self._padded_x, self._padded_y, self._z + 1)

		size = size * (layout_settings.scale or 1)

		local highlight_time = 0.1

		if self._highlighted then
			self._highlight_timer = math.min(self._highlight_timer + dt, highlight_time)
		else
			self._highlight_timer = math.max(self._highlight_timer - dt, 0)
		end

		pos[1] = pos[1] + size[1] * 0.5
		pos[2] = pos[2] + size[2] * 0.5
		pos[3] = pos[3] + (self._highlighted and 1 or 0)
		size = size * math.max(1, 1 + ((layout_settings.scale_on_highlight or 0) - 1) * (self._highlight_timer / highlight_time) or 1)
		pos[1] = pos[1] - size[1] * 0.5 + (layout_settings.texture_offset_x or 0)
		pos[2] = pos[2] - size[2] * 0.5 + (layout_settings.texture_offset_y or 0)

		local offset = 2
		local material = not self._available and (layout_settings.atlas_unavailable_material or material) or layout_settings.atlas_material or material

		offset = offset * math.max(1, 1 + ((layout_settings.scale_on_highlight or 0) - 1) * (self._highlight_timer / highlight_time) or 1)

		Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(-offset, offset, 1), size, color)
		Gui.bitmap_uv(gui, material, uv00, uv11, pos + Vector3(offset, -offset, 0), size + Vector2(offset, -offset), MenuHelper:color(layout_settings.drop_shadow_color or {
			160,
			60,
			60,
			60
		}))
		self:_render_mask(gui, pos + Vector3(-offset, offset, 1), size, layout_settings.mask, layout_settings.mask_func, layout_settings)
	elseif layout_settings.texture_func then
		local material, size, material_func_color = self:_try_callback(self.config.callback_object, layout_settings.texture_func, self.config.on_select_args[1], layout_settings)

		color = material_func_color or color

		if not self._available and layout_settings.available_parameter then
			local material = Gui.material(gui, material)

			Material.set_scalar(material, layout_settings.available_parameter, 1)
		elseif layout_settings.available_parameter then
			local material = Gui.material(gui, material)

			Material.set_scalar(material, layout_settings.available_parameter, 0)
		end

		size = size * (layout_settings.scale or 1)

		local pos = Vector3(self._padded_x, self._padded_y, self._z + 1)
		local highlight_time = 0.1

		if self._highlighted then
			self._highlight_timer = math.min(self._highlight_timer + dt, highlight_time)
		else
			self._highlight_timer = math.max(self._highlight_timer - dt, 0)
		end

		pos[1] = pos[1] + size[1] * 0.5
		pos[2] = pos[2] + size[2] * 0.5
		pos[3] = pos[3] + (self._highlighted and 1 or 0)
		size = size * math.max(1, 1 + ((layout_settings.scale_on_highlight or 0) - 1) * (self._highlight_timer / highlight_time) or 1)
		pos[1] = pos[1] - size[1] * 0.5 + (layout_settings.texture_offset_x or 0)
		pos[2] = pos[2] - size[2] * 0.5 + (layout_settings.texture_offset_y or 0)

		local offset = layout_settings.drop_shadow_offset or 2

		offset = offset * math.max(1, 1 + ((layout_settings.scale_on_highlight or 0) - 1) * (self._highlight_timer / highlight_time) or 1)

		Gui.bitmap(gui, material, pos + Vector3(-offset, offset, 1), size, color)

		if not layout_settings.hide_shadow then
			Gui.bitmap(gui, material, pos + Vector3(offset, -offset, 0), size + Vector2(offset, -offset), MenuHelper:color(layout_settings.drop_shadow_color or {
				160,
				60,
				60,
				60
			}))
		end

		self:_render_mask(gui, pos + Vector3(-offset, offset, 1), size, layout_settings.mask, layout_settings.mask_func, layout_settings)
	else
		local material_name = self.config.on_select_args[1].ui_texture
		local pos = Vector3(self._padded_x + (layout_settings.texture_offset_x or 0), self._padded_y + (layout_settings.texture_offset_y or 0), self._z + 1)

		Gui.bitmap(gui, material_name, pos, Vector2(layout_settings.texture_size[1], layout_settings.texture_size[2]), color)
		self:_render_mask(gui, pos, size, layout_settings.mask, layout_settings.mask_func, layout_settings)
	end
end

function GearItem:_render_mask(gui, pos, size, mask, mask_func, layout_settings)
	if not mask and not mask_func then
		return
	end

	if mask then
		Gui.bitmap(gui, mask, pos, size)
	elseif mask_func then
		local material, material_size = self:_try_callback(self.config.callback_object, mask_func, layout_settings)

		size = material_size or size

		Gui.bitmap(gui, material, pos, size)
	end
end

function GearItem:_render_text(dt, t, gui, layout_settings)
	if layout_settings.hide_info then
		return
	end

	local offset_x = layout_settings.text_offset_x or 0
	local offset_y = layout_settings.text_offset_y or 0
	local offset_z = layout_settings.text_offset_z or 2
	local pos = Vector3(self._padded_x + offset_x, self._padded_y + offset_y, self._z + offset_z)

	if layout_settings.align_text_x then
		if layout_settings.align_text_x == "right" then
			pos[1] = self._padded_x + self._width - self._text_extents[1] + offset_x
		elseif layout_settings.align_text_x == "center" then
			pos[1] = self._padded_x + self._width * 0.5 - self._text_extents[1] * 0.5 + offset_x
		end
	end

	if layout_settings.align_text_y then
		if layout_settings.align_text_y == "top" then
			pos[2] = self._padded_y + self._height - self._text_extents[2] + offset_y
		elseif layout_settings.align_text_y == "center" then
			pos[2] = self._padded_y + self._height * 0.5 - self._text_extents[2] * 0.5 + offset_y
		end
	end

	local text = L(self.config.name)
	local font = layout_settings.font.font
	local font_size = layout_settings.font_size
	local width = self._width - (layout_settings.padding_left or 0) - (layout_settings.padding_right or 0)

	text = HUDHelper:crop_text(gui, text, font, font_size, width - (layout_settings.padding_right or 0), "...")

	local back_assets = layout_settings.text_background_atlas
	local back_assets_masked = layout_settings.text_background_atlas_material
	local back_texture = layout_settings.text_background_texture

	if back_assets and back_assets_masked and back_texture then
		local text_offset, text_width, text_height = HUDHelper.text_align(gui, text, font, font_size)

		ScriptGUI.bitmap_uv_tiled(gui, back_assets_masked, HUDHelper.atlas_texture_settings(back_assets, back_texture), Vector3(pos.x, pos.y, pos.z - 1), Vector2(text_width, text_height), MenuHelper:color(layout_settings.text_background_color))
	end

	Gui.text(gui, text, font, font_size, layout_settings.font.material, pos, MenuHelper:color(self._highlighted and layout_settings.highlighted_text_color or layout_settings.text_color))
end

function GearItem:_render_extravagance_background_rect(dt, t, gui, layout_settings)
	local extravagance = self.config.gear.extravagance
	local rect_layout_settings = extravagance == 1 and layout_settings.texture_background_rect_stone or extravagance == 2 and layout_settings.texture_background_rect_wood or extravagance == 3 and layout_settings.texture_background_rect_fabric
	local width = rect_layout_settings.width
	local height = rect_layout_settings.height

	MenuHelper:render_texture_background_rect(dt, t, gui, rect_layout_settings, self._available, self._highlighted, 1, self._x + self._width / 2 - width / 2, self._y + self._height / 2 - height / 2, self._z, width, height)
end

function GearItem:_render_rect(dt, t, gui, layout_settings)
	local texture = layout_settings.rect_texture
	local width = self._width - (layout_settings.padding_left or 0) - (layout_settings.padding_right or 0)
	local height = self._height - (layout_settings.padding_top or 0) - (layout_settings.padding_bottom or 0)

	if texture then
		local atlas = layout_settings.rect_texture_atlas
		local color = MenuHelper:color(self._highlighted and layout_settings.highlighted_rect_color or layout_settings.rect_color)

		if atlas then
			ScriptGUI.bitmap_uv_tiled(gui, layout_settings.rect_texture_atlas_material or layout_settings.rect_texture_atlas, HUDHelper.atlas_texture_settings(atlas, texture), Vector3(self._padded_x, self._padded_y, self._z), Vector2(width, height), color)
		else
			local tile_x = math.ceil(width / layout_settings.rect_texture_size[1])
			local tile_y = math.ceil(height / layout_settings.rect_texture_size[2])

			for i = 1, tile_x do
				for j = 1, tile_y do
					local uv11 = Vector2(math.min((width - (i - 1) * layout_settings.rect_texture_size[1]) / layout_settings.rect_texture_size[1], 1), math.min((height - (j - 1) * layout_settings.rect_texture_size[2]) / layout_settings.rect_texture_size[2], 1))
					local pos = Vector3(self._padded_x + (i - 1) * layout_settings.rect_texture_size[1] + (layout_settings.texture_offset_x or 0), self._padded_y + (j - 1) * layout_settings.rect_texture_size[2] + (layout_settings.texture_offset_y or 0), self._z)
					local size = Vector2(layout_settings.rect_texture_size[1] * uv11[1], layout_settings.rect_texture_size[2] * uv11[2])

					Gui.bitmap_uv(gui, texture, Vector2(0, 0), uv11, pos, size, color)
				end
			end
		end

		MenuHelper:render_border(gui, {
			self._padded_x,
			self._padded_y,
			width,
			height
		}, 3, MenuHelper:color(self._highlighted and layout_settings.highlighted_border_color or layout_settings.border_color or {
			255,
			0,
			0,
			0
		}), 4, "rect_masked")
	else
		Gui.bitmap(gui, "rect_masked", Vector3(self._padded_x + (layout_settings.texture_offset_x or 0), self._padded_y + (layout_settings.texture_offset_y or 0), self._z), Vector2(width, height), MenuHelper:color(self._highlighted and layout_settings.highlighted_rect_color or layout_settings.rect_color))
	end
end

function GearItem.create_from_config(compiler_data, config, callback_object)
	local category_config = {
		type = "gear_item",
		name = config.name,
		layout_settings = config.layout_settings,
		callback_object = callback_object,
		on_select = config.on_select,
		on_select_args = config.on_select_args,
		on_highlight = config.on_highlight,
		on_highlight_args = config.on_highlight_args,
		remove_func = config.remove_func and callback(callback_object, config.remove_func),
		remove_args = config.remove_args,
		disabled_func = config.disabled_func and callback(callback_object, config.disabled_func),
		disabled_args = config.disabled_args,
		sounds = config.sounds and config.sounds.items.gear_item or MenuSettings.sounds.default.items.gear_item,
		item_padding = config.item_padding,
		gear = config.on_select_args and config.on_select_args[1],
		reset_callback = config.reset_callback,
		tier = config.tier,
		index = config.index,
		new_item = config.new_item or false,
		on_highlight_new_item = config.on_highlight_new_item,
		on_highlight_new_item_args = config.on_highlight_new_item_args or {}
	}

	return GearItem:new(category_config, compiler_data.world)
end
