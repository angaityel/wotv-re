-- chunkname: @scripts/game_state/state_ingame_running.lua

require("scripts/settings/controller_settings")
require("scripts/settings/mount_profiles")
require("scripts/settings/ai_profiles")
require("scripts/settings/player_profiles")
require("scripts/settings/robot_profiles")
require("scripts/settings/sp_profiles")
require("scripts/settings/heads")
require("scripts/settings/helmets")
require("scripts/settings/armours")
require("scripts/settings/hud_settings")
require("scripts/settings/material_effect_mappings")
require("scripts/settings/player_data")
require("scripts/helpers/level_helper")
require("scripts/helpers/achievement/achievement_helper")
require("scripts/menu/menus/ingame_menu")
require("scripts/menu/menus/scoreboard")
require("scripts/menu/menus/final_scoreboard_menu")
require("scripts/menu/menus/profile_viewer_menu")
require("scripts/managers/outline/outline_manager")
require("scripts/managers/battle_chatter/battle_chatter_collector")
require("scripts/managers/battle_chatter/battle_chatter_handler")

StateInGameRunning = class(StateInGameRunning)

local BUTTON_THRESHOLD = 0.5
local CHAT_INPUT_DEFAULT_COMMAND = "say"
local MAX_CHAT_INPUT_CHARS = 150

function StateInGameRunning:on_enter(params)
	self.world = self.parent.world
	self.params = params
	self.viewport_name = self.params.viewport_name
	self._default_camera_position = Vector3Box(0, 0, 0)
	self._default_camera_rotation = QuaternionBox(Quaternion.identity())
	self.player_index = self.params.player

	local player = Managers.player:player(self.player_index)

	self.player = player

	self:_setup_viewport()
	self:_setup_input()
	self:_setup_camera()
	self:_setup_menus()

	self._input_source_look = nil
	self._displayed_profile_selection = true
	self._display_profile_selection_timer = 0
	self._gained_xp_and_coins = {}
	self._awarded_prizes = {}
	self._awarded_medals = {}
	self._awarded_ranks = {}

	if GameSettingsDevelopment.enable_robot_player then
		local profile = GameSettingsDevelopment.robot_player_profile

		self.player.state_data.spawn_profile = profile == "random" and Math.random(1, #RobotProfiles) or profile
	elseif Managers.lobby.lobby then
		player.state_data.spawn_profile = nil
	else
		player.state_data.spawn_profile = 2
	end

	self:_init_hud_manager()
	Managers.state.blood:add_player(self.player)

	local event_manager = Managers.state.event

	event_manager:register(self, "ghost_mode_deactivated", "event_ghost_mode_deactivated")
	event_manager:register(self, "player_killed", "event_player_killed")
	event_manager:register(self, "game_started", "event_game_started")
	event_manager:register(self, "close_ingame_menu", "event_close_ingame_menu")
	event_manager:register(self, "force_close_ingame_menu", "event_force_close_ingame_menu")
	event_manager:register(self, "spawn_target_denied", "event_spawn_target_denied")
	event_manager:register(self, "gm_event_end_conditions_met", "gm_event_end_conditions_met")
	event_manager:register(self, "set_default_camera_pose", "event_set_default_camera_pose")
	event_manager:register(self, "event_level_ended", "event_level_ended")
	event_manager:register(self, "event_sp_level_ended", "event_level_ended")
	event_manager:register(self, "join_team_confirmed", "event_join_team_confirmed")
	event_manager:register(self, "location_print_requested", "event_location_print_requested")
	event_manager:register(self, "gained_xp_and_coins", "event_gained_xp_and_coins")
	event_manager:register(self, "awarded_prize", "event_awarded_prize")
	event_manager:register(self, "awarded_medal", "event_awarded_medal")
	event_manager:register(self, "player_killed_by_enemy", "event_player_killed_by_enemy")
	event_manager:register(self, "player_damaged", "event_player_damaged")
	event_manager:register(self, "client_player_damaged", "event_player_damaged")
	event_manager:register(self, "set_environment", "event_set_environment")
	event_manager:register(self, "level_change", "event_level_change")

	self._chat_input_blackboard = {
		text = ""
	}
	self._light_chat_shutdown = false

	Managers.state.event:trigger("event_chat_initiated", self._chat_input_blackboard)

	self._game_mode_events = GameModeEvents:new(self.world, player)

	if Managers.lobby.server or not Managers.lobby.lobby then
		Managers.state.event:trigger("game_started")
	end

	self._big_picture_input_handler = BigPictureInputHandler:new()
	self._gui = World.create_screen_gui(self._menu_world, "material", MenuSettings.font_group_materials.arial, "immediate")
	self._environment_state = "default"
	self._observer_camera_controller = ObserverCameraController:new(player)
	self._team_confirmed = false
	Managers.state.outline = OutlineManager:new(self.player)

	local game_mode_key = Managers.state.game_mode:game_mode_key()

	self.parent.parent.loading_context.last_level_id = Managers.state.game_mode:level_key()
	self.parent.parent.loading_context.last_level_game_mode = game_mode_key

	if GameSettingsDevelopment.enable_battle_chatter and game_mode_key ~= "sp" then
		self._battle_chatter_handler = BattleChatterHandler:new(self.world)
		self._battle_chatter_collector = BattleChatterCollector:new(self.world, self._battle_chatter_handler, self.player)
	end

	if GameModeSettings[game_mode_key].dom_minimap then
		Managers.state.event:trigger("domination_minimap_enabled")
	end
end

function StateInGameRunning:_init_hud_manager()
	local hud_data = {
		world_icons = {
			class = "HUDWorldIcons"
		},
		pose_charge = {
			class = "HUDPoseCharge"
		},
		parry_helper = {
			class = "HUDParryHelper"
		},
		buffs = {
			class = "HUDBuffs"
		},
		debuffs = {
			class = "HUDDebuffs"
		},
		spawn = {
			class = "HUDSpawn"
		},
		deserting = {
			class = "HUDDeserting"
		},
		hit_marker = {
			class = "HUDHitMarker"
		},
		fade_to_black = {
			class = "HUDFadeToBlack"
		},
		game_mode_status = {
			class = "HUDGameModeStatus"
		},
		combat_log = {
			class = "HUDCombatLog"
		},
		announcements = {
			class = "HUDAnnouncements"
		},
		sp_tutorial = {
			class = "HUDSPTutorial"
		},
		combat_text = {
			class = "HUDCombatText"
		},
		xp_coins = {
			class = "HUDXPCoins"
		},
		interaction = {
			class = "HUDInteraction"
		},
		ammo = {
			class = "HUDAmmoCounter"
		},
		chat_window = {
			class = "ChatOutputWindow",
			data = {
				input_text_layout_settings = "HUDSettings.chat.input_text",
				output_window_layout_settings = "HUDSettings.chat.new_output_window",
				register_events = true
			}
		},
		conquest_debug = {
			class = "HUDDebugConquestScore"
		},
		mockup = {
			class = "HUDMockup",
			data = {
				menu_world = self._menu_world
			}
		},
		player_status = {
			class = "HUDPlayerStatus"
		},
		domination_minimap = {
			class = "HUDDominationMinimap"
		}
	}

	Managers.state.hud:add_player(self.player, hud_data)
end

ObserverCameraController = class(ObserverCameraController)

function ObserverCameraController:init(player)
	self._player = player
	self._target_player_id = nil
	self._mode = "limited"
end

local BUTTON_THRESHOLD = 0.5

function ObserverCameraController:_pick_observer_target(dt, t, last_id, own_player, input)
	local player_manager = Managers.player
	local last_player = player_manager:player_exists(last_id) and player_manager:player(last_id)
	local targets = self:_get_targets()
	local move_left = input:get("select_left_click")
	local move_right = input:get("select_right_click")
	local player, unit

	if not last_player then
		player, unit = self:_first_target(targets, own_player)
	elseif move_right then
		player, unit = self:_next_target(targets, last_player, own_player)
	elseif move_left or not self:_check_target(last_player.player_unit) then
		player, unit = self:_last_target(targets, last_player, own_player)
	else
		player = last_player
		unit = last_player.player_unit
	end

	return player and player:player_id() or nil, unit
end

function ObserverCameraController:_first_target(targets, own_player)
	for _, player in pairs(targets) do
		if player ~= own_player and self:_check_target(player.player_unit) then
			return player, player.player_unit
		end
	end
end

function ObserverCameraController:_check_target(unit)
	return Unit.alive(unit) and ScriptUnit.has_extension(unit, "locomotion_system") and not ScriptUnit.extension(unit, "locomotion_system").ghost_mode
end

function ObserverCameraController:_next_target(targets, current, own_player)
	local found_current, target

	for _, player in pairs(targets) do
		if player ~= own_player then
			local unit = player.player_unit

			if player == current then
				found_current = true

				if self:_check_target(unit) then
					target = target or player
				end
			elseif found_current and self:_check_target(unit) then
				return player, unit
			elseif self:_check_target(unit) then
				target = target or player
			end
		end
	end

	return target, target and target.player_unit
end

function ObserverCameraController:_last_target(targets, current, own_player)
	local found_current, target

	for _, player in pairs(targets) do
		if player ~= own_player then
			local unit = player.player_unit

			if player == current and target then
				return target, unit
			elseif self:_check_target(unit) then
				target = player
			end
		end
	end

	return target, target and target.player_unit
end

function ObserverCameraController:_get_targets()
	local team = self._player.team

	if team and (not Managers.state.game_mode:team_locked_observer_cam(team) or team.name == "unassigned") then
		return Managers.player:players()
	elseif team then
		return team:get_members()
	else
		return {}
	end
end

function ObserverCameraController:update(dt, t, player, viewport_name, camera_manager, input)
	local tree_name = "player"
	local node_name = "squad_spawn_camera"
	local current_cam_unit = camera_manager:current_node_tree_root_unit(viewport_name)
	local owning_player_id, target = self:_pick_observer_target(dt, t, self._target_player_id, player, input)

	if target then
		player.camera_follow_unit = target
		self._target_player_id = owning_player_id

		if ScriptUnit.extension(target, "damage_system"):is_dead() then
			camera_manager:set_frozen(true)
		else
			camera_manager:set_frozen(false)
		end

		if target ~= current_cam_unit then
			local preserve_aim_yaw = current_cam_unit ~= nil

			camera_manager:set_node_tree_root_unit(viewport_name, tree_name, target, nil, preserve_aim_yaw)
			camera_manager:set_camera_node(viewport_name, tree_name, node_name)
		elseif node_name ~= camera_manager:current_camera_node(viewport_name) then
			camera_manager:set_camera_node(viewport_name, tree_name, node_name)
		end

		return true
	else
		player.camera_follow_unit = nil
		self._target_player_id = nil

		return false
	end
end

function ObserverCameraController:destroy()
	return
end

function StateInGameRunning:gm_event_end_conditions_met(winning_team_name, red_team_score, white_team_score, end_of_round_only)
	self:_set_all_menus_active(false)
	self._final_scoreboard_menu:set_active(true)
	self._final_scoreboard_menu:goto("final_scoreboard")

	self.parent.parent.loading_context.winning_team_name = winning_team_name
	self.parent.parent.loading_context.red_team_score = red_team_score
	self.parent.parent.loading_context.white_team_score = white_team_score

	local you_win = winning_team_name == (self.player.team and self.player.team.name)

	self:_set_battle_report_data(you_win)
	Managers.state.game_mode:stop_game_mode_music()
	LevelHelper:flow_event(self.world, "gm_event_end_conditions_met")

	if you_win then
		Managers.music:trigger_event("Play_win_match")
	else
		Managers.music:trigger_event("Play_lose_match")
	end
end

function StateInGameRunning:event_level_change()
	Profiler.start("stop_game_mode_music")
	Managers.state.game_mode:stop_game_mode_music()
	Profiler.stop()
	Profiler.start("setup end of level data")
	self:_setup_generic_eol_data()
	Profiler.stop()
end

function StateInGameRunning:event_gained_xp_and_coins(reason, xp, coins)
	if not self._gained_xp_and_coins[reason] then
		self._gained_xp_and_coins[reason] = {
			count = 1,
			xp = xp,
			coins = coins
		}
	else
		local gained = self._gained_xp_and_coins[reason]

		gained.count = gained.count + 1
		gained.xp = gained.xp + xp
		gained.coins = gained.coins + coins
	end
end

function StateInGameRunning:event_awarded_prize(name)
	if not self._awarded_prizes[name] then
		self._awarded_prizes[name] = 1
	else
		self._awarded_prizes[name] = self._awarded_prizes[name] + 1
	end
end

function StateInGameRunning:event_awarded_medal(name)
	if not self._awarded_medals[name] then
		self._awarded_medals[name] = 1
	else
		self._awarded_medals[name] = self._awarded_medals[name] + 1
	end
end

function StateInGameRunning:event_awarded_rank(rank)
	self._awarded_ranks[#self._awarded_ranks + 1] = rank
end

function StateInGameRunning:_set_battle_report_data(local_player_won)
	local players = {}

	for player_index, player in pairs(Managers.player:players()) do
		players[player_index] = {
			player_index = player.index,
			network_id = player:network_id(),
			player_name = player:name(),
			team_name = player.team.name,
			squad_index = player.squad_index,
			squad_name = player.squad_index and player.team.squads[player.squad_index]:name()
		}
	end

	local loading_context = self.parent.parent.loading_context

	loading_context.players = players
	loading_context.local_player_index = self.player.index
	loading_context.local_player_won = local_player_won
	loading_context.local_player_team = self.player.team.name
	loading_context.stats_collection = table.clone_instance(Managers.state.stats_collection)
	loading_context.gained_xp_and_coins = self._gained_xp_and_coins
	loading_context.awarded_prizes = self._awarded_prizes
	loading_context.awarded_medals = self._awarded_medals
	loading_context.awarded_ranks = self._awarded_ranks
	loading_context.chat_text_data = Managers.state.hud:get_hud(self.player, "chat_window"):text_data()
end

function StateInGameRunning:_set_all_menus_active(active)
	self._ingame_menu:set_active(active)
	self._scoreboard:set_active(active)
	self._final_scoreboard_menu:set_active(active)
end

function StateInGameRunning:_setup_viewport()
	Managers.state.camera:create_viewport(self.viewport_name, Vector3.zero(), Quaternion.identity())
end

function StateInGameRunning:_setup_input()
	Window.set_show_cursor(false)
end

function StateInGameRunning:event_location_print_requested()
	local viewport_name = self.viewport_name
	local camera_pos = Managers.state.camera:camera_position(viewport_name)
	local camera_rot = Managers.state.camera:camera_rotation(viewport_name)

	Managers.state.hud:output_console_text("Camera position: " .. camera_pos .. "  Camera rotation: " .. camera_rot)
end

function StateInGameRunning:_setup_camera()
	local viewport_name = self.viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local camera_manager = Managers.state.camera

	camera_manager:load_node_tree(viewport_name, "default", "world")
	camera_manager:load_node_tree(viewport_name, "player", "player")
	camera_manager:load_node_tree(viewport_name, "player_dead", "player_dead")
	camera_manager:load_node_tree(viewport_name, "cutscene", "cutscene")
	self:_set_default_camera(camera_manager, viewport_name)

	local zoom = Application.user_setting("zoom") or 0

	zoom = math.clamp(zoom, 0, 1)
	self._zoom_target = zoom
	self._zoom_scale = 1
	self._zoom = zoom

	local pad_active = Managers.input:pad_active(1)

	if pad_active then
		self._zoom_target = 1
	end
end

function StateInGameRunning:_setup_menus()
	local shading_environment = GameSettingsDevelopment.default_environment
	local shading_callback
	local world_layer = 3

	self._menu_world = Managers.world:create_world("menu_world", shading_environment, shading_callback, world_layer, Application.DISABLE_PHYSICS)

	ScriptWorld.create_viewport(self._menu_world, "menu_viewport", "overlay", world_layer)

	local menu_data = {
		viewport_name = "menu_viewport",
		local_player = self.player,
		gui_init_parameters = {
			"material",
			"materials/menu/loading_atlas",
			"material",
			"materials/menu/menu",
			"material",
			"materials/hud/hud",
			"material",
			"materials/menu/outfit_previews",
			"material",
			"materials/menu/cloak_previews",
			"material",
			MenuSettings.font_group_materials.font_gradient_100,
			"material",
			MenuSettings.font_group_materials.arial,
			"material",
			MenuSettings.font_group_materials.hell_shark,
			"material",
			"materials/hud/buttons",
			"immediate"
		}
	}

	self._ingame_menu = IngameMenu:new(self, self._menu_world, menu_data)
	self._scoreboard = Scoreboard:new(self, self._menu_world, menu_data)
	self._final_scoreboard_menu = FinalScoreboardMenu:new(self, self._menu_world, menu_data)
	self._profile_viewer_menu = ProfileViewerMenu:new(self, self._menu_world, menu_data)
end

function StateInGameRunning:event_set_default_camera_pose(position, rotation)
	self._default_camera_position:store(position)
	self._default_camera_rotation:store(rotation)
end

function StateInGameRunning:_set_default_camera(camera_manager, viewport_name)
	camera_manager:set_node_tree_root_position(viewport_name, "default", self._default_camera_position:unbox())
	camera_manager:set_node_tree_root_rotation(viewport_name, "default", self._default_camera_rotation:unbox())
	camera_manager:set_camera_node(viewport_name, "default", "default")
end

function StateInGameRunning:update(dt, t)
	Profiler.start("StateInGameRunning:update( dt, t )")
	Profiler.start("update director mode")
	self:_update_director_mode(dt, t)
	Profiler.stop()

	local player = self.player
	local input = player.input_source

	Profiler.start("update input")
	self:_update_input(dt, t, input)
	Profiler.stop()

	local free_flight_active = Managers.free_flight:active(self.player_index) or Managers.free_flight:active("global")
	local free_flight_mode = Managers.free_flight:mode(self.player_index) == "player_mechanics"
	local cutscene_active = Managers.state.entity:system("cutscene_system"):active()

	self._disable_input = self._ingame_menu:active() or self._final_scoreboard_menu:active() or self._chat_input_active or free_flight_active and not free_flight_mode or cutscene_active or self._overlay_active

	if not self._disable_input and (Managers.input:active_mapping(input.slot) ~= "pad360" or not self._scoreboard:active()) then
		Profiler.start("update locomotion input")
		self:_update_locomotion_input(dt)
		Profiler.stop()
	end

	Profiler.start("update player in spawn manager")
	Managers.state.spawn:update_player(player, dt, t, not self._disable_input and player.input_source or nil)
	Profiler.stop()
	Profiler.start("update profile selection")
	self:_update_profile_selection(dt, t)
	Profiler.stop()
	Profiler.start("update environment")
	self:_update_environment(dt, t)
	Profiler.stop()
	Profiler.start("update camera")
	self:_update_camera(dt, t, input)
	Profiler.stop()
	Profiler.start("update ingame menu")
	self._ingame_menu:update(dt, t)
	Profiler.stop()
	Profiler.start("update scoreboard")
	self._scoreboard:update(dt, t)
	Profiler.stop()
	Profiler.start("update final scoreboard")
	self._final_scoreboard_menu:update(dt, t)
	Profiler.stop()
	Profiler.start("update profile viewer")
	self._profile_viewer_menu:update(dt, t)
	Profiler.stop()
	Profiler.start("update debug text")
	Managers.state.debug_text:update(dt, self.viewport_name)
	Profiler.stop()
	Profiler.start("render version info")

	if GameSettingsDevelopment.show_version_info then
		HUDHelper:render_version_info(self._gui)
	end

	Profiler.stop()
	Profiler.start("render fps")

	if GameSettingsDevelopment.show_fps then
		HUDHelper:render_fps(self._gui, dt)
	end

	Profiler.stop()
	Profiler.start("debug lag stuff")

	if Application.build() ~= "release" and Keyboard.pressed(Keyboard.button_index("numpad +")) and Managers.lobby.lobby then
		Network.write_dump_tag("LAG!")

		local network_manager = Managers.state.network

		if network_manager:game() and not Managers.lobby.server then
			network_manager:send_rpc_server("rpc_write_network_dump_tag", NetworkLookup.network_dump_tags["LAG!"])
		end

		Managers.state.hud:output_console_text("Lag description 'LAG!' written to network dump.")
	end

	Profiler.stop()
	Profiler.start("out of spawns check")

	local out_of_spawns = player.team and Managers.state.game_mode:allowed_spawns(player.team) <= player.spawn_data.spawns

	if self._ingame_menu:active() and self._ingame_menu:current_page_type() == "pre_spawn_select_spawnpoint" and out_of_spawns then
		self._force_close_ingame_menu = true
	end

	Profiler.stop()
	Profiler.start("big picture")

	if self._delayed_controller_overlay_deactivate then
		self._overlay_active = self._big_picture_input_handler:is_deactivating()

		if not self._overlay_active then
			self._delayed_controller_overlay_deactivate = nil
		end
	end

	if self._overlay_active then
		local text, done, submitted = self._big_picture_input_handler:poll_text_input_done()

		if done then
			if submitted then
				self:_execute_controller_chat_input(text)
			end

			self._delayed_controller_overlay_deactivate = true
		end
	end

	Profiler.stop()
	Profiler.start("force close menu")

	if self._force_close_ingame_menu then
		self._force_close_ingame_menu = false

		self._ingame_menu:set_active(false)
	end

	Profiler.stop()

	if self._delayed_chat_input_deactivate then
		self._chat_input_active = false
		self._delayed_chat_input_deactivate = nil
	end

	Managers.state.outline:update(dt, t)

	if self._battle_chatter_handler then
		Profiler.start("update battle chatter")
		self._battle_chatter_handler:update(dt, t)
		Profiler.stop()
	end

	Profiler.stop()
end

function StateInGameRunning:_update_profile_selection(dt, t)
	local player = self.player
	local spawn_state = player.spawn_data.state
	local player_unit = player.player_unit
	local locomotion_ext = player_unit and ScriptUnit.has_extension(player_unit, "locomotion_system") and ScriptUnit.extension(player_unit, "locomotion_system")

	if (not (spawn_state ~= "dead" and spawn_state ~= "not_spawned") and t >= self._display_profile_selection_timer or locomotion_ext and locomotion_ext.yielded) and not self._final_scoreboard_menu:active() and Managers.state.game_mode:squad_screen_spawning() and Managers.state.game_mode:allowed_spawns(player.team) > player.spawn_data.spawns and player.team.name ~= "unassigned" and not self._displayed_profile_selection then
		self._scoreboard:set_active(false)
		self._ingame_menu:set_active(true)

		player.camera_follow_unit = nil

		self._ingame_menu:goto("select_profile")

		self._displayed_profile_selection = true
	elseif spawn_state ~= "dead" and spawn_state ~= "not_spawned" then
		self._displayed_profile_selection = false
	end
end

function StateInGameRunning:event_player_damaged(player, _, damage)
	if player == self.player then
		local damage = (self._damage or 0) + damage

		if damage > PlayerUnitDamageSettings.DAMAGE_VIGNETTE_THRESHOLD then
			self._damage_pulse = Managers.time:time("game")
			self._damage = 0
		else
			self._damage = damage
		end
	end
end

function StateInGameRunning:event_set_environment(environment_name, time)
	Managers.state.camera:change_environment(environment_name, time)
end

function StateInGameRunning:_update_environment(dt, t)
	local player = self.player
	local player_unit = Unit.alive(player.player_unit) and player.player_unit
	local damage_ext = player_unit and ScriptUnit.has_extension(player_unit, "damage_system") and ScriptUnit.extension(player_unit, "damage_system")
	local locomotion_ext = player_unit and ScriptUnit.has_extension(player_unit, "locomotion_system") and ScriptUnit.extension(player_unit, "locomotion_system")
	local damage_pulse = self._damage_pulse

	if damage_pulse then
		local damage_time = t - damage_pulse
		local blend_out = PlayerUnitDamageSettings.DAMAGE_VIGNETTE_BLEND_OUT

		if blend_out < damage_time then
			self._damage_pulse = nil

			Managers.state.camera:set_vignette()
		else
			local vignette_t = math.cos(math.pi * (damage_time / blend_out))

			Managers.state.camera:set_vignette(Vector3(0.94, 10, 1), Vector3(0.4745, 0.003, 0.003), vignette_t)
		end
	else
		Managers.state.camera:set_vignette()
	end

	local new_state

	if not player_unit then
		new_state = "default"
	elseif locomotion_ext and locomotion_ext.being_executed then
		new_state = "executed"
	elseif damage_ext and (damage_ext:is_knocked_down() or damage_ext:is_dead()) then
		Managers.state.camera:set_vignette()

		new_state = "knocked_down"
	else
		new_state = damage_ext and damage_ext:is_last_stand_active() and "last_stand" or locomotion_ext and locomotion_ext.deserting and "deserting" or locomotion_ext and locomotion_ext._ghost_mode_blend_timer and "ghost_mode_blend" or locomotion_ext and locomotion_ext.ghost_mode and "ghost_mode" or "default"
	end

	local level_settings = LevelSettings[Managers.state.game_mode:level_key()]

	if new_state == "ghost_mode" and self._environment_state ~= "ghost_mode" then
		local state = level_settings.ghost_mode_setting or "default"

		Managers.state.camera:change_environment(state, 0)
	elseif new_state == "executed" and self._environment_state ~= "executed" then
		local state = level_settings.executed_setting or "default"

		Managers.state.camera:change_environment(state, EnvironmentTweaks.time_to_blend_env)
	elseif new_state == "deserting" and self._environment_state ~= "deserting" then
		local state = level_settings.deserter_setting or "default"

		Managers.state.camera:change_environment(state, EnvironmentTweaks.time_to_blend_env)
	elseif new_state == "knocked_down" and self._environment_state ~= "knocked_down" then
		local state = level_settings.knocked_down_setting or "default"

		Managers.state.camera:change_environment(state, EnvironmentTweaks.time_to_blend_env)
	elseif new_state == "last_stand" and self._environment_state ~= "last_stand" then
		local state = level_settings.last_stand_setting or "default"

		Managers.state.camera:change_environment(state, EnvironmentTweaks.time_to_blend_env)
	elseif new_state == "ghost_mode_blend" and self._environment_state ~= "ghost_mode_blend" then
		local state = level_settings.ghost_mode_setting and "ghost_mode_blend" or "default"

		Managers.state.camera:change_environment(state, EnvironmentTweaks.time_to_blend_env)
	elseif new_state == "default" and self._environment_state ~= "default" then
		local state = "default"
		local time = self._environment_state == "ghost_mode_blend" and EnvironmentTweaks.time_to_default_env or EnvironmentTweaks.time_to_blend_env

		Managers.state.camera:change_environment(state, time)
	end

	self._environment_state = new_state
end

function StateInGameRunning:_update_input(dt, t, input)
	local player = self.player

	if input:get("vote_yes") then
		Managers.state.voting:client_vote("yes", player)
	elseif input:get("vote_no") then
		Managers.state.voting:client_vote("no", player)
	end

	if self._chat_input_active then
		self:_modify_chat_input_blackboard(dt, t, input)

		if self._ingame_menu:active() and not self._ingame_menu:enable_chat() or self._scoreboard:active() or self.parent.is_exiting then
			self:_deactivate_chat_input(true)
			Window.set_show_cursor(true)
		elseif input:get("execute_chat_input") then
			self:_execute_chat_input()
		elseif input:get("deactivate_chat_input") then
			self:_deactivate_chat_input()
		end
	else
		if input:get("activate_chat_input") and (not self._ingame_menu:active() or self._ingame_menu:enable_chat()) and not self._scoreboard:active() and not self.parent.is_exiting then
			self:_activate_chat_input(input, nil)
		elseif input:get("activate_chat_input_all") and (not self._ingame_menu:active() or self._ingame_menu:enable_chat()) and not self._scoreboard:active() and not self.parent.is_exiting then
			if not self._overlay_active then
				self:_activate_chat_input(input, Managers.command_parser:build_command_line("say", ""))
			end
		elseif input:get("activate_chat_input_team") and player.team and player.team.name ~= "unassigned" and (not self._ingame_menu:active() or self._ingame_menu:enable_chat()) and not self._scoreboard:active() and not self.parent.is_exiting then
			self:_activate_chat_input(input, Managers.command_parser:build_command_line("say_team", ""))
		elseif Managers.lobby.server and input:has("exit_to_menu_lobby") and input:get("exit_to_menu_lobby") then
			self.parent.exit_all_to_menu_lobby = true
		elseif Managers.lobby.server and input:get("load_next_level") then
			self:_setup_generic_eol_data()

			self.parent.load_next_level = true
		elseif input:get("cancel") then
			if not self.parent.is_exiting and Managers.time:has_timer("round") and not self._ingame_menu:active() and not self._final_scoreboard_menu:active() and not self._scoreboard:active() then
				self._ingame_menu:set_active(true)
				self._ingame_menu:cancel_to("root")
			elseif self._ingame_menu:active() and self._ingame_menu:current_page_is_root() then
				self._ingame_menu:set_active(false)
			end
		end

		self:_update_scoreboard_input(input)

		local cutscene_system = Managers.state.entity:system("cutscene_system")

		if cutscene_system:active() and input:get("skip_cutscene") then
			cutscene_system:skip()
		end
	end

	local idle_time = GameSettingsDevelopment.idle_kick_time
	local network_manager = Managers.state.network

	if network_manager:game() then
		local idle_since = player.state_data.idle_since
		local idle = input:is_idle() and player.team and player.team.name ~= "unassigned"

		if idle and idle_since < math.huge and t > idle_since + idle_time then
			network_manager:rpc_kicked(nil, "IDLE")
		elseif idle and idle_since == math.huge then
			player.state_data.idle_since = t
		elseif not idle then
			player.state_data.idle_since = math.huge
		end
	end
end

function InputSource:is_idle()
	local idle = true

	for _, controller in pairs(self.controllers) do
		if controller.any_pressed() then
			return false
		end
	end

	return true
end

function StateInGameRunning:_update_scoreboard_input(input)
	if self._ingame_menu:active() then
		return
	end

	local show_scoreboard_input = input:get("scoreboard")
	local show_scoreboard = Managers.lobby.lobby and show_scoreboard_input

	if show_scoreboard then
		local controller = Managers.input:active_mapping(input.slot)
		local scoreboard_active = self._scoreboard:active()

		if controller == "pad360" then
			self._scoreboard:set_active(not scoreboard_active, true)
		else
			local show_scoreboard_bool = show_scoreboard_input == 1

			if show_scoreboard_bool and not scoreboard_active or not show_scoreboard_bool and scoreboard_active then
				self._scoreboard:set_active(show_scoreboard_bool)
			end
		end
	end
end

function StateInGameRunning:_setup_generic_eol_data()
	local players = {}

	for player_index, player in pairs(Managers.player:players()) do
		players[player_index] = {
			player_index = player.index,
			network_id = player:network_id(),
			player_name = player:name(),
			team_name = player.team and player.team.name or "unassigned",
			squad_index = player.squad_index,
			squad_name = player.squad_index and player.team.squads[player.squad_index]:name()
		}
	end

	local loading_context = self.parent.parent.loading_context

	loading_context.players = players
	loading_context.local_player_index = self.player.index
	loading_context.stats_collection = table.clone_instance(Managers.state.stats_collection)
	loading_context.winning_team_name = loading_context.winning_team_name or "red"
	loading_context.red_team_score = loading_context.red_team_score or 0
	loading_context.white_team_score = loading_context.white_team_score or 0
	loading_context.local_player_won = loading_context.local_player_won or self.player.team and self.player.team.name == loading_context.winning_team_name
	loading_context.local_player_team = self.player.team and self.player.team.name or "unassigned"
	loading_context.chat_text_data = Managers.state.hud:get_hud(self.player, "chat_window"):text_data()
end

function StateInGameRunning:_update_locomotion_input(dt)
	for unit, _ in pairs(self.player.owned_units) do
		if ScriptUnit.has_extension_input(unit, "locomotion_system") then
			local locomotion_input = ScriptUnit.extension_input(unit, "locomotion_system")

			locomotion_input.controller = self.player.input_source
		end
	end
end

function StateInGameRunning:post_update(dt, t)
	Profiler.start("StateInGameRunning:post_update()")
	Profiler.start("Managers.state.camera:post_update()")
	Managers.state.camera:post_update(dt, self.viewport_name, self._input_source_look)
	Profiler.stop()
	self._ingame_menu:post_update(dt, t)

	if not Managers.lobby.lobby or Managers.state.network:game() then
		Profiler.start("Managers.state.hud:post_update()")
		Managers.state.hud:post_update(dt, t, self.player)
		Profiler.stop()
	end

	Profiler.stop()
end

function StateInGameRunning:_activate_chat_input(input, prefix, try_big_picture)
	if GameSettingsDevelopment.network_mode ~= "steam" or not Managers.lobby.lobby or self._overlay_active then
		return
	end

	if try_big_picture then
		local reason = ""

		self._overlay_active, reason = self._big_picture_input_handler:show_text_input(L("enter_chat_message"), 0, MAX_CHAT_INPUT_CHARS)

		if self._overlay_active then
			self._disable_input = true

			local text = prefix or self._chat_input_prefix or Managers.command_parser:build_command_line(CHAT_INPUT_DEFAULT_COMMAND, "")

			self._chat_input_blackboard.text = text

			return
		elseif reason == "deactivating" then
			return
		end
	end

	self._chat_input_active = true

	local chat_bb = self._chat_input_blackboard
	local text

	if self._light_chat_shutdown then
		text = chat_bb.text
		self._light_chat_shutdown = false
	else
		text = prefix or self._chat_input_prefix or Managers.command_parser:build_command_line(CHAT_INPUT_DEFAULT_COMMAND, "")
		chat_bb.text = text
	end

	local length = string.len(text)
	local index = 1
	local utf8chars = 0
	local _

	while index <= length do
		_, index = Utf8.location(text, index)
		utf8chars = utf8chars + 1
	end

	chat_bb.input_index = utf8chars + 1

	Managers.state.event:trigger("event_chat_input_activated")
end

function StateInGameRunning:_execute_chat_input()
	self._chat_input_active = false

	local success, msg, command, argument = Managers.command_parser:execute(self._chat_input_blackboard.text, self.player)

	if command then
		self._chat_input_prefix = Managers.command_parser:build_command_line(command, "")
	end

	Managers.state.event:trigger("event_chat_input_deactivated")
end

function StateInGameRunning:_execute_controller_chat_input(text)
	local success, msg, command, argument = Managers.command_parser:execute(self._chat_input_blackboard.text .. text, self.player)

	if command then
		self._chat_input_prefix = Managers.command_parser:build_command_line(command, "")
	end
end

function StateInGameRunning:_deactivate_chat_input(shutdown_light)
	self._delayed_chat_input_deactivate = true
	self._light_chat_shutdown = shutdown_light

	Managers.state.event:trigger("event_chat_input_deactivated")
end

function StateInGameRunning:_modify_chat_input_blackboard(dt, t, input)
	local text = self._chat_input_blackboard.text
	local index = self._chat_input_blackboard.input_index
	local mode = self._chat_input_blackboard.input_mode or "insert"
	local keystrokes = Keyboard.keystrokes()
	local new_text, new_index, new_mode = KeystrokeHelper.parse_strokes(text, index, mode, keystrokes)

	if KeystrokeHelper.num_utf8chars(new_text) > MAX_CHAT_INPUT_CHARS then
		return
	end

	self._chat_input_blackboard.text = new_text
	self._chat_input_blackboard.input_index = new_index
	self._chat_input_blackboard.input_mode = new_mode
end

KeystrokeHelper = KeystrokeHelper or {}

function KeystrokeHelper.num_utf8chars(text)
	local length = string.len(text)
	local index = 1
	local num_chars = 0
	local _

	while index <= length do
		_, index = Utf8.location(text, index)
		num_chars = num_chars + 1
	end

	return num_chars
end

function KeystrokeHelper.parse_strokes(text, index, mode, keystrokes)
	local text_table = KeystrokeHelper._build_utf8_table(text)

	for _, stroke in ipairs(keystrokes) do
		if type(stroke) == "string" then
			index, mode = KeystrokeHelper._add_character(text_table, stroke, index, mode)
		elseif stroke == Keyboard.ENTER then
			break
		elseif KeystrokeHelper[stroke] then
			index, mode = KeystrokeHelper[stroke](text_table, index, mode)
		end
	end

	local new_text = ""

	for _, text_snippet in ipairs(text_table) do
		new_text = new_text .. text_snippet
	end

	return new_text, index, mode
end

function KeystrokeHelper._build_utf8_table(text)
	local text_table = {}
	local character_index = 1
	local index = 1
	local length = string.len(text)

	while index <= length do
		local start_index, end_index = Utf8.location(text, index)

		text_table[character_index] = string.sub(text, index, end_index - 1)
		character_index = character_index + 1
		index = end_index
	end

	return text_table
end

function KeystrokeHelper._add_character(text_table, text, index, mode)
	if mode == "insert" then
		table.insert(text_table, index, text)
	else
		text_table[index] = text
	end

	return index + 1, mode
end

KeystrokeHelper[Keyboard.LEFT] = function(text_table, index, mode)
	return math.max(index - 1, 1), mode
end
KeystrokeHelper[Keyboard.RIGHT] = function(text_table, index, mode)
	return math.min(index + 1, #text_table + 1), mode
end
KeystrokeHelper[Keyboard.UP] = nil
KeystrokeHelper[Keyboard.DOWN] = nil
KeystrokeHelper[Keyboard.INSERT] = function(text_table, index, mode)
	return index, mode == "insert" and "overwrite" or "insert"
end
KeystrokeHelper[Keyboard.HOME] = function(text_table, index, mode)
	return 1, mode
end
KeystrokeHelper[Keyboard.END] = function(text_table, index, mode)
	return #text_table + 1, mode
end
KeystrokeHelper[Keyboard.BACKSPACE] = function(text_table, index, mode)
	local backspace_index = index - 1

	if backspace_index < 1 then
		return index, mode
	end

	table.remove(text_table, backspace_index)

	return backspace_index, mode
end
KeystrokeHelper[Keyboard.TAB] = nil
KeystrokeHelper[Keyboard.PAGE_UP] = nil
KeystrokeHelper[Keyboard.PAGE_DOWN] = nil
KeystrokeHelper[Keyboard.ESCAPE] = nil
KeystrokeHelper[Keyboard.DELETE] = function(text_table, index, mode)
	if text_table[index] then
		table.remove(text_table, index)
	end

	return index, mode
end

function StateInGameRunning:event_player_killed_by_enemy(own_player, attacking_player)
	if own_player == self.player then
		self._killer_player = attacking_player
		self._killer_player_time = Managers.time:time("game")
	end
end

function StateInGameRunning:event_player_killed(victim_unit, attacker_unit, gear_name, is_instakill, finish_off)
	local victim_player = Managers.player:owner(victim_unit)

	if self.player == victim_player and (is_instakill or finish_off) then
		self._display_profile_selection_timer = Managers.time:time("game") + 2
	end
end

function StateInGameRunning:_update_camera(dt, t, input)
	local player = self.player
	local viewport_name = player.viewport_name
	local camera_manager = Managers.state.camera
	local spawn_data = player.spawn_data
	local spawn_state = spawn_data.state
	local spawns = spawn_data.spawns
	local wants_observer = (spawn_state == "dead" or spawn_state == "not_spawned" or player.team and player.team.name == "unassigned" and self._team_confirmed) and not self._killer_player
	local observer = (not self._killer_player_time or not (t < self._killer_player_time + 2)) and t >= self._display_profile_selection_timer and wants_observer

	if observer and self._observer_camera_controller:update(dt, t, player, viewport_name, camera_manager, input) then
		self:_update_profile_viewer(dt, t, input)
	else
		self:_update_camera_target(dt, t, player, viewport_name, camera_manager, input)
	end

	self._input_source_look = Vector3(0, 0, 0)

	local pad_active

	if not self._disable_input and (Managers.input:active_mapping(input.slot) ~= "pad360" or not self._scoreboard:active()) then
		local player_unit = player.player_unit

		pad_active = Managers.input:pad_active(1)

		local locomotion = Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "locomotion_system")
		local attempting_parry = locomotion and locomotion.attempting_parry and not locomotion.parrying
		local attempting_swing = locomotion and locomotion.attempting_pose and not locomotion.pose_ready
		local lock_camera_time = pad_active and PlayerUnitMovementSettings.lock_camera_when_attacking_time
		local swinging = locomotion and locomotion.swinging
		local parrying = locomotion and locomotion.parrying
		local state = locomotion and locomotion.current_state._internal
		local blocking = state and state.blocking
		local special_attacking = state and state.special_attacking
		local dual_wield_attacking = state and state.dual_wield_attacking

		if not self._lock_time or not attempting_parry and not attempting_swing and (not self._lock_time or t > self._lock_time) then
			self._lock_time = nil

			if locomotion and (locomotion.aiming or locomotion.tagging) then
				local aim_multiplier = ActivePlayerControllerSettings.aim_multiplier

				self._input_source_look = input:get("look_aiming") * (ActivePlayerControllerSettings.sensitivity / 2) * (camera_manager:fov(viewport_name) / 0.785) * aim_multiplier
			elseif parrying or blocking or dual_wield_attacking then
				self._input_source_look = input:get("look") * (ActivePlayerControllerSettings.sensitivity / 3) * (camera_manager:fov(viewport_name) / 0.785)
			elseif swinging or special_attacking then
				self._input_source_look = input:get("look") * (ActivePlayerControllerSettings.sensitivity / 4) * (camera_manager:fov(viewport_name) / 0.785)
			else
				self._input_source_look = input:get("look") * (ActivePlayerControllerSettings.sensitivity / 2) * (camera_manager:fov(viewport_name) / 0.785)
			end
		elseif not self._lock_time then
			self._lock_time = t + lock_camera_time
		end
	end

	if not self._ingame_menu:active() then
		local zoom_in = input:has("zoom_in")
		local zoom_out = input:has("zoom_out")
		local zoom = input:has("zoom")

		if not self._chat_input_active and zoom_in and zoom_out then
			if input:has("zoom") then
				local zoom_delta = input:get("zoom_in") * dt - input:get("zoom_out") * dt - input:get("zoom").y

				self._zoom_target = math.clamp(self._zoom_target + zoom_delta * CameraTweaks.zoom.scale, 0, 1)
			elseif pad_active then
				local zoom_delta = dt * (input:get("zoom_out") - input:get("zoom_in"))

				if zoom_delta ~= 0 then
					self._zoom_target = math.clamp(self._zoom_target + zoom_delta * CameraTweaks.zoom.pad_scale, 0, 1)
				end
			end
		end
	end

	self._zoom = CameraTweaks.zoom.interpolation_function(self._zoom, self._zoom_target, dt)

	local zoom_variable = self._zoom

	camera_manager:set_variable(viewport_name, "look_controller_input", Vector3Box(self._input_source_look))
	camera_manager:set_variable(viewport_name, "zoom", zoom_variable)
	camera_manager:update(dt, viewport_name)
end

function StateInGameRunning:_update_profile_viewer(dt, t, input)
	do return end

	if self:_is_observer() and input:get("") then
		Managers.state.event:trigger("")
	end
end

function StateInGameRunning:_is_observer()
	local player = self.player

	return player.team and player.team.name == "unassigned" and self._team_confirmed
end

function StateInGameRunning:_update_camera_target(dt, t, player, viewport_name, camera_manager, input)
	local current_cam_unit = camera_manager:current_node_tree_root_unit(viewport_name)
	local unit = player.camera_follow_unit
	local spawn_data = player.spawn_data
	local tree_name, node_name

	if self._killer_player and (not Unit.alive(self._killer_player.player_unit) or self._ingame_menu:active() or self._final_scoreboard_menu:active() or self._scoreboard:active() or spawn_data.state ~= "dead" or t > self._killer_player_time + 4) then
		if self._show_killer_profile then
			self._show_killer_profile = false

			Managers.state.event:trigger("hide_profile")
		end

		self._killer_player = nil
	end

	if (spawn_data.state == "dead" or spawn_data.state == "not_spawned") and spawn_data.mode == "squad_member" then
		player.camera_follow_unit = spawn_data.squad_unit
		unit = spawn_data.squad_unit
		tree_name = "player"
		node_name = "squad_spawn_camera"
	elseif self._killer_player and t > self._killer_player_time + 2 then
		local player_unit = self._killer_player.player_unit

		player.camera_follow_unit = player_unit

		local game = Managers.state.network:game()

		if game and ScriptUnit.has_extension(player_unit, "locomotion_system") and not self._show_killer_profile then
			local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")
			local game_object = locomotion.id

			self._show_killer_profile = true

			if game_object then
				local profile = ProfileHelper:build_profile_from_game_object(game, game_object, locomotion:inventory())
			end
		end
	end

	if (not unit or not Unit.alive(unit)) and (not current_cam_unit or not Unit.alive(current_cam_unit)) then
		self:_set_default_camera(camera_manager, viewport_name)

		player.camera_follow_unit = nil

		camera_manager:update(dt, viewport_name)

		return
	elseif not unit or not Unit.alive(unit) then
		unit = current_cam_unit
	end

	tree_name = tree_name or Unit.get_data(unit, "camera", "settings_tree")
	node_name = node_name or Unit.get_data(unit, "camera", "settings_node")

	if tree_name and node_name then
		camera_manager:set_frozen(false)
	else
		camera_manager:set_frozen(true)
		camera_manager:update(dt, viewport_name)

		return
	end

	if current_cam_unit ~= unit then
		local preserve_aim_yaw = current_cam_unit ~= nil

		camera_manager:set_node_tree_root_unit(viewport_name, tree_name, unit, nil, preserve_aim_yaw)
		camera_manager:set_camera_node(viewport_name, tree_name, node_name)
	elseif node_name ~= camera_manager:current_camera_node(viewport_name) then
		camera_manager:set_camera_node(viewport_name, tree_name, node_name)
	end
end

function StateInGameRunning:on_exit()
	if self._battle_chatter_collector then
		self._battle_chatter_collector:destroy()

		self._battle_chatter_collector = nil
	end

	if self._battle_chatter_handler then
		self._battle_chatter_handler:destroy()

		self._battle_chatter_handler = nil
	end

	self._ingame_menu:destroy()

	self._ingame_menu = nil

	self._scoreboard:destroy()

	self._scoreboard = nil

	self._final_scoreboard_menu:destroy()

	self._final_scoreboard_menu = nil

	self._profile_viewer_menu:destroy()

	self._final_scoreboard_menu = nil

	World.destroy_gui(self._menu_world, self._gui)
	Managers.world:destroy_world(self._menu_world)
	Application.set_user_setting("zoom", self._zoom_target)
	Application.save_user_settings()
end

function StateInGameRunning:event_game_started(skip_team_selection)
	local squad_screen, auto_team = Managers.state.game_mode:squad_screen_spawning()

	if squad_screen then
		if EDITOR_LAUNCH then
			self._ingame_menu:goto("select_team")
		elseif skip_team_selection then
			LevelHelper:flow_event(self.parent.world, "team_selected")
			self._ingame_menu:goto("select_profile")
		else
			self._ingame_menu:goto("select_team")
		end

		self._scoreboard:set_active(false)
		self._ingame_menu:set_active(true)
	end

	local world = self.parent.world
	local level = LevelHelper:current_level(world)

	Level.trigger_event(level, "game_started")
end

function StateInGameRunning:event_join_team_confirmed()
	self._team_confirmed = true

	if not self._final_scoreboard_menu:active() then
		if self.player.team.name == "unassigned" then
			self._ingame_menu:set_active(false)
		else
			LevelHelper:flow_event(self.parent.world, "team_selected")

			if GameSettingsDevelopment.enable_robot_player then
				self._ingame_menu:goto("select_profile")
			elseif SquadSettings.autojoin_squad then
				self:_autojoin_squad()
				self._ingame_menu:goto("select_profile")
			else
				self._ingame_menu:goto("select_squad")
			end
		end
	end
end

function StateInGameRunning:_autojoin_squad()
	local player = self.player
	local team = player.team
	local squads = team.squads
	local squad_to_join

	for _, squad in ipairs(squads) do
		if squad:num_members() > 0 and not squad:full() then
			squad_to_join = squad

			break
		elseif squad:num_members() == 0 then
			squad_to_join = squad_to_join or squad
		end
	end

	if squad_to_join then
		squad_to_join:request_to_join(player)
	end
end

function StateInGameRunning:event_ghost_mode_deactivated()
	return
end

function StateInGameRunning:event_close_ingame_menu()
	self._ingame_menu:set_active(false)
end

function StateInGameRunning:event_force_close_ingame_menu()
	self._force_close_ingame_menu = true
end

function StateInGameRunning:event_spawn_target_denied()
	Managers.state.spawn:spawn_target_denied(self.player)
end

function StateInGameRunning:event_level_ended()
	if not Managers.lobby.lobby then
		local level_settings = LevelHelper:current_level_settings()

		self:_save_level_progression_id(level_settings.sp_progression_id)
		self:ingame_menu():set_active(false)

		self.parent.exit_to_menu = true
		self.parent.parent.goto_menu_node = "end_of_tutorial"
	end

	if false then
		-- block empty
	end
end

function StateInGameRunning:_save_level_progression_id(id)
	PlayerData.sp_level_progression_id = id > PlayerData.sp_level_progression_id and id or PlayerData.sp_level_progression_id
	SaveData.player_data = PlayerData

	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_player_data_saved"))
	Managers.state.event:trigger("event_save_started", "menu_saving_profile", "menu_profile_saved")
end

function StateInGameRunning:cb_player_data_saved(info)
	if info.error then
		Application.warning("Save error %q", info.error)
	end

	Managers.state.event:trigger("event_save_finished")
end

function StateInGameRunning:ingame_menu()
	return self._ingame_menu
end

function StateInGameRunning:_update_director_mode(dt, t)
	if script_data.director_mode then
		local player_unit = self.player.player_unit

		if not Unit.alive(player_unit) or not Managers.state.network:game() then
			return
		end

		if Keyboard.pressed(Keyboard.button_index("f5")) then
			Managers.state.network:send_rpc_server("rpc_teleport_team_to", NetworkLookup.team.white, Unit.world_position(player_unit, 0), Unit.world_rotation(player_unit, 0), Managers.state.camera:camera_rotation(self.viewport_name))
		end

		if Keyboard.pressed(Keyboard.button_index("f6")) then
			Managers.state.network:send_rpc_server("rpc_teleport_team_to", NetworkLookup.team.red, Unit.world_position(player_unit, 0), Unit.world_rotation(player_unit, 0), Managers.state.camera:camera_rotation(self.viewport_name))
		end

		if Keyboard.pressed(Keyboard.button_index("f7")) then
			Managers.state.network:send_rpc_server("rpc_teleport_all_to", Unit.world_position(player_unit, 0), Unit.world_rotation(player_unit, 0), Managers.state.camera:camera_rotation(self.viewport_name))
		end

		if Keyboard.pressed(Keyboard.button_index("f4")) then
			local physics_world = World.physics_world(self.world)

			local function callback(hit, position, distance, normal, actor)
				if not hit then
					return
				end

				if not actor then
					return
				end

				local unit = Actor.unit(actor)

				if not Unit.alive(unit) then
					return
				end

				local owner = Managers.player:owner(unit)

				if not owner then
					return
				end

				if Unit.alive(owner.player_unit) then
					Managers.state.network:send_rpc_server("rpc_teleport_unit_to", Managers.state.network:game_object_id(owner.player_unit), Unit.world_position(player_unit, 0), Unit.world_rotation(player_unit, 0), Managers.state.camera:camera_rotation(self.viewport_name))
				end
			end

			local raycast = PhysicsWorld.make_raycast(physics_world, callback, "collision_filter", "horse_collision_sweep")
			local from = Managers.state.camera:camera_position(self.viewport_name)
			local dir = Quaternion.forward(Managers.state.camera:camera_rotation(self.viewport_name))

			Raycast.cast(raycast, from, dir)
		end

		if Keyboard.pressed(Keyboard.button_index("f1")) then
			Managers.state.network:send_rpc_server("rpc_toggle_disable_damage")
		end

		if Keyboard.pressed(Keyboard.button_index("f2")) then
			Managers.state.network:send_rpc_server("rpc_toggle_unlimited_ammo", true)
		end
	end
end

function StateInGameRunning:ingame_menu_cancel_to(page_id)
	self._ingame_menu:cancel_to(page_id)
end
