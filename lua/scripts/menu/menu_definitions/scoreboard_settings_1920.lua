-- chunkname: @scripts/menu/menu_definitions/scoreboard_settings_1920.lua

require("scripts/settings/hud_settings")

ScoreboardSettings = ScoreboardSettings or {}
ScoreboardSettings.items = ScoreboardSettings.items or {}
ScoreboardSettings.pages = ScoreboardSettings.pages or {}
ScoreboardSettings.pages.main_page = ScoreboardSettings.pages.main_page or {}
ScoreboardSettings.pages.main_page[1680] = ScoreboardSettings.pages.main_page[1680] or {}
ScoreboardSettings.pages.main_page[1680][1050] = ScoreboardSettings.pages.main_page[1680][1050] or {
	center_items = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = -80,
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
		pivot_align_y = "top",
		pivot_offset_y = 470,
		screen_align_x = "center",
		number_of_columns = 3,
		pivot_offset_x = -110,
		screen_offset_y = 0,
		pivot_align_x = "right",
		column_width = {
			110,
			280,
			170
		},
		column_alignment = {
			"left",
			"left",
			"right"
		}
	},
	left_team_players = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture_background = "scoreboard_bgr_left_1920",
		pivot_offset_y = 300,
		texture_background_width = 572,
		screen_align_x = "center",
		number_of_visible_rows = 12,
		background_min_height = 490,
		pivot_offset_x = -25,
		screen_offset_y = 0,
		pivot_align_x = "right",
		texture_background_align = "right",
		headers = {
			columns = {
				{
					width = 60,
					align = "left"
				},
				{
					width = 290,
					align = "left"
				},
				{
					width = 100,
					align = "left"
				},
				{
					width = 60,
					align = "left"
				},
				{
					width = 100,
					align = "left"
				},
				{
					width = 80,
					align = "left"
				}
			},
			rows = {
				{
					align = "center",
					height = 40
				}
			}
		},
		items = {
			columns = {
				{
					width = 690,
					align = "left"
				}
			},
			rows = {
				{
					align = "center",
					height = 40
				}
			}
		},
		scroll_bar = {
			offset_z = 10,
			align = "left"
		}
	},
	right_team_items = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		pivot_offset_y = 470,
		screen_align_x = "center",
		number_of_columns = 3,
		pivot_offset_x = 110,
		screen_offset_y = 0,
		pivot_align_x = "left",
		column_width = {
			170,
			280,
			110
		},
		column_alignment = {
			"left",
			"right",
			"right"
		}
	},
	right_team_players = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture_background = "scoreboard_bgr_right_1920",
		pivot_offset_y = 300,
		texture_background_width = 572,
		screen_align_x = "center",
		number_of_visible_rows = 12,
		background_min_height = 490,
		pivot_offset_x = 25,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_background_align = "left",
		headers = {
			columns = {
				{
					width = 60,
					align = "left"
				},
				{
					width = 290,
					align = "left"
				},
				{
					width = 100,
					align = "left"
				},
				{
					width = 60,
					align = "left"
				},
				{
					width = 100,
					align = "left"
				},
				{
					width = 80,
					align = "left"
				}
			},
			rows = {
				{
					align = "center",
					height = 40
				}
			}
		},
		items = {
			columns = {
				{
					width = 690,
					align = "left"
				}
			},
			rows = {
				{
					align = "center",
					height = 40
				}
			}
		},
		scroll_bar = {
			offset_z = 10,
			align = "right"
		}
	},
	player_details = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture_background = "scoreboard_player_details_bgr_1920",
		pivot_offset_y = -250,
		texture_background_width = 1400,
		screen_align_x = "center",
		texture_background_align = "left",
		background_min_height = 210,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		background_offset_y = 54,
		headers = {
			columns = {
				{
					width = 200,
					align = "right"
				},
				{
					width = 600,
					align = "left"
				},
				{
					width = 600,
					align = "right"
				}
			},
			rows = {
				{
					align = "center",
					height = 50
				},
				{
					align = "center",
					height = 4
				}
			}
		},
		items = {
			columns = {
				{
					width = 160,
					align = "right"
				},
				{
					width = 250,
					align = "right"
				},
				{
					width = 60,
					align = "left"
				},
				{
					width = 250,
					align = "right"
				},
				{
					width = 60,
					align = "left"
				},
				{
					width = 250,
					align = "right"
				},
				{
					width = 60,
					align = "left"
				},
				{
					width = 250,
					align = "right"
				},
				{
					width = 60,
					align = "left"
				}
			},
			rows = {
				{
					align = "center",
					height = 36
				}
			}
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
		pivot_offset_x = -25,
		screen_offset_y = 0,
		pivot_align_x = "right",
		stretch_width = 750,
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
		pivot_offset_x = -25,
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
		pivot_offset_x = -30,
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
		pivot_offset_x = 25,
		screen_offset_y = 0,
		pivot_align_x = "left",
		stretch_width = 750,
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
		pivot_offset_x = 25,
		screen_offset_y = 0,
		pivot_align_x = "right",
		texture_height = 1016
	},
	right_corner_top_texture = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_align_y = "top",
		texture = "item_list_top_corner_right_1920",
		pivot_offset_y = 0,
		texture_width = 416,
		screen_align_x = "center",
		pivot_offset_x = 30,
		screen_offset_y = 0,
		pivot_align_x = "left",
		texture_height = 308
	}
}
ScoreboardSettings.pages.main_page[1680][1050].do_not_render_buttons = true
ScoreboardSettings.items.left_team_rose = ScoreboardSettings.items.left_team_rose or {}
ScoreboardSettings.items.left_team_rose[1680] = ScoreboardSettings.items.left_team_rose[1680] or {}
ScoreboardSettings.items.left_team_rose[1680][1050] = ScoreboardSettings.items.left_team_rose[1680][1050] or {
	texture_red = "medium_rose_red_1920",
	padding_bottom = -20,
	padding_left = 0,
	texture_width = 108,
	texture_white = "medium_rose_white_1920",
	padding_top = 0,
	padding_right = 0,
	texture_height = 108
}
ScoreboardSettings.items.right_team_rose = ScoreboardSettings.items.right_team_rose or {}
ScoreboardSettings.items.right_team_rose[1680] = ScoreboardSettings.items.right_team_rose[1680] or {}
ScoreboardSettings.items.right_team_rose[1680][1050] = ScoreboardSettings.items.right_team_rose[1680][1050] or {
	texture_red = "medium_rose_red_1920",
	padding_bottom = -20,
	padding_left = 0,
	texture_width = 108,
	texture_white = "medium_rose_white_1920",
	padding_top = 0,
	padding_right = 0,
	texture_height = 108
}
ScoreboardSettings.items.team_score = ScoreboardSettings.items.team_score or {}
ScoreboardSettings.items.team_score[1680] = ScoreboardSettings.items.team_score[1680] or {}
ScoreboardSettings.items.team_score[1680][1050] = ScoreboardSettings.items.team_score[1680][1050] or {
	line_height = 60,
	padding_left = 0,
	padding_right = 0,
	font_size = 150,
	padding_top = 0,
	padding_bottom = 8,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		0
	}
}
ScoreboardSettings.items.team_num_members = ScoreboardSettings.items.team_num_members or {}
ScoreboardSettings.items.team_num_members[1680] = ScoreboardSettings.items.team_num_members[1680] or {}
ScoreboardSettings.items.team_num_members[1680][1050] = ScoreboardSettings.items.team_num_members[1680][1050] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 32,
	padding_top = 14,
	padding_bottom = 0,
	line_height = 21,
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
ScoreboardSettings.items.players_header = ScoreboardSettings.items.players_header or {}
ScoreboardSettings.items.players_header[1680] = ScoreboardSettings.items.players_header[1680] or {}
ScoreboardSettings.items.players_header[1680][1050] = ScoreboardSettings.items.players_header[1680][1050] or {
	padding_left = 0,
	font_size = 32,
	padding_top = 0,
	padding_bottom = -16,
	line_height = 0,
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
ScoreboardSettings.items.players_header_bgr_texture_left = ScoreboardSettings.items.players_header_bgr_texture_left or {}
ScoreboardSettings.items.players_header_bgr_texture_left[1680] = ScoreboardSettings.items.players_header_bgr_texture_left[1680] or {}
ScoreboardSettings.items.players_header_bgr_texture_left[1680][1050] = ScoreboardSettings.items.players_header_bgr_texture_left[1680][1050] or {
	texture_alignment = "right",
	font_size = 32,
	texture_disabled_width = 572,
	texture_offset_x = 26,
	padding_top = 0,
	texture_disabled = "scoreboard_header_bgr_left_1920",
	padding_bottom = -16,
	line_height = 0,
	texture_disabled_height = 40,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
ScoreboardSettings.items.players_header_bgr_texture_right = ScoreboardSettings.items.players_header_bgr_texture_right or {}
ScoreboardSettings.items.players_header_bgr_texture_right[1680] = ScoreboardSettings.items.players_header_bgr_texture_right[1680] or {}
ScoreboardSettings.items.players_header_bgr_texture_right[1680][1050] = ScoreboardSettings.items.players_header_bgr_texture_right[1680][1050] or {
	texture_alignment = "left",
	font_size = 32,
	texture_disabled_width = 572,
	texture_offset_x = -61,
	padding_top = 0,
	texture_disabled = "scoreboard_header_bgr_right_1920",
	padding_bottom = -16,
	line_height = 0,
	texture_disabled_height = 40,
	padding_left = 0,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_32,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
ScoreboardSettings.items.players_scroll_bar = ScoreboardSettings.items.players_scroll_bar or {}
ScoreboardSettings.items.players_scroll_bar[1680] = ScoreboardSettings.items.players_scroll_bar[1680] or {}
ScoreboardSettings.items.players_scroll_bar[1680][1050] = ScoreboardSettings.items.players_scroll_bar[1680][1050] or {
	scroll_bar_handle_width = 6,
	width = 12,
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
ScoreboardSettings.items.player_details_stat = ScoreboardSettings.items.player_details_stat or {}
ScoreboardSettings.items.player_details_stat[1680] = ScoreboardSettings.items.player_details_stat[1680] or {}
ScoreboardSettings.items.player_details_stat[1680][1050] = ScoreboardSettings.items.player_details_stat[1680][1050] or {
	padding_left = 0,
	font_size = 28,
	padding_top = 0,
	padding_bottom = -16,
	line_height = 0,
	padding_right = 10,
	font = MenuSettings.fonts.hell_shark_28,
	color_disabled = {
		255,
		200,
		0,
		0
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
ScoreboardSettings.items.player_details_stat_score = ScoreboardSettings.items.player_details_stat_score or {}
ScoreboardSettings.items.player_details_stat_score[1680] = ScoreboardSettings.items.player_details_stat_score[1680] or {}
ScoreboardSettings.items.player_details_stat_score[1680][1050] = ScoreboardSettings.items.player_details_stat_score[1680][1050] or {
	line_height = 26,
	padding_left = 0,
	padding_right = 40,
	font_size = 36,
	padding_top = 0,
	padding_bottom = 0,
	font = MenuSettings.fonts.wotr_hud_text_36,
	color_disabled = {
		255,
		255,
		255,
		0
	}
}
ScoreboardSettings.items.player_details_delimiter = ScoreboardSettings.items.player_details_delimiter or {}
ScoreboardSettings.items.player_details_delimiter[1680] = ScoreboardSettings.items.player_details_delimiter[1680] or {}
ScoreboardSettings.items.player_details_delimiter[1680][1050] = ScoreboardSettings.items.player_details_delimiter[1680][1050] or {
	texture = "tab_gradient_1920",
	padding_bottom = 0,
	padding_left = 0,
	texture_width = 1550,
	padding_top = 0,
	padding_right = 0,
	texture_height = 4,
	color = {
		255,
		255,
		0,
		0
	}
}
