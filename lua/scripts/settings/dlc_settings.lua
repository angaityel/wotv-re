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
	yogscast = app_id_check(AppIDSettings.dlc.yogscast),
	shieldmaiden_dlc_helmet = app_id_check(AppIDSettings.dlc.shieldmaiden_dlc_helmet),
	premium = app_id_check(AppIDSettings.dlc.premium),
	beagle = app_id_check(AppIDSettings.dlc.beagle),
	early_access = app_id_check(AppIDSettings.dlc.early_access),
	vanguard = app_id_check(AppIDSettings.dlc.vanguard),
	berserk = app_id_check(AppIDSettings.dlc.berserk),
	premium_or_beagle = function()
		return app_id_check(AppIDSettings.dlc.premium)() or app_id_check(AppIDSettings.dlc.beagle)()
	end,
	coins_gift = app_id_check(AppIDSettings.dlc.coins_gift),
	coins_retail_bonus = app_id_check(AppIDSettings.dlc.retail_bonus)
}
