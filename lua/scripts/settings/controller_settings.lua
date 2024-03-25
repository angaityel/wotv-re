-- chunkname: @scripts/settings/controller_settings.lua

require("scripts/settings/input_filters")

function populate_player_controls_from_save(save_data)
	if save_data.controls then
		if not save_data.controls.big_picture then
			save_data.controls.pad360 = PlayerControllerSettings.pad360
			save_data.controls.big_picture = true
		end

		for k, v in pairs(save_data.controls) do
			if type(v) == "table" then
				for k1, v1 in pairs(v) do
					ActivePlayerControllerSettings[k][k1] = v1
				end
			else
				ActivePlayerControllerSettings[k] = v
			end
		end
	end
end

PlayerControllerSettings = {}
PlayerControllerSettings.sensitivity = 1
PlayerControllerSettings.aim_multiplier = 1
PlayerControllerSettings.big_picture = true
PlayerControllerSettings.pad360 = {
	scoreboard = {
		controller_type = "pad",
		key = "back",
		func = "pressed"
	},
	cancel = {
		controller_type = "pad",
		key = "start",
		func = "pressed"
	},
	leave_ghost_mode = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	skip_cutscene = {
		controller_type = "pad",
		key = "start",
		func = "pressed"
	},
	select_left_click = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	select_left_click = {
		controller_type = "pad",
		key = "b",
		func = "pressed"
	},
	move = {
		controller_type = "pad",
		key = "left",
		func = "axis"
	},
	mount_move = {
		controller_type = "pad",
		key = "left",
		func = "axis"
	},
	look_raw = {
		controller_type = "pad",
		key = "right",
		func = "axis"
	},
	melee_pose = {
		controller_type = "pad",
		key = "right_trigger",
		func = "button"
	},
	melee_pose_pushed = {
		controller_type = "pad",
		key = "right_trigger",
		func = "pressed"
	},
	right_hand_attack_held = {
		controller_type = "pad",
		key = "right_trigger",
		func = "button"
	},
	right_hand_attack_pressed = {
		controller_type = "pad",
		key = "right_trigger",
		func = "pressed"
	},
	falling_attack = {
		controller_type = "pad",
		key = "right_trigger",
		func = "pressed"
	},
	melee_swing = {
		controller_type = "pad",
		key = "right_trigger",
		func = "released"
	},
	special_attack_held = {
		controller_type = "pad",
		key = "right_shoulder",
		func = "button"
	},
	special_attack = {
		controller_type = "pad",
		key = "right_shoulder",
		func = "pressed"
	},
	raise_block = {
		controller_type = "pad",
		key = "left_trigger",
		func = "pressed"
	},
	lower_block = {
		controller_type = "pad",
		key = "left_trigger",
		func = "released"
	},
	block = {
		controller_type = "pad",
		key = "left_trigger",
		func = "button"
	},
	left_hand_attack_held = {
		controller_type = "pad",
		key = "left_trigger",
		func = "button"
	},
	left_hand_attack_pressed = {
		controller_type = "pad",
		key = "left_trigger",
		func = "pressed"
	},
	ranged_weapon_aim = {
		controller_type = "pad",
		key = "left_trigger",
		func = "button"
	},
	ranged_weapon_aim_pressed = {
		controller_type = "pad",
		key = "left_trigger",
		func = "pressed"
	},
	ranged_weapon_fire = {
		controller_type = "pad",
		key = "right_trigger",
		func = "pressed"
	},
	wield_shield = {
		controller_type = "pad",
		key = "d_left",
		func = "pressed"
	},
	wield_one_handed_weapon = {
		controller_type = "pad",
		key = "d_right",
		func = "pressed"
	},
	wield_two_handed_weapon = {
		controller_type = "pad",
		key = "d_left",
		func = "pressed"
	},
	interact = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	interacting = {
		controller_type = "pad",
		key = "x",
		func = "button"
	},
	loot = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	looting = {
		controller_type = "pad",
		key = "x",
		func = "button"
	},
	jump = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	dodge = {
		controller_type = "pad",
		key = "b",
		func = "pressed"
	},
	throw_weapon = {
		controller_type = "pad",
		key = "left_shoulder",
		func = "button"
	},
	crouch = {
		controller_type = "pad",
		key = "right_thumb",
		func = "pressed"
	},
	travel_mode = {
		controller_type = "pad",
		key = "left_thumb",
		func = "pressed"
	},
	travel_mode_held = {
		controller_type = "pad",
		key = "left_thumb",
		func = "button"
	},
	backspace_pressed = {
		controller_type = "pad",
		key = "back",
		func = "pressed"
	},
	backspace_down = {
		controller_type = "pad",
		key = "back",
		func = "button"
	},
	bandage = {
		controller_type = "pad",
		key = "d_down",
		func = "button"
	},
	bandage_start = {
		controller_type = "pad",
		key = "d_down",
		func = "pressed"
	},
	shield_bash_pose = {
		controller_type = "pad",
		key = "right_trigger",
		func = "button"
	},
	push = {
		controller_type = "pad",
		key = "right_trigger",
		func = "pressed"
	},
	couch_lance = {
		controller_type = "pad",
		key = "right_trigger",
		func = "button"
	},
	hold_breath = {
		controller_type = "pad",
		key = "right_shoulder",
		func = "button"
	},
	ranged_weapon_zoom = {
		controller_type = "pad",
		key = "right_thumb",
		func = "pressed"
	},
	yield = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	activate_tag = {
		controller_type = "pad",
		key = "d_up",
		func = "button"
	},
	activate_tag_pressed = {
		controller_type = "pad",
		key = "d_up",
		func = "pressed"
	},
	deactivate_chat_input = {
		controller_type = "pad",
		key = "b",
		func = "pressed"
	},
	duel = {
		type = "FilterDoubleTap",
		controller_type = "pad",
		func = "filter",
		input = {
			pressed = "raise_block",
			duration = 0.2
		}
	},
	activate_perk_1 = {
		controller_type = "pad",
		key = "y",
		func = "pressed"
	},
	activate_perk_2 = {
		controller_type = "pad",
		key = "y",
		func = "pressed"
	},
	activate_perk_3 = {
		controller_type = "pad",
		key = "y",
		func = "pressed"
	},
	activate_perk_4 = {
		controller_type = "pad",
		key = "y",
		func = "pressed"
	},
	shift_function = {
		set_state = "shifted",
		key = "back",
		controller_type = "pad",
		func = "button"
	},
	wield_dagger = {
		controller_type = "pad",
		key = "d_right",
		func = "pressed"
	},
	call_horse_released = {
		controller_type = "pad",
		key = "x",
		state = "shifted",
		func = "released"
	},
	call_horse = {
		controller_type = "pad",
		key = "x",
		state = "shifted",
		func = "button"
	},
	toggle_visor = {
		controller_type = "pad",
		key = "y",
		state = "shifted",
		func = "pressed"
	},
	vote_yes = {
		controller_type = "pad",
		key = "d_left",
		state = "shifted",
		func = "pressed"
	},
	vote_no = {
		controller_type = "pad",
		key = "d_right",
		state = "shifted",
		func = "pressed"
	},
	activate_chat_input_all = {
		controller_type = "pad",
		key = "right_thumb",
		state = "shifted",
		func = "pressed"
	},
	zoom_in = {
		controller_type = "pad",
		key = "d_up",
		state = "shifted",
		func = "button"
	},
	zoom_out = {
		controller_type = "pad",
		key = "d_down",
		state = "shifted",
		func = "button"
	},
	mount_brake = {
		controller_type = "pad",
		key = "b",
		func = "button"
	},
	switch_weapon_grip = {
		controller_type = "pad",
		key = "back",
		func = "pressed"
	},
	rush = {
		controller_type = "pad",
		key = "left_thumb",
		func = "button"
	},
	rush_pressed = {
		controller_type = "pad",
		key = "left_thumb",
		func = "pressed"
	},
	mounted_charge = {
		controller_type = "pad",
		key = "left_thumb",
		func = "button"
	},
	mounted_charge_pressed = {
		controller_type = "pad",
		key = "left_thumb",
		func = "pressed"
	},
	double_tap_dodge_left = {
		controller_type = "pad",
		key = "d_left",
		state_blocked = "shifted",
		func = "pressed"
	},
	double_tap_dodge_right = {
		controller_type = "pad",
		key = "d_right",
		state_blocked = "shifted",
		func = "pressed"
	},
	double_tap_dodge_forward = {
		controller_type = "pad",
		key = "d_up",
		state_blocked = "shifted",
		func = "pressed"
	},
	double_tap_dodge_backward = {
		controller_type = "pad",
		key = "d_down",
		state_blocked = "shifted",
		func = "pressed"
	},
	request_revive = {
		controller_type = "pad",
		key = "b",
		state_blocked = "shifted",
		func = "button"
	},
	next_spawn = {
		controller_type = "pad",
		key = "b",
		state_blocked = "shifted",
		func = "pressed"
	},
	plant_squad_flag = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	look = {
		type = "FilterAxisScaleRampDt",
		controller_type = "pad",
		func = "filter",
		input = {
			type = "look",
			scale_x = 1,
			axis = "look_raw",
			scale_y = 0.78,
			min_move = 0
		}
	},
	look_aiming = {
		type = "FilterAxisScaleRampDt",
		controller_type = "pad",
		func = "filter",
		input = {
			type = "look_aiming",
			time_acc_multiplier = 1,
			scale_x = 0.9,
			axis = "look_raw",
			scale_y = 0.65,
			hi_scale_x = 1,
			min_move = 0
		}
	}
}
PlayerControllerSettings.padps3 = {
	move = {
		controller_type = "pad",
		key = "left",
		func = "axis"
	},
	look_raw = {
		controller_type = "pad",
		key = "right",
		func = "axis"
	},
	enter_free_flight = {
		controller_type = "pad",
		key = "start",
		func = "pressed"
	},
	jump = {
		controller_type = "pad",
		key = "cross",
		func = "pressed"
	},
	look = {
		type = "FilterAxisScale",
		controller_type = "pad",
		func = "filter",
		input = {
			scale = 0.3,
			axis = "look_raw"
		}
	}
}
PlayerControllerSettings.keyboard_mouse = {
	scoreboard = {
		controller_type = "keyboard",
		key = "tab",
		func = "button"
	},
	cancel = {
		controller_type = "keyboard",
		key = "esc",
		func = "pressed"
	},
	enter_free_flight = {
		controller_type = "keyboard",
		key = "f8",
		func = "pressed"
	},
	activate_chat_input = {
		controller_type = "keyboard",
		key = "enter",
		func = "pressed"
	},
	activate_chat_input_all = {
		controller_type = "keyboard",
		key = "y",
		func = "pressed"
	},
	activate_chat_input_team = {
		controller_type = "keyboard",
		key = "u",
		func = "pressed"
	},
	execute_chat_input = {
		controller_type = "keyboard",
		key = "enter",
		func = "pressed"
	},
	deactivate_chat_input = {
		controller_type = "keyboard",
		key = "esc",
		func = "pressed"
	},
	plant_squad_flag = {
		controller_type = "keyboard",
		key = "e",
		func = "pressed"
	},
	suicide = {
		controller_type = "keyboard",
		key = "f3",
		func = "pressed"
	},
	exit_to_menu_lobby = {
		controller_type = "keyboard",
		key = "l",
		func = "pressed"
	},
	load_next_level = {
		controller_type = "keyboard",
		key = "n",
		func = "pressed"
	},
	hud_debug_text_test = {
		controller_type = "keyboard",
		key = "o",
		func = "pressed"
	},
	look_raw = {
		controller_type = "mouse",
		key = "mouse",
		func = "axis"
	},
	couch_lance = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	melee_pose = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	falling_attack = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	melee_pose_pushed = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	pommel_bash_pushed = {
		controller_type = "keyboard",
		key = "q",
		func = "pressed"
	},
	melee_swing = {
		controller_type = "mouse",
		key = "left",
		func = "released"
	},
	left_hand_attack_pressed = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	right_hand_attack_pressed = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	left_hand_attack_held = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	right_hand_attack_held = {
		controller_type = "mouse",
		key = "right",
		func = "button"
	},
	special_attack_primary = {
		controller_type = "mouse",
		key = "extra_1",
		func = "pressed"
	},
	special_attack_secondary = {
		controller_type = "keyboard",
		key = "f",
		func = "pressed"
	},
	special_attack_primary_held = {
		controller_type = "mouse",
		key = "extra_1",
		func = "button"
	},
	special_attack_secondary_held = {
		controller_type = "keyboard",
		key = "f",
		func = "button"
	},
	special_attack = {
		type = "FilterOr",
		controller_type = "keyboard",
		func = "filter",
		input = {
			"special_attack_primary",
			"special_attack_secondary"
		}
	},
	special_attack_held = {
		type = "FilterAverage",
		controller_type = "keyboard",
		func = "filter",
		input = {
			"special_attack_primary_held",
			"special_attack_secondary_held"
		}
	},
	raise_block = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	lower_block = {
		controller_type = "mouse",
		key = "right",
		func = "released"
	},
	block = {
		controller_type = "mouse",
		key = "right",
		func = "button"
	},
	throw_weapon = {
		controller_type = "mouse",
		key = "middle",
		func = "button"
	},
	ranged_weapon_aim = {
		controller_type = "mouse",
		key = "right",
		func = "button"
	},
	ranged_weapon_aim_pressed = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	toggle_visor = {
		controller_type = "keyboard",
		key = "v",
		func = "pressed"
	},
	select_left_click = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	select_right_click = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	leave_ghost_mode = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	bandage = {
		controller_type = "keyboard",
		key = "b",
		func = "button"
	},
	bandage_start = {
		controller_type = "keyboard",
		key = "b",
		func = "pressed"
	},
	ranged_weapon_fire = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	cursor = {
		controller_type = "mouse",
		key = "cursor",
		func = "axis"
	},
	wield_shield = {
		controller_type = "keyboard",
		key = "4",
		func = "pressed"
	},
	wield_dagger = {
		controller_type = "keyboard",
		key = "3",
		func = "pressed"
	},
	wield_one_handed_weapon = {
		controller_type = "keyboard",
		key = "2",
		func = "pressed"
	},
	wield_two_handed_weapon = {
		controller_type = "keyboard",
		key = "1",
		func = "pressed"
	},
	wield_throwing_weapon = {
		controller_type = "keyboard",
		key = "5",
		func = "pressed"
	},
	mount_cruise_control_gear_up = {
		controller_type = "keyboard",
		key = "w",
		func = "pressed"
	},
	mount_cruise_control_gear_down = {
		controller_type = "keyboard",
		key = "s",
		func = "pressed"
	},
	interact = {
		controller_type = "keyboard",
		key = "e",
		func = "pressed"
	},
	interacting = {
		controller_type = "keyboard",
		key = "e",
		func = "button"
	},
	loot = {
		controller_type = "keyboard",
		key = "q",
		func = "pressed"
	},
	looting = {
		controller_type = "keyboard",
		key = "q",
		func = "button"
	},
	jump = {
		controller_type = "keyboard",
		key = "space",
		func = "pressed"
	},
	yield = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	request_revive = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	next_spawn = {
		controller_type = "mouse",
		key = "right",
		func = "pressed"
	},
	mount_brake = {
		controller_type = "keyboard",
		key = "space",
		func = "button"
	},
	crouch = {
		controller_type = "keyboard",
		key = "left ctrl",
		func = "pressed"
	},
	move_left = {
		controller_type = "keyboard",
		key = "a",
		func = "button"
	},
	move_right = {
		controller_type = "keyboard",
		key = "d",
		func = "button"
	},
	move_left_pressed = {
		controller_type = "keyboard",
		key = "a",
		func = "pressed"
	},
	move_right_pressed = {
		controller_type = "keyboard",
		key = "d",
		func = "pressed"
	},
	move_forward_pressed = {
		controller_type = "keyboard",
		key = "w",
		func = "pressed"
	},
	move_back_pressed = {
		controller_type = "keyboard",
		key = "s",
		func = "pressed"
	},
	mount_move_back_pressed = {
		controller_type = "keyboard",
		key = "f",
		func = "pressed"
	},
	move_back = {
		controller_type = "keyboard",
		key = "s",
		func = "button"
	},
	move_forward = {
		controller_type = "keyboard",
		key = "w",
		func = "button"
	},
	taunt = {
		controller_type = "keyboard",
		key = "r",
		func = "pressed"
	},
	mount_move_forward_pressed = {
		controller_type = "keyboard",
		key = "r",
		func = "pressed"
	},
	activate_perk_1 = {
		controller_type = "keyboard",
		key = "z",
		func = "pressed"
	},
	activate_perk_2 = {
		controller_type = "keyboard",
		key = "x",
		func = "pressed"
	},
	activate_perk_3 = {
		controller_type = "keyboard",
		key = "c",
		func = "pressed"
	},
	activate_perk_4 = {
		controller_type = "keyboard",
		key = "v",
		func = "pressed"
	},
	show_player_profile = {
		controller_type = "keyboard",
		key = "left ctrl",
		func = "button"
	},
	mount_move_left = {
		controller_type = "keyboard",
		key = "a",
		func = "button"
	},
	mount_move_right = {
		controller_type = "keyboard",
		key = "d",
		func = "button"
	},
	mount_move_back = {
		controller_type = "keyboard",
		key = "f",
		func = "button"
	},
	mount_move_forward = {
		controller_type = "keyboard",
		key = "r",
		func = "button"
	},
	duel = {
		controller_type = "keyboard",
		key = "y",
		func = "button"
	},
	rush = {
		controller_type = "keyboard",
		key = "g",
		func = "button"
	},
	rush_pressed = {
		controller_type = "keyboard",
		key = "g",
		func = "pressed"
	},
	mounted_charge = {
		controller_type = "keyboard",
		key = "left shift",
		func = "button"
	},
	mounted_charge_pressed = {
		controller_type = "keyboard",
		key = "left shift",
		func = "pressed"
	},
	ranged_weapon_zoom = {
		controller_type = "keyboard",
		key = "left ctrl",
		func = "pressed"
	},
	hold_breath = {
		controller_type = "keyboard",
		key = "left shift",
		func = "button"
	},
	travel_mode = {
		controller_type = "keyboard",
		key = "left shift",
		func = "pressed"
	},
	travel_mode_held = {
		controller_type = "keyboard",
		key = "left shift",
		func = "button"
	},
	backspace_pressed = {
		controller_type = "keyboard",
		key = "backspace",
		func = "pressed"
	},
	backspace_down = {
		controller_type = "keyboard",
		key = "backspace",
		func = "button"
	},
	activate_tag = {
		controller_type = "keyboard",
		key = "t",
		func = "button"
	},
	activate_tag_pressed = {
		controller_type = "keyboard",
		key = "t",
		func = "pressed"
	},
	shield_bash_pose = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	push = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	call_horse_released = {
		controller_type = "keyboard",
		key = "c",
		func = "released"
	},
	call_horse = {
		controller_type = "keyboard",
		key = "c",
		func = "button"
	},
	switch_weapon_grip = {
		controller_type = "keyboard",
		key = "q",
		func = "pressed"
	},
	delete_pressed = {
		controller_type = "keyboard",
		key = "delete",
		func = "pressed"
	},
	space_pressed = {
		controller_type = "keyboard",
		key = "space",
		func = "pressed"
	},
	left_ctrl_down = {
		controller_type = "keyboard",
		key = "left ctrl",
		func = "button"
	},
	zoom_in = {
		controller_type = "mouse",
		key = "wheel_up",
		func = "button"
	},
	zoom_out = {
		controller_type = "mouse",
		key = "wheel_down",
		func = "button"
	},
	zoom = {
		controller_type = "mouse",
		key = "wheel",
		func = "axis"
	},
	mouse_scroll = {
		controller_type = "mouse",
		key = "wheel",
		func = "axis"
	},
	skip_cutscene = {
		controller_type = "mouse",
		key = "left",
		func = "pressed"
	},
	vote_yes = {
		controller_type = "keyboard",
		key = "f1",
		func = "pressed"
	},
	vote_no = {
		controller_type = "keyboard",
		key = "f2",
		func = "pressed"
	},
	dodge = {
		controller_type = "keyboard",
		key = "left alt",
		func = "pressed"
	},
	double_tap_dodge_left = {
		type = "FilterDoubleTap",
		controller_type = "keyboard",
		func = "filter",
		input = {
			pressed = "move_left_pressed",
			duration = 0.3
		}
	},
	double_tap_dodge_right = {
		type = "FilterDoubleTap",
		controller_type = "keyboard",
		func = "filter",
		input = {
			pressed = "move_right_pressed",
			duration = 0.3
		}
	},
	double_tap_dodge_forward = {
		type = "FilterDoubleTap",
		controller_type = "keyboard",
		func = "filter",
		input = {
			pressed = "move_forward_pressed",
			duration = 0.3
		}
	},
	double_tap_dodge_backward = {
		type = "FilterDoubleTap",
		controller_type = "keyboard",
		func = "filter",
		input = {
			pressed = "move_back_pressed",
			duration = 0.3
		}
	},
	move = {
		type = "FilterVirtualAxis",
		controller_type = "mouse",
		func = "filter",
		input = {
			neg_y = "move_back",
			pos_x = "move_right",
			neg_x = "move_left",
			pos_y = "move_forward"
		}
	},
	mount_move = {
		type = "FilterVirtualAxis",
		controller_type = "mouse",
		func = "filter",
		input = {
			neg_y = "mount_move_back",
			pos_x = "mount_move_right",
			neg_x = "mount_move_left",
			pos_y = "mount_move_forward"
		}
	},
	look = {
		type = "FilterInvertAxisY",
		controller_type = "mouse",
		func = "filter",
		input = {
			scale = 0.0002,
			axis = "look_raw"
		}
	},
	look_aiming = {
		type = "FilterInvertAxisY",
		controller_type = "mouse",
		func = "filter",
		input = {
			scale = 0.0002,
			axis = "look_raw"
		}
	}
}
ActivePlayerControllerSettings = ActivePlayerControllerSettings or table.clone(PlayerControllerSettings)
