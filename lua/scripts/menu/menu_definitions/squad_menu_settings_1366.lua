-- chunkname: @scripts/menu/menu_definitions/squad_menu_settings_1366.lua

require("scripts/menu/menu_definitions/final_scoreboard_menu_settings_1366")
require("scripts/settings/menu_settings")

SCALE_1366 = 0.7114583333333333
SquadMenuSettings = SquadMenuSettings or {}
SquadMenuSettings.items = SquadMenuSettings.items or {}
SquadMenuSettings.pages = SquadMenuSettings.pages or {}
SquadMenuSettings.items.spawn_map = SquadMenuSettings.items.spawn_map or {}
SquadMenuSettings.items.spawn_map[1366] = SquadMenuSettings.items.spawn_map[1366] or {}
SquadMenuSettings.items.spawn_map[1366][768] = SquadMenuSettings.items.spawn_map[1366][768] or {
	width = 512 * SCALE_1366,
	height = 512 * SCALE_1366,
	color = {
		255,
		64,
		128,
		255
	}
}
SquadMenuSettings.items.local_player_marker = SquadMenuSettings.items.local_player_marker or {}
SquadMenuSettings.items.local_player_marker[1366] = SquadMenuSettings.items.local_player_marker[1366] or {}
SquadMenuSettings.items.local_player_marker[1366][768] = SquadMenuSettings.items.local_player_marker[1366][768] or {
	texture = "map_icon_local_player",
	texture_height = 12,
	texture_width = 12
}
SquadMenuSettings.items.spawn_area_marker = SquadMenuSettings.items.spawn_area_marker or {}
SquadMenuSettings.items.spawn_area_marker[1366] = SquadMenuSettings.items.spawn_area_marker[1366] or {}
SquadMenuSettings.items.spawn_area_marker[1366][768] = SquadMenuSettings.items.spawn_area_marker[1366][768] or {
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
SquadMenuSettings.items.squad_marker[1366] = SquadMenuSettings.items.squad_marker[1366] or {}
SquadMenuSettings.items.squad_marker[1366][768] = SquadMenuSettings.items.squad_marker[1366][768] or {
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
SquadMenuSettings.items.squad_join_button[1366] = SquadMenuSettings.items.squad_join_button[1366] or {}
SquadMenuSettings.items.squad_join_button[1366][768] = SquadMenuSettings.items.squad_join_button[1366][768] or {
	texture_left = "small_button_left_1366",
	texture_left_highlighted = "small_button_left_highlighted_1366",
	text_offset_y = 6,
	texture_right_highlighted = "small_button_right_highlighted_1366",
	padding_bottom = 10,
	padding_top = 12,
	texture_middle_highlighted = "small_button_center_highlighted_1366",
	texture_left_width = 8,
	padding_right = 0,
	texture_height = 24,
	text_padding = 1,
	padding_left = 14,
	texture_right = "small_button_right_1366",
	font_size = 18,
	texture_middle = "small_button_center_1366",
	texture_right_width = 8,
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
SquadMenuSettings.items.page_link[1366] = SquadMenuSettings.items.page_link[1366] or {}
SquadMenuSettings.items.page_link[1366][768] = SquadMenuSettings.items.page_link[1366][768] or {
	font = MenuSettings.fonts.hell_shark_32,
	font_size = 32 * SCALE_1366,
	line_height = 21 * SCALE_1366,
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
	},
	padding_top = 12 * SCALE_1366,
	padding_bottom = 12 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 20 * SCALE_1366
}
SquadMenuSettings.items.next_button = SquadMenuSettings.items.next_button or {}
SquadMenuSettings.items.next_button[1366] = SquadMenuSettings.items.next_button[1366] or {}
SquadMenuSettings.items.next_button[1366][768] = SquadMenuSettings.items.next_button[1366][768] or {
	texture_left = "shiny_button_left_end_1366",
	texture_left_highlighted = "shiny_button_left_end_highlighted_1366",
	text_offset_y = 16,
	texture_right_highlighted = "shiny_button_right_tip_highlighted_1366",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1366",
	texture_left_width = 20,
	padding_right = 14,
	texture_height = 44,
	text_padding = 0,
	padding_left = 14,
	texture_right = "shiny_button_right_tip_1366",
	font_size = 18,
	texture_middle = "shiny_button_center_1366",
	texture_right_width = 24,
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
SquadMenuSettings.items.previous_button[1366] = SquadMenuSettings.items.previous_button[1366] or {}
SquadMenuSettings.items.previous_button[1366][768] = SquadMenuSettings.items.previous_button[1366][768] or {
	texture_left = "shiny_button_left_tip_1366",
	texture_left_highlighted = "shiny_button_left_tip_highlighted_1366",
	text_offset_y = 16,
	texture_right_highlighted = "shiny_button_right_end_highlighted_1366",
	padding_bottom = 0,
	padding_top = 0,
	texture_middle_highlighted = "shiny_button_center_highlighted_1366",
	texture_left_width = 24,
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
SquadMenuSettings.items.centered_button[1366] = SquadMenuSettings.items.centered_button[1366] or {}
SquadMenuSettings.items.centered_button[1366][768] = SquadMenuSettings.items.centered_button[1366][768] or {
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
SquadMenuSettings.items.quote_text = SquadMenuSettings.items.quote_text or {}
SquadMenuSettings.items.quote_text[1366] = SquadMenuSettings.items.quote_text[1366] or {}
SquadMenuSettings.items.quote_text[1366][768] = SquadMenuSettings.items.quote_text[1366][768] or {
	text_align = "left",
	font = MenuSettings.fonts.hell_shark_22,
	font_size = 22 * SCALE_1366,
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
		2 * SCALE_1366,
		-2 * SCALE_1366
	},
	line_height = 32 * SCALE_1366,
	width = 440 * SCALE_1366,
	padding_top = 40 * SCALE_1366,
	padding_bottom = 40 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
SquadMenuSettings.items.red_team_rose = SquadMenuSettings.items.red_team_rose or {}
SquadMenuSettings.items.red_team_rose[1366] = SquadMenuSettings.items.red_team_rose[1366] or {}
SquadMenuSettings.items.red_team_rose[1366][768] = SquadMenuSettings.items.red_team_rose[1366][768] or {
	texture_highlighted = "team_selection_highlighted_viking",
	texture = "big_rose_red",
	texture_disabled = "team_selection_disabled_1920",
	texture_width = 444 * SCALE_1366,
	texture_height = 488 * SCALE_1366,
	color_disabled = {
		150,
		100,
		100,
		100
	},
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366,
	texture_highlighted_offset_x = -44 * SCALE_1366,
	texture_highlighted_offset_y = -22 * SCALE_1366,
	texture_highlighted_offset_z = 0 * SCALE_1366,
	texture_highlighted_width = 532 * SCALE_1366,
	texture_highlighted_height = 532 * SCALE_1366,
	texture_disabled_offset_x = 136 * SCALE_1366,
	texture_disabled_offset_y = 150 * SCALE_1366,
	texture_disabled_offset_z = 2 * SCALE_1366,
	texture_disabled_width = 184 * SCALE_1366,
	texture_disabled_height = 184 * SCALE_1366
}
SquadMenuSettings.items.white_team_rose = SquadMenuSettings.items.white_team_rose or {}
SquadMenuSettings.items.white_team_rose[1366] = SquadMenuSettings.items.white_team_rose[1366] or {}
SquadMenuSettings.items.white_team_rose[1366][768] = SquadMenuSettings.items.white_team_rose[1366][768] or {
	texture_highlighted = "team_selection_highlighted_saxon",
	texture = "big_rose_white",
	texture_disabled = "team_selection_disabled_1920",
	texture_width = 444 * SCALE_1366,
	texture_height = 488 * SCALE_1366,
	color_disabled = {
		150,
		100,
		100,
		100
	},
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366,
	texture_highlighted_offset_x = -44 * SCALE_1366,
	texture_highlighted_offset_y = -22 * SCALE_1366,
	texture_highlighted_offset_z = 0 * SCALE_1366,
	texture_highlighted_width = 532 * SCALE_1366,
	texture_highlighted_height = 532 * SCALE_1366,
	texture_disabled_offset_x = 140 * SCALE_1366,
	texture_disabled_offset_y = 156 * SCALE_1366,
	texture_disabled_offset_z = 2 * SCALE_1366,
	texture_disabled_width = 184 * SCALE_1366,
	texture_disabled_height = 184 * SCALE_1366
}
SquadMenuSettings.items.wotv_viking_team = SquadMenuSettings.items.wotv_viking_team or {}
SquadMenuSettings.items.wotv_viking_team[1366] = {}
SquadMenuSettings.items.wotv_viking_team[1366][768] = SquadMenuSettings.items.wotv_viking_team[1366][768] or {
	texture_highlighted = "team_selection_highlighted_viking",
	texture_highlighted_height = 266,
	texture_disabled_offset_y = 80,
	texture_disabled_width = 92,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = 0,
	texture_disabled_height = 92,
	texture_width = 266,
	padding_right = 0,
	texture_height = 266,
	texture = "big_rose_red",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = 0,
	padding_left = 0,
	texture_disabled_offset_x = 85,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 266,
	color_disabled = {
		150,
		100,
		100,
		100
	}
}
SquadMenuSettings.items.wotv_saxon_team = SquadMenuSettings.items.wotv_saxon_team or {}
SquadMenuSettings.items.wotv_saxon_team[1366] = {}
SquadMenuSettings.items.wotv_saxon_team[1366][768] = SquadMenuSettings.items.wotv_saxon_team[1366][768] or {
	texture_highlighted = "team_selection_highlighted_saxon",
	texture_highlighted_height = 266,
	texture_disabled_offset_y = 80,
	texture_disabled_width = 92,
	padding_top = 0,
	padding_bottom = 0,
	texture_highlighted_offset_y = 0,
	texture_disabled_height = 92,
	texture_width = 266,
	padding_right = 0,
	texture_height = 266,
	texture = "big_rose_white",
	texture_disabled_offset_z = 2,
	texture_highlighted_offset_x = 0,
	texture_disabled_offset_x = 85,
	texture_disabled = "team_selection_disabled_1920",
	texture_highlighted_offset_z = 0,
	texture_highlighted_width = 266,
	color_disabled = {
		150,
		100,
		100,
		100
	},
	padding_left = -50 * SCALE_1366
}
SquadMenuSettings.items.red_team_num_players = SquadMenuSettings.items.red_team_num_players or {}
SquadMenuSettings.items.red_team_num_players[1366] = SquadMenuSettings.items.red_team_num_players[1366] or {}
SquadMenuSettings.items.red_team_num_players[1366][768] = SquadMenuSettings.items.red_team_num_players[1366][768] or {
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
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
SquadMenuSettings.items.white_team_num_players = SquadMenuSettings.items.white_team_num_players or {}
SquadMenuSettings.items.white_team_num_players[1366] = SquadMenuSettings.items.white_team_num_players[1366] or {}
SquadMenuSettings.items.white_team_num_players[1366][768] = SquadMenuSettings.items.white_team_num_players[1366][768] or {
	font = MenuSettings.fonts.hell_shark_32,
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
	font_size = 32 * SCALE_1366,
	line_height = 21 * SCALE_1366,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	padding_top = 0 * SCALE_1366,
	padding_bottom = 0 * SCALE_1366,
	padding_left = 0 * SCALE_1366,
	padding_right = 0 * SCALE_1366
}
SquadMenuSettings.pages.select_team = SquadMenuSettings.pages.select_team or {}
SquadMenuSettings.pages.select_team[1366] = {}
SquadMenuSettings.pages.select_team[1366][768] = SquadMenuSettings.pages.select_team[1366][768] or table.clone(FinalScoreboardMenuSettings.pages.main_page[1366][768])
SquadMenuSettings.pages.select_team[1366][768].back_list = table.clone(MainMenuSettings.pages.level_2[1366][768].back_list)
SquadMenuSettings.pages.select_team[1366][768].back_list.number_of_columns = 2
SquadMenuSettings.pages.select_team[1366][768].page_links = {
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
SquadMenuSettings.pages.select_team[1366][768].back_list = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	number_of_columns = 2,
	pivot_offset_x = 40,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_team[1366][768].left_team_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 100,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 80,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_team[1366][768].right_team_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 100,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 350,
	screen_offset_y = 0,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_team[1366][768].center_items = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 335,
	screen_offset_y = -0.08,
	pivot_align_x = "left",
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1366][768].auto_join_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 400,
	pivot_align_x = "left",
	screen_offset_y = -0,
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1366][768].red_players = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	screen_offset_y = -0.17,
	pivot_align_x = "right",
	pivot_offset_x = 800 * SCALE_1366,
	column_alignment = {
		"left"
	}
}
SquadMenuSettings.pages.select_team[1366][768].white_players = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	screen_offset_y = -0.17,
	pivot_align_x = "left",
	pivot_offset_x = 50 * SCALE_1366,
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_team[1366][768].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_team[1366][768].button_info = {
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
SquadMenuSettings.pages.select_team[1366][768].auto_join_items = {
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
SquadMenuSettings.pages.select_squad = SquadMenuSettings.pages.select_squad or {}
SquadMenuSettings.pages.select_squad[1366] = {}
SquadMenuSettings.pages.select_squad[1366][768] = SquadMenuSettings.pages.select_squad[1366][768] or table.clone(FinalScoreboardMenuSettings.pages.main_page[1366][768])
SquadMenuSettings.pages.select_squad[1366][768].back_list = table.clone(MainMenuSettings.pages.level_2[1366][768].back_list)
SquadMenuSettings.pages.select_squad[1366][768].back_list.number_of_columns = 2
SquadMenuSettings.pages.select_squad[1366][768].page_links = {
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
SquadMenuSettings.pages.select_squad[1366][768].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1366][768].prev_link = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_align_y = "bottom",
	screen_align_x = "left",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1366][768].next_link = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	pivot_align_y = "bottom",
	screen_align_x = "right",
	pivot_offset_y = 0
}
SquadMenuSettings.pages.select_squad[1366][768].header_items = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 220
}
SquadMenuSettings.pages.select_squad[1366][768].menu_items = {
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
SquadMenuSettings.pages.select_squad[1366][768].button_info = {
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
SquadMenuSettings.pages.select_squad[1366][768].auto_join_items = {
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
SquadMenuSettings.items.placeholder_header = SquadMenuSettings.items.placeholder_header or {}
SquadMenuSettings.items.placeholder_header[1366] = SquadMenuSettings.items.placeholder_header[1366] or {}
SquadMenuSettings.items.placeholder_header[1366][768] = SquadMenuSettings.items.placeholder_header[1366][768] or {
	font_size = 40,
	align = "center",
	font = MenuSettings.fonts.hell_shark_36,
	color = {
		255,
		255,
		36,
		36
	},
	disabled_color = {
		255,
		255,
		36,
		36
	},
	highlight_color = {
		255,
		255,
		36,
		36
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
SquadMenuSettings.items.squad_menu_background_container = SquadMenuSettings.items.squad_menu_background_container or {}
SquadMenuSettings.items.squad_menu_background_container[1366] = SquadMenuSettings.items.squad_menu_background_container[1366] or {}
SquadMenuSettings.items.squad_menu_background_container[1366][768] = SquadMenuSettings.items.squad_menu_background_container[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.items.squad_menu_squads_container = SquadMenuSettings.items.squad_menu_squads_container or {}
SquadMenuSettings.items.squad_menu_squads_container[1366] = SquadMenuSettings.items.squad_menu_squads_container[1366] or {}
SquadMenuSettings.items.squad_menu_squads_container[1366][768] = SquadMenuSettings.items.squad_menu_squads_container[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.items.squad_menu_squad_container = SquadMenuSettings.items.squad_menu_squad_container or {}
SquadMenuSettings.items.squad_menu_squad_container[1366] = SquadMenuSettings.items.squad_menu_squad_container[1366] or {}
SquadMenuSettings.items.squad_menu_squad_container[1366][768] = SquadMenuSettings.items.squad_menu_squad_container[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.items.squad_menu_squad_members_container = SquadMenuSettings.items.squad_menu_squad_members_container or {}
SquadMenuSettings.items.squad_menu_squad_members_container[1366] = SquadMenuSettings.items.squad_menu_squad_members_container[1366] or {}
SquadMenuSettings.items.squad_menu_squad_members_container[1366][768] = SquadMenuSettings.items.squad_menu_squad_members_container[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
SquadMenuSettings.items.squad_menu_squad_header_banner = SquadMenuSettings.items.squad_menu_squad_header_banner or {}
SquadMenuSettings.items.squad_menu_squad_header_banner[1366] = SquadMenuSettings.items.squad_menu_squad_header_banner[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_banner[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_banner[1366][768] or {
	texture = "squad_menu_banner_squad",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SquadMenuSettings.items.squad_menu_squad_header_banner_large = SquadMenuSettings.items.squad_menu_squad_header_banner_large or {}
SquadMenuSettings.items.squad_menu_squad_header_banner_large[1366] = SquadMenuSettings.items.squad_menu_squad_header_banner_large[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_banner_large[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_banner_large[1366][768] or {
	texture = "squad_menu_banner_lonewolfs",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SquadMenuSettings.items.squad_menu_squad_header_text = SquadMenuSettings.items.squad_menu_squad_header_text or {}
SquadMenuSettings.items.squad_menu_squad_header_text[1366] = SquadMenuSettings.items.squad_menu_squad_header_text[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_text[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_text[1366][768] or {
	padding_bottom = 7,
	padding_left = 20,
	rect_width = 250,
	render_rect = true,
	padding_top = 7,
	rect_height = 25,
	line_height = 32,
	rect_offset_y = -5,
	masked = "rect_masked",
	padding_right = 20,
	spacing = 13,
	rect_offset_x = -10,
	font_size = 16,
	border_thickness = 3,
	font = MenuSettings.fonts.hell_shark_16_masked,
	color = {
		255,
		255,
		255,
		255
	},
	color_disabled = {
		128,
		128,
		128,
		128
	},
	color_render_from_child_page = {
		160,
		0,
		0,
		0
	},
	rect_color = {
		160,
		0,
		0,
		0
	},
	rect_color_highlighted = {
		225,
		0,
		0,
		0
	},
	border_color = {
		192,
		0,
		0,
		0
	}
}
SquadMenuSettings.items.squad_menu_squad_header_icon = SquadMenuSettings.items.squad_menu_squad_header_icon or {}
SquadMenuSettings.items.squad_menu_squad_header_icon[1366] = SquadMenuSettings.items.squad_menu_squad_header_icon[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_icon[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_icon[1366][768] or {
	texture = "squad_menu_animal_bear",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SquadMenuSettings.items.squad_menu_squad_header_icon_background = SquadMenuSettings.items.squad_menu_squad_header_icon_background or {}
SquadMenuSettings.items.squad_menu_squad_header_icon_background[1366] = SquadMenuSettings.items.squad_menu_squad_header_icon_background[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_icon_background[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_icon_background[1366][768] or {
	texture = "squad_menu_animal_bg",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SquadMenuSettings.items.squad_menu_squad_header_lock = SquadMenuSettings.items.squad_menu_squad_header_lock or {}
SquadMenuSettings.items.squad_menu_squad_header_lock[1366] = SquadMenuSettings.items.squad_menu_squad_header_lock[1366] or {}
SquadMenuSettings.items.squad_menu_squad_header_lock[1366][768] = SquadMenuSettings.items.squad_menu_squad_header_lock[1366][768] or {
	texture = "squad_menu_unlocked",
	texture_atlas = "menu_assets",
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SquadMenuSettings.items.squad_menu_join_squad_button = SquadMenuSettings.items.squad_menu_join_squad_button or {}
SquadMenuSettings.items.squad_menu_join_squad_button[1366] = SquadMenuSettings.items.squad_menu_join_squad_button[1366] or {}
SquadMenuSettings.items.squad_menu_join_squad_button[1366][768] = SquadMenuSettings.items.squad_menu_join_squad_button[1366][768] or {}
SquadMenuSettings.items.squad_menu_join_squad_text = SquadMenuSettings.items.squad_menu_join_squad_text or {}
SquadMenuSettings.items.squad_menu_join_squad_text[1366] = SquadMenuSettings.items.squad_menu_join_squad_text[1366] or {}
SquadMenuSettings.items.squad_menu_join_squad_text[1366][768] = SquadMenuSettings.items.squad_menu_join_squad_text[1366][768] or {}
SquadMenuSettings.items.squad_menu_squad_members_text = SquadMenuSettings.items.squad_menu_squad_members_text or {}
SquadMenuSettings.items.squad_menu_squad_members_text[1366] = SquadMenuSettings.items.squad_menu_squad_members_text[1366] or {}
SquadMenuSettings.items.squad_menu_squad_members_text[1366][768] = SquadMenuSettings.items.squad_menu_squad_members_text[1366][768] or {
	padding_bottom = 0,
	padding_left = 8,
	rect_width = 35,
	render_rect = true,
	padding_top = 0,
	rect_height = 25,
	line_height = 28,
	rect_offset_y = -5,
	masked = "rect_masked",
	padding_right = 0,
	spacing = 0,
	rect_offset_x = 0,
	font_size = 28,
	border_thickness = 3,
	font = MenuSettings.fonts.hell_shark_28_masked,
	color = {
		255,
		255,
		255,
		255
	},
	color_disabled = {
		255,
		255,
		255,
		255
	},
	color_render_from_child_page = {
		160,
		0,
		0,
		0
	},
	rect_color = {
		160,
		0,
		0,
		0
	},
	rect_color_highlighted = {
		225,
		0,
		0,
		0
	},
	border_color = {
		192,
		0,
		0,
		0
	}
}
SquadMenuSettings.items.auto_join = SquadMenuSettings.items.auto_join or {}
SquadMenuSettings.items.auto_join[1366] = {}
SquadMenuSettings.items.auto_join[1366][768] = SquadMenuSettings.items.auto_join[1366][768] or {
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
SquadMenuSettings.items.centered_text[1366] = {}
SquadMenuSettings.items.centered_text[1366][768] = SquadMenuSettings.items.centered_text[1366][768] or {
	padding_left = 150,
	font_size = 24,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0,
	line_height = 25,
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
SquadMenuSettings.items.choose_side = SquadMenuSettings.items.choose_side or {}
SquadMenuSettings.items.choose_side[1366] = {}
SquadMenuSettings.items.choose_side[1366][768] = SquadMenuSettings.items.choose_side[1366][768] or {
	padding_left = 0,
	font_size = 40,
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
SquadMenuSettings.items.red_team_text = SquadMenuSettings.items.red_team_text or {}
SquadMenuSettings.items.red_team_text[1366] = {}
SquadMenuSettings.items.red_team_text[1366][768] = SquadMenuSettings.items.red_team_text[1366][768] or {
	padding_left = 0,
	font_size = 30,
	padding_top = 5,
	padding_bottom = 15,
	line_height = 21,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_30,
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
SquadMenuSettings.items.white_team_text[1366] = {}
SquadMenuSettings.items.white_team_text[1366][768] = SquadMenuSettings.items.white_team_text[1366][768] or {
	padding_left = 0,
	font_size = 30,
	padding_top = 5,
	padding_bottom = 15,
	line_height = 21,
	padding_right = 0,
	font = MenuSettings.fonts.hell_shark_30,
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
SquadMenuSettings.pages.select_spawnpoint = SquadMenuSettings.pages.select_spawnpoint or {}
SquadMenuSettings.pages.select_spawnpoint[1366] = SquadMenuSettings.pages.select_spawnpoint[1366] or {}
SquadMenuSettings.pages.select_spawnpoint[1366][768] = SquadMenuSettings.pages.select_spawnpoint[1366][768] or table.clone(MainMenuSettings.pages.level_3[1366][768])
SquadMenuSettings.pages.select_spawnpoint[1366][768].center_items = table.clone(FinalScoreboardMenuSettings.pages.main_page[1680][1050].center_items)
SquadMenuSettings.pages.select_spawnpoint[1366][768].center_items.pivot_offset_y = 0
SquadMenuSettings.pages.select_spawnpoint[1366][768].squad_header = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	screen_align_x = "left",
	screen_offset_y = -0.25,
	pivot_align_x = "right",
	pivot_offset_x = 540 * SCALE_1366,
	pivot_offset_y = 60 * SCALE_1366,
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1366][768].squad_info = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	screen_align_x = "left",
	screen_offset_y = -0.25,
	pivot_align_x = "right",
	pivot_offset_x = 540 * SCALE_1366,
	pivot_offset_y = 0 * SCALE_1366,
	column_alignment = {
		"right"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1366][768].squad_button = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	screen_align_x = "left",
	screen_offset_y = -0.25,
	pivot_align_x = "center",
	pivot_offset_x = 490 * SCALE_1366,
	pivot_offset_y = 3 * SCALE_1366,
	column_alignment = {
		"center"
	}
}
SquadMenuSettings.pages.select_spawnpoint[1366][768].page_links = table.clone(SquadMenuSettings.pages.select_team[1366][768].page_links)
SquadMenuSettings.pages.select_spawnpoint[1366][768].page_links.number_of_columns = 2
SquadMenuSettings.pages.select_spawnpoint[1366][768].spawnpoint = {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	screen_align_x = "right",
	screen_offset_y = 0,
	pivot_align_x = "right",
	pivot_offset_x = 0 * SCALE_1366,
	pivot_offset_y = 0 * SCALE_1366,
	background = {
		texture = "right_info_bgr_1920",
		texture_width = 700 * SCALE_1366,
		texture_height = 860 * SCALE_1366
	},
	map = {
		offset_x = 20 * SCALE_1366,
		offset_y = 226 * SCALE_1366
	},
	objectives_header = {
		font = MenuSettings.fonts.hell_shark_22,
		font_size = 22 * SCALE_1366,
		text_color = {
			255,
			255,
			255,
			255
		},
		text_offset_x = 22 * SCALE_1366,
		text_offset_y = 194 * SCALE_1366,
		drop_shadow_color = {
			120,
			0,
			0,
			0
		},
		drop_shadow_offset = {
			2 * SCALE_1366,
			-2 * SCALE_1366
		}
	},
	objectives_description = {
		text_align = "left",
		font = MenuSettings.fonts.hell_shark_16,
		font_size = 16 * SCALE_1366,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 18 * SCALE_1366,
		width = 580 * SCALE_1366,
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
		offset_x = 20 * SCALE_1366,
		offset_y = 190 * SCALE_1366
	},
	level_header = {
		font = MenuSettings.fonts.hell_shark_22,
		font_size = 22 * SCALE_1366,
		text_color = {
			255,
			255,
			255,
			255
		},
		text_offset_x = 22 * SCALE_1366,
		text_offset_y = -36 * SCALE_1366,
		drop_shadow_color = {
			120,
			0,
			0,
			0
		},
		drop_shadow_offset = {
			2 * SCALE_1366,
			-2 * SCALE_1366
		}
	},
	level_description = {
		text_align = "left",
		font = MenuSettings.fonts.hell_shark_16,
		font_size = 16 * SCALE_1366,
		color = {
			255,
			255,
			255,
			255
		},
		line_height = 18 * SCALE_1366,
		width = 580 * SCALE_1366,
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
		offset_x = 20 * SCALE_1366,
		offset_y = -38 * SCALE_1366
	},
	corner_top_texture = {
		texture = "item_list_top_corner_1920",
		texture_width = 416 * SCALE_1366,
		texture_height = 308 * SCALE_1366,
		texture_offset_x = 290 * SCALE_1366,
		texture_offset_y = 542 * SCALE_1366
	}
}
SquadMenuSettings.pages.select_spawnpoint[1366][768].button_info = {
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
SquadMenuSettings.pages.level_2_character_profiles[1366] = SquadMenuSettings.pages.level_2_character_profiles[1366] or {}
SquadMenuSettings.pages.level_2_character_profiles[1366][768] = SquadMenuSettings.pages.level_2_character_profiles[1366][768] or table.clone(MainMenuSettings.pages.level_2_character_profiles[1366][768])
SquadMenuSettings.pages.level_2_character_profiles[1366][768].page_links = table.clone(SquadMenuSettings.pages.select_team[1366][768].page_links)
SquadMenuSettings.background_container = SquadMenuSettings.background_container or {}
SquadMenuSettings.background_container[1366] = SquadMenuSettings.background_container[1366] or {}
SquadMenuSettings.background_container[1366][768] = SquadMenuSettings.background_container[1366][768] or {
	x = 0,
	z = 0,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 2,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 1470 * SCALE_1366,
	height = 820 * SCALE_1366,
	row_heights = {
		445 * SCALE_1366,
		375 * SCALE_1366
	}
}
SquadMenuSettings.squad_grid_container = SquadMenuSettings.squad_grid_container or {}
SquadMenuSettings.squad_grid_container[1366] = SquadMenuSettings.squad_grid_container[1366] or {}
SquadMenuSettings.squad_grid_container[1366][768] = SquadMenuSettings.squad_grid_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 4,
	num_rows = 2,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 1440 * SCALE_1366,
	height = 425 * SCALE_1366
}
SquadMenuSettings.squadless_container = SquadMenuSettings.squadless_container or {}
SquadMenuSettings.squadless_container[1366] = SquadMenuSettings.squadless_container[1366] or {}
SquadMenuSettings.squadless_container[1366][768] = SquadMenuSettings.squadless_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 3,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685 * SCALE_1366,
	height = 330 * SCALE_1366,
	row_heights = {
		37 * SCALE_1366,
		30 * SCALE_1366,
		263 * SCALE_1366
	}
}
SquadMenuSettings.squadless_header_container = SquadMenuSettings.squadless_header_container or {}
SquadMenuSettings.squadless_header_container[1366] = SquadMenuSettings.squadless_header_container[1366] or {}
SquadMenuSettings.squadless_header_container[1366][768] = SquadMenuSettings.squadless_header_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685 * SCALE_1366,
	height = 37 * SCALE_1366
}
SquadMenuSettings.squadless_header_background = SquadMenuSettings.squadless_header_background or {}
SquadMenuSettings.squadless_header_background[1366] = SquadMenuSettings.squadless_header_background[1366] or {}
SquadMenuSettings.squadless_header_background[1366][768] = SquadMenuSettings.squadless_header_background[1366][768] or {
	texture_name = "squad_menu_banner_lonewolfs",
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685 * SCALE_1366,
	height = 37 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squadless_header_text = SquadMenuSettings.squadless_header_text or {}
SquadMenuSettings.squadless_header_text[1366] = SquadMenuSettings.squadless_header_text[1366] or {}
SquadMenuSettings.squadless_header_text[1366][768] = SquadMenuSettings.squadless_header_text[1366][768] or {
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
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squadless_container = SquadMenuSettings.join_squadless_container or {}
SquadMenuSettings.join_squadless_container[1366] = SquadMenuSettings.join_squadless_container[1366] or {}
SquadMenuSettings.join_squadless_container[1366][768] = SquadMenuSettings.join_squadless_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 685 * SCALE_1366,
	height = 30 * SCALE_1366
}
SquadMenuSettings.join_squadless_text = SquadMenuSettings.join_squadless_text or {}
SquadMenuSettings.join_squadless_text[1366] = SquadMenuSettings.join_squadless_text[1366] or {}
SquadMenuSettings.join_squadless_text[1366][768] = SquadMenuSettings.join_squadless_text[1366][768] or {
	scale = 1,
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
	width = 600 * SCALE_1366,
	height = 115 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_14,
	color = {
		255,
		235,
		235,
		235
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squadless_scroll_container = SquadMenuSettings.squadless_scroll_container or {}
SquadMenuSettings.squadless_scroll_container[1366] = SquadMenuSettings.squadless_scroll_container[1366] or {}
SquadMenuSettings.squadless_scroll_container[1366][768] = SquadMenuSettings.squadless_scroll_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	scroll_bar_width = 4,
	scroll_bar_alignment = "right",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	slider_margin = 1,
	width = 674 * SCALE_1366,
	height = 257 * SCALE_1366,
	slider_color = {
		180,
		220,
		220,
		220
	}
}
SquadMenuSettings.squadless_members_container = SquadMenuSettings.squadless_members_container or {}
SquadMenuSettings.squadless_members_container[1366] = SquadMenuSettings.squadless_members_container[1366] or {}
SquadMenuSettings.squadless_members_container[1366][768] = SquadMenuSettings.squadless_members_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "top",
	width = 330 * SCALE_1366,
	height = 0 * SCALE_1366
}
SquadMenuSettings.squadless_member_name = SquadMenuSettings.squadless_member_name or {}
SquadMenuSettings.squadless_member_name[1366] = SquadMenuSettings.squadless_member_name[1366] or {}
SquadMenuSettings.squadless_member_name[1366][768] = SquadMenuSettings.squadless_member_name[1366][768] or {
	horizontal_position_policy = "left",
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
	width = 300 * SCALE_1366,
	height = 30 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16_masked,
	color = {
		255,
		235,
		235,
		235
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_container = SquadMenuSettings.squad_container or {}
SquadMenuSettings.squad_container[1366] = SquadMenuSettings.squad_container[1366] or {}
SquadMenuSettings.squad_container[1366][768] = SquadMenuSettings.squad_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 1,
	num_rows = 3,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329 * SCALE_1366,
	height = 200 * SCALE_1366,
	row_heights = {
		37 * SCALE_1366,
		30 * SCALE_1366,
		133 * SCALE_1366
	}
}
SquadMenuSettings.squad_header_container = SquadMenuSettings.squad_header_container or {}
SquadMenuSettings.squad_header_container[1366] = SquadMenuSettings.squad_header_container[1366] or {}
SquadMenuSettings.squad_header_container[1366][768] = SquadMenuSettings.squad_header_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329 * SCALE_1366,
	height = 37 * SCALE_1366
}
SquadMenuSettings.squad_header_background = SquadMenuSettings.squad_header_background or {}
SquadMenuSettings.squad_header_background[1366] = SquadMenuSettings.squad_header_background[1366] or {}
SquadMenuSettings.squad_header_background[1366][768] = SquadMenuSettings.squad_header_background[1366][768] or {
	texture_name = "squad_menu_banner_squad",
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329 * SCALE_1366,
	height = 37 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_information_container = SquadMenuSettings.squad_header_information_container or {}
SquadMenuSettings.squad_header_information_container[1366] = SquadMenuSettings.squad_header_information_container[1366] or {}
SquadMenuSettings.squad_header_information_container[1366][768] = SquadMenuSettings.squad_header_information_container[1366][768] or {
	x = 0,
	z = 2,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	num_columns = 3,
	num_rows = 1,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329 * SCALE_1366,
	height = 37 * SCALE_1366,
	column_widths = {
		232 * SCALE_1366,
		56 * SCALE_1366,
		41 * SCALE_1366
	}
}
SquadMenuSettings.squad_header_text = SquadMenuSettings.squad_header_text or {}
SquadMenuSettings.squad_header_text[1366] = SquadMenuSettings.squad_header_text[1366] or {}
SquadMenuSettings.squad_header_text[1366][768] = SquadMenuSettings.squad_header_text[1366][768] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "auto",
	horizontal_position_policy = "left",
	localize_text = true,
	text = "squad_name",
	height_policy = "auto",
	y = 0,
	vertical_position_policy = "center",
	width = 0,
	offset_x = 15 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_lock_icon = SquadMenuSettings.squad_header_lock_icon or {}
SquadMenuSettings.squad_header_lock_icon[1366] = SquadMenuSettings.squad_header_lock_icon[1366] or {}
SquadMenuSettings.squad_header_lock_icon[1366][768] = SquadMenuSettings.squad_header_lock_icon[1366][768] or {
	texture_name = "squad_menu_locked",
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	highlighted_scale = 1.07,
	atlas_name = "menu_assets",
	x = 0,
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 24 * SCALE_1366,
	height = 20 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_animal_container = SquadMenuSettings.squad_header_animal_container or {}
SquadMenuSettings.squad_header_animal_container[1366] = SquadMenuSettings.squad_header_animal_container[1366] or {}
SquadMenuSettings.squad_header_animal_container[1366][768] = SquadMenuSettings.squad_header_animal_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 37 * SCALE_1366,
	height = 37 * SCALE_1366
}
SquadMenuSettings.squad_header_animal_background = SquadMenuSettings.squad_header_animal_background or {}
SquadMenuSettings.squad_header_animal_background[1366] = SquadMenuSettings.squad_header_animal_background[1366] or {}
SquadMenuSettings.squad_header_animal_background[1366][768] = SquadMenuSettings.squad_header_animal_background[1366][768] or {
	texture_name = "squad_menu_animal_bg",
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	x = 0,
	atlas_name = "menu_assets",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 52 * SCALE_1366,
	height = 52 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_header_animal_icon = SquadMenuSettings.squad_header_animal_icon or {}
SquadMenuSettings.squad_header_animal_icon[1366] = SquadMenuSettings.squad_header_animal_icon[1366] or {}
SquadMenuSettings.squad_header_animal_icon[1366][768] = SquadMenuSettings.squad_header_animal_icon[1366][768] or {
	texture_name = "squad_menu_animal_moose",
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
	width = 52 * SCALE_1366,
	height = 52 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squad_container = SquadMenuSettings.join_squad_container or {}
SquadMenuSettings.join_squad_container[1366] = SquadMenuSettings.join_squad_container[1366] or {}
SquadMenuSettings.join_squad_container[1366][768] = SquadMenuSettings.join_squad_container[1366][768] or {
	x = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	width = 329 * SCALE_1366,
	height = 30 * SCALE_1366
}
SquadMenuSettings.join_squad_text = SquadMenuSettings.join_squad_text or {}
SquadMenuSettings.join_squad_text[1366] = SquadMenuSettings.join_squad_text[1366] or {}
SquadMenuSettings.join_squad_text[1366][768] = SquadMenuSettings.join_squad_text[1366][768] or {
	scale = 1,
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
	width = 300 * SCALE_1366,
	height = 115 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_14,
	color = {
		255,
		235,
		235,
		235
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.join_squad_button_prompt = SquadMenuSettings.join_squad_button_prompt or {}
SquadMenuSettings.join_squad_button_prompt[1366] = SquadMenuSettings.join_squad_button_prompt[1366] or {}
SquadMenuSettings.join_squad_button_prompt[1366][768] = SquadMenuSettings.join_squad_button_prompt[1366][768] or {
	texture_name = "y",
	z = 1,
	width_policy = "defined",
	horizontal_position_policy = "center",
	scale = 1,
	atlas_name = "X360Buttons",
	asset_name = "x360_buttons",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "center",
	x = 0,
	width = 50 * SCALE_1366,
	height = 50 * SCALE_1366,
	offset_x = 75 * SCALE_1366,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.squad_members_container = SquadMenuSettings.squad_members_container or {}
SquadMenuSettings.squad_members_container[1366] = SquadMenuSettings.squad_members_container[1366] or {}
SquadMenuSettings.squad_members_container[1366][768] = SquadMenuSettings.squad_members_container[1366][768] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "defined",
	horizontal_position_policy = "left",
	height_policy = "defined",
	y = 0,
	vertical_position_policy = "top",
	width = 329 * SCALE_1366
}
SquadMenuSettings.squad_member_name = SquadMenuSettings.squad_member_name or {}
SquadMenuSettings.squad_member_name[1366] = SquadMenuSettings.squad_member_name[1366] or {}
SquadMenuSettings.squad_member_name[1366][768] = SquadMenuSettings.squad_member_name[1366][768] or {
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
	width = 300 * SCALE_1366,
	height = 30 * SCALE_1366,
	offset_x = 15 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		235,
		235,
		235
	},
	highlighted_color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.select_team_text = SquadMenuSettings.select_team_text or {}
SquadMenuSettings.select_team_text[1366] = SquadMenuSettings.select_team_text[1366] or {}
SquadMenuSettings.select_team_text[1366][768] = SquadMenuSettings.select_team_text[1366][768] or {
	height = 0,
	width_policy = "auto",
	scale = 1,
	x = 0,
	horizontal_position_policy = "left",
	text = "menu_select_team",
	vertical_position_policy = "bottom",
	z = 1,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "auto",
	y = 0,
	width = 0,
	offset_x = 75 * SCALE_1366,
	offset_y = 22 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_18,
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
SquadMenuSettings.page_name_text[1366] = SquadMenuSettings.page_name_text[1366] or {}
SquadMenuSettings.page_name_text[1366][768] = SquadMenuSettings.page_name_text[1366][768] or {
	x = 0,
	height = 0,
	z = 1,
	scale = 1,
	width_policy = "auto",
	horizontal_position_policy = "center",
	localize_text = true,
	text = "squad_manager_page_name",
	height_policy = "auto",
	y = 0,
	vertical_position_policy = "bottom",
	width = 0,
	offset_y = 22 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20,
	color = {
		255,
		255,
		255,
		255
	}
}
SquadMenuSettings.select_profile_text = SquadMenuSettings.select_profile_text or {}
SquadMenuSettings.select_profile_text[1366] = SquadMenuSettings.select_profile_text[1366] or {}
SquadMenuSettings.select_profile_text[1366][768] = SquadMenuSettings.select_profile_text[1366][768] or {
	height = 0,
	width_policy = "auto",
	scale = 1,
	x = 0,
	horizontal_position_policy = "right",
	text = "menu_select_character",
	vertical_position_policy = "bottom",
	z = 1,
	localize_text = true,
	highlighted_scale = 1.04,
	height_policy = "auto",
	y = 0,
	width = 0,
	offset_x = -75 * SCALE_1366,
	offset_y = 22 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_18,
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
