-- chunkname: @scripts/menu/menu_definitions/final_scoreboard_menu_settings_1920.lua

require("scripts/settings/hud_settings")

FinalScoreboardMenuSettings = FinalScoreboardMenuSettings or {}
FinalScoreboardMenuSettings.items = FinalScoreboardMenuSettings.items or {}
FinalScoreboardMenuSettings.pages = FinalScoreboardMenuSettings.pages or {}
FinalScoreboardMenuSettings.items.battle_result = FinalScoreboardMenuSettings.items.battle_result or {}
FinalScoreboardMenuSettings.items.battle_result[1680] = FinalScoreboardMenuSettings.items.battle_result[1680] or {}
FinalScoreboardMenuSettings.items.battle_result[1680][1050] = FinalScoreboardMenuSettings.items.battle_result[1680][1050] or {
	texture_disabled_width = 1080,
	texture_disabled = "selected_item_bgr_big_centered_1920",
	font_size = 80,
	padding_top = 20,
	texture_alignment = "center",
	padding_bottom = 24,
	line_height = 54,
	texture_disabled_height = 60,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
FinalScoreboardMenuSettings.items.battle_details = FinalScoreboardMenuSettings.items.battle_details or {}
FinalScoreboardMenuSettings.items.battle_details[1680] = FinalScoreboardMenuSettings.items.battle_details[1680] or {}
FinalScoreboardMenuSettings.items.battle_details[1680][1050] = FinalScoreboardMenuSettings.items.battle_details[1680][1050] or {
	texture_disabled = "selected_item_bgr_centered_1920",
	texture_disabled_height = 36,
	texture_alignment = "center",
	font_size = 32,
	padding_top = 8,
	texture_disabled_width = 652,
	padding_bottom = 9,
	line_height = 21,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_32,
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
		2,
		-2
	}
}
FinalScoreboardMenuSettings.items.left_team_rose = FinalScoreboardMenuSettings.items.left_team_rose or {}
FinalScoreboardMenuSettings.items.left_team_rose[1680] = FinalScoreboardMenuSettings.items.left_team_rose[1680] or {}
FinalScoreboardMenuSettings.items.left_team_rose[1680][1050] = FinalScoreboardMenuSettings.items.left_team_rose[1680][1050] or {
	texture_red = "big_rose_red",
	padding_bottom = 0,
	padding_left = 0,
	texture_width = 532,
	texture_white = "big_rose_white",
	padding_top = 0,
	padding_right = 0,
	texture_height = 532
}
FinalScoreboardMenuSettings.items.center_team_rose = FinalScoreboardMenuSettings.items.center_team_rose or {}
FinalScoreboardMenuSettings.items.center_team_rose[1680] = FinalScoreboardMenuSettings.items.center_team_rose[1680] or {}
FinalScoreboardMenuSettings.items.center_team_rose[1680][1050] = FinalScoreboardMenuSettings.items.center_team_rose[1680][1050] or {
	texture_red = "big_rose_red",
	padding_bottom = 0,
	padding_left = 0,
	texture_width = 532,
	texture_white = "big_rose_white",
	padding_top = 100,
	padding_right = 0,
	texture_height = 532
}
FinalScoreboardMenuSettings.items.right_team_rose = FinalScoreboardMenuSettings.items.right_team_rose or {}
FinalScoreboardMenuSettings.items.right_team_rose[1680] = FinalScoreboardMenuSettings.items.right_team_rose[1680] or {}
FinalScoreboardMenuSettings.items.right_team_rose[1680][1050] = FinalScoreboardMenuSettings.items.right_team_rose[1680][1050] or {
	texture_red = "big_rose_red",
	padding_bottom = 0,
	padding_left = 0,
	texture_width = 532,
	texture_white = "big_rose_white",
	padding_top = 0,
	padding_right = 0,
	texture_height = 532
}
FinalScoreboardMenuSettings.items.left_team_score = FinalScoreboardMenuSettings.items.left_team_score or {}
FinalScoreboardMenuSettings.items.left_team_score[1680] = FinalScoreboardMenuSettings.items.left_team_score[1680] or {}
FinalScoreboardMenuSettings.items.left_team_score[1680][1050] = FinalScoreboardMenuSettings.items.left_team_score[1680][1050] or {
	line_height = 60,
	padding_left = 0,
	padding_right = 0,
	font_size = 150,
	padding_top = 20,
	padding_bottom = 60,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
FinalScoreboardMenuSettings.items.right_team_score = FinalScoreboardMenuSettings.items.right_team_score or {}
FinalScoreboardMenuSettings.items.right_team_score[1680] = FinalScoreboardMenuSettings.items.right_team_score[1680] or {}
FinalScoreboardMenuSettings.items.right_team_score[1680][1050] = FinalScoreboardMenuSettings.items.right_team_score[1680][1050] or {
	line_height = 60,
	padding_left = 0,
	padding_right = 0,
	font_size = 150,
	padding_top = 20,
	padding_bottom = 60,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
FinalScoreboardMenuSettings.items.left_team_text = FinalScoreboardMenuSettings.items.left_team_text or {}
FinalScoreboardMenuSettings.items.left_team_text[1680] = FinalScoreboardMenuSettings.items.left_team_text[1680] or {}
FinalScoreboardMenuSettings.items.left_team_text[1680][1050] = FinalScoreboardMenuSettings.items.left_team_text[1680][1050] or {
	texture_disabled_width = 652,
	texture_disabled_height = 36,
	texture_alignment = "center",
	font_size = 32,
	padding_top = 7,
	texture_disabled = "selected_item_bgr_right_1920",
	padding_bottom = 7,
	line_height = 21,
	texture_offset_x = -66,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color_red = HUDSettings.player_colors.red,
	color_white = HUDSettings.player_colors.white,
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
FinalScoreboardMenuSettings.items.right_team_text = FinalScoreboardMenuSettings.items.right_team_text or {}
FinalScoreboardMenuSettings.items.right_team_text[1680] = FinalScoreboardMenuSettings.items.right_team_text[1680] or {}
FinalScoreboardMenuSettings.items.right_team_text[1680][1050] = FinalScoreboardMenuSettings.items.right_team_text[1680][1050] or {
	texture_disabled_width = 652,
	texture_disabled_height = 36,
	texture_alignment = "center",
	font_size = 32,
	padding_top = 7,
	texture_disabled = "selected_item_bgr_left_1920",
	padding_bottom = 7,
	line_height = 21,
	texture_offset_x = 66,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color_red = HUDSettings.player_colors.red,
	color_white = HUDSettings.player_colors.white,
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
FinalScoreboardMenuSettings.pages.main_page = FinalScoreboardMenuSettings.pages.main_page or {}
FinalScoreboardMenuSettings.pages.main_page[1680] = FinalScoreboardMenuSettings.pages.main_page[1680] or {}
FinalScoreboardMenuSettings.pages.main_page[1680][1050] = {
	center_items = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = -50,
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
		pivot_offset_y = -300,
		screen_align_x = "center",
		pivot_offset_x = -300,
		screen_offset_y = 0,
		pivot_align_x = "right",
		anim_from = {
			screen_align_y = "center",
			screen_offset_x = 0,
			pivot_align_y = "bottom",
			interpolation = "smoothstep",
			pivot_offset_y = -300,
			screen_align_x = "left",
			pivot_offset_x = 0,
			screen_offset_y = 0,
			pivot_align_x = "right",
			duration = 0.25
		},
		column_alignment = {
			"center"
		}
	},
	right_team_items = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		pivot_offset_y = -300,
		screen_align_x = "center",
		pivot_offset_x = 300,
		screen_offset_y = 0,
		pivot_align_x = "left",
		anim_from = {
			screen_align_y = "center",
			screen_offset_x = 0,
			pivot_align_y = "bottom",
			interpolation = "smoothstep",
			pivot_offset_y = -300,
			screen_align_x = "right",
			pivot_offset_x = 0,
			screen_offset_y = 0,
			pivot_align_x = "left",
			duration = 0.25
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
		pivot_offset_y = 0,
		texture_width = 636,
		screen_align_x = "center",
		stretch_relative_height = 1,
		pivot_offset_x = -262,
		screen_offset_y = 0,
		pivot_align_x = "right",
		stretch_width = 540,
		texture_height = 4,
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
		pivot_offset_y = 0,
		texture_width = 16,
		screen_align_x = "center",
		pivot_offset_x = -262,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_height = 1016
	},
	left_corner_top_texture = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_top_corner_1920",
		pivot_offset_y = 0,
		texture_width = 416,
		screen_align_x = "center",
		pivot_offset_x = -266,
		screen_offset_y = 0,
		pivot_align_x = "right",
		texture_height = 308
	},
	right_gradient_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_gradient_right_1920",
		pivot_offset_y = 0,
		texture_width = 636,
		screen_align_x = "center",
		stretch_relative_height = 1,
		pivot_offset_x = 262,
		screen_offset_y = 0,
		pivot_align_x = "left",
		stretch_width = 540,
		texture_height = 4,
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
		pivot_offset_y = 0,
		texture_width = 16,
		screen_align_x = "center",
		pivot_offset_x = 262,
		screen_offset_y = 0,
		pivot_align_x = "right",
		texture_height = 1016
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
FinalScoreboardMenuSettings.pages.main_page[1680][1050].button_info = {
	text_data = {
		font_size = 28,
		font = MenuSettings.fonts.hell_shark_28,
		offset_x = 25 * SCALE_1366,
		offset_y = 100 * SCALE_1366,
		drop_shadow = {
			2,
			-2
		}
	},
	default_buttons = {}
}

local ORANGE_COLOR = {
	255,
	203,
	100,
	25
}
local ORANGE_HIGHLIGHTED_COLOR = {
	255,
	255,
	160,
	85
}
local WHITE_COLOR = {
	255,
	255,
	255,
	255
}
local GREY_COLOR = {
	255,
	100,
	100,
	100
}

FinalScoreboardMenuSettings.items.coin_award_header = FinalScoreboardMenuSettings.items.coin_award_header or {}
FinalScoreboardMenuSettings.items.coin_award_header[1680] = {}
FinalScoreboardMenuSettings.items.coin_award_header[1680][1050] = {
	pivot_offset_y = -67,
	screen_offset_x = 0,
	font_size = 67,
	pivot_align_x = "center",
	screen_offset_y = 0,
	padding_top = 0,
	screen_align_x = "center",
	padding_bottom = 0,
	line_height = 67,
	padding_right = 0,
	screen_align_y = "top",
	padding_left = 0,
	pivot_align_y = "bottom",
	pivot_offset_x = 0,
	font = MenuSettings.fonts.font_gradient_100,
	color = ORANGE_COLOR,
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		4,
		-4
	}
}
FinalScoreboardMenuSettings.items.coin_award_header_delimiter = FinalScoreboardMenuSettings.items.coin_award_header_delimiter or {}
FinalScoreboardMenuSettings.items.coin_award_header_delimiter[1680] = {}
FinalScoreboardMenuSettings.items.coin_award_header_delimiter[1680][1050] = {
	screen_align_y = "top",
	screen_offset_x = 0,
	texture_atlas = "menu_assets",
	texture = "divider_ornament_long",
	padding_left = 0,
	padding_top = 0,
	screen_align_x = "center",
	padding_bottom = 0,
	pivot_align_y = "top",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	padding_right = 0,
	pivot_offset_y = FinalScoreboardMenuSettings.items.coin_award_header[1680][1050].pivot_offset_y - 15
}
FinalScoreboardMenuSettings.items.total_coins = FinalScoreboardMenuSettings.items.total_coins or {}
FinalScoreboardMenuSettings.items.total_coins[1680] = {}
FinalScoreboardMenuSettings.items.total_coins[1680][1050] = {
	pivot_offset_y = 30,
	screen_offset_x = 0.8,
	font_size = 32,
	pivot_align_x = "right",
	screen_offset_y = 0,
	padding_top = 9,
	screen_align_x = "left",
	padding_bottom = 9,
	line_height = 22,
	text_alignment = "right",
	padding_right = 0,
	screen_align_y = "bottom",
	padding_left = 0,
	pivot_align_y = "bottom",
	rect_width = 100,
	pivot_offset_x = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color = WHITE_COLOR,
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
FinalScoreboardMenuSettings.items.total_coins_texture = FinalScoreboardMenuSettings.items.total_coins_texture or {}
FinalScoreboardMenuSettings.items.total_coins_texture[1680] = {}
FinalScoreboardMenuSettings.items.total_coins_texture[1680][1050] = {
	texture_atlas = "menu_assets",
	padding_top = 0,
	padding_bottom = 0,
	texture = "ring",
	padding_left = 0,
	pivot_align_x = "left",
	padding_right = 0,
	screen_align_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_align_x,
	screen_align_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_align_y,
	screen_offset_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_offset_x,
	screen_offset_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_offset_y,
	pivot_align_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_align_y,
	pivot_offset_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_offset_x,
	pivot_offset_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_offset_y
}

local COINS_TEXTURE_TABLE = FinalScoreboardMenuSettings.items.total_coins_texture[1680][1050]
local COINS_TEXTURE_WIDTH = rawget(_G, COINS_TEXTURE_TABLE.texture_atlas)[COINS_TEXTURE_TABLE.texture].size[1]

FinalScoreboardMenuSettings.items.total_coins_chest_texture = FinalScoreboardMenuSettings.items.total_coins_chest_texture or {}
FinalScoreboardMenuSettings.items.total_coins_chest_texture[1680] = {}
FinalScoreboardMenuSettings.items.total_coins_chest_texture[1680][1050] = {
	texture_atlas = "menu_assets",
	padding_top = 0,
	padding_bottom = 0,
	texture = "treasure_chest",
	padding_left = 0,
	pivot_align_x = "right",
	padding_right = 0,
	screen_align_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_align_x,
	screen_align_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_align_y,
	screen_offset_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_offset_x,
	screen_offset_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].screen_offset_y,
	pivot_align_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_align_y,
	pivot_offset_x = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_offset_x + COINS_TEXTURE_WIDTH + 20,
	pivot_offset_y = FinalScoreboardMenuSettings.items.total_coins[1680][1050].pivot_offset_y + FinalScoreboardMenuSettings.items.total_coins[1680][1050].line_height
}
FinalScoreboardMenuSettings.items.round_coins = FinalScoreboardMenuSettings.items.round_coins or {}
FinalScoreboardMenuSettings.items.round_coins[1680] = {}
FinalScoreboardMenuSettings.items.round_coins[1680][1050] = {
	pivot_offset_y = 30,
	screen_offset_x = 0,
	font_size = 32,
	pivot_align_x = "left",
	screen_offset_y = 0,
	padding_top = 9,
	screen_align_x = "center",
	padding_bottom = 9,
	line_height = 22,
	text_alignment = "right",
	padding_right = 0,
	screen_align_y = "center",
	padding_left = 0,
	pivot_align_y = "bottom",
	rect_width = 100,
	pivot_offset_x = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color = GREY_COLOR,
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}

local COIN_LINE_DIFF = 38

FinalScoreboardMenuSettings.items.round_coins_texture = FinalScoreboardMenuSettings.items.round_coins_texture or {}
FinalScoreboardMenuSettings.items.round_coins_texture[1680] = {}
FinalScoreboardMenuSettings.items.round_coins_texture[1680][1050] = {
	texture_atlas = "menu_assets",
	padding_top = 0,
	padding_bottom = 0,
	texture = "ring",
	padding_left = 0,
	pivot_align_x = "left",
	padding_right = 0,
	screen_align_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_align_x,
	screen_align_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_align_y,
	screen_offset_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_offset_x,
	screen_offset_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_offset_y,
	pivot_align_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].pivot_align_y,
	pivot_offset_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].rect_width + FinalScoreboardMenuSettings.items.round_coins[1680][1050].pivot_offset_x,
	pivot_offset_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].pivot_offset_y
}
FinalScoreboardMenuSettings.items.round_coins_header = FinalScoreboardMenuSettings.items.round_coins_header or {}
FinalScoreboardMenuSettings.items.round_coins_header[1680] = {}
FinalScoreboardMenuSettings.items.round_coins_header[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_coins[1680][1050])
FinalScoreboardMenuSettings.items.round_coins_header[1680][1050].pivot_align_x = "right"
FinalScoreboardMenuSettings.items.round_coins_header[1680][1050].text_alignment = nil
FinalScoreboardMenuSettings.items.round_coins_header[1680][1050].rect_width = nil
FinalScoreboardMenuSettings.items.round_coins_header[1680][1050].color = ORANGE_COLOR
FinalScoreboardMenuSettings.items.short_term_goal_bonus = FinalScoreboardMenuSettings.items.short_term_goal_bonus or {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680] = {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_coins[1680][1050])
FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].pivot_offset_y - COIN_LINE_DIFF
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent = FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent or {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680] = {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050])
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680][1050].pivot_align_x = "left"
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680][1050].pivot_offset_x = FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050].rect_width + FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050].pivot_offset_x
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680][1050].text_alignment = "center"
FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent[1680][1050].rect_width = COINS_TEXTURE_WIDTH
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header = FinalScoreboardMenuSettings.items.short_term_goal_bonus_header or {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680] = {}
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050])
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680][1050].pivot_align_x = "right"
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680][1050].rect_width = nil
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680][1050].text_alignment = nil
FinalScoreboardMenuSettings.items.short_term_goal_bonus_header[1680][1050].color = ORANGE_COLOR
FinalScoreboardMenuSettings.items.event_bonus = FinalScoreboardMenuSettings.items.event_bonus or {}
FinalScoreboardMenuSettings.items.event_bonus[1680] = {}
FinalScoreboardMenuSettings.items.event_bonus[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050])
FinalScoreboardMenuSettings.items.event_bonus[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.short_term_goal_bonus[1680][1050].pivot_offset_y - COIN_LINE_DIFF
FinalScoreboardMenuSettings.items.event_bonus_procent = FinalScoreboardMenuSettings.items.event_bonus_procent or {}
FinalScoreboardMenuSettings.items.event_bonus_procent[1680] = {}
FinalScoreboardMenuSettings.items.event_bonus_procent[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.event_bonus[1680][1050])
FinalScoreboardMenuSettings.items.event_bonus_procent[1680][1050].pivot_align_x = "left"
FinalScoreboardMenuSettings.items.event_bonus_procent[1680][1050].pivot_offset_x = FinalScoreboardMenuSettings.items.event_bonus[1680][1050].rect_width + FinalScoreboardMenuSettings.items.event_bonus[1680][1050].pivot_offset_x
FinalScoreboardMenuSettings.items.event_bonus_procent[1680][1050].text_alignment = "center"
FinalScoreboardMenuSettings.items.event_bonus_procent[1680][1050].rect_width = COINS_TEXTURE_WIDTH
FinalScoreboardMenuSettings.items.event_bonus_header = FinalScoreboardMenuSettings.items.event_bonus_header or {}
FinalScoreboardMenuSettings.items.event_bonus_header[1680] = FinalScoreboardMenuSettings.items.event_bonus_header[1680] or {}
FinalScoreboardMenuSettings.items.event_bonus_header[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.event_bonus[1680][1050])
FinalScoreboardMenuSettings.items.event_bonus_header[1680][1050].pivot_align_x = "right"
FinalScoreboardMenuSettings.items.event_bonus_header[1680][1050].rect_width = nil
FinalScoreboardMenuSettings.items.event_bonus_header[1680][1050].text_alignment = nil
FinalScoreboardMenuSettings.items.event_bonus_header[1680][1050].color = ORANGE_HIGHLIGHTED_COLOR
FinalScoreboardMenuSettings.items.first_win_coins = FinalScoreboardMenuSettings.items.first_win_coins or {}
FinalScoreboardMenuSettings.items.first_win_coins[1680] = {}
FinalScoreboardMenuSettings.items.first_win_coins[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.event_bonus[1680][1050])
FinalScoreboardMenuSettings.items.first_win_coins[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.event_bonus[1680][1050].pivot_offset_y - COIN_LINE_DIFF
FinalScoreboardMenuSettings.items.first_win_coins_texture = FinalScoreboardMenuSettings.items.first_win_coins_texture or {}
FinalScoreboardMenuSettings.items.first_win_coins_texture[1680] = {}
FinalScoreboardMenuSettings.items.first_win_coins_texture[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_coins_texture[1680][1050])
FinalScoreboardMenuSettings.items.first_win_coins_texture[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.first_win_coins[1680][1050].pivot_offset_y
FinalScoreboardMenuSettings.items.first_win_coins_header = FinalScoreboardMenuSettings.items.first_win_coins_header or {}
FinalScoreboardMenuSettings.items.first_win_coins_header[1680] = {}
FinalScoreboardMenuSettings.items.first_win_coins_header[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.first_win_coins[1680][1050])
FinalScoreboardMenuSettings.items.first_win_coins_header[1680][1050].pivot_align_x = "right"
FinalScoreboardMenuSettings.items.first_win_coins_header[1680][1050].rect_width = nil
FinalScoreboardMenuSettings.items.first_win_coins_header[1680][1050].text_alignment = nil
FinalScoreboardMenuSettings.items.first_win_coins_header[1680][1050].color = ORANGE_COLOR
FinalScoreboardMenuSettings.items.round_total_divider_texture = FinalScoreboardMenuSettings.items.round_total_divider_texture or {}
FinalScoreboardMenuSettings.items.round_total_divider_texture[1680] = {}
FinalScoreboardMenuSettings.items.round_total_divider_texture[1680][1050] = {
	texture_atlas = "menu_assets",
	texture = "spoils_of_war_divider",
	padding_top = 0,
	padding_bottom = 0,
	pivot_align_y = "center",
	padding_left = 0,
	pivot_align_x = "right",
	padding_right = 0,
	screen_align_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_align_x,
	screen_align_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_align_y,
	screen_offset_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_offset_x,
	screen_offset_y = FinalScoreboardMenuSettings.items.round_coins[1680][1050].screen_offset_y,
	pivot_offset_x = FinalScoreboardMenuSettings.items.round_coins[1680][1050].rect_width + FinalScoreboardMenuSettings.items.round_coins[1680][1050].pivot_offset_x + COINS_TEXTURE_WIDTH - 8,
	pivot_offset_y = FinalScoreboardMenuSettings.items.first_win_coins[1680][1050].pivot_offset_y - 10
}
FinalScoreboardMenuSettings.items.round_total = FinalScoreboardMenuSettings.items.round_total or {}
FinalScoreboardMenuSettings.items.round_total[1680] = {}
FinalScoreboardMenuSettings.items.round_total[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_coins[1680][1050])
FinalScoreboardMenuSettings.items.round_total[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.round_total_divider_texture[1680][1050].pivot_offset_y - 10 - COIN_LINE_DIFF
FinalScoreboardMenuSettings.items.round_total_texture = FinalScoreboardMenuSettings.items.round_total_texture or {}
FinalScoreboardMenuSettings.items.round_total_texture[1680] = {}
FinalScoreboardMenuSettings.items.round_total_texture[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_coins_texture[1680][1050])
FinalScoreboardMenuSettings.items.round_total_texture[1680][1050].pivot_offset_y = FinalScoreboardMenuSettings.items.round_total[1680][1050].pivot_offset_y
FinalScoreboardMenuSettings.items.round_total_header = FinalScoreboardMenuSettings.items.round_total_header or {}
FinalScoreboardMenuSettings.items.round_total_header[1680] = {}
FinalScoreboardMenuSettings.items.round_total_header[1680][1050] = table.clone(FinalScoreboardMenuSettings.items.round_total[1680][1050])
FinalScoreboardMenuSettings.items.round_total_header[1680][1050].pivot_align_x = "right"
FinalScoreboardMenuSettings.items.round_total_header[1680][1050].rect_width = nil
FinalScoreboardMenuSettings.items.round_total_header[1680][1050].text_alignment = nil
FinalScoreboardMenuSettings.items.round_total_header[1680][1050].color = ORANGE_COLOR
