-- chunkname: @scripts/menu/menu_definitions/loading_screen_menu_settings_1920.lua

LoadingScreenMenuSettings = LoadingScreenMenuSettings or {}
LoadingScreenMenuSettings.items = LoadingScreenMenuSettings.items or {}
LoadingScreenMenuSettings.pages = LoadingScreenMenuSettings.pages or {}
LoadingScreenMenuSettings.music_events = {}
LoadingScreenMenuSettings.items.loading_indicator = LoadingScreenMenuSettings.items.loading_indicator or {}
LoadingScreenMenuSettings.items.loading_indicator[1680] = LoadingScreenMenuSettings.items.loading_indicator[1680] or {}
LoadingScreenMenuSettings.items.loading_indicator[1680][1050] = LoadingScreenMenuSettings.items.loading_indicator[1680][1050] or {
	pivot_offset_y = 0,
	screen_offset_x = -0.04,
	pivot_align_y = "bottom",
	fade_end_delay = 1,
	screen_align_y = "bottom",
	texture = "loading_icon_mockup",
	texture_rotation_angle = 90,
	fade_start_delay = 2,
	text_padding = 20,
	texture_scale = 0.6,
	font_size = 30,
	screen_align_x = "right",
	pivot_offset_x = 0,
	screen_offset_y = 0.08,
	pivot_align_x = "right",
	texture_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		255,
		255,
		255,
		255
	},
	font = MenuSettings.fonts.hell_shark_30,
	loading_icon_config = {
		padding_bottom = -50,
		animation_speed = 64,
		texture_atlas = "loading_atlas",
		padding_right = 0,
		padding_left = 0,
		padding_top = 18,
		texture_width = 40,
		scale = 0.5,
		texture_height = 40,
		frames = {},
		texture_atlas_settings = LoadingAtlas
	}
}

for i = 1, 64 do
	LoadingScreenMenuSettings.items.loading_indicator[1680][1050].loading_icon_config.frames[i] = string.format("loading_shield_%.2d", i)
end

LoadingScreenMenuSettings.items.next_arrow = LoadingScreenMenuSettings.items.next_arrow or {}
LoadingScreenMenuSettings.items.next_arrow[1680] = LoadingScreenMenuSettings.items.next_arrow[1680] or {}
LoadingScreenMenuSettings.items.next_arrow[1680][1050] = LoadingScreenMenuSettings.items.next_arrow[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = 270,
	padding_left = 0,
	arrow_size_x = 30,
	arrow_size_y = 30,
	arrow_facing = "right",
	padding_top = 0,
	drop_shadow = true,
	padding_right = 0,
	color = {
		128,
		255,
		255,
		255
	},
	color_highlighted = {
		255,
		255,
		255,
		255
	},
	drop_shadow_offset = {
		4,
		4
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
LoadingScreenMenuSettings.items.prev_arrow = LoadingScreenMenuSettings.items.prev_arrow or {}
LoadingScreenMenuSettings.items.prev_arrow[1680] = LoadingScreenMenuSettings.items.prev_arrow[1680] or {}
LoadingScreenMenuSettings.items.prev_arrow[1680][1050] = LoadingScreenMenuSettings.items.prev_arrow[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = -270,
	padding_left = 0,
	arrow_size_x = 30,
	arrow_size_y = 30,
	arrow_facing = "left",
	padding_top = 0,
	drop_shadow = true,
	padding_right = 0,
	color = {
		128,
		255,
		255,
		255
	},
	color_highlighted = {
		255,
		255,
		255,
		255
	},
	drop_shadow_offset = {
		4,
		4
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1680] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1680] or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1680][1050] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1680][1050] or {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 36,
	padding_top = 11,
	padding_bottom = 11,
	line_height = 15,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_36,
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
	},
	background_stripe_color = {
		128,
		0,
		0,
		0
	}
}
LoadingScreenMenuSettings.items.server_banner = LoadingScreenMenuSettings.items.server_banner or {}
LoadingScreenMenuSettings.items.server_banner[1680] = LoadingScreenMenuSettings.items.server_banner[1680] or {}
LoadingScreenMenuSettings.items.server_banner[1680][1050] = LoadingScreenMenuSettings.items.server_banner[1680][1050] or {
	texture = "server_banner_1920",
	padding_bottom = 10,
	texture_width = 512,
	padding_left = 0,
	padding_top = 20,
	padding_right = 20,
	texture_height = 128
}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1680] = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1680] or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1680][1050] = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1680][1050] or {
	padding_left = 0,
	padding_right = 20,
	font_size = 20,
	padding_top = 0,
	text_align = "right",
	padding_bottom = 50,
	line_height = 26,
	width = 440,
	font = MenuSettings.fonts.hell_shark_20,
	color = {
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
LoadingScreenMenuSettings.pages.loading_screen = LoadingScreenMenuSettings.pages.loading_screen or {}
LoadingScreenMenuSettings.pages.loading_screen[1680] = LoadingScreenMenuSettings.pages.loading_screen[1680] or {}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050] = LoadingScreenMenuSettings.pages.loading_screen[1680][1050] or table.clone(MainMenuSettings.pages.level_1[1680][1050])
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].item_list.screen_align_y = "center"
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].item_list.pivot_align_y = "center"
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].item_list.screen_offset_y = 0
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].logo_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].gradient_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].vertical_line_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].corner_top_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].corner_bottom_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].item_list = {
	screen_align_y = "top",
	screen_offset_x = -0.1,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "right",
	pivot_offset_x = 0,
	screen_offset_y = -0.1,
	pivot_align_x = "right",
	column_alignment = {
		"right"
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].level_description = {
	screen_offset_y = 0.45,
	screen_offset_x = 0.025,
	screen_align_x = "left",
	font_size = 22,
	pivot_align_y = "top",
	background_rect = true,
	no_localization = true,
	screen_align_y = "bottom",
	pivot_offset_y = 0,
	text_align = "center",
	pivot_offset_x = 0,
	pivot_align_x = "left",
	width = 450,
	background_rect_offset = 5,
	font = MenuSettings.fonts.hell_shark_22,
	text_color = {
		255,
		255,
		255,
		255
	},
	color = {
		255,
		255,
		255,
		255
	},
	line_height = 30 * SCALE_1366,
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	},
	background_color = {
		128,
		0,
		0,
		0
	},
	background_size = {
		450,
		350
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].arrow_list = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	number_of_columns = 2,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0.11,
	pivot_align_x = "center",
	column_alignment = {
		"center"
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].page_links = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 0,
	screen_align_x = "right",
	number_of_columns = 2,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	column_alignment = {
		"center"
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].tip_of_the_day = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	tip_background_texture = {
		texture = "right_info_bgr_1920",
		texture_height = 860,
		texture_width = 700,
		texture_color = {
			210,
			255,
			255,
			255
		}
	},
	tip_graphics = {
		video_key = "video_1920",
		height = 332,
		texture_key = "texture_1920",
		offset_y = 436,
		offset_x = 22,
		width = 596
	},
	tip_text = {
		offset_x = 0,
		offset_y = 140,
		font_size = 24,
		text_align = "left",
		line_height = 20,
		width = 500,
		font = MenuSettings.fonts.hell_shark_24,
		color = {
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
	},
	corner_top_texture = {
		texture = "item_list_top_corner_1920",
		texture_offset_y = 542,
		texture_width = 416,
		texture_offset_x = 290,
		texture_height = 308
	}
}
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned = LoadingScreenMenuSettings.items.loading_screen_header_center_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1680] = LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1050] or {}
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1680][1050] = {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 36,
	padding_top = 0,
	padding_bottom = 11,
	line_height = 15,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
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
	},
	background_stripe_color = {
		128,
		0,
		0,
		0
	}
}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1680] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1680] or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1680][1050] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1680][1050] or {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 65,
	padding_top = 11,
	padding_bottom = 0,
	line_height = 15,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_36,
	color_disabled = {
		255,
		253,
		242,
		101
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
	},
	background_stripe_color = {
		128,
		0,
		0,
		0
	}
}
LoadingScreenMenuSettings.items.next_button = LoadingScreenMenuSettings.items.next_button or {}
LoadingScreenMenuSettings.items.next_button[1680] = LoadingScreenMenuSettings.items.next_button[1680] or {}
LoadingScreenMenuSettings.items.next_button[1680][1050] = LoadingScreenMenuSettings.items.next_button[1680][1050] or {
	no_middle_texture = true,
	font_size = 26,
	text_offset_y = 16,
	text_padding = 0,
	padding_bottom = 0,
	padding_top = 0,
	padding_left = 14,
	z = 10,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_26,
	text_color = {
		255,
		203,
		100,
		25
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		125,
		125,
		125
	},
	drop_shadow_color_highlighted = {
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
LoadingScreenMenuSettings.items.previous_button = LoadingScreenMenuSettings.items.previous_button or {}
LoadingScreenMenuSettings.items.previous_button[1680] = LoadingScreenMenuSettings.items.previous_button[1680] or {}
LoadingScreenMenuSettings.items.previous_button[1680][1050] = LoadingScreenMenuSettings.items.previous_button[1680][1050] or {
	no_middle_texture = true,
	font_size = 26,
	text_offset_y = 16,
	text_padding = 0,
	padding_bottom = 0,
	padding_top = 0,
	padding_left = 14,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_26,
	text_color = {
		255,
		203,
		100,
		25
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		125,
		125,
		125
	},
	drop_shadow_color_highlighted = {
		255,
		0,
		0,
		0
	},
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
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].message_of_the_day = {
	screen_offset_x = -0.05,
	font_size = 26,
	pivot_align_y = "center",
	padding_top = 0,
	screen_align_x = "right",
	padding_bottom = 50,
	line_height = 21,
	padding_left = 20,
	padding_right = 20,
	screen_align_y = "center",
	pivot_offset_y = 0,
	text_align = "left",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	width = 625,
	font = MenuSettings.fonts.hell_shark_26,
	color = {
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
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].background_level_texture = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "loading_screen_background",
	pivot_offset_y = 0,
	texture_width = 300,
	screen_align_x = "left",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	texture_height = 168
}
LoadingScreenMenuSettings.pages.loading_screen[1680][1050].button_info = {
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
	default_buttons = {
		{
			button_name = "a",
			text = "menu_scoreboard"
		},
		{
			button_name = "y",
			text = "menu_next_tip"
		}
	}
}
LoadingScreenMenuSettings.pages.loading_screen_first_round = LoadingScreenMenuSettings.pages.loading_screen_first_round or {}
LoadingScreenMenuSettings.pages.loading_screen_first_round[1680] = LoadingScreenMenuSettings.pages.loading_screen_first_round[1680] or {}
LoadingScreenMenuSettings.pages.loading_screen_first_round[1680][1050] = LoadingScreenMenuSettings.pages.loading_screen_first_round[1680][1050] or table.clone(LoadingScreenMenuSettings.pages.loading_screen[1680][1050])
LoadingScreenMenuSettings.pages.loading_screen_first_round[1680][1050].button_info.default_buttons = {
	{
		button_name = "y",
		text = "menu_next_tip"
	},
	{
		button_name = "a",
		text = "menu_start_battle"
	}
}
