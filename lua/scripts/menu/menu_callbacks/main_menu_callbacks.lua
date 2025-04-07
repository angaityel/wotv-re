-- chunkname: @scripts/menu/menu_callbacks/main_menu_callbacks.lua

MainMenuCallbacks = class(MainMenuCallbacks)

function MainMenuCallbacks:init(menu_state)
	self._menu_state = menu_state
end

function MainMenuCallbacks:cb_exit_game()
	self._menu_state:exit_game()
end

function MainMenuCallbacks:cb_is_not_demo()
	return not IS_DEMO
end

function MainMenuCallbacks:cb_single_player_start()
	self._menu_state:single_player_start(self._selected_single_player_level)
end

function MainMenuCallbacks:cb_disable_single_player()
	if IS_DEMO or GameSettingsDevelopment.disable_singleplayer then
		return true
	end
end

function MainMenuCallbacks:cb_start_tutorial()
	self._menu_state:single_player_start("Tutorial")
end

function MainMenuCallbacks:cb_has_debug_join_lobby()
	return not GameSettingsDevelopment.allow_old_join_game
end

function MainMenuCallbacks:cb_has_debug_host_lobby()
	return not GameSettingsDevelopment.allow_host_game
end

function MainMenuCallbacks:cb_menu_shield_units(team_name)
	local units = self._menu_state._menu._menu_shield_units and table.clone(self._menu_state._menu._menu_shield_units[team_name]) or {}

	units[#units + 1] = self._menu_state._menu._menu_main_shield_unit

	return units
end

function MainMenuCallbacks:cb_menu_main_shield_unit()
	return self._menu_state._menu._menu_main_shield_unit
end

function MainMenuCallbacks:cb_start_single_player_game_disabled()
	if script_data.sp_level_unlock then
		return false
	end

	return not (PlayerData.sp_level_progression_id >= LevelSettings[self._selected_single_player_level].sp_requirement_id)
end

function MainMenuCallbacks:cb_on_enter_single_player_ddl_text()
	local levels = MenuHelper.single_player_levels_sorted()
	local saved_level_key = Application.win32_user_setting("single_player_level")
	local level_key = saved_level_key or levels[1].level_key
	local description_text = L("main_menu_level") .. ": "
	local value_text = L(LevelSettings[level_key].display_name)

	self._selected_single_player_level = level_key

	return description_text, value_text
end

function MainMenuCallbacks:cb_set_banner_material_variation(material_variation)
	local banner_unit = self._menu_state._menu:menu_banner_unit()

	if banner_unit then
		Unit.set_material_variation(banner_unit, material_variation)
	end
end

function MainMenuCallbacks:cb_set_banner_unit_visibility(visibility)
	local banner_unit = self._menu_state:banner_unit()

	if banner_unit then
		Unit.set_unit_visibility(banner_unit, visibility)
	end
end

function MainMenuCallbacks:cb_single_player_ddl_options()
	local levels = MenuHelper.single_player_levels_sorted()
	local saved_level_key = Application.win32_user_setting("single_player_level")
	local selected_index = 1
	local options = {}

	for i, config in ipairs(levels) do
		options[#options + 1] = {
			key = config.level_key,
			value = L(LevelSettings[config.level_key].display_name)
		}

		if saved_level_key and saved_level_key == config.level_key then
			selected_index = i
		end
	end

	self._selected_single_player_level = options[selected_index].key

	return options, selected_index
end

function MainMenuCallbacks:cb_single_player_ddl_option_changed(option)
	Application.set_win32_user_setting("single_player_level", option.key)
	Application.save_win32_user_settings()

	self._selected_single_player_level = option.key
end

function MainMenuCallbacks:cb_show_hud_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_hud and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_hide_blood_changed(option)
	Application.set_user_setting("hide_blood", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_hide_blood_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = Application.user_setting("hide_blood") and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_squadless_scoreboard_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = Application.user_setting("squadless_scoreboard") and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_autojoin_squad_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = Application.user_setting("autojoin_squad") and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_squadless_scoreboard_changed(option)
	Application.set_user_setting("squadless_scoreboard", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_autojoin_squad_changed(option)
	Application.set_user_setting("autojoin_squad", option.key)
	Application.save_user_settings()

	SquadSettings.autojoin_squad = option.key
end

function MainMenuCallbacks:cb_show_hud_option_changed(option)
	Application.set_win32_user_setting("show_hud", option.key)
	Application.save_win32_user_settings()

	HUDSettings.show_hud = option.key

	Managers.state.event:trigger("show_hud_changed", option.key)
end

function MainMenuCallbacks:cb_show_reticule_options()
	local options = {
		{
			key = false,
			value = L("main_menu_off")
		}
	}

	for _, crosshair in ipairs(HUDSettings.crosshairs) do
		options[#options + 1] = {
			key = crosshair.texture,
			value = L(crosshair.string_id)
		}
	end

	local selected_index
	local crosshair = Application.user_setting("crosshair")

	if not HUDSettings.show_reticule then
		return options, 1
	else
		for index, option in ipairs(options) do
			if option.key == crosshair then
				return options, index
			end
		end

		return options, 2
	end
end

function MainMenuCallbacks:cb_show_reticule_color_a_options()
	return self:_color_options("crosshair_alpha")
end

function MainMenuCallbacks:cb_show_reticule_color_r_options()
	return self:_color_options("crosshair_r")
end

function MainMenuCallbacks:cb_show_reticule_color_g_options()
	return self:_color_options("crosshair_g")
end

function MainMenuCallbacks:cb_show_reticule_color_b_options()
	return self:_color_options("crosshair_b")
end

function MainMenuCallbacks:_color_options(setting)
	local options = {}

	for i = 0, 255 do
		options[#options + 1] = {
			key = i,
			value = i
		}
	end

	local color = Application.user_setting(setting) or 255
	local selected_index = math.floor(color) + 1

	return options, selected_index
end

function MainMenuCallbacks:cb_show_reticule_color_a_option_changed(option)
	Application.set_user_setting("crosshair_alpha", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_reticule_color_r_option_changed(option)
	Application.set_user_setting("crosshair_r", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_reticule_color_g_option_changed(option)
	Application.set_user_setting("crosshair_g", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_reticule_color_b_option_changed(option)
	Application.set_user_setting("crosshair_b", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_reticule_option_changed(option)
	if option.key == false then
		Application.set_user_setting("show_reticule", false)
		Application.set_user_setting("crosshair", nil)
		Application.set_user_setting("crosshair_hit_marker", nil)
		Application.set_user_setting("crosshair_teammate_hit_marker", nil)
	else
		Application.set_user_setting("show_reticule", true)
		Application.set_user_setting("crosshair", option.key)
		Application.set_user_setting("crosshair_hit_marker", option.key .. "_hit")
		Application.set_user_setting("crosshair_teammate_hit_marker", option.key .. "_hit_tm")
	end

	Application.save_user_settings()

	HUDSettings.show_reticule = option.key
end

function MainMenuCallbacks:cb_show_combat_text_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_combat_text and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_show_combat_text_option_changed(option)
	Application.set_win32_user_setting("show_combat_text", option.key)
	Application.save_win32_user_settings()

	HUDSettings.show_combat_text = option.key
end

function MainMenuCallbacks:cb_show_xp_awards()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_xp_awards and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_show_xp_awards_option_changed(option)
	Application.set_user_setting("show_xp_awards", option.key)
	Application.save_user_settings()

	HUDSettings.show_xp_awards = option.key
end

function MainMenuCallbacks:cb_show_parry_helper()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_parry_helper and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_show_parry_helper_option_changed(option)
	Application.set_user_setting("show_parry_helper", option.key)
	Application.save_user_settings()

	HUDSettings.show_parry_helper = option.key
end

function MainMenuCallbacks:cb_show_pose_charge_helper()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_pose_charge_helper and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_show_pose_charge_helper_option_changed(option)
	Application.set_user_setting("show_pose_charge_helper", option.key)
	Application.save_user_settings()

	HUDSettings.show_pose_charge_helper = option.key
end

function MainMenuCallbacks:cb_show_team_outlines_options()
	local selected_index = Application.user_setting("hide_team_outlines") and 2 or 1
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}

	return options, selected_index
end

function MainMenuCallbacks:cb_show_squad_outlines_option_changed(option)
	Application.set_user_setting("hide_squad_outlines", not option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_team_outlines_option_changed(option)
	Application.set_user_setting("hide_team_outlines", not option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_tagged_outlines_option_changed(option)
	Application.set_user_setting("hide_tagged_outlines", not option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_show_squad_outlines_options()
	local selected_index = Application.user_setting("hide_squad_outlines") and 2 or 1
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}

	return options, selected_index
end

function MainMenuCallbacks:cb_show_tagged_outlines_options()
	local selected_index = Application.user_setting("hide_tagged_outlines") and 2 or 1
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}

	return options, selected_index
end

function MainMenuCallbacks:cb_show_announcements()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = HUDSettings.show_announcements and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_show_announcements_option_changed(option)
	Application.set_user_setting("show_announcements", option.key)
	Application.save_user_settings()

	HUDSettings.show_announcements = option.key
end

function MainMenuCallbacks:cb_invert_pose_control_x_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.swing.invert_pose_control_x and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_invert_pose_control_x_option_changed(option)
	Application.set_win32_user_setting("invert_pose_control_x", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.swing.invert_pose_control_x = option.key
end

function MainMenuCallbacks:cb_invert_pose_control_y_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.swing.invert_pose_control_y and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_invert_pose_control_y_option_changed(option)
	Application.set_win32_user_setting("invert_pose_control_y", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.swing.invert_pose_control_y = option.key
end

function MainMenuCallbacks:cb_invert_parry_control_x_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.parry.invert_parry_control_x and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_invert_parry_control_x_option_changed(option)
	Application.set_win32_user_setting("invert_parry_control_x", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.parry.invert_parry_control_x = option.key
end

function MainMenuCallbacks:cb_invert_parry_control_y_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.parry.invert_parry_control_y and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_travel_mode_input_mode_options()
	local options = {
		{
			key = "undecided",
			value = L("controls_hybrid")
		},
		{
			key = "hold",
			value = L("controls_hold")
		},
		{
			key = "pressed",
			value = L("controls_pressed")
		}
	}
	local saved_mode = Application.user_setting("travel_mode_input_mode")
	local selected_index = saved_mode == "hold" and 2 or saved_mode == "pressed" and 3 or 1

	return options, selected_index
end

function MainMenuCallbacks:cb_travel_mode_input_mode_changed(option)
	Application.set_win32_user_setting("travel_mode_input_mode", option.key)
	Application.save_win32_user_settings()
end

function MainMenuCallbacks:cb_move_to_interrupt_stance_options()
	local options = {
		{
			key = true,
			value = L("menu_yes")
		},
		{
			key = false,
			value = L("menu_no")
		}
	}
	local saved_mode = Application.user_setting("move_to_leave_stance")
	local selected_index = saved_mode and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_move_to_interrupt_stance_option_changed(option)
	Application.set_win32_user_setting("move_to_leave_stance", option.key)
	Application.save_win32_user_settings()
end

function MainMenuCallbacks:cb_battle_chatter_hardcore_mode_options()
	local options = {
		{
			key = true,
			value = L("menu_yes")
		},
		{
			key = false,
			value = L("menu_no")
		}
	}
	local saved_mode = Application.user_setting("battle_chatter_hardcore_mode")
	local selected_index = saved_mode and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_battle_chatter_hardcore_mode_option_changed(option)
	Application.set_win32_user_setting("battle_chatter_hardcore_mode", option.key)
	Application.save_win32_user_settings()
end

function MainMenuCallbacks:cb_immediate_hit_effects_options()
	local options = {
		{
			key = true,
			value = L("menu_yes")
		},
		{
			key = false,
			value = L("menu_no")
		}
	}
	local saved_mode = Application.user_setting("show_only_confirmed_hits")
	local selected_index = saved_mode and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_immediate_hit_effects_option_changed(option)
	Application.set_win32_user_setting("immediate_hit_effects", option.key)
	Application.save_win32_user_settings()
end

function MainMenuCallbacks:cb_invert_parry_control_y_option_changed(option)
	Application.set_win32_user_setting("invert_parry_control_y", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.parry.invert_parry_control_y = option.key
end

function MainMenuCallbacks:cb_double_tap_dodge_changed(option)
	Application.set_win32_user_setting("double_tap_dodge", option.key)
	Application.save_win32_user_settings()
end

function MainMenuCallbacks:cb_double_tap_dodge_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local setting = Application.user_setting("double_tap_dodge")
	local selected_index = setting and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_mouse_sensitivity_options()
	local negative_step = 0.85
	local positive_step = 1.1764705882352942
	local negative_steps = 10
	local positive_steps = 10
	local options = {}
	local temp_options = {
		{
			value = 0,
			key = 1
		}
	}
	local sensitivity = ActivePlayerControllerSettings.sensitivity
	local selected_index = negative_steps + 1
	local error = math.abs(sensitivity - 1)

	for i = 1, positive_steps do
		local key = temp_options[#temp_options].key * positive_step
		local difference = math.abs(sensitivity - key)

		if difference < error then
			selected_index = negative_steps + #temp_options + 1
			error = difference
		end

		temp_options[#temp_options + 1] = {
			value = i,
			key = key
		}
	end

	for i = -1, -negative_steps, -1 do
		local key = temp_options[1].key * negative_step
		local difference = math.abs(sensitivity - key)

		if difference < error then
			selected_index = negative_steps + i + 1
			error = difference
		end

		table.insert(temp_options, 1, {
			value = i,
			key = key
		})
	end

	local options = {}

	for i = 1, #temp_options do
		options[#options + 1] = {
			key = temp_options[i].key,
			value = i
		}
	end

	local real_options = options

	return options, selected_index
end

function MainMenuCallbacks:cb_mouse_sensitivity_option_changed(option)
	Application.set_win32_user_setting("mouse_sensitivity", option.key)
	Application.save_win32_user_settings()

	ActivePlayerControllerSettings.sensitivity = option.key
	SaveData.controls = table.clone(ActivePlayerControllerSettings)

	Managers.save:auto_save(SaveFileName, SaveData)
end

function MainMenuCallbacks:cb_aim_multiplier_options()
	local steps = 20
	local top = 1
	local step = top / steps
	local options = {}
	local selected_index = 1
	local aim_multiplier = ActivePlayerControllerSettings.aim_multiplier
	local difference = aim_multiplier - step

	for i = 1, steps do
		local key = step * i
		local value = i
		local diff = math.abs(aim_multiplier - key)

		if diff < difference then
			selected_index = i
			difference = diff
		end

		options[#options + 1] = {
			key = key,
			value = i
		}
	end

	return options, selected_index
end

function MainMenuCallbacks:cb_aim_multiplier_option_changed(option)
	Application.set_win32_user_setting("aim_multiplier", option.key)
	Application.save_win32_user_settings()

	ActivePlayerControllerSettings.aim_multiplier = option.key
end

function MainMenuCallbacks:cb_keyboard_parry_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.parry.keyboard_controlled and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_keyboard_parry_option_changed(option)
	Application.set_win32_user_setting("keyboard_parry", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.parry.keyboard_controlled = option.key
end

function MainMenuCallbacks:cb_keyboard_pose_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = PlayerUnitMovementSettings.swing.keyboard_controlled and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_keyboard_pose_option_changed(option)
	Application.set_win32_user_setting("keyboard_pose", option.key)
	Application.save_win32_user_settings()

	PlayerUnitMovementSettings.swing.keyboard_controlled = option.key
end

function MainMenuCallbacks:cb_cancel_to(page_id)
	self._menu_state:menu_cancel_to(page_id)
end

function MainMenuCallbacks:cb_master_volumes()
	local options, index = SoundHelper.sound_volume_options("master_volume")

	return options, index
end

function MainMenuCallbacks:cb_master_volume_changed(option)
	Application.set_win32_user_setting("master_volume", option.key)
	Application.save_win32_user_settings()
	Timpani.set_bus_volume("Master Bus", option.key)
end

function MainMenuCallbacks:cb_voice_over_volume_changed(option)
	Application.set_win32_user_setting("voice_over", option.key)
	Application.save_win32_user_settings()
	Timpani.set_bus_volume("voice_over", option.key)
end

function MainMenuCallbacks:cb_voice_over_volumes()
	local options, index = SoundHelper.sound_volume_options("voice_over")

	return options, index
end

function MainMenuCallbacks:cb_voice_overs()
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

function MainMenuCallbacks:cb_voice_over_changed(option)
	HUDSettings.announcement_voice_over = option.key

	Application.set_user_setting("announcement_voice_over", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_music_volumes()
	local options, index = SoundHelper.sound_volume_options("music_volume")

	return options, index
end

function MainMenuCallbacks:cb_music_volume_changed(option)
	Application.set_win32_user_setting("music_volume", option.key)
	Application.save_win32_user_settings()
	Timpani.set_bus_volume("music", option.key)
end

function MainMenuCallbacks:cb_sfx_volumes()
	local options, index = SoundHelper.sound_volume_options("sfx_volume")

	return options, index
end

function MainMenuCallbacks:cb_sfx_volume_changed(option)
	Application.set_win32_user_setting("sfx_volume", option.key)
	Application.save_win32_user_settings()
	Timpani.set_bus_volume("sfx", option.key)
	Timpani.set_bus_volume("special", option.key)
end

function MainMenuCallbacks:cb_steam_server_browser_disabled()
	return GameSettingsDevelopment.network_mode ~= "steam"
end

function MainMenuCallbacks:cb_look_invert_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = ActivePlayerControllerSettings.keyboard_mouse.look.type == "FilterAxisScale" and 1 or 2

	return options, selected_index
end

function MainMenuCallbacks:cb_look_invert_changed(option)
	local invert = option.key

	ActivePlayerControllerSettings.keyboard_mouse.look.type = invert and "FilterAxisScale" or "FilterInvertAxisY"
	ActivePlayerControllerSettings.keyboard_mouse.look_aiming.type = invert and "FilterAxisScale" or "FilterInvertAxisY"
	ActivePlayerControllerSettings.pad360.look.input.scale_y = (invert and -1 or 1) * PlayerControllerSettings.pad360.look.input.scale_y
	ActivePlayerControllerSettings.pad360.look_aiming.input.scale_y = (invert and -1 or 1) * PlayerControllerSettings.pad360.look_aiming.input.scale_y
	SaveData.controls = table.clone(ActivePlayerControllerSettings)

	Managers.save:auto_save(SaveFileName, SaveData)

	if Managers.player:player_exists(1) then
		local player = Managers.player:player(1)

		Managers.input:unmap_input_source(player.input_source)

		local input_source = Managers.input:map_slot(player.input_slot, ActivePlayerControllerSettings, nil)

		player.input_source = input_source
	end
end

function MainMenuCallbacks:cb_show_attack_indicators_with_shield_options()
	local selected_index = Application.user_setting("attack_indicators_with_shield") and 1 or 2
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}

	return options, selected_index
end

function MainMenuCallbacks:cb_show_attack_indicators_with_shield_option_changed(option)
	Application.set_user_setting("attack_indicators_with_shield", option.key)
	Application.save_user_settings()
end

function MainMenuCallbacks:cb_disable_controller_options()
	local options = {
		{
			key = true,
			value = L("main_menu_yes")
		},
		{
			key = false,
			value = L("main_menu_no")
		}
	}
	local selected_index = ActivePlayerControllerSettings.disable_controller == false and 2 or 1

	return options, selected_index
end

function MainMenuCallbacks:cb_disable_controller_changed(option)
	local disable_controller = option.key

	ActivePlayerControllerSettings.disable_controller = disable_controller
	SaveData.controls = table.clone(ActivePlayerControllerSettings)

	Managers.save:auto_save(SaveFileName, SaveData)
end

function MainMenuCallbacks:cb_profile_viewer_world_name()
	return "menu_level_world"
end

function MainMenuCallbacks:cb_profile_viewer_viewport_name()
	return "menu_level_viewport"
end

function MainMenuCallbacks:cb_alignment_dummy_units()
	return self._menu_state.parent.alignment_dummy_units
end

function MainMenuCallbacks:cb_open_link(url)
	if url then
		Application.open_url_in_browser(url)
		Window.minimize()
	end
end

function MainMenuCallbacks:cb_controller_enabled()
	return Managers.input:pad_active(1)
end

function MainMenuCallbacks:cb_controller_disabled()
	return not Managers.input:pad_active(1)
end

function MainMenuCallbacks:cb_camera_positioned()
	local current_position = Managers.state.camera:camera_position("menu_level_viewport")
	local target_camera = self._menu_state._menu:camera_dummy_unit()

	if not target_camera then
		return true
	end

	local target_position = Unit.local_position(target_camera, 0)

	return Vector3.length(current_position - target_position) < 1.5
end

function MainMenuCallbacks:cb_has_unviewed_unlocks()
	for name, unlock in pairs(UnviewedUnlockedItems) do
		if unlock.category == "beard_color" then
			local beard_color = BeardColorNames[unlock.name]
			local beard_name = beard_color.beard_name
			local beard = BeardNames[beard_name]

			if UnviewedUnlockedItemsHelper:can_access_item(beard) then
				return true
			end
		elseif unlock.category == "cloak_pattern" then
			local cloak_pattern = CloakPatterns[unlock.name]
			local cloak = Cloaks[cloak_pattern.cloak_name]

			if UnviewedUnlockedItemsHelper:can_access_item(cloak) then
				return true
			end
		elseif unlock.category == "helmet_variation" then
			local helmet_variation = HelmetVariations[unlock.name]
			local helmet = Helmets[helmet_variation.helmet_name]

			if UnviewedUnlockedItemsHelper:can_access_item(helmet) then
				return true
			end
		else
			return true
		end
	end

	return false
end

function MainMenuCallbacks:cb_loudout_required_rank()
	local required_rank

	for idx, profile in ipairs(PlayerProfiles) do
		local profile_index = idx
		local unlock_type = "profile"
		local unlock_key = PlayerProfiles[profile_index].unlock_key
		local entity_type = "profile"
		local entity_name = PlayerProfiles[profile_index].unlock_key
		local available, unavailable_reason = ProfileHelper:is_entity_avalible(unlock_type, unlock_key, entity_type, entity_name, PlayerProfiles[profile_index].release_name, PlayerProfiles[profile_index].developer_item)
		local required_entity_rank = ProfileHelper:required_entity_rank(entity_type, entity_name)

		if not profile.no_editing and available then
			return false, 0
		else
			required_rank = not profile.no_editing and not available and (required_rank == nil and required_entity_rank or required_entity_rank < required_rank and required_entity_rank) or required_rank
		end
	end

	return required_rank ~= nil, required_rank
end

function MainMenuCallbacks:cb_incoming_chat_sound_options()
	local options = {}

	for i = 1, 17 do
		local i_str

		if i < 10 then
			i_str = tostring("0" .. i)
		else
			i_str = tostring(i)
		end

		options[#options + 1] = {
			key = "hud_chat_ver_" .. i_str,
			value = "Sound " .. i_str
		}
	end

	options[#options + 1] = {
		key = "off",
		value = L("main_menu_off")
	}

	local setting = Application.user_setting("chat_sound")
	local selected_index = 10

	for index, t in ipairs(options) do
		if setting == t.key then
			selected_index = index
		end
	end

	return options, selected_index
end

function MainMenuCallbacks:cb_incoming_chat_sound_option_changed(option)
	Application.set_user_setting("chat_sound", option.key)

	if option.key ~= "off" then
		local world = Application.main_world()
		local timpani_world = World.timpani_world(world)

		TimpaniWorld.trigger_event(timpani_world, option.key)
	end

	Application.save_user_settings()
end
