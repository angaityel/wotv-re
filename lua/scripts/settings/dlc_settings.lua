-- chunkname: @scripts/settings/dlc_settings.lua

require("scripts/settings/app_id_settings")

local function app_id_check(app_id)
	if rawget(_G, "Steam") then
		return function()
			return Steam.is_installed(app_id)
		end
	else
		return function()
			return false
		end
	end
end

DLCSettings = {
	brian_blessed = function()
		return true
	end,
	full_game = function()
		return true
	end,
	yogscast = function()
		return true
	end,
	shieldmaiden_dlc_helmet = function()
		return true
	end,
	premium = function()
		return true
	end,
	beagle = function()
		return true
	end,
	early_access = function()
		return true
	end,
	vanguard = function()
		return true
	end,
	berserk = function()
		return true
	end,
	premium_or_beagle = function()
		return true
	end,
	coins_gift = function()
		return true
	end,
	coins_retail_bonus = function()
		return true
	end
}
