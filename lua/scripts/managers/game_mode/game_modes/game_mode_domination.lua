-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_domination.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

GameModeDomination = class(GameModeDomination, GameModeBase)

function GameModeDomination:init(settings, world, ...)
	GameModeDomination.super.init(self, settings, world, ...)

	self._side_domination_status = {
		attackers = {
			dominating = false,
			timer = math.huge
		},
		defenders = {
			dominating = false,
			timer = math.huge
		}
	}

	local event_manager = Managers.state.event

	event_manager:register(self, "gm_event_side_dominating", "gm_event_side_dominating")
	event_manager:register(self, "gm_event_objective_captured", "gm_event_objective_captured")

	self._start_score = settings.start_score
end

function GameModeDomination:gm_event_side_dominating(side, dominating)
	if Managers.lobby.server then
		local status = self._side_domination_status[side]
		local team = Managers.state.team:team_by_side(side)
		local game = Managers.state.network:game()

		if game then
			GameSession.set_game_object_field(game, team.game_object_id, "dominating", dominating)
		end

		if dominating then
			local domination_time = Managers.time:time("round") + self._settings.domination_timer

			status.dominating = true
			status.timer = domination_time

			if game then
				GameSession.set_game_object_field(game, team.game_object_id, "domination_time", domination_time)
			end
		else
			status.dominating = false
			status.timer = math.huge

			if game then
				GameSession.set_game_object_field(game, team.game_object_id, "domination_time", -1)
			end
		end
	end

	if dominating then
		Managers.state.event:trigger("conquest_announcement", "domination_win_by_domination_imminent", Managers.state.team:team_by_side(side))
	end
end

function GameModeDomination:start_score()
	return self._start_score
end

function GameModeDomination:win_scale()
	local team_manager = Managers.state.team
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		for _, side in pairs(team_manager:sides()) do
			local team = team_manager:team_by_side(side)

			if team.game_object_id and GameSession.game_object_field(game, team.game_object_id, "dominating") then
				return 1
			end
		end
	end

	local score = 1
	local team_manager = Managers.state.team

	for _, side in pairs(team_manager:sides()) do
		local team = team_manager:team_by_side(side)

		score = math.min(score, team.score)
	end

	local win_scale = math.clamp(score / self._start_score, 0, 1)

	return 1 - win_scale
end

function GameModeDomination:evaluate_end_conditions()
	local team_manager = Managers.state.team
	local red_team = team_manager:team_by_name("red")
	local white_team = team_manager:team_by_name("white")

	if not red_team or not white_team then
		return
	end

	local round_time = Managers.time:time("round")

	for side, status in pairs(self._side_domination_status) do
		if round_time > status.timer then
			local winning = Managers.state.team:team_by_side(side)
			local losing = Managers.state.team:team_by_side(side == "defenders" and "attackers" or "defenders")

			losing:set_score(0)

			return true, winning
		end
	end

	local start_score = self._start_score
	local time_limit = self._time_limit
	local score_limit_reached = red_team.score <= 0 or white_team.score <= 0
	local time_limit_reached = time_limit and time_limit <= round_time

	if score_limit_reached or time_limit_reached then
		if math.ceil(red_team.score) > math.ceil(white_team.score) then
			return true, red_team
		elseif math.ceil(white_team.score) > math.ceil(red_team.score) then
			return true, white_team
		else
			return true, false
		end
	end

	return false, false
end

function GameModeDomination:gm_event_objective_captured(capturing_player, captured_unit, previous_owner, no_previous_cap)
	if not capturing_player.team or not Unit.alive(captured_unit) then
		return
	end

	local player_manager = Managers.player
	local local_player = player_manager:player_exists(1) and player_manager:player(1)

	if local_player and local_player.team and local_player.team.side and capturing_player.team.side and local_player.team.side ~= capturing_player.team.side and no_previous_cap then
		return
	end

	local interacted = Unit.get_data(captured_unit, "hud", "ui_interacted")
	local objective_name = Unit.get_data(captured_unit, "hud", "ui_name")

	Managers.state.event:trigger("conquest_announcement", "domination_captured_objective", capturing_player.team, objective_name)
end

function GameModeDomination:objective(local_player)
	return ""
end

function GameModeDomination:own_score_announcement(local_player)
	local announcement = ""
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local enemy_team = Managers.state.team:team_by_name(enemy_team_name)
	local enemy_score = enemy_team.score
	local own_score = local_player.team.score
	local game = Managers.state.network:game()
	local dominating, domination_time
	local round_time = Managers.time:time("round")

	if round_time and game and enemy_team.game_object_id then
		dominating = GameSession.game_object_field(game, enemy_team.game_object_id, "dominating")
		domination_time = GameSession.game_object_field(game, enemy_team.game_object_id, "domination_time")
	end

	if own_score / self._start_score <= 0.1 and own_score < enemy_score or dominating and domination_time - round_time < 10 then
		announcement = "domination_losing"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeDomination:game_mode_description_announcement(local_player)
	local announcement = ""

	if Managers.time:time("round") > 0 and local_player.spawn_data.state == "spawned" then
		announcement = "domination_description"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeDomination:enemy_score_announcement(local_player)
	local local_team = local_player.team
	local enemy_team_name = local_team.name == "red" and "white" or "red"
	local enemy_score = Managers.state.team:team_by_name(enemy_team_name).score
	local announcement = ""
	local game = Managers.state.network:game()
	local dominating, domination_time
	local round_time = Managers.time:time("round")

	if round_time and game and local_team.game_object_id then
		dominating = GameSession.game_object_field(game, local_team.game_object_id, "dominating")
		domination_time = GameSession.game_object_field(game, local_team.game_object_id, "domination_time")
	end

	if enemy_score / self._start_score <= 0.1 and enemy_score < local_player.team.score or dominating and domination_time - round_time < 10 then
		announcement = "domination_winning"
	end

	local param1, param2 = GameModeHelper:announcement_parameters(announcement, local_player, self._world)

	return announcement, param1, param2
end

function GameModeDomination:own_capture_point_announcement(local_player)
	return ""
end

function GameModeDomination:enemy_capture_point_announcement(local_player)
	return ""
end

function GameModeDomination:hud_score_text(team_name)
	return Managers.state.game_mode:num_owned_objectives(team_name)
end

function GameModeDomination:hud_progress(local_player)
	local own_team_name = local_player.team.name
	local enemy_team_name = local_player.team.name == "red" and "white" or "red"
	local own_score = Managers.state.team:team_by_name(own_team_name).score
	local enemy_score = Managers.state.team:team_by_name(enemy_team_name).score
	local total_score = own_score + enemy_score
	local center

	center = total_score == 0 and 0.5 or 0.5 + (own_score - enemy_score) / total_score * 0.5

	return 0, center, 1, true
end
