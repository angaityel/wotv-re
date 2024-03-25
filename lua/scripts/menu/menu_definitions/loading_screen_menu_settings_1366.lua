-- chunkname: @scripts/menu/menu_definitions/loading_screen_menu_settings_1366.lua

SCALE_1366 = 0.7114583333333333
LoadingScreenMenuSettings = LoadingScreenMenuSettings or {}
LoadingScreenMenuSettings.items = LoadingScreenMenuSettings.items or {}
LoadingScreenMenuSettings.pages = LoadingScreenMenuSettings.pages or {}
LoadingScreenMenuSettings.music_events = {}
LoadingScreenMenuSettings.items.loading_indicator = LoadingScreenMenuSettings.items.loading_indicator or {}
LoadingScreenMenuSettings.items.loading_indicator[1366] = LoadingScreenMenuSettings.items.loading_indicator[1366] or {}
LoadingScreenMenuSettings.items.loading_indicator[1366][768] = LoadingScreenMenuSettings.items.loading_indicator[1366][768] or {
	pivot_offset_y = 0,
	screen_offset_x = -0.04,
	pivot_align_y = "bottom",
	fade_end_delay = 1,
	screen_align_y = "bottom",
	texture = "loading_icon_mockup",
	texture_rotation_angle = 90,
	fade_start_delay = 2,
	font_size = 22,
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
	texture_scale = 0.6 * SCALE_1366,
	text_color = {
		255,
		255,
		255,
		255
	},
	font = MenuSettings.fonts.hell_shark_22,
	text_padding = 20 * SCALE_1366,
	loading_icon_config = {
		animation_speed = 64,
		texture_atlas = "loading_atlas",
		padding_right = 0,
		padding_left = 0,
		frames = {},
		texture_width = 40 * SCALE_1366,
		texture_height = 40 * SCALE_1366,
		texture_atlas_settings = LoadingAtlas,
		padding_top = 18 * SCALE_1366,
		padding_bottom = -50 * SCALE_1366,
		scale = 0.5 * SCALE_1366
	}
}

for i = 1, 64 do
	LoadingScreenMenuSettings.items.loading_indicator[1366][768].loading_icon_config.frames[i] = string.format("loading_shield_%.2d", i)
end

LoadingScreenMenuSettings.items.next_arrow = LoadingScreenMenuSettings.items.next_arrow or {}
LoadingScreenMenuSettings.items.next_arrow[1366] = LoadingScreenMenuSettings.items.next_arrow[1366] or {}
LoadingScreenMenuSettings.items.next_arrow[1366][768] = LoadingScreenMenuSettings.items.next_arrow[1366][768] or {
	padding_bottom = 0,
	z = 100,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
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
	offset_x = 270 * SCALE_1366,
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
LoadingScreenMenuSettings.items.prev_arrow[1366] = LoadingScreenMenuSettings.items.prev_arrow[1366] or {}
LoadingScreenMenuSettings.items.prev_arrow[1366][768] = LoadingScreenMenuSettings.items.prev_arrow[1366][768] or {
	padding_bottom = 0,
	z = 100,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
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
	offset_x = -270 * SCALE_1366,
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
LoadingScreenMenuSettings.items.next_button = LoadingScreenMenuSettings.items.next_button or {}
LoadingScreenMenuSettings.items.next_button[1366] = LoadingScreenMenuSettings.items.next_button[1366] or {}
LoadingScreenMenuSettings.items.next_button[1366][768] = LoadingScreenMenuSettings.items.next_button[1366][768] or {
	no_middle_texture = true,
	font_size = 18,
	text_offset_y = 16,
	text_padding = 0,
	padding_bottom = 0,
	padding_top = 0,
	padding_left = 14,
	z = 10,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_18,
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
LoadingScreenMenuSettings.items.previous_button[1366] = LoadingScreenMenuSettings.items.previous_button[1366] or {}
LoadingScreenMenuSettings.items.previous_button[1366][768] = LoadingScreenMenuSettings.items.previous_button[1366][768] or {
	no_middle_texture = true,
	font_size = 18,
	text_offset_y = 16,
	text_padding = 0,
	padding_bottom = 0,
	padding_top = 0,
	padding_left = 14,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_18,
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
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1366] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1366] or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1366][768] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned[1366][768] or {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 28,
	padding_top = 11,
	padding_bottom = 11,
	line_height = 15,
	padding_right = 14,
	font = MenuSettings.fonts.hell_shark_28,
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
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned = LoadingScreenMenuSettings.items.loading_screen_header_center_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1366] = LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1366] or {}
LoadingScreenMenuSettings.items.loading_screen_header_center_aligned[1366][768] = {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 18,
	padding_top = 0,
	padding_bottom = 11,
	line_height = 15,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_18,
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
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1366] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1366] or {}
LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1366][768] = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big[1366][768] or {
	padding_left = 0,
	background_stripe = true,
	background_stripe_size = 0.7,
	font_size = 42,
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
LoadingScreenMenuSettings.items.server_banner = LoadingScreenMenuSettings.items.server_banner or {}
LoadingScreenMenuSettings.items.server_banner[1366] = LoadingScreenMenuSettings.items.server_banner[1366] or {}
LoadingScreenMenuSettings.items.server_banner[1366][768] = LoadingScreenMenuSettings.items.server_banner[1366][768] or {
	texture = "server_banner_1920",
	padding_bottom = 7,
	padding_left = 0,
	padding_top = 14,
	padding_right = 14,
	texture_width = 512 * SCALE_1366,
	texture_height = 128 * SCALE_1366
}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1366] = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1366] or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1366][768] = LoadingScreenMenuSettings.items.loading_screen_text_box_right_aligned[1366][768] or {
	padding_left = 0,
	font_size = 16,
	padding_top = 0,
	text_align = "right",
	line_height = 21,
	font = MenuSettings.fonts.hell_shark_16,
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
	},
	width = 440 * SCALE_1366,
	padding_bottom = 50 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned = LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned[1366] = LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned[1366] or {}
LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned[1366][768] = LoadingScreenMenuSettings.items.loading_screen_text_box_left_aligned[1366][768] or {
	padding_left = 0,
	font_size = 16,
	padding_top = 0,
	text_align = "left",
	line_height = 21,
	font = MenuSettings.fonts.hell_shark_16,
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
	},
	width = 440 * SCALE_1366,
	padding_bottom = 50 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
LoadingScreenMenuSettings.pages.loading_screen = LoadingScreenMenuSettings.pages.loading_screen or {}
LoadingScreenMenuSettings.pages.loading_screen[1366] = LoadingScreenMenuSettings.pages.loading_screen[1366] or {}
LoadingScreenMenuSettings.pages.loading_screen[1366][768] = LoadingScreenMenuSettings.pages.loading_screen[1366][768] or table.clone(MainMenuSettings.pages.level_1[1366][768])
LoadingScreenMenuSettings.pages.loading_screen[1366][768].item_list.screen_align_y = "center"
LoadingScreenMenuSettings.pages.loading_screen[1366][768].item_list.pivot_align_y = "center"
LoadingScreenMenuSettings.pages.loading_screen[1366][768].item_list.screen_offset_y = 0
LoadingScreenMenuSettings.pages.loading_screen[1366][768].logo_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1366][768].gradient_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1366][768].vertical_line_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1366][768].corner_top_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1366][768].corner_bottom_texture = nil
LoadingScreenMenuSettings.pages.loading_screen[1366][768].item_list = {
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
LoadingScreenMenuSettings.pages.loading_screen[1366][768].arrow_list = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	number_of_columns = 2,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0.15,
	pivot_align_x = "center",
	column_alignment = {
		"center"
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1366][768].level_description = {
	screen_offset_y = 0.4,
	screen_offset_x = 0.05,
	screen_align_x = "left",
	font_size = 16,
	pivot_align_y = "top",
	background_rect = true,
	no_localization = true,
	screen_align_y = "bottom",
	pivot_offset_y = 0,
	text_align = "center",
	pivot_offset_x = 0,
	pivot_align_x = "left",
	background_rect_offset = 5,
	font = MenuSettings.fonts.hell_shark_16,
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
	width = 400 * SCALE_1366,
	background_color = {
		128,
		0,
		0,
		0
	},
	background_size = {
		300,
		200
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1366][768].page_links = {
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
LoadingScreenMenuSettings.pages.loading_screen[1366][768].tip_of_the_day = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	tip_background_texture = {
		texture = "right_info_bgr_1366",
		texture_height = 604,
		texture_width = 492,
		texture_color = {
			210,
			255,
			255,
			255
		}
	},
	tip_graphics = {
		video_key = "video_1920",
		height = 236,
		texture_key = "texture_1920",
		width = 424,
		offset_x = 22 * SCALE_1366,
		offset_y = 436 * SCALE_1366
	},
	tip_text = {
		offset_x = 0,
		offset_y = 120,
		font_size = 14,
		text_align = "left",
		font = MenuSettings.fonts.hell_shark_14,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 20 * SCALE_1366,
		width = 500 * SCALE_1366,
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
		texture = "item_list_top_corner_1366",
		texture_width = 292,
		texture_height = 216,
		texture_offset_x = 290 * SCALE_1366,
		texture_offset_y = 542 * SCALE_1366
	}
}
LoadingScreenMenuSettings.pages.loading_screen[1366][768].message_of_the_day = {
	screen_offset_x = -0.05,
	font_size = 16,
	pivot_align_y = "center",
	padding_top = 0,
	screen_align_x = "right",
	line_height = 21,
	screen_align_y = "center",
	pivot_offset_y = 0,
	text_align = "left",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	font = MenuSettings.fonts.hell_shark_16,
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
	},
	width = 625 * SCALE_1366,
	padding_bottom = 50 * SCALE_1366,
	padding_left = 20 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
LoadingScreenMenuSettings.pages.loading_screen[1366][768].background_level_texture = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "loading_screen_background",
	pivot_offset_y = 0,
	screen_align_x = "left",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	texture_width = 300 * SCALE_1366,
	texture_height = 168 * SCALE_1366
}
LoadingScreenMenuSettings.pages.loading_screen[1366][768].button_info = {
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
	default_buttons = {
		{
			button_name = "a",
			text = "menu_start_battle"
		},
		{
			button_name = "y",
			text = "menu_next_tip"
		}
	}
}
LoadingScreenMenuSettings.pages.loading_screen_first_round = LoadingScreenMenuSettings.pages.loading_screen_first_round or {}
LoadingScreenMenuSettings.pages.loading_screen_first_round[1366] = LoadingScreenMenuSettings.pages.loading_screen_first_round[1366] or {}
LoadingScreenMenuSettings.pages.loading_screen_first_round[1366][768] = LoadingScreenMenuSettings.pages.loading_screen_first_round[1366][768] or table.clone(LoadingScreenMenuSettings.pages.loading_screen[1366][768])
LoadingScreenMenuSettings.pages.loading_screen_first_round[1366][768].button_info.default_buttons = {
	{
		button_name = "y",
		text = "menu_next_tip"
	},
	{
		button_name = "a",
		text = "menu_start_battle"
	}
}
