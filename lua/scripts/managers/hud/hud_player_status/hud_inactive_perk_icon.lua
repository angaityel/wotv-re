-- chunkname: @scripts/managers/hud/hud_player_status/hud_inactive_perk_icon.lua

require("scripts/managers/hud/shared_hud_elements/hud_texture_element")

HUDInactivePerkIcon = class(HUDInactivePerkIcon, HUDTextureElement)

function HUDInactivePerkIcon:init(config)
	HUDInactivePerkIcon.super.init(self, config)

	self._fade = {
		current_state = "inactive",
		duration = 0.1
	}
	self._gradient = {
		current_state = "inactive"
	}
end

function HUDInactivePerkIcon:render(dt, t, gui, layout_settings)
	self:update_icon(t, layout_settings)

	layout_settings.color[2] = 100
	layout_settings.color[3] = 100
	layout_settings.color[4] = 100

	HUDInactivePerkIcon.super.render(self, dt, t, gui, layout_settings)
end

function HUDInactivePerkIcon:update_icon(t, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk = Perks[blackboard.perk_name]
	local current_state = blackboard.state

	self:decide_states(current_state, t, layout_settings)

	layout_settings.pivot_offset_x = layout_settings.offset_x + slot_number * layout_settings.perk_slot_x_difference
	self._previous_state = current_state
	self.config.gradient_shader_value = self:calculate_gradient(t)
	layout_settings.color[1] = self:calculate_alpha(t)
end

function HUDInactivePerkIcon:decide_states(current_state, t, layout_settings)
	local previous_state = self._previous_state

	if current_state == "inactive" then
		if previous_state ~= "inactive" then
			self._fade.time = t
		end

		self._fade.current_state = "active"
		self._gradient.current_state = "active"
	else
		if previous_state == "inactive" then
			local config = self.config
			local slot_number = config.slot_number
			local blackboard = config.blackboard[slot_number]

			blackboard.time_start = nil
			blackboard.time_end = nil
			self._fade.time_start = t
		end

		self._fade.current_state = "inactive"
		self._gradient.current_state = "inactive"
	end
end

HUD_GRADIENT_NOT_COVERING = 0
HUD_GRADIENT_COVERING = 1

function HUDInactivePerkIcon:calculate_gradient(t)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk = Perks[blackboard.perk_name]
	local grad_table = self._gradient
	local state = grad_table.current_state
	local time_start = blackboard.time_start
	local time_end = blackboard.time_end

	if not time_start or not time_end or state ~= "active" then
		return HUD_GRADIENT_COVERING
	end

	local time_remaining = time_end - t
	local time_duration = time_end - time_start

	return (math.max(HUD_GRADIENT_NOT_COVERING, time_remaining / time_duration))
end

HUD_ALPHA_INVISIBLE = 0
HUD_ALPHA_VISIBLE = 255

function HUDInactivePerkIcon:calculate_alpha(t)
	local fade_table = self._fade
	local state = fade_table.current_state
	local time_start = fade_table.time_start
	local is_active = state == "active"
	local is_inactive = state == "inactive"

	if not time_start and is_active then
		return HUD_ALPHA_VISIBLE
	elseif not time_start and is_inactive then
		return HUD_ALPHA_INVISIBLE
	end

	local time_end = time_start + fade_table.duration
	local time_remaining = time_end - t

	if is_inactive then
		local final_diff = 0 + time_remaining / fade_table.duration * 255

		return math.max(HUD_ALPHA_INVISIBLE, final_diff)
	elseif is_active then
		local final_diff = 255 - time_remaining / fade_table.duration * 255

		return math.min(HUD_ALPHA_VISIBLE, final_diff)
	end
end

function HUDInactivePerkIcon.create_from_config(config)
	return HUDInactivePerkIcon:new(config)
end
