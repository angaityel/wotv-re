-- chunkname: @scripts/game_state/state_automatic_localhost_join.lua

StateAutomaticLocalhostJoin = class(StateAutomaticLocalhostJoin)

function StateAutomaticLocalhostJoin:on_enter()
	self:setup_state_context()

	local lobby_manager = Managers.lobby
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
		CommandWindow.print("Starting local client")
	end

	lobby_manager:refresh_lobby_browser()

	self._t = 0
	self._refresh_timer = 0
	self._refresh_delay = 2

	Managers.lobby:set_network_hash(Boot.loading_context.network_hash)
end

function StateAutomaticLocalhostJoin:update(dt)
	self._t = self._t + dt

	local lobby_manager = Managers.lobby

	lobby_manager:update(dt)
	Managers.state.network:update(dt)

	if lobby_manager.state == LobbyState.JOINED then
		if self._show_command_window then
			CommandWindow.print("    Joined Server")
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

			return loading_context.state
		end
	elseif lobby_manager.state == LobbyState.JOINING then
		-- block empty
	elseif self._refresh_timer < self._t then
		local lobbies = lobby_manager:lobby_browser_content()

		if #lobbies > 0 then
			for i, lobby in ipairs(lobbies) do
				if lobby.valid then
					lobby_manager:join_lobby(lobby.lobby_num)

					break
				end

				table.dump(lobby, "", 3)
			end

			if self._show_command_window then
				CommandWindow.print("    Lobby Found")
			end
		elseif self._show_command_window then
			CommandWindow.print("    No Lobbies Found")
		end

		self._refresh_timer = self._t + self._refresh_delay

		lobby_manager:refresh_lobby_browser()
	end
end

function StateAutomaticLocalhostJoin:on_exit()
	Managers.state:destroy()
end

function StateAutomaticLocalhostJoin:setup_state_context()
	Managers.state.network = MenuNetworkManager:new(self, Managers.lobby.lobby)
end
