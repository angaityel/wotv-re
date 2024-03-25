-- chunkname: @scripts/managers/network/dedicated_server_init_network_manager.lua

require("scripts/network_lookup/network_lookup")

DedicatedServerInitNetworkManager = class(DedicatedServerInitNetworkManager)

local Lobby = LanLobbyStateMachine

function DedicatedServerInitNetworkManager:init(state, lobby)
	self._state = state
	self._lobby = lobby

	local meta = getmetatable(RPC)

	meta._old__index = meta.__index

	function meta.__index(t, k)
		local function func(peer, ...)
			if peer == Network.peer_id() then
				local network_manager = Managers.state.network

				network_manager[k](network_manager, peer, ...)
			else
				local meta = getmetatable(t)

				meta._old__index(t, k)(peer, ...)
			end
		end

		return func
	end

	setmetatable(RPC, meta)

	if self._lobby then
		Network.set_pong_timeout(GameSettingsDevelopment.network_timeout)
	end

	Managers.chat:register_chat_rpc_callbacks(self)

	self._notified_clients = {}
end

function DedicatedServerInitNetworkManager:rpc_notify_lobby_joined(sender)
	local is_dedicated = script_data.settings.dedicated_server

	self._notified_clients[sender] = true
end

function DedicatedServerInitNetworkManager:notified_clients(sender)
	return self._notified_clients
end

function DedicatedServerInitNetworkManager:start_server_game(game_start_countdown, level_key, game_mode_key, win_score, time_limit)
	for member, _ in pairs(self._notified_clients) do
		RPC.rpc_load_level(member, NetworkLookup.level_keys[level_key], NetworkLookup.game_mode_keys[game_mode_key], game_start_countdown, win_score, time_limit)
	end
end

function DedicatedServerInitNetworkManager:update(dt)
	Network.update(dt, self)
end

function DedicatedServerInitNetworkManager:destroy()
	return
end
