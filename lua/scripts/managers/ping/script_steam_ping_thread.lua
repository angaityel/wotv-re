-- chunkname: @scripts/managers/ping/script_steam_ping_thread.lua

require("scripts/network_lookup/network_lookup")

ScriptSteamPingThread = class(ScriptSteamPingThread)

function ScriptSteamPingThread:setup()
	local network_lobby = Managers.lobby
	local steam_client = network_lobby.client
	local steam_server = network_lobby.lobby

	if Managers.lobby.server then
		self._thread = SteamPingThread(steam_server)
	else
		self._thread = SteamPingThread(steam_client)
	end
end

function ScriptSteamPingThread:destroy()
	fassert(self._thread, "SteamPingThread has no thread open, check if initalized.")
	SteamPingThread.destroy(self._thread)
end

function ScriptSteamPingThread:add_peer(peer_id)
	fassert(self._thread, "SteamPingThread has no thread open, check if initalized.")
	SteamPingThread.add_peer(self._thread, peer_id)
end

function ScriptSteamPingThread:remove_peer(peer_id)
	fassert(self._thread, "SteamPingThread has no thread open, check if initalized.")
	SteamPingThread.remove_peer(self._thread, peer_id)
end

function ScriptSteamPingThread:ping(peer_id)
	fassert(self._thread, "SteamPingThread has no thread open, check if initalized.")

	return SteamPingThread.ping(self._thread, peer_id)
end
