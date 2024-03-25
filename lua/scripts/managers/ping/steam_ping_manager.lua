-- chunkname: @scripts/managers/ping/steam_ping_manager.lua

require("scripts/managers/ping/ping_manager")

SteamPingManager = class(SteamPingManager, PingManager)

function SteamPingManager:init()
	self._steam_ping = ScriptSteamPingThread:new()

	self._steam_ping:setup()

	if Managers.lobby.server then
		Managers.state.event:register(self, "remote_player_created", "event_player_created")
		Managers.state.event:register(self, "remote_player_destroyed", "event_player_destroyed")
	end

	SteamPingManager.super.init(self)
end

function SteamPingManager:destroy()
	self._steam_ping:destroy()
end

function SteamPingManager:event_player_created(player)
	self._steam_ping:add_peer(player:network_id())
end

function SteamPingManager:event_player_destroyed(player)
	self._steam_ping:remove_peer(player:network_id())
end

function SteamPingManager:_ping_client(network_id)
	return self._steam_ping:ping(network_id)
end
