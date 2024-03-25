-- chunkname: @scripts/managers/ping/lan_ping_manager.lua

require("scripts/managers/ping/ping_manager")

LANPingManager = class(LANPingManager, PingManager)

function LANPingManager:_ping_client(network_id)
	return Network.ping(network_id)
end
