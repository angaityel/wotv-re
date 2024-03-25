-- chunkname: @scripts/menu/menu_controller_settings/loading_screen_menu_controller_settings.lua

LoadingScreenMenuControllerSettings = {}
LoadingScreenMenuControllerSettings.pad360 = {
	select = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	replay = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	move = {
		controller_type = "pad",
		key = "left",
		func = "axis"
	},
	mouse_scroll = {
		controller_type = "pad",
		key = "right",
		func = "axis"
	},
	close_menu = {
		controller_type = "pad",
		key = "start",
		func = "pressed"
	},
	move_up_value = {
		controller_type = "pad",
		key = "d_up",
		func = "button"
	},
	move_down_value = {
		controller_type = "pad",
		key = "d_down",
		func = "button"
	},
	move_left_value = {
		controller_type = "pad",
		key = "d_left",
		func = "button"
	},
	move_right_value = {
		controller_type = "pad",
		key = "d_right",
		func = "button"
	},
	move_up = {
		type = "FilterControllerMenuMovement",
		controller_type = "pad",
		func = "filter",
		input = {
			input = "move_up_value"
		}
	},
	move_down = {
		type = "FilterControllerMenuMovement",
		controller_type = "pad",
		func = "filter",
		input = {
			input = "move_down_value"
		}
	},
	move_left = {
		type = "FilterControllerMenuMovement",
		controller_type = "pad",
		func = "filter",
		input = {
			input = "move_left_value"
		}
	},
	move_right = {
		type = "FilterControllerMenuMovement",
		controller_type = "pad",
		func = "filter",
		input = {
			input = "move_right_value"
		}
	},
	summary = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	scoreboard = {
		controller_type = "pad",
		key = "x",
		func = "pressed"
	},
	next_battle = {
		controller_type = "pad",
		key = "a",
		func = "pressed"
	},
	deactivate_chat_input = {
		controller_type = "pad",
		key = "b",
		func = "pressed"
	},
	activate_chat_input_all = {
		controller_type = "pad",
		key = "right_thumb",
		state = "shifted",
		func = "pressed"
	},
	next_tip = {
		controller_type = "pad",
		key = "y",
		func = "pressed"
	}
}
LoadingScreenMenuControllerSettings.padps3 = {
	select = {
		controller_type = "pad",
		key = "cross",
		func = "pressed"
	},
	replay = {
		controller_type = "pad",
		key = "square",
		func = "pressed"
	},
	move = {
		controller_type = "pad",
		key = "left",
		func = "axis"
	},
	close_menu = {
		controller_type = "pad",
		key = "start",
		func = "pressed"
	}
}
LoadingScreenMenuControllerSettings.keyboard_mouse = {
	activate_chat_input = {
		controller_type = "keyboard",
		key = "enter",
		func = "pressed"
	},
	deactivate_chat_input = {
		controller_type = "keyboard",
		key = "esc",
		func = "pressed"
	},
	select = {
		controller_type = "keyboard",
		key = "enter",
		func = "pressed"
	},
	replay = {
		controller_type = "keyboard",
		key = "r",
		func = "pressed"
	},
	move_up = {
		controller_type = "keyboard",
		key = "up",
		func = "pressed"
	},
	move_down = {
		controller_type = "keyboard",
		key = "down",
		func = "pressed"
	},
	move_left = {
		controller_type = "keyboard",
		key = "left",
		func = "pressed"
	},
	move_right = {
		controller_type = "keyboard",
		key = "right",
		func = "pressed"
	},
	close_menu = {
		controller_type = "keyboard",
		key = "esc",
		func = "pressed"
	},
	cursor = {
		controller_type = "mouse",
		key = "cursor",
		func = "axis"
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
	select_down = {
		controller_type = "mouse",
		key = "left",
		func = "button"
	},
	mouse_scroll = {
		controller_type = "mouse",
		key = "wheel",
		func = "axis"
	},
	next_tip = {
		controller_type = "keyboard",
		key = "t",
		func = "pressed"
	}
}
