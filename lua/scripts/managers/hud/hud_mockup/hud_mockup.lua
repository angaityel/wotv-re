-- chunkname: @scripts/managers/hud/hud_mockup/hud_mockup.lua

require("scripts/managers/hud/shared_hud_elements/hud_hit_indicator")

HUDMockup = class(HUDMockup, HUDBase)

function HUDMockup:init(world, player, hud_data)
	HUDMockup.super.init(self, world, player)

	self._world = world
	self._player = player

	local resolution_width, resolution_height = Gui.resolution()

	self._gui = World.create_screen_gui(self._world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.wotr_hud_text, "material", MenuSettings.font_group_materials.arial, "material", "materials/fonts/hell_shark_font", "immediate")

	local death_text_config = {
		z = 20,
		layout_settings = HUDSettings.death_text
	}
	local killer_name_config = {
		z = 20,
		layout_settings = HUDSettings.killer_name_text
	}
	local interaction_bar_config = {
		z = 20,
		layout_settings = HUDSettings.interaction.interaction_bar
	}

	self._death_text = HUDTextElement.create_from_config(death_text_config)
	self._killer_name_text = HUDTextElement.create_from_config(killer_name_config)
	self._interaction_bar = HUDPowerBarElement.create_from_config(interaction_bar_config)
	self._interaction_bar_text = HUDTextElement.create_from_config({
		layout_settings = HUDSettings.interaction.interaction_bar_text
	})

	Managers.state.event:register(self, "projectile_hit_afro", "event_projectile_hit_afro", "show_hud_changed", "event_show_hud_changed")

	self._hits = {}
	self._reticule_alpha = 0
end

function HUDMockup:event_projectile_hit_afro(player, projectile_unit)
	if player ~= self._player then
		return
	end

	local config = {
		layout_settings = table.clone(HUDSettings.hit_indicator)
	}
	local hit_indicator = HUDHitIndicator.create_from_config(config, player.viewport_name, Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.world_rotation(projectile_unit, 0)))))
	local hit_time = Managers.time:time("game")

	table.insert(self._hits, 1, {
		hit_indicator = hit_indicator,
		time = hit_time
	})
end

function HUDMockup:event_show_hud_changed(show_hud)
	if not show_hud then
		self:_clear_damage_indicator("_id1")
		self:_clear_damage_indicator("_id2")
		self:_clear_damage_indicator("_id3")
		self:_clear_damage_indicator("_id4")
	end
end

local HIT_INDICATOR_DURATION = 1.5

function HUDMockup:_update_hit_indicator(dt, t, resolution_width, resolution_height)
	local remove_hits = false
	local gui = self._gui

	for i = 1, #self._hits do
		local hit = self._hits[i]
		local duration = hit.time + HIT_INDICATOR_DURATION - t

		if duration < 0 or remove_hits then
			hit[i] = nil
			remove_hits = true
		else
			local hit_indicator = hit.hit_indicator
			local hit_indicator_config = hit_indicator.config
			local layout_settings = HUDHelper:layout_settings(hit_indicator_config.layout_settings)

			layout_settings.color[1] = math.sin(duration / HIT_INDICATOR_DURATION * math.half_pi) * 255

			hit_indicator:update_size(dt, t, gui, layout_settings)

			local x, y = HUDHelper:element_position(nil, hit_indicator, layout_settings)

			hit_indicator:update_position(dt, t, layout_settings, x, y, layout_settings.z)
			hit_indicator:render(dt, t, gui, layout_settings)
		end
	end
end

function HUDMockup:post_update(dt, t)
	local resolution_width, resolution_height = Gui.resolution()

	self:_update_interaction_progress(dt, t, resolution_width, resolution_height)
	self:_update_reticule(dt, t, resolution_width, resolution_height)
	self:_update_damage_indicator(dt, t, resolution_width, resolution_height)
	self:_update_interaction(dt, t, resolution_width, resolution_height)
	self:_update_hit_indicator(dt, t, resolution_width, resolution_height)
end

function HUDMockup:_update_interaction(dt, t, resolution_width, resolution_height)
	local state_data = self._player.state_data
	local font = MenuSettings.fonts.hell_shark_36.font
	local font_material = MenuSettings.fonts.hell_shark_36.material
	local size = 36

	for index, interaction in ipairs(PlayerUnitMovementSettings.interaction) do
		local interaction_variable = interaction.state_data_name
		local interaction_string = state_data[interaction_variable]

		if interaction_string then
			local text = ""

			if Managers.input:pad_active(1) then
				local interaction_arg1 = state_data[interaction.state_data_arg1]
				local interaction_arg2 = state_data[interaction.state_data_arg2]
				local full_text = L(interaction_string)

				if interaction_arg1 and interaction_arg2 then
					text = sprintf(text, interaction_arg1, interaction_arg2)
				elseif interaction_arg1 then
					text = sprintf(text, interaction_arg1)
				end

				local prefix, suffix, button = self:_handle_pad_interaction_text(interaction_string)
				local text_extent_min, text_extent_max = Gui.text_extents(self._gui, full_text, font, size)
				local text_width = text_extent_max[1] - text_extent_min[1]
				local text_height = text_extent_max[3] - text_extent_min[3]
				local x = resolution_width / 2 - text_width / 2
				local y = resolution_height / 2.5 - 120 - (index - 1) * text_height * 1.5

				if prefix then
					Gui.text(self._gui, prefix, font, size, font_material, Vector3(x, y, 0), Color(255, 255, 255))
				end

				if button and prefix then
					local min, max = Gui.text_extents(self._gui, prefix, font, size)
					local button_offset = max[1] - min[1]

					Gui.text(self._gui, button, "materials/fonts/hell_shark_36", size, "hell_shark_36", Vector3(x + button_offset, y, 0), Color(255, 255, 255))
				end

				if prefix and button and suffix then
					local min, max = Gui.text_extents(self._gui, prefix .. button, font, size)
					local suffix_offset = max[1] - min[1]

					Gui.text(self._gui, suffix, font, size, font_material, Vector3(x + suffix_offset, y, 0), Color(255, 255, 255))
				end
			else
				text = L(interaction_string)

				local interaction_arg1 = state_data[interaction.state_data_arg1]
				local interaction_arg2 = state_data[interaction.state_data_arg2]

				if interaction_arg1 and interaction_arg2 then
					text = sprintf(text, interaction_arg1, interaction_arg2)
				elseif interaction_arg1 then
					text = sprintf(text, interaction_arg1)
				end

				local text_extent_min, text_extent_max = Gui.text_extents(self._gui, text, font, size)
				local text_width = text_extent_max[1] - text_extent_min[1]
				local text_height = text_extent_max[3] - text_extent_min[3]
				local x = resolution_width / 2 - text_width / 2
				local y = resolution_height / 2.5 - 120 - (index - 1) * text_height * 1.5

				Gui.text(self._gui, text, font, size, font_material, Vector3(x, y, 0), Color(255, 255, 255))
			end
		end
	end
end

function HUDMockup:_handle_pad_interaction_text(text)
	text = Managers.localizer:simple_lookup(text)

	local prefix_arg_start, prefix_arg_end = string.find(text, "KEY")

	if prefix_arg_start then
		local prefix = string.sub(text, 1, prefix_arg_start - 2) .. " "
		local suffix_arg_start, suffix_arg_end = string.find(text, ":")
		local suffix = string.sub(text, suffix_arg_end + 1, -2)
		local button = Managers.localizer:_find_macro(string.sub(text, prefix_arg_start - 1, suffix_arg_start))

		return prefix, suffix, button
	else
		return L(text)
	end
end

function HUDMockup:_update_damage_indicator(dt, t, resolution_width, resolution_height)
	local state_data = self._player.state_data

	if state_data.damage then
		local new_damage = state_data.damage / state_data.health
		local world = self._world

		if new_damage > 0.1 and not self._id1 then
			self._id1 = World.create_particles(world, "fx/screenspace_damage_4", Vector3(0, 0, 0))
		elseif new_damage < 0.1 and self._id1 then
			self:_clear_damage_indicator("_id1")
		end

		if new_damage > 0.3 and not self._id2 then
			self._id2 = World.create_particles(world, "fx/screenspace_damage_3", Vector3(0, 0, 0))
		elseif new_damage < 0.3 and self._id2 then
			self:_clear_damage_indicator("_id2")
		end

		if new_damage > 0.5 and not self._id3 then
			self._id3 = World.create_particles(world, "fx/screenspace_damage_2", Vector3(0, 0, 0))
		elseif new_damage < 0.5 and self._id3 then
			self:_clear_damage_indicator("_id3")
		end

		if new_damage > 0.7 and not self._id4 then
			self._id4 = World.create_particles(world, "fx/screenspace_damage_1", Vector3(0, 0, 0))
		elseif new_damage < 0.7 and self._id4 then
			self:_clear_damage_indicator("_id4")
		end
	else
		self:_clear_damage_indicator("_id1")
		self:_clear_damage_indicator("_id2")
		self:_clear_damage_indicator("_id3")
		self:_clear_damage_indicator("_id4")
	end
end

function HUDMockup:_clear_damage_indicator(key)
	local id = self[key]

	if not id then
		return
	end

	World.destroy_particles(self._world, id)

	self[key] = nil
end

local function pulse(t, min, max, speed)
	local amp = (max - min) / 2
	local off = min + amp

	return amp * math.cos(t * speed) + off
end

local interaction_strings = {
	bandage = "bar_bandage",
	bandage_self = "bar_bandage_self",
	loot = "bar_loot",
	revive = "bar_revive"
}

function HUDMockup:_update_interaction_progress(dt, t, resolution_width, resolution_height)
	local state_data = self._player.state_data
	local interaction_progress = state_data.interaction_progress
	local interaction_duration = state_data.interaction_duration
	local interaction_type = state_data.interaction_type

	if interaction_progress and interaction_duration then
		local gui = self._gui
		local bar = self._interaction_bar

		bar:set_value(math.clamp(1 - interaction_progress / interaction_duration, 0, 1))

		local layout_settings = HUDHelper:layout_settings(bar.config.layout_settings)

		bar:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, bar, layout_settings)

		bar:update_position(dt, t, layout_settings, x, y, 0)
		bar:render(dt, t, gui, layout_settings)

		if interaction_type then
			local bar_text = self._interaction_bar_text
			local config = bar_text.config
			local layout_settings = HUDHelper:layout_settings(config.layout_settings)

			if layout_settings.pulse_speed and layout_settings.pulse_alpha_min and layout_settings.pulse_alpha_max then
				local pulse = pulse(t, layout_settings.pulse_alpha_min, layout_settings.pulse_alpha_max, layout_settings.pulse_speed)

				config.color = layout_settings.text_color
				config.color[1] = pulse
			end

			config.text = interaction_strings[interaction_type] and L(interaction_strings[interaction_type]) or interaction_type

			bar_text:update_size(dt, t, gui, layout_settings)

			local x, y = HUDHelper:element_position(nil, bar_text, layout_settings)

			bar_text:update_position(dt, t, layout_settings, x, y, 20)
			bar_text:render(dt, t, gui, layout_settings)
		end
	end
end

function HUDMockup:_update_reticule(dt, t, resolution_width, resolution_height)
	if HUDSettings.show_reticule then
		local player = self._player
		local player_unit = player.player_unit
		local locomotion = player and Unit.alive(player_unit) and ScriptUnit.has_extension(player_unit, "locomotion_system") and ScriptUnit.extension(player_unit, "locomotion_system")
		local show = locomotion and (locomotion.aiming or locomotion.throw_data and locomotion.throw_data.state ~= "released_weapon" and locomotion.throw_data.state ~= "wielding" and (locomotion.throw_data.state ~= "posing" or t > locomotion.throw_data.pose_time - 0.2))

		if show then
			self._reticule_alpha = 1
		else
			self._reticule_alpha = math.max(self._reticule_alpha - dt * 4, 0)
		end

		if self._reticule_alpha > 0 then
			local atlas_name = "hud_assets"
			local crosshair = Application.user_setting("crosshair") or "crosshair_texture_1"
			local crosshair_r = Application.user_setting("crosshair_r") or 255
			local crosshair_g = Application.user_setting("crosshair_g") or 255
			local crosshair_b = Application.user_setting("crosshair_b") or 255
			local crosshair_alpha = Application.user_setting("crosshair_alpha") or 255
			local color = Color(crosshair_alpha * math.smoothstep(self._reticule_alpha, 0, 1), crosshair_r, crosshair_g, crosshair_b)

			if rawget(_G, atlas_name)[crosshair] then
				local material, uv00, uv11, size = HUDHelper.atlas_material(atlas_name, crosshair)
				local scale = 1

				Gui.bitmap_uv(self._gui, material, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), Vector3((resolution_width - scale * size.x) / 2, (resolution_height - scale * size.y) / 2, 0), scale * size, color)
			end
		end
	end
end

function HUDMockup:destroy()
	World.destroy_gui(self._world, self._gui)
end
