-- chunkname: @scripts/menu/menu_callbacks/ingame_menu_callbacks.lua

IngameMenuCallbacks = class(IngameMenuCallbacks)

function IngameMenuCallbacks:init(game_state)
	self._game_state = game_state
end

function IngameMenuCallbacks:cb_leave_game()
	if not EDITOR_LAUNCH then
		self._game_state.parent.exit_to_menu = true

		self._game_state:ingame_menu():set_active(false)
	end
end

function IngameMenuCallbacks:cb_return_to_battle()
	self._game_state:ingame_menu():set_active(false)
end

function IngameMenuCallbacks:cb_master_volumes()
	local options, index = SoundHelper.sound_volume_options("master_volume")

	return options, index
end

function IngameMenuCallbacks:cb_master_volume_changed(option)
	Application.set_user_setting("master_volume", option.key)
	Application.save_user_settings()
	Timpani.set_bus_volume("Master Bus", option.key)
end

function IngameMenuCallbacks:cb_voice_over_volume_changed(option)
	Application.set_user_setting("voice_over", option.key)
	Application.save_user_settings()
	Timpani.set_bus_volume("voice_over", option.key)
end

function IngameMenuCallbacks:cb_voice_over_volumes()
	local options, index = SoundHelper.sound_volume_options("voice_over")

	return options, index
end

function IngameMenuCallbacks:cb_music_volumes()
	local options, index = SoundHelper.sound_volume_options("music_volume")

	return options, index
end

function IngameMenuCallbacks:cb_music_volume_changed(option)
	Application.set_user_setting("music_volume", option.key)
	Application.save_user_settings()
	Timpani.set_bus_volume("music", option.key)
end

function IngameMenuCallbacks:cb_sfx_volumes()
	local options, index = SoundHelper.sound_volume_options("sfx_volume")

	return options, index
end

function IngameMenuCallbacks:cb_sfx_volume_changed(option)
	Application.set_user_setting("sfx_volume", option.key)
	Application.save_user_settings()
	Timpani.set_bus_volume("sfx", option.key)
	Timpani.set_bus_volume("special", option.key)
end

function IngameMenuCallbacks:cb_profile_viewer_world_name()
	return "level_world"
end

function IngameMenuCallbacks:cb_profile_viewer_viewport_name(local_player)
	return local_player.viewport_name
end

function IngameMenuCallbacks:cb_outfit_editor_highlight_item()
	return "goto_select_team_button"
end

function IngameMenuCallbacks:cb_goto_select_team_disabled()
	return Managers.time:time("round") < GameSettingsDevelopment.exit_ingame_character_editor_round_time
end

function IngameMenuCallbacks:cb_team_selection_highlight_item()
	local controller_active = Managers.input:pad_active(1)

	if controller_active then
		return nil
	else
		return "auto_join_team_button"
	end
end

function IngameMenuCallbacks:cb_set_banner_material_variation(material_variation)
	local banner_unit = self._game_state._ingame_menu:menu_banner_unit()

	if banner_unit then
		Unit.set_material_variation(banner_unit, material_variation)
	end
end

function IngameMenuCallbacks:cb_character_profiles_options()
	local options = {}

	for i, config in ipairs(PlayerProfiles) do
		options[#options + 1] = {
			key = i,
			value = config.display_name
		}
	end

	return options
end

function IngameMenuCallbacks:cb_profile_selected()
	self._game_state:ingame_menu():set_active(false)
end

function IngameMenuCallbacks:cb_character_profile_highlight_item()
	return "select_spawnpoint_button"
end

function IngameMenuCallbacks:cb_character_profile_selected_option()
	return self._game_state.player.state_data.spawn_profile or Application.win32_user_setting("character_selection_profile") or 1
end

function IngameMenuCallbacks:cb_select_character_cancelled()
	if self._game_state.player.state_data.spawn_profile then
		self._game_state:ingame_menu():set_active(false)
	else
		self._game_state:ingame_menu():goto("select_team")
	end
end

function IngameMenuCallbacks:cb_select_character_ingame_cancelled()
	return
end

function IngameMenuCallbacks:cb_select_spawnpoint_highlight_item()
	return "spawn_button"
end

function IngameMenuCallbacks:cb_select_spawnpoint_disabled()
	local state = self._game_state.player.spawn_data.state

	return state ~= "dead" and state ~= "not_spawned" and state ~= "ghost_mode"
end

function IngameMenuCallbacks:cb_game_data()
	local loading_context = self._game_state.parent.loading_context
	local data = {
		level = Managers.state.game_mode:level_key(),
		game_mode = Managers.state.game_mode:game_mode_key(),
		spawn_profile = self._game_state.player.state_data.spawn_profile
	}

	return data
end

function IngameMenuCallbacks:cb_goto(page_id)
	self._game_state:ingame_menu():goto(page_id)
end

function IngameMenuCallbacks:cb_cancel_to(page_id)
	self._game_state:ingame_menu_cancel_to(page_id)
end

function IngameMenuCallbacks:cb_leave_game_popup_item_selected(args)
	if args.action == "leave_game" then
		self:cb_leave_game()
	end
end

function IngameMenuCallbacks:cb_alignment_dummy_units()
	return {}
end

function IngameMenuCallbacks:cb_controller_enabled()
	return Managers.input:pad_active(1)
end

function IngameMenuCallbacks:cb_controller_disabled()
	return not Managers.input:pad_active(1)
end

function IngameMenuCallbacks:cb_ingame_select_spawnpoint_visible()
	local team = self._game_state.player.team

	return Managers.state.network:game() and team and team.name ~= "unassigned"
end

function IngameMenuCallbacks:cb_return_to_team_selection_visible()
	local team = self._game_state.player.team

	return team and team.name == "unassigned" or false
end

function IngameMenuCallbacks:cb_in_tutorial()
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local in_tutorial = game_mode_key == "sp"

	return in_tutorial or false
end

function IngameMenuCallbacks:cb_return_to_team_selection()
	self._game_state:ingame_menu():goto("select_team")
end

function IngameMenuCallbacks:cb_join_squad_disabled()
	local player_team = self._game_state.player.team

	if player_team and #player_team.squads > 0 then
		return false
	end

	return true
end

function IngameMenuCallbacks:cb_return_to_squad_selection()
	self._game_state:ingame_menu():goto("select_squad")
end

function IngameMenuCallbacks:cb_should_remove_select_profile_ingame()
	local team = self._game_state.player.team
	local state = self._game_state.player.spawn_data.state

	return not team or team.name == "unassigned" or state == "spawned"
end

function IngameMenuCallbacks:cb_voice_overs()
	local options = {
		{
			key = "normal",
			value = L("main_menu_voice_over_normal")
		}
	}

	if DLCSettings.brian_blessed() then
		options[#options + 1] = {
			key = "brian_blessed",
			value = L("main_menu_voice_over_brian_blessed")
		}
	end

	return options, HUDSettings.announcement_voice_over == "normal" and 1 or 2
end

function IngameMenuCallbacks:cb_voice_over_changed(option)
	HUDSettings.announcement_voice_over = option.key

	Application.set_user_setting("announcement_voice_over", option.key)
	Application.save_user_settings()
end
