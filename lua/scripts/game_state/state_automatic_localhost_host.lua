-- chunkname: @scripts/game_state/state_automatic_localhost_host.lua

StateAutomaticLocalhostHost = class(StateAutomaticLocalhostHost)

function StateAutomaticLocalhostHost:on_enter()
	self:setup_state_context()

	local args = {
		Application.argv()
	}

	self._show_command_window = false

	for i = 1, #args do
		if args[i] == "-no-rendering" then
			self._show_command_window = true

			break
		end
	end

	if self._show_command_window then
		CommandWindow.open(Postman._localhost_window_name())
		CommandWindow.print("Starting local server")
	end

	self._game_hosted = false

	Managers.lobby:set_network_hash(Boot.loading_context.network_hash)
	Managers.lobby:create_lobby(callback(self, "cb_lobby_created"))
end

function StateAutomaticLocalhostHost:cb_lobby_created()
	local loading_context = self.parent.loading_context

	Managers.lobby:set_server(true)

	local level = loading_context.level_key
	local game_mode = loading_context.game_mode_key
	local win_score = loading_context.win_score
	local time_limit = loading_context.time_limit

	Managers.lobby:set_lobby_data("lobby_name", Managers.lobby.lobby_name)
	Managers.lobby:set_lobby_data("level_key", level)
	Managers.lobby:set_lobby_data("game_mode_key", game_mode)
	Managers.lobby:set_lobby_data("win_score", win_score)
	Managers.lobby:set_lobby_data("time_limit", time_limit)
	Managers.state.network:start_server_game(level, game_mode, win_score, time_limit)
	Managers.lobby:set_lobby_data("game_started", "true")

	self._game_hosted = true
end

function StateAutomaticLocalhostHost:update(dt)
	Managers.lobby:update(dt)
	Managers.state.network:update(dt)

	if self._game_hosted then
		if self._show_command_window then
			CommandWindow.print("Server Started")
			CommandWindow.print(Managers.lobby.lobby_name)
		end

		local drop_in_settings = Managers.state.network:drop_in_settings()

		if drop_in_settings then
			local loading_context = {}

			loading_context.state = StateLoading
			loading_context.level_key = drop_in_settings.level_key
			loading_context.game_mode_key = drop_in_settings.game_mode_key
			loading_context.level_cycle = drop_in_settings.level_cycle
			loading_context.time_limit = drop_in_settings.time_limit
			loading_context.win_score = drop_in_settings.win_score
			loading_context.level_cycle_count = drop_in_settings.level_cycle_count
			loading_context.game_start_countdown = drop_in_settings.game_start_countdown
			self.parent.loading_context = loading_context

			if Managers.lobby.lobby.request_data then
				Managers.lobby.lobby:request_data()
			end

			return loading_context.state
		end
	end
end

function StateAutomaticLocalhostHost:on_exit()
	Managers.state:destroy()
end

function StateAutomaticLocalhostHost:setup_state_context()
	Managers.state.network = MenuNetworkManager:new(self, Managers.lobby.lobby)
end
