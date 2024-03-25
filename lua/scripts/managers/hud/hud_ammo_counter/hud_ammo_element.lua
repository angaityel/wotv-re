-- chunkname: @scripts/managers/hud/hud_ammo_counter/hud_ammo_element.lua

require("scripts/managers/hud/shared_hud_elements/hud_texture_element")

HUDAmmoElement = class(HUDAmmoElement, HUDTextureElement)

function HUDAmmoElement:start_glow(t, glow_duration, peak, sustain)
	self._start_glow = t
	self._end_glow = t + glow_duration
	self._glow_duration = glow_duration
	self._peak = peak
	self._sustain = sustain
end

function HUDAmmoElement:render(dt, t, gui, layout_settings)
	self.super.render(self, dt, t, gui, layout_settings)

	if self._start_glow and t < self._end_glow then
		local atlas_settings = layout_settings.glow_texture_atlas_settings_func(self.config.blackboard)
		local config = self.config
		local position = self:_position(dt, t, gui, layout_settings, config)
		local size = self:_size(dt, t, gui, layout_settings, config)
		local a, r, g, b = Quaternion.to_elements(self:_color(dt, t, gui, layout_settings, config))
		local alpha_t = (t - self._start_glow) / self._glow_duration
		local peak = self._peak
		local sustain = self._sustain
		local alpha_multiplier

		if alpha_t < peak then
			alpha_multiplier = (alpha_t / peak)^2
		elseif alpha_t < peak + sustain then
			alpha_multiplier = 1
		else
			local peak_and_sustain = peak + sustain

			alpha_multiplier = 1 - (alpha_t - peak_and_sustain) / (1 - peak_and_sustain)
		end

		local color = Color(a * alpha_multiplier, r, g, b)
		local uv00 = Vector2(atlas_settings.uv00[1], atlas_settings.uv00[2])
		local uv11 = Vector2(atlas_settings.uv11[1], atlas_settings.uv11[2])

		position = position + Vector3(0, 0, 1)

		Gui.bitmap_uv(gui, layout_settings.texture_atlas, uv00, uv11, position, size, color)
	end
end

function HUDAmmoElement.create_from_config(config)
	return HUDAmmoElement:new(config)
end
