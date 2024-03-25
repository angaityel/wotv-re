-- chunkname: @scripts/managers/paradox_os/pdx_telemetry_offline.lua

require("scripts/managers/paradox_os/script_curl_token")

PdxTelemetryOffline = class(PdxTelemetryOffline)

local URL = GameSettingsDevelopment.paradox_telemetry_api

function PdxTelemetryOffline:init()
	return
end

function PdxTelemetryOffline:set_id(id)
	return
end

function PdxTelemetryOffline:set_steam_id(id)
	return
end

function PdxTelemetryOffline:send_telemetry(events, callback)
	callback({})
end

function PdxTelemetryOffline:timestamp()
	return "0-0-0T0:0:0"
end

function PdxTelemetryOffline:add_start_game_event()
	return {}
end

function PdxTelemetryOffline:add_exit_game_event()
	return {}
end

function PdxTelemetryOffline:add_meta_event(...)
	return {}
end
