-- chunkname: @scripts/managers/paradox_os/pdx_accounts.lua

require("scripts/managers/paradox_os/script_curl_token")
require("scripts/utils/sha256")
require("scripts/utils/base64")

PdxAccounts = class(PdxAccounts)

local URL = GameSettingsDevelopment.paradox_api
local KEY = GameSettingsDevelopment.paradox_api_key

function PdxAccounts:init()
	self._pdx_accounts_id = nil
end

function PdxAccounts:accounts_id()
	return self._pdx_accounts_id
end

function PdxAccounts:set_accounts_id(id)
	self._pdx_accounts_id = id
end

function PdxAccounts:create_account(email, password, callback)
	local url = sprintf(URL, "accounts")
	local password_hash = sha256(password .. KEY)
	local headers = "Content-Type: application/json"
	local data = sprintf("{ \"language\": %q, \"auth-method\": \"hawk\", \"email\": %q, \"sha256(password+salt)\": %q }", Steam:language(), email, password_hash)
	local request_id = Curl.post(url, headers, data)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end

function PdxAccounts:authenticate(email, password, callback)
	local url = sprintf(URL, "accounts/auth")
	local password_hash = sha256(password .. KEY)
	local email_hash = base64_encode(email)
	local headers = sprintf("Authorization: { \"hawkb64\": { \"email\": %q, \"sha256(password+salt)\": %q } }", email_hash, password_hash)
	local request_id = Curl.get(url, headers)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end

function PdxAccounts:get_profile(email, password, callback)
	local url = sprintf(URL, "accounts")
	local password_hash = sha256(password .. KEY)
	local header = sprintf("Authorization: { \"hawk\": { \"email\": %q, \"sha256(password+salt)\": %q } }", email, password_hash)
	local request_id = Curl.get(url, header)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end

function PdxAccounts:update_password(email, password, new_password, callback)
	local url = sprintf(URL, "accounts")
	local password_hash = sha256(password .. KEY)
	local headers = sprintf("Content-Type: application/json;Authorization: { \"hawk\": { \"email\": %q, \"sha256(password+salt)\": %q } }", email, password_hash)
	local new_password_hash = sha256(new_password .. KEY)
	local data = sprintf("\"new-sha256(password+salt)\": %q", new_password_hash)
	local request_id = Curl.put(url, headers, data)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end

function PdxAccounts:reset_password(email, callback)
	local url = sprintf(URL, "accounts/password-reset")
	local headers = "Content-Type: application/json"
	local data = sprintf("{ \"email\": %q }", email)
	local request_id = Curl.post(url, headers, data)
	local script_curl_token = ScriptCurlToken:new(request_id)

	Managers.token:register_token(script_curl_token, callback)
end
