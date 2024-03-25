-- chunkname: @scripts/managers/paradox_os/pdx_accounts_offline.lua

require("scripts/managers/paradox_os/script_curl_token")
require("scripts/utils/sha256")

PdxAccountsOffline = class(PdxAccountsOffline)

local URL = GameSettingsDevelopment.paradox_api
local KEY = GameSettingsDevelopment.paradox_api_key

function PdxAccountsOffline:init()
	self._pdx_accounts_id = nil
end

function PdxAccountsOffline:accounts_id()
	return self._pdx_accounts_id
end

function PdxAccountsOffline:set_accounts_id(id)
	self._pdx_accounts_id = id
end

function PdxAccountsOffline:create_account(email, password, callback)
	local info = {
		body = "{\"result\":\"OK\", \"id\":\"0\"}"
	}

	callback(info)
end

function PdxAccountsOffline:authenticate(email, password, callback)
	local info = {
		body = "{\"result\":\"OK\", \"id\":\"0\"}"
	}

	callback(info)
end

function PdxAccountsOffline:get_profile(email, password, callback)
	callback({})
end

function PdxAccountsOffline:update_password(email, password, new_password, callback)
	callback({})
end

function PdxAccountsOffline:reset_password(email, callback)
	callback({})
end
