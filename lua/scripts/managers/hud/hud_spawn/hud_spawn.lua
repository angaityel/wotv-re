-- chunkname: @scripts/managers/hud/hud_spawn/hud_spawn.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_text_element")

HUDSpawn = class(HUDSpawn, HUDBase)

function HUDSpawn:init(world, player)
	HUDSpawn.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", "materials/fonts/hell_shark_font", "immediate")

	self:_setup()

	self._colors = {
		disabled = {
			255,
			125,
			125,
			125
		},
		enabled = {
			255,
			255,
			255,
			255
		},
		pulsing = {
			255,
			255,
			255,
			255
		},
		pulsing_red = {
			255,
			255,
			255,
			255
		},
		invisible = {
			0,
			255,
			255,
			255
		}
	}

	Managers.state.event:register(self, "ghost_mode_activated", "event_ghost_mode_activated")
	Managers.state.event:register(self, "ghost_mode_deactivated", "event_ghost_mode_deactivated")
	Managers.state.event:register(self, "ingame_menu_set_active", "event_ingame_menu_set_active")
end

function HUDSpawn:event_ingame_menu_set_active(active)
	self._ingame_menu_active = active
end

function HUDSpawn:_setup()
	local is_domination = Managers.state.game_mode:game_mode_key() == "domination"

	self._container = HUDContainerElement.create_from_config({
		layout_settings = is_domination and HUDSettings.spawn.container_domination or HUDSettings.spawn.container
	})
	self._timer_text_blackboard = {}

	local timer_text_config = {
		text = "",
		z = 2,
		blackboard = self._timer_text_blackboard,
		layout_settings = HUDSettings.spawn.timer_text
	}

	self._container:add_element("timer_text", HUDTextElement.create_from_config(timer_text_config))

	local timer_texture_config = {
		z = 1,
		layout_settings = HUDSettings.spawn.timer_texture
	}

	self._container:add_element("timer_texture", HUDTextureElement.create_from_config(timer_texture_config))

	self._select_spawn_point_text = HUDTextElement.create_from_config({
		z = 1,
		layout_settings = HUDSettings.spawn.select_spawn_point_text,
		text = L("hud_spawn_right_click_respawn")
	})
	self._switch_spawn_point_text = HUDTextElement.create_from_config({
		z = 1,
		layout_settings = HUDSettings.spawn.switch_spawn_point_text,
		text = L("hud_spawn_right_click_select_spawn")
	})
	self._ask_for_aid_text = HUDTextElement.create_from_config({
		z = 1,
		layout_settings = HUDSettings.spawn.ask_for_aid_text,
		text = L("hud_spawn_left_click_ask_for_aid")
	})
end

function HUDSpawn:event_ghost_mode_activated()
	self._ghost_mode = true
end

function HUDSpawn:event_ghost_mode_deactivated()
	self._ghost_mode = false
end

function HUDSpawn:post_update(dt, t)
	self._timer_text_blackboard.color = self._colors.enabled

	local timer = false
	local aid = false
	local respawn = false
	local spawn_point_select = false
	local spawn_timer = Managers.state.spawn:spawn_timer(self._player)
	local round_time = Managers.time:time("round")
	local player = self._player

	if round_time and not Managers.time:active("round") then
		self._timer_text_blackboard.text = L("menu_waiting_for_more_players")
		timer = true
	elseif round_time and round_time < 0 then
		self._timer_text_blackboard.text = L("battle_starts_in") .. " " .. string.format("%.0f", math.abs(round_time))
		timer = true
	elseif spawn_timer then
		local damage_ext = Unit.alive(self._player.player_unit) and ScriptUnit.extension(self._player.player_unit, "damage_system")

		timer = false

		local spawn_data = self._player.spawn_data

		if spawn_data.state == "ghost_mode" and not self._ingame_menu_active then
			if spawn_timer == math.huge then
				self._timer_text_blackboard.text = L("menu_waiting_for_more_players")
			elseif spawn_timer > 0 then
				self._timer_text_blackboard.text = L("menu_time_to_spawn") .. " " .. string.format("%.0f", math.max(0, spawn_timer))
			else
				self._timer_text_blackboard.text = L("menu_press_to_spawn")
				self._timer_text_blackboard.color = self._colors.pulsing
			end

			spawn_point_select = true
			timer = true
		elseif damage_ext and damage_ext:is_knocked_down() and not damage_ext:is_dead() then
			if player.spawn_data.spawns and self._player.spawn_data.spawns >= Managers.state.game_mode:allowed_spawns(player.team) then
				aid = true
				timer = false
				respawn = true
				self._select_spawn_point_text.config.text = L("hud_spawn_right_click_observe")
			elseif spawn_timer > 0 then
				self._timer_text_blackboard.text = L("menu_time_to_spawn") .. " " .. string.format("%.0f", math.max(0, spawn_timer))
				aid = true
				respawn = true
				timer = true
				self._select_spawn_point_text.config.text = L("hud_spawn_right_click_respawn")
			else
				self._timer_text_blackboard.text = L("menu_press_to_yield")
				aid = true
				respawn = true
				timer = true
				self._select_spawn_point_text.config.text = L("hud_spawn_right_click_respawn")
			end
		elseif (spawn_data.mode == "point" or spawn_data.mode == "unconfirmed_point") and (spawn_data.state == "dead" or spawn_data.state == "not_spawned") and player.team.name ~= "unassigned" then
			self._timer_text_blackboard.text = L("menu_time_to_spawn") .. " " .. string.format("%.0f", math.max(0, spawn_timer))
			timer = true
		end
	end

	local gui = self._gui

	if timer then
		local pulsing = self._colors.pulsing
		local pulse_phase = math.lerp(100, 255, 0.5 * (math.sin(0.8 * t * math.pi % math.pi * 2) + 1))

		pulsing[4] = pulse_phase
		pulsing[2] = pulse_phase
		pulsing[3] = pulse_phase

		local pulsing_red = self._colors.pulsing_red

		pulsing_red[3] = pulse_phase
		pulsing_red[4] = pulse_phase

		local layout_settings = HUDHelper:layout_settings(self._container.config.layout_settings)

		self._container:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._container, layout_settings)

		self._container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._container:render(dt, t, gui, layout_settings)
	end

	if spawn_point_select and Managers.state.game_mode:game_mode_key() == "domination" then
		self:_update_element(dt, t, gui, self._switch_spawn_point_text)
	end

	if respawn then
		self:_update_element(dt, t, gui, self._select_spawn_point_text)
	end

	if aid and player.squad_index then
		self:_update_element(dt, t, gui, self._ask_for_aid_text)
	end
end

function HUDSpawn:_update_element(dt, t, gui, element)
	local layout_settings = HUDHelper:layout_settings(element.config.layout_settings)

	element:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, element, layout_settings)

	element:update_position(dt, t, layout_settings, x, y, element.config.z)
	element:render(dt, t, gui, layout_settings)
end

function HUDSpawn:destroy()
	World.destroy_gui(self._world, self._gui)
end
