-- chunkname: @scripts/managers/hud/hud_domination_minimap/hud_domination_minimap.lua

HUDDominationMinimap = class(HUDDominationMinimap, HUDBase)

function HUDDominationMinimap:init(world, local_player)
	self._minimap_enabled = false
	self._world = world
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", "materials/fonts/hell_shark_font", "material", "materials/menu/menu", "immediate")
	self._player = local_player

	local dom_minimap_layout = "HUDSettings.domination_minimap"
	local minimap_settings = self:level_settings()

	self._icons = {}
	self._icons.objective_icon_neutral = HUDAtlasTextureElement:new({
		pulse = true,
		z = 1,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".objective_icon_neutral"
	})
	self._icons.objective_icon_friendly = HUDAtlasTextureElement:new({
		pulse = true,
		z = 1,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".objective_icon_friendly"
	})
	self._icons.objective_icon_enemy = HUDAtlasTextureElement:new({
		pulse = true,
		z = 1,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".objective_icon_enemy"
	})
	self._icons.objective_icon_contested = HUDAtlasTextureElement:new({
		z = 0,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".objective_icon_contested"
	})
	self._icons.player_icon_friendly = HUDAtlasTextureElement:new({
		distance_fade = true,
		z = 2,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".player_icon_friendly"
	})
	self._icons.player_icon_squad = HUDAtlasTextureElement:new({
		distance_fade = true,
		z = 2,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".player_icon_squad"
	})
	self._icons.player_icon_player = HUDAtlasTextureElement:new({
		z = 3,
		rotate_3d = true,
		distance_fade = true,
		blackboard = {},
		layout_settings = dom_minimap_layout .. ".player_icon_player"
	})
	self._icons.objective_icon_white = HUDAtlasTextureElement:new({
		distance_fade = true,
		z = 2,
		layout_settings = "HUDSettings.domination_minimap.objective_icon_saxon",
		blackboard = {}
	})
	self._icons.objective_icon_red = HUDAtlasTextureElement:new({
		distance_fade = true,
		z = 2,
		layout_settings = "HUDSettings.domination_minimap.objective_icon_viking",
		blackboard = {}
	})
	self._icons.spawn_point_icon_white = HUDAtlasTextureElement:new({
		layout_settings = "HUDSettings.domination_minimap.spawn_point_icon_saxon",
		z = 2,
		distance_fade = false,
		blackboard = {},
		level_position = minimap_settings and minimap_settings.spawn_points.white
	})
	self._icons.spawn_point_icon_red = HUDAtlasTextureElement:new({
		layout_settings = "HUDSettings.domination_minimap.spawn_point_icon_viking",
		z = 2,
		distance_fade = false,
		blackboard = {},
		level_position = minimap_settings and minimap_settings.spawn_points.red
	})
	self._bg = HUDAtlasTextureElement:new({
		layout_settings = "HUDSettings.domination_minimap.bg",
		z = 0,
		blackboard = {}
	})

	local score_bar_friendly_config = {
		z = 20,
		reverse_bar = true,
		layout_settings = HUDSettings.domination_minimap.score_bar_friendly,
		blackboard = {}
	}
	local score_bar_enemy_config = {
		z = 20,
		reverse_bar = false,
		layout_settings = HUDSettings.domination_minimap.score_bar_enemy,
		blackboard = {}
	}

	self._score_bar_friendly = HUDChunkyBarElement:new(score_bar_friendly_config)
	self._score_bar_enemy = HUDChunkyBarElement:new(score_bar_enemy_config)

	local score_ticker_bg_friendly_config = {
		z = 10,
		layout_settings = HUDSettings.domination_minimap.score_ticker_bg_friendly,
		blackboard = {}
	}
	local score_ticker_bg_enemy_config = {
		z = 10,
		layout_settings = HUDSettings.domination_minimap.score_ticker_bg_enemy,
		blackboard = {}
	}

	self._score_ticker_bg_friendly = HUDAtlasTextureElement:new(score_ticker_bg_friendly_config)
	self._score_ticker_bg_enemy = HUDAtlasTextureElement:new(score_ticker_bg_enemy_config)

	local score_ticker_friendly_config = {
		z = 25,
		layout_settings = HUDSettings.domination_minimap.score_ticker_friendly,
		blackboard = {}
	}
	local score_ticker_enemy_config = {
		z = 25,
		layout_settings = HUDSettings.domination_minimap.score_ticker_enemy,
		blackboard = {}
	}

	self._score_ticker_friendly = HUDTextElement:new(score_ticker_friendly_config)
	self._score_ticker_enemy = HUDTextElement:new(score_ticker_enemy_config)
	self._objective_time = {}
	self._owned_objective_friendly = HUDAtlasTextureElement:new({
		layout_settings = "HUDSettings.domination_minimap.owned_objective_friendly",
		z = 4
	})
	self._owned_objective_enemy = HUDAtlasTextureElement:new({
		layout_settings = "HUDSettings.domination_minimap.owned_objective_enemy",
		z = 4
	})
	self._owned_objectives_size_friendly = nil
	self._owned_objectives_size_enemy = nil
	self._owned_objectives_size_neutral = nil
	self._owned_objective_layouts = {
		red = "HUDSettings.domination_minimap.objective_icon_viking",
		white = "HUDSettings.domination_minimap.objective_icon_saxon"
	}

	local owned_objective_indicators_friendly_config = {
		layout_settings = "HUDSettings.domination_minimap.owned_objectives_indicator_left",
		z = 20
	}
	local owned_objective_indicators_neutral_config = {
		layout_settings = "HUDSettings.domination_minimap.owned_objectives_indicator_middle",
		z = 20
	}
	local owned_objective_indicators_enemy_config = {
		layout_settings = "HUDSettings.domination_minimap.owned_objectives_indicator_right",
		z = 20
	}

	self._owned_objectives_indicators_friendly = HUDCollectionContainerElement:new(owned_objective_indicators_friendly_config)
	self._owned_objectives_indicators_neutral = HUDCollectionContainerElement:new(owned_objective_indicators_neutral_config)
	self._owned_objectives_indicators_enemy = HUDCollectionContainerElement:new(owned_objective_indicators_enemy_config)
	self._domination_text_lower = HUDAnimatedTextElement:new({
		layout_settings = "HUDSettings.domination_minimap.domination_text_lower",
		z = 20,
		drop_shadow = {
			color = ColorBox(120, 0, 0, 0),
			offset = Vector3Box(1, -1, 0)
		},
		blackboard = {
			text = "",
			original_text_enemy = L("hud_enemy_domination_countdown_text_lower"),
			original_text_friendly = L("hud_friendly_domination_countdown_text_lower")
		}
	})
	self._domination_text_upper = HUDAnimatedTextElement:new({
		layout_settings = "HUDSettings.domination_minimap.domination_text_upper",
		z = 20,
		drop_shadow = {
			color = ColorBox(120, 0, 0, 0),
			offset = Vector3Box(1, -1, 0)
		},
		blackboard = {
			text = "",
			original_text_enemy = L("hud_enemy_domination_countdown_text_upper"),
			original_text_friendly = L("hud_friendly_domination_countdown_text_upper")
		}
	})
	self.config = {
		layout_settings = HUDSettings.domination_minimap.container
	}

	local event_manager = Managers.state.event

	event_manager:register(self, "domination_minimap_enabled", "event_domination_minimap_enabled")
end

function HUDDominationMinimap:destroy()
	Managers.state.event:unregister("domination_minimap_enabled", self)
end

function HUDDominationMinimap:event_domination_minimap_enabled()
	self._minimap_enabled = true
end

function HUDDominationMinimap:width()
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)

	return layout_settings.width
end

function HUDDominationMinimap:height()
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)

	return layout_settings.height
end

function HUDDominationMinimap:level_settings()
	local level_settings = LevelHelper:current_level_settings()

	return level_settings.minimap
end

local function table_to_2d(vector3)
	return Vector3(vector3[1], vector3[2], 0)
end

local function vector_to_2d(vector3)
	return Vector3(vector3.x, vector3.y, 0)
end

function HUDDominationMinimap:anchor()
	local minimap_settings = self:level_settings()

	return table_to_2d(minimap_settings.anchor)
end

function HUDDominationMinimap:scale()
	return self:level_settings().scale * HUDHelper:layout_settings(self.config.layout_settings).pivot_scale
end

function HUDDominationMinimap:element_position()
	local layout_settings = HUDHelper:layout_settings(HUDSettings.domination_minimap.container)
	local screen_x, screen_y = HUDHelper:element_position(nil, self, layout_settings)

	return Vector3(screen_x, screen_y, 0)
end

function HUDDominationMinimap:calculate_position(world_position)
	local minimap_settings = self:level_settings()
	local rotation = Quaternion(Vector3.up(), minimap_settings.rotation)
	local anchor = table_to_2d(minimap_settings.anchor)
	local position = anchor - world_position

	position = position * self:scale()
	position = Quaternion.rotate(rotation, position)

	return position
end

function HUDDominationMinimap:post_update(dt, t, local_player)
	if self._minimap_enabled and self:level_settings() and local_player then
		self:_update_domination(dt, t, local_player)
		self:render_score_dependent(dt, t, local_player)
		self:render_objectives(dt, t, local_player)
		self:render_players(dt, t, local_player)
		self:render_objective_indicators(dt, t, local_player)
		self:render_spawn_points(dt, t)
		self:render_bg(dt, t)
	end
end

function HUDDominationMinimap:_create_pulse_data(end_time, color_main, color_highlight)
	local pulse_data = {
		pulse_function = function(t)
			local clamped_t = math.clamp(t, 0.1, 0.7)

			t = math.auto_lerp(0.1, 0.7, 0, 1, clamped_t)

			return math.sin(t * math.pi * 0.5)
		end,
		min_max_scale_function = function(bar_progress)
			local t = Managers.time:time("round") or 0
			local duration = GameModeSettings.domination.domination_timer
			local pulse_t = math.clamp(1 - (end_time - t) / duration, 0, 1)

			return pulse_t
		end,
		min = {
			frequency = 5,
			color_multiplier_min = 1,
			color_multiplier_max = 1,
			color = color_highlight
		},
		max = {
			frequency = 10,
			color_multiplier_min = 1,
			color_multiplier_max = 1,
			color = color_main
		}
	}

	return pulse_data
end

function HUDDominationMinimap:_update_domination(dt, t, local_player)
	local gui = self._gui
	local side
	local team_manager = Managers.state.team
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if not game then
		return
	end

	for _, side in pairs(team_manager:sides()) do
		local team = team_manager:team_by_side(side)

		if team.game_object_id then
			local friendly = local_player.team == team
			local bar = not friendly and self._score_bar_friendly or self._score_bar_enemy
			local pulsing = bar:has_pulse()
			local dominating = GameSession.game_object_field(game, team.game_object_id, "dominating")
			local domination_round_time = dominating and GameSession.game_object_field(game, team.game_object_id, "domination_time")

			if not pulsing and dominating then
				local color_main = friendly and HUDSettings.player_colors.enemy or HUDSettings.player_colors.team_member
				local color_highlight = friendly and HUDSettings.player_colors.enemy_highlighted or HUDSettings.player_colors.team_member_highlighted
				local pulse_data = self:_create_pulse_data(domination_round_time, color_main, color_highlight)

				bar:start_pulse(pulse_data)
			elseif pulsing and not dominating then
				self._time_left_tick = nil

				bar:stop_pulse()
			end

			if dominating then
				local text_element = self._domination_text_lower

				self:_render_domination_text_element(dt, t, gui, text_element, friendly, domination_round_time)

				local text_element = self._domination_text_upper

				self:_render_domination_text_element(dt, t, gui, text_element, friendly, domination_round_time)
			end
		end
	end
end

function HUDDominationMinimap:_render_domination_text_element(dt, t, gui, text_element, friendly, domination_round_time)
	local original_text
	local config = text_element.config
	local blackboard = config.blackboard

	original_text = friendly and blackboard.original_text_friendly or blackboard.original_text_enemy

	local time_left = math.max(math.floor(domination_round_time - Managers.time:time("round")), 0)

	if self._time_left_tick ~= time_left then
		self._time_left_tick = time_left

		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, "hud_domination_countdown")
	end

	blackboard.text = string.format(original_text, time_left)

	local layout_settings = HUDHelper:layout_settings(config.layout_settings)

	text_element:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, text_element, layout_settings)

	text_element:update_position(dt, t, layout_settings, x, y, 0)
	text_element:render(dt, t, gui, layout_settings)
end

function HUDDominationMinimap:determine_player_icon(local_player, player)
	local unit = player.player_unit

	if not unit then
		return nil
	end

	if local_player == player and ScriptUnit.has_extension(unit, "locomotion_system") then
		local icon = self._icons.player_icon_player
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")
		local aim_direction = locomotion.aim_rotation:unbox()
		local vector3, angle = Quaternion.decompose(aim_direction)

		icon:update_rotation_radians(0 - angle - self:level_settings().rotation - math.pi)

		return icon
	end

	if local_player.team == player.team then
		if local_player.squad_index and local_player.squad_index == player.squad_index then
			return self._icons.player_icon_squad
		else
			return self._icons.player_icon_friendly
		end
	end

	return nil
end

function HUDDominationMinimap:render_bg(dt, t)
	local gui = self._gui

	self._bg.config.blackboard.scale = HUDHelper:layout_settings(self.config.layout_settings).pivot_scale

	local layout_settings = HUDHelper:layout_settings(self._bg.config.layout_settings)

	self._bg:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self._bg, layout_settings)

	self._bg:update_position(dt, t, layout_settings, x, y, 0)
	self._bg:render(dt, t, gui, layout_settings)
end

function HUDDominationMinimap:render_players(dt, t, local_player)
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)
	local screen_position = self:element_position()

	for _, player in pairs(Managers.player:players()) do
		local icon = self:determine_player_icon(local_player, player)

		if icon then
			local unit = player.player_unit
			local world_position = vector_to_2d(Unit.world_position(unit, 0))

			self:render_icon(dt, t, icon, world_position, screen_position)
		end
	end
end

function HUDDominationMinimap:render_spawn_points(dt, t)
	local icon_white = self._icons.spawn_point_icon_white
	local icon_white_pos = icon_white.config.level_position:unbox()
	local icon_white_screen_pos = vector_to_2d(icon_white_pos)
	local icon_red = self._icons.spawn_point_icon_red
	local icon_red_pos = icon_red.config.level_position:unbox()
	local icon_red_screen_pos = vector_to_2d(icon_red_pos)
	local screen_position = self:element_position()

	self:render_icon(dt, t, icon_white, icon_white_screen_pos, screen_position)
	self:render_icon(dt, t, icon_red, icon_red_screen_pos, screen_position)
end

function HUDDominationMinimap:render_objectives(dt, t, local_player)
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)
	local screen_position = self:element_position()

	for _, unit in pairs(Managers.state.game_mode:objective_units()) do
		local world_position = vector_to_2d(Unit.world_position(unit, 0))
		local objective = ScriptUnit.extension(unit, "objective_system")
		local player_owned = objective:owned(local_player.team.side)
		local neutral_owned = objective:owned("neutral")
		local bg_icon = player_owned and self._icons.objective_icon_friendly or neutral_owned and self._icons.objective_icon_neutral or self._icons.objective_icon_enemy
		local game = Managers.state.network:game()
		local object_point_id = Managers.state.network:game_object_id(unit)

		bg_icon.config.blackboard.pulse = GameSession.game_object_field(game, object_point_id, "being_captured")
		bg_icon.config.blackboard.unit = unit

		self:render_icon(dt, t, bg_icon, world_position, screen_position)

		if bg_icon.config.blackboard.pulse then
			local capturing_team = NetworkLookup.team[GameSession.game_object_field(game, object_point_id, "capturing_team")]

			if capturing_team ~= local_player.team.side then
				local contested_icon = self._icons.objective_icon_contested

				self:render_icon(dt, t, contested_icon, world_position, screen_position)
			end
		end

		local team_name = player_owned and local_player.team.name or not player_owned and not neutral_owned and (local_player.team.name == "white" and "red" or "white") or nil
		local team_icon = team_name and self._icons["objective_icon_" .. team_name]

		if team_icon then
			self:render_icon(dt, t, team_icon, world_position, screen_position)
		end
	end
end

function HUDDominationMinimap:render_objective_indicators(dt, t, local_player)
	local gui = self._gui
	local friendly_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local friendly_team = Managers.state.team:team_by_name(friendly_team_name)
	local enemy_team = Managers.state.team:team_by_name(enemy_team_name)
	local friendly_owned = 0
	local enemy_owned = 0
	local neutraly_owned = 0

	for _, unit in pairs(Managers.state.game_mode:objective_units()) do
		local objective = ScriptUnit.extension(unit, "objective_system")
		local if_player_owned = objective:owned(local_player.team.side)
		local if_neutral_owned = objective:owned("neutral")

		if if_player_owned then
			friendly_owned = friendly_owned + 1
		elseif if_neutral_owned then
			neutraly_owned = neutraly_owned + 1
		else
			enemy_owned = enemy_owned + 1
		end
	end

	local friendly_element = self._owned_objectives_indicators_friendly
	local enemy_element = self._owned_objectives_indicators_enemy
	local neutral_element = self._owned_objectives_indicators_neutral
	local objective_layout_settings = self._owned_objective_layouts

	if self._owned_objectives_size_neutral ~= neutraly_owned then
		neutral_element:remove_all_elements()

		for i = 1, neutraly_owned do
			local hud = HUDAtlasTextureElement:new({
				layout_settings = "HUDSettings.domination_minimap.objective_icon_neutral",
				z = 1,
				z_override = true
			})

			neutral_element:insert_element(hud, nil)
		end
	end

	if self._owned_objectives_size_friendly ~= friendly_owned then
		friendly_element:remove_all_elements()

		for i = 1, friendly_owned do
			local hud = {
				HUDAtlasTextureElement:new({
					layout_settings = "HUDSettings.domination_minimap.objective_icon_friendly",
					z = 1,
					z_override = true
				}),
				is_table = true,
				HUDAtlasTextureElement:new({
					z = 4,
					z_override = true,
					layout_settings = objective_layout_settings[friendly_team_name]
				})
			}

			friendly_element:insert_element(hud, nil)
		end
	end

	if self._owned_objectives_size_enemy ~= enemy_owned then
		enemy_element:remove_all_elements()

		for i = 1, enemy_owned do
			local hud = {
				HUDAtlasTextureElement:new({
					layout_settings = "HUDSettings.domination_minimap.objective_icon_enemy",
					z = 1,
					z_override = true
				}),
				is_table = true,
				HUDAtlasTextureElement:new({
					z = 4,
					z_override = true,
					layout_settings = objective_layout_settings[enemy_team_name]
				})
			}

			enemy_element:insert_element(hud, nil)
		end
	end

	self._owned_objectives_size_friendly = friendly_owned
	self._owned_objectives_size_enemy = enemy_owned
	self._owned_objectives_size_neutral = neutraly_owned

	local layout_settings = HUDHelper:layout_settings(friendly_element.config.layout_settings)

	friendly_element:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, friendly_element, layout_settings)

	friendly_element:update_position(dt, t, layout_settings, x, y, 0)
	friendly_element:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(neutral_element.config.layout_settings)

	neutral_element:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, neutral_element, layout_settings)

	neutral_element:update_position(dt, t, layout_settings, x, y, 0)
	neutral_element:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(enemy_element.config.layout_settings)

	enemy_element:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, enemy_element, layout_settings)

	enemy_element:update_position(dt, t, layout_settings, x, y, 0)
	enemy_element:render(dt, t, gui, layout_settings)
end

function HUDDominationMinimap:render_score_dependent(dt, t, local_player)
	local friendly_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local friendly_team = Managers.state.team:team_by_name(friendly_team_name)
	local enemy_team = Managers.state.team:team_by_name(enemy_team_name)
	local friendly_score = friendly_team.score
	local enemy_score = enemy_team.score
	local game_mode = Managers.state.game_mode
	local total_score = GameModeSettings.domination.start_score

	self:render_bars(dt, t, local_player, friendly_score, enemy_score, total_score)
	self:render_tickers(dt, t, local_player, friendly_score, enemy_score, total_score)
end

function HUDDominationMinimap:render_bars(dt, t, local_player, friendly_score, enemy_score, total_score)
	local gui = self._gui
	local friendly_bar = self._score_bar_friendly
	local enemy_bar = self._score_bar_enemy

	friendly_bar.config.blackboard.texture_color = HUDSettings.player_colors.team_member
	enemy_bar.config.blackboard.texture_color = HUDSettings.player_colors.enemy

	friendly_bar:set_progress(friendly_score / total_score)
	enemy_bar:set_progress(enemy_score / total_score)

	local layout_settings = HUDHelper:layout_settings(friendly_bar.config.layout_settings)

	friendly_bar:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, friendly_bar, layout_settings)

	friendly_bar:update_position(dt, t, layout_settings, x, y, friendly_bar.config.z)
	friendly_bar:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(enemy_bar.config.layout_settings)

	enemy_bar:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, enemy_bar, layout_settings)

	enemy_bar:update_position(dt, t, layout_settings, x, y, enemy_bar.config.z)
	enemy_bar:render(dt, t, gui, layout_settings)
end

function HUDDominationMinimap:render_tickers(dt, t, local_player, friendly_score, enemy_score, total_score)
	local gui = self._gui
	local bg_ticker_friendly = self._score_ticker_bg_friendly
	local bg_ticker_enemy = self._score_ticker_bg_enemy
	local text_ticker_friendly = self._score_ticker_friendly
	local text_ticker_enemy = self._score_ticker_enemy

	text_ticker_friendly.config.text = tostring(friendly_score)
	text_ticker_enemy.config.text = tostring(enemy_score)

	local layout_settings = HUDHelper:layout_settings(bg_ticker_friendly.config.layout_settings)

	bg_ticker_friendly:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, bg_ticker_friendly, layout_settings)

	bg_ticker_friendly:update_position(dt, t, layout_settings, x, y, bg_ticker_friendly.config.z)
	bg_ticker_friendly:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(bg_ticker_enemy.config.layout_settings)

	bg_ticker_enemy:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, bg_ticker_enemy, layout_settings)

	bg_ticker_enemy:update_position(dt, t, layout_settings, x, y, bg_ticker_enemy.config.z)
	bg_ticker_enemy:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(text_ticker_friendly.config.layout_settings)

	text_ticker_friendly:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, text_ticker_friendly, layout_settings)

	text_ticker_friendly:update_position(dt, t, layout_settings, x, y, text_ticker_friendly.config.z)
	text_ticker_friendly:render(dt, t, gui, layout_settings)

	local layout_settings = HUDHelper:layout_settings(text_ticker_enemy.config.layout_settings)

	text_ticker_enemy:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, text_ticker_enemy, layout_settings)

	text_ticker_enemy:update_position(dt, t, layout_settings, x, y, text_ticker_enemy.config.z)
	text_ticker_enemy:render(dt, t, gui, layout_settings)
end

local function calculate_fade_percent(settings, world_position, scale)
	local length = Vector3.length(world_position)
	local inner = settings.fade.inner * scale
	local outer = settings.fade.outer * scale

	if length < inner then
		return 1
	elseif inner < length and length < outer then
		local subtracted_length = length - inner
		local percentage = subtracted_length / (outer - inner)

		return 1 - math.clamp(percentage, 0, 1)
	else
		return 0
	end
end

local function pulse(t, min, max, speed)
	local amp = (max - min) / 2
	local off = min + amp

	return amp * math.cos(t * speed) + off
end

function HUDDominationMinimap:render_icon(dt, t, icon, unit_position, screen_position, debug)
	local gui = self._gui
	local world_position = self:calculate_position(unit_position)
	local position = screen_position + world_position
	local config = icon.config
	local blackboard = config.blackboard
	local layout_settings = HUDHelper:layout_settings(config.layout_settings)
	local color = layout_settings.color or blackboard.color or {
		255,
		255,
		255,
		255
	}

	if config.distance_fade then
		color[1] = calculate_fade_percent(self:level_settings(), world_position, self:scale()) * 255
	else
		color[1] = layout_settings.color and layout_settings.color[1] or 255
	end

	if config.pulse and blackboard.unit then
		if blackboard.pulse then
			self._objective_time[blackboard.unit] = (self._objective_time[blackboard.unit] or 0) + dt
			color[1] = pulse(self._objective_time[blackboard.unit], 1, color[1], 5)
		else
			self._objective_time[blackboard.unit] = 0
		end
	end

	blackboard.color = color

	icon:update_size(dt, t, gui, layout_settings)
	icon:update_position(dt, t, layout_settings, position.x - icon:width() * 0.5, position.y - icon:height() * 0.5, config.z or 1)
	icon:render(dt, t, gui, layout_settings)
end
