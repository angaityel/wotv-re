-- chunkname: @scripts/managers/hud/hud_hit_marker/hud_hit_marker_marker.lua

require("scripts/managers/hud/shared_hud_elements/hud_texture_element")

HUDHitMarkerMarker = class(HUDHitMarkerMarker, HUDTextureElement)

function HUDHitMarkerMarker:init(config)
	HUDHitMarkerMarker.super.init(self, config)

	self._alpha_value = 255
	self._alpha_timer = 0
	self._active = false
end

function HUDHitMarkerMarker:update_size(dt, t, gui, layout_settings)
	local config = self.config

	if config.active then
		self._alpha_value = 255
		self._alpha_timer = t + 3
		self._active = true
		config.active = false
	end

	HUDHitMarkerMarker.super.update_size(self, dt, t, gui, layout_settings)
end

function HUDHitMarkerMarker:_color(dt, t, gui, layout_settings)
	local layout_settings_color = layout_settings.color

	if script_data.debug_hit_marker then
		return Color(255, layout_settings_color[2], layout_settings_color[3], layout_settings_color[4])
	elseif script_data.debug_team_hit_marker then
		return Color(255, 255, 0, 0)
	elseif self.config.same_team then
		local alpha = layout_settings_color and #layout_settings_color == 4 and layout_settings_color[1] or 255

		return Color(alpha, 255, 0, 0)
	else
		return Color(layout_settings_color[1], layout_settings_color[2], layout_settings_color[3], layout_settings_color[4])
	end
end

function HUDHitMarkerMarker:active()
	return self._active
end

function HUDHitMarkerMarker:_texture_atlas_settings(layout_settings)
	local texture

	if self.config.same_team or script_data.debug_team_hit_marker then
		texture = Application.user_setting("crosshair_teammate_hit_marker") or "crosshair_texture_1_hit_tm"
	else
		texture = Application.user_setting("crosshair_hit_marker") or "crosshair_texture_1_hit"
	end

	local atlas_name = layout_settings.texture_atlas
	local atlas = rawget(_G, atlas_name)

	return atlas[texture]
end

function HUDHitMarkerMarker:update_position(dt, t, layout_settings, x, y, z)
	local config = self.config

	if t <= self._alpha_timer then
		self._alpha_value = self:_calculate_alpha(t)
	elseif self._active then
		self._active = false
	end

	layout_settings.color[1] = self._alpha_value

	HUDHitMarkerMarker.super.update_position(self, dt, t, layout_settings, x, y, z)
end

function HUDHitMarkerMarker:_calculate_alpha(t)
	local alpha_value = 255 * (self._alpha_timer - t) / 5

	return alpha_value
end

function HUDHitMarkerMarker.create_from_config(config)
	return HUDHitMarkerMarker:new(config)
end
