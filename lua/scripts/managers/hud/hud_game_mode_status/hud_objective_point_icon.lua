-- chunkname: @scripts/managers/hud/hud_game_mode_status/hud_objective_point_icon.lua

require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")
require("scripts/managers/hud/shared_hud_elements/hud_bar_element")

HUDObjectivePointIcon = class(HUDObjectivePointIcon, HUDAtlasTextureElement)

function HUDObjectivePointIcon:init(config)
	HUDObjectivePointIcon.super.init(self, config)

	self._icon_colour = "grey"
	self._owning_team_name = "neutral"
	self._render_swords = false
	self.sign = 1
	self._fading = false
	self._fade_settings = {
		fade_in = false,
		fade_time = 0
	}
	self._icon_glowing = false
	self._glow_fading = false
	self._glow_fade_settings = {
		fade_in = true,
		fade_time = 0
	}
	self._capture_scale = nil
	self._progress_colour = "none"

	local progress_bar_config = {
		text = "",
		z = 1,
		layout_settings = HUDSettings.game_mode_status.progress_bar
	}

	self._progress_bar = HUDBarElement.create_from_config(progress_bar_config)

	Managers.state.event:register(self, "objective_activated", "event_objective_activated", "objective_deactivated", "event_objective_deactivated")
end

function HUDObjectivePointIcon:event_objective_activated(blackboard, unit)
	if self.config.objective_point_unit == unit then
		self._blackboard = blackboard
	end
end

function HUDObjectivePointIcon:event_objective_deactivated(unit)
	return
end

function HUDObjectivePointIcon:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HUDObjectivePointIcon:render(dt, t, gui, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local unit = self.config.objective_point_unit
	local game = Managers.state.network:game()
	local player = self.config.player
	local object_point_id = Managers.state.network:game_object_id(unit)
	local alpha = 255
	local player_team_name = player.team.name
	local being_captured = GameSession.game_object_field(game, object_point_id, "being_captured")

	self._capture_scale = GameSession.game_object_field(game, object_point_id, "capture_scale")

	local objective_ext = ScriptUnit.extension(unit, "objective_system")
	local level = LevelHelper:current_level(objective_ext._world)
	local zone_name = objective_ext._zone_name
	local blackboard = self._blackboard

	if player.team.side == "defenders" then
		self.sign = -1
	else
		self.sign = 1
	end

	local owner_side = NetworkLookup.team[GameSession.game_object_field(game, object_point_id, "owner")]
	local owner_name = "neutral"

	if owner_side == "neutral" then
		self._icon_colour = "grey"
		self._owning_team_name = "neutral"
	else
		owner_name = Managers.state.team:name(owner_side)
		self._owning_team_name = owner_name

		if player_team_name == owner_name then
			self._icon_colour = "blue"
		else
			self._icon_colour = "red"
		end
	end

	if being_captured then
		local capturing_team = GameSession.game_object_field(game, object_point_id, "capturing_team")

		alpha = self:_fade_icon(dt, t, layout_settings)

		if self._render_swords == true then
			if owner_side == "neutral" then
				if NetworkLookup.team[capturing_team] == player.team.side then
					self._icon_colour = "blue"
				else
					self._icon_colour = "red"
				end
			else
				self._icon_colour = "grey"
			end

			self._owning_team_name = "swords"
		end

		if NetworkLookup.team[capturing_team] == player.team.side then
			self._progress_colour = "blue"
		else
			self._progress_colour = "red"
		end

		self:_update_progress_bar(dt, t, gui, self._capture_scale, player, capturing_team, owner_name)
	end

	local position = self:_position(dt, t, gui, layout_settings, config)
	local size = self:_size(dt, t, gui, layout_settings, config)
	local objective_icon_texture, team_icon_texture = self:_texture(dt, t, gui, layout_settings, config)
	local color = Color(255, 255, 255, 255)

	HUDHelper.atlas_bitmap(gui, layout_settings.atlas, objective_icon_texture, position, size, color)

	local player_unit = player.player_unit

	if Unit.alive(player_unit) then
		color = Color(255, 255, 255, 255)

		local pos = Unit.world_position(player_unit, 0)

		if Level.is_point_inside_volume(level, zone_name, pos) and not self._icon_glowing then
			local glow_alpha = self:_fade_glow(dt, t, layout_settings)
			local glow_color = Color(glow_alpha, 255, 255, 255)

			HUDHelper.atlas_bitmap(gui, layout_settings.atlas, "objective_icon_glow_blue", position, size, glow_color)
		elseif Level.is_point_inside_volume(level, zone_name, pos) and self._icon_glowing then
			HUDHelper.atlas_bitmap(gui, layout_settings.atlas, "objective_icon_glow_blue", position, size, color)
		elseif not Level.is_point_inside_volume(level, zone_name, pos) and self._icon_glowing then
			local glow_alpha = self:_fade_glow(dt, t, layout_settings)
			local glow_color = Color(glow_alpha, 255, 255, 255)

			HUDHelper.atlas_bitmap(gui, layout_settings.atlas, "objective_icon_glow_blue", position, size, glow_color)
		end
	end

	color = Color(alpha, 255, 255, 255)

	HUDHelper.atlas_bitmap(gui, layout_settings.atlas, team_icon_texture, position, size, color)

	if player and blackboard then
		self:_draw_text(gui, layout_settings.objective_text, position)
	end
end

function HUDObjectivePointIcon:_draw_text(gui, settings, position)
	local font = settings.font
	local text_color = settings.color and Color(settings.color[1], settings.color[2], settings.color[3], settings.color[4])
	local text = settings.text

	if settings.text_func then
		local t, c = settings.text_func(self._blackboard, self.config.player)

		text = t or text
		text_color = c or text_color
	end

	if not text then
		return
	end

	local font_name = font.font
	local text = settings.text_type == "number" and math.round(text) or settings.text_type == "string" and L(text)
	local font_size = settings.font_size
	local offset = Vector3(settings.text_offset.x, settings.text_offset.y, settings.text_offset.z)
	local text_offset, text_width, text_height = HUDHelper.text_align(gui, text, font_name, font_size)
	local set_drop_shadow = settings.drop_shadow
	local drop_shadow = set_drop_shadow and Vector3(set_drop_shadow[1], set_drop_shadow[2], 0)
	local set_drop_shadow_color = settings.drop_shadow_color
	local drop_shadow_color = drop_shadow and (set_drop_shadow_color and Color(set_drop_shadow_color[1], set_drop_shadow_color[2], set_drop_shadow_color[3], set_drop_shadow_color[4]) or Color(0, 0, 0))

	ScriptGUI.text(gui, text, font_name, font_size, font.material, position + offset + text_offset, text_color, drop_shadow_color, drop_shadow)
end

function HUDObjectivePointIcon:_update_progress_bar(dt, t, gui, capture_scale, player, capturing_team, owner_name)
	local layout_settings = HUDHelper:layout_settings(self._progress_bar.config.layout_settings)
	local x, y, z = self:_get_icon_position()

	y = y + layout_settings.pivot_offset_y

	local progress_size = math.lerp(0, layout_settings.bar_width, capture_scale)

	if owner_name ~= NetworkLookup.team[capturing_team] and owner_name ~= "neutral" then
		progress_size = math.lerp(layout_settings.bar_width, 0, capture_scale)
	end

	self._progress_bar:update_position(dt, t, layout_settings, x, y, z)
	self._progress_bar:update_size(dt, t, gui, layout_settings)
	self._progress_bar:set_progress(capture_scale)

	local bar_bg_texture, progress_colour_texture = self:_texture(dt, t, gui, layout_settings, self._progress_bar.config)
	local color = Color(255, 255, 255, 255)
	local position = Vector2(x, y)
	local size = Vector2(layout_settings.bar_width, layout_settings.bar_height)

	HUDHelper.atlas_bitmap(gui, layout_settings.atlas, bar_bg_texture, position, size, color)

	size = Vector2(progress_size, layout_settings.bar_height)

	HUDHelper.atlas_bitmap(gui, layout_settings.atlas, progress_colour_texture, position, size, color)
end

function HUDObjectivePointIcon:_texture(dt, t, gui, layout_settings, config)
	if layout_settings.texture_func then
		return layout_settings.texture_func(self._icon_colour, self._owning_team_name, self._blackboard, self.config.player)
	elseif layout_settings.get_textures then
		return layout_settings.get_textures(self._progress_colour)
	else
		return layout_settings.texture
	end
end

function HUDObjectivePointIcon:_fade_icon(dt, t, layout_settings)
	local fade_in = self._fade_settings.fade_in
	local fade_duration = fade_in and layout_settings.fade_in_duration or layout_settings.fade_out_duration

	if not self._fading then
		self._fade_settings.fade_time = t + fade_duration
		self._fading = true
	end

	local alpha_multiplier = fade_in and 1 or 0

	if t < self._fade_settings.fade_time then
		alpha_multiplier = math.lerp(0, 1, (fade_duration - (self._fade_settings.fade_time - t)) / fade_duration)
		alpha_multiplier = fade_in and alpha_multiplier or 1 - alpha_multiplier
	else
		self._fading = false
		self._fade_settings.fade_in = not self._fade_settings.fade_in

		if self._fade_settings.fade_in == true then
			self._render_swords = not self._render_swords
		end
	end

	return 255 * alpha_multiplier
end

function HUDObjectivePointIcon:_fade_glow(dt, t, layout_settings)
	local fade_in = self._glow_fade_settings.fade_in
	local fade_duration = fade_in and layout_settings.glow_fade_in_duration or layout_settings.glow_fade_out_duration

	if not self._glow_fading then
		self._glow_fade_settings.fade_time = t + fade_duration
		self._glow_fading = true
	end

	local alpha_multiplier = fade_in and 1 or 0

	if t < self._glow_fade_settings.fade_time then
		alpha_multiplier = math.lerp(0, 1, (fade_duration - (self._glow_fade_settings.fade_time - t)) / fade_duration)
		alpha_multiplier = fade_in and alpha_multiplier or 1 - alpha_multiplier
	else
		self._glow_fading = false
		self._icon_glowing = not self._icon_glowing
		self._glow_fade_settings.fade_in = not self._glow_fade_settings.fade_in
	end

	return 255 * alpha_multiplier
end

function HUDObjectivePointIcon:_get_icon_position()
	return self._x, self._y, self._z
end

function HUDObjectivePointIcon.create_from_config(config)
	return HUDObjectivePointIcon:new(config)
end
