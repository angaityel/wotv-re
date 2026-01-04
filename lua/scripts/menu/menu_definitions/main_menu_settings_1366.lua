-- chunkname: @scripts/menu/menu_definitions/main_menu_settings_1366.lua

require("scripts/settings/menu_settings")
require("scripts/settings/coat_of_arms")
require("gui/textures/loading_atlas")
require("gui/textures/outfit_atlas")
require("gui/textures/perk_atlas")
require("scripts/menu/menu_definitions/final_scoreboard_menu_settings_1366")

SCALE_1366 = 0.7114583333333333
MainMenuSettings = MainMenuSettings or {}
MainMenuSettings.items = MainMenuSettings.items or {}
MainMenuSettings.pages = MainMenuSettings.pages or {}
MainMenuSettings.containers = MainMenuSettings.containers or {}
MainMenuSettings.level = MainMenuSettings.level or {
	level_name = "main_menu_release"
}
MainMenuSettings.music_events = {
	on_menu_init = {
		"Play_menu_music"
	},
	on_menu_destroy = {
		"Stop_main_menu_ambience"
	}
}
MainMenuSettings.containers.news_ticker = MainMenuSettings.containers.news_ticker or {}
MainMenuSettings.containers.news_ticker[1366] = MainMenuSettings.containers.news_ticker[1366] or {}
MainMenuSettings.containers.news_ticker[1366][768] = MainMenuSettings.containers.news_ticker[1366][768] or {
	screen_align_x = "left",
	height = 32,
	pivot_offset_y = -8,
	pivot_align_y = "top",
	text_offset_y = 9,
	screen_offset_x = 0,
	delimiter_texture_width = 64,
	delimiter_texture_height = 28,
	left_background_texture = "news_ticker_left_1366",
	right_background_texture_width = 392,
	right_background_texture = "news_ticker_right_1366",
	delimiter_texture = "news_ticker_delimiter_1366",
	left_background_texture_height = 32,
	screen_align_y = "top",
	right_background_texture_height = 32,
	font_size = 18,
	text_spacing = 156,
	delimiter_texture_offset_y = 2,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	left_background_texture_width = 392,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_shadow_color = {
		200,
		0,
		0,
		0
	},
	text_shadow_offset = {
		2,
		-2
	},
	delimiter_texture_color = {
		200,
		255,
		255,
		255
	},
	background_rect_color = {
		80,
		0,
		0,
		0
	},
	background_texture_color = {
		150,
		255,
		255,
		255
	}
}
MainMenuSettings.items.xp_progress_bar = MainMenuSettings.items.xp_progress_bar or {}
MainMenuSettings.items.xp_progress_bar[1366] = MainMenuSettings.items.xp_progress_bar[1366] or {}
MainMenuSettings.items.xp_progress_bar[1366][768] = MainMenuSettings.items.xp_progress_bar[1366][768] or {
	texture_bar_bgr = "xp_progress_bar_bgr_1920",
	texture_bar = "xp_progress_bar_1920",
	text_bar_font_size = 11,
	border_size = 1,
	text_sides_font_size = 18,
	bar_width = 340 * SCALE_1366,
	bar_height = 20 * SCALE_1366,
	border_color = {
		200,
		150,
		150,
		150
	},
	texture_bar_bgr_color = {
		255,
		255,
		255,
		255
	},
	texture_bar_color = {
		255,
		255,
		255,
		255
	},
	text_bar_font = MenuSettings.fonts.hell_shark_11,
	text_bar_drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	text_bar_drop_shadow_offset = {
		2,
		-2
	},
	text_bar_offset_y = 6 * SCALE_1366,
	text_sides_font = MenuSettings.fonts.hell_shark_18,
	text_sides_drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	text_sides_drop_shadow_offset = {
		2,
		-2
	},
	text_sides_padding = 8 * SCALE_1366,
	text_sides_offset_y = 4 * SCALE_1366
}
MainMenuSettings.items.popup_header = MainMenuSettings.items.popup_header or {}
MainMenuSettings.items.popup_header[1366] = MainMenuSettings.items.popup_header[1366] or {}
MainMenuSettings.items.popup_header[1366][768] = MainMenuSettings.items.popup_header[1366][768] or {
	texture_disabled = "popup_title_bar_1920",
	font_size = 14,
	padding_top = 0,
	texture_alignment = "left",
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_14,
	line_height = 13 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	texture_disabled_width = 604 * SCALE_1366,
	texture_disabled_height = 32 * SCALE_1366,
	padding_left = 25 * SCALE_1366
}
MainMenuSettings.items.buy_coins_popup_header = MainMenuSettings.items.buy_coins_popup_header or {}
MainMenuSettings.items.buy_coins_popup_header[1366] = MainMenuSettings.items.buy_coins_popup_header[1366] or {}
MainMenuSettings.items.buy_coins_popup_header[1366][768] = table.clone(MainMenuSettings.items.popup_header[1366][768])
MainMenuSettings.items.buy_coins_popup_header[1366][768].texture_disabled_width = 654
MainMenuSettings.items.pdx_login_popup_header = MainMenuSettings.items.pdx_login_popup_header or {}
MainMenuSettings.items.pdx_login_popup_header[1366] = MainMenuSettings.items.pdx_login_popup_header[1366] or {}
MainMenuSettings.items.pdx_login_popup_header[1366][768] = table.clone(MainMenuSettings.items.popup_header[1366][768])
MainMenuSettings.items.pdx_login_popup_header[1366][768].texture_disabled_width = 562 * SCALE_1366
MainMenuSettings.items.popup_header_alert = MainMenuSettings.items.popup_header_alert or {}
MainMenuSettings.items.popup_header_alert[1366] = MainMenuSettings.items.popup_header_alert[1366] or {}
MainMenuSettings.items.popup_header_alert[1366][768] = MainMenuSettings.items.popup_header_alert[1366][768] or table.clone(MainMenuSettings.items.popup_header[1366][768])
MainMenuSettings.items.popup_header_alert[1366][768].color_disabled = {
	255,
	255,
	50,
	50
}
MainMenuSettings.items.popup_input = MainMenuSettings.items.popup_input or {}
MainMenuSettings.items.popup_input[1366] = MainMenuSettings.items.popup_input[1366] or {}
MainMenuSettings.items.popup_input[1366][768] = MainMenuSettings.items.popup_input[1366][768] or {
	texture_background = "popup_input_background_1920",
	font_size = 14,
	texture_offset_y = 0,
	font = MenuSettings.fonts.hell_shark_14,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_offset_y = 11 * SCALE_1366,
	texture_background_width = 520 * SCALE_1366,
	texture_background_height = 36 * SCALE_1366,
	marker_width = 2 * SCALE_1366,
	marker_height = 24 * SCALE_1366,
	marker_offset_y = 7 * SCALE_1366,
	width = 520 * SCALE_1366,
	height = 36 * SCALE_1366
}
MainMenuSettings.items.popup_text = MainMenuSettings.items.popup_text or {}
MainMenuSettings.items.popup_text[1366] = MainMenuSettings.items.popup_text[1366] or {}
MainMenuSettings.items.popup_text[1366][768] = MainMenuSettings.items.popup_text[1366][768] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 14,
	padding_top = 0,
	padding_bottom = 0,
	font = MenuSettings.fonts.hell_shark_14,
	line_height = 13 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.pdx_login_popup_error_text = MainMenuSettings.items.pdx_login_popup_error_text or {}
MainMenuSettings.items.pdx_login_popup_error_text[1366] = MainMenuSettings.items.pdx_login_popup_error_text[1366] or {}
MainMenuSettings.items.pdx_login_popup_error_text[1366][768] = table.clone(MainMenuSettings.items.popup_text[1366][768])
MainMenuSettings.items.pdx_login_popup_error_text[1366][768].color_disabled = {
	255,
	255,
	0,
	0
}
MainMenuSettings.items.connection_popup_text = MainMenuSettings.items.connection_popup_text or {}
MainMenuSettings.items.connection_popup_text[1366] = MainMenuSettings.items.connection_popup_text[1366] or {}
MainMenuSettings.items.connection_popup_text[1366][768] = MainMenuSettings.items.connection_popup_text[1366][768] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 14,
	padding_top = 0,
	padding_bottom = 25,
	font = MenuSettings.fonts.hell_shark_14,
	line_height = 13 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.popup_textbox = MainMenuSettings.items.popup_textbox or {}
MainMenuSettings.items.popup_textbox[1366] = MainMenuSettings.items.popup_textbox[1366] or {}
MainMenuSettings.items.popup_textbox[1366][768] = MainMenuSettings.items.popup_textbox[1366][768] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 13,
	padding_top = 0,
	text_align = "left",
	padding_bottom = 0,
	font = MenuSettings.fonts.hell_shark_13,
	color = {
		255,
		255,
		255,
		255
	},
	line_height = 25 * SCALE_1366,
	width = 550 * SCALE_1366,
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
MainMenuSettings.items.popup_loading_texture = MainMenuSettings.items.popup_loading_texture or {}
MainMenuSettings.items.popup_loading_texture[1366] = MainMenuSettings.items.popup_loading_texture[1366] or {}
MainMenuSettings.items.popup_loading_texture[1366][768] = MainMenuSettings.items.popup_loading_texture[1366][768] or {
	texture_atlas = "loading_atlas",
	padding_right = 0,
	padding_left = 0,
	frames = {},
	texture_width = 128 * SCALE_1366,
	texture_height = 128 * SCALE_1366,
	texture_atlas_settings = LoadingAtlas,
	animation_speed = 64 * SCALE_1366,
	padding_top = 18 * SCALE_1366,
	padding_bottom = -50 * SCALE_1366,
	scale = 0.5 * SCALE_1366
}

for i = 1, 64 do
	MainMenuSettings.items.popup_loading_texture[1366][768].frames[i] = string.format("loading_shield_%.2d", i)
end

MainMenuSettings.items.popup_button = MainMenuSettings.items.popup_button or {}
MainMenuSettings.items.popup_button[1366] = MainMenuSettings.items.popup_button[1366] or {}
MainMenuSettings.items.popup_button[1366][768] = MainMenuSettings.items.popup_button[1366][768] or {
	texture_left = "shiny_button_left_end_1366",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1366",
	text_offset_y = 16,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1366",
	padding_bottom = 3,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1366",
	texture_left_width = 20,
	padding_right = 7,
	texture_height = 44,
	text_padding = 0,
	padding_left = 7,
	texture_right = "shiny_button_right_end_1366",
	font_size = 18,
	texture_middle = "shiny_button_center_1366",
	texture_right_width = 20,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		0,
		0,
		0
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		110,
		110,
		110
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
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color_disabled = {
		100,
		0,
		0,
		0
	}
}
MainMenuSettings.items.pdx_login_popup_button = MainMenuSettings.items.pdx_login_popup_button or {}
MainMenuSettings.items.pdx_login_popup_button[1366] = MainMenuSettings.items.pdx_login_popup_button[1366] or {}
MainMenuSettings.items.pdx_login_popup_button[1366][768] = table.clone(MainMenuSettings.items.popup_button[1366][768])
MainMenuSettings.items.pdx_login_popup_button[1366][768].texture_forced_width = 75
MainMenuSettings.items.changelog_popup_button = MainMenuSettings.items.changelog_popup_button or {}
MainMenuSettings.items.changelog_popup_button[1366] = MainMenuSettings.items.changelog_popup_button[1366] or {}
MainMenuSettings.items.changelog_popup_button[1366][768] = MainMenuSettings.items.changelog_popup_button[1366][768] or {
	texture_left = "shiny_button_left_end_1366",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1366",
	text_offset_y = 16,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1366",
	padding_bottom = 3,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1366",
	texture_left_width = 20,
	padding_right = 7,
	texture_height = 44,
	text_padding = 0,
	padding_left = 345,
	texture_right = "shiny_button_right_end_1366",
	font_size = 18,
	texture_middle = "shiny_button_center_1366",
	texture_right_width = 20,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		0,
		0,
		0
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		110,
		110,
		110
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
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color_disabled = {
		100,
		0,
		0,
		0
	}
}
MainMenuSettings.items.coins_amount_button = MainMenuSettings.items.coins_amount_button or {}
MainMenuSettings.items.coins_amount_button[1366] = MainMenuSettings.items.coins_amount_button[1366] or {}
MainMenuSettings.items.coins_amount_button[1366][768] = MainMenuSettings.items.coins_amount_button[1366][768] or {
	texture_height = 120,
	texture_middle_highlighted = "gold_button_hover_",
	text_offset_y = 32,
	text_padding = 0,
	padding_bottom = -10,
	padding_top = -10,
	padding_left = 0,
	texture_left_width = 0,
	padding_right = 0,
	text_offset_x = 264,
	font_size = 16,
	texture_middle = "gold_button_",
	texture_forced_width = 700,
	texture_right_width = 0,
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		255,
		255,
		255
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
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color_disabled = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.popup_button_small = MainMenuSettings.items.popup_button_small or {}
MainMenuSettings.items.popup_button_small[1366] = MainMenuSettings.items.popup_button_small[1366] or {}
MainMenuSettings.items.popup_button_small[1366][768] = MainMenuSettings.items.popup_button_small[1366][768] or table.clone(MainMenuSettings.items.popup_button[1366][768])
MainMenuSettings.items.popup_button_small[1366][768].font = MenuSettings.fonts.hell_shark_14
MainMenuSettings.items.popup_button_small[1366][768].font_size = 14
MainMenuSettings.items.popup_button_small[1366][768].text_offset_y = 18
MainMenuSettings.items.popup_button_small[1366][768].padding_left = 2
MainMenuSettings.items.popup_button_small[1366][768].padding_right = 2
MainMenuSettings.items.popup_button_small[1366][768].text_padding = -8
MainMenuSettings.items.popup_close_texture = MainMenuSettings.items.popup_close_texture or {}
MainMenuSettings.items.popup_close_texture[1366] = MainMenuSettings.items.popup_close_texture[1366] or {}
MainMenuSettings.items.popup_close_texture[1366][768] = MainMenuSettings.items.popup_close_texture[1366][768] or {
	texture = "checkbox_close_1366",
	texture_highlighted = "checkbox_close_1366",
	texture_highlighted_height = 28,
	texture_background_height = 28,
	padding_top = -9,
	texture_background = "checkbox_off_1366",
	padding_bottom = -9,
	texture_offset_z = 2,
	texture_background_offset_z = 1,
	texture_width = 28,
	padding_right = 0,
	texture_height = 28,
	texture_background_alignment = "center",
	padding_left = 0,
	texture_background_width = 28,
	texture_highlighted_offset_z = 2,
	texture_highlighted_width = 28,
	color = {
		160,
		255,
		255,
		255
	},
	color_highlighted = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.expandable_popup_header = MainMenuSettings.items.expandable_popup_header or {}
MainMenuSettings.items.expandable_popup_header[1366] = MainMenuSettings.items.expandable_popup_header[1366] or {}
MainMenuSettings.items.expandable_popup_header[1366][768] = MainMenuSettings.items.expandable_popup_header[1366][768] or {
	texture_disabled_width = 432,
	texture_disabled = "popup_title_bar_1366",
	font_size = 16,
	padding_top = 14,
	texture_alignment = "left",
	padding_bottom = 14,
	line_height = 9,
	texture_disabled_height = 24,
	padding_left = 18,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_16,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.expandable_popup_textbox = MainMenuSettings.items.expandable_popup_textbox or {}
MainMenuSettings.items.expandable_popup_textbox[1366] = MainMenuSettings.items.expandable_popup_textbox[1366] or {}
MainMenuSettings.items.expandable_popup_textbox[1366][768] = MainMenuSettings.items.expandable_popup_textbox[1366][768] or {
	render_from_top = true,
	text_align = "left",
	padding_left = 18,
	padding_right = 0,
	font_size = 14,
	padding_top = 0,
	min_height = 284,
	padding_bottom = 0,
	line_height = 18,
	width = 390,
	font = MenuSettings.fonts.hell_shark_14,
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
MainMenuSettings.items.centered_button = MainMenuSettings.items.centered_button or {}
MainMenuSettings.items.centered_button[1366] = MainMenuSettings.items.centered_button[1366] or {}
MainMenuSettings.items.centered_button[1366][768] = MainMenuSettings.items.centered_button[1366][768] or {
	texture_left = "shiny_button_left_end_1366",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1366",
	text_offset_y = 16,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1366",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1366",
	texture_left_width = 20,
	padding_right = 14,
	texture_height = 44,
	text_padding = 0,
	padding_left = 14,
	texture_right = "shiny_button_right_end_1366",
	font_size = 18,
	texture_middle = "shiny_button_center_1366",
	texture_right_width = 20,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		0,
		0,
		0
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		110,
		110,
		110
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
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color_disabled = {
		100,
		0,
		0,
		0
	}
}
MainMenuSettings.items.header_text_right_aligned = MainMenuSettings.items.header_text_right_aligned or {}
MainMenuSettings.items.header_text_right_aligned[1366] = MainMenuSettings.items.header_text_right_aligned[1366] or {}
MainMenuSettings.items.header_text_right_aligned[1366][768] = MainMenuSettings.items.header_text_right_aligned[1366][768] or {
	padding_left = 0,
	font_size = 22,
	font = MenuSettings.fonts.hell_shark_22,
	line_height = 21 * SCALE_1366,
	color_disabled = {
		255,
		0,
		0,
		0
	},
	color_render_from_child_page = {
		160,
		0,
		0,
		0
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
MainMenuSettings.items.sub_header_left_aligned = MainMenuSettings.items.sub_header_left_aligned or {}
MainMenuSettings.items.sub_header_left_aligned[1366] = MainMenuSettings.items.sub_header_left_aligned[1366] or {}
MainMenuSettings.items.sub_header_left_aligned[1366][768] = MainMenuSettings.items.sub_header_left_aligned[1366][768] or {
	font_size = 22,
	font = MenuSettings.fonts.hell_shark_22,
	line_height = 21 * SCALE_1366,
	color_disabled = {
		255,
		0,
		0,
		0
	},
	color = {
		255,
		0,
		0,
		0
	},
	color_highlighted = {
		255,
		255,
		255,
		255
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_left = 20 * SCALE_1366,
	padding_right = 20 * SCALE_1366,
	division_rect = {
		540 * SCALE_1366,
		270 * SCALE_1366
	}
}
MainMenuSettings.items.division_header_devision_left_aligned = MainMenuSettings.items.division_header_devision_left_aligned or {}
MainMenuSettings.items.division_header_devision_left_aligned[1366] = MainMenuSettings.items.division_header_devision_left_aligned[1366] or {}
MainMenuSettings.items.division_header_devision_left_aligned[1366][768] = MainMenuSettings.items.division_header_devision_left_aligned[1366][768] or table.clone(MainMenuSettings.items.sub_header_left_aligned[1366][768])
MainMenuSettings.items.division_header_devision_left_aligned[1366][768].division_rect = {
	540 * SCALE_1366,
	270 * SCALE_1366
}
MainMenuSettings.items.division_header_ordinary_left_aligned = MainMenuSettings.items.division_header_ordinary_left_aligned or {}
MainMenuSettings.items.division_header_ordinary_left_aligned[1366] = MainMenuSettings.items.division_header_ordinary_left_aligned[1366] or {}
MainMenuSettings.items.division_header_ordinary_left_aligned[1366][768] = MainMenuSettings.items.division_header_ordinary_left_aligned[1366][768] or table.clone(MainMenuSettings.items.sub_header_left_aligned[1366][768])
MainMenuSettings.items.division_header_ordinary_left_aligned[1366][768].division_rect = {
	540 * SCALE_1366,
	105 * SCALE_1366
}
MainMenuSettings.items.division_header_charge_left_aligned = MainMenuSettings.items.division_header_charge_left_aligned or {}
MainMenuSettings.items.division_header_charge_left_aligned[1366] = MainMenuSettings.items.division_header_charge_left_aligned[1366] or {}
MainMenuSettings.items.division_header_charge_left_aligned[1366][768] = MainMenuSettings.items.division_header_charge_left_aligned[1366][768] or table.clone(MainMenuSettings.items.sub_header_left_aligned[1366][768])
MainMenuSettings.items.division_header_charge_left_aligned[1366][768].division_rect = {
	540 * SCALE_1366,
	145 * SCALE_1366
}
MainMenuSettings.items.division_header_crest_left_aligned = MainMenuSettings.items.division_header_crest_left_aligned or {}
MainMenuSettings.items.division_header_crest_left_aligned[1366] = MainMenuSettings.items.division_header_crest_left_aligned[1366] or {}
MainMenuSettings.items.division_header_crest_left_aligned[1366][768] = MainMenuSettings.items.division_header_crest_left_aligned[1366][768] or table.clone(MainMenuSettings.items.sub_header_left_aligned[1366][768])
MainMenuSettings.items.division_header_crest_left_aligned[1366][768].division_rect = {
	540 * SCALE_1366,
	100 * SCALE_1366
}
MainMenuSettings.items.sub_header_2_left_aligned = MainMenuSettings.items.sub_header_2_left_aligned or {}
MainMenuSettings.items.sub_header_2_left_aligned[1366] = MainMenuSettings.items.sub_header_2_left_aligned[1366] or {}
MainMenuSettings.items.sub_header_2_left_aligned[1366][768] = MainMenuSettings.items.sub_header_2_left_aligned[1366][768] or {
	texture_alignment = "left",
	font_size = 22,
	font = MenuSettings.fonts.hell_shark_22,
	line_height = 21 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_left = 20 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
MainMenuSettings.items.color_picker = MainMenuSettings.items.color_picker or {}
MainMenuSettings.items.color_picker[1366] = MainMenuSettings.items.color_picker[1366] or {}
MainMenuSettings.items.color_picker[1366][768] = MainMenuSettings.items.color_picker[1366][768] or {
	texture = "color_picker_1920",
	texture_selected_background = "color_picker_selected_background_1920",
	texture_2 = "color_picker_2_1920",
	padding_right = 0,
	texture_width = 20 * SCALE_1366,
	texture_height = 20 * SCALE_1366,
	texture_2_width = 20 * SCALE_1366,
	texture_2_height = 20 * SCALE_1366,
	texture_selected_background_width = 20 * SCALE_1366,
	texture_selected_background_height = 20 * SCALE_1366,
	border_size = {
		255,
		0,
		0,
		0
	},
	border_color = {
		255,
		0,
		0,
		0
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366,
	padding_left = 10 * SCALE_1366
}
MainMenuSettings.items.floating_tooltip = MainMenuSettings.items.floating_tooltip or {}
MainMenuSettings.items.floating_tooltip[1366] = MainMenuSettings.items.floating_tooltip[1366] or {}
MainMenuSettings.items.floating_tooltip[1366][768] = MainMenuSettings.items.floating_tooltip[1366][768] or {
	texture_top_right = "tooltip_top_right",
	texture_center = "tooltip_cent",
	header_font_size = 16,
	texture_middle_left = "tooltip_mid_left",
	fade_in_delay = 0.6,
	texture_middle_right = "tooltip_mid_right",
	texture_down_right = "tooltip_down_right",
	texture_down_left = "tooltip_down_left",
	texture_down_middle = "tooltip_down_mid",
	fade_out_delay = 0,
	texture_top_left = "tooltip_top_left",
	fade_in_speed = 5,
	text_font_size = 16,
	texture_top_middle = "tooltip_top_mid",
	fade_out_speed = 10,
	texture_width = 20 * SCALE_1366,
	texture_height = 20 * SCALE_1366,
	header_font = MenuSettings.fonts.arial_16,
	header_color = {
		255,
		255,
		255,
		255
	},
	header_shadow_color = {
		255,
		100,
		100,
		100
	},
	header_shadow_offset = {
		1,
		-1
	},
	text_font = MenuSettings.fonts.arial_16,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_shadow_color = {
		255,
		100,
		100,
		100
	},
	text_shadow_offset = {
		1,
		-1
	},
	text_line_height = 20 * SCALE_1366,
	text_padding_top = 10 * SCALE_1366,
	min_center_width = 200 * SCALE_1366,
	cursor_offset_y = -14 * SCALE_1366
}
MainMenuSettings.items.scroll_up = MainMenuSettings.items.scroll_up or {}
MainMenuSettings.items.scroll_up[1366] = MainMenuSettings.items.scroll_up[1366] or {}
MainMenuSettings.items.scroll_up[1366][768] = MainMenuSettings.items.scroll_up[1366][768] or {
	texture = "scroll_up_1920",
	padding_left = 0,
	padding_bottom = 0,
	padding_right = 0,
	texture_width = 24 * SCALE_1366,
	texture_height = 12 * SCALE_1366,
	color_disabled = {
		80,
		255,
		255,
		255
	},
	offset_x = 490 * SCALE_1366,
	padding_top = 4 * SCALE_1366
}
MainMenuSettings.items.scroll_down = MainMenuSettings.items.scroll_down or {}
MainMenuSettings.items.scroll_down[1366] = MainMenuSettings.items.scroll_down[1366] or {}
MainMenuSettings.items.scroll_down[1366][768] = MainMenuSettings.items.scroll_down[1366][768] or {
	texture = "scroll_down_1920",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_width = 24 * SCALE_1366,
	texture_height = 12 * SCALE_1366,
	color_disabled = {
		80,
		255,
		255,
		255
	},
	offset_x = 490 * SCALE_1366,
	padding_bottom = 4 * SCALE_1366
}
MainMenuSettings.items.scroll_text = MainMenuSettings.items.scroll_text or {}
MainMenuSettings.items.scroll_text[1366] = MainMenuSettings.items.scroll_text[1366] or {}
MainMenuSettings.items.scroll_text[1366][768] = MainMenuSettings.items.scroll_text[1366][768] or {
	padding_left = 0,
	padding_top = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_14,
	font_size = 14 * SCALE_1366,
	line_height = 10 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	offset_x = 490 * SCALE_1366
}
MainMenuSettings.items.scroll_up_left_aligned = MainMenuSettings.items.scroll_up_left_aligned or {}
MainMenuSettings.items.scroll_up_left_aligned[1366] = MainMenuSettings.items.scroll_up_left_aligned[1366] or {}
MainMenuSettings.items.scroll_up_left_aligned[1366][768] = MainMenuSettings.items.scroll_up_left_aligned[1366][768] or {
	texture = "scroll_up_1920",
	padding_left = 0,
	padding_bottom = 0,
	padding_right = 0,
	texture_width = 24 * SCALE_1366,
	texture_height = 12 * SCALE_1366,
	color_disabled = {
		80,
		255,
		255,
		255
	},
	offset_x = -40 * SCALE_1366,
	padding_top = 4 * SCALE_1366
}
MainMenuSettings.items.scroll_down_left_aligned = MainMenuSettings.items.scroll_down_left_aligned or {}
MainMenuSettings.items.scroll_down_left_aligned[1366] = MainMenuSettings.items.scroll_down_left_aligned[1366] or {}
MainMenuSettings.items.scroll_down_left_aligned[1366][768] = MainMenuSettings.items.scroll_down_left_aligned[1366][768] or {
	texture = "scroll_down_1920",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_width = 24 * SCALE_1366,
	texture_height = 12 * SCALE_1366,
	color_disabled = {
		80,
		255,
		255,
		255
	},
	offset_x = -40 * SCALE_1366,
	padding_bottom = 4 * SCALE_1366
}
MainMenuSettings.items.scroll_text_left_aligned = MainMenuSettings.items.scroll_text_left_aligned or {}
MainMenuSettings.items.scroll_text_left_aligned[1366] = MainMenuSettings.items.scroll_text_left_aligned[1366] or {}
MainMenuSettings.items.scroll_text_left_aligned[1366][768] = MainMenuSettings.items.scroll_text_left_aligned[1366][768] or {
	padding_left = 0,
	font_size = 14,
	padding_top = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_14,
	line_height = 10 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	offset_x = -40 * SCALE_1366
}
MainMenuSettings.items.wotv_text_left_aligned = MainMenuSettings.items.wotv_text_left_aligned or {}
MainMenuSettings.items.wotv_text_left_aligned[1366] = {}
MainMenuSettings.items.wotv_text_left_aligned[1366][768] = MainMenuSettings.items.wotv_text_left_aligned[1366][768] or {
	font_size = 22,
	highlight_font_size = 26,
	align = "center",
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_22,
	highlight_font = MenuSettings.fonts.hell_shark_26,
	line_height = 21 * SCALE_1366,
	color = {
		255,
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
	disabled_color = {
		160,
		100,
		100,
		100
	},
	color_render_from_child_page = {
		80,
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
	drop_shadow_color_disabled = {
		0,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	},
	padding_top = 0 * SCALE_1366,
	padding_bottom = 20 * SCALE_1366,
	padding_left = 0 * SCALE_1366
}
MainMenuSettings.items.ddl_closed_text_center_aligned = MainMenuSettings.items.ddl_closed_text_center_aligned or {}
MainMenuSettings.items.ddl_closed_text_center_aligned[1366] = {}
MainMenuSettings.items.ddl_closed_text_center_aligned[1366][768] = MainMenuSettings.items.ddl_closed_text_center_aligned[1366][768] or {
	texture_arrow_offset_x = 0,
	highlight_font_size = 18,
	texture_arrow_height = 12,
	texture_arrow_width = 20,
	texture_arrow_offset_y = 3,
	do_not_render_from_child_page = true,
	texture_alignment = "right",
	padding_bottom = 7,
	line_height = 10,
	padding_top = 7,
	padding_left = 0,
	padding_right = 26,
	font_size = 16,
	texture_arrow = "drop_down_list_arrow",
	font = MenuSettings.fonts.hell_shark_16,
	highlight_font = MenuSettings.fonts.hell_shark_18,
	color = {
		160,
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
	color_disabled = {
		255,
		100,
		100,
		100
	},
	color_render_from_child_page = {
		80,
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
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.drop_down_list_scroll_bar = MainMenuSettings.items.drop_down_list_scroll_bar or {}
MainMenuSettings.items.drop_down_list_scroll_bar[1366] = MainMenuSettings.items.drop_down_list_scroll_bar[1366] or {}
MainMenuSettings.items.drop_down_list_scroll_bar[1366][768] = MainMenuSettings.items.drop_down_list_scroll_bar[1366][768] or {
	scroll_bar_handle_width = 6,
	width = 16,
	scroll_bar_width = 2,
	scroll_bar_handle_color = {
		255,
		215,
		215,
		215
	},
	scroll_bar_color = {
		255,
		130,
		130,
		130
	},
	background_color = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.items.wotv_drop_down_list_scroll_bar = MainMenuSettings.items.wotv_drop_down_list_scroll_bar or {}
MainMenuSettings.items.wotv_drop_down_list_scroll_bar[1366] = {}
MainMenuSettings.items.wotv_drop_down_list_scroll_bar[1366][768] = MainMenuSettings.items.wotv_drop_down_list_scroll_bar[1366][768] or {
	scroll_bar_handle_width = 6,
	width = 16,
	scroll_bar_width = 2,
	scroll_bar_handle_color = {
		255,
		215,
		215,
		215
	},
	scroll_bar_color = {
		255,
		130,
		130,
		130
	},
	background_color = {
		255,
		0,
		0,
		0
	}
}
MainMenuSettings.items.texture_button_left_aligned = MainMenuSettings.items.texture_button_left_aligned or {}
MainMenuSettings.items.texture_button_left_aligned[1366] = MainMenuSettings.items.texture_button_left_aligned[1366] or {}
MainMenuSettings.items.texture_button_left_aligned[1366][768] = MainMenuSettings.items.texture_button_left_aligned[1366][768] or {
	texture_left = "small_button_left_1366",
	texture_left_highlighted = "small_button_left_highlighted_1366",
	text_offset_y = 7,
	texture_right_highlighted = "small_button_right_highlighted_1366",
	padding_bottom = 5,
	padding_top = 10,
	texture_middle_highlighted = "small_button_center_highlighted_1366",
	texture_left_width = 8,
	padding_right = 0,
	texture_height = 24,
	text_padding = 1,
	padding_left = 12,
	texture_right = "small_button_right_1366",
	font_size = 18,
	texture_middle = "small_button_center_1366",
	texture_right_width = 8,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_color_highlighted = {
		255,
		255,
		255,
		255
	},
	text_color_disabled = {
		255,
		150,
		150,
		150
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
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color_disabled = {
		100,
		0,
		0,
		0
	}
}
MainMenuSettings.items.how_to_play = MainMenuSettings.items.how_to_play or {}
MainMenuSettings.items.how_to_play[1366] = MainMenuSettings.items.how_to_play[1366] or {}
MainMenuSettings.items.how_to_play[1366][768] = MainMenuSettings.items.how_to_play[1366][768] or {
	texture = "how_to_play_screen_controls_bg_1920x1080",
	padding_bottom = 0,
	texture_width = 1920,
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_height = 1080
}
MainMenuSettings.items.how_to_play_end_of_tutorial = MainMenuSettings.items.how_to_play_end_of_tutorial or {}
MainMenuSettings.items.how_to_play_end_of_tutorial[1366] = MainMenuSettings.items.how_to_play_end_of_tutorial[1366] or {}
MainMenuSettings.items.how_to_play_end_of_tutorial[1366][768] = MainMenuSettings.items.how_to_play_end_of_tutorial[1366][768] or {
	texture = "how_to_play_screen_bg_1920x1080",
	padding_bottom = 0,
	texture_width = 1920,
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_height = 1080
}
MainMenuSettings.items.roadmap = MainMenuSettings.items.roadmap or {}
MainMenuSettings.items.roadmap[1280] = MainMenuSettings.items.roadmap[1280] or {}
MainMenuSettings.items.roadmap[1280][720] = MainMenuSettings.items.roadmap[1280][720] or {
	texture = "early_access_roadmap",
	padding_bottom = 0,
	texture_width = 1280,
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_height = 720
}
MainMenuSettings.items.roadmap = MainMenuSettings.items.roadmap or {}
MainMenuSettings.items.roadmap[1] = MainMenuSettings.items.roadmap[1] or {}
MainMenuSettings.items.roadmap[1][1] = MainMenuSettings.items.roadmap[1][1] or {}
MainMenuSettings.items.roadmap[1][1].texture = "early_access_roadmap"
MainMenuSettings.items.roadmap[1][1].texture_width = 1280
MainMenuSettings.items.roadmap[1][1].texture_height = 720
MainMenuSettings.items.roadmap[1][1].width_scale_of_gui = 1
MainMenuSettings.items.roadmap[1][1].padding_top = 0
MainMenuSettings.items.roadmap[1][1].padding_bottom = 0
MainMenuSettings.items.roadmap[1][1].padding_left = 0
MainMenuSettings.items.roadmap[1][1].padding_right = 0
MainMenuSettings.items.delimiter_texture = MainMenuSettings.items.delimiter_texture or {}
MainMenuSettings.items.delimiter_texture[1366] = MainMenuSettings.items.delimiter_texture[1366] or {}
MainMenuSettings.items.delimiter_texture[1366][768] = MainMenuSettings.items.delimiter_texture[1366][768] or {
	texture = "divider_ornament_long",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_right = 0,
	texture_width = 340 * SCALE_1366,
	texture_height = 4 * SCALE_1366,
	color_render_from_child_page = {
		80,
		255,
		255,
		255
	},
	padding_top = 6 * SCALE_1366,
	padding_bottom = 4 * SCALE_1366
}
MainMenuSettings.items.delimiter_texture_left = MainMenuSettings.items.delimiter_texture_left or {}
MainMenuSettings.items.delimiter_texture_left[1366] = MainMenuSettings.items.delimiter_texture_left[1366] or {}
MainMenuSettings.items.delimiter_texture_left[1366][768] = table.clone(MainMenuSettings.items.delimiter_texture[1366][768])
MainMenuSettings.items.delimiter_texture_left[1366][768].align = "center"
MainMenuSettings.items.delimiter_texture_right = MainMenuSettings.items.delimiter_texture_right or {}
MainMenuSettings.items.delimiter_texture_right[1366] = {}
MainMenuSettings.items.delimiter_texture_right[1366][768] = table.clone(MainMenuSettings.items.delimiter_texture[1366][768])
MainMenuSettings.items.delimiter_texture_right[1366][768].align = "right"
MainMenuSettings.items.empty = MainMenuSettings.items.empty or {}
MainMenuSettings.items.empty[1366] = MainMenuSettings.items.empty[1366] or {}
MainMenuSettings.items.empty[1366][768] = MainMenuSettings.items.empty[1366][768] or {}
MainMenuSettings.items.text_back = MainMenuSettings.items.text_back or {}
MainMenuSettings.items.text_back[1366] = MainMenuSettings.items.text_back[1366] or {}
MainMenuSettings.items.text_back[1366][768] = MainMenuSettings.items.text_back[1366][768] or {
	font_size = 14,
	font = MenuSettings.fonts.hell_shark_14,
	line_height = 21 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	},
	color_highlighted = {
		255,
		0,
		0,
		0
	},
	color_disabled = {
		255,
		100,
		100,
		100
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_color_disabled = {
		0,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	},
	padding_top = 6 * SCALE_1366,
	padding_bottom = 6 * SCALE_1366,
	padding_left = 6 * SCALE_1366,
	padding_right = 6 * SCALE_1366
}
MainMenuSettings.items.lobby_host = MainMenuSettings.items.lobby_host or {}
MainMenuSettings.items.lobby_host[1366] = MainMenuSettings.items.lobby_host[1366] or {}
MainMenuSettings.items.lobby_host[1366][768] = MainMenuSettings.items.lobby_host[1366][768] or {
	font_size = 14,
	font = MenuSettings.fonts.hell_shark_14
}
MainMenuSettings.items.lobby_join = MainMenuSettings.items.lobby_join or {}
MainMenuSettings.items.lobby_join[1366] = MainMenuSettings.items.lobby_join[1366] or {}
MainMenuSettings.items.lobby_join[1366][768] = {
	font_size = 14,
	font = MenuSettings.fonts.hell_shark_14
}
MainMenuSettings.items.outfit_selection = MainMenuSettings.items.outfit_selection or {}
MainMenuSettings.items.outfit_selection[1366] = MainMenuSettings.items.outfit_selection[1366] or {}
MainMenuSettings.items.outfit_selection[1366][768] = MainMenuSettings.items.outfit_selection[1366][768] or {
	font_size = 16,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		150,
		150,
		150
	},
	color_highlighted = {
		255,
		150,
		0,
		0
	},
	color_disabled = {
		255,
		50,
		50,
		50
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366
}
MainMenuSettings.items.outfit_multiple_selection = MainMenuSettings.items.outfit_multiple_selection or {}
MainMenuSettings.items.outfit_multiple_selection[1366] = MainMenuSettings.items.outfit_multiple_selection[1366] or {}
MainMenuSettings.items.outfit_multiple_selection[1366][768] = MainMenuSettings.items.outfit_multiple_selection[1366][768] or {
	padding_left = 0,
	font_size = 16,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		150,
		150,
		150
	},
	color_highlighted = {
		255,
		150,
		0,
		0
	},
	color_selected = {
		255,
		255,
		255,
		255
	},
	color_disabled = {
		255,
		50,
		50,
		50
	},
	padding_top = 7 * SCALE_1366,
	padding_bottom = 7 * SCALE_1366
}
MainMenuSettings.items.loading_indicator = MainMenuSettings.items.loading_indicator or {}
MainMenuSettings.items.loading_indicator[1366] = MainMenuSettings.items.loading_indicator[1366] or {}
MainMenuSettings.items.loading_indicator[1366][768] = MainMenuSettings.items.loading_indicator[1366][768] or {
	pivot_offset_y = 0,
	screen_offset_x = -0.04,
	pivot_align_y = "bottom",
	fade_end_delay = 1,
	screen_align_y = "bottom",
	texture = "loading_icon_mockup",
	texture_rotation_angle = 90,
	fade_start_delay = 2,
	font_size = 20,
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
	font = MenuSettings.fonts.hell_shark_20,
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
	MainMenuSettings.items.loading_indicator[1366][768].loading_icon_config.frames[i] = string.format("loading_shield_%.2d", i)
end

MainMenuSettings.items.popup_twitter_link = MainMenuSettings.items.popup_twitter_link or {}
MainMenuSettings.items.popup_twitter_link[1366] = MainMenuSettings.items.popup_twitter_link[1366] or {}
MainMenuSettings.items.popup_twitter_link[1366][768] = MainMenuSettings.items.popup_twitter_link[1366][768] or {
	texture = "twitter_1366",
	texture_highlighted = "twitter_highlighted_1366",
	texture_highlighted_height = 32,
	texture_highlighted_width = 32,
	texture_width = 32,
	texture_highlighted_offset_z = 2,
	texture_height = 32,
	padding_top = 19 * SCALE_1366,
	padding_bottom = 13 * SCALE_1366,
	padding_left = 10 * SCALE_1366,
	padding_right = 10 * SCALE_1366
}
MainMenuSettings.pages.text_input_popup = MainMenuSettings.pages.text_input_popup or {}
MainMenuSettings.pages.text_input_popup[1366] = MainMenuSettings.pages.text_input_popup[1366] or {}
MainMenuSettings.pages.text_input_popup[1366][768] = MainMenuSettings.pages.text_input_popup[1366][768] or {
	header_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		screen_align_x = "center",
		number_of_columns = 1,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_offset_y = 100 * SCALE_1366,
		column_width = {
			604 * SCALE_1366
		},
		column_alignment = {
			"left"
		}
	},
	item_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		screen_align_x = "center",
		number_of_columns = 1,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_offset_y = 34 * SCALE_1366,
		column_width = {
			604 * SCALE_1366
		},
		column_alignment = {
			"center"
		}
	},
	button_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		screen_align_x = "center",
		number_of_columns = 2,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_offset_y = -60 * SCALE_1366,
		column_alignment = {
			"right",
			"left"
		}
	},
	background_rect = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = 0,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		absolute_width = 604 * SCALE_1366,
		absolute_height = 230 * SCALE_1366,
		color = {
			220,
			20,
			20,
			20
		}
	}
}
MainMenuSettings.pages.text_input_popup_no_overlay = MainMenuSettings.pages.text_input_popup_no_overlay or {}
MainMenuSettings.pages.text_input_popup_no_overlay[1366] = MainMenuSettings.pages.text_input_popup_no_overlay[1366] or {}
MainMenuSettings.pages.text_input_popup_no_overlay[1366][768] = MainMenuSettings.pages.text_input_popup_no_overlay[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
MainMenuSettings.pages.text_input_popup_no_overlay[1366][768].overlay_texture = nil
MainMenuSettings.pages.demo_popup = MainMenuSettings.pages.demo_popup or {}
MainMenuSettings.pages.demo_popup[1366] = MainMenuSettings.pages.demo_popup[1366] or {}
MainMenuSettings.pages.demo_popup[1366][768] = MainMenuSettings.pages.demo_popup[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
MainMenuSettings.pages.demo_popup[1366][768].button_list.number_of_columns = 2
MainMenuSettings.pages.demo_popup[1366][768].button_list.column_alignment = {
	"left",
	"right"
}
MainMenuSettings.pages.demo_popup[1366][768].button_list.pivot_align_x = "right"
MainMenuSettings.pages.demo_popup[1366][768].button_list.pivot_offset_x = 210 * SCALE_1366
MainMenuSettings.pages.demo_popup[1366][768].button_list.pivot_offset_y = -70 * SCALE_1366
MainMenuSettings.pages.buy_gold_popup = MainMenuSettings.pages.buy_gold_popup or {}
MainMenuSettings.pages.buy_gold_popup[1366] = MainMenuSettings.pages.buy_gold_popup[1366] or {}
MainMenuSettings.pages.buy_gold_popup[1366][768] = MainMenuSettings.pages.buy_gold_popup[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
MainMenuSettings.pages.buy_gold_popup[1366][768].background_rect.absolute_height = 710
MainMenuSettings.pages.buy_gold_popup[1366][768].background_rect.absolute_width = 664
MainMenuSettings.pages.buy_gold_popup[1366][768].header_list.number_of_columns = 2
MainMenuSettings.pages.buy_gold_popup[1366][768].header_list.column_width = {
	327,
	327
}
MainMenuSettings.pages.buy_gold_popup[1366][768].header_list.column_alignment = {
	"left",
	"right"
}
MainMenuSettings.pages.buy_gold_popup[1366][768].header_list.pivot_offset_y = (MainMenuSettings.pages.buy_gold_popup[1366][768].background_rect.absolute_height - 30) * 0.5
MainMenuSettings.pages.buy_gold_popup[1366][768].item_list.pivot_offset_y = MainMenuSettings.pages.buy_gold_popup[1366][768].header_list.pivot_offset_y - 36
MainMenuSettings.pages.buy_gold_popup[1366][768].button_list.number_of_columns = 1
MainMenuSettings.pages.buy_gold_popup[1366][768].button_list.column_alignment = {
	"center"
}
MainMenuSettings.pages.buy_gold_popup[1366][768].button_list.column_width = {
	650
}
MainMenuSettings.pages.buy_gold_popup[1366][768].button_list.pivot_offset_y = -20
MainMenuSettings.pages.message_popup = MainMenuSettings.pages.message_popup or {}
MainMenuSettings.pages.message_popup[1366] = MainMenuSettings.pages.message_popup[1366] or {}
MainMenuSettings.pages.message_popup[1366][768] = MainMenuSettings.pages.message_popup[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
MainMenuSettings.pages.message_popup[1366][768].button_list.number_of_columns = 1
MainMenuSettings.pages.message_popup[1366][768].button_list.column_width = nil
MainMenuSettings.pages.message_popup[1366][768].button_list.column_alignment = {
	"center"
}
MainMenuSettings.pages.message_popup_no_overlay = MainMenuSettings.pages.message_popup_no_overlay or {}
MainMenuSettings.pages.message_popup_no_overlay[1366] = MainMenuSettings.pages.message_popup_no_overlay[1366] or {}
MainMenuSettings.pages.message_popup_no_overlay[1366][768] = MainMenuSettings.pages.message_popup_no_overlay[1366][768] or table.clone(MainMenuSettings.pages.message_popup[1366][768])
MainMenuSettings.pages.message_popup_no_overlay[1366][768].overlay_texture = nil
MainMenuSettings.pages.expandable_popup = MainMenuSettings.pages.expandable_popup or {}
MainMenuSettings.pages.expandable_popup[1366] = MainMenuSettings.pages.expandable_popup[1366] or {}
MainMenuSettings.pages.expandable_popup[1366][768] = MainMenuSettings.pages.expandable_popup[1366][768] or {
	item_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = 0,
		screen_align_x = "center",
		number_of_columns = 3,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		column_alignment = {
			"left",
			"center",
			"center"
		},
		column_width = {
			144,
			144,
			144
		}
	},
	background_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "skeleton_flipped_1366",
		pivot_offset_y = 0,
		texture_width = 192,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		texture_height = 228
	},
	background_rect = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = 0,
		screen_align_x = "center",
		absolute_width = 432,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		border_size = 1,
		color = {
			220,
			20,
			20,
			20
		},
		border_color = {
			220,
			80,
			80,
			80
		}
	}
}
MainMenuSettings.pages.pdx_login = MainMenuSettings.pages.pdx_login or {}
MainMenuSettings.pages.pdx_login[1366] = MainMenuSettings.pages.pdx_login[1366] or {}
MainMenuSettings.pages.pdx_login[1366][768] = MainMenuSettings.pages.pdx_login[1366][768] or {
	header_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = 105,
		screen_align_x = "center",
		number_of_columns = 1,
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		column_width = {
			400
		},
		column_alignment = {
			"left"
		}
	},
	button_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = -80,
		screen_align_x = "center",
		number_of_columns = 3,
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		column_alignment = {
			"left",
			"left",
			"left"
		}
	},
	item_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		pivot_offset_y = 20,
		screen_align_x = "center",
		number_of_columns = 1,
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		column_alignment = {
			"center"
		},
		column_width = {
			365
		}
	},
	background_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "skeleton_flipped_1920",
		pivot_offset_y = 0,
		texture_width = 276,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		texture_height = 328
	},
	background_rect = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		absolute_height = 230,
		pivot_offset_y = -0.1,
		screen_align_x = "center",
		absolute_width = 400,
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		border_size = 1,
		color = {
			220,
			20,
			20,
			20
		},
		border_color = {
			220,
			80,
			80,
			80
		}
	},
	warning_text = {
		background_rect_offset_x = -5,
		screen_offset_x = 0,
		text_align = "left",
		font_size = 18,
		pivot_align_y = "bottom",
		background_rect_offset_y = 0,
		background_width = 310,
		line_height = 18,
		screen_offset_y = 0.9,
		background_rect = true,
		background_height_bottom_padding = 5,
		border_size = 1,
		screen_align_y = "bottom",
		pivot_offset_y = 0,
		screen_align_x = "center",
		render_border = true,
		pivot_offset_x = 0,
		pivot_align_x = "center",
		width = 300,
		font = MenuSettings.fonts.arial_18,
		color = {
			255,
			255,
			255,
			255
		},
		drop_shadow_color = {
			255,
			0,
			0,
			0
		},
		drop_shadow_offset = {
			1,
			-1
		},
		background_color = {
			220,
			20,
			20,
			20
		},
		border_color = {
			220,
			80,
			80,
			80
		}
	}
}
MainMenuSettings.pages.level_1 = MainMenuSettings.pages.level_1 or {}
MainMenuSettings.pages.level_1[1366] = MainMenuSettings.pages.level_1[1366] or {}
MainMenuSettings.pages.level_1[1366][768] = MainMenuSettings.pages.level_1[1366][768] or {
	item_list = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		screen_offset_y = -0.25,
		pivot_align_x = "right",
		pivot_offset_x = 540 * SCALE_1366,
		column_alignment = {
			"right"
		}
	},
	news_ticker = {
		screen_align_x = "left",
		height = 32,
		pivot_offset_y = -8,
		pivot_align_y = "top",
		text_offset_y = 9,
		screen_offset_x = 0,
		delimiter_texture_width = 64,
		delimiter_texture_height = 28,
		left_background_texture = "news_ticker_left_1366",
		right_background_texture_width = 392,
		right_background_texture = "news_ticker_right_1366",
		delimiter_texture = "news_ticker_delimiter_1366",
		left_background_texture_height = 32,
		screen_align_y = "top",
		right_background_texture_height = 32,
		font_size = 18,
		text_spacing = 156,
		delimiter_texture_offset_y = 2,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		left_background_texture_width = 392,
		font = MenuSettings.fonts.hell_shark_18,
		text_color = {
			255,
			255,
			255,
			255
		},
		text_shadow_color = {
			200,
			0,
			0,
			0
		},
		text_shadow_offset = {
			2,
			-2
		},
		delimiter_texture_color = {
			200,
			255,
			255,
			255
		},
		background_rect_color = {
			80,
			0,
			0,
			0
		},
		background_texture_color = {
			150,
			255,
			255,
			255
		}
	},
	tooltip_text_box = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		font_size = 16,
		pivot_offset_y = 0,
		screen_align_x = "left",
		text_align = "right",
		screen_offset_y = -0.6,
		pivot_align_x = "right",
		pivot_offset_x = 520 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_16,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 28 * SCALE_1366,
		width = 440 * SCALE_1366,
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
	gradient_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_gradient_1920",
		pivot_offset_y = 0,
		screen_align_x = "left",
		stretch_relative_height = 1,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_width = 636 * SCALE_1366,
		texture_height = 4 * SCALE_1366,
		stretch_width = 540 * SCALE_1366
	},
	vertical_line_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_vertical_line_1920",
		pivot_offset_y = 0,
		screen_align_x = "left",
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 540 * SCALE_1366,
		texture_width = 16 * SCALE_1366,
		texture_height = 1016 * SCALE_1366
	},
	corner_top_texture = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_top_corner_1920",
		pivot_offset_y = 0,
		screen_align_x = "left",
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_offset_x = 536 * SCALE_1366,
		texture_width = 416 * SCALE_1366,
		texture_height = 308 * SCALE_1366
	}
}
MainMenuSettings.pages.level_2 = MainMenuSettings.pages.level_2 or {}
MainMenuSettings.pages.level_2[1366] = MainMenuSettings.pages.level_2[1366] or {}
MainMenuSettings.pages.level_2[1366][768] = MainMenuSettings.pages.level_2[1366][768] or {
	item_list = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		screen_offset_y = -0.25,
		pivot_align_x = "right",
		pivot_offset_x = 540 * SCALE_1366,
		column_alignment = {
			"right"
		}
	},
	tooltip_text_box = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		font_size = 16,
		pivot_offset_y = 0,
		screen_align_x = "left",
		text_align = "right",
		screen_offset_y = -0.6,
		pivot_align_x = "right",
		pivot_offset_x = 520 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_16,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 28 * SCALE_1366,
		width = 440 * SCALE_1366,
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
	back_list = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		screen_align_x = "left",
		number_of_columns = 2,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 0 * SCALE_1366,
		pivot_offset_y = 30 * SCALE_1366,
		column_alignment = {
			"left",
			"left"
		}
	},
	background_texture = {
		texture = "item_list_gradient_2_1920",
		stretch_relative_width = 1,
		texture_width = 4 * SCALE_1366,
		texture_height = 600 * SCALE_1366
	},
	horizontal_line_top_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "pink_horror",
		pivot_offset_y = 0,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		texture_width = 1000 * SCALE_1366,
		texture_height = 12 * SCALE_1366
	},
	horizontal_line_bottom_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture = "item_list_bottom_horizontal_line_1920",
		pivot_offset_y = 0,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		texture_height = 12,
		texture_width = 1000 * SCALE_1366
	}
}
MainMenuSettings.pages.level_3 = MainMenuSettings.pages.level_3 or {}
MainMenuSettings.pages.level_3[1366] = MainMenuSettings.pages.level_3[1366] or {}
MainMenuSettings.pages.level_3[1366][768] = MainMenuSettings.pages.level_3[1366][768] or {
	item_list = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		screen_offset_y = -0.25,
		pivot_align_x = "right",
		pivot_offset_x = 540 * SCALE_1366,
		column_alignment = {
			"right"
		}
	},
	tooltip_text_box = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		font_size = 16,
		pivot_offset_y = 0,
		screen_align_x = "left",
		text_align = "right",
		screen_offset_y = -0.6,
		pivot_align_x = "right",
		pivot_offset_x = 520 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_16,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 28 * SCALE_1366,
		width = 440 * SCALE_1366,
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
	back_list = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		screen_align_x = "left",
		number_of_columns = 2,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 0 * SCALE_1366,
		pivot_offset_y = 30 * SCALE_1366,
		column_alignment = {
			"left",
			"left"
		}
	},
	background_texture = {
		texture = "item_list_gradient_3_1920",
		texture_width = 568 * SCALE_1366,
		texture_height = 4 * SCALE_1366,
		texture_color_render_from_child_page = {
			80,
			255,
			255,
			255
		}
	}
}
MainMenuSettings.pages.level_4 = MainMenuSettings.pages.level_4 or {}
MainMenuSettings.pages.level_4[1366] = MainMenuSettings.pages.level_4[1366] or {}
MainMenuSettings.pages.level_4[1366][768] = MainMenuSettings.pages.level_4[1366][768] or {
	item_list = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		max_visible_rows = 11,
		screen_offset_y = -0.25,
		pivot_align_x = "left",
		pivot_offset_x = 192 * SCALE_1366,
		column_width = {
			460 * SCALE_1366
		}
	},
	tooltip_text_box = {
		pivot_align_x = "right",
		screen_offset_x = 0,
		pivot_align_y = "center",
		font_size = 16,
		text_align = "right",
		screen_align_y = "center",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		width = 270,
		padding_top = 20 * SCALE_1366,
		padding_right = 26 * SCALE_1366,
		padding_bottom = 20 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_16,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 28 * SCALE_1366,
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
	tooltip_text_box_2 = {
		pivot_align_x = "right",
		screen_offset_x = 0,
		pivot_align_y = "center",
		font_size = 14,
		text_align = "right",
		padding_top = 0,
		screen_align_y = "center",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		width = 270,
		padding_right = 26 * SCALE_1366,
		padding_bottom = 20 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_italic_14,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 28 * SCALE_1366,
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
	back_list = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		screen_align_x = "left",
		number_of_columns = 2,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_offset_x = 0 * SCALE_1366,
		pivot_offset_y = 30 * SCALE_1366,
		column_alignment = {
			"left",
			"left"
		}
	},
	background_texture = {
		texture = "item_list_gradient_4_1920",
		stretch_relative_width = 1,
		texture_width = 1920 * SCALE_1366,
		texture_height = 4 * SCALE_1366,
		texture_min_height = 260 * SCALE_1366,
		texture_color_render_from_child_page = {
			80,
			255,
			255,
			255
		}
	},
	background_texture_top_line = {
		width = 1,
		absolute_height = 1,
		color = {
			255,
			200,
			200,
			200
		}
	},
	background_texture_bottom_shadow = {
		texture = "item_list_shadow_4_1920",
		stretch_relative_width = 1,
		texture_height = 8 * SCALE_1366
	}
}
MainMenuSettings.pages.wotv_keymapping = MainMenuSettings.pages.wotv_keymapping or {}
MainMenuSettings.pages.wotv_keymapping[1366] = {}
MainMenuSettings.pages.wotv_keymapping[1366][768] = MainMenuSettings.pages.wotv_keymapping[1366][768] or table.clone(MainMenuSettings.pages.level_4[1366][768])
MainMenuSettings.pages.wotv_keymapping[1366][768].item_list = {
	spacing_y = 0,
	screen_offset_x = 0,
	pivot_align_y = "top",
	offset_x = 0,
	align = "right",
	spacing_x = 0,
	max_visible_rows = 10,
	num_columns = 1,
	max_shown_items = 15,
	screen_align_y = "top",
	z = 10,
	spacing = 0,
	pivot_offset_y = 0,
	screen_align_x = "center",
	max_shown_items_pad = 15,
	scroller_thickness = 10,
	pivot_offset_x = 0,
	screen_offset_y = -0.27,
	pivot_align_x = "center",
	offset_y = 0,
	column_width = {
		460
	},
	scroller_color = {
		255,
		215,
		215,
		215
	}
}

local item_list = MainMenuSettings.pages.wotv_keymapping[1366][768].item_list

function item_list.max_shown_items_func()
	return Managers.input:active_mapping(1) ~= "keyboard_mouse" and item_list.max_shown_items_pad or item_list.max_shown_items
end

MainMenuSettings.pages.wotv_keymapping[1366][768].background_texture = nil
MainMenuSettings.pages.wotv_keymapping[1366][768].background_texture_top_line = nil
MainMenuSettings.pages.wotv_keymapping[1366][768].background_texture_bottom_shadow = nil
MainMenuSettings.pages.wotv_keymapping[1366][768].overlay_texture = nil
MainMenuSettings.pages.wotv_keymapping[1366][768].header_items = {
	screen_align_y = "top",
	spacing = 10,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	num_columns = 1,
	screen_align_x = "center",
	align = "center",
	offset_x = 0,
	spacing_x = 10,
	pivot_offset_x = 0,
	screen_offset_y = -0.1,
	pivot_align_x = "center",
	spacing_y = 10,
	offset_y = -30,
	z = 10,
	screen_offset_x = -0
}
MainMenuSettings.pages.wotv_keymapping[1366][768].verification_items = {
	spacing_y = 0,
	screen_offset_x = 0,
	num_columns = 1,
	item_position = "centered",
	pivot_offset_y = 0,
	align = "center",
	spacing_x = 0,
	screen_align_x = "center",
	screen_align_y = "top",
	z = 10,
	spacing = 0,
	offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_x = 0,
	screen_offset_y = -0.7,
	pivot_align_x = "center",
	offset_y = 0
}
MainMenuSettings.pages.wotv_keymapping[1366][768].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
MainMenuSettings.pages.how_to_play_page = MainMenuSettings.pages.how_to_play_page or {}
MainMenuSettings.pages.how_to_play_page[1366] = MainMenuSettings.pages.how_to_play_page[1366] or {}
MainMenuSettings.pages.how_to_play_page[1366][768] = table.clone(MainMenuSettings.pages.full_screen_texture_page[1680][1050])
MainMenuSettings.pages.how_to_play_page[1366][768].logo_texture = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "how_to_play_screen_text_controls_1280x720",
	pivot_offset_y = 0,
	texture_width = 1280,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	z_offset = 10,
	texture_height = 720,
	color = {
		255,
		255,
		255,
		255
	}
}
MainMenuSettings.pages.how_to_play_page[1366][768].links = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "left",
	pivot_align_y = "bottom",
	screen_align_x = "right",
	pivot_offset_y = 0
}
MainMenuSettings.pages.how_to_play_end_of_tutorial_page = MainMenuSettings.pages.how_to_play_end_of_tutorial_page or {}
MainMenuSettings.pages.how_to_play_end_of_tutorial_page[1366] = MainMenuSettings.pages.how_to_play_end_of_tutorial_page[1366] or {}
MainMenuSettings.pages.how_to_play_end_of_tutorial_page[1366][768] = table.clone(MainMenuSettings.pages.how_to_play_page[1366][768])
MainMenuSettings.pages.how_to_play_end_of_tutorial_page[1366][768].logo_texture.texture = "how_to_play_screen_text_1280x720"
MainMenuSettings.pages.level_3_video_settings = MainMenuSettings.pages.level_3_video_settings or {}
MainMenuSettings.pages.level_3_video_settings[1366] = MainMenuSettings.pages.level_3_video_settings[1366] or {}
MainMenuSettings.pages.level_3_video_settings[1366][768] = MainMenuSettings.pages.level_3_video_settings[1366][768] or table.clone(MainMenuSettings.pages.level_3[1366][768])
MainMenuSettings.pages.level_3_video_settings[1366][768].item_list.screen_align_y = "center"
MainMenuSettings.pages.level_3_video_settings[1366][768].item_list.screen_offset_y = 0
MainMenuSettings.pages.level_3_video_settings[1366][768].item_list.pivot_align_y = "center"
MainMenuSettings.pages.level_2_character_profiles = MainMenuSettings.pages.level_2_character_profiles or {}
MainMenuSettings.pages.level_2_character_profiles[1366] = MainMenuSettings.pages.level_2_character_profiles[1366] or {}
MainMenuSettings.pages.level_2_character_profiles[1366][768] = MainMenuSettings.pages.level_2_character_profiles[1366][768] or table.clone(MainMenuSettings.pages.level_2[1366][768])
MainMenuSettings.pages.level_2_character_profiles[1366][768].text = MainMenuSettings.items.outfit_editor_text_right_aligned
MainMenuSettings.pages.level_2_character_profiles[1366][768].header_text = MainMenuSettings.items.header_text_right_aligned
MainMenuSettings.pages.level_2_character_profiles[1366][768].delimiter_texture = MainMenuSettings.items.delimiter_texture
MainMenuSettings.pages.level_2_character_profiles[1366][768].text_back = MainMenuSettings.items.text_right_aligned
MainMenuSettings.pages.level_2_character_profiles[1366][768].buy_coins = MainMenuSettings.items.buy_coins_right_aligned
MainMenuSettings.pages.level_2_character_profiles[1366][768].center_items = table.clone(FinalScoreboardMenuSettings.pages.main_page[1366][768].center_items)
MainMenuSettings.pages.level_2_character_profiles[1366][768].center_items.pivot_offset_y = 0
MainMenuSettings.pages.level_2_character_profiles[1366][768].profile_info = {
	screen_align_x = "right",
	screen_offset_x = 0,
	main_weapon_name_font_size = 22,
	sidearm_name_font_size = 22,
	profile_name_font_size = 22,
	screen_offset_y = 0,
	bgr_texture = "profile_info_bgr_1920",
	screen_align_y = "center",
	pivot_offset_y = 0,
	pivot_align_y = "center",
	pivot_offset_x = 0,
	dagger_name_font_size = 22,
	pivot_align_x = "right",
	shield_name_font_size = 22,
	bgr_texture_width = 700 * SCALE_1366,
	bgr_texture_height = 860 * SCALE_1366,
	profile_name_font = MenuSettings.fonts.hell_shark_22,
	profile_name_color = {
		255,
		255,
		255,
		255
	},
	profile_name_offset_x = 20 * SCALE_1366,
	profile_name_offset_y = 812 * SCALE_1366,
	main_weapon_name_font = MenuSettings.fonts.hell_shark_22,
	main_weapon_name_color = {
		255,
		0,
		0,
		0
	},
	main_weapon_name_offset_x = 20 * SCALE_1366,
	main_weapon_name_offset_y = 768 * SCALE_1366,
	sidearm_name_font = MenuSettings.fonts.hell_shark_22,
	sidearm_name_color = {
		255,
		0,
		0,
		0
	},
	sidearm_name_offset_x = 20 * SCALE_1366,
	sidearm_name_offset_y = 556 * SCALE_1366,
	dagger_name_font = MenuSettings.fonts.hell_shark_22,
	dagger_name_color = {
		255,
		0,
		0,
		0
	},
	dagger_name_offset_x = 20 * SCALE_1366,
	dagger_name_offset_y = 342 * SCALE_1366,
	shield_name_font = MenuSettings.fonts.hell_shark_22,
	shield_name_color = {
		255,
		0,
		0,
		0
	},
	shield_name_offset_x = 422 * SCALE_1366,
	shield_name_offset_y = 342 * SCALE_1366,
	main_weapon_viewer = {
		outfit_texture_atlas_name = "outfit_atlas",
		attachment_texture_atlas_name = "menu_atlas",
		outfit_texture_background = "outfit_background_1920",
		offset_x = 0,
		outfit_texture_overlay = "outfit_overlay_1920",
		offset_y = 592 * SCALE_1366,
		width = 588 * SCALE_1366,
		height = 160 * SCALE_1366,
		outfit_texture_offset_x = 24 * SCALE_1366,
		outfit_texture_offset_y = 15 * SCALE_1366,
		outfit_texture_width = 400 * SCALE_1366,
		outfit_texture_height = 128 * SCALE_1366,
		outfit_texture_atlas_settings = outfit_atlas,
		outfit_texture_background_width = 588 * SCALE_1366,
		outfit_texture_background_height = 160 * SCALE_1366,
		attachment_texture_offset_x = 436 * SCALE_1366,
		attachment_texture_offset_y = 106 * SCALE_1366,
		attachment_texture_size = 32 * SCALE_1366,
		attachment_texture_spacing_x = 10 * SCALE_1366,
		attachment_texture_atlas_settings = MenuAtlas
	},
	sidearm_viewer = {
		outfit_texture_atlas_name = "outfit_atlas",
		attachment_texture_atlas_name = "menu_atlas",
		outfit_texture_background = "outfit_background_1920",
		offset_x = 0,
		outfit_texture_overlay = "outfit_overlay_1920",
		offset_y = 379 * SCALE_1366,
		width = 588 * SCALE_1366,
		height = 160 * SCALE_1366,
		outfit_texture_offset_x = 24 * SCALE_1366,
		outfit_texture_offset_y = 15 * SCALE_1366,
		outfit_texture_width = 400 * SCALE_1366,
		outfit_texture_height = 128 * SCALE_1366,
		outfit_texture_atlas_settings = outfit_atlas,
		outfit_texture_background_width = 588 * SCALE_1366,
		outfit_texture_background_height = 160 * SCALE_1366,
		attachment_texture_offset_x = 436 * SCALE_1366,
		attachment_texture_offset_y = 106 * SCALE_1366,
		attachment_texture_size = 32 * SCALE_1366,
		attachment_texture_spacing_x = 10 * SCALE_1366,
		attachment_texture_atlas_settings = MenuAtlas
	},
	perk_offensive_offset_y = 272 * SCALE_1366,
	perk_defensive_offset_y = 211 * SCALE_1366,
	perk_supportive_offset_y = 150 * SCALE_1366,
	perk_movement_offset_y = 89 * SCALE_1366,
	perk_officer_offset_y = 28 * SCALE_1366,
	perks = {
		specialized_2_header_font_size = 13,
		basic_text_font_size = 11,
		specialized_1_header_font_size = 13,
		texture_atlas_name = "menu_atlas",
		basic_header_font_size = 18,
		width = 500 * SCALE_1366,
		height = 54 * SCALE_1366,
		basic_texture_width = 32 * SCALE_1366,
		basic_texture_height = 32 * SCALE_1366,
		basic_texture_offset_x = 24 * SCALE_1366,
		basic_texture_offset_y = 10 * SCALE_1366,
		basic_header_offset_x = 70 * SCALE_1366,
		basic_header_offset_y = 28 * SCALE_1366,
		basic_header_font = MenuSettings.fonts.hell_shark_18,
		basic_text_offset_x = 70 * SCALE_1366,
		basic_text_offset_y = 4 * SCALE_1366,
		basic_text_font = MenuSettings.fonts.hell_shark_11,
		specialized_1_texture_width = 20 * SCALE_1366,
		specialized_1_texture_height = 20 * SCALE_1366,
		specialized_1_texture_offset_x = 424 * SCALE_1366,
		specialized_1_texture_offset_y = 28 * SCALE_1366,
		specialized_1_header_offset_x = 456 * SCALE_1366,
		specialized_1_header_offset_y = 34 * SCALE_1366,
		specialized_1_header_font = MenuSettings.fonts.hell_shark_13,
		specialized_2_texture_width = 20 * SCALE_1366,
		specialized_2_texture_height = 20 * SCALE_1366,
		specialized_2_texture_offset_x = 424 * SCALE_1366,
		specialized_2_texture_offset_y = 3 * SCALE_1366,
		specialized_2_header_offset_x = 456 * SCALE_1366,
		specialized_2_header_offset_y = 7 * SCALE_1366,
		specialized_2_header_font = MenuSettings.fonts.hell_shark_13,
		texture_atlas_settings = MenuAtlas,
		text_color = {
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
		texture_width = 416 * SCALE_1366,
		texture_height = 308 * SCALE_1366,
		texture_offset_x = 290 * SCALE_1366,
		texture_offset_y = 542 * SCALE_1366
	}
}
MainMenuSettings.pages.level_2_character_profiles[1366][768].profile_viewer = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
MainMenuSettings.pages.level_2_character_profiles[1366][768].xp_progress_bar = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	screen_align_x = "center",
	number_of_columns = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_offset_y = 30 * SCALE_1366,
	column_alignment = {
		"center"
	}
}
MainMenuSettings.pages.level_2_character_profiles[1366][768].background_texture = {
	texture = "item_list_gradient_2_1920",
	texture_width = 4 * SCALE_1366,
	texture_height = 600 * SCALE_1366,
	stretch_width = 540 * SCALE_1366
}
MainMenuSettings.pages.level_2_character_profiles[1366][768].horizontal_line_top_texture = table.clone(MainMenuSettings.pages.level_2[1366][768].horizontal_line_top_texture)
MainMenuSettings.pages.level_2_character_profiles[1366][768].horizontal_line_top_texture.color = {
	0,
	0,
	0,
	0
}
MainMenuSettings.pages.level_2_character_profiles[1366][768].horizontal_line_bottom_texture = table.clone(MainMenuSettings.pages.level_2[1366][768].horizontal_line_bottom_texture)
MainMenuSettings.pages.level_2_character_profiles[1366][768].horizontal_line_bottom_texture.color = {
	0,
	0,
	0,
	0
}
MainMenuSettings.pages.level_3_character_profiles = MainMenuSettings.pages.level_3_character_profiles or {}
MainMenuSettings.pages.level_3_character_profiles[1366] = MainMenuSettings.pages.level_3_character_profiles[1366] or {}
MainMenuSettings.pages.level_3_character_profiles[1366][768] = MainMenuSettings.pages.level_3_character_profiles[1366][768] or table.clone(MainMenuSettings.pages.level_3[1366][768])
MainMenuSettings.pages.level_3_character_profiles[1366][768].text = MainMenuSettings.items.text_right_aligned
MainMenuSettings.pages.level_3_character_profiles[1366][768].header_text = MainMenuSettings.items.header_text_right_aligned
MainMenuSettings.pages.level_3_character_profiles[1366][768].delimiter_texture = MainMenuSettings.items.delimiter_texture
MainMenuSettings.pages.level_3_character_profiles[1366][768].text_back = MainMenuSettings.items.text_right_aligned
MainMenuSettings.pages.level_3_character_profiles[1366][768].buy_coins = MainMenuSettings.items.buy_coins_right_aligned
MainMenuSettings.pages.level_3_character_profiles[1366][768].center_items = table.clone(FinalScoreboardMenuSettings.pages.main_page[1366][768].center_items)
MainMenuSettings.pages.level_3_character_profiles[1366][768].center_items.screen_offset_y = -0.015
MainMenuSettings.pages.level_4_character_profiles = MainMenuSettings.pages.level_4_character_profiles or {}
MainMenuSettings.pages.level_4_character_profiles[1366] = MainMenuSettings.pages.level_4_character_profiles[1366] or {}
MainMenuSettings.pages.level_4_character_profiles[1366][768] = MainMenuSettings.pages.level_4_character_profiles[1366][768] or table.clone(MainMenuSettings.pages.level_4[1366][768])
MainMenuSettings.pages.level_4_character_profiles[1366][768].text = MainMenuSettings.items.outfit_editor_text_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].drop_down_list = MainMenuSettings.items.ddl_closed_text_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].checkbox = MainMenuSettings.items.outfit_editor_checkbox_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].header_text = MainMenuSettings.items.header_text_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].delimiter_texture = MainMenuSettings.items.delimiter_texture_left
MainMenuSettings.pages.level_4_character_profiles[1366][768].text_back = MainMenuSettings.items.text_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].buy_coins = MainMenuSettings.items.buy_coins
MainMenuSettings.pages.level_4_character_profiles[1366][768].texture_button = MainMenuSettings.items.texture_button_left_aligned
MainMenuSettings.pages.level_4_character_profiles[1366][768].perks = {
	pivot_align_y = "center",
	screen_align_y = "center",
	texture_background = "perk_background_1920",
	screen_offset_x = 0,
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_atlas_name = "menu_atlas",
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_offset_x = -140 * SCALE_1366,
	padding_top = 35 * SCALE_1366,
	basic_texture_width = 64 * SCALE_1366,
	basic_texture_height = 64 * SCALE_1366,
	basic_texture_offset_x = 19 * SCALE_1366,
	basic_texture_offset_y = 77 * SCALE_1366,
	specialized_1_texture_width = 64 * SCALE_1366,
	specialized_1_texture_height = 64 * SCALE_1366,
	specialized_1_texture_offset_x = 164 * SCALE_1366,
	specialized_1_texture_offset_y = 51 * SCALE_1366,
	specialized_2_texture_width = 64 * SCALE_1366,
	specialized_2_texture_height = 64 * SCALE_1366,
	specialized_2_texture_offset_x = 253 * SCALE_1366,
	specialized_2_texture_offset_y = 51 * SCALE_1366,
	texture_background_width = 580 * SCALE_1366,
	texture_background_height = 124 * SCALE_1366,
	texture_atlas_settings = MenuAtlas
}
MainMenuSettings.pages.level_4_armour_attachments = MainMenuSettings.pages.level_4_armour_attachments or {}
MainMenuSettings.pages.level_4_armour_attachments[1366] = MainMenuSettings.pages.level_4_armour_attachments[1366] or {}
MainMenuSettings.pages.level_4_armour_attachments[1366][768] = MainMenuSettings.pages.level_4_armour_attachments[1366][768] or table.clone(MainMenuSettings.pages.level_4_character_profiles[1366][768])
MainMenuSettings.pages.level_4_armour_attachments[1366][768].item_list.max_visible_rows = 7
MainMenuSettings.pages.level_2_coat_of_arms = MainMenuSettings.pages.level_2_coat_of_arms or {}
MainMenuSettings.pages.level_2_coat_of_arms[1366] = MainMenuSettings.pages.level_2_coat_of_arms[1366] or {}
MainMenuSettings.pages.level_2_coat_of_arms[1366][768] = MainMenuSettings.pages.level_2_coat_of_arms[1366][768] or table.clone(MainMenuSettings.pages.level_3[1366][768])
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].item_list = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_offset_x = 540 * SCALE_1366,
	column_alignment = {
		"right"
	}
}
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].back_list.number_of_columns = 1
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	screen_offset_y = -0.06,
	pivot_align_x = "right",
	pivot_offset_x = 540 * SCALE_1366,
	column_alignment = {
		"right"
	}
}
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = -0.06,
	pivot_align_x = "left",
	pivot_align_y = "top",
	screen_align_x = "left",
	pivot_offset_y = 0
}
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].button_info = {
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
			button_name = "d_pad",
			text = "main_menu_move"
		},
		{
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "b",
			text = "main_menu_cancel"
		}
	},
	division_selected_buttons = {
		{
			button_name = "d_pad",
			text = "main_menu_move"
		},
		{
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "b",
			text = "menu_cancel"
		}
	},
	division_specific_rendering = {
		charge = "_render_charge_buttons"
	}
}
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_division = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_division or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_division.pivot_offset_y = -36 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_type_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_type_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_type_picker.pivot_offset_y = -80 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_type_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_type_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_type_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_type_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_type_picker.pivot_offset_y = -130 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_type_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_type_picker.number_of_columns = 20
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_color_picker.pivot_offset_y = -160 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_color_picker.pivot_offset_y = -180 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_field_variation_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_type_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_type_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_type_picker.pivot_offset_y = -220 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_type_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_type_picker.number_of_columns = 20
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_color_picker.pivot_offset_y = -250 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_color_picker.pivot_offset_y = -270 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].division_variation_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_ordinary = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_ordinary or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_ordinary.pivot_offset_y = -340 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_color_picker.pivot_offset_y = -380 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_type_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_type_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_type_picker.pivot_offset_y = -420 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_type_picker.pivot_offset_x = 14 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].ordinary_type_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_charge = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_charge or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_charge.pivot_offset_y = -480 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_color_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_color_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_color_picker.pivot_offset_y = -520 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_color_picker.pivot_offset_x = 10 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_color_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker.pivot_offset_y = -560 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker.pivot_offset_x = 14 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker.number_of_visible_rows = 2
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].charge_type_picker.scroll_number_of_rows = 2
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_crest = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_crest or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].header_crest.pivot_offset_y = -660 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].crest_picker = MainMenuSettings.pages.level_2_coat_of_arms[1366][768].crest_picker or table.clone(MainMenuSettings.pages.level_2_coat_of_arms[1366][768].sub_header)
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].crest_picker.pivot_offset_y = -710 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].crest_picker.pivot_offset_x = 14 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].crest_picker.number_of_columns = 15
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].back_list.pivot_offset_y = 20 * SCALE_1366
MainMenuSettings.pages.level_2_coat_of_arms[1366][768].coat_of_arms_viewer = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
MainMenuSettings.pages.lobby = MainMenuSettings.pages.lobby or {}
MainMenuSettings.pages.lobby[1366] = MainMenuSettings.pages.lobby[1366] or {}
MainMenuSettings.pages.lobby[1366][768] = MainMenuSettings.pages.lobby[1366][768] or {
	item_list = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = -0.2,
		pivot_align_x = "center",
		column_alignment = {
			"center"
		}
	}
}
MainMenuSettings.pages.lobby[1366][768].button_info = {
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
			text = "main_menu_select"
		},
		{
			button_name = "x",
			text = "main_menu_change_map"
		},
		{
			button_name = "y",
			text = "main_menu_change_game_mode"
		},
		{
			button_name = "b",
			text = "main_menu_cancel"
		}
	}
}
MainMenuSettings.pages.join_lobby = MainMenuSettings.pages.join_lobby or {}
MainMenuSettings.pages.join_lobby[1366] = MainMenuSettings.pages.join_lobby[1366] or {}
MainMenuSettings.pages.join_lobby[1366][768] = MainMenuSettings.pages.join_lobby[1366][768] or table.clone(MainMenuSettings.pages.lobby[1366][768])
MainMenuSettings.pages.join_lobby[1366][768].do_not_render_buttons = true
MainMenuSettings.pages.ddl_center_aligned = MainMenuSettings.pages.ddl_center_aligned or {}
MainMenuSettings.pages.ddl_center_aligned[1366] = {}
MainMenuSettings.pages.ddl_center_aligned[1366][768] = MainMenuSettings.pages.ddl_center_aligned[1366][768] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
MainMenuSettings.pages.ddl_center_aligned[1366][768].drop_down_list = {
	offset_x = 0,
	list_alignment = "right",
	number_of_visible_rows = 10,
	item_config = "MainMenuSettings.items.ddl_open_text_center_aligned",
	item_type = "HeaderItem",
	offset_y = 0,
	rect_background_color = {
		255,
		0,
		0,
		0
	},
	items = {
		columns = {
			{
				width = 190,
				align = "right"
			}
		},
		rows = {
			{
				align = "bottom",
				height = 30
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "right"
	}
}
MainMenuSettings.pages.ddl_center_aligned[1680][1050].tooltip_text_box = nil
MainMenuSettings.pages.ddl_center_aligned[1680][1050].tooltip_text_box_2 = nil
MainMenuSettings.pages.ddl_center_aligned_large = MainMenuSettings.pages.ddl_center_aligned_large or {}
MainMenuSettings.pages.ddl_center_aligned_large[1366] = {}
MainMenuSettings.pages.ddl_center_aligned_large[1366][768] = MainMenuSettings.pages.ddl_center_aligned_large[1366][768] or table.clone(MainMenuSettings.pages.ddl_center_aligned[1366][768])
MainMenuSettings.pages.ddl_center_aligned_large[1366][768].drop_down_list.items.columns = {
	{
		width = 200,
		align = "right"
	}
}
MainMenuSettings.pages.outfit_ddl_left_aligned = MainMenuSettings.pages.outfit_ddl_left_aligned or {}
MainMenuSettings.pages.outfit_ddl_left_aligned[1366] = MainMenuSettings.pages.outfit_ddl_left_aligned[1366] or {}
MainMenuSettings.pages.outfit_ddl_left_aligned[1366][768] = MainMenuSettings.pages.outfit_ddl_left_aligned[1366][768] or table.clone(MainMenuSettings.pages.level_4[1366][768])
MainMenuSettings.pages.outfit_ddl_left_aligned[1366][768].drop_down_list = {
	texture_background_align = "left",
	texture_background = "ddl_background_left_1920",
	list_alignment = "left",
	number_of_visible_rows = 8,
	offset_y = 0,
	offset_x = 22 * SCALE_1366,
	texture_background_width = 568 * SCALE_1366,
	item_config = MainMenuSettings.items.outfit_ddl_open_text_left_aligned,
	items = {
		columns = {
			{
				align = "left",
				width = 568 * SCALE_1366
			}
		},
		rows = {
			{
				align = "bottom",
				height = 36 * SCALE_1366
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "left"
	}
}
MainMenuSettings.pages.outfit_ddl_left_aligned[1366][768].tooltip_text_box = nil
MainMenuSettings.pages.outfit_ddl_left_aligned[1366][768].tooltip_text_box_2 = nil
MainMenuSettings.items.twitter = MainMenuSettings.items.twitter or {}
MainMenuSettings.items.twitter[1366] = MainMenuSettings.items.twitter[1366] or {}
MainMenuSettings.items.twitter[1366][768] = MainMenuSettings.items.twitter[1366][768] or {
	texture = "twitter",
	highlight_multiplier = 0.3,
	texture_align = "bottom_left",
	texture_width = 50,
	highlight_time = 0.35,
	indentation = 0.04,
	texture_height = 100
}
MainMenuSettings.items.discord = MainMenuSettings.items.discord or {}
MainMenuSettings.items.discord[1366] = MainMenuSettings.items.discord[1366] or {}
MainMenuSettings.items.discord[1366][768] = MainMenuSettings.items.discord[1366][768] or {
	texture = "discord",
	highlight_multiplier = 0.3,
	texture_align = "bottom_left",
	texture_width = 50,
	highlight_time = 0.35,
	indentation = 0.04,
	texture_height = 100
}
MainMenuSettings.items.steam_chat = MainMenuSettings.items.steam_chat or {}
MainMenuSettings.items.steam_chat[1366] = MainMenuSettings.items.steam_chat[1366] or {}
MainMenuSettings.items.steam_chat[1366][768] = MainMenuSettings.items.steam_chat[1366][768] or {
	texture_extra_offset = 60,
	texture = "steam_chat",
	texture_align = "bottom_left",
	texture_width = 50,
	highlight_multiplier = 0.3,
	highlight_time = 0.35,
	indentation = 0.04,
	texture_height = 100
}
MainMenuSettings.items.survey = MainMenuSettings.items.survey or {}
MainMenuSettings.items.survey[1366] = MainMenuSettings.items.survey[1366] or {}
MainMenuSettings.items.survey[1366][768] = MainMenuSettings.items.survey[1366][768] or {
	texture_extra_offset = 120,
	texture = "survey",
	texture_align = "bottom_left",
	texture_width = 50,
	highlight_multiplier = 0.3,
	highlight_time = 0.35,
	indentation = 0.04,
	texture_height = 100
}
MainMenuSettings.items.filter_popup_header = MainMenuSettings.items.filter_popup_header or {}
MainMenuSettings.items.filter_popup_header[1366] = MainMenuSettings.items.filter_popup_header[1366] or {}
MainMenuSettings.items.filter_popup_header[1366][768] = MainMenuSettings.items.filter_popup_header[1366][768] or table.clone(MainMenuSettings.items.popup_header[1366][768])
MainMenuSettings.items.filter_popup_header[1366][768].texture_disabled = nil
MainMenuSettings.items.filter_popup_header[1366][768].texture_disabled_width = 400 * SCALE_1366
MainMenuSettings.items.filter_popup_header[1366][768].texture_disabled_height = 50 * SCALE_1366
MainMenuSettings.items.filter_popup_header[1366][768].texture_disabled_color = {
	100,
	255,
	255,
	255
}
MainMenuSettings.items.filter_popup_header[1366][768].font = MenuSettings.fonts.hell_shark_32
MainMenuSettings.items.filter_popup_header[1366][768].font_size = 32
MainMenuSettings.items.filter_popup_header[1366][768].texture_alignment = "center"
MainMenuSettings.items.filter_popup_header[1366][768].padding_left = 0
MainMenuSettings.items.filter_popup_header[1366][768].texture_disabled_width = 470 * SCALE_1366
MainMenuSettings.items.facebook = MainMenuSettings.items.facebook or {}
MainMenuSettings.items.facebook[1366] = MainMenuSettings.items.facebook[1366] or {}
MainMenuSettings.items.facebook[1366][768] = MainMenuSettings.items.facebook[1366][768] or {
	texture_extra_offset = 60,
	texture = "facebook",
	texture_align = "bottom_left",
	texture_width = 50,
	highlight_multiplier = 0.3,
	highlight_time = 0.35,
	indentation = 0.04,
	texture_height = 100
}
MainMenuSettings.items.pdx_login_input = MainMenuSettings.items.pdx_login_input or {}
MainMenuSettings.items.pdx_login_input[1366] = {}
MainMenuSettings.items.pdx_login_input[1366][768] = {
	height = 20,
	text_alignement_y = "bottom",
	marker_offset_x = 0,
	font_size = 18,
	text_offset_y = 5,
	masked = true,
	marker_offset_y = -2,
	marker_height = 14,
	text_alignement_x = "left",
	marker_width = 1,
	width = 365,
	text_offset_x = 3,
	font = MenuSettings.fonts.arial_18_masked,
	text_color = {
		255,
		255,
		255,
		255
	},
	border = {
		thickness = 1,
		color = {
			100,
			255,
			255,
			255
		}
	},
	confine_settings = {
		width = 360
	}
}
MainMenuSettings.items.pdx_login_input_password = MainMenuSettings.items.pdx_login_input_password or {}
MainMenuSettings.items.pdx_login_input_password[1366] = {}
MainMenuSettings.items.pdx_login_input_password[1366][768] = table.clone(MainMenuSettings.items.pdx_login_input[1366][768])
MainMenuSettings.items.pdx_login_input_password[1366][768].hidden = true
MainMenuSettings.items.pdx_login_input_password[1366][768].text_offset_y = 4
MainMenuSettings.items.pdx_login_input_password[1366][768].marker_offset_y = 0
MainMenuSettings.pages.filter_popup = MainMenuSettings.pages.filter_popup or {}
MainMenuSettings.pages.filter_popup[1366] = MainMenuSettings.pages.filter_popup[1366] or {}
MainMenuSettings.pages.filter_popup[1366][768] = MainMenuSettings.pages.filter_popup[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
MainMenuSettings.pages.filter_popup[1366][768].item_list.column_alignment = {
	"left"
}
MainMenuSettings.pages.filter_popup[1366][768].item_list.screen_offset_x = 0.13 * SCALE_1366
MainMenuSettings.pages.filter_popup[1366][768].item_list.pivot_offset_y = 0
MainMenuSettings.pages.filter_popup[1366][768].background_rect.absolute_width = 400 * SCALE_1366
MainMenuSettings.pages.filter_popup[1366][768].background_rect.absolute_height = 470 * SCALE_1366
MainMenuSettings.pages.filter_popup[1366][768].background_rect.border_size = 1
MainMenuSettings.pages.filter_popup[1366][768].background_rect.border_color = {
	255,
	192,
	192,
	192
}
MainMenuSettings.pages.filter_popup[1366][768].background_rect.color = {
	255,
	20,
	20,
	20
}
MainMenuSettings.pages.filter_popup[1366][768].header_list.column_width = {
	400 * SCALE_1366
}
MainMenuSettings.pages.filter_popup[1366][768].header_list.column_alignment = {
	"center"
}
MainMenuSettings.pages.filter_popup[1366][768].header_list.pivot_offset_y = 200 * SCALE_1366
MainMenuSettings.default_button_info = MainMenuSettings.default_button_info or {}
MainMenuSettings.default_button_info[1366] = MainMenuSettings.default_button_info[1366] or {}
MainMenuSettings.default_button_info[1366][768] = MainMenuSettings.default_button_info[1366][768] or {
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
			button_name = "d_pad",
			text = "main_menu_move"
		},
		{
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "b",
			text = "main_menu_cancel"
		}
	}
}
MainMenuSettings.items.header_centered_text = MainMenuSettings.items.header_centered_text or {}
MainMenuSettings.items.header_centered_text[1366] = {}
MainMenuSettings.items.header_centered_text[1366][768] = MainMenuSettings.items.header_centered_text[1366][768] or {
	padding_left = 0,
	padding_right = 20,
	font_size = 50,
	padding_top = -50,
	padding_bottom = 57,
	line_height = 25,
	expand_on_highlight = true,
	font = MenuSettings.fonts.hell_shark_36,
	color = {
		255,
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
	color_disabled = {
		255,
		100,
		100,
		100
	},
	color_render_from_child_page = {
		80,
		255,
		255,
		255
	},
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.centered_text = MainMenuSettings.items.centered_text or {}
MainMenuSettings.items.centered_text[1366] = {}
MainMenuSettings.items.centered_text[1366][768] = {
	align = "left",
	highlight_font_size = 22,
	font_size = 20,
	padding_top = 3,
	padding_bottom = 7,
	font = MenuSettings.fonts.hell_shark_20,
	highlight_font = MenuSettings.fonts.hell_shark_22,
	color = {
		160,
		255,
		255,
		255
	},
	disabled_color = {
		90,
		255,
		255,
		255
	},
	highlight_color = {
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
	drop_shadow_color_disabled = {
		60,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
MainMenuSettings.items.centered_new_unlock_text = MainMenuSettings.items.centered_new_unlock_text or {}
MainMenuSettings.items.centered_new_unlock_text[1366] = {}
MainMenuSettings.items.centered_new_unlock_text[1366][768] = table.clone(MainMenuSettings.items.centered_text[1366][768])
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_atlas = "menu_assets"
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture = "new_icon_horizontal"
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_align_x = "right"
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_align_y = "center"
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_offset_x = -30
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_offset_y = -7
MainMenuSettings.items.centered_new_unlock_text[1366][768].texture_color = {
	255,
	255,
	255,
	255
}
MainMenuSettings.items.centered_new_unlock_text[1366][768].scale = SCALE_1366
MainMenuSettings.items.centered_new_unlock_text[1366][768].required_rank = {
	offset_x = 25,
	icon_material = "lvl",
	icon_scale = 0.65,
	font_size = 16,
	align = "right",
	masked = false,
	offset_z = 100,
	icon_atlas = "menu_assets",
	offset_y = 0,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		255,
		49,
		18
	},
	drop_shadow_offset = {
		2,
		-2
	},
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	icon_offset = {
		0,
		0
	}
}
MainMenuSettings.items.large_centered_text = MainMenuSettings.items.large_centered_text or {}
MainMenuSettings.items.large_centered_text[1366] = {}
MainMenuSettings.items.large_centered_text[1366][768] = {
	align = "left",
	highlight_font_size = 42,
	font_size = 36,
	padding_top = -15,
	padding_bottom = 0,
	font = MenuSettings.fonts.hell_shark_36,
	highlight_font = MenuSettings.fonts.hell_shark_36,
	color = {
		160,
		255,
		255,
		255
	},
	highlight_color = {
		255,
		255,
		255,
		255
	},
	disabled_color = {
		90,
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
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.centered_menu_header = MainMenuSettings.items.centered_menu_header or {}
MainMenuSettings.items.centered_menu_header[1366] = {}
MainMenuSettings.items.centered_menu_header[1366][768] = {
	highlight_font_size = 32,
	font_size = 28,
	align = "left",
	padding_bottom = 25,
	font = MenuSettings.fonts.hell_shark_28,
	highlight_font = MenuSettings.fonts.hell_shark_32,
	color = {
		255,
		87,
		163,
		199
	},
	disabled_color = {
		255,
		87,
		163,
		199
	},
	highlight_color = {
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
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.key_centered_text = MainMenuSettings.items.key_centered_text or {}
MainMenuSettings.items.key_centered_text[1366] = {}
MainMenuSettings.items.key_centered_text[1366][768] = table.clone(MainMenuSettings.items.centered_text[1366][768])
MainMenuSettings.items.key_centered_text[1366][768].padding_bottom = 20
MainMenuSettings.items.key_centered_text[1366][768].padding_top = 10
MainMenuSettings.items.centered_slider = MainMenuSettings.items.centered_slider or {}
MainMenuSettings.items.centered_slider[1366] = {}
MainMenuSettings.items.centered_slider[1366][768] = {
	highlight_font_size = 18,
	padding_top = 15,
	align = "left",
	slider_extra_highlight_size_x = 10,
	padding_bottom = 15,
	line_height = 5,
	spacing = 10,
	font_size = 16,
	slider_extra_highlight_size_y = 10,
	font = MenuSettings.fonts.hell_shark_16,
	highlight_font = MenuSettings.fonts.hell_shark_18,
	color = {
		160,
		255,
		255,
		255
	},
	highlight_color = {
		255,
		255,
		255,
		255
	},
	slider_size = {
		130,
		4
	},
	drop_shadow_color = {
		90,
		0,
		0,
		0
	},
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.centered_enum = MainMenuSettings.items.centered_enum or {}
MainMenuSettings.items.centered_enum[1366] = {}
MainMenuSettings.items.centered_enum[1366][768] = {
	font_size = 16,
	padding_top = 5,
	padding_bottom = 5,
	line_height = 8,
	padding_right = 0,
	highlighted_font_size = 18,
	spacing = 10,
	padding_left = 1,
	font = MenuSettings.fonts.hell_shark_16,
	highlighted_font = MenuSettings.fonts.hell_shark_18,
	color = {
		160,
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
	color_disabled = {
		255,
		100,
		100,
		100
	},
	drop_shadow_color = {
		90,
		0,
		0,
		0
	},
	drop_shadow_color_disabled = {
		255,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	},
	color_render_from_child_page = {
		80,
		255,
		255,
		255
	}
}
MainMenuSettings.items.centered_enum_checkbox = MainMenuSettings.items.centered_enum_checkbox or {}
MainMenuSettings.items.centered_enum_checkbox[1366] = {}
MainMenuSettings.items.centered_enum_checkbox[1366][768] = table.clone(MainMenuSettings.items.centered_enum[1366][768])
MainMenuSettings.items.centered_enum_checkbox[1366][768].checkbox = true
MainMenuSettings.items.centered_enum_checkbox[1366][768].checkbox_size = {
	12,
	12
}
MainMenuSettings.items.centered_enum_checkbox[1366][768].checkbox_bg_color = {
	255,
	90,
	90,
	90
}
MainMenuSettings.items.centered_enum_checkbox[1366][768].border_thickness = 2
MainMenuSettings.items.centered_enum_checkbox[1366][768].checkbox_checked_color = {
	255,
	255,
	255,
	255
}
MainMenuSettings.items.centered_header_text = MainMenuSettings.items.centered_header_text or {}
MainMenuSettings.items.centered_header_text[1366] = {}
MainMenuSettings.items.centered_header_text[1366][768] = {
	align = "left",
	highlight_font_size = 42,
	font_size = 36,
	padding_top = -15,
	padding_bottom = 25,
	font = MenuSettings.fonts.hell_shark_36,
	highlight_font = MenuSettings.fonts.hell_shark_36,
	color = {
		160,
		255,
		255,
		255
	},
	highlight_color = {
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
	drop_shadow_color_disabled = {
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
MainMenuSettings.items.exit_header_text = MainMenuSettings.items.exit_header_text or {}
MainMenuSettings.items.exit_header_text[1366] = {}
MainMenuSettings.items.exit_header_text[1366][768] = {
	align = "left",
	highlight_font_size = 22,
	font_size = 20,
	padding_top = 0,
	font = MenuSettings.fonts.hell_shark_20,
	highlight_font = MenuSettings.fonts.hell_shark_22,
	color = {
		160,
		255,
		255,
		255
	},
	highlight_color = {
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
	drop_shadow_color_disabled = {
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
