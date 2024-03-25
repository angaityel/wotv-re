-- chunkname: @scripts/managers/hud/hud_game_mode_status/hud_game_mode_status.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_extended_container")
require("scripts/managers/hud/hud_game_mode_status/hud_objective_point_icon")

HUDGameModeStatus = class(HUDGameModeStatus, HUDBase)

function HUDGameModeStatus:init(world, player)
	HUDGameModeStatus.super.init(self, world, player)

	self._world = world
	self._player = player
	self._show_game_mode_status = true
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", "materials/fonts/hell_shark_font", "material", "materials/fonts/viking_numbers_font", "immediate")
	self._objective_text = ""

	self:_setup()
	Managers.state.event:register(self, "refresh_game_mode_objective", "event_refresh_objective")
	Managers.state.event:register(self, "set_game_mode_objective_text", "event_set_objective_text")
	Managers.state.event:register(self, "show_game_mode_status", "event_show_game_mode_status")
	Managers.state.event:register(self, "objective_points_ordered", "event_objective_points_ordered")
end

function HUDGameModeStatus:_setup()
	self._container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.game_mode_status.container
	})
	self._objective_point_icon_container = HUDExtendedContainer.create_from_config({
		layout_settings = HUDSettings.game_mode_status.objective_point_icon_container
	})

	local round_timer_background_config = {
		text = "",
		z = 1,
		layout_settings = HUDSettings.game_mode_status.round_timer_background
	}

	self._round_timer_background = HUDTextureElement.create_from_config(round_timer_background_config)

	self._container:add_element("round_timer_background", self._round_timer_background)

	local round_timer_config = {
		text = "",
		z = 1,
		layout_settings = table.clone(HUDSettings.game_mode_status.round_timer)
	}

	self._round_timer = HUDTextElement.create_from_config(round_timer_config)

	self._container:add_element("round_timer", self._round_timer)

	self._container_menu = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.game_mode_status.container
	})

	local round_timer_background_config = {
		text = "",
		z = 1,
		layout_settings = HUDSettings.game_mode_status.round_timer_background
	}

	self._round_timer_menu = HUDTextureElement.create_from_config(round_timer_background_config)

	self._container_menu:add_element("round_timer_background", self._round_timer_menu)

	local round_timer_config = {
		text = "",
		z = 2,
		layout_settings = table.clone(HUDSettings.game_mode_status.round_timer_menu)
	}

	self._round_timer_menu = HUDTextElement.create_from_config(round_timer_config)

	self._container_menu:add_element("round_timer", self._round_timer_menu)
	self._container:add_element("round_timer_background", self._container_menu)

	if GameModeSettings[Managers.state.game_mode:game_mode_key()].team_scoring_hud then
		self:_setup_tdm_gui()
	end
end

function HUDGameModeStatus:_setup_tdm_gui()
	self._tdm_score_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.game_mode_status.tdm_score_container
	})

	local tdm_score_middle_background_config = {
		z = 3,
		player = self._player,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_background)
	}

	self._tdm_score_middle_background = HUDTextureElement.create_from_config(tdm_score_middle_background_config)

	self._tdm_score_container:add_element("tdm_score_middle_background", self._tdm_score_middle_background)

	local tdm_score_left_background_config = {
		z = 2,
		player = self._player,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_background_left)
	}

	self._tdm_score_left_background = HUDTextureElement.create_from_config(tdm_score_left_background_config)

	self._tdm_score_container:add_element("tdm_score_left_background", self._tdm_score_left_background)

	local tdm_score_right_background_config = {
		z = 2,
		player = self._player,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_background_right)
	}

	self._tdm_score_right_background = HUDTextureElement.create_from_config(tdm_score_right_background_config)

	self._tdm_score_container:add_element("tdm_score_right_background", self._tdm_score_right_background)

	local tdm_score_middle_counter = {
		text = "",
		z = 4,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_counter)
	}

	self._tdm_score_counter = HUDTextElement.create_from_config(tdm_score_middle_counter)

	self._tdm_score_container:add_element("tdm_score_counter", self._tdm_score_counter)

	local tdm_score_left_counter = {
		text = "",
		z = 3,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_counter_left)
	}

	self._tdm_score_left_counter = HUDTextElement.create_from_config(tdm_score_left_counter)

	self._tdm_score_container:add_element("tdm_score_left_counter", self._tdm_score_left_counter)

	local tdm_score_right_counter = {
		text = "",
		z = 3,
		layout_settings = table.clone(HUDSettings.game_mode_status.tdm_score_counter_right)
	}

	self._tdm_score_right_counter = HUDTextElement.create_from_config(tdm_score_right_counter)

	self._tdm_score_container:add_element("tdm_score_right_counter", self._tdm_score_right_counter)
	self._container:add_element("tdm_score", self._tdm_score_container)
end

function HUDGameModeStatus:event_objective_points_ordered(object_order_id, unit, table_size)
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local objective_point_icon_config = {
		layout_settings = "HUDSettings.game_mode_status.objective_point_icon",
		z = 1,
		player = self._player
	}
	local name = NetworkLookup.objective_point_order_ids[object_order_id]
	local objective_point_icon = HUDObjectivePointIcon.create_from_config(objective_point_icon_config)

	objective_point_icon.config.slot_number = string.sub(name, -1)
	objective_point_icon.config.objective_point_unit = unit

	self._objective_point_icon_container:add_element("objective_point_icon" .. string.sub(name, -1), objective_point_icon)
	self._container:add_element("objective_point_icon_container", self._objective_point_icon_container)
	self._container_menu:add_element("objective_point_icon_container", self._objective_point_icon_container)
end

function HUDGameModeStatus:event_refresh_objective()
	local objective, param1, param2 = Managers.state.game_mode:objective(self._player)

	self:_set_objective_texts(self._player, objective, param1, param2)
end

function HUDGameModeStatus:event_set_objective_text(objective)
	local param1, param2 = GameModeHelper:objective_parameters(objective, self._player, self._world)

	self:_set_objective_texts(self._player, objective, param1, param2)
end

function HUDGameModeStatus:event_show_game_mode_status(show)
	self._show_game_mode_status = show
end

function HUDGameModeStatus:_update_objective(player)
	local objective, param1, param2 = Managers.state.game_mode:objective(player)

	if not objective then
		return
	end

	if objective ~= self._objective or param1 ~= self._param1 or param2 ~= self._param2 then
		self:_set_objective_texts(player, objective, param1, param2)
	end

	self._objective = objective
	self._param1 = param1
	self._param2 = param2
end

function HUDGameModeStatus:_set_objective_texts(player, objective, param1, param2)
	if objective == "" then
		self._objective_text = ""
	else
		self._objective_text = string.format(L(objective), param1, param2)
	end

	local announcement = GameModeObjectives[objective].announcement

	if announcement then
		local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

		Managers.state.event:trigger("game_mode_announcement", announcement, param1, param2)
	end
end

function HUDGameModeStatus:disabled_post_update(dt, t)
	local player = self._player

	if not player.team or player.team.name == "unassigned" then
		return
	end

	self:_update_objective(player)
end

function HUDGameModeStatus:post_update(dt, t)
	local player = self._player

	if not player.team or player.team.name == "unassigned" or script_data.map_dump_mode then
		return
	end

	self:_update_objective(player)

	local own_team_name = player.team.name
	local enemy_team_name = own_team_name == "red" and "white" or "red"
	local timer_text, timer_alert = Managers.state.game_mode:hud_timer_text()

	self._round_timer.config.text = timer_text

	if timer_alert then
		local round_timer_layout_settings = HUDHelper:layout_settings(self._round_timer.config.layout_settings)

		round_timer_layout_settings.text_color[1] = 100 * math.cos(t * 6) + 155
	end

	self._round_timer_menu.config.text = timer_text

	if timer_alert then
		local round_timer_layout_settings = HUDHelper:layout_settings(self._round_timer_menu.config.layout_settings)

		round_timer_layout_settings.text_color[1] = 100 * math.cos(t * 6) + 155
	end

	if self._tdm_score_container then
		local tdm_goal = Managers.state.game_mode:win_score()

		self._tdm_score_counter.config.text = math.round(tdm_goal, 0)

		local friendly_team = Managers.state.team:team_by_name(own_team_name)
		local enemy_team = Managers.state.team:team_by_name(enemy_team_name)

		self._tdm_score_left_counter.config.text = math.round(friendly_team.score, 0)
		self._tdm_score_right_counter.config.text = math.round(enemy_team.score, 0)
	end

	if self._show_game_mode_status then
		local layout_settings = HUDHelper:layout_settings(self._container.config.layout_settings)
		local gui = self._gui

		self._container:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._container, layout_settings)

		self._container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._container:render(dt, t, gui, layout_settings)
	else
		local layout_settings = HUDHelper:layout_settings(self._container_menu.config.layout_settings)
		local gui = self._gui

		self._container_menu:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._container_menu, layout_settings)

		self._container_menu:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._container_menu:render(dt, t, gui, layout_settings)
	end
end

function HUDGameModeStatus:destroy()
	World.destroy_gui(self._world, self._gui)
end
