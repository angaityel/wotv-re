-- chunkname: @scripts/managers/hud/hud_world_icons/floating_objective_hud_icon.lua

FloatingObjectiveHUDIcon = class(FloatingObjectiveHUDIcon, FloatingHUDIcon)

function FloatingObjectiveHUDIcon:_draw_floating_icon(layout_settings, screen_x, screen_y, screen_z, inside_attention_zone, dt, t, state_table, taggable)
	local blackboard = self._blackboard
	local settings = inside_attention_zone and layout_settings.attention_screen_zone or layout_settings.default_screen_zone
	local texture = settings.texture_func and settings.texture_func(blackboard, self._player, self._unit, self._world, self._player_unit)

	if texture and state_table.status == "show" then
		state_table.fade_alpha = 1
		state_table.last_texture = texture
	elseif not texture and (state_table.status == "hide" or not state_table.last_texture) then
		state_table.fade_alpha = 0
		state_table.status = "hide"

		return
	elseif not texture and state_table.last_texture then
		state_table.fade_alpha = math.clamp((state_table.fade_alpha or 1) - dt / self._fade_duration, 0, 1)

		if state_table.fade_alpha <= 0 then
			state_table.status = "hide"
			state_table.last_texture = nil

			return
		else
			state_table.status = "fade"
			texture = state_table.last_texture
		end
	elseif texture then
		state_table.last_texture = texture
		state_table.fade_alpha = math.clamp((state_table.fade_alpha or 0) + dt / self._fade_duration, 0, 1)

		if state_table.fade_alpha >= 1 then
			state_table.status = "show"
		else
			state_table.status = "fade"
		end
	end

	local color = HUDHelper.floating_hud_icon_color(self._player, settings, blackboard, dt, t)
	local x, y, z, w = Quaternion.to_elements(color)

	color = Quaternion.from_elements(x * state_table.fade_alpha, y, z, w)

	local uv00 = Vector2(texture.uv00[1], texture.uv00[2])
	local uv11 = Vector2(texture.uv11[1], texture.uv11[2])
	local width, height = HUDHelper:floating_icon_size(screen_z, texture.size[1], texture.size[2], settings.min_scale, settings.max_scale, settings.min_scale_distance, settings.max_scale_distance)
	local position = Vector3(screen_x - width * 0.5, screen_y - height * 0.5, settings.z or 0)

	Gui.bitmap_uv(self._gui, settings.texture_atlas, uv00, uv11, position, Vector2(width, height), color)

	if settings.objective_text then
		self:_draw_text(settings, settings.objective_text, screen_z, screen_x, screen_y + height * 0.5, blackboard)
	end

	if settings.show_progress then
		self:_draw_progress_bar(position, width, height, blackboard)
	end
end

function FloatingObjectiveHUDIcon:_draw_text(parent_settings, settings, screen_z, screen_x, screen_y, blackboard)
	local gui = self._gui
	local font = settings.font
	local text_color = settings.color and Color(settings.color[1], settings.color[2], settings.color[3], settings.color[4])
	local text = settings.text

	if settings.text_func then
		local t, c = settings.text_func(blackboard, self._player, self._unit, self._world, self._player_unit)

		text = t or text
		text_color = c or text_color
	end

	if not text then
		return
	end

	local text = settings.text_type == "number" and math.round(text) or settings.text_type == "string" and L(text)
	local font_size = settings.font_size
	local size = HUDHelper:floating_text_icon_size(screen_z, font_size, parent_settings.min_scale, parent_settings.max_scale, parent_settings.min_scale_distance, parent_settings.max_scale_distance)
	local min, max = Gui.text_extents(gui, text, font.font, size)
	local offset = settings.text_offset
	local pos = Vector3(screen_x + 0.5 * (min.x - max.x) + offset.x, screen_y + offset.y, screen_z + offset.z)
	local set_drop_shadow = settings.drop_shadow
	local drop_shadow = set_drop_shadow and Vector3(set_drop_shadow[1], set_drop_shadow[2], 0)
	local set_drop_shadow_color = settings.drop_shadow_color
	local drop_shadow_color = drop_shadow and (set_drop_shadow_color and Color(set_drop_shadow_color[1], set_drop_shadow_color[2], set_drop_shadow_color[3], set_drop_shadow_color[4]) or Color(0, 0, 0))

	ScriptGUI.text(gui, text, font.font, size, font.material, pos, text_color, drop_shadow_color, drop_shadow)
end

function FloatingObjectiveHUDIcon:_draw_clamped_icon(layout_settings, screen_x, screen_y, screen_z, dt, t, taggable)
	local blackboard = self._blackboard
	local settings = layout_settings.clamped_screen_zone
	local texture = settings.texture_func and settings.texture_func(blackboard, self._player, self._unit, self._world, self._player_unit)

	if not texture then
		return
	end

	local color = HUDHelper.floating_hud_icon_color(self._player, settings, blackboard, dt, t)
	local uv00 = Vector2(texture.uv00[1], texture.uv00[2])
	local uv11 = Vector2(texture.uv11[1], texture.uv11[2])
	local width = texture.size[1] * settings.scale
	local height = texture.size[2] * settings.scale
	local clamped_x, clamped_y = HUDHelper:clamped_icon_position(screen_x, screen_y, screen_z)
	local position = Vector3(clamped_x - width * 0.5, clamped_y - height * 0.5, settings.z or 0)

	Gui.bitmap_uv(self._gui, settings.texture_atlas, uv00, uv11, position, Vector2(width, height), color)

	if settings.show_progress then
		self:_draw_progress_bar(position, width, height, blackboard)
	end
end

function FloatingObjectiveHUDIcon:_draw_progress_bar(position, width, height, blackboard)
	if not blackboard.capture_scale or blackboard.capture_scale == 0 then
		return
	end

	local progress = blackboard.capture_scale
	local middle = width * progress
	local player = self._player
	local team = player.team
	local side = team and team.side

	if not side then
		return
	end

	local color1, color2, capturing_team, color_table1, color_table2

	if blackboard.owner_team_side == side then
		color_table2 = HUDSettings.player_colors.team_member
	elseif blackboard.owner_team_side == "neutral" then
		color_table2 = HUDSettings.player_colors.neutral_team
	else
		color_table2 = HUDSettings.player_colors.enemy
	end

	color2 = Color(color_table2[1], color_table2[2], color_table2[3], color_table2[4])

	Gui.rect(self._gui, position + Vector2(middle, 0), Vector2((1 - progress) * width, 5), color2)

	if blackboard.capturing_team then
		if blackboard.owner_team_side == "neutral" then
			if blackboard.capturing_team == side then
				color_table1 = HUDSettings.player_colors.team_member
			else
				color_table1 = HUDSettings.player_colors.enemy
			end
		elseif blackboard.instant_capture then
			if blackboard.capturing_team == side then
				color_table1 = HUDSettings.player_colors.team_member
			else
				color_table1 = HUDSettings.player_colors.enemy
			end
		else
			color_table1 = HUDSettings.player_colors.neutral_team
		end

		color1 = Color(color_table1[1], color_table1[2], color_table1[3], color_table1[4])

		Gui.rect(self._gui, position, Vector2(middle, 5), color1)
	end
end
