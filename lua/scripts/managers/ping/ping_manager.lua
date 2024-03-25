-- chunkname: @scripts/managers/ping/ping_manager.lua

require("scripts/managers/ping/script_steam_ping_thread")

PingManager = class(PingManager)

local PING_SAMPLE_INTERVAL = 2
local PING_SAMPLES_MAX_SIZE = 10

function PingManager:init()
	self._peer_interval = {}
end

function PingManager:destroy()
	return
end

function PingManager:update(t)
	for player_index, player in pairs(Managers.player:players()) do
		self:_update_player(player, t)
	end
end

function PingManager:_update_player(player, t)
	if not player.remote or player.ai_player then
		return
	end

	local network_id = player:network_id()
	local peer_interval = self._peer_interval[network_id]

	if not peer_interval then
		self._peer_interval[network_id] = t + PING_SAMPLE_INTERVAL
	elseif peer_interval < t then
		self._peer_interval[network_id] = t + PING_SAMPLE_INTERVAL

		local ping = self:_ping_client(network_id)

		self:_set_ping(player, ping)
		self:_sync_mean_ping(player)

		if player.game_object_id then
			local last_ping = Network.ping(player:network_id())

			if last_ping > 0 then
				GameSession.set_game_object_field(Managers.state.network:game(), player.game_object_id, "last_ping", last_ping)
			end
		end
	end
end

function PingManager:_ping_client(network_id)
	fassert(nil, "Shouldn't reach here, please define '_ping_client' in your child class.")
end

function PingManager:_set_ping(player, ping)
	local ping_data = player.ping_data

	ping_data.ping_table_index = ping_data.ping_table_index % PING_SAMPLES_MAX_SIZE + 1
	ping_data.ping_table[ping_data.ping_table_index] = ping
	ping_data.mean_ping = self:_calculate_mean_ping(ping_data.ping_table)
end

function PingManager:_sync_mean_ping(player)
	if player.game_object_id then
		local mean_ping = math.clamp(player.ping_data.mean_ping, NetworkConstants.ping.min, NetworkConstants.ping.max)

		GameSession.set_game_object_field(Managers.state.network:game(), player.game_object_id, "ping", mean_ping)
	end
end

function PingManager:_calculate_mean_ping(ping_table)
	local ping_sum = 0

	for _, ping in ipairs(ping_table) do
		ping_sum = ping_sum + ping
	end

	return math.ceil(ping_sum / #ping_table * 1000)
end
