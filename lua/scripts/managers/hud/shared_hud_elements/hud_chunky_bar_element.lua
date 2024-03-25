-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_chunky_bar_element.lua

require("scripts/hud/hud_assets")

HUDChunkyBarElement = class(HUDChunkyBarElement)

local fade_functions = {
	low_hi = function(time, duration)
		return math.sin(math.pi * 0.5 * (time / duration)) * 255
	end,
	hi_low = function(time, duration)
		return math.sin(math.pi * 0.5 * (1 - time / duration)) * 255
	end,
	low_hi_low = function(time, duration)
		return math.sin(math.pi * (time / duration)) * 255
	end,
	hi_low_hi = function(time, duration)
		return math.abs(math.cos(math.pi * (time / duration))) * 255
	end,
	flat = function(time, duration)
		return 255
	end
}

function HUDChunkyBarElement:init(config)
	self._width = nil
	self._height = nil
	self.config = config
	self._progress = 1
	self._goal_progress = 1
	self._old_progress = 1
	self._chunk_width = 0
	self._pulse_t = 1
	self._pulse = nil
end

function HUDChunkyBarElement:start_pulse(pulse_data)
	self._pulse = pulse_data
end

function HUDChunkyBarElement:has_pulse()
	return self._pulse and true or false
end

function HUDChunkyBarElement:stop_pulse()
	self._pulse = nil
end

function HUDChunkyBarElement:width()
	return self._width
end

function HUDChunkyBarElement:height()
	return self._height
end

function HUDChunkyBarElement:set_progress_fail(progress)
	self._progress_fail_set = progress
end

function HUDChunkyBarElement:set_progress(progress)
	if self._old_progress ~= progress then
		progress = math.clamp(progress, 0, 1)
		self._old_progress = progress
		self._progress_set = progress
	end
end

function HUDChunkyBarElement:update_size(dt, t, gui, layout_settings)
	self._width = layout_settings.bar_width
	self._height = layout_settings.bar_height
end

function HUDChunkyBarElement:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HUDChunkyBarElement:render_pixel_chunk(gui, data, layout_settings, from_x, c)
	local texture_name = data.texture_name
	local material, uv00, uv11, size = HudAssets.get(texture_name)
	local color = Color(c[1], c[2], c[3], c[4])
	local bar_width = layout_settings.bar_width
	local w = size[1]
	local h = layout_settings.pixel_chunk_height_override or size[2]
	local x = data.align == "center" and math.floor(from_x - w / 2) or math.floor(from_x)
	local y = math.floor(self._y + (layout_settings.texture_offset_y or 0)) + (layout_settings.pixel_offset_y or 0)
	local z = self._z + (data.z or 1)

	Gui.bitmap_uv(gui, material, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), Vector3(x, y, z), Vector2(w, h), color)
end

function HUDChunkyBarElement:render_chunk(gui, data, layout_settings, from_x, width, bar_color)
	local texture_name = data and data.texture_name or layout_settings.lose_texture
	local material, uv00, uv11, size = HudAssets.get(texture_name)
	local c = bar_color or {
		255,
		255,
		0,
		0
	}
	local color = Color(c[1], c[2], c[3], c[4])
	local bar_width = layout_settings.bar_width
	local bar_height = layout_settings.bar_height
	local x = from_x
	local y = math.floor(self._y + (layout_settings.texture_offset_y or 0)) + (layout_settings.chunk_offset_y or 0)
	local z = self._z + (data and data.z or 1)
	local w = bar_width * width
	local h = layout_settings.background_size and layout_settings.background_size[2] or layout_settings.chunk_height_override or size[2]

	Gui.bitmap_uv(gui, material, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), Vector3(x, y, z), Vector2(w, h), color)
end

function HUDChunkyBarElement:glowing_end(gui, texture_name, layout_settings, from_x, color)
	local material, uv00, uv11, size = HudAssets.get(texture_name)
	local end_x = from_x + math.floor(layout_settings.bar_width * self._chunk_width + 1)

	self:render_pixel_chunk(gui, {
		z = 2,
		align = "center",
		texture_name = texture_name
	}, layout_settings, end_x, color)
	self:render_pixel_chunk(gui, {
		z = 2,
		align = "center",
		texture_name = texture_name
	}, layout_settings, from_x + 1, color)
end

function HUDChunkyBarElement:main_glowing_end(gui, layout_settings, from_x, color)
	local texture_name = layout_settings.texture_glow_h or "life_lit_glow_horizontal"
	local material, uv00, uv11, size = HudAssets.get(texture_name)
	local end_x = math.floor(from_x + layout_settings.bar_width * self._chunk_width)

	self:render_pixel_chunk(gui, {
		z = 2,
		align = "center",
		texture_name = texture_name
	}, layout_settings, end_x, color)
end

function HUDChunkyBarElement:_render_background_texture(gui, layout_settings, config)
	local bg_texture = layout_settings.background_texture

	if bg_texture then
		local bgr_c = config.blackboard and config.blackboard.background_texture_color or self.config.background_texture_color or layout_settings.background_texture_color or {
			255,
			255,
			255,
			255
		}
		local bgr_color = Color(bgr_c[1], bgr_c[2], bgr_c[3], bgr_c[4])
		local bgr_size = layout_settings.background_size and Vector2(layout_settings.background_size[1], layout_settings.background_size[2])

		HudAssets.bitmap_asset(gui, bg_texture, Vector3(math.floor(self._x), math.floor(self._y), self._z), bgr_size, bgr_color)
	end
end

function HUDChunkyBarElement:_render_foreground_texture(gui, layout_settings, config)
	local fg_texture = layout_settings.foreground_texture

	if fg_texture then
		local fgr_c = config.blackboard and config.blackboard.background_texture_color or self.config.background_texture_color or layout_settings.background_texture_color or {
			255,
			255,
			255,
			255
		}
		local fgr_color = Color(fgr_c[1], fgr_c[2], fgr_c[3], fgr_c[4])
		local fg_texture_x = math.floor(self._x + (layout_settings.foreground_texture_offset_x or 0))
		local fg_texture_y = math.floor(self._y + (layout_settings.foreground_texture_offset_y or 0))

		HudAssets.bitmap_asset(gui, fg_texture, Vector3(fg_texture_x, fg_texture_y, self._z + 3), nil, fgr_color)
	end
end

function HUDChunkyBarElement:_render_fail_bar(dt, t, gui, layout_settings, config, texture_x)
	if self._progress_fail_goal then
		if t <= self._fail_timer then
			local time = (layout_settings.fail_duration or 0.5) - (self._fail_timer - t)
			local fail_alpha = fade_functions.low_hi_low(time, layout_settings.fail_duration or 0.5)
			local fail_color = {
				fail_alpha,
				255,
				255,
				255
			}
			local fail_texture = "stamina_red_default" or layout_settings.fail_texture

			self:render_chunk(gui, {
				z = 1,
				texture_name = fail_texture
			}, layout_settings, texture_x, self._progress_fail_goal, fail_color)
		else
			self._fail_timer = nil
			self._progress_fail_goal = nil
		end
	end
end

function HUDChunkyBarElement:_render_pre_cut(gui, layout_settings, config, from_x, color)
	local glow_texture_name = layout_settings.texture_glow_h

	self:render_pixel_chunk(gui, {
		z = 2,
		align = "center",
		texture_name = glow_texture_name
	}, layout_settings, math.floor(from_x), color)

	local end_x = from_x + math.floor(layout_settings.bar_width * self._chunk_width + 1)

	self:render_pixel_chunk(gui, {
		z = 2,
		align = "center",
		texture_name = glow_texture_name
	}, layout_settings, end_x, color)
end

function HUDChunkyBarElement:_render_chunk_lost(time, duration, gui, layout_settings, config, from_x, color)
	local hi_alpha = math.sin(math.pi * 0.5 * (1 - time / duration)) * 255
	local lo_alpha = 255 - hi_alpha
	local lo_color = {
		lo_alpha,
		255,
		255,
		255
	}
	local lose_texture = layout_settings.lose_texture or "life_default_red"

	self:render_chunk(gui, {
		z = 1,
		texture_name = lose_texture
	}, layout_settings, from_x, self._chunk_width, lo_color)

	local glow_texture_name = layout_settings.lose_texture_glow_h or "life_lit_glow_horizontal_red"

	self:glowing_end(gui, glow_texture_name, layout_settings, from_x, color)

	local hi_color = {
		hi_alpha,
		255,
		255,
		255
	}
	local texture2 = layout_settings.lose_texture_glow_v

	self:render_chunk(gui, {
		z = 2,
		texture_name = texture2
	}, layout_settings, from_x, self._chunk_width, hi_color)
end

function HUDChunkyBarElement:render(dt, t, gui, layout_settings)
	local total_time = layout_settings.lose_time or 0.5
	local config = self.config

	if self._progress_set then
		self._goal_progress = self._progress_set
		self._progress_set = nil

		if self._goal_progress > self._progress then
			if layout_settings.continuous_growth then
				self._state = "LERPED_GAIN"
				self._chunk_width = 0
			else
				self._state = "GAIN"
				self._chunk_width = math.abs(self._goal_progress - self._progress)
				self._start_progress = self._progress
			end
		elseif layout_settings.continuous_loss then
			self._state = "LERPED_LOSS"
			self._chunk_width = 0
		else
			self._state = "LOSE"

			if layout_settings.combine_loss and self._progress ~= self._goal_progress then
				if config.reverse_bar then
					self._chunk_width = self._chunk_width - (self._progress - self._goal_progress)
				else
					self._chunk_width = self._chunk_width + (self._progress - self._goal_progress)
				end

				self._progress = self._goal_progress
			else
				self._start_progress = self._progress
				self._chunk_width = self._progress - self._goal_progress
				self._progress = self._goal_progress
			end
		end

		self._chunk_timer = t + total_time
	end

	if self._progress_fail_set and layout_settings.fail_texture then
		self._fail_timer = t + (layout_settings.fail_duration or 1)
		self._progress_fail_goal = self._progress_fail_set
		self._progress_fail_set = nil
	end

	self:_render_background_texture(gui, layout_settings, config)
	self:_render_foreground_texture(gui, layout_settings, config)

	local texture_name = layout_settings.texture
	local material, uv00, uv11, size = HudAssets.get(texture_name)
	local uv_x00, uv_x10

	if layout_settings.uv_progress_scale then
		local new_width = (uv11[1] - uv00[1]) * self._progress

		uv_x00 = not config.reverse_bar and uv11[1] - new_width or uv00[1]
		uv_x10 = config.reverse_bar and uv00[1] + new_width or uv11[1]
	else
		uv_x00 = uv00[1]
		uv_x10 = uv11[1]
	end

	local c = config.blackboard and config.blackboard.texture_color or self.config.texture_color or layout_settings.texture_color or {
		255,
		255,
		255,
		255
	}
	local color
	local pulse = self._pulse or layout_settings.pulse

	if pulse then
		local progress = pulse.min_max_scale_function(self._progress)
		local frequency = math.lerp(pulse.min.frequency, pulse.max.frequency, progress)

		self._pulse_t = (self._pulse_t + frequency * dt) % 2

		local pulse_t = pulse.pulse_function(math.abs(self._pulse_t - 1))
		local a, r, g, b = c[1], c[2], c[3], c[4]

		if pulse.min.color and pulse.max.color then
			local inverted_pulse_t = 1 - pulse_t

			a = pulse_t * pulse.max.color[1] + inverted_pulse_t * pulse.min.color[1]
			r = pulse_t * pulse.max.color[2] + inverted_pulse_t * pulse.min.color[2]
			g = pulse_t * pulse.max.color[3] + inverted_pulse_t * pulse.min.color[3]
			b = pulse_t * pulse.max.color[4] + inverted_pulse_t * pulse.min.color[4]
		end

		local color_multiplier_min = math.lerp(pulse.min.color_multiplier_min, pulse.max.color_multiplier_min, progress)
		local color_multiplier_max = math.lerp(pulse.min.color_multiplier_max, pulse.max.color_multiplier_max, progress)
		local color_mul = math.lerp(color_multiplier_min, color_multiplier_max, pulse_t)

		color = Color(a, color_mul * r, color_mul * g, color_mul * b)
	else
		color = Color(c[1], c[2], c[3], c[4])
	end

	local width = (layout_settings.bar_width_override or layout_settings.bar_width) * self._progress
	local remaining_width = (layout_settings.bar_width_override or layout_settings.bar_width) * (1 - self._progress)
	local texture_x_offset = config.reverse_bar and remaining_width or 0
	local texture_x = math.floor(self._x + (layout_settings.texture_offset_x or 0) + texture_x_offset)
	local texture_y = math.floor(self._y + (layout_settings.texture_offset_y or 0))
	local texture_w = width
	local texture_h = layout_settings.bar_height_override or layout_settings.background_size and layout_settings.background_size[2] or size[2] or layout_settings.bar_height
	local cut_edge_fadeout = layout_settings.cut_edge_fadeout == nil or layout_settings.cut_edge_fadeout
	local cut_edge_fadeout_duration = 0.3
	local cut_edge_fadeout_func = fade_functions.hi_low
	local darken_main_bar = layout_settings.darken_main_bar
	local lighten_main_bar = layout_settings.lighten_main_bar
	local show_pre_cut = layout_settings.show_pre_cut
	local main_bar_cut_duration = show_pre_cut and 0.3 or 0

	self:_render_fail_bar(dt, t, gui, layout_settings, config, texture_x)

	local bar_position = texture_x + (not config.reverse_bar and texture_w or 0)

	if self._state == "LOSE" then
		if self._chunk_timer then
			local t5, t6 = 0, main_bar_cut_duration
			local t3, t4 = 0, 0.4
			local t1, t2 = main_bar_cut_duration, total_time
			local time = t - (self._chunk_timer - total_time)
			local from_x = bar_position
			local base_color = {
				255,
				255,
				255,
				255
			}

			if show_pre_cut and t5 <= time and time <= t6 then
				self:_render_pre_cut(gui, layout_settings, config, from_x, base_color)
			end

			if t < self._chunk_timer then
				if t1 <= time and time <= t2 then
					self:_render_chunk_lost(time - t1, t2 - t1, gui, layout_settings, config, from_x, base_color)

					if (darken_main_bar or lighten_main_bar) and t3 <= time and time <= t4 then
						local texture_name2 = "life_lit_glow_vertical" or layout_settings.texture
						local material2, uv00, uv11, size = HudAssets.get(texture_name2)
						local m_time = time - t3
						local m_duration = t4 - t3
						local m_alpha = 127 + math.abs(math.cos(math.pi * (m_time / m_duration))) * 128

						if darken_main_bar then
							color = Color(m_alpha, 255, 255, 255)
						end

						if lighten_main_bar then
							local main_bar_color = Color(m_alpha, 255, 255, 255)

							Gui.bitmap_uv(gui, material2, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), Vector3(texture_x, texture_y, self._z + 2), Vector2(texture_w, texture_h), main_bar_color)
						end
					end
				else
					self:render_chunk(gui, {
						texture_name = "life_default"
					}, layout_settings, from_x, self._chunk_width, base_color)
				end
			else
				local preserved_chunk_width = self._chunk_width

				self._chunk_width = math.lerp(self._chunk_width, 0, layout_settings.lose_lerp_speed or 0.2)

				local texture_name = layout_settings.lose_texture or "life_default_red"
				local chunk_render_x = config.reverse_bar and from_x - self._chunk_width or from_x + self._chunk_width

				self:render_chunk(gui, {
					texture_name = texture_name
				}, layout_settings, chunk_render_x, self._chunk_width, base_color)

				if config.reverse_bar and self._chunk_width > -0.003 or not config.reverse_bar and self._chunk_width < 0.003 then
					self._chunk_timer = nil
					self._state = "LOSE_AFTERMATH"
					self._aftermath_timer = t
				end

				local glow_texture_name = layout_settings.lose_texture_glow_h or "life_lit_glow_horizontal_red"

				self:glowing_end(gui, glow_texture_name, layout_settings, from_x, base_color)
			end
		end
	elseif self._state == "LOSE_AFTERMATH" then
		local time = t - self._aftermath_timer

		if cut_edge_fadeout then
			if time < cut_edge_fadeout_duration then
				local hi_alpha = cut_edge_fadeout_func(time, cut_edge_fadeout_duration)
				local base_color = {
					hi_alpha,
					255,
					255,
					255
				}
				local from_x = bar_position
				local end_x = config.reverse_bar and from_x or math.floor(from_x + layout_settings.bar_width * self._chunk_width)
				local glow_texture_name = layout_settings.texture_glow_h

				self:render_pixel_chunk(gui, {
					z = 2,
					align = "center",
					texture_name = glow_texture_name
				}, layout_settings, end_x, base_color)
			else
				self._chunk_width = 0
				self._state = nil
			end
		end
	elseif self._state == "GAIN" then
		if self._chunk_timer then
			local base_color = {
				255,
				255,
				255,
				255
			}
			local from_x = texture_x + texture_w

			if t < self._chunk_timer then
				local time = t - (self._chunk_timer - total_time)
				local t1, t2 = main_bar_cut_duration, total_time
				local hi_duration = t2 - t1

				if t1 <= time and time <= t2 then
					local hi_time = time - t1
					local hi_alpha = math.sin(math.pi * 0.5 * (1 - hi_time / hi_duration)) * 255
					local lo_alpha = 255 - hi_alpha
					local lo_color = {
						lo_alpha,
						255,
						255,
						255
					}
					local grow_texture = layout_settings.grow_texture or "life_default"

					self:render_chunk(gui, {
						z = 1,
						texture_name = grow_texture
					}, layout_settings, from_x, self._chunk_width, lo_color, false)

					local glow_texture_name = layout_settings.grow_texture_glow_h

					self:glowing_end(gui, glow_texture_name, layout_settings, from_x, base_color)

					local hi_color = {
						hi_alpha,
						255,
						255,
						255
					}
					local texture2 = layout_settings.grow_texture_glow_v

					self:render_chunk(gui, {
						z = 2,
						texture_name = texture2
					}, layout_settings, from_x, self._chunk_width, hi_color, false)
				end
			else
				self._chunk_timer = nil

				if self._start_progress then
					self._progress = self._start_progress
				end
			end
		else
			local base_color = {
				255,
				255,
				255,
				255
			}

			self._progress = math.lerp(self._progress, self._goal_progress, 0.2)

			if math.abs(self._progress - self._goal_progress) < 0.001 then
				self._state = "GAIN_AFTERMATH"
				self._progress = self._goal_progress
				self._aftermath_timer = t
			else
				local from_x = math.floor(texture_x + texture_w - self._chunk_width * layout_settings.bar_width)

				self:main_glowing_end(gui, layout_settings, from_x, base_color)
			end
		end
	elseif self._state == "GAIN_AFTERMATH" then
		local time = t - self._aftermath_timer

		if cut_edge_fadeout then
			if time < cut_edge_fadeout_duration then
				local hi_alpha = cut_edge_fadeout_func(time, cut_edge_fadeout_duration)
				local base_color = {
					hi_alpha,
					255,
					255,
					255
				}
				local from_x = texture_x + texture_w
				local end_x = math.floor(from_x)
				local glow_texture_name = layout_settings.texture_glow_h

				self:render_pixel_chunk(gui, {
					z = 2,
					align = "center",
					texture_name = glow_texture_name
				}, layout_settings, end_x, base_color)
			else
				self._state = nil
				self._chunk_width = 0
			end
		end
	elseif self._state == "LERPED_GAIN" or self._state == "LERPED_LOSS" then
		self._progress = math.lerp(self._progress, self._goal_progress, 0.2)
	end

	Gui.bitmap_uv(gui, material, Vector2(uv_x00, uv00[2]), Vector2(uv_x10, uv11[2]), Vector3(texture_x, texture_y, self._z + 1), Vector2(texture_w, texture_h), color)

	if GameSettingsDevelopment.use_bar_digits and layout_settings.text then
		local text = tostring(math.floor(self._progress * 100 + 0.5))
		local font = layout_settings.text.font
		local font_size = layout_settings.text.font_size
		local align = layout_settings.text.align
		local offset = layout_settings.text.text_offset or {
			0,
			0
		}
		local shadow_offset = layout_settings.text.shadow_offset
		local min, max = Gui.text_extents(gui, text, MenuSettings.fonts.hell_shark_16.font, 16)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}
		local pos

		if align == "center" then
			pos = Vector3(texture_x + layout_settings.bar_width * 0.5 - extents[1] * 0.5 + offset[1], texture_y + layout_settings.bar_height * 0.5 - extents[2] * 0.5 + offset[2], self._z + 5)
		elseif align == "left" then
			pos = Vector3(texture_x + offset[1], texture_y + layout_settings.bar_height * 0.5 - extents[2] * 0.5 + offset[2], self._z + 5)
		else
			pos = Vector3(texture_x + layout_settings.bar_width - extents[1] + offset[1], texture_y + layout_settings.bar_height * 0.5 - extents[2] * 0.5 + offset[2], self._z + 5)
		end

		Gui.text(gui, text, MenuSettings.fonts.hell_shark_16.font, 16, MenuSettings.fonts.hell_shark_16.material, pos)

		if shadow_offset then
			Gui.text(gui, text, MenuSettings.fonts.hell_shark_16.font, 16, MenuSettings.fonts.hell_shark_16.material, pos + Vector3(shadow_offset[1], shadow_offset[2], -1), MenuHelper:color(layout_settings.shadow_color or {
				255,
				0,
				0,
				0
			}))
		end
	end
end

function HUDChunkyBarElement:x(layout_settings)
	return self._x
end

function HUDChunkyBarElement:y(layout_settings)
	return self._y
end

function HUDChunkyBarElement:current_width(layout_settings)
	return layout_settings.bar_width * self._progress
end

function HUDChunkyBarElement.create_from_config(config)
	return HUDChunkyBarElement:new(config)
end

HudAssets = {}

function HudAssets.get(material_name)
	local material = "hud_assets"
	local hud_table = hud_assets[material_name]
	local size = hud_table.size
	local uv00 = hud_table.uv00
	local uv11 = hud_table.uv11

	return material, uv00, uv11, size
end

function HudAssets.bitmap_asset(gui, asset_name, pos, size, color)
	local material = "hud_assets"
	local hud_table = hud_assets[asset_name]

	size = size or hud_table.size and Vector2(hud_table.size[1], hud_table.size[2])

	local uv00 = hud_table.uv00
	local uv11 = hud_table.uv11

	Gui.bitmap_uv(gui, material, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), pos, size, color)
end
