-- chunkname: @scripts/managers/save/save_data.win32.lua

local steam = rawget(_G, "Steam")
local branch_name = steam and steam.branch_name()

if not script_data.settings.content_revision then
	SaveFileName = "save_data_trunk"
elseif branch_name == "save_test" then
	SaveFileName = "save_data_test"
elseif branch_name then
	SaveFileName = "save_data_branch_" .. branch_name
elseif GameSettingsDevelopment.dev_build then
	SaveFileName = "save_data_dev_build"
else
	SaveFileName = "save_data_test"
end

printf("Save system using save name %q.", SaveFileName)

SaveData = SaveData or {
	player_data_version = 7,
	controls_version = 12,
	profiles_version = 150,
	version = 5,
	player_coat_of_arms_version = 10,
	user_data = {}
}
RESET_SAVE_DATA = false

function create_save_data(save_data)
	local user_id

	if rawget(_G, "Steam") then
		user_id = Steam.user_id()
	else
		user_id = "dev_user"
	end

	save_data.user_data = save_data.user_data or {}
	save_data.user_data[user_id] = save_data.user_data[user_id] or {}

	local user_data = save_data.user_data[user_id]

	user_data.profiles_version = save_data.profiles_version
	user_data.player_coat_of_arms_version = save_data.player_coat_of_arms_version

	populate_player_profiles_from_save(user_data)
	populate_player_controls_from_save(save_data)
	populate_player_coat_of_arms_from_save(user_data)
	populate_player_data_from_save(save_data)
end

function populate_save_data(save_data)
	if SaveData.version ~= save_data.version or RESET_SAVE_DATA then
		print("Wrong version for save file, saved: ", save_data.version, " current: ", SaveData.version)

		save_data = SaveData
	end

	if SaveData.controls_version ~= save_data.controls_version then
		save_data.controls = nil

		print("Wrong controls_version for save file, saved: ", save_data.controls_version, " current: ", SaveData.controls_version)

		save_data.controls_version = SaveData.controls_version
	end

	if SaveData.player_data_version ~= save_data.player_data_version then
		save_data.player_data = nil

		print("Wrong player_data_version for save file, saved: ", save_data.player_data_version, " current: ", SaveData.player_data_version)

		save_data.player_data_version = SaveData.player_data_version
	end

	local user_id

	if rawget(_G, "Steam") then
		user_id = Steam.user_id()
	else
		user_id = "dev_user"
	end

	save_data.user_data = save_data.user_data or {}
	save_data.user_data[user_id] = save_data.user_data[user_id] or {}

	local user_data = save_data.user_data[user_id]

	if SaveData.profiles_version ~= user_data.profiles_version then
		user_data.profiles = nil

		print("Wrong profiles_version for save file, saved: ", user_data.profiles_version, " current: ", SaveData.profiles_version)

		user_data.profiles_version = SaveData.profiles_version
		save_data.profiles_version = SaveData.profiles_version
	end

	if SaveData.player_coat_of_arms_version ~= user_data.player_coat_of_arms_version then
		user_data.player_coat_of_arms = nil

		print("Wrong player_coat_of_arms for save file, saved: ", user_data.player_coat_of_arms_version, " current: ", SaveData.player_coat_of_arms_version)

		user_data.player_coat_of_arms_version = SaveData.player_coat_of_arms_version
		save_data.player_coat_of_arms_version = SaveData.player_coat_of_arms_version
	end

	populate_player_profiles_from_save(user_data)
	populate_player_controls_from_save(save_data)
	populate_player_coat_of_arms_from_save(user_data)
	populate_player_data_from_save(save_data)

	SaveData = save_data
end
