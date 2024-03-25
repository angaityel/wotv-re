-- chunkname: @scripts/unit_extensions/objectives/zone_capture_point_server.lua

require("scripts/unit_extensions/objectives/capture_point_server_base")

ZoneCapturePointServer = class(ZoneCapturePointServer, CapturePointServerBase)

local NEUTRALIZE_SPEED = 0.25
local CAPTURE_SPEED = 0.05
local IDLE_REVERT_SPEED_NEUTRALIZED = 0.02
local IDLE_REVERT_SPEED = 0.4

function ZoneCapturePointServer:init(world, unit)
	ZoneCapturePointServer.super.init(self, world, unit)

	self._capturing_units = {}
	self._old_capturing_units = {}
	self._num_capturing_units = {}
	self._capture_scale = 0
	self._instant_capture = true
	self._inactive_teams_block_capture = true
	self._blackboard.capture_scale = 0
	self._blackboard.being_captured = false
	self._blackboard.instant_capture = self._instant_capture
	self._oldest_unit = {}
	self._capturing_team = false
	self.objective_point_order_id = "none"
	self._locked = false
	self._locked_end_time = 0
	self._forced_synch = nil
	self._lock_reasons = {
		game_mode = false,
		activated = false
	}
	self._neutralize_speed = Unit.get_data(unit, "neutralize_speed") or NEUTRALIZE_SPEED
	self._capture_speed = Unit.get_data(unit, "capture_speed") or CAPTURE_SPEED
	self._idle_revert_speed_neutralized = Unit.get_data(unit, "idle_revert_speed_neutralized") or IDLE_REVERT_SPEED_NEUTRALIZED
	self._idle_revert_speed = Unit.get_data(unit, "idle_revert_speed") or IDLE_REVERT_SPEED

	local game_mode_settings = Managers.state.game_mode:game_mode_settings()

	self._capture_speed_multiplier = game_mode_settings and game_mode_settings.capture_speed_multiplier or 1
	self._instant_capture = not game_mode_settings or game_mode_settings.instant_capture ~= false
	self._blackboard.capture_scale = 0
	self._blackboard.being_captured = false
	self._blackboard.instant_capture = self._instant_capture

	if game_mode_settings.previous_owned_cap_multiplier then
		self._capture_speed_previous_owned_multiplier = game_mode_settings.previous_owned_cap_multiplier
	else
		self._capture_speed_previous_owned_multiplier = 1
	end

	self._team_has_captured = {}
	self._has_captured_before = {}
end

function ZoneCapturePointServer:set_capture_speed(speed)
	self._capture_speed = speed
end

function ZoneCapturePointServer:_init_teams()
	ZoneCapturePointServer.super._init_teams(self)

	local teams = Managers.state.team:sides()

	for _, team in pairs(teams) do
		self._capturing_units[team] = {}
		self._old_capturing_units[team] = {}
		self._num_capturing_units[team] = 0
	end
end

function ZoneCapturePointServer:flow_cb_set_active(team_side, active, with_delay)
	if not self._active[team_side] then
		local game_mode_key = Managers.state.game_mode:game_mode_key()
		local lock_duration = GameModeSettings[game_mode_key].capture_point_lock_duration

		if with_delay and lock_duration and lock_duration > 0 then
			self:lock("activated", Managers.time:time("round") + lock_duration)
		end
	end

	self:_set_active(team_side, active)
end

function ZoneCapturePointServer:_set_active(side, active)
	ZoneCapturePointServer.super._set_active(self, side, active)

	if self._lock_reasons.activated then
		local active_at_all = false

		for side, active in pairs(self._active) do
			active_at_all = active_at_all or active
		end

		if not active_at_all then
			self:unlock("activated")
		end
	end
end

function ZoneCapturePointServer:lock(reason, end_time)
	local lock_reasons = self._lock_reasons

	lock_reasons[reason] = end_time or true

	local max_end_time = 0

	for reason, end_time in pairs(lock_reasons) do
		if type(end_time) == "number" and max_end_time < end_time then
			max_end_time = end_time
		end
	end

	self._locked = true
	self._locked_end_time = max_end_time
	self._blackboard.locked = true
	self._blackboard.locked_end_time = max_end_time

	if self._game and self._id then
		GameSession.set_game_object_field(self._game, self._id, "locked", self._locked)
		GameSession.set_game_object_field(self._game, self._id, "locked_end_time", self._locked_end_time)
	end
end

function ZoneCapturePointServer:unlock(reason)
	local lock_reasons = self._lock_reasons

	lock_reasons[reason] = false

	local max_end_time = 0
	local locked = false

	for reason, end_time in pairs(lock_reasons) do
		if type(end_time) == "number" and max_end_time < end_time then
			max_end_time = end_time
			locked = true
		elseif end_time then
			locked = true
		end
	end

	self._locked = locked
	self._locked_end_time = max_end_time
	self._blackboard.locked = locked
	self._blackboard.locked_end_time = max_end_time

	if self._game and self._id then
		GameSession.set_game_object_field(self._game, self._id, "locked", self._locked)
		GameSession.set_game_object_field(self._game, self._id, "locked_end_time", self._locked_end_time)
	end
end

function ZoneCapturePointServer:_update_lock_status(dt, t)
	if self._locked_end_time > 0 then
		local lock_reasons = self._lock_reasons

		for reason, end_time in pairs(lock_reasons) do
			if type(end_time) == "number" and end_time < t then
				Managers.state.event:trigger("objective_unlocked_by_time", self._unit, reason, self._owner)
				self:unlock(reason)
			end
		end
	end
end

function ZoneCapturePointServer:update(unit, input, dt, context, t)
	if self._frozen then
		return
	end

	local update_blackboard = false

	if self._locked then
		local round_t = Managers.time:time("round")

		self:_update_lock_status(dt, round_t)
	else
		self:_update_units(dt, t)

		local largest_team, num, number_of_capturing_teams = self:_largest_team()
		local owner = self._owner
		local capture_speed = (not (owner ~= "neutral" and not self._instant_capture) and self._capture_speed or self._neutralize_speed) * (1 + 0.2 * (num - 1) - 4 * ((num - 1) / 64)^2) * self._capture_speed_multiplier * (self:_should_apply_recapture_bonus(largest_team) and self._capture_speed_previous_owned_multiplier or 1)
		local idle_revert_speed = (not (owner ~= "neutral" and not self._instant_capture) and self._idle_revert_speed_neutralized or self._idle_revert_speed) * self._capture_speed_multiplier * (self:_should_apply_recapture_bonus(largest_team) and self._capture_speed_previous_owned_multiplier or 1)
		local old_capturing_team = self._capturing_team

		if number_of_capturing_teams > 1 then
			self._blackboard.being_captured = true
		elseif largest_team and largest_team ~= owner and (largest_team == self._capturing_team or not self._capturing_team) then
			self._capture_scale = self._capture_scale + dt * capture_speed
			self._capturing_team = largest_team

			if self._capture_scale >= 1 and (self._instant_capture or owner == "neutral") then
				self._capture_scale = 0

				self:_zone_captured(largest_team, owner)
				self:set_owner(largest_team)

				self._blackboard.being_captured = true
			elseif self._capture_scale >= 1 then
				self:set_owner("neutral")

				self._capture_scale = 0
				self._blackboard.being_captured = true
			else
				self._blackboard.being_captured = true
			end
		elseif largest_team and largest_team ~= owner then
			self._capture_scale = self._capture_scale - dt * capture_speed
			self._blackboard.being_captured = true

			if self._capture_scale <= 0 then
				Managers.state.event:trigger("objective_being_captured", self._unit, largest_team)

				self._capturing_team = largest_team
				self._capture_scale = 0
			end
		elseif largest_team then
			self._capture_scale = math.max(0, self._capture_scale - dt * capture_speed)
			self._blackboard.being_captured = false
		elseif num >= 1 then
			self._blackboard.being_captured = false
		else
			self._capture_scale = math.max(0, self._capture_scale - dt * idle_revert_speed)
			self._blackboard.being_captured = false
		end

		if self._capture_scale == 0 and not self._blackboard_being_captured then
			self._capturing_team = false
		end

		if old_capturing_team and old_capturing_team ~= self._capturing_team then
			Managers.state.event:trigger("objective_not_being_captured", self._unit, old_capturing_team)
		end

		if self._capturing_team and self._capturing_team ~= old_capturing_team then
			Managers.state.event:trigger("objective_being_captured", self._unit, self._capturing_team)
		end
	end

	self._blackboard.capture_scale = self._capture_scale
	self._blackboard.capturing_team = self._capturing_team

	if self._game and self._id then
		GameSession.set_game_object_field(self._game, self._id, "capturing_team", NetworkLookup.team[self._blackboard.capturing_team or false])

		if (self._capture_scale == 1 or self._capture_scale == 0) and self._forced_synch ~= self._capture_scale then
			GameSession.set_game_object_field(self._game, self._id, "capture_scale", self._capture_scale, true)

			self._forced_synch = self._capture_scale
		elseif self._capture_scale ~= 1 and self._capture_scale ~= 0 then
			GameSession.set_game_object_field(self._game, self._id, "capture_scale", self._capture_scale)

			self._forced_synch = nil
		else
			GameSession.set_game_object_field(self._game, self._id, "capture_scale", self._capture_scale)
		end

		GameSession.set_game_object_field(self._game, self._id, "being_captured", self._blackboard.being_captured)
	end
end

function ZoneCapturePointServer:_should_apply_recapture_bonus(side)
	return self._team_has_captured[side]
end

function ZoneCapturePointServer:_zone_captured(side, previous_owner)
	local no_previous_cap = self._has_captured_before[side] == nil and self._has_captured_before[side == "defenders" and "attackers" or "defenders"] == nil
	local oldest_unit = self._oldest_unit[side] or script_data.player
	local player_manager = Managers.player
	local player = player_manager:owner(oldest_unit)

	Managers.state.event:trigger("objective_captured", player, self._unit, side, previous_owner, no_previous_cap)

	self._has_captured_before[side] = true

	for unit, _ in pairs(self._capturing_units[side]) do
		if oldest_unit ~= unit then
			local assisting_player = player_manager:owner(unit)

			Managers.state.event:trigger("objective_captured_assist", assisting_player, self._unit)
		end
	end
end

function ZoneCapturePointServer:_largest_team()
	local largest_num = 0.1
	local largest_team
	local teams_with_members = 0

	for team, num in pairs(self._num_capturing_units) do
		if (not self._inactive_teams_block_capture or self._active[team]) and largest_num < num then
			largest_team = team
			largest_num = num
		elseif (not self._inactive_teams_block_capture or self._active[team]) and math.abs(num - largest_num) < 0.1 then
			largest_team = nil
		end

		if num > 0 then
			teams_with_members = teams_with_members + 1
		end
	end

	if script_data.capture_zones and not largest_team then
		largest_team = script_data.capture_zones
		largest_num = 5
		teams_with_members = 1
	end

	return self._active[largest_team] and largest_team, largest_num, teams_with_members
end

function ZoneCapturePointServer:flow_cb_set_zone_name(name)
	self._zone_name = name

	local network_manager = Managers.state.network

	if network_manager:game() then
		local level_object_id = network_manager:level_object_id(self._unit)

		network_manager:send_rpc_clients("rpc_set_zone_name", level_object_id, name)
	end
end

function ZoneCapturePointServer:flow_cb_set_owner(team)
	self._capture_scale = 0

	self:set_owner(team, true)

	self._team_has_captured[team] = true
end

function ZoneCapturePointServer:is_contributing(player)
	local team_side = player.team.side
	local units = self._capturing_units[team_side]

	for unit, _ in pairs(units) do
		if unit == player.player_unit then
			return true
		end
	end
end

function ZoneCapturePointServer:_update_units(dt, t)
	local zone = self._zone_name

	if not zone or zone == "" then
		return
	end

	for side_name, units in pairs(self._capturing_units) do
		self._num_capturing_units[side_name] = 0

		local old_table = self._old_capturing_units[side_name]
		local new_table = self._capturing_units[side_name]

		table.clear(old_table)

		self._capturing_units[side_name] = old_table
		self._old_capturing_units[side_name] = new_table
		self._oldest_unit[side_name] = nil
	end

	local units = Managers.state.entity:get_entities("PlayerUnitDeserter")
	local player_manager = Managers.player
	local level = LevelHelper:current_level(self._world)

	for unit, _ in pairs(units) do
		local damage_extension = ScriptUnit.extension(unit, "damage_system")
		local pos = Unit.world_position(unit, 0) + Vector3(0, 0, 0.5)

		if not damage_extension:is_knocked_down() and not damage_extension:is_dead() and Level.is_point_inside_volume(level, zone, pos) and not ScriptUnit.extension(unit, "locomotion_system").ghost_mode then
			local player = player_manager:owner(unit)
			local side_name = player and player.team and player.team.side

			if side_name then
				self._num_capturing_units[side_name] = self._num_capturing_units[side_name] + 1

				local capturing_units_table = self._capturing_units[side_name]

				capturing_units_table[unit] = self._old_capturing_units[side_name][unit] or t

				local oldest_unit = self._oldest_unit[side_name]

				if not oldest_unit or capturing_units_table[unit] < capturing_units_table[oldest_unit] then
					self._oldest_unit[side_name] = unit
				end
			end
		end
	end
end

function ZoneCapturePointServer:_create_game_object()
	local unit = self._unit
	local data_table = {
		locked_end_time = 0,
		locked = false,
		game_object_created_func = NetworkLookup.game_object_functions.cb_capture_point_created,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		object_destroy_func = NetworkLookup.game_object_functions.cb_capture_point_destroyed,
		level_unit_index = Unit.get_data(self._unit, "level_unit_index"),
		owner = NetworkLookup.team[self._owner],
		capture_scale = self._blackboard.capture_scale,
		being_captured = self._blackboard.being_captured,
		capturing_team = NetworkLookup.team[self._capturing_team],
		instant_capture = self._instant_capture,
		object_order_id = NetworkLookup.objective_point_order_ids[self.objective_point_order_id]
	}

	for team, active in pairs(self._active) do
		data_table[team .. "_active"] = active
	end

	local callback = callback(self, "cb_game_session_disconnect")

	self._id = Managers.state.network:create_game_object("zone_capture_point", data_table, callback, "cb_local_capture_point_created", unit)
	self._game = Managers.state.network:game()
end

function ZoneCapturePointServer:hot_join_synch(sender, player)
	local network_manager = Managers.state.network

	if self._zone_name then
		local level_object_id = network_manager:level_object_id(self._unit)

		RPC.rpc_set_zone_name(sender, level_object_id, self._zone_name)
	end
end
