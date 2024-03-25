-- chunkname: @scripts/menu/menu_definitions/battle_report_page_settings_1920.lua

BattleReportSettings = BattleReportSettings or {}
BattleReportSettings.items = BattleReportSettings.items or {}
BattleReportSettings.pages = BattleReportSettings.pages or {}
BattleReportSettings.items.header = BattleReportSettings.items.header or {}
BattleReportSettings.items.header[1680] = BattleReportSettings.items.header[1680] or {}
BattleReportSettings.items.header[1680][1050] = BattleReportSettings.items.header[1680][1050] or {
	padding_left = 0,
	font_size = 36,
	padding_top = 0,
	padding_bottom = 0,
	line_height = 22,
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
	}
}
BattleReportSettings.items.stat_value = BattleReportSettings.items.stat_value or {}
BattleReportSettings.items.stat_value[1680] = {}
BattleReportSettings.items.stat_value[1680][1050] = BattleReportSettings.items.stat_value[1680][1050] or {
	color_callback = "cb_team_color",
	font_size = 28,
	padding_left = 0,
	padding_top = 10,
	padding_bottom = 0,
	line_height = 22,
	padding_right = 0,
	font = MenuSettings.fonts.arial,
	drop_down_color = {
		255,
		0,
		0,
		0
	}
}
BattleReportSettings.items.stat_name = BattleReportSettings.items.stat_name or {}
BattleReportSettings.items.stat_name[1680] = {}
BattleReportSettings.items.stat_name[1680][1050] = BattleReportSettings.items.stat_name[1680][1050] or {
	font_size = 22,
	padding_left = 20,
	padding_top = 10,
	padding_bottom = 0,
	line_height = 22,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_22,
	color = {
		255,
		255,
		255,
		255
	},
	drop_down_color = {
		255,
		0,
		0,
		0
	}
}
BattleReportSettings.items.scoreboard_header = BattleReportSettings.items.scoreboard_header or {}
BattleReportSettings.items.scoreboard_header[1680] = {}
BattleReportSettings.items.scoreboard_header[1680][1050] = BattleReportSettings.items.scoreboard_header[1680][1050] or {
	screen_width = 0.85,
	height = 130,
	viking_texture = "medium_rose_red_1920",
	padding_left = 0,
	font_size = 75,
	padding_top = 0,
	saxon_texture = "medium_rose_white_1920",
	padding_bottom = 0,
	line_height = 22,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	color = {
		160,
		0,
		0,
		0
	},
	texture_size = {
		160,
		160
	},
	left_team_score = {
		font_size = 120,
		padding_x = 25,
		padding_y = -35,
		font = MenuSettings.fonts.font_gradient_100
	},
	right_team_score = {
		font_size = 120,
		padding_x = 25,
		padding_y = -35,
		font = MenuSettings.fonts.font_gradient_100
	}
}
BattleReportSettings.items.scoreboard_left = BattleReportSettings.items.scoreboard_left or {}
BattleReportSettings.items.scoreboard_left[1680] = {}
BattleReportSettings.items.scoreboard_left[1680][1050] = BattleReportSettings.items.scoreboard_left[1680][1050] or {
	screen_align_x = "left",
	scroller_width = 3,
	scrollbar_line_width = 1,
	scrollbar_offset_x = 10,
	pivot_offset_y = 0,
	padding_top = 40,
	screen_offset_x = 0.075,
	padding_bottom = 0,
	line_height = 22,
	screen_height = 0.45,
	scroller_height = 0.4,
	padding_left = 0,
	padding_right = 0,
	screen_width = 0.42,
	screen_align_y = "top",
	z = 10,
	pivot_align_y = "top",
	font_size = 60,
	pivot_offset_x = 0,
	screen_offset_y = -0.21,
	pivot_align_x = "left",
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
	header = {
		{
			font_size = 24,
			padding_left = 0.07,
			text_func = "cb_team_name",
			padding_top = -30,
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_score_lower",
			padding_top = -30,
			padding_left = 0.48,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_kills_lower",
			padding_top = -30,
			padding_left = 0.56,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_deaths_lower",
			padding_top = -30,
			padding_left = 0.64,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_assist_lower",
			padding_top = -30,
			padding_left = 0.72,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_level_lower",
			padding_top = -30,
			padding_left = 0.84,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			font_size = 24,
			padding_top = -30,
			padding_left = 0.94,
			text_func = "cb_show_ping",
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		}
	}
}
BattleReportSettings.items.scoreboard_right = BattleReportSettings.items.scoreboard_right or {}
BattleReportSettings.items.scoreboard_right[1680] = {}
BattleReportSettings.items.scoreboard_right[1680][1050] = BattleReportSettings.items.scoreboard_right[1680][1050] or {
	screen_align_x = "right",
	scroller_width = 3,
	scrollbar_line_width = 1,
	scrollbar_offset_x = 10,
	pivot_offset_y = 0,
	padding_top = 40,
	screen_offset_x = -0.075,
	padding_bottom = 0,
	line_height = 22,
	screen_height = 0.45,
	scroller_height = 0.4,
	padding_left = 0,
	padding_right = 0,
	screen_width = 0.42,
	screen_align_y = "top",
	z = 10,
	pivot_align_y = "top",
	font_size = 60,
	pivot_offset_x = 0,
	screen_offset_y = -0.21,
	pivot_align_x = "right",
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
	header = {
		{
			font_size = 24,
			padding_left = 0.07,
			text_func = "cb_team_name",
			padding_top = -30,
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_score_lower",
			padding_top = -30,
			padding_left = 0.48,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_kills_lower",
			padding_top = -30,
			padding_left = 0.56,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_deaths_lower",
			padding_top = -30,
			padding_left = 0.64,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_assist_lower",
			padding_top = -30,
			padding_left = 0.72,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			text = "menu_level_lower",
			padding_top = -30,
			padding_left = 0.84,
			font_size = 24,
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		},
		{
			font_size = 24,
			padding_top = -30,
			padding_left = 0.94,
			text_func = "cb_show_ping",
			align = "right",
			font = MenuSettings.fonts.hell_shark_24
		}
	}
}
BattleReportSettings.items.squad_score = BattleReportSettings.items.squad_score or {}
BattleReportSettings.items.squad_score[1680] = {}
BattleReportSettings.items.squad_score[1680][1050] = BattleReportSettings.items.squad_score[1680][1050] or {
	padding_left = 40,
	item_height = 30,
	font_size = 28,
	expand_rect_z = 2,
	player_padding = 6,
	expand_rect_frame_size = 2,
	expand_rect_size = 10,
	padding_right = 40,
	padding = 10,
	font = MenuSettings.fonts.hell_shark_28_masked,
	expand_rect_color = {
		255,
		255,
		255,
		255
	},
	expand_rect_frame_color = {
		255,
		0,
		0,
		0
	},
	header = {
		font_size = 28,
		padding_left = 20,
		padding_bottom = 6,
		color = {
			128,
			255,
			255,
			255
		},
		lone_wolves_color = {
			128,
			128,
			128,
			128
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		items = {
			{
				font_size = 24,
				text_func = "cb_squad_name",
				padding_left = 0.03,
				padding_bottom = 6,
				font = MenuSettings.fonts.hell_shark_24_masked
			},
			{
				text_func = "score",
				padding_top = -30,
				padding_left = 0.468,
				font_size = 24,
				align = "right",
				padding_bottom = 6,
				font = MenuSettings.fonts.hell_shark_24_masked
			},
			{
				text_func = "cb_squad_kills",
				padding_top = -30,
				padding_left = 0.563,
				font_size = 24,
				align = "right",
				padding_bottom = 6,
				font = MenuSettings.fonts.hell_shark_24_masked
			},
			{
				text_func = "cb_squad_deaths",
				padding_top = -30,
				padding_left = 0.655,
				font_size = 24,
				align = "right",
				padding_bottom = 6,
				font = MenuSettings.fonts.hell_shark_24_masked
			},
			{
				text_func = "cb_squad_assists",
				padding_top = -30,
				padding_left = 0.742,
				font_size = 24,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_24_masked
			},
			{
				text_func = "cb_squad_average_level",
				padding_top = -30,
				padding_left = 0.88,
				font_size = 24,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_24_masked
			}
		}
	}
}
BattleReportSettings.items.player_score = BattleReportSettings.items.player_score or {}
BattleReportSettings.items.player_score[1680] = {}
BattleReportSettings.items.player_score[1680][1050] = BattleReportSettings.items.player_score[1680][1050] or {
	font_size = 28,
	item_height = 26,
	item_width = 200,
	item_padding_bottom = -20,
	padding_left = 40,
	expand_rect_z = 2,
	player_padding = 3,
	expand_rect_frame_size = 2,
	expand_rect_size = 10,
	padding_right = 40,
	padding = 10,
	font = MenuSettings.fonts.hell_shark_28_masked,
	expand_rect_color = {
		255,
		255,
		255,
		255
	},
	expand_rect_frame_color = {
		255,
		0,
		0,
		0
	},
	items = {
		{
			padding_left = 0.02,
			padding_top = 5,
			bitmap_ex_material = "hud_assets_masked",
			bitmap_ex_func = "cb_player_is_dead",
			bitmap_ex_texture = "hud_combatlog_selfkilled",
			bitmap_ex_atlas = "hud_assets",
			bitmap_size = {
				100.8,
				28
			},
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			font_size = 24,
			padding_left = 0.05,
			max_text_width = 200,
			padding_top = 5,
			local_text_color_func = "cb_local_player_color",
			crop_text = true,
			text_func = "cb_player_name",
			font = MenuSettings.fonts.arial_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.468,
			font_size = 24,
			align = "right",
			text_func = "cb_player_score",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.563,
			font_size = 24,
			align = "right",
			text_func = "cb_player_kills",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.655,
			font_size = 24,
			align = "right",
			text_func = "cb_player_deaths",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.742,
			font_size = 24,
			align = "right",
			text_func = "cb_player_assists",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.88,
			font_size = 24,
			align = "right",
			text_func = "cb_player_level",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		},
		{
			local_text_color_func = "cb_local_player_color",
			padding_left = 0.995,
			font_size = 24,
			align = "right",
			text_func = "cb_player_ping",
			font = MenuSettings.fonts.hell_shark_24_masked,
			text_color = {
				255,
				255,
				255,
				255
			},
			shadow_color = {
				255,
				0,
				0,
				0
			}
		}
	}
}
BattleReportSettings.items.player_option_item = BattleReportSettings.items.player_option_item or {}
BattleReportSettings.items.player_option_item[1680] = BattleReportSettings.items.player_option_item[1680] or {}
BattleReportSettings.items.player_option_item[1680][1050] = BattleReportSettings.items.player_option_item[1680][1050] or {
	highlight_font_size = 24,
	padding_top = 5,
	font_size = 22,
	align = "left",
	line_height = 26,
	padding_bottom = 12,
	padding_right = 0,
	padding_left = 5,
	font = MenuSettings.fonts.hell_shark_22,
	highlight_font = MenuSettings.fonts.hell_shark_24,
	color = {
		255,
		200,
		200,
		200
	},
	color_highlighted = {
		255,
		250,
		250,
		250
	},
	color_disabled = {
		255,
		50,
		50,
		50
	},
	drop_shadow_color = {
		60,
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
	}
}
BattleReportSettings.pages.player_options_drop_down_list = BattleReportSettings.pages.player_options_drop_down_list or {}
BattleReportSettings.pages.player_options_drop_down_list[1680] = BattleReportSettings.pages.player_options_drop_down_list[1680] or {}
BattleReportSettings.pages.player_options_drop_down_list[1680][1050] = BattleReportSettings.pages.player_options_drop_down_list[1680][1050] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
BattleReportSettings.pages.player_options_drop_down_list[1680][1050].drop_down_list = {
	list_alignment = "left",
	offset_x = 2,
	border_thickness = 3,
	render_border = true,
	number_of_visible_rows = 4,
	item_type = "HeaderItem",
	offset_y = -20,
	border_color = {
		255,
		20,
		20,
		20
	},
	rect_background_color = {
		255,
		40,
		40,
		40
	},
	item_config = BattleReportSettings.items.player_option_item,
	items = {
		columns = {
			{
				width = 140,
				align = "left"
			}
		},
		rows = {
			{
				align = "center",
				height = 26
			}
		}
	}
}
BattleReportSettings.items.server_name = BattleReportSettings.items.server_name or {}
BattleReportSettings.items.server_name[1680] = {}
BattleReportSettings.items.server_name[1680][1050] = BattleReportSettings.items.server_name[1680][1050] or {
	padding_left = 0,
	font_size = 60,
	padding_top = 40,
	padding_bottom = 0,
	line_height = 22,
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
	}
}
BattleReportSettings.items.game_mode_name = BattleReportSettings.items.game_mode_name or {}
BattleReportSettings.items.game_mode_name[1680] = {}
BattleReportSettings.items.game_mode_name[1680][1050] = BattleReportSettings.items.game_mode_name[1680][1050] or {
	padding_left = 0,
	font_size = 60,
	padding_top = 100,
	padding_bottom = 0,
	line_height = 22,
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
	}
}
BattleReportSettings.items.header_delimiter_bottom = BattleReportSettings.items.header_delimiter_bottom or {}
BattleReportSettings.items.header_delimiter_bottom[1680] = BattleReportSettings.items.header_delimiter_bottom[1680] or {}
BattleReportSettings.items.header_delimiter_bottom[1680][1050] = BattleReportSettings.items.header_delimiter_bottom[1680][1050] or {
	texture = "item_list_bottom_horizontal_line_1920",
	padding_bottom = 0,
	padding_left = 0,
	texture_width = 1000,
	padding_top = 0,
	padding_right = 0,
	texture_height = 12,
	color = {
		255,
		200,
		200,
		200
	}
}
BattleReportSettings.items.countdown = BattleReportSettings.items.countdown or {}
BattleReportSettings.items.countdown[1680] = BattleReportSettings.items.countdown[1680] or {}
BattleReportSettings.items.countdown[1680][1050] = BattleReportSettings.items.countdown[1680][1050] or {
	texture_disabled = "countdown_background_1920",
	texture_disabled_height = 32,
	texture_alignment = "center",
	padding_left = 0,
	font_size = 22,
	padding_top = 0,
	texture_disabled_width = 508,
	padding_bottom = 0,
	line_height = 14,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_22,
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
BattleReportSettings.items.scoreboard_scroll_bar = BattleReportSettings.items.scoreboard_scroll_bar or {}
BattleReportSettings.items.scoreboard_scroll_bar[1680] = BattleReportSettings.items.scoreboard_scroll_bar[1680] or {}
BattleReportSettings.items.scoreboard_scroll_bar[1680][1050] = BattleReportSettings.items.scoreboard_scroll_bar[1680][1050] or {
	scroll_bar_handle_width = 6,
	width = 20,
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
		0,
		50,
		50,
		50
	}
}
BattleReportSettings.items.scoreboard_header_text = BattleReportSettings.items.scoreboard_header_text or {}
BattleReportSettings.items.scoreboard_header_text[1680] = BattleReportSettings.items.scoreboard_header_text[1680] or {}
BattleReportSettings.items.scoreboard_header_text[1680][1050] = BattleReportSettings.items.scoreboard_header_text[1680][1050] or {
	rect_delimiter_height = 32,
	text_offset_z = 1,
	rect_delimiter_offset_y = 0,
	text_offset_y = 10,
	texture_sort_offset_y = 10,
	texture_sort_height = 12,
	texture_sort_width = 16,
	rect_delimiter_width = 2,
	texture_sort_desc = "sort_descending",
	text_offset_x = 16,
	texture_sort_offset_x = -26,
	font_size = 18,
	rect_delimiter_offset_z = 1,
	rect_delimiter_offset_x = -2,
	texture_sort_asc = "sort_ascending",
	texture_sort_offset_z = 1,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		255,
		255,
		255
	},
	rect_delimiter_color = {
		0,
		0,
		0,
		0
	},
	rect_background_color = {
		255,
		0,
		0,
		0
	}
}
BattleReportSettings.items.scoreboard_header_delimiter = BattleReportSettings.items.scoreboard_header_delimiter or {}
BattleReportSettings.items.scoreboard_header_delimiter[1680] = BattleReportSettings.items.scoreboard_header_delimiter[1680] or {}
BattleReportSettings.items.scoreboard_header_delimiter[1680][1050] = BattleReportSettings.items.scoreboard_header_delimiter[1680][1050] or {
	texture = "tab_gradient_1920",
	padding_bottom = -2,
	padding_left = 0,
	texture_width = 1550,
	padding_top = 0,
	padding_right = 0,
	texture_height = 4,
	color = {
		255,
		255,
		255,
		255
	}
}
BattleReportSettings.items.summary = BattleReportSettings.items.summary or {}
BattleReportSettings.items.summary[1680] = BattleReportSettings.items.summary[1680] or {}
BattleReportSettings.items.summary[1680][1050] = BattleReportSettings.items.summary[1680][1050] or {
	font_size = 18,
	text_offset_y = 8,
	text_offset_x = 16,
	font = MenuSettings.fonts.hell_shark_18,
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
	},
	column_width = {
		440,
		160,
		160,
		160,
		480
	}
}
BattleReportSettings.items.summary_demo = BattleReportSettings.items.summary_demo or {}
BattleReportSettings.items.summary_demo[1680] = BattleReportSettings.items.summary_demo[1680] or {}
BattleReportSettings.items.summary_demo[1680][1050] = BattleReportSettings.items.summary_demo[1680][1050] or table.clone(BattleReportSettings.items.summary[1680][1050])
BattleReportSettings.items.summary_demo[1680][1050].text_color = {
	255,
	255,
	255,
	0
}
BattleReportSettings.items.summary_total = BattleReportSettings.items.summary_total or {}
BattleReportSettings.items.summary_total[1680] = BattleReportSettings.items.summary_total[1680] or {}
BattleReportSettings.items.summary_total[1680][1050] = BattleReportSettings.items.summary_total[1680][1050] or {
	font_size = 18,
	text_offset_y = 8,
	text_offset_x = 16,
	font = MenuSettings.fonts.hell_shark_18,
	text_color = {
		255,
		0,
		0,
		0
	},
	drop_shadow_color = {
		120,
		255,
		255,
		255
	},
	drop_shadow_offset = {
		2,
		-2
	},
	background_color = {
		255,
		170,
		170,
		170
	},
	column_width = {
		440,
		160,
		160,
		160,
		480
	}
}
BattleReportSettings.items.summary_award = BattleReportSettings.items.summary_award or {}
BattleReportSettings.items.summary_award[1680] = BattleReportSettings.items.summary_award[1680] or {}
BattleReportSettings.items.summary_award[1680][1050] = BattleReportSettings.items.summary_award[1680][1050] or {
	amount_text_offset_x = -3,
	font_size = 16,
	texture_atlas_name = "prizes_medals_unlocks_atlas",
	name_text_offset_y = -14,
	amount_text_offset_y = 3,
	texture_width = 128,
	name_text_max_width = 134,
	texture_height = 128,
	texture_atlas_settings = PrizesMedalsUnlocksAtlas,
	font = MenuSettings.fonts.hell_shark_16,
	amount_text_color = {
		255,
		255,
		255,
		255
	},
	amount_text_shadow_color = {
		255,
		100,
		100,
		100
	},
	amount_text_shadow_offset = {
		1,
		-1
	},
	amount_rect_color = {
		255,
		0,
		0,
		0
	},
	name_text_color = {
		255,
		255,
		255,
		255
	}
}
BattleReportSettings.items.summary_award_tooltip = BattleReportSettings.items.summary_award_tooltip or {}
BattleReportSettings.items.summary_award_tooltip[1680] = BattleReportSettings.items.summary_award_tooltip[1680] or {}
BattleReportSettings.items.summary_award_tooltip[1680][1050] = BattleReportSettings.items.summary_award_tooltip[1680][1050] or table.clone(MainMenuSettings.items.floating_tooltip[1680][1050])
BattleReportSettings.pages.base = BattleReportSettings.pages.base or {}
BattleReportSettings.pages.base[1680] = {}
BattleReportSettings.pages.base[1680][1050] = BattleReportSettings.pages.base[1680][1050] or {
	header_items = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = -50,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		items = {
			columns = {
				{
					align = "center"
				}
			},
			rows = {
				{
					align = "center",
					height = 12
				},
				{
					align = "center",
					height = 34
				},
				{
					align = "center",
					height = 12
				},
				{
					align = "bottom",
					height = 105
				}
			}
		}
	},
	page_links = {
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
	},
	background_rect = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		absolute_height = 1000,
		pivot_offset_y = 0,
		screen_align_x = "center",
		absolute_width = 1570,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		color = {
			240,
			50,
			50,
			50
		}
	},
	horizontal_line_texture_top = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		texture = "pink_horror",
		pivot_offset_y = 500,
		texture_width = 1000,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		texture_height = 12
	},
	horizontal_line_texture_bottom = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_bottom_horizontal_line_1920",
		pivot_offset_y = -500,
		texture_width = 1000,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		texture_height = 12
	},
	background_level_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture_callback = "cb_background_texture",
		pivot_offset_y = 0,
		texture_width = 804,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_height = 452
	},
	player_details = {
		num_columns = 4,
		num_rows = 4,
		padding_top = 0.02,
		name_padding_top = 0.02,
		player_name_width = 700,
		player_name_font_size = 60,
		name_padding_left = 0.02,
		row_height = 0.05,
		player_name_font = MenuSettings.fonts.arial_36,
		background_rect_color = {
			192,
			0,
			0,
			0
		},
		columns = {
			{
				size = 0.05,
				align = "right"
			},
			{
				size = 0.3,
				align = "left"
			},
			{
				size = 0.1,
				align = "right"
			},
			{
				size = 0.15,
				align = "left"
			}
		}
	}
}
BattleReportSettings.pages.scoreboard = BattleReportSettings.pages.scoreboard or {}
BattleReportSettings.pages.scoreboard[1680] = {}
BattleReportSettings.pages.scoreboard[1680][1050] = BattleReportSettings.pages.scoreboard[1680][1050] or table.clone(BattleReportSettings.pages.base[1680][1050])
BattleReportSettings.pages.scoreboard[1680][1050].scoreboard = BattleReportSettings.pages.scoreboard[1680][1050].scoreboard or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 144,
	background_min_height = 420,
	screen_align_x = "center",
	number_of_visible_rows = 12,
	pivot_offset_x = -700,
	screen_offset_y = 0,
	pivot_align_x = "left",
	rect_background_color = {
		255,
		30,
		30,
		30
	},
	headers = {
		columns = {
			{
				width = 900,
				align = "left"
			},
			{
				width = 100,
				align = "left"
			},
			{
				width = 100,
				align = "left"
			},
			{
				width = 100,
				align = "left"
			},
			{
				width = 100,
				align = "left"
			},
			{
				width = 100,
				align = "left"
			}
		},
		rows = {
			{
				align = "bottom",
				height = 1
			},
			{
				align = "center",
				height = 32
			},
			{
				align = "bottom",
				height = 1
			}
		}
	},
	items = {
		columns = {
			{
				width = 1400,
				align = "left"
			}
		},
		rows = {
			{
				height = 35,
				align = "bottom",
				odd_color = {
					255,
					40,
					40,
					40
				},
				even_color = {
					255,
					65,
					65,
					65
				}
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "right"
	}
}
BattleReportSettings.pages.scoreboard[1680][1050].button_info = {
	text_data = {
		font_size = 28,
		font = MenuSettings.fonts.hell_shark_28,
		offset_x = 25 * SCALE_1366,
		offset_y = 85 * SCALE_1366,
		drop_shadow = {
			2,
			-2
		}
	},
	default_buttons = {}
}
BattleReportSettings.pages.summary = BattleReportSettings.pages.summary or {}
BattleReportSettings.pages.summary[1680] = BattleReportSettings.pages.summary[1680] or {}
BattleReportSettings.pages.summary[1680][1050] = BattleReportSettings.pages.summary[1680][1050] or table.clone(BattleReportSettings.pages.base[1680][1050])
BattleReportSettings.pages.summary[1680][1050].summary_list = BattleReportSettings.pages.summary[1680][1050].summary_list or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 18,
	screen_align_x = "center",
	pivot_offset_x = -700,
	screen_offset_y = 0,
	pivot_align_x = "left",
	headers = {
		columns = {
			{
				width = 0,
				align = "left"
			},
			{
				width = 440,
				align = "left"
			},
			{
				width = 160,
				align = "left"
			},
			{
				width = 160,
				align = "left"
			},
			{
				width = 360,
				align = "left"
			},
			{
				width = 280,
				align = "left"
			}
		},
		rows = {
			{
				align = "bottom",
				height = 1
			},
			{
				align = "center",
				height = 32
			},
			{
				align = "bottom",
				height = 1
			}
		}
	},
	items = {
		columns = {
			{
				width = 1400,
				align = "left"
			}
		},
		rows = {
			{
				height = 32,
				align = "bottom",
				odd_color = {
					255,
					40,
					40,
					40
				},
				even_color = {
					255,
					65,
					65,
					65
				}
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "right"
	}
}
BattleReportSettings.pages.summary[1680][1050].button_info = {
	text_data = {
		font_size = 28,
		font = MenuSettings.fonts.hell_shark_28,
		offset_x = 180 * SCALE_1366,
		offset_y = 85 * SCALE_1366,
		drop_shadow = {
			2,
			-2
		}
	},
	default_buttons = {
		{
			button_name = "x",
			text = "menu_scoreboard"
		},
		{
			button_name = "a",
			text = "menu_close"
		}
	}
}
BattleReportSettings.pages.summary[1680][1050].award_list = BattleReportSettings.pages.summary[1680][1050].award_list or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 17,
	background_min_height = 640,
	screen_align_x = "center",
	number_of_visible_rows = 4,
	pivot_offset_x = 270,
	screen_offset_y = 0,
	pivot_align_x = "left",
	rect_background_color = {
		255,
		0,
		0,
		0
	},
	items = {
		columns = {
			{
				width = 150,
				align = "center"
			},
			{
				width = 130,
				align = "center"
			},
			{
				width = 150,
				align = "center"
			}
		},
		rows = {
			{
				align = "center",
				height = 158
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "right"
	}
}
BattleReportSettings.pages.summary[1680][1050].xp_progress_bar = BattleReportSettings.pages.summary[1680][1050].xp_progress_bar or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = -380,
	screen_align_x = "center",
	number_of_columns = 1,
	pivot_offset_x = -690,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
