-- chunkname: @scripts/menu/menu_callbacks/scoreboard_callbacks.lua

ScoreboardCallbacks = class(ScoreboardCallbacks)

function ScoreboardCallbacks:cb_game_mode_name()
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	return L(GameModeSettings[game_mode_key].display_name)
end
