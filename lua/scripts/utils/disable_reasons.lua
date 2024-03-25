-- chunkname: @scripts/utils/disable_reasons.lua

local function table_is_empty(t)
	return next(t) == nil
end

DisableReasons = class(DisableReasons)

function DisableReasons:init()
	self.is_enabled = true
	self.disable_reasons = {}
end

function DisableReasons:disable(reason)
	local disable_reasons = self.disable_reasons
	local was_empty = table_is_empty(disable_reasons)

	if was_empty then
		self.is_enabled = false
	end

	disable_reasons[reason] = true

	return was_empty
end

function DisableReasons:enable(reason)
	local disable_reasons = self.disable_reasons

	disable_reasons[reason] = nil

	local is_empty = table_is_empty(disable_reasons)

	if is_empty then
		self.is_enabled = true
	end

	return is_empty
end
