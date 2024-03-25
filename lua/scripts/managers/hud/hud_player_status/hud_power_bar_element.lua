-- chunkname: @scripts/managers/hud/hud_player_status/hud_power_bar_element.lua

require("scripts/hud/hud_assets")

HUDPowerBarElement = class(HUDPowerBarElement)

local fade_functions = {
	low_hi = function(time, duration)
		return math.sin(math.pi * 0.5 * (time / duration))
	end,
	hi_low = function(time, duration)
		return math.sin(math.pi * 0.5 * (1 - time / duration))
	end,
	low_hi_low = function(time, duration)
		return math.sin(math.pi * (time / duration))
	end,
	hi_low_hi = function(time, duration)
		return math.abs(math.cos(math.pi * (time / duration)))
	end,
	flat = function(time, duration)
		return 1
	end,
	linear = function(time, duration)
		return time / duration
	end,
	exp_step = function(time, k, n)
		return math.exp(-k * math.pow(time, n))
	end
}

local function render_cut_texture(gui, atlas, texture, x, y, z, x1, color, render_type)
	local material, uv00, uv11, size = HUDHelper.atlas_material(atlas, texture)
	local new_width
	local uv_x10 = uv11[1]
	local uv_x00 = uv00[1]

	if render_type == "default" then
		new_width = (uv11[1] - uv00[1]) * x1
		uv_x10 = uv00[1] + new_width
		size[1] = size[1] * x1
	elseif render_type == "inwards" then
		new_width = (uv11[1] - uv00[1]) * x1
		uv_x00 = uv00[1] + new_width
		x = x + size[1] * x1
		size[1] = size[1] - size[1] * x1
	elseif render_type == "reverse_inwards" then
		new_width = (uv11[1] - uv00[1]) * x1
		uv_x00 = uv11[1] - new_width
		uv_x10 = uv00[1]
		size[1] = size[1] * (1 - x1)
	end

	Gui.bitmap_uv(gui, atlas, Vector2(uv_x00, uv00[2]), Vector2(uv_x10, uv11[2]), Vector3(x, y, z), size, color)
end

function HUDPowerBarElement:init(config)
	self._width = nil
	self._height = nil
	self.config = config
	self._cut_value = 0.3
	self._value = 0
	self._glow_value = 0
	self._fade_factor = 1
	self._fade_duration = 0.5
	self._stay_duration = 0.3
end

function HUDPowerBarElement:width()
	return self._width
end

function HUDPowerBarElement:height()
	return self._height
end

function HUDPowerBarElement:set_transition_value(value)
	self._cut_value = value
end

function HUDPowerBarElement:set_glow_value(value)
	self._glow_value = value
end

function HUDPowerBarElement:set_value(value)
	self._value = value
	self._active = true
	self._fading = false
end

function HUDPowerBarElement:set_done()
	self._fade_out_time = 0
	self._stay_time = 0
	self._fading = true
	self._stay = true
end

function HUDPowerBarElement:update_size(dt, t, gui, layout_settings)
	self._width = layout_settings.bar_width
	self._height = layout_settings.bar_height
end

function HUDPowerBarElement:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HUDPowerBarElement:_colors(layout_settings, config)
	if config.blackboard and config.blackboard.color then
		return config.blackboard.color[2], config.blackboard.color[3], config.blackboard.color[4]
	end

	return 255, 255, 255
end

function HUDPowerBarElement:_render_background_texture(gui, layout_settings)
	local texture = layout_settings.background_texture

	if texture then
		local color = Color(self._fade_factor * 255, 255, 255, 255)

		HUDHelper.atlas_bitmap(gui, layout_settings.atlas, texture, Vector3(math.floor(self._x), math.floor(self._y), self._z + 1), nil, color)
	end
end

function HUDPowerBarElement:_render_foreground_texture(gui, layout_settings)
	local texture = layout_settings.foreground_texture

	if texture then
		local color = Color(255 * self._fade_factor2, 255, 255, 255)
		local x = math.floor(self._x + (layout_settings.foreground_texture_offset_x or 0))
		local y = math.floor(self._y + (layout_settings.foreground_texture_offset_y or 0))

		HUDHelper.atlas_bitmap(gui, layout_settings.atlas, texture, Vector3(x, y, self._z + 6), nil, color)
	end
end

function HUDPowerBarElement:_render_glow_texture(gui, layout_settings)
	local texture = layout_settings.glow_texture

	if texture and not self._fading and self._active then
		local alpha = 0
		local x = math.floor(self._x + (layout_settings.bar_texture_offset_x or 0))
		local y = math.floor(self._y + (layout_settings.bar_texture_offset_y or 0))
		local color = Color((math.smoothstep(self._glow_value, 0, 1) or 0) * 255, self:_colors(layout_settings, self.config))

		HUDHelper.atlas_bitmap(gui, layout_settings.atlas, texture, Vector3(math.floor(x), math.floor(y), self._z + 5), nil, color)
	end
end

function HUDPowerBarElement:_render_start_bar_texture(gui, layout_settings, x1)
	local texture = layout_settings.start_bar_texture

	if texture then
		local atlas = layout_settings.atlas
		local x = math.floor(self._x + (layout_settings.bar_texture_offset_x or 0))
		local y = math.floor(self._y + (layout_settings.bar_texture_offset_y or 0))
		local color = Color(self._fade_factor * 200, self:_colors(layout_settings, self.config))

		render_cut_texture(gui, atlas, texture, x, y, self._z + 6, x1, color, self.config.render_type or "default")
	end
end

function HUDPowerBarElement:_render_main_bar_texture(gui, layout_settings, x1)
	local texture = layout_settings.end_bar_texture
	local factor = 0
	local t = math.clamp((x1 - factor) / (1 - factor), 0, 1)^8
	local atlas = layout_settings.atlas
	local x = math.floor(self._x + (layout_settings.bar_texture_offset_x or 0))
	local y = math.floor(self._y + (layout_settings.bar_texture_offset_y or 0))

	render_cut_texture(gui, atlas, layout_settings.end_bar_texture, x, y, self._z + 4, x1, Color(self._fade_factor * (0.8 + 0.2 * math.smoothstep(t, 0, 1)) * 255, self:_colors(layout_settings, self.config)), self.config.render_type or "default")
end

function HUDPowerBarElement:_render_dusk_bar(gui, layout_settings, x1)
	local color = Color(self._fade_factor * 48, self:_colors(layout_settings, self.config))
	local atlas = layout_settings.atlas
	local x = math.floor(self._x + (layout_settings.bar_texture_offset_x or 0))
	local y = math.floor(self._y + (layout_settings.bar_texture_offset_y or 0))

	if layout_settings.start_bar_texture then
		render_cut_texture(gui, atlas, layout_settings.start_bar_texture, x, y, self._z + 3, self._cut_value, color, self.config.render_type or "default")
	end

	if layout_settings.end_bar_texture then
		render_cut_texture(gui, atlas, layout_settings.end_bar_texture, x, y, self._z + 2, 1, color, self.config.render_type or "default")
	end
end

function HUDPowerBarElement:_handle_fade_out(dt, t)
	if self._fading then
		self._stay_duration = 0.3
		self._stay_time = self._stay_time + dt

		if self._stay_time <= self._stay_duration then
			self._fade_factor = 1
			self._fade_factor2 = 1
			self._fade_out_time = 0

			return
		end

		self._fade_out_time = self._fade_out_time + dt

		if self._fade_out_time >= self._fade_duration then
			self._fading = false
			self._active = false
			self._fade_factor = 0
			self._fade_factor2 = 0
		else
			self._fade_factor = 1 - fade_functions.linear(self._fade_out_time, self._fade_duration)
			self._fade_factor2 = fade_functions.exp_step(self._fade_out_time / self._fade_duration, 4.65, 20)
		end
	else
		self._fade_factor = 1
		self._fade_factor2 = 1
	end
end

function HUDPowerBarElement:render(dt, t, gui, layout_settings)
	if not self._active then
		return
	end

	self:_handle_fade_out(dt, t)
	self:_render_background_texture(gui, layout_settings)
	self:_render_foreground_texture(gui, layout_settings)
	self:_render_glow_texture(gui, layout_settings)

	local x1 = self._value
	local cut_value = x1 < self._cut_value and x1 or self._cut_value

	self:_render_dusk_bar(gui, layout_settings, x1)
	self:_render_start_bar_texture(gui, layout_settings, cut_value)
	self:_render_main_bar_texture(gui, layout_settings, x1)
end

function HUDPowerBarElement.create_from_config(config)
	return HUDPowerBarElement:new(config)
end
