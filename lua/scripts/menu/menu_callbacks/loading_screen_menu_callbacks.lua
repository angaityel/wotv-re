-- chunkname: @scripts/menu/menu_callbacks/loading_screen_menu_callbacks.lua

LoadingScreenMenuCallbacks = class(LoadingScreenMenuCallbacks)

function LoadingScreenMenuCallbacks:init(menu_state)
	self._menu_state = menu_state
end

function LoadingScreenMenuCallbacks:cb_game_data()
	local loading_context = self._menu_state.parent.loading_context
	local data = {
		level = loading_context.level_key,
		game_mode = loading_context.game_mode_key
	}

	return data
end

function LoadingScreenMenuCallbacks:cb_battle_report_music_parameters()
	local loading_context = self._menu_state.parent.loading_context

	return "result", loading_context.local_player_won and "win" or "lose", "team", loading_context.local_player_team
end

function LoadingScreenMenuCallbacks:cb_game_mode_name()
	local loading_context = self._menu_state.parent.loading_context

	return L(GameModeSettings[loading_context.last_level_game_mode].display_name)
end

function LoadingScreenMenuCallbacks:cb_level_texture()
	local loading_context = self._menu_state.parent.loading_context

	return LevelSettings[loading_context.last_level_id].loading_background or "loading_screen_wip"
end
