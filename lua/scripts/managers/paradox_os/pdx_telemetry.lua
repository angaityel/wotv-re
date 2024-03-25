-- chunkname: @scripts/managers/paradox_os/pdx_telemetry.lua

require("scripts/managers/paradox_os/script_curl_token")

local function build_entry_string_start_game(entry)
	local entry_string = sprintf("{\"timestamp\": %q, \"event\": \"start_game\"}", entry.timestamp)

	return entry_string
end

local function build_entry_string_exit_game(entry)
	local entry_string = sprintf("{\"timestamp\": %q, \"event\": \"exit_game\"}", entry.timestamp)

	return entry_string
end

local function build_entry_string_meta(entry)
	local entry_string = sprintf("{\"timestamp\": %q, \"event\": \"meta\", ", entry.timestamp)

	for id, data in ipairs(entry.data) do
		local data_string = sprintf("%q: %q", data.key, data.value)

		if entry.data[id + 1] ~= nil then
			data_string = data_string .. ", "
		end

		entry_string = entry_string .. data_string
	end

	entry_string = entry_string .. "}"

	return entry_string
end

local function build_telemetry_data(events)
	local prefix = "["
	local suffix = "]"
	local data = ""

	for id, entry in ipairs(events) do
		local event_name = entry.event_name
		local entry_string = ""

		if event_name == "start_game" then
			entry_string = build_entry_string_start_game(entry)
		elseif event_name == "exit_game" then
			entry_string = build_entry_string_exit_game(entry)
		elseif event_name == "meta" then
			entry_string = build_entry_string_meta(entry)
		else
			ferror("Unsupported telemetry event: %q", event_name)
		end

		if events[id + 1] ~= nil then
			entry_string = entry_string .. ", "
		end

		data = data .. entry_string
	end

	return prefix .. data .. suffix
end

PdxTelemetry = class(PdxTelemetry)

local URL = GameSettingsDevelopment.paradox_telemetry_api

function PdxTelemetry:init()
	self._pdx_accounts_id = nil
	self._steam_id = nil
end

function PdxTelemetry:set_id(id)
	self._pdx_accounts_id = id
end

function PdxTelemetry:set_steam_id(id)
	self._steam_id = id
end

function PdxTelemetry:send_telemetry(events, callback)
	if self._pdx_accounts_id == nil then
		print("[PdxTelemetry] Tried sending telemetry without being logged in to a pdx account")

		return
	end

	local url = sprintf(URL, "wotv")
	local headers = "Content-Type: application/json"
	local telemetry_data = build_telemetry_data(events)
	local data = sprintf("{ \"userid\": %q, \"universe\": \"accounts\", \"game\": \"wotv %s\", \"steamid\": %q, \"data\": %s }", self._pdx_accounts_id, script_data.build_identifier or "???", Steam.user_id_int(), telemetry_data)
	local request_id = Curl.post(url, headers, data)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end

function PdxTelemetry:timestamp()
	return os.date("%Y-%m-%dT%X")
end

function PdxTelemetry:add_start_game_event()
	return {
		event_name = "start_game",
		timestamp = self:timestamp()
	}
end

function PdxTelemetry:add_exit_game_event()
	return {
		event_name = "exit_game",
		timestamp = self:timestamp()
	}
end

function PdxTelemetry:add_meta_event(...)
	local num_args = select("#", ...)

	fassert(num_args % 2 == 0, "Meta events only support a format of key/value. There is not an even amount of keys/values passed")
	fassert(num_args / 2 <= 3, "Meta events only supports 3 pairs of keys/values, you passed %q number of pairs", num_args / 2)

	local meta_pairs = {}

	for i = 1, num_args, 2 do
		meta_pairs[#meta_pairs + 1] = {
			key = select(i, ...),
			value = select(i + 1, ...)
		}
	end

	return {
		event_name = "meta",
		timestamp = self:timestamp(),
		data = meta_pairs
	}
end
