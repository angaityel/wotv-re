﻿-- chunkname: @scripts/menu/menu_definitions/final_scoreboard_menu_settings_1366.lua

require("scripts/settings/hud_settings")

SCALE_1366 = 0.7114583333333333
FinalScoreboardMenuSettings = FinalScoreboardMenuSettings or {}
FinalScoreboardMenuSettings.items = FinalScoreboardMenuSettings.items or {}
FinalScoreboardMenuSettings.pages = FinalScoreboardMenuSettings.pages or {}
FinalScoreboardMenuSettings.items.battle_result = FinalScoreboardMenuSettings.items.battle_result or {}
FinalScoreboardMenuSettings.items.battle_result[1366] = FinalScoreboardMenuSettings.items.battle_result[1366] or {}
FinalScoreboardMenuSettings.items.battle_result[1366][768] = FinalScoreboardMenuSettings.items.battle_result[1366][768] or {
	texture_disabled = "selected_item_bgr_big_centered_1920",
	texture_alignment = "center",
	font = MenuSettings.fonts.font_gradient_100,
	font_size = 80 * SCALE_1366,
	line_height = 54 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2 * SCALE_1366,
		-2 * SCALE_1366
	},
	texture_disabled_width = 1080 * SCALE_1366,
	texture_disabled_height = 60 * SCALE_1366,
	padding_top = 20 * SCALE_1366,
	padding_bottom = 24 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.battle_details = FinalScoreboardMenuSettings.items.battle_details or {}
FinalScoreboardMenuSettings.items.battle_details[1366] = FinalScoreboardMenuSettings.items.battle_details[1366] or {}
FinalScoreboardMenuSettings.items.battle_details[1366][768] = FinalScoreboardMenuSettings.items.battle_details[1366][768] or {
	texture_disabled = "selected_item_bgr_centered_1920",
	texture_alignment = "center",
	font = MenuSettings.fonts.hell_shark_32,
	font_size = 32 * SCALE_1366,
	line_height = 21 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2 * SCALE_1366,
		-2 * SCALE_1366
	},
	texture_disabled_width = 652 * SCALE_1366,
	texture_disabled_height = 36 * SCALE_1366,
	padding_top = 8 * SCALE_1366,
	padding_bottom = 9 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.left_team_rose = FinalScoreboardMenuSettings.items.left_team_rose or {}
FinalScoreboardMenuSettings.items.left_team_rose[1366] = FinalScoreboardMenuSettings.items.left_team_rose[1366] or {}
FinalScoreboardMenuSettings.items.left_team_rose[1366][768] = FinalScoreboardMenuSettings.items.left_team_rose[1366][768] or {
	texture_red = "big_rose_red",
	texture_white = "big_rose_white",
	texture_width = 532 * SCALE_1366,
	texture_height = 532 * SCALE_1366,
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.center_team_rose = FinalScoreboardMenuSettings.items.center_team_rose or {}
FinalScoreboardMenuSettings.items.center_team_rose[1366] = FinalScoreboardMenuSettings.items.center_team_rose[1366] or {}
FinalScoreboardMenuSettings.items.center_team_rose[1366][768] = FinalScoreboardMenuSettings.items.center_team_rose[1366][768] or {
	texture_red = "big_rose_red",
	texture_white = "big_rose_white",
	texture_width = 532 * SCALE_1366,
	texture_height = 532 * SCALE_1366,
	padding_top = 100 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.right_team_rose = FinalScoreboardMenuSettings.items.right_team_rose or {}
FinalScoreboardMenuSettings.items.right_team_rose[1366] = FinalScoreboardMenuSettings.items.right_team_rose[1366] or {}
FinalScoreboardMenuSettings.items.right_team_rose[1366][768] = FinalScoreboardMenuSettings.items.right_team_rose[1366][768] or {
	texture_red = "big_rose_red",
	texture_white = "big_rose_white",
	texture_width = 532 * SCALE_1366,
	texture_height = 532 * SCALE_1366,
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.left_team_score = FinalScoreboardMenuSettings.items.left_team_score or {}
FinalScoreboardMenuSettings.items.left_team_score[1366] = FinalScoreboardMenuSettings.items.left_team_score[1366] or {}
FinalScoreboardMenuSettings.items.left_team_score[1366][768] = FinalScoreboardMenuSettings.items.left_team_score[1366][768] or {
	font = MenuSettings.fonts.font_gradient_100,
	font_size = 150 * SCALE_1366,
	line_height = 60 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	padding_top = 20 * SCALE_1366,
	padding_bottom = 60 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.right_team_score = FinalScoreboardMenuSettings.items.right_team_score or {}
FinalScoreboardMenuSettings.items.right_team_score[1366] = FinalScoreboardMenuSettings.items.right_team_score[1366] or {}
FinalScoreboardMenuSettings.items.right_team_score[1366][768] = FinalScoreboardMenuSettings.items.right_team_score[1366][768] or {
	font = MenuSettings.fonts.font_gradient_100,
	font_size = 150 * SCALE_1366,
	line_height = 60 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	padding_top = 20 * SCALE_1366,
	padding_bottom = 60 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.left_team_text = FinalScoreboardMenuSettings.items.left_team_text or {}
FinalScoreboardMenuSettings.items.left_team_text[1366] = FinalScoreboardMenuSettings.items.left_team_text[1366] or {}
FinalScoreboardMenuSettings.items.left_team_text[1366][768] = FinalScoreboardMenuSettings.items.left_team_text[1366][768] or {
	texture_alignment = "center",
	texture_disabled = "selected_item_bgr_right_1920",
	font = MenuSettings.fonts.hell_shark_32,
	font_size = 32 * SCALE_1366,
	line_height = 21 * SCALE_1366,
	color_red = HUDSettings.player_colors.red,
	color_white = HUDSettings.player_colors.white,
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2 * SCALE_1366,
		-2 * SCALE_1366
	},
	texture_disabled_width = 652 * SCALE_1366,
	texture_disabled_height = 36 * SCALE_1366,
	texture_offset_x = -66 * SCALE_1366,
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.items.right_team_text = FinalScoreboardMenuSettings.items.right_team_text or {}
FinalScoreboardMenuSettings.items.right_team_text[1366] = FinalScoreboardMenuSettings.items.right_team_text[1366] or {}
FinalScoreboardMenuSettings.items.right_team_text[1366][768] = FinalScoreboardMenuSettings.items.right_team_text[1366][768] or {
	texture_alignment = "center",
	texture_disabled = "selected_item_bgr_left_1920",
	font = MenuSettings.fonts.hell_shark_32,
	font_size = 32 * SCALE_1366,
	line_height = 21 * SCALE_1366,
	color_red = HUDSettings.player_colors.red,
	color_white = HUDSettings.player_colors.white,
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2 * SCALE_1366,
		-2 * SCALE_1366
	},
	texture_disabled_width = 652 * SCALE_1366,
	texture_disabled_height = 36 * SCALE_1366,
	texture_offset_x = 66 * SCALE_1366,
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
FinalScoreboardMenuSettings.pages.main_page = FinalScoreboardMenuSettings.pages.main_page or {}
FinalScoreboardMenuSettings.pages.main_page[1366] = FinalScoreboardMenuSettings.pages.main_page[1366] or {}
FinalScoreboardMenuSettings.pages.main_page[1366][768] = FinalScoreboardMenuSettings.pages.main_page[1366][768] or {
	center_items = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = -40,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		column_alignment = {
			"center"
		}
	},
	left_team_items = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_offset_x = -300 * SCALE_1366,
		pivot_offset_y = -300 * SCALE_1366,
		anim_from = {
			screen_align_y = "center",
			screen_offset_x = 0,
			pivot_align_y = "bottom",
			interpolation = "smoothstep",
			screen_align_x = "left",
			pivot_offset_x = 0,
			screen_offset_y = 0,
			pivot_align_x = "right",
			duration = 0.25,
			pivot_offset_y = -300 * SCALE_1366
		},
		column_alignment = {
			"center"
		}
	},
	right_team_items = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 300 * SCALE_1366,
		pivot_offset_y = -300 * SCALE_1366,
		anim_from = {
			screen_align_y = "center",
			screen_offset_x = 0,
			pivot_align_y = "bottom",
			interpolation = "smoothstep",
			screen_align_x = "right",
			pivot_offset_x = 0,
			screen_offset_y = 0,
			pivot_align_x = "left",
			duration = 0.25,
			pivot_offset_y = -300 * SCALE_1366
		},
		column_alignment = {
			"center"
		}
	},
	left_gradient_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_gradient_1920",
		screen_align_x = "center",
		stretch_relative_height = 1,
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_offset_x = -262 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366,
		texture_width = 636 * SCALE_1366,
		texture_height = 4 * SCALE_1366,
		stretch_width = 540 * SCALE_1366,
		color_red = {
			255,
			255,
			180,
			180
		},
		color_white = {
			255,
			255,
			255,
			255
		}
	},
	left_vertical_line_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_vertical_line_1920",
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = -262 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366,
		texture_width = 16 * SCALE_1366,
		texture_height = 1016 * SCALE_1366
	},
	left_corner_top_texture = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_top_corner_1920",
		texture_width = 416,
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "right",
		texture_height = 308,
		pivot_offset_x = -266 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366
	},
	right_gradient_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_gradient_right_1920",
		screen_align_x = "center",
		stretch_relative_height = 1,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 262 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366,
		texture_width = 636 * SCALE_1366,
		texture_height = 4 * SCALE_1366,
		stretch_width = 540 * SCALE_1366,
		color_red = {
			255,
			255,
			180,
			180
		},
		color_white = {
			255,
			255,
			255,
			255
		}
	},
	right_vertical_line_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_vertical_line_right_1920",
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_offset_x = 262 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366,
		texture_width = 16 * SCALE_1366,
		texture_height = 1016 * SCALE_1366
	},
	right_corner_top_texture = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_top_corner_right_1920",
		screen_align_x = "center",
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 266 * SCALE_1366,
		pivot_offset_y = 0 * SCALE_1366,
		texture_width = 416 * SCALE_1366,
		texture_height = 308 * SCALE_1366
	},
	coin_award = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		height = 500,
		pivot_offset_y = 0,
		screen_align_x = "center",
		z = 30,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		render_rect = {
			border_size = 3,
			color = {
				210,
				0,
				0,
				0
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	}
}
FinalScoreboardMenuSettings.pages.main_page[1366][768].button_info = {
	text_data = {
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		offset_x = 25 * SCALE_1366,
		offset_y = 100 * SCALE_1366,
		drop_shadow = {
			1,
			-1
		}
	},
	default_buttons = {}
}
