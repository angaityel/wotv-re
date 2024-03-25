-- chunkname: @scripts/managers/hud/hud_world_icons/floating_player_hud_icon.lua

require("scripts/settings/squad_settings")

FloatingPlayerHUDIcon = class(FloatingPlayerHUDIcon)

function FloatingPlayerHUDIcon:init(gui, local_player, player_unit, camera, world, layout_settings)
	self._gui = gui
	self._local_player = local_player
	self._player_unit = player_unit
	self._camera = camera
	self._world = world
	self.layout_settings = layout_settings
	self._show_time = nil
	self._hide_time = nil
	self._render = false
	self._player_visible = false
	self._line_of_sight_check_result = false
	self._raycast_node_list = HUDSettings.player_icons.line_of_sight_nodes
	self._raycast_node_list_index = 0
	self._help_requested_time = -math.huge

	self:_init_raycast()
end

function FloatingPlayerHUDIcon:help_requested()
	self._help_requested_time = Managers.time:time("game")
end

function FloatingPlayerHUDIcon:help_no_longer_requested()
	self._help_requested_time = -math.huge
end

function FloatingPlayerHUDIcon:destroy()
	self._raycast = nil
end

function FloatingPlayerHUDIcon:unit()
	return self._player_unit
end

function FloatingPlayerHUDIcon:_init_raycast()
	local function raycast_result(hit, position, distance, normal, actor)
		self:_raycast_result(hit, position, distance, normal, actor)
	end

	local physics_world = World.physics_world(self._world)

	self._raycast = PhysicsWorld.make_raycast(physics_world, raycast_result, "closest", "collision_filter", "husk_in_line_of_sight")
end

function FloatingPlayerHUDIcon:post_update(dt, t)
	local local_player = self._local_player
	local local_player_unit = local_player.camera_follow_unit
	local other_player_unit = self._player_unit
	local other_player = Managers.player:owner(other_player_unit)

	if local_player == other_player then
		return
	end

	if not Unit.alive(local_player_unit) or not Unit.alive(other_player_unit) or not local_player.team or not other_player or not other_player.team or ScriptUnit.extension(other_player_unit, "locomotion_system").ghost_mode and (local_player.team ~= other_player.team or not not PlayerMechanicsHelper.player_unit_tagged(local_player, other_player_unit)) then
		self._player_visible = false
		self._show_time = nil
		self._hide_time = nil
		self._render = false
		self._wants_line_of_sight_check = false

		return false
	end

	local screen_x, screen_y, screen_z = self:_icon_screen_pos(other_player_unit, local_player_unit)
	local is_squad_member = self:_is_squad_member()

	if not HUDHelper:inside_screen(screen_x, screen_y, screen_z) and not is_squad_member and not self:_help_requested(t) then
		self._render = false
		self._player_visible = false
		self._show_time = nil
		self._hide_time = nil
		self._wants_line_of_sight_check = false

		return false
	end

	local local_player_pos = Unit.world_position(local_player_unit, 0)
	local other_player_pos = Unit.world_position(other_player_unit, 0)
	local distance = Vector3.length(local_player_pos - other_player_pos)
	local inside_attention_zone = HUDHelper:inside_attention_screen_zone(screen_x, screen_y, screen_z)
	local player_visible = self:_player_visible_check(local_player, other_player, distance, local_player_unit, other_player_unit, t, inside_attention_zone) or PlayerMechanicsHelper.player_unit_tagged(local_player, other_player_unit)

	if player_visible and not self._player_visible and not self._show_time then
		self._hide_time = nil

		if local_player.team == other_player.team then
			if local_player.squad_index and local_player.squad_index == other_player.squad_index then
				self._show_time = t + HUDSettings.player_icons.squad_member_show_delay
			else
				self._show_time = t + HUDSettings.player_icons.team_member_show_delay
			end
		elseif distance <= HUDSettings.player_icons.near_enemy_max_distance then
			self._show_time = t + HUDSettings.player_icons.near_enemy_show_delay
		else
			local level_key = Managers.state.game_mode:level_key()
			local far_enemy_max_distance = HUDSettings.player_icons.level_far_enemy_max_distance[level_key] or HUDSettings.player_icons.default_far_enemy_max_distance
			local near_enemy_max_distance = HUDSettings.player_icons.near_enemy_max_distance
			local delay = math.auto_lerp(near_enemy_max_distance, far_enemy_max_distance, HUDSettings.player_icons.far_enemy_show_delay_min, HUDSettings.player_icons.far_enemy_show_delay_max, distance)

			self._show_time = t + delay
		end
	elseif not player_visible and self._player_visible then
		self._show_time = nil

		if local_player.team == other_player.team then
			if local_player.squad_index and local_player.squad_index == other_player.squad_index then
				self._hide_time = t + HUDSettings.player_icons.squad_member_hide_delay
			else
				self._hide_time = t + HUDSettings.player_icons.team_member_hide_delay
			end
		elseif distance <= HUDSettings.player_icons.near_enemy_max_distance then
			self._hide_time = t + HUDSettings.player_icons.near_enemy_hide_delay
		else
			self._hide_time = t + HUDSettings.player_icons.far_enemy_hide_delay
		end
	end

	self._player_visible = player_visible

	if self._show_time and t >= self._show_time then
		self._show_time = nil
		self._render = true
	elseif self._hide_time and t >= self._hide_time then
		self._hide_time = nil
		self._render = false
	end

	if self._render then
		self._screen_x = screen_x
		self._screen_y = screen_y
		self._screen_z = screen_z
		self._distance = distance
		self._inside_attention_zone = inside_attention_zone
	end

	return self._render
end

function FloatingPlayerHUDIcon:render(dt, t, taggable)
	if self._render then
		self:_render_floating_icon(self._screen_x, self._screen_y, self._screen_z, self._inside_attention_zone, t, self._distance, taggable)
	end
end

local function vector3_clamp_i(v, min, max)
	v.x = math.clamp(v.x, min, max)
	v.y = math.clamp(v.y, min, max)
	v.z = math.clamp(v.z, min, max)
end

function FloatingPlayerHUDIcon:_icon_screen_pos(player_unit, local_player_unit)
	local icon_world_pos = Unit.world_position(player_unit, Unit.node(player_unit, "Head"))
	local character_pos = Unit.world_position(player_unit, 0)

	if not GameSettingsDevelopment.dev_build then
		vector3_clamp_i(icon_world_pos, -10000, 10000)
	end

	if icon_world_pos.z > character_pos.z + 1.2 then
		icon_world_pos.z = character_pos.z + 1.2
	end

	icon_world_pos.z = icon_world_pos.z + 0.47

	local xy_distance = math.sqrt((icon_world_pos.x - character_pos.x)^2 + (icon_world_pos.y - character_pos.y)^2)
	local lerp_t = math.max((xy_distance - 0.15) * 10, 0)

	if lerp_t < 1 then
		icon_world_pos.x = math.lerp(character_pos.x, icon_world_pos.x, lerp_t)
		icon_world_pos.y = math.lerp(character_pos.y, icon_world_pos.y, lerp_t)
	end

	local world_to_screen = self:world_to_screen(self._camera, icon_world_pos)

	return world_to_screen.x, world_to_screen.z, world_to_screen.y
end

function FloatingPlayerHUDIcon:world_to_screen(camera, position)
	local world_to_screen = Camera.world_to_screen(self._camera, position)
	local dir = position - Camera.world_position(camera)
	local camera_rot = Camera.world_rotation(camera)
	local z1 = Vector3.normalize(dir).z
	local z2 = Quaternion.forward(camera_rot).z
	local angle_y = math.asin(z1) - math.asin(z2)
	local y = angle_y / Camera.vertical_fov(camera)
	local rez_x, rez_y = Application.resolution()
	local screen_y = rez_y * (y + 0.5)

	return Vector3(world_to_screen.x, world_to_screen.y, screen_y)
end

function FloatingPlayerHUDIcon:_player_visible_check(local_player, other_player, distance, local_player_unit, other_player_unit, t, inside_attention_zone)
	if local_player.team == other_player.team then
		if local_player.squad_index and local_player.squad_index == other_player.squad_index or self:_help_requested(t) then
			self._wants_line_of_sight_check = false

			return true
		elseif distance <= HUDSettings.player_icons.team_member_max_distance and inside_attention_zone then
			if not self._wants_line_of_sight_check then
				self._line_of_sight_check_result = false
			end

			self._wants_line_of_sight_check = true

			return self._line_of_sight_check_result
		end
	elseif local_player_unit == other_player_unit then
		return true
	elseif inside_attention_zone then
		local level_key = Managers.state.game_mode:level_key()
		local far_enemy_max_distance = HUDSettings.player_icons.level_far_enemy_max_distance[level_key] or HUDSettings.player_icons.default_far_enemy_max_distance

		if distance <= far_enemy_max_distance then
			if not self._wants_line_of_sight_check then
				self._line_of_sight_check_result = false
			end

			self._wants_line_of_sight_check = true

			return self._line_of_sight_check_result
		end
	end

	self._wants_line_of_sight_check = false
end

function FloatingPlayerHUDIcon:wants_line_of_sight_check()
	return self._wants_line_of_sight_check
end

function FloatingPlayerHUDIcon:check_line_of_sight()
	local local_player = self._local_player
	local other_player_unit = self._player_unit

	if not Unit.alive(local_player.camera_follow_unit) or not Unit.alive(other_player_unit) then
		return
	end

	local camera_unit = Camera.get_data(self._camera, "unit")
	local cam_pos = Unit.local_position(camera_unit, 0)

	self._raycast_node_list_index = self._raycast_node_list_index % #self._raycast_node_list + 1

	local other_player_pos = Unit.world_position(other_player_unit, Unit.node(other_player_unit, self._raycast_node_list[self._raycast_node_list_index]))
	local length = Vector3.length(other_player_pos - cam_pos)

	self._raycast:cast(cam_pos, other_player_pos - cam_pos, length)
end

function FloatingPlayerHUDIcon:_raycast_result(hit, position, distance, normal, actor)
	self._line_of_sight_check_result = not hit
end

function FloatingPlayerHUDIcon:_is_squad_member()
	local player = Managers.player:owner(self._player_unit)

	return self._local_player.team == player.team and self._local_player.squad_index and self._local_player.squad_index == player.squad_index
end

function FloatingPlayerHUDIcon:_render_floating_icon(screen_x, screen_y, screen_z, inside_attention_zone, t, distance, taggable)
	Profiler.start("render name")

	local layout_settings = HUDHelper:layout_settings(self.layout_settings)
	local gui = self._gui
	local settings = inside_attention_zone and layout_settings.attention_screen_zone or layout_settings.default_screen_zone
	local local_player = self._local_player
	local player_unit = local_player.player_unit
	local alpha_multiplier = self:_help_requested(t) and 1 or settings.name_alpha_multiplier

	if self._hide_time and self._hide_time - t <= HUDSettings.player_icons.hide_fade_time then
		alpha_multiplier = (self._hide_time - t) / HUDSettings.player_icons.hide_fade_time
	end

	local other_player_unit = self._player_unit
	local other_player_loco = ScriptUnit.extension(other_player_unit, "locomotion_system")
	local other_player = Managers.player:owner(other_player_unit)
	local name_color_alpha = 255
	local damage_ext = ScriptUnit.extension(other_player_unit, "damage_system")
	local dead = damage_ext:is_dead()
	local name_color_table = dead and HUDSettings.player_colors.dead or HUDHelper:player_color(local_player, other_player, taggable)

	if not name_color_table then
		return
	end

	local name_color = Color(name_color_table[1] * alpha_multiplier, name_color_table[2], name_color_table[3], name_color_table[4])
	local name_shadow_color = Color(HUDSettings.player_colors.shadow[1] * alpha_multiplier, HUDSettings.player_colors.shadow[2], HUDSettings.player_colors.shadow[3], HUDSettings.player_colors.shadow[4])
	local name_text = other_player:name()
	local is_squad_member = self:_is_squad_member()
	local name_scaled_font_size = is_squad_member and 20 or HUDHelper:floating_text_icon_size(screen_z, settings.font_size, settings.min_scale, settings.max_scale, settings.min_scale_distance, settings.max_scale_distance)
	local font = MenuSettings.fonts.player_name_font
	local min, max = Gui.text_extents(gui, name_text, font.font, name_scaled_font_size)
	local name_width = max[1] - min[1]
	local name_mid = (min[1] + max[1]) / 2
	local name_height = max[3] - min[3]
	local name_position = Vector3(screen_x - name_mid, screen_y, 2)
	local shadow_offset = Vector3(1, -1, -1)
	local is_squad_member = self:_is_squad_member()
	local clamped_x, clamped_y = HUDHelper:clamped_icon_position(screen_x, screen_y, screen_z)

	if is_squad_member or self:_help_requested(t) then
		name_position = Vector3(clamped_x - name_width * 0.5, clamped_y, 0)
	end

	local player_pos = Unit.alive(player_unit) and Unit.local_position(player_unit, 0) or Managers.state.camera:camera_position(local_player.viewport_name)
	local other_player_pos = Unit.local_position(other_player_unit, 0)
	local distance = Vector3.length(player_pos - other_player_pos)
	local in_range = distance < SquadSettings.far_range

	if local_player ~= other_player then
		if is_squad_member then
			local tmp

			tmp, name_color = self:_get_name_color(distance, t)

			Gui.text(gui, name_text, font.font, name_scaled_font_size, font.material, name_position, Color(255, name_color[1], name_color[2], name_color[3]))
			Gui.text(gui, name_text, font.font, name_scaled_font_size, font.material, name_position + shadow_offset, Color(255, 0, 0, 0))
		else
			Gui.text(gui, name_text, font.font, name_scaled_font_size, font.material, name_position, name_color)
			Gui.text(gui, name_text, font.font, name_scaled_font_size, font.material, name_position + shadow_offset, name_shadow_color)
		end

		if is_squad_member and other_player.is_corporal then
			local material, uv00, uv11, size = HUDHelper.atlas_material("hud_assets", "squad_leader_icon")

			Gui.bitmap_uv(gui, material, uv00, uv11, name_position + Vector3(-size[1], -size[2] * 0.3, 0), size, Color(in_range and 255 or 128, 255, 255, 255))
		end
	end

	Profiler.stop("render name")
	Profiler.start("status texture")

	local status_texture, status_perk_texture, status_perk_texture_atlas, secondary_texture, secondary_texture_blend_function, secondary_texture_z_offset, action_text

	if local_player.team == other_player.team and (not SquadSettings.status_icons_on_squad_only or is_squad_member) then
		if dead then
			status_texture = settings.texture_dead
		elseif damage_ext:is_knocked_down() and not damage_ext:is_reviving() then
			status_texture = settings.texture_knocked_down

			if other_player_loco:has_perk("revive_yourself") then
				status_perk_texture = "perk_icon_strong_will_hud"
				status_perk_texture_atlas = "hud_assets"
				action_text = L("perk_header_revive_yourself")
			else
				if self:_help_requested(t) then
					secondary_texture = settings.texture_knocked_down_glow
					secondary_texture_blend_function = settings.texture_knocked_down_revive_request_blend_function
					secondary_texture_z_offset = 1
				else
					secondary_texture = settings.texture_knocked_down_glow
					secondary_texture_blend_function = settings.texture_knocked_down_blend_function
					secondary_texture_z_offset = -1
				end

				action_text = L("floating_icon_revive")
			end
		elseif damage_ext:is_last_stand_active() and damage_ext:is_alive() then
			status_texture = Perks.last_stand.texture_last_stand
			status_perk_texture = settings.texture_last_stand
			status_perk_texture_atlas = "hud_assets"
			secondary_texture = hud_assets[settings.texture_last_stand_glow]
			secondary_texture_z_offset = 0
			secondary_texture_blend_function = settings.texture_last_stand_blend_function
		end
	elseif local_player.team ~= other_player.team and damage_ext:is_knocked_down() and not dead then
		status_texture = settings.texture_knocked_down_enemy
		secondary_texture = settings.texture_knocked_down_enemy_glow
		secondary_texture_blend_function = settings.texture_knocked_down_enemy_blend_function
		secondary_texture_z_offset = -1
		action_text = L("floating_icon_finish_off")
	elseif damage_ext:is_last_stand_active() and damage_ext:is_alive() then
		status_texture = settings.texture_last_stand
		status_perk_texture = settings.texture_last_stand
		status_perk_texture_atlas = "hud_assets"
		secondary_texture = hud_assets[settings.texture_last_stand_glow]
		secondary_texture_z_offset = 0
		secondary_texture_blend_function = settings.texture_last_stand_blend_function
	end

	if status_texture then
		local status_texture_uv00, status_texture_uv11, size_1, size_2

		if status_perk_texture and status_perk_texture_atlas then
			local material, uv00, uv11, size = HUDHelper.atlas_material(status_perk_texture_atlas, status_perk_texture)

			status_texture_uv00 = uv00
			status_texture_uv11 = uv11
			size_1 = size[1]
			size_2 = size[2]
		else
			status_texture_uv00 = Vector2(status_texture.uv00[1], status_texture.uv00[2])
			status_texture_uv11 = Vector2(status_texture.uv11[1], status_texture.uv11[2])
			size_1 = status_texture.size[1]
			size_2 = status_texture.size[2]
		end

		local status_texture_width, status_texture_height = HUDHelper:floating_icon_size(screen_z, size_1, size_2, settings.min_scale, settings.max_scale, settings.min_scale_distance, settings.max_scale_distance)
		local status_texture_position = Vector3(screen_x - status_texture_width * settings.texture_scale * 0.5, screen_y + name_height * 1.5 - status_texture_height * settings.texture_scale * 0.5 + settings.texture_y_offset, 0)
		local status_texture_color = Color(255, 255, 255, 255)

		if is_squad_member or self:_help_requested(t) then
			status_texture_position = Vector3(clamped_x - status_texture_width * settings.texture_scale * 0.5, clamped_y + name_height * 1.5 - status_texture_height * settings.texture_scale * 0.5 + settings.texture_y_offset, 0)
		end

		local size = Vector2(status_texture_width * settings.texture_scale, status_texture_height * settings.texture_scale)

		if action_text then
			local min, max = Gui.text_extents(gui, action_text, font.font, name_scaled_font_size * 0.8)
			local mid = (min[1] + max[1]) / 2
			local pos

			if is_squad_member or self:_help_requested(t) then
				pos = Vector3(clamped_x - mid, status_texture_position.y + size.y, 0)
			else
				pos = Vector3(screen_x - mid, status_texture_position.y + size.y, 0)
			end

			ScriptGUI.text(gui, action_text, font.font, name_scaled_font_size * 0.8, font.material, pos, Color(255, 255, 255, 255), Color(255, 0, 0, 0), Vector3(2, -2, 0))
		end

		if secondary_texture then
			local alpha = secondary_texture_blend_function(t)

			Gui.bitmap_uv(gui, status_perk_texture_atlas or settings.texture_atlas, Vector2(secondary_texture.uv00[1], secondary_texture.uv00[2]), Vector2(secondary_texture.uv11[1], secondary_texture.uv11[2]), status_texture_position + Vector3(0, 0, secondary_texture_z_offset), size, Color(255 * alpha, 255, 255, 255))

			status_texture_color = Color(255, 255, 255, 255)
		end

		Gui.bitmap_uv(gui, status_perk_texture_atlas or settings.texture_atlas, status_texture_uv00, status_texture_uv11, status_texture_position, size, status_texture_color)
	end

	Profiler.stop("status texture")
	Profiler.start("magical healthbar")

	local player_tagged, tagging_player = PlayerMechanicsHelper.player_unit_tagged(local_player, other_player_unit)
	local tagger_locomotion = tagging_player and Unit.alive(tagging_player.player_unit) and ScriptUnit.extension(tagging_player.player_unit, "locomotion_system")
	local player_tagged_by_tag_on_bow_shot = player_tagged and tagger_locomotion and tagger_locomotion:has_perk("tag_on_bow_shot")

	if in_range and local_player ~= other_player and (SquadSettings.render_health == "team" or SquadSettings.render_health == "squad" and is_squad_member or player_tagged_by_tag_on_bow_shot) then
		local damage_ext = ScriptUnit.extension(other_player_unit, "damage_system")

		if not damage_ext:is_alive() then
			Profiler.stop("magical healthbar")

			return
		end

		local health_bar_settings = HUDSettings.player_icons.health_bar
		local colors = health_bar_settings.colors
		local size_settings = health_bar_settings.size
		local pos = name_position + Vector3(min[1], health_bar_settings.y_offset, 0)
		local size_x = math.max(name_width, size_settings[1])
		local size = Vector2(size_x, size_settings[2])

		Gui.rect(gui, pos, size, Color(name_color_alpha, 0, 0, 0))
		Gui.rect(gui, pos + Vector3(1, 1, 1), size + Vector2(-2, -2), Color(name_color_alpha, 60, 60, 60))

		local hp_left = 1 - damage_ext._damage / damage_ext._health
		local color

		for _, color_table in ipairs(colors) do
			if hp_left >= color_table.above then
				color = color_table.value

				break
			end
		end

		color = color or colors.less

		local rows = size[2] - 1

		for i = 1, rows - 1 do
			local color_scale = math.sin(math.pi * i / (rows + 1)) * (0.86^(rows - i - 1))^2 * 1.25

			Gui.rect(gui, pos + Vector3(1, i, 2), Vector2((size_x - 2) * hp_left, 1), Color(name_color_alpha, color[2] * color_scale, color[3] * color_scale, color[4] * color_scale))
		end
	end

	Profiler.stop("magical healthbar")
end

function FloatingPlayerHUDIcon:_help_requested(t)
	local unit = self._player_unit

	return ScriptUnit.extension(unit, "damage_system"):is_knocked_down() and t < self._help_requested_time + 15
end

function FloatingPlayerHUDIcon:_get_name_color(distance, t)
	local old_state = self._state

	if distance < SquadSettings.far_range then
		self._state = "color_lit"
	else
		self._state = "color_unlit"
	end

	if self._state ~= old_state then
		self._state_data = nil
	end

	return self[self._state](self, t)
end

function FloatingPlayerHUDIcon:color_lit(t)
	local pulse_duration = 0.5

	if not self._state_data then
		self._state_data = {
			end_multiplier = 1,
			start_multiplier = 3,
			end_time = t + pulse_duration
		}
	end

	local name_alpha = 1
	local multiplier = self._state_data.end_multiplier

	if t < self._state_data.end_time then
		local diff = self._state_data.end_time - t
		local value = math.smoothstep(diff / pulse_duration, 0, 1)

		multiplier = value * self._state_data.start_multiplier + (1 - value) * self._state_data.end_multiplier
		name_alpha = math.lerp(1, 0, value)
	end

	local c = HUDSettings.player_colors.squad_member
	local name_color = {
		math.min(c[2] * multiplier, 255),
		math.min(c[3] * multiplier, 255),
		math.min(c[4] * multiplier, 255)
	}

	return name_alpha, name_color
end

function FloatingPlayerHUDIcon:color_unlit(t)
	local c = HUDSettings.player_colors.squad_member_out_of_range
	local name_color = {
		c[2],
		c[3],
		c[4]
	}
	local name_alpha = 1

	return name_alpha, name_color
end
