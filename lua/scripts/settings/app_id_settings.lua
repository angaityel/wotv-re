-- chunkname: @scripts/settings/app_id_settings.lua

AppIDSettings = AppIDSettings or {}
AppIDSettings.app_ids = {
	alpha = 246190,
	main = 234530
}

local DLC = {
	shieldmaiden_dlc_helmet = 297560,
	early_access = 258450,
	berserk = 300140,
	premium = 259271,
	retail_bonus = 281981,
	coins_gift = 281980,
	vanguard = 292951,
	yogscast = 267620,
	beagle = 259270
}
local ALPHA_DLC = {
	shieldmaiden_dlc_helmet = 297560,
	early_access = 283222,
	berserk = 300140,
	premium = 283224,
	retail_bonus = 283221,
	coins_gift = 283220,
	vanguard = 292951,
	yogscast = 267620,
	beagle = 283223
}

if rawget(_G, "Steam") then
	local appid = Steam.app_id()

	if appid == AppIDSettings.app_ids.main then
		AppIDSettings.dlc = DLC
	elseif appid == AppIDSettings.app_ids.alpha then
		AppIDSettings.dlc = ALPHA_DLC
	else
		AppIDSettings.dlc = DLC
	end
else
	AppIDSettings.dlc = DLC
end
