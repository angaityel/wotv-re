-- chunkname: @scripts/managers/paradox_os/script_curl_token.lua

ScriptCurlToken = class(ScriptCurlToken)

function ScriptCurlToken:init(request_id)
	self._info = {}
	self._request_id = request_id
	self._name = "ScriptCurlToken"
end

function ScriptCurlToken:name()
	return self._name
end

function ScriptCurlToken:info()
	return self._info
end

function ScriptCurlToken:update()
	self._info = Curl.progress(self._request_id)
end

function ScriptCurlToken:done()
	return self._info.done
end

function ScriptCurlToken:close()
	Curl.close(self._request_id)
end
