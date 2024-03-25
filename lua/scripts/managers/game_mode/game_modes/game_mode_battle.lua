﻿-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_battle.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

GameModeBattle = class(GameModeBattle, GameModeBase)

function GameModeBattle:init(settings, world, ...)
	GameModeBattle.super.init(self, settings, world, ...)
	Managers.state.event:register(self, "gm_event_battle_tiebreak", "gm_event_battle_tiebreak")
	Managers.state.event:register(self, "gm_event_objective_captured", "event_objective_captured")

	self._spawned = false
	self._tie_break_objective_captured_by = nil
end

function GameModeBattle:_allowed_spawns_spawn_owner(team)
	return self._spawned and 0 or 1
end

function GameModeBattle:spawned()
	self._spawned = true
end

function GameModeBattle:custom_spawning(settings)
	return BattleSpawning:new(settings, self)
end

function GameModeBattle:_team_alive(members)
	local alive = false

	for _, player in pairs(members) do
		local unit = player.player_unit
		local damage_ext = Unit.alive(unit) and ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")

		if damage_ext and damage_ext:is_alive() then
			alive = true
		end
	end

	return alive
end

function GameModeBattle:evaluate_end_conditions()
	local round_timer = Managers.time:time("round")

	if not self._spawned or round_timer < 3 then
		return
	end

	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if not red_team or not white_team then
		return
	end

	local red_alive, white_alive

	red_alive = self:_team_alive(red_team.members)
	white_alive = self:_team_alive(white_team.members)

	local end_of_round_only = true
	local time_limit = self._time_limit
	local time_limit_reached = time_limit and time_limit <= round_timer

	if not white_alive and not red_alive then
		return true, false, end_of_round_only
	elseif not white_alive then
		red_team:give_score(1)

		end_of_round_only = red_team.score < self._win_score

		self:_kill_alive(white_team)

		return true, red_team, end_of_round_only
	elseif not red_alive then
		white_team:give_score(1)

		end_of_round_only = white_team.score < self._win_score

		self:_kill_alive(red_team)

		return true, white_team, end_of_round_only
	elseif self._tie_break_objective_captured_by then
		local winning_team = self._tie_break_objective_captured_by == "red" and red_team or white_team
		local losing_team = self._tie_break_objective_captured_by == "red" and white_team or red_team

		winning_team:give_score(1)

		end_of_round_only = winning_team.score < self._win_score

		return true, winning_team, end_of_round_only
	else
		if time_limit_reached and not self._tie_break_started then
			Managers.state.game_mode:trigger_event("battle_tiebreak")

			local level = LevelHelper:current_level(self._world)

			Level.trigger_event(level, "battle_tiebreak")

			local network_manager = Managers.state.network

			network_manager:send_rpc_clients("rpc_battle_tiebreak")
		end

		return false, false, end_of_round_only
	end
end

function GameModeBattle:_kill_alive(team)
	for _, player in pairs(team.members) do
		local unit = player.player_unit
		local damage_ext = Unit.alive(unit) and ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")

		if damage_ext and not damage_ext:is_dead() then
			if damage_ext:is_knocked_down() then
				damage_ext:yield()
			else
				damage_ext:die(player, nil, true)
			end
		end
	end
end

function GameModeBattle:event_objective_captured(player, objective_unit)
	local team_name = player.team.name

	self._tie_break_objective_captured_by = team_name
end

function GameModeBattle:gm_event_battle_tiebreak()
	self._tie_break_started = true
end

function GameModeBattle:objective(local_player)
	if local_player.spawn_data.state ~= "spawned" then
		return "", nil, nil
	end

	local objective = ""
	local tagged_player_unit = GameModeHelper:player_unit_tagged_by_own_squad_corporal(local_player)

	if tagged_player_unit and self._settings.tagging_objectives then
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
	elseif self._tie_break_started then
		objective = "pitched_battle_tiebreak_objective"
	end

	local param1, param2 = GameModeHelper:objective_parameters(objective, local_player, self._world)

	return objective, param1, param2
end

function GameModeBattle:own_score_announcement(local_player)
	local announcement = ""
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeBattle:enemy_score_announcement(local_player)
	local announcement = ""
	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeBattle:game_mode_description_announcement(local_player)
	local announcement = ""
	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if red_team and white_team and Managers.time:time("round") > 0 then
		local first_round = red_team.score == 0 and white_team.score == 0 and true or false

		if first_round and local_player.spawn_data.state == "spawned" then
			local game_mode_key = Managers.state.game_mode:game_mode_key()

			announcement = game_mode_key == "arena" and "arena_description" or "battle_description"
		end
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeBattle:last_man_standing_announcement(local_player)
	local announcement = ""
	local unit = local_player.player_unit
	local damage_ext = Unit.alive(unit) and ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")
	local round_timer = Managers.time:time("round")

	if damage_ext and damage_ext:is_alive() and round_timer > 3 then
		local local_player_team = local_player.team
		local num_players_alive_in_team = self:_num_players_alive(local_player_team)

		if num_players_alive_in_team == 1 then
			announcement = "pitched_battle_last_man_standing"
		end
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeBattle:_num_players_alive(team)
	local num_players_alive = 0
	local members = team.members

	for _, player in pairs(members) do
		local unit = player.player_unit
		local damage_ext = Unit.alive(unit) and ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")

		if damage_ext and damage_ext:is_alive() then
			num_players_alive = num_players_alive + 1
		end
	end

	return num_players_alive
end

function GameModeBattle:hud_score_text(team_name)
	return Managers.state.team:team_by_name(team_name).score
end

function GameModeBattle:hud_progress(local_player)
	local own_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local own_score = Managers.state.team:team_by_name(own_team_name).score
	local enemy_score = Managers.state.team:team_by_name(enemy_team_name).score
	local win_score = self._win_score
	local left = (1 - own_score / win_score) * 0.5
	local center = 0.5
	local right = (1 + enemy_score / win_score) * 0.5

	return left, center, right, false
end
