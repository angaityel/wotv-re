-- chunkname: @scripts/settings/menu_settings.lua

local FONT_GRADIENT_100, WOTR_HUD_TEXT_36, WOTR_HUD_TEXT_MATERIAL, FONT_GRADIENT_100_MATERIAL

if rawget(_G, "Steam") and Steam:language() == "ja" then
	FONT_GRADIENT_100 = {
		size = 36,
		font = "materials/fonts/hell_shark_36",
		material = "hell_shark_36",
		base_size = 29
	}
	WOTR_HUD_TEXT_36 = {
		size = 36,
		font = "materials/fonts/hell_shark_36",
		material = "hell_shark_36",
		base_size = 29
	}
	WOTR_HUD_TEXT_MATERIAL = "materials/fonts/hell_shark_font"
	FONT_GRADIENT_100_MATERIAL = "materials/fonts/hell_shark_font"
else
	FONT_GRADIENT_100 = {
		size = 100,
		font = "materials/fonts/font_gradient_100",
		material = "font_gradient_100",
		base_size = 79
	}
	WOTR_HUD_TEXT_36 = {
		material = "wotr_hud_text_36",
		font = "materials/fonts/wotr_hud_text_36"
	}
	WOTR_HUD_TEXT_MATERIAL = "materials/fonts/wotr_hud_text"
	FONT_GRADIENT_100_MATERIAL = "materials/fonts/font_gradient_100"
end

MenuSettings = {
	camera_lerp_speed = 3,
	news_ticker_speed = 110,
	double_click_threshold = 0.18,
	revision = {
		font_size = 18,
		font = "materials/fonts/hell_shark_18",
		material = "hell_shark_18",
		color = {
			255,
			255,
			255,
			255
		},
		shadow_color = {
			120,
			0,
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		position = {
			z = 999,
			x = -30,
			y = 20
		}
	},
	transitions = {
		fade_out_speed = 1,
		fade_in_speed = 1
	},
	viewports = {
		main_menu_profile_viewer = {
			units = {
				player_without_mount = {
					position_offset = Vector3Box(-0.2, 4.8, -0.7),
					rotation_offset = math.pi
				},
				player_with_mount = {
					position_offset = Vector3Box(-0.2, 4.2, -0.74),
					rotation_offset = math.pi
				},
				mount = {
					position_offset = Vector3Box(-0.6, 5.3, -0.66),
					rotation_offset = math.pi * 1.4
				}
			}
		},
		spawn_menu_profile_viewer = {
			units = {
				player_without_mount = {
					position_offset = Vector3Box(-0.2, 4.2, -0.74),
					rotation_offset = math.pi
				},
				player_with_mount = {
					position_offset = Vector3Box(-0.2, 4.2, -0.74),
					rotation_offset = math.pi
				},
				mount = {
					position_offset = Vector3Box(-0.6, 5.3, -0.66),
					rotation_offset = math.pi * 1.4
				}
			}
		},
		character_sheet_profile_viewer = {
			units = {
				player_without_mount = {
					position_offset = Vector3Box(-0.2, 2.5, -0.7),
					rotation_offset = math.pi
				}
			}
		},
		main_weapon_viewer = {
			default_camera_position = Vector3Box(0.4, 0, 0.4)
		},
		sidearm_viewer = {
			default_camera_position = Vector3Box(0.4, 0, 0.4)
		}
	},
	textures = {
		gear = {
			width = 256,
			height = 128
		},
		perks = {
			width = 128,
			height = 128
		},
		armour = {
			width = 256,
			height = 128
		},
		helmet = {
			width = 256,
			height = 128
		},
		mount = {
			width = 256,
			height = 128
		},
		loading_indicator = {
			width = 128,
			height = 128
		}
	},
	sounds = {
		buy_gold_success = "menu_buy_money",
		buy_item_success = "menu_buy_item",
		none = {
			page = {},
			items = {
				texture_button = {}
			}
		},
		profile_editor = {
			page = {
				back = "menu_exit_profile_editor"
			},
			items = {
				header_item = {
					hover = "menu_hover",
					select = "menu_select"
				},
				switch_item = {
					select = "menu_change_character"
				},
				gear_item = {
					hover = "menu_hover",
					select = "menu_select"
				},
				category_item = {
					hover = "menu_hover",
					select = "menu_select"
				},
				profile_container = {
					hover = "menu_hover",
					select = "menu_select"
				},
				cancel = {
					hover = "menu_hover",
					select = "menu_back"
				},
				text = {
					hover = "menu_hover",
					select = "menu_select"
				},
				texture_button = {
					hover = "menu_hover",
					select = "menu_select"
				}
			}
		},
		default = {
			page = {
				back = "menu_back"
			},
			items = {
				checkbox = {
					hover = "menu_hover",
					select = "menu_select"
				},
				coat_of_arms_color_picker = {
					hover = "menu_hover",
					select = "menu_select"
				},
				coat_of_arms = {
					hover = "menu_hover",
					select = "menu_select"
				},
				drop_down_list = {
					hover = "menu_hover",
					select = "menu_select"
				},
				enum = {
					hover = "menu_hover",
					select = "menu_select"
				},
				key_mapping = {
					hover = "menu_hover",
					select = "menu_select"
				},
				spawn_area_marker = {
					hover = "menu_hover",
					select = "menu_select"
				},
				squad_marker = {
					hover = "menu_hover",
					select = "menu_select"
				},
				text = {
					hover = "menu_hover",
					select = "menu_select"
				},
				texture_button = {
					hover = "menu_hover",
					select = "menu_select"
				},
				texture = {
					hover = "menu_hover",
					select = "menu_select"
				},
				progress_bar = {
					hover = "menu_hover",
					select = "menu_select"
				},
				text_input = {
					hover = "menu_hover",
					select = "menu_select"
				},
				text_box = {
					hover = "menu_hover",
					select = "menu_select"
				},
				server = {
					hover = "menu_hover",
					select = "menu_select"
				},
				scroll_bar = {
					hover = "menu_hover",
					select = "menu_select"
				},
				tab = {
					hover = "menu_hover",
					select = "menu_select"
				},
				scoreboard_player = {
					hover = "menu_hover",
					select = "menu_select"
				},
				loading_texture = {
					hover = "menu_hover",
					select = "menu_select"
				},
				battle_report_scoreboard = {
					hover = "menu_hover"
				},
				battle_report_summary = {},
				battle_report_summary_award = {},
				header_item = {
					hover = "menu_hover",
					select = "menu_select_header"
				},
				profile_editor = {
					hover = "menu_hover",
					select = "menu_open_profile_editor"
				},
				switch_item = {
					select = "menu_change_character"
				},
				gear_item = {
					hover = "menu_hover",
					select = "menu_select"
				},
				category_item = {
					hover = "menu_hover",
					select = "menu_select"
				},
				profile_container = {
					hover = "menu_hover",
					select = "menu_select"
				},
				cancel = {
					hover = "menu_hover",
					select = "menu_back"
				}
			}
		}
	},
	videos = {
		fatshark_splash = {
			sound_event = "fatshark_splash",
			video = "fatshark_splash",
			material = "video/fatshark_splash",
			ivf = "video/fatshark_splash"
		},
		paradox_splash = {
			video = "paradox_splash",
			material = "video/paradox_splash",
			ivf = "video/paradox_splash"
		},
		physx_splash = {
			video = "physx_splash",
			material = "video/physx_splash",
			ivf = "video/physx_splash"
		},
		wotv_splash = {
			video = "wotv_splash",
			material = "video/wotv_splash",
			ivf = "video/wotv_splash"
		},
		stalbans_intro = {
			video = "stalbans_intro",
			material = "video/stalbans_intro",
			ivf = "video/stalbans_intro"
		},
		mortimerscross_intro = {
			video = "mortimerscross_intro",
			material = "video/mortimerscross_intro",
			ivf = "video/mortimerscross_intro"
		},
		bamburgh_intro = {
			video = "bamburgh_intro",
			material = "video/bamburgh_intro",
			ivf = "video/bamburgh_intro"
		},
		tournament_intro = {
			video = "tournament_intro",
			material = "video/tournament_intro",
			ivf = "video/tournament_intro"
		},
		barnet_intro = {
			video = "barnet_intro",
			material = "video/barnet_intro",
			ivf = "video/barnet_intro"
		}
	},
	fonts = {
		hell_shark_11 = {
			size = 11,
			font = "materials/fonts/hell_shark_11",
			material = "hell_shark_11",
			base_size = 9
		},
		hell_shark_13 = {
			size = 13,
			font = "materials/fonts/hell_shark_13",
			material = "hell_shark_13",
			base_size = 10
		},
		hell_shark_14 = {
			size = 14,
			font = "materials/fonts/hell_shark_14",
			material = "hell_shark_14",
			base_size = 11
		},
		hell_shark_16 = {
			size = 16,
			font = "materials/fonts/hell_shark_16",
			material = "hell_shark_16",
			base_size = 13
		},
		hell_shark_18 = {
			size = 18,
			font = "materials/fonts/hell_shark_18",
			material = "hell_shark_18",
			base_size = 14
		},
		hell_shark_20 = {
			size = 20,
			font = "materials/fonts/hell_shark_20",
			material = "hell_shark_20",
			base_size = 16
		},
		hell_shark_italic_14 = {
			size = 14,
			font = "materials/fonts/hell_shark_italic_14",
			material = "hell_shark_italic_14",
			base_size = 11
		},
		hell_shark_italic_20 = {
			size = 20,
			font = "materials/fonts/hell_shark_italic_20",
			material = "hell_shark_italic_20",
			base_size = 16
		},
		hell_shark_22 = {
			size = 22,
			font = "materials/fonts/hell_shark_22",
			material = "hell_shark_22",
			base_size = 17
		},
		hell_shark_24 = {
			size = 24,
			font = "materials/fonts/hell_shark_24",
			material = "hell_shark_24",
			base_size = 19
		},
		hell_shark_26 = {
			size = 26,
			font = "materials/fonts/hell_shark_26",
			material = "hell_shark_26",
			base_size = 21
		},
		hell_shark_28 = {
			size = 28,
			font = "materials/fonts/hell_shark_28",
			material = "hell_shark_28",
			base_size = 22
		},
		hell_shark_30 = {
			size = 30,
			font = "materials/fonts/hell_shark_30",
			material = "hell_shark_30",
			base_size = 24
		},
		hell_shark_32 = {
			size = 32,
			font = "materials/fonts/hell_shark_32",
			material = "hell_shark_32",
			base_size = 26
		},
		hell_shark_36 = {
			size = 36,
			font = "materials/fonts/hell_shark_36",
			material = "hell_shark_36",
			base_size = 29
		},
		hell_shark_11_masked = {
			size = 11,
			font = "materials/fonts/hell_shark_11",
			material = "hell_shark_11_masked",
			base_size = 9
		},
		hell_shark_13_masked = {
			size = 13,
			font = "materials/fonts/hell_shark_13",
			material = "hell_shark_13_masked",
			base_size = 10
		},
		hell_shark_14_masked = {
			size = 14,
			font = "materials/fonts/hell_shark_14",
			material = "hell_shark_14_masked",
			base_size = 11
		},
		hell_shark_16_masked = {
			size = 16,
			font = "materials/fonts/hell_shark_16",
			material = "hell_shark_16_masked",
			base_size = 13
		},
		hell_shark_18_masked = {
			size = 18,
			font = "materials/fonts/hell_shark_18",
			material = "hell_shark_18_masked",
			base_size = 14
		},
		hell_shark_20_masked = {
			size = 20,
			font = "materials/fonts/hell_shark_20",
			material = "hell_shark_20_masked",
			base_size = 16
		},
		hell_shark_italic_14_masked = {
			size = 14,
			font = "materials/fonts/hell_shark_italic_14",
			material = "hell_shark_italic_14_masked",
			base_size = 11
		},
		hell_shark_italic_20_masked = {
			size = 20,
			font = "materials/fonts/hell_shark_italic_20",
			material = "hell_shark_italic_20_masked",
			base_size = 16
		},
		hell_shark_22_masked = {
			size = 22,
			font = "materials/fonts/hell_shark_22",
			material = "hell_shark_22_masked",
			base_size = 17
		},
		hell_shark_24_masked = {
			size = 24,
			font = "materials/fonts/hell_shark_24",
			material = "hell_shark_24_masked",
			base_size = 19
		},
		hell_shark_26_masked = {
			size = 26,
			font = "materials/fonts/hell_shark_26",
			material = "hell_shark_26_masked",
			base_size = 21
		},
		hell_shark_28_masked = {
			size = 28,
			font = "materials/fonts/hell_shark_28",
			material = "hell_shark_28_masked",
			base_size = 22
		},
		hell_shark_30_masked = {
			size = 30,
			font = "materials/fonts/hell_shark_30",
			material = "hell_shark_30_masked",
			base_size = 24
		},
		hell_shark_32_masked = {
			size = 32,
			font = "materials/fonts/hell_shark_32",
			material = "hell_shark_32_masked",
			base_size = 26
		},
		hell_shark_36_masked = {
			size = 36,
			font = "materials/fonts/hell_shark_36",
			material = "hell_shark_36_masked",
			base_size = 29
		},
		font_gradient_100 = FONT_GRADIENT_100,
		arial_11 = {
			size = 11,
			font = "materials/fonts/arial_11",
			material = "arial_11",
			base_size = 9
		},
		arial_13 = {
			size = 13,
			font = "materials/fonts/arial_13",
			material = "arial_13",
			base_size = 11
		},
		arial_14 = {
			size = 14,
			font = "materials/fonts/arial_14",
			material = "arial_14",
			base_size = 11
		},
		arial_15 = {
			size = 15,
			font = "materials/fonts/arial_15",
			material = "arial_15",
			base_size = 12
		},
		arial_16 = {
			size = 16,
			font = "materials/fonts/arial_16",
			material = "arial_16",
			base_size = 13
		},
		arial_18 = {
			size = 18,
			font = "materials/fonts/arial_18",
			material = "arial_18",
			base_size = 15
		},
		arial_20 = {
			size = 20,
			font = "materials/fonts/arial_20",
			material = "arial_20",
			base_size = 16
		},
		arial_22 = {
			size = 22,
			font = "materials/fonts/arial_22",
			material = "arial_22",
			base_size = 18
		},
		arial_24 = {
			size = 24,
			font = "materials/fonts/arial_24",
			material = "arial_24",
			base_size = 19
		},
		arial_26 = {
			size = 26,
			font = "materials/fonts/arial_26",
			material = "arial_26",
			base_size = 21
		},
		arial_28 = {
			size = 28,
			font = "materials/fonts/arial_28",
			material = "arial_28",
			base_size = 23
		},
		arial_30 = {
			size = 30,
			font = "materials/fonts/arial_30",
			material = "arial_30",
			base_size = 24
		},
		arial_32 = {
			size = 32,
			font = "materials/fonts/arial_32",
			material = "arial_32",
			base_size = 26
		},
		arial_34 = {
			size = 34,
			font = "materials/fonts/arial_34",
			material = "arial_34",
			base_size = 27
		},
		arial_36 = {
			size = 36,
			font = "materials/fonts/arial_36",
			material = "arial_36",
			base_size = 29
		},
		arial_11_masked = {
			size = 11,
			font = "materials/fonts/arial_11",
			material = "arial_11_masked",
			base_size = 9
		},
		arial_13_masked = {
			size = 13,
			font = "materials/fonts/arial_13",
			material = "arial_13_masked",
			base_size = 11
		},
		arial_14_masked = {
			size = 14,
			font = "materials/fonts/arial_14",
			material = "arial_14_masked",
			base_size = 11
		},
		arial_15_masked = {
			size = 15,
			font = "materials/fonts/arial_15",
			material = "arial_15_masked",
			base_size = 12
		},
		arial_16_masked = {
			size = 16,
			font = "materials/fonts/arial_16",
			material = "arial_16_masked",
			base_size = 13
		},
		arial_18_masked = {
			size = 18,
			font = "materials/fonts/arial_18",
			material = "arial_18_masked",
			base_size = 15
		},
		arial_20_masked = {
			size = 20,
			font = "materials/fonts/arial_20",
			material = "arial_20_masked",
			base_size = 16
		},
		arial_22_masked = {
			size = 22,
			font = "materials/fonts/arial_22",
			material = "arial_22_masked",
			base_size = 18
		},
		arial_24_masked = {
			size = 24,
			font = "materials/fonts/arial_24",
			material = "arial_24_masked",
			base_size = 19
		},
		arial_26_masked = {
			size = 26,
			font = "materials/fonts/arial_26",
			material = "arial_26_masked",
			base_size = 21
		},
		arial_28_masked = {
			size = 28,
			font = "materials/fonts/arial_28",
			material = "arial_28_masked",
			base_size = 23
		},
		arial_30_masked = {
			size = 30,
			font = "materials/fonts/arial_30",
			material = "arial_30_masked",
			base_size = 24
		},
		arial_32_masked = {
			size = 32,
			font = "materials/fonts/arial_32",
			material = "arial_32_masked",
			base_size = 26
		},
		arial_34_masked = {
			size = 34,
			font = "materials/fonts/arial_34",
			material = "arial_34_masked",
			base_size = 27
		},
		arial_36_masked = {
			size = 36,
			font = "materials/fonts/arial_36",
			material = "arial_36_masked",
			base_size = 29
		},
		arial_masked = {
			size = 32,
			font = "materials/fonts/arial",
			material = "arial_masked",
			base_size = 26
		},
		arial = {
			size = 32,
			font = "materials/fonts/arial",
			material = "arial",
			base_size = 26
		},
		wotr_hud_text_36 = WOTR_HUD_TEXT_36,
		ingame_font = {
			material = "debug",
			font = "core/performance_hud/debug"
		},
		menu_font = {
			size = 16,
			font = "materials/fonts/arial_16",
			material = "arial_16",
			base_size = 13
		},
		player_name_font = {
			size = 16,
			font = "materials/fonts/arial_16",
			material = "arial_16",
			base_size = 13
		},
		viking_numbers_11 = {
			size = 11,
			font = "materials/fonts/viking_numbers_11",
			material = "viking_numbers_11",
			base_size = 10
		},
		viking_numbers_13 = {
			size = 13,
			font = "materials/fonts/viking_numbers_13",
			material = "viking_numbers_13",
			base_size = 12
		},
		viking_numbers_14 = {
			size = 14,
			font = "materials/fonts/viking_numbers_14",
			material = "viking_numbers_14",
			base_size = 13
		},
		viking_numbers_16 = {
			size = 16,
			font = "materials/fonts/viking_numbers_16",
			material = "viking_numbers_16",
			base_size = 15
		},
		viking_numbers_18 = {
			size = 18,
			font = "materials/fonts/viking_numbers_18",
			material = "viking_numbers_18",
			base_size = 17
		},
		viking_numbers_20 = {
			size = 20,
			font = "materials/fonts/viking_numbers_20",
			material = "viking_numbers_20",
			base_size = 18
		},
		viking_numbers_22 = {
			size = 22,
			font = "materials/fonts/viking_numbers_22",
			material = "viking_numbers_22",
			base_size = 20
		},
		viking_numbers_24 = {
			size = 24,
			font = "materials/fonts/viking_numbers_24",
			material = "viking_numbers_24",
			base_size = 22
		},
		viking_numbers_26 = {
			size = 26,
			font = "materials/fonts/viking_numbers_26",
			material = "viking_numbers_26",
			base_size = 24
		},
		viking_numbers_28 = {
			size = 28,
			font = "materials/fonts/viking_numbers_28",
			material = "viking_numbers_28",
			base_size = 26
		},
		viking_numbers_30 = {
			size = 30,
			font = "materials/fonts/viking_numbers_30",
			material = "viking_numbers_30",
			base_size = 28
		},
		viking_numbers_32 = {
			size = 32,
			font = "materials/fonts/viking_numbers_32",
			material = "viking_numbers_32",
			base_size = 29
		},
		viking_numbers_34 = {
			size = 34,
			font = "materials/fonts/viking_numbers_34",
			material = "viking_numbers_34",
			base_size = 31
		},
		viking_numbers_36 = {
			size = 36,
			font = "materials/fonts/viking_numbers_36",
			material = "viking_numbers_36",
			base_size = 33
		}
	}
}
MenuSettings.font_group_materials = {
	fat_unicorn = "materials/fonts/fat_unicorn_16",
	viking_numbers = "materials/fonts/viking_numbers_font",
	hell_shark = "materials/fonts/hell_shark_font",
	arial = "materials/fonts/arial",
	font_gradient_100 = FONT_GRADIENT_100_MATERIAL,
	wotr_hud_text = WOTR_HUD_TEXT_MATERIAL
}
