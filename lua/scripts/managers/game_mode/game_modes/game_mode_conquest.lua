-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_conquest.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

GameModeConquest = class(GameModeConquest, GameModeBase)

function GameModeConquest:init(settings, world, ...)
	GameModeConquest.super.init(self, settings, world, ...)

	local event_manager = Managers.state.event

	event_manager:register(self, "gm_event_objective_captured", "gm_event_objective_captured")
	event_manager:register(self, "gm_event_objective_being_captured", "gm_event_objective_being_captured")
	event_manager:register(self, "gm_event_objective_unlocked_by_time", "gm_event_objective_unlocked_by_time")
	event_manager:register(self, "objective_captured", "event_objective_captured")
	event_manager:register(self, "objective_being_captured", "event_objective_being_captured")
	event_manager:register(self, "objective_not_being_captured", "event_objective_not_being_captured")

	self._win_score = math.huge
	self._objectives = {}
	self._objective_indices = {}
	self._objective_spawn_points = {}
	self._objective_boundary_areas = {}
	self._objectives_set = false
end

function GameModeConquest:add_objective_spawn_point(objective_unit, side, spawn_point_name, spawn_direction)
	local point = self._objective_spawn_points[objective_unit] or {}
	local point_per_side = point[side] or {}

	point_per_side[#point_per_side + 1] = {
		name = spawn_point_name,
		direction = Vector3Box(spawn_direction)
	}
	point[side] = point_per_side
	self._objective_spawn_points[objective_unit] = point
end

function GameModeConquest:add_objective_boundary_area(objective_unit, side, boundary_area_name)
	local zone = self._objective_boundary_areas[objective_unit] or {}

	fassert(not zone[side], "Already set boundary area %q for side %q for objective %q", boundary_area_name, side, tostring(objective_unit))

	zone[side] = {
		side = side,
		boundary_area = boundary_area_name
	}
	self._objective_boundary_areas[objective_unit] = zone
end

function GameModeConquest:set_objective_point_order(objectives)
	for index, unit in ipairs(objectives) do
		self._objectives[index] = unit
		self._objective_indices[unit] = index
	end

	local num_objectives = #objectives

	self._win_score = num_objectives

	self:_setup_point_ownership(objectives, num_objectives)

	self._objectives_set = true
end

function GameModeConquest:_setup_point_ownership(objectives, num_objectives)
	local half_objectives = num_objectives / 2
	local with_delay = false
	local activate = true
	local level_key = Managers.state.game_mode:level_key()
	local level_settings = LevelSettings[level_key].con
	local capture_speeds = level_settings and level_settings.capture_speeds

	if capture_speeds then
		local num_capture_speeds = #capture_speeds

		fassert(num_capture_speeds == num_objectives, "There are %i capture speeds and %i objectives, these need to contain the same amount", num_capture_speeds, num_objectives)
	end

	for index, unit in ipairs(objectives) do
		local objective_ext = ScriptUnit.extension(unit, "objective_system")

		if capture_speeds then
			objective_ext:set_capture_speed(capture_speeds[index])
		end

		local owner = index <= half_objectives and "attackers" or index >= half_objectives + 1 and "defenders" or nil

		if owner then
			objective_ext:flow_cb_set_owner(owner)
			Managers.state.team:give_score_to_side(owner, 1)
		end

		if index == half_objectives then
			objective_ext:flow_cb_set_active("attackers", activate, with_delay)
			objective_ext:flow_cb_set_active("defenders", activate, with_delay)
			self:_activate_spawn("attackers", index)
			self:_activate_boundary_area("attackers", index)
		elseif index == half_objectives + 1 then
			objective_ext:flow_cb_set_active("attackers", activate, with_delay)
			objective_ext:flow_cb_set_active("defenders", activate, with_delay)
			self:_activate_spawn("defenders", index)
			self:_activate_boundary_area("defenders", index)
		elseif math.abs(index - (half_objectives + 0.5)) < EPSILON then
			objective_ext:flow_cb_set_active("attackers", activate, with_delay)
			objective_ext:flow_cb_set_active("defenders", activate, with_delay)
		elseif math.abs(index - (half_objectives - 0.5)) < EPSILON then
			self:_activate_spawn("attackers", index)
			self:_activate_boundary_area("attackers", index)
		elseif math.abs(index - (half_objectives + 1.5)) < EPSILON then
			self:_activate_spawn("defenders", index)
			self:_activate_boundary_area("defenders", index)
		end
	end
end

function GameModeConquest:_activate_boundary_area(side, index)
	local team_name = Managers.state.team:name(side)
	local objective = self._objectives[index]
	local boundary_area = self._objective_boundary_areas[objective][side]

	Managers.state.event:trigger("activate_boundary_area", boundary_area)
end

function GameModeConquest:_deactivate_boundary_area(side, index)
	local team_name = Managers.state.team:name(side)
	local objective = self._objectives[index]
	local boundary_area = self._objective_boundary_areas[objective][side]

	Managers.state.event:trigger("deactivate_boundary_area", boundary_area)
end

function GameModeConquest:_activate_spawn(side, index)
	local team_name = Managers.state.team:name(side)
	local objective = self._objectives[index]
	local spawns = self._objective_spawn_points[objective][side]

	for _, spawn in ipairs(spawns) do
		print("[GameModeConquest] activating: ", spawn.name, team_name, spawn.direction)
		Managers.state.spawn:activate_spawn_area(spawn.name, team_name, spawn.direction)
	end
end

function GameModeConquest:_deactivate_spawn(side, index)
	local team_name = Managers.state.team:name(side)
	local objective = self._objectives[index]
	local spawns = self._objective_spawn_points[objective][side]

	for _, spawn in ipairs(spawns) do
		print("[GameModeConquest] deactivating: ", spawn.name, team_name, spawn.direction)
		Managers.state.spawn:deactivate_spawn_area(spawn.name, team_name)
	end
end

function GameModeConquest:_objective_captured(unit, side, previous_owner)
	local index = self._objective_indices[unit]

	if side == "attackers" then
		local attacker_index = index - 1

		if attacker_index > 0 then
			self:_set_objective_active(attacker_index, false)
			self:_deactivate_spawn("attackers", attacker_index)
			self:_deactivate_boundary_area("attackers", attacker_index)
		end

		self:_deactivate_spawn("defenders", index)
		self:_deactivate_boundary_area("defenders", index)
		self:_activate_spawn("attackers", index)
		self:_activate_boundary_area("attackers", index)

		local defender_index = index + 1

		if defender_index <= #self._objectives then
			self:_set_objective_active(defender_index, true)
			self:_activate_spawn("defenders", defender_index)
			self:_activate_boundary_area("defenders", defender_index)
		end

		Managers.state.team:give_score_to_side("attackers", 1)
	elseif side == "defenders" then
		local defender_index = index + 1

		if defender_index <= #self._objectives then
			self:_set_objective_active(defender_index, false)
			self:_deactivate_spawn("defenders", defender_index)
			self:_deactivate_boundary_area("defenders", defender_index)
		end

		self:_deactivate_spawn("attackers", index)
		self:_deactivate_boundary_area("attackers", index)
		self:_activate_spawn("defenders", index)
		self:_activate_boundary_area("defenders", index)

		local attacker_index = index - 1

		if attacker_index > 0 then
			self:_set_objective_active(attacker_index, true)
			self:_activate_spawn("attackers", attacker_index)
			self:_activate_boundary_area("attackers", attacker_index)
		end

		Managers.state.team:give_score_to_side("defenders", 1)
	end

	if previous_owner and previous_owner ~= "neutral" then
		Managers.state.team:give_score_to_side(previous_owner, -1)
	end
end

function GameModeConquest:_set_objective_active(index, active)
	local unit = self._objectives[index]
	local objective_ext = ScriptUnit.extension(unit, "objective_system")

	objective_ext:flow_cb_set_active("attackers", active, active)
	objective_ext:flow_cb_set_active("defenders", active, active)
end

function GameModeConquest:evaluate_end_conditions()
	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if not red_team or not white_team or not self._objectives_set then
		return
	end

	local win_score = self._win_score
	local time_limit = self._time_limit
	local score_limit_reached = win_score <= red_team.score or win_score <= white_team.score
	local time_limit_reached = time_limit and time_limit <= Managers.time:time("round")

	if score_limit_reached or time_limit_reached then
		if math.floor(red_team.score) > math.floor(white_team.score) then
			return true, red_team, false, score_limit_reached
		elseif math.floor(white_team.score) > math.floor(red_team.score) then
			return true, white_team, false, score_limit_reached
		else
			return true, false
		end
	end

	return false, false
end

function GameModeConquest:event_objective_captured(player, objective_unit, side, previous_owner)
	self:_objective_captured(objective_unit, side, previous_owner)
end

function GameModeConquest:event_objective_being_captured(objective_unit, side)
	self:_update_objective_lock(objective_unit, side, true)
end

function GameModeConquest:event_objective_not_being_captured(objective_unit, side)
	self:_update_objective_lock(objective_unit, side, false)
end

function GameModeConquest:_update_objective_lock(unit, side, being_captured)
	local index = self._objective_indices[unit]

	if side == "attackers" then
		local attacker_index = index - 1

		if attacker_index > 0 then
			self:_set_objective_lock_status(attacker_index, "defenders", being_captured)
		end
	elseif side == "defenders" then
		local defender_index = index + 1

		if defender_index <= #self._objectives then
			self:_set_objective_lock_status(defender_index, "attackers", being_captured)
		end
	end
end

function GameModeConquest:_set_objective_lock_status(index, side, lock)
	local unit = self._objectives[index]
	local objective_ext = ScriptUnit.extension(unit, "objective_system")

	if lock then
		objective_ext:lock("game_mode")
	else
		objective_ext:unlock("game_mode")
	end
end

function GameModeConquest:gm_event_objective_unlocked_by_time(objective_unit, reason, owner)
	if reason == "activated" then
		local objective_name = Unit.get_data(objective_unit, "hud", "ui_name")

		Managers.state.event:trigger("conquest_announcement", "conquest_objective_unlocked_by_time", Managers.state.team:team_by_side(owner), objective_name)
	end
end

function GameModeConquest:gm_event_objective_being_captured(objective_unit, side)
	local objective_name = Unit.get_data(objective_unit, "hud", "ui_name")

	Managers.state.event:trigger("conquest_announcement", "conquest_capturing_objective", Managers.state.team:team_by_side(side), objective_name)
end

function GameModeConquest:gm_event_objective_captured(capturing_player, captured_unit)
	if not capturing_player.team or not Unit.alive(captured_unit) then
		return
	end

	local interacted = Unit.get_data(captured_unit, "hud", "ui_interacted")
	local objective_name = Unit.get_data(captured_unit, "hud", "ui_name")

	Managers.state.event:trigger("conquest_announcement", "conquest_captured_objective", capturing_player.team, objective_name)
end

function GameModeConquest:objective(local_player)
	if local_player.spawn_data.state ~= "spawned" then
		return "", nil, nil
	end

	local objective = ""

	if self._settings.tagging_objectives then
		local tagged_player_unit = GameModeHelper:player_unit_tagged_by_own_squad_corporal(local_player)

		if tagged_player_unit then
			local damage_ext = ScriptUnit.extension(tagged_player_unit, "damage_system")
			local tagged_player = Managers.player:owner(tagged_player_unit)

			if tagged_player.team == local_player.team then
				if damage_ext._knocked_down then
					objective = "revive_tagged_team_member"
				else
					objective = "defend_tagged_team_member"
				end
			elseif damage_ext._knocked_down then
				objective = "execute_tagged_enemy"
			else
				objective = "kill_tagged_enemy"
			end
		else
			local tagged_objective_unit = GameModeHelper:objective_unit_tagged_by_own_squad_corporal(local_player, self._world)

			if tagged_objective_unit then
				local objectiv_ext = ScriptUnit.extension(tagged_objective_unit, "objective_system")

				objective = objectiv_ext._owner == local_player.team.side and "defend_tagged_objective" or "attack_tagged_objective"
			end
		end
	end

	local param1, param2 = GameModeHelper:objective_parameters(objective, local_player, self._world)

	return objective, param1, param2
end

function GameModeConquest:own_score_announcement(local_player)
	local announcement = ""
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeConquest:enemy_score_announcement(local_player)
	local announcement = ""
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeConquest:own_capture_point_announcement(local_player)
	local not_owned_objectives = Managers.state.game_mode:not_owned_objectives(local_player.team.name)
	local announcement = ""

	if #not_owned_objectives == 0 then
		announcement = "own_team_have_captured_all_points"
	elseif #not_owned_objectives == 1 then
		announcement = "own_team_only_need_last_point"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeConquest:enemy_capture_point_announcement(local_player)
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local not_owned_objectives = Managers.state.game_mode:not_owned_objectives(enemy_team_name)
	local announcement = ""

	if #not_owned_objectives == 0 then
		announcement = "enemy_team_have_captured_all_points"
	elseif #not_owned_objectives == 1 then
		announcement = "enemy_team_only_need_last_point"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeConquest:game_mode_description_announcement(local_player)
	local announcement = ""

	if Managers.time:time("round") > 0 and local_player.spawn_data.state == "spawned" then
		announcement = "conquest_description"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeConquest:hud_score_text(team_name)
	return Managers.state.game_mode:num_owned_objectives(team_name)
end

function GameModeConquest:hud_progress(local_player)
	local own_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local own_score = Managers.state.team:team_by_name(own_team_name).score
	local enemy_score = Managers.state.team:team_by_name(enemy_team_name).score
	local total_score = own_score + enemy_score
	local center

	center = total_score == 0 and 0.5 or 0.5 + (own_score - enemy_score) / total_score * 0.5

	return 0, center, 1, true
end
