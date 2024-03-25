-- chunkname: @scripts/managers/hud/hud_player_status/hud_perk_icon.lua

require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")

HUDPerkIcon = class(HUDPerkIcon, HUDAtlasTextureElement)

function HUDPerkIcon:init(config)
	HUDPerkIcon.super.init(self, config)

	self._previous_state = nil
	self._fade_settings = {
		active = false,
		fade_in = false
	}
	self._fade_time = 0
end

function HUDPerkIcon:render(dt, t, gui, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk = Perks[blackboard.perk_name]
	local current_state = blackboard.state

	self[config.render_function](self, dt, t, gui, layout_settings)

	layout_settings.pivot_offset_x = layout_settings.offset_x + slot_number * layout_settings.perk_slot_x_difference
	self._previous_state = current_state

	HUDPerkIcon.super.render(self, dt, t, gui, layout_settings)
end

function HUDPerkIcon:_render_active_icon(dt, t, gui, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk = Perks[blackboard.perk_name]
	local current_state = blackboard.state
	local alpha = self._fade_settings.fade_in and 255 or 0
	local scale = 1

	if self._fade_settings.active and (current_state ~= "active" or self._previous_state == "active") then
		alpha, scale = self:_update_fade(dt, t, layout_settings)
	elseif current_state == "active" and self._previous_state == "active" then
		alpha = 255
	elseif current_state == "active" and self._previous_state ~= "active" then
		self._fade_settings.active = true
		self._fade_settings.fade_in = true
	elseif current_state ~= "active" and self._fade_settings.fade_in then
		self._fade_settings.active = true
		self._fade_settings.fade_in = false
	end

	layout_settings.color[1] = alpha
	layout_settings.scale = scale
	layout_settings.texture = perk.hud_texture_active
end

function HUDPerkIcon:_update_fade(dt, t, layout_settings)
	local fade_in = self._fade_settings.fade_in
	local fade_duration = fade_in and layout_settings.fade_in_duration or layout_settings.fade_out_duration

	if not self._fading then
		self._fade_time = t + fade_duration
		self._fading = true
	end

	local alpha_multiplier = fade_in and 1 or 0

	if t < self._fade_time then
		alpha_multiplier = math.lerp(0, 1, (fade_duration - (self._fade_time - t)) / fade_duration)
		alpha_multiplier = fade_in and alpha_multiplier or 1 - alpha_multiplier
	else
		self._fading = false
		self._fade_settings.active = false
	end

	local scale = 1

	if fade_in then
		scale = math.round(1 + math.sin(alpha_multiplier * math.pi) * 0.15, 2)
	end

	return 255 * alpha_multiplier, scale
end

function HUDPerkIcon:_render_default_icon(dt, t, gui, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk = Perks[blackboard.perk_name]

	layout_settings.texture = perk.hud_texture_default
end

function HUDPerkIcon.create_from_config(config)
	return HUDPerkIcon:new(config)
end
