-- chunkname: @scripts/managers/hud/hud_announcements/hud_announcements.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_animated_text_element")
require("scripts/managers/hud/hud_announcements/hud_announcements_animated_container_element")

HUDAnnouncements = class(HUDAnnouncements, HUDBase)

function HUDAnnouncements:init(world, player)
	HUDAnnouncements.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.font_gradient_100, "material", MenuSettings.font_group_materials.hell_shark, "immediate")
	self._queue = {}
	self._history = {}
	self._elements = {}
	self._elements_cnt = 0
	self._container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.announcements.container
	})

	local event_manager = Managers.state.event

	event_manager:register(self, "game_mode_announcement", "event_game_mode_announcement")
	event_manager:register(self, "conquest_announcement", "event_conquest_announcement")
	event_manager:register(self, "gm_event_flow", "event_gm_event_flow")
	event_manager:register(self, "player_last_stand_activated", "event_player_last_stand_activated")
	event_manager:register(self, "local_player_stats_context_created", "event_local_player_stats_context_created")
	event_manager:register(self, "received_help_request", "event_received_help_request")
	event_manager:register(self, "received_duel_challenge", "event_received_duel_challenge")
	event_manager:register(self, "received_bandage_notification", "event_received_bandage_notification")
	event_manager:register(self, "duel_finished", "event_duel_finished")
	event_manager:register(self, "awarded_rank", "event_awarded_rank")
	event_manager:register(self, "short_term_goal_achieved", "event_short_term_goal_achieved")

	self._longshot_cb_id = nil
end

function HUDAnnouncements:event_local_player_stats_context_created(player)
	if player == self._player then
		local stats_collection_manager = Managers.state.stats_collection

		stats_collection_manager:register_callback(player:network_id(), "headshots", ">", 0, callback(self, "cb_headshot"))
		stats_collection_manager:register_callback(player:network_id(), "kill_streak", "=", 3, callback(self, "cb_killstreak"))
		stats_collection_manager:register_callback(player:network_id(), "kill_streak", "=", 5, callback(self, "cb_multi_killstreak"))
		stats_collection_manager:register_callback(player:network_id(), "kill_streak", "=", 10, callback(self, "cb_mega_killstreak"))

		self._longshot_cb_id = Managers.state.stats_collection:register_callback(player:network_id(), "longshot_range", ">", 45.725, callback(self, "cb_longshot"))
	end
end

function HUDAnnouncements:cb_headshot()
	local announcement = "headshot"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:cb_longshot(range)
	local announcement = "longshot"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, range / 0.9144)

	local player = self._player

	Managers.state.stats_collection:unregister_callback(player:network_id(), "longshot_range", self._longshot_cb_id)

	self._longshot_cb_id = Managers.state.stats_collection:register_callback(player:network_id(), "longshot_range", ">", range, callback(self, "cb_longshot"))
end

function HUDAnnouncements:cb_killstreak()
	local announcement = "killstreak"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:cb_multi_killstreak()
	local announcement = "multi_killstreak"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:cb_mega_killstreak()
	local announcement = "mega_killstreak"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:event_gm_event_flow(announcement, side, flow_param_1, flow_param_2)
	local player = self._player

	if player.team and side == player.team.side then
		flow_param_1 = flow_param_1 ~= "" and flow_param_1 or nil
		flow_param_2 = flow_param_2 ~= "" and flow_param_2 or nil

		local param1, param2 = GameModeHelper:announcement_parameters(announcement, player, self._world, flow_param_1, flow_param_2)

		self:_add(announcement, param1, param2)
	end
end

function HUDAnnouncements:event_awarded_rank(rank)
	local announcement = "rank_up"
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:event_short_term_goal_achieved(goal)
	local announcement = "short_term_goal_achieved"

	self:_add(announcement, goal)
end

function HUDAnnouncements:event_game_mode_announcement(announcement, param1, param2)
	if not HUDSettings.show_announcements then
		return
	end

	self:_add(announcement, param1, param2)
end

function HUDAnnouncements:event_conquest_announcement(announcement, team, param1)
	if not HUDSettings.show_announcements then
		return
	end

	if team == self._player.team then
		announcement = announcement .. "_you"
	else
		announcement = announcement .. "_them"
	end

	if Announcements[announcement] then
		self:_add(announcement, param1, team.ui_name)
	end
end

function HUDAnnouncements:event_player_last_stand_activated(player)
	if player == self._player then
		local announcement = "last_stand_activated"
		local param1, param2 = GameModeHelper:announcement_parameters(announcement, self._player, self._world)

		self:_add(announcement, param1, param2)
	end
end

function HUDAnnouncements:event_received_help_request(unit)
	local owner = Managers.player:owner(unit)

	if owner then
		local player_team = self._player.team
		local owner_team = owner.team

		if owner_team and player_team and owner_team == player_team and owner.squad_index and owner.squad_index == self._player.squad_index then
			self:_add("squad_request_revive_notification", owner:name())
		else
			self:_add("team_request_revive_notification", owner:name())
		end
	end
end

function HUDAnnouncements:event_duel_finished(attacker, defender, result)
	local winner, loser

	if result == "attacker" then
		winner = attacker
		loser = defender
	elseif result == "defender" then
		winner = defender
		loser = attacker
	elseif result == "draw" then
		self:_add("duel_draw")

		return
	end

	if not winner.remote then
		self:_add("duel_win", loser:name())
	end

	if not loser.remote then
		self:_add("duel_loss", winner:name())
	end
end

function HUDAnnouncements:event_received_bandage_notification(player)
	self:_add("squad_received_bandage_notification", player:name())
end

function HUDAnnouncements:event_received_duel_challenge(unit)
	local owner = Managers.player:owner(unit)

	if owner then
		local player_team = self._player.team
		local owner_team = owner.team

		self:_add("duel_challenge_notification", owner:name())
	end
end

function HUDAnnouncements:_update_game_mode_announcements(player)
	if not player.team or player.team.name == "unassigned" then
		return
	end

	local time_announcement, time_param1, time_param2 = Managers.state.game_mode:time_announcement(player)

	if time_announcement ~= "" and (time_announcement ~= self._time_announcement or time_param1 ~= self._time_param1 or time_param2 ~= self._time_param2) then
		self:_add(time_announcement, time_param1, time_param2)
	end

	self._time_announcement = time_announcement
	self._time_param1 = time_param1
	self._time_param2 = time_param2

	local own_score_announcement, own_score_param1, own_score_param2 = Managers.state.game_mode:own_score_announcement(player)

	if own_score_announcement ~= "" and (own_score_announcement ~= self._own_score_announcement or own_score_param1 ~= self._own_score_param1 or own_score_param2 ~= self._own_score_param2) then
		self:_add(own_score_announcement, own_score_param1, own_score_param2)
	end

	self._own_score_announcement = own_score_announcement
	self._own_score_param1 = own_score_param1
	self._own_score_param2 = own_score_param2

	local enemy_score_announcement, enemy_score_param1, enemy_score_param2 = Managers.state.game_mode:enemy_score_announcement(player)

	if enemy_score_announcement ~= "" and (enemy_score_announcement ~= self._enemy_score_announcement or enemy_score_param1 ~= self._enemy_score_param1 or enemy_score_param2 ~= self._enemy_score_param2) then
		self:_add(enemy_score_announcement, enemy_score_param1, enemy_score_param2)
	end

	self._enemy_score_announcement = enemy_score_announcement
	self._enemy_score_param1 = enemy_score_param1
	self._enemy_score_param2 = enemy_score_param2

	local own_point_announcement, own_point_param1, own_point_param2 = Managers.state.game_mode:own_capture_point_announcement(player)

	if own_point_announcement ~= "" and (own_point_announcement ~= self._own_point_announcement or own_point_param1 ~= self._own_point_param1 or own_point_param2 ~= self._own_point_param2) then
		self:_add(own_point_announcement, own_point_param1, own_point_param2)
	end

	self._own_point_announcement = own_point_announcement
	self._own_point_param1 = own_point_param1
	self._own_point_param2 = own_point_param2

	local enemy_point_announcement, enemy_point_param1, enemy_point_param2 = Managers.state.game_mode:enemy_capture_point_announcement(player)

	if enemy_point_announcement ~= "" and (enemy_point_announcement ~= self._enemy_point_announcement or enemy_point_param1 ~= self._enemy_point_param1 or enemy_point_param2 ~= self._enemy_point_param2) then
		self:_add(enemy_point_announcement, enemy_point_param1, enemy_point_param2)
	end

	self._enemy_point_announcement = enemy_point_announcement
	self._enemy_point_param1 = enemy_point_param1
	self._enemy_point_param2 = enemy_point_param2

	local description_announcement, description_param1, description_param2 = Managers.state.game_mode:game_mode_description_announcement(player)

	if description_announcement ~= "" and (description_announcement ~= self._description_announcement or description_param1 ~= self._description_param1 or description_param2 ~= self._description_param2) then
		self:_add(description_announcement, description_param1, description_param2)
	end

	self._description_announcement = description_announcement
	self._description_param1 = description_param1
	self._description_param2 = description_param2

	local last_man_standing_announcement, last_man_standing_description_param1, last_man_standing_description_param2 = Managers.state.game_mode:last_man_standing_announcement(player)

	if last_man_standing_announcement ~= "" and (last_man_standing_announcement ~= self._last_man_standing_announcement or last_man_standing_description_param1 ~= self._last_man_standing_description_param1 or last_man_standing_description_param2 ~= self._last_man_standing_description_param2) then
		self:_add(last_man_standing_announcement, last_man_standing_description_param1, last_man_standing_description_param2)
	end

	self._last_man_standing_announcement = last_man_standing_announcement
	self._last_man_standing_description_param1 = last_man_standing_description_param1
	self._last_man_standing_description_param2 = last_man_standing_description_param2
end

function HUDAnnouncements:_add(announcement, param1, param2)
	local history = self._history[announcement] or {
		times_shown = 0,
		last_time = -math.huge
	}
	local times_shown = history.times_shown
	local last_time = history.last_time
	local t = Managers.time:time("game")
	local announcement_settings = Announcements[announcement]
	local show_max_times = announcement_settings.show_max_times or math.huge
	local cooldown = announcement_settings.cooldown

	if show_max_times <= times_shown or cooldown and t < last_time + cooldown then
		return
	end

	local text, layout_settings

	if not announcement_settings.no_text then
		if announcement_settings.localize_parameters then
			text = string.format(L(announcement), L(param1), L(param2))
		else
			text = string.format(L(announcement), param1, param2)
		end
	end

	layout_settings = announcement_settings.layout_settings

	local unique_id = announcement_settings.unique_id
	local sound_event

	if announcement_settings.sound_events then
		sound_event = announcement_settings.sound_event_function(self._player, announcement_settings, param1, param2)
	else
		sound_event = announcement_settings.sound_event
	end

	local interrupt_prio = announcement_settings.interrupt_prio

	if unique_id then
		for i = #self._queue, 1, -1 do
			if unique_id == self._queue[i].unique_id then
				table.remove(self._queue, i)
			end
		end
	end

	if interrupt_prio then
		for i = #self._elements, 1, -1 do
			local element = self._elements[i]
			local element_interrupt_prio = element.interrupt_prio

			if not element_interrupt_prio or element_interrupt_prio <= interrupt_prio then
				self._container:remove_element(element.id)
				table.remove(self._elements, i)
			end
		end
	end

	local entry = {
		unique_id = unique_id,
		text = text,
		sound_event = sound_event,
		interrupt_prio = interrupt_prio,
		container = announcement_settings.container,
		elements = announcement_settings.elements,
		container_sound_events = announcement_settings.container_sound_events,
		layout_settings = layout_settings,
		params = {
			param1 = param1,
			param2 = param2
		},
		discard_time = t + (announcement_settings.discard_time or DefaultAnnouncementSettings.discard_time)
	}

	table.insert(self._queue, self:_next_queue_index(announcement), entry)

	history.times_shown = history.times_shown + 1
	history.last_time = t
	self._history[announcement] = history
end

function HUDAnnouncements:_next_queue_index(announcement)
	local index = #self._queue + 1
	local interrupt_prio = Announcements[announcement].interrupt_prio

	if interrupt_prio then
		for i = #self._queue, 1, -1 do
			local entry_interrupt_prio = self._queue[i].interrupt_prio

			if not entry_interrupt_prio or entry_interrupt_prio <= interrupt_prio then
				index = i
			end
		end
	end

	return index
end

function HUDAnnouncements:_update_queue(dt, t)
	if #self._queue > 0 and (#self._elements == 0 or t > self._elements[1].queue_delay) then
		local config = table.remove(self._queue, 1)

		if t < config.discard_time then
			self:_add_element(dt, t, config)
		end
	end
end

function HUDAnnouncements:_update_elements(dt, t)
	for i = #self._elements, 1, -1 do
		local element = self._elements[i]

		if t > element.anim_length then
			self._container:remove_element(element.id)
			table.remove(self._elements, i)
		end
	end
end

function HUDAnnouncements:_add_element(dt, t, config)
	if config.container then
		local container = self:_add_container(config)
		local id = "announcement_" .. self._elements_cnt

		self._container:add_element(id, container)

		local layout_settings = HUDHelper:layout_settings(config.layout_settings)

		self._elements[#self._elements + 1] = {
			id = id,
			queue_delay = t + layout_settings.queue_delay,
			anim_length = t + layout_settings.anim_length,
			interrupt_prio = config.interrupt_prio
		}
		self._elements_cnt = self._elements_cnt + 1
	elseif config.layout_settings then
		local element_config = {
			z = #self._elements + 1,
			text = config.text or "",
			layout_settings = config.layout_settings,
			drop_shadow = {
				color = QuaternionBox(190, 0, 0, 0),
				offset = Vector3Box(2, -2, -1)
			}
		}
		local id = "announcement_" .. self._elements_cnt

		self._container:add_element(id, HUDAnimatedTextElement.create_from_config(element_config))

		local layout_settings = HUDHelper:layout_settings(config.layout_settings)

		self._elements[#self._elements + 1] = {
			id = id,
			queue_delay = t + layout_settings.queue_delay,
			anim_length = t + layout_settings.anim_length,
			interrupt_prio = config.interrupt_prio
		}
		self._elements_cnt = self._elements_cnt + 1
	end

	if config.sound_event then
		local team = self._player.team
		local team_name = team and team.name
		local team_settings = TeamSettings[team_name]

		if team_settings and team_settings.announcer_voice then
			local timpani_world = World.timpani_world(self._world)
			local event_id = TimpaniWorld.trigger_event(timpani_world, config.sound_event)

			TimpaniWorld.set_parameter(timpani_world, event_id, "character_announcer", team_settings.announcer_voice)
		end
	end
end

function HUDAnnouncements:_add_container(settings)
	local container_sound_events = table.clone(settings.container_sound_events)
	local num_sound_events = #container_sound_events

	for i = 1, num_sound_events do
		local sound_event = container_sound_events[i]
		local sound_func = sound_event.sound_func

		if sound_func then
			local event, parameters = sound_func(self._player)

			sound_event.event = event
			sound_event.parameters = parameters
		end
	end

	local config = {
		world = self._world,
		layout_settings = settings.layout_settings,
		sound_events = container_sound_events
	}
	local container = HUDAnnouncementsAnimatedContainerElement.create_from_config(config)

	for id, element_settings in ipairs(settings.elements) do
		local config = {
			text = element_settings.text_func and HUDHelper[element_settings.text_func](self._player, self._world, settings.params) or string.format(L(element_settings.text), settings.params.param1, settings.params.param2),
			layout_settings = element_settings.layout_settings,
			drop_shadow = {
				color = QuaternionBox(190, 0, 0, 0),
				offset = Vector3Box(2, -1, -1)
			}
		}

		container:add_element(id, HUDAnimatedTextElement.create_from_config(config))
	end

	return container
end

function HUDAnnouncements:post_update(dt, t)
	self:_update_game_mode_announcements(self._player)
	self:_update_queue(dt, t)
	self:_update_elements(dt, t)

	local layout_settings = HUDHelper:layout_settings(self._container.config.layout_settings)
	local gui = self._gui

	self._container:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self._container, layout_settings)

	self._container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
	self._container:render(dt, t, gui, layout_settings)
end

function HUDAnnouncements:disabled_post_update(dt, t)
	self:_update_game_mode_announcements(self._player)
end

function HUDAnnouncements:destroy()
	World.destroy_gui(self._world, self._gui)
end
