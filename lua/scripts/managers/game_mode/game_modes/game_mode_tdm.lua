-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_tdm.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

GameModeTDM = class(GameModeTDM, GameModeBase)

function GameModeTDM:init(settings, world, ...)
	GameModeTDM.super.init(self, settings, world, ...)

	self._tdm_spawn_mode = {
		point = true
	}
	self._allowed_spawn_modes = {
		squad_point = true
	}
	self._team_in_lead = nil
	self._team_lead_timer = -math.huge
end

function GameModeTDM:evaluate_end_conditions()
	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if not red_team or not white_team then
		return
	end

	local win_score = self._win_score
	local time_limit = self._time_limit
	local score_limit_reached = win_score <= red_team.score or win_score <= white_team.score
	local time_limit_reached = time_limit and time_limit <= Managers.time:time("round")

	if score_limit_reached or time_limit_reached then
		if red_team.score > white_team.score then
			return true, red_team
		elseif white_team.score > red_team.score then
			return true, white_team
		else
			return true, false
		end
	end

	return false, false
end

function GameModeTDM:allowed_spawn_modes(player)
	if Managers.time:time("round") > 0 then
		return self._tdm_spawn_mode
	else
		return self._allowed_spawn_modes
	end
end

function GameModeTDM:objective(local_player)
	if local_player.spawn_data.state ~= "spawned" then
		return "", nil, nil
	end

	local objective = ""
	local tagged_player_unit = GameModeHelper:player_unit_tagged_by_own_squad_corporal(local_player)

	if tagged_player_unit and self._settings.tagging_objectives then
		local damage_ext = ScriptUnit.extension(tagged_player_unit, "damage_system")
		local tagged_player = Managers.player:owner(tagged_player_unit)

		objective = tagged_player.team == local_player.team and (damage_ext._knocked_down and "revive_tagged_team_member" or "defend_tagged_team_member") or damage_ext._knocked_down and "execute_tagged_enemy" or "kill_tagged_enemy"
	end

	local param1, param2 = GameModeHelper:objective_parameters(objective, local_player, self._world)

	return objective, param1, param2
end

function GameModeTDM:own_score_announcement(local_player)
	local announcement = ""
	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if not red_team or not white_team or not local_player.team or local_player.team.name == "unassigned" then
		return announcement
	end

	local red_score = red_team.score
	local white_score = white_team.score
	local win_score = self._win_score
	local time_limit = self._time_limit
	local critical_settings = self._settings.score_announcement.critical_mode
	local round_time = Managers.time:time("round")
	local time_limit_close = time_limit and round_time > time_limit - critical_settings.time_left
	local score_threshold = win_score * critical_settings.score_fraction
	local score_limit_close = score_threshold < red_score or score_threshold < white_score
	local critical_mode = time_limit_close or score_limit_close
	local leading_team

	if white_score < red_score then
		leading_team = "red"
	elseif red_score < white_score then
		leading_team = "white"
	end

	local local_team = local_player.team.name

	if leading_team == self._team_in_lead then
		self:_set_team_lead_timer(round_time)
	elseif critical_mode and leading_team and leading_team ~= self._team_in_lead then
		announcement = self:_change_score_announcement(local_team, leading_team, round_time)
	elseif not critical_mode and leading_team and leading_team ~= self._team_in_lead and round_time > self._team_lead_timer then
		announcement = self:_change_score_announcement(local_team, leading_team, round_time)
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeTDM:_change_score_announcement(local_team_name, leading_team_name, round_time)
	self:_set_team_lead_timer(round_time)

	self._team_in_lead = leading_team_name

	if local_team_name == leading_team_name then
		return "tdm_taken_the_lead"
	else
		return "tdm_lost_the_lead"
	end
end

function GameModeTDM:_set_team_lead_timer(round_time)
	self._team_lead_timer = round_time + self._settings.score_announcement.announcement_delay
end

function GameModeTDM:enemy_score_announcement(local_player)
	local announcement = ""
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeTDM:game_mode_description_announcement(local_player)
	local announcement = ""

	if Managers.time:time("round") > 0 and local_player.spawn_data.state == "spawned" then
		announcement = "team_deathmatch_description"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeTDM:time_announcement(local_player)
	local announcement, param1, param2 = GameModeTDM.super.time_announcement(self, local_player)

	if announcement == "" then
		local round_time = Managers.time:time("round")
		local time_limit = self._time_limit

		if round_time > time_limit - 31 then
			announcement = "tdm_time_running_out"
			param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)
		end
	end

	return announcement, param1, param2
end

function GameModeTDM:hud_score_text(team_name)
	return Managers.state.team:team_by_name(team_name).score
end

function GameModeTDM:hud_progress(local_player)
	local own_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local own_score = Managers.state.team:team_by_name(own_team_name).score
	local enemy_score = Managers.state.team:team_by_name(enemy_team_name).score
	local win_score = self._win_score
	local left = 0.5 - own_score / win_score * 0.5
	local center = 0.5
	local right = 0.5 + enemy_score / win_score * 0.5

	return left, center, right, false
end
