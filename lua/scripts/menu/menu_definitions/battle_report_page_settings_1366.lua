-- chunkname: @scripts/menu/menu_definitions/battle_report_page_settings_1366.lua

BattleReportSettings = BattleReportSettings or {}
BattleReportSettings.items = BattleReportSettings.items or {}
BattleReportSettings.pages = BattleReportSettings.pages or {}
SCALE_1366 = 0.7114583333333333
BattleReportSettings.items.header = BattleReportSettings.items.header or {}
BattleReportSettings.items.header[1366] = BattleReportSettings.items.header[1366] or {}
BattleReportSettings.items.header[1366][768] = BattleReportSettings.items.header[1366][768] or {
	padding_left = 0,
	font_size = 26,
	padding_top = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_26,
	line_height = 22 * SCALE_1366,
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
BattleReportSettings.items.stat_value[1366] = {}
BattleReportSettings.items.stat_value[1366][768] = BattleReportSettings.items.stat_value[1366][768] or {
	color_callback = "cb_team_color",
	font_size = 16,
	padding_left = 0,
	padding_bottom = 0,
	padding_right = 0,
	padding_top = 10 * SCALE_1366,
	line_height = 22 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16,
	drop_down_color = {
		255,
		0,
		0,
		0
	}
}
BattleReportSettings.items.stat_name = BattleReportSettings.items.stat_name or {}
BattleReportSettings.items.stat_name[1366] = {}
BattleReportSettings.items.stat_name[1366][768] = BattleReportSettings.items.stat_name[1366][768] or {
	font_size = 16,
	padding_bottom = 0,
	padding_right = 0,
	padding_top = 10 * SCALE_1366,
	padding_left = 20 * SCALE_1366,
	line_height = 22 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16,
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
BattleReportSettings.items.scoreboard_header[1366] = {}
BattleReportSettings.items.scoreboard_header[1366][768] = BattleReportSettings.items.scoreboard_header[1366][768] or {
	screen_width = 0.85,
	height = 90,
	viking_texture = "medium_rose_red_1920",
	padding_left = 0,
	padding_top = 0,
	saxon_texture = "medium_rose_white_1920",
	padding_bottom = 0,
	line_height = 22,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	font_size = 60 * SCALE_1366,
	color = {
		160,
		0,
		0,
		0
	},
	texture_size = {
		110,
		110
	},
	left_team_score = {
		font_size = 90,
		padding_x = 10,
		padding_y = -20,
		font = MenuSettings.fonts.font_gradient_100
	},
	right_team_score = {
		font_size = 90,
		padding_x = 10,
		padding_y = -20,
		font = MenuSettings.fonts.font_gradient_100
	}
}
BattleReportSettings.items.scoreboard_left = BattleReportSettings.items.scoreboard_left or {}
BattleReportSettings.items.scoreboard_left[1366] = {}
BattleReportSettings.items.scoreboard_left[1366][768] = BattleReportSettings.items.scoreboard_left[1366][768] or {
	screen_offset_y = -0.21,
	screen_offset_x = 0.075,
	font_size = 60,
	scrollbar_offset_x = 10,
	screen_align_x = "left",
	padding_top = 40,
	padding_left = 0,
	padding_bottom = 0,
	line_height = 22,
	screen_height = 0.4,
	scroller_height = 0.4,
	scroller_width = 3,
	scrollbar_line_width = 1,
	padding_right = 0,
	screen_width = 0.42,
	screen_align_y = "top",
	z = 10,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	pivot_offset_x = 0,
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
			font_size = 18,
			padding_left = 0.08,
			text_func = "cb_team_name",
			padding_top = -30,
			font = MenuSettings.fonts.hell_shark_18
		},
		{
			text = "menu_score_lower",
			padding_top = -30,
			padding_left = 0.47,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_kills_lower",
			padding_top = -30,
			padding_left = 0.55,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_deaths_lower",
			padding_top = -30,
			padding_left = 0.63,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_assist_lower",
			padding_top = -30,
			padding_left = 0.71,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_level_lower",
			padding_top = -30,
			padding_left = 0.83,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			font_size = 20,
			padding_top = -30,
			padding_left = 0.92,
			text_func = "cb_show_ping",
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		}
	}
}
BattleReportSettings.items.scoreboard_right = BattleReportSettings.items.scoreboard_right or {}
BattleReportSettings.items.scoreboard_right[1366] = {}
BattleReportSettings.items.scoreboard_right[1366][768] = BattleReportSettings.items.scoreboard_right[1366][768] or {
	screen_align_x = "right",
	scroller_width = 3,
	scrollbar_line_width = 1,
	scrollbar_offset_x = 10,
	pivot_offset_y = 0,
	padding_top = 40,
	screen_offset_x = -0.075,
	padding_bottom = 0,
	line_height = 22,
	screen_height = 0.4,
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
			font_size = 18,
			padding_left = 0.08,
			text_func = "cb_team_name",
			padding_top = -30,
			font = MenuSettings.fonts.hell_shark_18
		},
		{
			text = "menu_score_lower",
			padding_top = -30,
			padding_left = 0.47,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_kills_lower",
			padding_top = -30,
			padding_left = 0.55,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_deaths_lower",
			padding_top = -30,
			padding_left = 0.63,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_assist_lower",
			padding_top = -30,
			padding_left = 0.71,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			text = "menu_level_lower",
			padding_top = -30,
			padding_left = 0.83,
			font_size = 20,
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		},
		{
			font_size = 20,
			padding_top = -30,
			padding_left = 0.92,
			text_func = "cb_show_ping",
			align = "right",
			font = MenuSettings.fonts.hell_shark_20
		}
	}
}
BattleReportSettings.items.squad_score = BattleReportSettings.items.squad_score or {}
BattleReportSettings.items.squad_score[1366] = {}
BattleReportSettings.items.squad_score[1366][768] = BattleReportSettings.items.squad_score[1366][768] or {
	padding_left = 40,
	item_height = 20,
	font_size = 28,
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
		text_color = {
			255,
			0,
			0,
			0
		},
		items = {
			{
				font_size = 16,
				text_func = "cb_squad_name",
				padding_left = 0.03,
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			},
			{
				text_func = "score",
				padding_top = -30,
				padding_left = 0.468,
				font_size = 16,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			},
			{
				text_func = "cb_squad_kills",
				padding_top = -30,
				padding_left = 0.563,
				font_size = 16,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			},
			{
				text_func = "cb_squad_deaths",
				padding_top = -30,
				padding_left = 0.655,
				font_size = 16,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			},
			{
				text_func = "cb_squad_assists",
				padding_top = -30,
				padding_left = 0.742,
				font_size = 16,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			},
			{
				text_func = "cb_squad_average_level",
				padding_top = -30,
				padding_left = 0.88,
				font_size = 16,
				align = "right",
				padding_bottom = 5,
				font = MenuSettings.fonts.hell_shark_16_masked
			}
		}
	}
}
BattleReportSettings.items.player_score = BattleReportSettings.items.player_score or {}
BattleReportSettings.items.player_score[1366] = {}
BattleReportSettings.items.player_score[1366][768] = BattleReportSettings.items.player_score[1366][768] or {
	font_size = 28,
	item_height = 20,
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
				72,
				20
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
			font_size = 16,
			padding_left = 0.05,
			max_text_width = 125,
			padding_top = 5,
			local_text_color_func = "cb_local_player_color",
			crop_text = true,
			text_func = "cb_player_name",
			font = MenuSettings.fonts.arial_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_score",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_kills",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_deaths",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_assists",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_level",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
			font_size = 16,
			align = "right",
			text_func = "cb_player_ping",
			font = MenuSettings.fonts.hell_shark_16_masked,
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
BattleReportSettings.items.player_option_item[1366] = BattleReportSettings.items.player_option_item[1366] or {}
BattleReportSettings.items.player_option_item[1366][768] = BattleReportSettings.items.player_option_item[1366][768] or {
	highlight_font_size = 20,
	padding_top = 5,
	font_size = 18,
	align = "left",
	line_height = 22,
	padding_bottom = 12,
	padding_right = 0,
	padding_left = 5,
	font = MenuSettings.fonts.hell_shark_18,
	highlight_font = MenuSettings.fonts.hell_shark_20,
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
		1,
		-1
	}
}
BattleReportSettings.pages.player_options_drop_down_list = BattleReportSettings.pages.player_options_drop_down_list or {}
BattleReportSettings.pages.player_options_drop_down_list[1366] = BattleReportSettings.pages.player_options_drop_down_list[1366] or {}
BattleReportSettings.pages.player_options_drop_down_list[1366][768] = BattleReportSettings.pages.player_options_drop_down_list[1366][768] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
BattleReportSettings.pages.player_options_drop_down_list[1366][768].drop_down_list = {
	list_alignment = "left",
	offset_x = 2,
	border_thickness = 2,
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
				width = 110,
				align = "left"
			}
		},
		rows = {
			{
				align = "center",
				height = 22
			}
		}
	}
}
BattleReportSettings.items.server_name = BattleReportSettings.items.server_name or {}
BattleReportSettings.items.server_name[1366] = {}
BattleReportSettings.items.server_name[1366][768] = BattleReportSettings.items.server_name[1366][768] or {
	padding_left = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	font_size = 40 * SCALE_1366,
	line_height = 22 * SCALE_1366,
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
	padding_top = 40 * SCALE_1366
}
BattleReportSettings.items.game_mode_name = BattleReportSettings.items.game_mode_name or {}
BattleReportSettings.items.game_mode_name[1366] = {}
BattleReportSettings.items.game_mode_name[1366][768] = BattleReportSettings.items.game_mode_name[1366][768] or {
	padding_left = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	font_size = 40 * SCALE_1366,
	line_height = 22 * SCALE_1366,
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
	padding_top = 100 * SCALE_1366
}
BattleReportSettings.items.countdown = BattleReportSettings.items.countdown or {}
BattleReportSettings.items.countdown[1366] = BattleReportSettings.items.countdown[1366] or {}
BattleReportSettings.items.countdown[1366][768] = BattleReportSettings.items.countdown[1366][768] or {
	texture_disabled = "countdown_background_1920",
	texture_alignment = "center",
	padding_left = 0,
	font_size = 16,
	padding_top = 0,
	padding_bottom = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_16,
	line_height = 14 * SCALE_1366,
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
	texture_disabled_width = 508 * SCALE_1366,
	texture_disabled_height = 32 * SCALE_1366
}
BattleReportSettings.items.scoreboard_header_text = BattleReportSettings.items.scoreboard_header_text or {}
BattleReportSettings.items.scoreboard_header_text[1366] = BattleReportSettings.items.scoreboard_header_text[1366] or {}
BattleReportSettings.items.scoreboard_header_text[1366][768] = BattleReportSettings.items.scoreboard_header_text[1366][768] or {
	text_offset_z = 1,
	rect_delimiter_offset_y = 0,
	rect_delimiter_width = 2,
	texture_sort_desc = "sort_descending",
	font_size = 13,
	rect_delimiter_offset_z = 1,
	rect_delimiter_offset_x = -2,
	texture_sort_asc = "sort_ascending",
	texture_sort_offset_z = 1,
	font = MenuSettings.fonts.hell_shark_13,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_offset_x = 16 * SCALE_1366,
	text_offset_y = 10 * SCALE_1366,
	rect_delimiter_color = {
		0,
		0,
		0,
		0
	},
	rect_delimiter_height = 32 * SCALE_1366,
	texture_sort_width = 16 * SCALE_1366,
	texture_sort_height = 12 * SCALE_1366,
	texture_sort_offset_x = -26 * SCALE_1366,
	texture_sort_offset_y = 10 * SCALE_1366,
	rect_background_color = {
		255,
		0,
		0,
		0
	}
}
BattleReportSettings.items.scoreboard_header_delimiter = BattleReportSettings.items.scoreboard_header_delimiter or {}
BattleReportSettings.items.scoreboard_header_delimiter[1366] = BattleReportSettings.items.scoreboard_header_delimiter[1366] or {}
BattleReportSettings.items.scoreboard_header_delimiter[1366][768] = BattleReportSettings.items.scoreboard_header_delimiter[1366][768] or {
	texture = "tab_gradient_1920",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	texture_width = 1550 * SCALE_1366,
	texture_height = 4 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	},
	padding_bottom = -2 * SCALE_1366
}
BattleReportSettings.items.summary = BattleReportSettings.items.summary or {}
BattleReportSettings.items.summary[1366] = BattleReportSettings.items.summary[1366] or {}
BattleReportSettings.items.summary[1366][768] = BattleReportSettings.items.summary[1366][768] or {
	font_size = 13,
	font = MenuSettings.fonts.hell_shark_13,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_offset_x = 16 * SCALE_1366,
	text_offset_y = 8 * SCALE_1366,
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
		440 * SCALE_1366,
		160 * SCALE_1366,
		160 * SCALE_1366,
		160 * SCALE_1366,
		480 * SCALE_1366
	}
}
BattleReportSettings.items.summary_demo = BattleReportSettings.items.summary_demo or {}
BattleReportSettings.items.summary_demo[1366] = BattleReportSettings.items.summary_demo[1366] or {}
BattleReportSettings.items.summary_demo[1366][768] = BattleReportSettings.items.summary_demo[1366][768] or table.clone(BattleReportSettings.items.summary[1366][768])
BattleReportSettings.items.summary_demo[1366][768].text_color = {
	255,
	255,
	255,
	0
}
BattleReportSettings.items.summary_total = BattleReportSettings.items.summary_total or {}
BattleReportSettings.items.summary_total[1366] = BattleReportSettings.items.summary_total[1366] or {}
BattleReportSettings.items.summary_total[1366][768] = BattleReportSettings.items.summary_total[1366][768] or {
	font_size = 13,
	font = MenuSettings.fonts.hell_shark_13,
	text_color = {
		255,
		0,
		0,
		0
	},
	text_offset_x = 16 * SCALE_1366,
	text_offset_y = 8 * SCALE_1366,
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
		440 * SCALE_1366,
		160 * SCALE_1366,
		160 * SCALE_1366,
		160 * SCALE_1366,
		480 * SCALE_1366
	}
}
BattleReportSettings.items.summary_award = BattleReportSettings.items.summary_award or {}
BattleReportSettings.items.summary_award[1366] = BattleReportSettings.items.summary_award[1366] or {}
BattleReportSettings.items.summary_award[1366][768] = BattleReportSettings.items.summary_award[1366][768] or {
	amount_text_offset_x = -2,
	font_size = 11,
	texture_atlas_name = "prizes_medals_unlocks_atlas",
	name_text_offset_y = -10,
	amount_text_offset_y = 2,
	name_text_max_width = 96,
	texture_width = 128 * SCALE_1366,
	texture_height = 128 * SCALE_1366,
	texture_atlas_settings = PrizesMedalsUnlocksAtlas,
	font = MenuSettings.fonts.hell_shark_11,
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
BattleReportSettings.items.summary_award_tooltip[1366] = BattleReportSettings.items.summary_award_tooltip[1366] or {}
BattleReportSettings.items.summary_award_tooltip[1366][768] = BattleReportSettings.items.summary_award_tooltip[1366][768] or table.clone(MainMenuSettings.items.floating_tooltip[1366][768])
BattleReportSettings.pages.base = BattleReportSettings.pages.base or {}
BattleReportSettings.pages.base[1366] = {}
BattleReportSettings.pages.base[1366][768] = {
	header_items = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = -30,
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
					height = 12 * SCALE_1366
				},
				{
					align = "center",
					height = 34 * SCALE_1366
				},
				{
					align = "center",
					height = 12 * SCALE_1366
				},
				{
					align = "bottom",
					height = 105 * SCALE_1366
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
		pivot_offset_y = 0,
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		absolute_width = 1570 * SCALE_1366,
		absolute_height = 1000 * SCALE_1366,
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
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_offset_y = 500 * SCALE_1366,
		texture_width = 1000 * SCALE_1366,
		texture_height = 12 * SCALE_1366
	},
	horizontal_line_texture_bottom = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_bottom_horizontal_line_1920",
		screen_align_x = "center",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_offset_y = -500 * SCALE_1366,
		texture_width = 1000 * SCALE_1366,
		texture_height = 12 * SCALE_1366
	},
	background_level_texture = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		texture_callback = "cb_background_texture",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_width = 804 * SCALE_1366,
		texture_height = 452 * SCALE_1366
	},
	player_details = {
		num_columns = 4,
		num_rows = 4,
		padding_top = 0.02,
		name_padding_top = 0.02,
		player_name_width = 500,
		player_name_font_size = 40,
		name_padding_left = 0.02,
		row_height = 0.045,
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
BattleReportSettings.pages.scoreboard[1366] = {}
BattleReportSettings.pages.scoreboard[1366][768] = BattleReportSettings.pages.scoreboard[1366][768] or table.clone(BattleReportSettings.pages.base[1366][768])
BattleReportSettings.pages.scoreboard[1366][768].scoreboard = BattleReportSettings.pages.scoreboard[1366][768].scoreboard or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "center",
	screen_align_x = "center",
	number_of_visible_rows = 12,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_offset_x = -700 * SCALE_1366,
	pivot_offset_y = 144 * SCALE_1366,
	rect_background_color = {
		255,
		30,
		30,
		30
	},
	background_min_height = 420 * SCALE_1366,
	headers = {
		columns = {
			{
				align = "left",
				width = 900 * SCALE_1366
			},
			{
				align = "left",
				width = 100 * SCALE_1366
			},
			{
				align = "left",
				width = 100 * SCALE_1366
			},
			{
				align = "left",
				width = 100 * SCALE_1366
			},
			{
				align = "left",
				width = 100 * SCALE_1366
			},
			{
				align = "left",
				width = 100 * SCALE_1366
			}
		},
		rows = {
			{
				align = "bottom",
				height = 1
			},
			{
				align = "center",
				height = 32 * SCALE_1366
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
				align = "left",
				width = 1400 * SCALE_1366
			}
		},
		rows = {
			{
				align = "bottom",
				height = 35 * SCALE_1366,
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
BattleReportSettings.pages.scoreboard[1366][768].button_info = {
	text_data = {
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		offset_x = 25 * SCALE_1366,
		offset_y = 85 * SCALE_1366,
		drop_shadow = {
			1,
			-1
		}
	},
	default_buttons = {}
}
BattleReportSettings.pages.summary = BattleReportSettings.pages.summary or {}
BattleReportSettings.pages.summary[1366] = BattleReportSettings.pages.summary[1366] or {}
BattleReportSettings.pages.summary[1366][768] = BattleReportSettings.pages.summary[1366][768] or table.clone(BattleReportSettings.pages.base[1366][768])
BattleReportSettings.pages.summary[1366][768].summary_list = BattleReportSettings.pages.summary[1366][768].summary_list or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	screen_align_x = "center",
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_offset_x = -700 * SCALE_1366,
	pivot_offset_y = 18 * SCALE_1366,
	headers = {
		columns = {
			{
				width = 0,
				align = "left"
			},
			{
				align = "left",
				width = 440 * SCALE_1366
			},
			{
				align = "left",
				width = 160 * SCALE_1366
			},
			{
				align = "left",
				width = 160 * SCALE_1366
			},
			{
				align = "left",
				width = 360 * SCALE_1366
			},
			{
				align = "left",
				width = 280 * SCALE_1366
			}
		},
		rows = {
			{
				align = "bottom",
				height = 1
			},
			{
				align = "center",
				height = 32 * SCALE_1366
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
				align = "left",
				width = 1400 * SCALE_1366
			}
		},
		rows = {
			{
				align = "bottom",
				height = 32 * SCALE_1366,
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
BattleReportSettings.pages.summary[1366][768].button_info = {
	text_data = {
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		offset_x = 180 * SCALE_1366,
		offset_y = 85 * SCALE_1366,
		drop_shadow = {
			1,
			-1
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
BattleReportSettings.pages.summary[1366][768].award_list = BattleReportSettings.pages.summary[1366][768].award_list or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	screen_align_x = "center",
	number_of_visible_rows = 4,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_offset_x = 270 * SCALE_1366,
	pivot_offset_y = 17 * SCALE_1366,
	rect_background_color = {
		255,
		0,
		0,
		0
	},
	background_min_height = 640 * SCALE_1366,
	items = {
		columns = {
			{
				align = "center",
				width = 150 * SCALE_1366
			},
			{
				align = "center",
				width = 130 * SCALE_1366
			},
			{
				align = "center",
				width = 150 * SCALE_1366
			}
		},
		rows = {
			{
				align = "center",
				height = 158 * SCALE_1366
			}
		}
	},
	scroll_bar = {
		offset_z = 10,
		align = "right"
	}
}
BattleReportSettings.pages.summary[1366][768].xp_progress_bar = BattleReportSettings.pages.summary[1366][768].xp_progress_bar or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	screen_align_x = "center",
	number_of_columns = 1,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_offset_x = -690 * SCALE_1366,
	pivot_offset_y = -380 * SCALE_1366,
	column_alignment = {
		"center"
	}
}
