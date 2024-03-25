-- chunkname: @scripts/managers/hud/hud_in_range/hud_in_range_indicator.lua

require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")

HUDInRangeIndicator = class(HUDInRangeIndicator, HUDAtlasTextureElement)

function HUDInRangeIndicator:init(config)
	HUDInRangeIndicator.super.init(self, config)

	self._in_squad_member_range_previous = false
	self._fade_settings = {
		active = false,
		fade_in = false
	}
	self._fade_time = 0
	self._fading = false
end

function HUDInRangeIndicator:render(dt, t, gui, layout_settings)
	local config = self.config
	local alpha = self._in_squad_member_range_previous and 255 or 0
	local in_squad_member_range = self:_in_squad_member_range()

	layout_settings.texture = layout_settings.texture_lit

	if in_squad_member_range and self._in_squad_member_range_previous or not in_squad_member_range and not self._in_squad_member_range_previous then
		if self._fade_settings.active then
			alpha = self:_update_fade(dt, t, layout_settings)
		end
	elseif in_squad_member_range and not self._in_squad_member_range_previous then
		self._fade_settings.active = true
		self._fade_settings.fade_in = true
	elseif self._in_squad_member_range_previous and not in_squad_member_range then
		self._fade_settings.active = true
		self._fade_settings.fade_in = false
	end

	layout_settings.color[1] = alpha
	self._in_squad_member_range_previous = in_squad_member_range

	HUDInRangeIndicator.super.render(self, dt, t, gui, layout_settings)
end

function HUDInRangeIndicator:_update_fade(dt, t, layout_settings)
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

	return 255 * alpha_multiplier
end

function HUDInRangeIndicator:_in_squad_member_range()
	local config = self.config
	local blackboard = config.blackboard
	local player = blackboard.player
	local squad_index = player.squad_index
	local player_unit = player.player_unit
	local in_range = false

	if Unit.alive(player_unit) and squad_index then
		local damage_system = ScriptUnit.has_extension(player_unit, "damage_system") and ScriptUnit.extension(player_unit, "damage_system")

		in_range = damage_system and damage_system:in_squad_range() or false
	end

	return in_range
end

function HUDInRangeIndicator.create_from_config(config)
	return HUDInRangeIndicator:new(config)
end
