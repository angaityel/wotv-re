-- chunkname: @scripts/menu/menu_definitions/squad_menu_settings_1920.lua

require("scripts/menu/menu_definitions/final_scoreboard_menu_settings_1920")
require("scripts/settings/menu_settings")

SquadMenuSettings = SquadMenuSettings or {}
SquadMenuSettings.items = SquadMenuSettings.items or {}
SquadMenuSettings.pages = SquadMenuSettings.pages or {}
SquadMenuSettings.items.spawn_map = SquadMenuSettings.items.spawn_map or {}
SquadMenuSettings.items.spawn_map[1680] = SquadMenuSettings.items.spawn_map[1680] or {}
SquadMenuSettings.items.spawn_map[1680][1050] = SquadMenuSettings.items.spawn_map[1680][1050] or {
	height = 512,
	width = 512,
	color = {
		255,
		64,
		128,
		255
	}
}
SquadMenuSettings.items.local_player_marker = SquadMenuSettings.items.local_player_marker or {}
SquadMenuSettings.items.local_player_marker[1680] = SquadMenuSettings.items.local_player_marker[1680] or {}
SquadMenuSettings.items.local_player_marker[1680][1050] = SquadMenuSettings.items.local_player_marker[1680][1050] or {
	texture = "map_icon_local_player",
	texture_height = 12,
	texture_width = 12
}
SquadMenuSettings.items.spawn_area_marker = SquadMenuSettings.items.spawn_area_marker or {}
SquadMenuSettings.items.spawn_area_marker[1680] = SquadMenuSettings.items.spawn_area_marker[1680] or {}
SquadMenuSettings.items.spawn_area_marker[1680][1050] = SquadMenuSettings.items.spawn_area_marker[1680][1050] or {
	spawn_target_texture = "map_icon_spawn_target",
	spawn_area_texture_width = 40,
	spawn_area_texture_highlighted = "map_icon_spawn_area_highlighted",
	spawn_target_texture_height = 40,
	spawn_area_texture_height = 40,
	spawn_target_anim_speed = 1.5,
	spawn_target_texture_width = 40,
	spawn_target_offset_y = 14,
	spawn_target_anim_amplitude = 8,
	spawn_area_texture = "map_icon_spawn_area"
}
SquadMenuSettings.items.squad_marker = SquadMenuSettings.items.squad_marker or {}
SquadMenuSettings.items.squad_marker[1680] = SquadMenuSettings.items.squad_marker[1680] or {}
SquadMenuSettings.items.squad_marker[1680][1050] = SquadMenuSettings.items.squad_marker[1680][1050] or {
	squad_textures_width = 28,
	squad_textures_height = 28,
	spawn_target_texture = "map_icon_spawn_target",
	spawn_target_texture_height = 40,
	spawn_target_anim_speed = 1.5,
	spawn_target_texture_width = 40,
	spawn_target_offset_y = 20,
	spawn_target_anim_amplitude = 8,
	squad_member = {
		texture = "map_icon_squad_member",
		texture_highlighted = "map_icon_squad_member_highlighted",
		texture_disabled = "map_icon_squad_member_disabled"
	},
	squad_corporal = {
		texture = "map_icon_squad_corporal",
		texture_highlighted = "map_icon_squad_corporal_highlighted",
		texture_disabled = "map_icon_squad_corporal_disabled"
	}
}
SquadMenuSettings.items.squad_join_button = SquadMenuSettings.items.squad_join_button or {}
SquadMenuSettings.items.squad_join_button[1680] = SquadMenuSettings.items.squad_join_button[1680] or {}
SquadMenuSettings.items.squad_join_button[1680][1050] = SquadMenuSettings.items.squad_join_button[1680][1050] or {
	texture_left = "small_button_left_1920",
	texture_left_highlighted = "small_button_left_highlighted_1920",
	text_offset_y = 8,
	texture_right_highlighted = "small_button_right_highlighted_1920",
	padding_bottom = 13,
	padding_top = 19,
	texture_middle_highlighted = "small_button_center_highlighted_1920",
	texture_left_width = 8,
	padding_right = 0,
	texture_height = 32,
	text_padding = 4,
	padding_left = 20,
	texture_right = "small_button_right_1920",
	font_size = 26,
	texture_middle = "small_button_center_1920",
	texture_right_width = 8,
	font = MenuSettings.fonts.hell_shark_26,
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
SquadMenuSettings.items.page_link = SquadMenuSettings.items.page_link or {}
SquadMenuSettings.items.page_link[1680] = SquadMenuSettings.items.page_link[1680] or {}
SquadMenuSettings.items.page_link[1680][1050] = SquadMenuSettings.items.page_link[1680][1050] or {
	padding_left = 0,
	font_size = 32,
	padding_top = 12,
	padding_bottom = 12,
	line_height = 21,
	padding_right = 20,
	font = MenuSettings.fonts.hell_shark_32,
	color = {
		255,
		0,
		0,
		0
	},
	color_highlighted = {
		255,
		0,
		0,
		0
	},
	color_disabled = {
		0,
		110,
		110,
		110
	}
}
SquadMenuSettings.items.next_button = SquadMenuSettings.items.next_button or {}
SquadMenuSettings.items.next_button[1680] = SquadMenuSettings.items.next_button[1680] or {}
SquadMenuSettings.items.next_button[1680][1050] = SquadMenuSettings.items.next_button[1680][1050] or {
	texture_left = "shiny_button_left_end_1920",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1920",
	text_offset_y = 22,
	texture_right_highlighted = "shiny_button_right_tip_highlighted_1920",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1920",
	texture_left_width = 24,
	padding_right = 20,
	texture_height = 60,
	text_padding = 0,
	padding_left = 20,
	texture_right = "shiny_button_right_tip_1920",
	font_size = 26,
	texture_middle = "shiny_button_center_1920",
	texture_right_width = 32,
	font = MenuSettings.fonts.hell_shark_26,
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
		40,
		40,
		40
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
SquadMenuSettings.items.previous_button = SquadMenuSettings.items.previous_button or {}
SquadMenuSettings.items.previous_button[1680] = SquadMenuSettings.items.previous_button[1680] or {}
SquadMenuSettings.items.previous_button[1680][1050] = SquadMenuSettings.items.previous_button[1680][1050] or {
	texture_left = "shiny_button_left_tip_1920",
	texture_left_highlighted = "shiny_button_left_tip_highlighted_1920",
	text_offset_y = 22,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1920",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1920",
	texture_left_width = 32,
	padding_right = 20,
	texture_height = 60,
	text_padding = 0,
	padding_left = 20,
	texture_right = "shiny_button_right_end_1920",
	font_size = 26,
	texture_middle = "shiny_button_center_1920",
	texture_right_width = 24,
	font = MenuSettings.fonts.hell_shark_26,
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
		40,
		40,
		40
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
SquadMenuSettings.items.centered_button = SquadMenuSettings.items.centered_button or {}
SquadMenuSettings.items.centered_button[1680] = SquadMenuSettings.items.centered_button[1680] or {}
SquadMenuSettings.items.centered_button[1680][1050] = SquadMenuSettings.items.centered_button[1680][1050] or {
	texture_left = "shiny_button_left_end_1920",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1920",
	text_offset_y = 22,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1920",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1920",
	texture_left_width = 24,
	padding_right = 20,
	texture_height = 60,
	text_padding = 0,
	padding_left = 20,
	texture_right = "shiny_button_right_end_1920",
	font_size = 26,
	texture_middle = "shiny_button_center_1920",
	texture_right_width = 24,
	font = MenuSettings.fonts.hell_shark_26,
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
SquadMenuSettings.items.quote_text = SquadMenuSettings.items.quote_text or {}
SquadMenuSettings.items.quote_text[1680] = SquadMenuSettings.items.quote_text[1680] or {}
SquadMenuSettings.items.quote_text[1680][1050] = SquadMenuSettings.items.quote_text[1680][1050] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 22,
	padding_top = 40,
	text_align = "left",
	padding_bottom = 40,
	line_height = 32,
	width = 440,
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
SquadMenuSettings.items.red_team_rose = SquadMenuSettings.items.red_team_rose or {}
SquadMenuSettings.items.red_team_rose[1680] = SquadMenuSettings.items.red_team_rose[1680] or {}
SquadMenuSettings.items.red_team_rose[1680][1050] = SquadMenuSettings.items.red_team_rose[1680][1050] or {
	texture_highlighted = "team_selection_highlighted_viking",
	texture_highlighted_height = 532,
	texture_disabled_offset_y = 150,
	texture_disabled_width = 184,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = -22,
	texture_disabled_height = 184,
	texture_width = 444,
	padding_right = 0,
	texture_height = 488,
	texture = "big_rose_red",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = -44,
	padding_left = 0,
	texture_disabled_offset_x = 136,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 532,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.white_team_rose = SquadMenuSettings.items.white_team_rose or {}
SquadMenuSettings.items.white_team_rose[1680] = SquadMenuSettings.items.white_team_rose[1680] or {}
SquadMenuSettings.items.white_team_rose[1680][1050] = SquadMenuSettings.items.white_team_rose[1680][1050] or {
	texture_highlighted = "team_selection_highlighted_saxon",
	texture_highlighted_height = 532,
	texture_disabled_offset_y = 156,
	texture_disabled_width = 184,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = -22,
	texture_disabled_height = 184,
	texture_width = 444,
	padding_right = 0,
	texture_height = 488,
	texture = "big_rose_white",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = -44,
	padding_left = 0,
	texture_disabled_offset_x = 140,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 532,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.wotv_viking_team = SquadMenuSettings.items.wotv_viking_team or {}
SquadMenuSettings.items.wotv_viking_team[1680] = {}
SquadMenuSettings.items.wotv_viking_team[1680][1050] = SquadMenuSettings.items.wotv_viking_team[1680][1050] or {
	texture_highlighted = "team_selection_highlighted_viking",
	texture_highlighted_height = 425.6,
	texture_disabled_offset_y = 128,
	texture_disabled_width = 147.20000000000002,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = 0,
	texture_disabled_height = 147.20000000000002,
	texture_width = 425.6,
	padding_right = 0,
	texture_height = 425.6,
	texture = "big_rose_red",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = 0,
	padding_left = 0,
	texture_disabled_offset_x = 136,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 425.6,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.wotv_saxon_team = SquadMenuSettings.items.wotv_saxon_team or {}
SquadMenuSettings.items.wotv_saxon_team[1680] = {}
SquadMenuSettings.items.wotv_saxon_team[1680][1050] = SquadMenuSettings.items.wotv_saxon_team[1680][1050] or {
	texture_highlighted = "team_selection_highlighted_saxon",
	texture_highlighted_height = 425.6,
	texture_disabled_offset_y = 128,
	texture_disabled_width = 147.20000000000002,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = 0,
	texture_disabled_height = 147.20000000000002,
	texture_width = 425.6,
	padding_right = 0,
	texture_height = 425.6,
	texture = "big_rose_white",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = 0,
	padding_left = -50,
	texture_disabled_offset_x = 136,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 425.6,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.red_team_text = SquadMenuSettings.items.red_team_text or {}
SquadMenuSettings.items.red_team_text[1680] = {}
SquadMenuSettings.items.red_team_text[1680][1050] = SquadMenuSettings.items.red_team_text[1680][1050] or {
	padding_left = 0,
	font_size = 50,
	padding_top = 40,
	padding_bottom = 40,
	line_height = 21,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	color = {
		255,
		87,
		163,
		199
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
SquadMenuSettings.items.white_team_text = SquadMenuSettings.items.white_team_text or {}
SquadMenuSettings.items.white_team_text[1680] = {}
SquadMenuSettings.items.white_team_text[1680][1050] = SquadMenuSettings.items.white_team_text[1680][1050] or {
	padding_left = 0,
	font_size = 50,
	padding_top = 40,
	padding_bottom = 40,
	line_height = 21,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
	color = {
		255,
		255,
		128,
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
SquadMenuSettings.items.red_team_num_players = SquadMenuSettings.items.red_team_num_players or {}
SquadMenuSettings.items.red_team_num_players[1680] = {}
SquadMenuSettings.items.red_team_num_players[1680][1050] = SquadMenuSettings.items.red_team_num_players[1680][1050] or {
	padding_left = 0,
	font_size = 60,
	padding_top = 0,
	padding_bottom = 0,
	line_height = 21,
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
SquadMenuSettings.items.white_team_num_players = SquadMenuSettings.items.white_team_num_players or {}
SquadMenuSettings.items.white_team_num_players[1680] = {}
SquadMenuSettings.items.white_team_num_players[1680][1050] = SquadMenuSettings.items.white_team_num_players[1680][1050] or {
	padding_left = 0,
	font_size = 60,
	padding_top = 0,
	padding_bottom = 0,
	line_height = 21,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_36,
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
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.pages.select_team = SquadMenuSettings.pages.select_team or {}
SquadMenuSettings.pages.select_team[1680] = {}
SquadMenuSettings.pages.select_team[1680][1050] = SquadMenuSettings.pages.select_team[1680][1050] or table.clone(FinalScoreboardMenuSettings.pages.main_page[1680][1050])
SquadMenuSettings.pages.select_team[1680][1050].back_list = table.clone(MainMenuSettings.pages.level_2[1680][1050].back_list)
SquadMenuSettings.pages.select_team[1680][1050].back_list.number_of_columns = 2
SquadMenuSettings.pages.select_team[1680][1050].page_links = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 5,
	screen_align_x = "right",
	number_of_columns = 2,
	pivot_offset_x = -40,
	screen_offset_y = 0,
	pivot_align_x = "right",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].back_list = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 5,
	screen_align_x = "left",
	number_of_columns = 2,
	pivot_offset_x = 40,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].left_team_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 100,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 90,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].right_team_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 100,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 480,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].center_items = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 480,
	screen_offset_y = -0.07,
	pivot_align_x = "left",
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].auto_join_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 380,
	screen_offset_y = -0.24,
	pivot_align_x = "left",
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].red_players = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 800,
	screen_offset_y = -0.17,
	pivot_align_x = "right",
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].white_players = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1920,
	pivot_offset_x = 50,
	screen_offset_y = -0.17,
	pivot_align_x = "left",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_team[1680][1050].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_team[1680][1050].button_info = {
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
			button_name = "d_pad",
			text = "main_menu_move"
		},
		{
			button_name = "x",
			text = "menu_auto_join_team"
		},
		{
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "back",
			text = "menu_ingame_leave_battle_lower"
		}
	}
}
SquadMenuSettings.pages.select_squad = SquadMenuSettings.pages.select_squad or {}
SquadMenuSettings.pages.select_squad[1680] = {}
SquadMenuSettings.pages.select_squad[1680][1050] = SquadMenuSettings.pages.select_squad[1680][1050] or table.clone(FinalScoreboardMenuSettings.pages.main_page[1680][1050])
SquadMenuSettings.pages.select_squad[1680][1050].back_list = table.clone(MainMenuSettings.pages.level_2[1680][1050].back_list)
SquadMenuSettings.pages.select_squad[1680][1050].back_list.number_of_columns = 2
SquadMenuSettings.pages.select_squad[1680][1050].page_links = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 0,
	screen_align_x = "right",
	number_of_columns = 2,
	pivot_offset_x = -40,
	screen_offset_y = 0,
	pivot_align_x = "right",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_squad[1680][1050].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1680][1050].prev_link = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_align_y = "bottom",
	screen_align_x = "left",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1680][1050].next_link = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	pivot_align_y = "bottom",
	screen_align_x = "right",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1680][1050].header_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 220
}
SquadMenuSettings.pages.select_squad[1680][1050].menu_items = {
	spacing_y = 20,
	screen_offset_x = 0,
	align = "right",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	num_columns = 2,
	spacing_x = 20,
	max_shown_items = 6,
	screen_align_y = "center",
	pivot_offset_y = -80,
	render_mask = true,
	using_container = true,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	rect = {
		color = {
			90,
			0,
			0,
			0
		}
	},
	border = {
		thickness = 3,
		color = {
			120,
			0,
			0,
			0
		}
	}
}
SquadMenuSettings.pages.select_squad[1680][1050].button_info = {
	text_data = {
		font_size = 16,
		offset_x = 25,
		offset_y = 100,
		font = MenuSettings.fonts.hell_shark_16,
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
			button_name = "x",
			text = "menu_auto_join_team"
		},
		{
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "back",
			text = "menu_ingame_leave_battle_lower"
		}
	}
}
SquadMenuSettings.pages.select_squad[1680][1050].auto_join_items = {
	screen_align_y = "center",
	screen_offset_x = 0.185,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	pivot_offset_x = 0,
	screen_offset_y = -0.14,
	pivot_align_x = "left",
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.items.choose_side = SquadMenuSettings.items.choose_side or {}
SquadMenuSettings.items.choose_side[1680] = {}
SquadMenuSettings.items.choose_side[1680][1050] = SquadMenuSettings.items.choose_side[1680][1050] or {
	padding_left = 0,
	font_size = 60,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0,
	line_height = 25,
	expand_on_highlight = true,
	font = MenuSettings.fonts.font_gradient_100,
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
		255,
		255,
		255,
		255
	},
	color_render_from_child_page = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.items.auto_join = SquadMenuSettings.items.auto_join or {}
SquadMenuSettings.items.auto_join[1680] = {}
SquadMenuSettings.items.auto_join[1680][1050] = SquadMenuSettings.items.auto_join[1680][1050] or {
	texture = "autojoin",
	texture_highlighted = "autojoin_lit",
	texture_atlas = "menu_assets",
	texture_disabled = "autojoin",
	padding_left = 0,
	padding_top = 0,
	padding_bottom = 0,
	padding_right = 0,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.centered_text = SquadMenuSettings.items.centered_text or {}
SquadMenuSettings.items.centered_text[1680] = {}
SquadMenuSettings.items.centered_text[1680][1050] = SquadMenuSettings.items.centered_text[1680][1050] or {
	padding_left = 150,
	font_size = 36,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0,
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
	disabled_color = {
		255,
		255,
		255,
		255
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
SquadMenuSettings.items.player_text = SquadMenuSettings.items.player_text or {}
SquadMenuSettings.items.player_text[1680] = {}
SquadMenuSettings.items.player_text[1680][1050] = SquadMenuSettings.items.player_text[1680][1050] or {
	padding_left = 150,
	font_size = 20,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0,
	line_height = 25,
	expand_on_highlight = true,
	align = "left",
	font = MenuSettings.fonts.hell_shark_20,
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
		255,
		255,
		255,
		255
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
SquadMenuSettings.items.player_text_friend = SquadMenuSettings.items.player_text_friend or {}
SquadMenuSettings.items.player_text_friend[1680] = {}
SquadMenuSettings.items.player_text_friend[1680][1050] = SquadMenuSettings.items.player_text_friend[1680][1050] or {
	padding_left = 150,
	font_size = 20,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0,
	line_height = 25,
	expand_on_highlight = true,
	align = "left",
	font = MenuSettings.fonts.hell_shark_20,
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
		255,
		0,
		255,
		0
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
SquadMenuSettings.items.player_text_header = SquadMenuSettings.items.player_text_header or {}
SquadMenuSettings.items.player_text_header[1680] = {}
SquadMenuSettings.items.player_text_header[1680][1050] = SquadMenuSettings.items.player_text_header[1680][1050] or {
	font_size = 24,
	line_height = 25,
	align = "left",
	padding_top = 0,
	padding_bottom = 5,
	disabled_color_func = "cb_team_color",
	padding_right = 0,
	padding_left = 150,
	expand_on_highlight = true,
	font = MenuSettings.fonts.hell_shark_24,
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
		255,
		255,
		255,
		255
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
SquadMenuSettings.pages.select_spawnpoint = SquadMenuSettings.pages.select_spawnpoint or {}
SquadMenuSettings.pages.select_spawnpoint[1680] = SquadMenuSettings.pages.select_spawnpoint[1680] or {}
SquadMenuSettings.pages.select_spawnpoint[1680][1050] = SquadMenuSettings.pages.select_spawnpoint[1680][1050] or table.clone(MainMenuSettings.pages.level_3[1680][1050])
SquadMenuSettings.pages.select_spawnpoint[1680][1050].center_items = table.clone(FinalScoreboardMenuSettings.pages.main_page[1680][1050].center_items)
SquadMenuSettings.pages.select_spawnpoint[1680][1050].center_items.pivot_offset_y = 0
SquadMenuSettings.pages.select_spawnpoint[1680][1050].squad_header = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 60,
	screen_align_x = "left",
	pivot_offset_x = 540,
	screen_offset_y = -0.25,
	pivot_align_x = "right",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1680][1050].squad_info = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	pivot_offset_x = 540,
	screen_offset_y = -0.25,
	pivot_align_x = "right",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1680][1050].squad_button = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 3,
	screen_align_x = "left",
	pivot_offset_x = 490,
	screen_offset_y = -0.25,
	pivot_align_x = "center",
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1680][1050].page_links = table.clone(SquadMenuSettings.pages.select_team[1680][1050].page_links)
SquadMenuSettings.pages.select_spawnpoint[1680][1050].page_links.number_of_columns = 2
SquadMenuSettings.pages.select_spawnpoint[1680][1050].spawnpoint = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "right",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	background = {
		texture = "right_info_bgr_1920",
		texture_height = 860,
		texture_width = 700
	},
	map = {
		offset_x = 20,
		offset_y = 226
	},
	objectives_header = {
		font_size = 22,
		text_offset_y = 194,
		text_offset_x = 22,
		font = MenuSettings.fonts.hell_shark_22,
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
	objectives_description = {
		offset_x = 20,
		offset_y = 190,
		font_size = 16,
		text_align = "left",
		line_height = 18,
		width = 580,
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
		}
	},
	level_header = {
		font_size = 22,
		text_offset_y = -36,
		text_offset_x = 22,
		font = MenuSettings.fonts.hell_shark_22,
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
	level_description = {
		offset_x = 20,
		offset_y = -38,
		font_size = 16,
		text_align = "left",
		line_height = 18,
		width = 580,
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
SquadMenuSettings.pages.select_spawnpoint[1680][1050].button_info = {
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
			button_name = "d_pad",
			text = "menu_ingame_join_leave_squad"
		},
		{
			button_name = "x",
			text = "menu_switch_character_lower"
		},
		{
			text = "menu_ingame_select_spawnpoint",
			button_name = {
				"left_button",
				"right_button"
			}
		},
		{
			button_name = "a",
			text = "menu_spawn"
		},
		{
			button_name = "back",
			text = "menu_ingame_leave_battle"
		}
	}
}
SquadMenuSettings.pages.level_2_character_profiles = SquadMenuSettings.pages.level_2_character_profiles or {}
SquadMenuSettings.pages.level_2_character_profiles[1680] = SquadMenuSettings.pages.level_2_character_profiles[1680] or {}
SquadMenuSettings.pages.level_2_character_profiles[1680][1050] = SquadMenuSettings.pages.level_2_character_profiles[1680][1050] or table.clone(MainMenuSettings.pages.level_2_character_profiles[1680][1050])
SquadMenuSettings.pages.level_2_character_profiles[1680][1050].page_links = table.clone(SquadMenuSettings.pages.select_team[1680][1050].page_links)
SquadMenuSettings.background_container = SquadMenuSettings.background_container or {}
SquadMenuSettings.background_container[1680] = SquadMenuSettings.background_container[1680] or {}
SquadMenuSettings.background_container[1680][1050] = SquadMenuSettings.background_container[1680][1050] or {
	x = 0,
	height = 820,
	z = 0,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 2,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 1470,
	row_heights = {
		445,
		375
	}
}
SquadMenuSettings.squad_grid_container = SquadMenuSettings.squad_grid_container or {}
SquadMenuSettings.squad_grid_container[1680] = SquadMenuSettings.squad_grid_container[1680] or {}
SquadMenuSettings.squad_grid_container[1680][1050] = SquadMenuSettings.squad_grid_container[1680][1050] or {
	x = 0,
	height = 425,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 4,
	num_rows = 2,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 1440
}
SquadMenuSettings.squadless_container = SquadMenuSettings.squadless_container or {}
SquadMenuSettings.squadless_container[1680] = SquadMenuSettings.squadless_container[1680] or {}
SquadMenuSettings.squadless_container[1680][1050] = SquadMenuSettings.squadless_container[1680][1050] or {
	x = 0,
	height = 330,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 3,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685,
	row_heights = {
		37,
		30,
		263
	}
}
SquadMenuSettings.squadless_header_container = SquadMenuSettings.squadless_header_container or {}
SquadMenuSettings.squadless_header_container[1680] = SquadMenuSettings.squadless_header_container[1680] or {}
SquadMenuSettings.squadless_header_container[1680][1050] = SquadMenuSettings.squadless_header_container[1680][1050] or {
	x = 0,
	height = 37,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685
}
SquadMenuSettings.squadless_header_background = SquadMenuSettings.squadless_header_background or {}
SquadMenuSettings.squadless_header_background[1680] = SquadMenuSettings.squadless_header_background[1680] or {}
SquadMenuSettings.squadless_header_background[1680][1050] = SquadMenuSettings.squadless_header_background[1680][1050] or {
	texture_name = "squad_menu_banner_lonewolfs",
	height = 37,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squadless_header_text = SquadMenuSettings.squadless_header_text or {}
SquadMenuSettings.squadless_header_text[1680] = SquadMenuSettings.squadless_header_text[1680] or {}
SquadMenuSettings.squadless_header_text[1680][1050] = SquadMenuSettings.squadless_header_text[1680][1050] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "auto",
	horizontal_position_policy = "center",
	localize_text = true,
	text = "squadless_name",
	height_policy = "auto",
	y = 0,
	vertical_position_policy = "center",
	width = 0,
	font = MenuSettings.fonts.hell_shark_22,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squadless_container = SquadMenuSettings.join_squadless_container or {}
SquadMenuSettings.join_squadless_container[1680] = SquadMenuSettings.join_squadless_container[1680] or {}
SquadMenuSettings.join_squadless_container[1680][1050] = SquadMenuSettings.join_squadless_container[1680][1050] or {
	x = 0,
	height = 30,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685
}
SquadMenuSettings.join_squadless_text = SquadMenuSettings.join_squadless_text or {}
SquadMenuSettings.join_squadless_text[1680] = SquadMenuSettings.join_squadless_text[1680] or {}
SquadMenuSettings.join_squadless_text[1680][1050] = SquadMenuSettings.join_squadless_text[1680][1050] or {
	scale = 1,
	height = 115,
	x = 0,
	horizontal_position_policy = "center",
	text_alignment = "center",
	text = "join_squadless",
	vertical_position_policy = "center",
	z = 1,
	width_policy = "defined",
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "defined",
	y = 0,
	width = 600,
	font = MenuSettings.fonts.hell_shark_20,
	color = {
		255,
		215,
		215,
		215
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squadless_scroll_container = SquadMenuSettings.squadless_scroll_container or {}
SquadMenuSettings.squadless_scroll_container[1680] = SquadMenuSettings.squadless_scroll_container[1680] or {}
SquadMenuSettings.squadless_scroll_container[1680][1050] = SquadMenuSettings.squadless_scroll_container[1680][1050] or {
	x = 0,
	height = 257,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	scroll_bar_width = 4,
	scroll_bar_alignment = "right",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 674,
	slider_margin = 1,
	slider_color = {
		180,
		220,
		220,
		220
	}
}
SquadMenuSettings.squadless_members_container = SquadMenuSettings.squadless_members_container or {}
SquadMenuSettings.squadless_members_container[1680] = SquadMenuSettings.squadless_members_container[1680] or {}
SquadMenuSettings.squadless_members_container[1680][1050] = SquadMenuSettings.squadless_members_container[1680][1050] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "top",
	width = 330
}
SquadMenuSettings.squadless_member_name = SquadMenuSettings.squadless_member_name or {}
SquadMenuSettings.squadless_member_name[1680] = SquadMenuSettings.squadless_member_name[1680] or {}
SquadMenuSettings.squadless_member_name[1680][1050] = SquadMenuSettings.squadless_member_name[1680][1050] or {
	horizontal_position_policy = "left",
	height = 30,
	scale = 1,
	width_policy = "defined",
	x = 0,
	text = "PLAYER NAME EXAMPLE",
	vertical_position_policy = "center",
	z = 1,
	truncate_text = true,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "defined",
	y = 0,
	width = 300,
	font = MenuSettings.fonts.hell_shark_22_masked,
	color = {
		255,
		215,
		215,
		215
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_container = SquadMenuSettings.squad_container or {}
SquadMenuSettings.squad_container[1680] = SquadMenuSettings.squad_container[1680] or {}
SquadMenuSettings.squad_container[1680][1050] = SquadMenuSettings.squad_container[1680][1050] or {
	x = 0,
	height = 200,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 3,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329,
	row_heights = {
		37,
		30,
		133
	}
}
SquadMenuSettings.squad_header_container = SquadMenuSettings.squad_header_container or {}
SquadMenuSettings.squad_header_container[1680] = SquadMenuSettings.squad_header_container[1680] or {}
SquadMenuSettings.squad_header_container[1680][1050] = SquadMenuSettings.squad_header_container[1680][1050] or {
	x = 0,
	height = 37,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329
}
SquadMenuSettings.squad_header_background = SquadMenuSettings.squad_header_background or {}
SquadMenuSettings.squad_header_background[1680] = SquadMenuSettings.squad_header_background[1680] or {}
SquadMenuSettings.squad_header_background[1680][1050] = SquadMenuSettings.squad_header_background[1680][1050] or {
	texture_name = "squad_menu_banner_squad",
	height = 37,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_information_container = SquadMenuSettings.squad_header_information_container or {}
SquadMenuSettings.squad_header_information_container[1680] = SquadMenuSettings.squad_header_information_container[1680] or {}
SquadMenuSettings.squad_header_information_container[1680][1050] = SquadMenuSettings.squad_header_information_container[1680][1050] or {
	x = 0,
	height = 37,
	z = 2,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 3,
	num_rows = 1,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329,
	column_widths = {
		232,
		56,
		41
	}
}
SquadMenuSettings.squad_header_text = SquadMenuSettings.squad_header_text or {}
SquadMenuSettings.squad_header_text[1680] = SquadMenuSettings.squad_header_text[1680] or {}
SquadMenuSettings.squad_header_text[1680][1050] = SquadMenuSettings.squad_header_text[1680][1050] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "auto",
	horizontal_position_policy = "left",
	offset_x = 15,
	localize_text = true,
	text = "squad_name",
	height_policy = "auto",
	y = 0,
	vertical_position_policy = "center",
	width = 0,
	font = MenuSettings.fonts.hell_shark_22,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_lock_icon = SquadMenuSettings.squad_header_lock_icon or {}
SquadMenuSettings.squad_header_lock_icon[1680] = SquadMenuSettings.squad_header_lock_icon[1680] or {}
SquadMenuSettings.squad_header_lock_icon[1680][1050] = SquadMenuSettings.squad_header_lock_icon[1680][1050] or {
	texture_name = "squad_menu_locked",
	height = 20,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	highlighted_scale = 1.05,
	atlas_name = "menu_assets",
	x = 0,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 24,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_animal_container = SquadMenuSettings.squad_header_animal_container or {}
SquadMenuSettings.squad_header_animal_container[1680] = SquadMenuSettings.squad_header_animal_container[1680] or {}
SquadMenuSettings.squad_header_animal_container[1680][1050] = SquadMenuSettings.squad_header_animal_container[1680][1050] or {
	x = 0,
	height = 37,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 37
}
SquadMenuSettings.squad_header_animal_background = SquadMenuSettings.squad_header_animal_background or {}
SquadMenuSettings.squad_header_animal_background[1680] = SquadMenuSettings.squad_header_animal_background[1680] or {}
SquadMenuSettings.squad_header_animal_background[1680][1050] = SquadMenuSettings.squad_header_animal_background[1680][1050] or {
	texture_name = "squad_menu_animal_bg",
	height = 52,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 52,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_animal_icon = SquadMenuSettings.squad_header_animal_icon or {}
SquadMenuSettings.squad_header_animal_icon[1680] = SquadMenuSettings.squad_header_animal_icon[1680] or {}
SquadMenuSettings.squad_header_animal_icon[1680][1050] = SquadMenuSettings.squad_header_animal_icon[1680][1050] or {
	texture_name = "squad_menu_animal_moose",
	height = 52,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	highlighted_scale = 1.06,
	atlas_name = "menu_assets",
	x = 0,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 52,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squad_container = SquadMenuSettings.join_squad_container or {}
SquadMenuSettings.join_squad_container[1680] = SquadMenuSettings.join_squad_container[1680] or {}
SquadMenuSettings.join_squad_container[1680][1050] = SquadMenuSettings.join_squad_container[1680][1050] or {
	x = 0,
	height = 30,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329
}
SquadMenuSettings.join_squad_text = SquadMenuSettings.join_squad_text or {}
SquadMenuSettings.join_squad_text[1680] = SquadMenuSettings.join_squad_text[1680] or {}
SquadMenuSettings.join_squad_text[1680][1050] = SquadMenuSettings.join_squad_text[1680][1050] or {
	scale = 1,
	height = 115,
	x = 0,
	horizontal_position_policy = "center",
	text_alignment = "center",
	text = "join_squad",
	vertical_position_policy = "center",
	z = 1,
	width_policy = "defined",
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "defined",
	y = 0,
	width = 300,
	font = MenuSettings.fonts.hell_shark_20,
	color = {
		255,
		215,
		215,
		215
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squad_button_prompt = SquadMenuSettings.join_squad_button_prompt or {}
SquadMenuSettings.join_squad_button_prompt[1680] = SquadMenuSettings.join_squad_button_prompt[1680] or {}
SquadMenuSettings.join_squad_button_prompt[1680][1050] = SquadMenuSettings.join_squad_button_prompt[1680][1050] or {
	texture_name = "y",
	height = 50,
	z = 1,
	offset_x = 75,
	width_policy = "defined",
	horizontal_position_policy = "center",
	scale = 1,
	width = 50,
	atlas_name = "X360Buttons",
	asset_name = "x360_buttons",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	x = 0,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_members_container = SquadMenuSettings.squad_members_container or {}
SquadMenuSettings.squad_members_container[1680] = SquadMenuSettings.squad_members_container[1680] or {}
SquadMenuSettings.squad_members_container[1680][1050] = SquadMenuSettings.squad_members_container[1680][1050] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "left",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "top",
	width = 329
}
SquadMenuSettings.squad_member_name = SquadMenuSettings.squad_member_name or {}
SquadMenuSettings.squad_member_name[1680] = SquadMenuSettings.squad_member_name[1680] or {}
SquadMenuSettings.squad_member_name[1680][1050] = SquadMenuSettings.squad_member_name[1680][1050] or {
	offset_x = 15,
	height = 30,
	width_policy = "defined",
	scale = 1,
	x = 0,
	horizontal_position_policy = "left",
	text = "PLAYER NAME EXAMPLE",
	vertical_position_policy = "center",
	z = 1,
	truncate_text = true,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "defined",
	y = 0,
	width = 300,
	font = MenuSettings.fonts.hell_shark_22,
	color = {
		255,
		215,
		215,
		215
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.select_team_text = SquadMenuSettings.select_team_text or {}
SquadMenuSettings.select_team_text[1680] = SquadMenuSettings.select_team_text[1680] or {}
SquadMenuSettings.select_team_text[1680][1050] = SquadMenuSettings.select_team_text[1680][1050] or {
	offset_y = 22,
	height = 0,
	width_policy = "auto",
	scale = 1,
	x = 0,
	horizontal_position_policy = "left",
	text = "menu_select_team",
	vertical_position_policy = "bottom",
	z = 1,
	offset_x = 45,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "auto",
	y = 0,
	width = 0,
	font = MenuSettings.fonts.hell_shark_26,
	color = {
		255,
		203,
		100,
		25
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.page_name_text = SquadMenuSettings.page_name_text or {}
SquadMenuSettings.page_name_text[1680] = SquadMenuSettings.page_name_text[1680] or {}
SquadMenuSettings.page_name_text[1680][1050] = SquadMenuSettings.page_name_text[1680][1050] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "auto",
	horizontal_position_policy = "center",
	offset_y = 22,
	localize_text = true,
	text = "squad_manager_page_name",
	height_policy = "auto",
	y = 0,
	vertical_position_policy = "bottom",
	width = 0,
	font = MenuSettings.fonts.hell_shark_28,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.select_profile_text = SquadMenuSettings.select_profile_text or {}
SquadMenuSettings.select_profile_text[1680] = SquadMenuSettings.select_profile_text[1680] or {}
SquadMenuSettings.select_profile_text[1680][1050] = SquadMenuSettings.select_profile_text[1680][1050] or {
	offset_y = 22,
	height = 0,
	width_policy = "auto",
	scale = 1,
	x = 0,
	horizontal_position_policy = "right",
	text = "menu_select_character",
	vertical_position_policy = "bottom",
	z = 1,
	offset_x = -45,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "auto",
	y = 0,
	width = 0,
	font = MenuSettings.fonts.hell_shark_26,
	color = {
		255,
		203,
		100,
		25
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
