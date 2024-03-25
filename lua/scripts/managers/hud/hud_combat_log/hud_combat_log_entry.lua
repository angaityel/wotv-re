-- chunkname: @scripts/managers/hud/hud_combat_log/hud_combat_log_entry.lua

HUDCombatLogEntry = class(HUDCombatLogEntry)

function HUDCombatLogEntry:init(config)
	self.config = config
	self._local_player = config.local_player
	self._attacker_name = nil
	self._victim_name = nil
	self._weapon_texture_settings = nil
	self._attacker_color = nil
	self._victim_color = nil
	self._background_color = QuaternionBox()
	self._render_attacking_player = false
end

function HUDCombatLogEntry:set_entry_data(attacking_player, victim_player, gear_name, hit_zone)
	self._attacker_name = attacking_player:name()
	self._victim_name = victim_player:name()

	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)

	if gear_name == "n/a" then
		self._weapon_texture_settings = layout_settings.texture_atlas_settings.hud_combatlog_selfkilled
	else
		local gear_settings = Gear[gear_name]
		local weapon_texture_name = hit_zone == "helmet" and gear_settings.ui_combat_log_texture_headshot or hit_zone == "head" and gear_settings.ui_combat_log_texture_facehit or gear_settings.ui_combat_log_texture

		self._weapon_texture_settings = layout_settings.texture_atlas_settings[weapon_texture_name]
		self._gear_name = gear_name
	end

	local local_player = self._local_player

	if attacking_player ~= victim_player and attacking_player then
		self._render_attacking_player = true
	end

	self._attacker_color = self:_player_color(layout_settings, local_player, attacking_player)
	self._victim_color = self:_player_color(layout_settings, local_player, victim_player)

	self._background_color:store(not (local_player ~= attacking_player and victim_player ~= local_player) and Color(200, 180, 180, 180) or Color(75, 50, 50, 50))
end

function HUDCombatLogEntry:_player_color(layout_settings, self_player, other_player)
	return self_player.team.name == "unassigned" and HUDSettings.player_colors[other_player.team.name] or self_player.team == other_player.team and (self_player.squad_index and other_player.squad_index == self_player.squad_index and HUDSettings.player_colors.squad_member or HUDSettings.player_colors.team_member) or HUDSettings.player_colors.enemy
end

function HUDCombatLogEntry:width()
	return self._width
end

function HUDCombatLogEntry:height()
	return self._height
end

function HUDCombatLogEntry:update_size(dt, t, gui, layout_settings)
	self._width = layout_settings.width
	self._height = layout_settings.height
end

function HUDCombatLogEntry:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HUDCombatLogEntry:render(dt, t, gui, layout_settings)
	if self._weapon_texture_settings then
		local c = self._victim_color
		local victim_color = Color(c[1] * layout_settings.alpha_multiplier, c[2], c[3], c[4])
		local victim_name_cropped = HUDHelper:crop_text(gui, self._victim_name, layout_settings.font.font, layout_settings.font_size, layout_settings.text_max_width, "...")
		local min, max = Gui.text_extents(gui, victim_name_cropped, layout_settings.font.font, layout_settings.font_size)
		local victim_name_width = max[1] - min[1]
		local weapon_texture_settings = self._weapon_texture_settings
		local uv00 = Vector2(weapon_texture_settings.uv00[1], weapon_texture_settings.uv00[2])
		local uv11 = Vector2(weapon_texture_settings.uv11[1], weapon_texture_settings.uv11[2])
		local size = Vector2(weapon_texture_settings.size[1], weapon_texture_settings.size[2])
		local weapon_color = Color(255 * layout_settings.alpha_multiplier, 255, 255, 255)
		local c = self._attacker_color
		local attacker_color = Color(c[1] * layout_settings.alpha_multiplier, c[2], c[3], c[4])
		local attacker_name_cropped = HUDHelper:crop_text(gui, self._attacker_name, layout_settings.font.font, layout_settings.font_size, layout_settings.text_max_width, "...")
		local min, max = Gui.text_extents(gui, attacker_name_cropped, layout_settings.font.font, layout_settings.font_size)
		local attacker_name_width = max[1] - min[1]
		local weapon_texture_x = self._x + (self._width - weapon_texture_settings.size[1]) * 0.5
		local victim_name_x = self._x + self._width * 0.5 + layout_settings.padding
		local attacker_name_x = self._x + self._width * 0.5 - layout_settings.padding - attacker_name_width
		local text_y = math.floor(self._y + (self._height - layout_settings.font_size) * 0.5 + 3)
		local a, r, g, b = Quaternion.to_elements(self._background_color:unbox())
		local background_color = Color(a * layout_settings.alpha_multiplier, r, g, b)

		Gui.rect(gui, Vector3(math.floor(self._x), math.floor(self._y + self._height * 0.1), self._z - 1), Vector2(math.floor(self._width), math.floor(self._height * 0.8)), background_color)
		ScriptGUI.text(gui, victim_name_cropped, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(math.floor(victim_name_x), text_y, self._z), victim_color, Color(255 * layout_settings.alpha_multiplier, 0, 0, 0), Vector3(1, -1, 0))
		Gui.bitmap_uv(gui, layout_settings.texture_atlas, uv00, uv11, Vector3(math.floor(weapon_texture_x), self._y + self._height * 0.5 - weapon_texture_settings.size[2] * 0.5, self._z), size, weapon_color)

		if self._render_attacking_player then
			ScriptGUI.text(gui, attacker_name_cropped, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(math.floor(attacker_name_x), text_y, self._z), attacker_color, Color(255 * layout_settings.alpha_multiplier, 0, 0, 0), Vector3(1, -1, 0))
		end
	elseif self._gear_name then
		local text = "Missing combat log texture: " .. self._gear_name
		local color = Color(255 * layout_settings.alpha_multiplier, 255, 255, 255)
		local text_y = math.floor(self._y + (self._height - layout_settings.font_size) * 0.5 + 3)
		local text_x = self._x

		ScriptGUI.text(gui, text, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, Vector3(math.floor(text_x), text_y, self._z), color, Color(255 * layout_settings.alpha_multiplier, 0, 0, 0), Vector3(1, -1, 0))
	end
end

function HUDCombatLogEntry.create_from_config(config)
	return HUDCombatLogEntry:new(config)
end
