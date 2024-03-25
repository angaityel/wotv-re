-- chunkname: @scripts/menu/menu_definitions/profile_editor_settings_1366.lua

ProfileEditorSettings = ProfileEditorSettings or {}
ProfileEditorSettings.pages = ProfileEditorSettings.pages or {}
ProfileEditorSettings.items = ProfileEditorSettings.items or {}
ProfileEditorSettings.pages.profile_editor = ProfileEditorSettings.pages.profile_editor or {}
ProfileEditorSettings.pages.profile_editor[1366] = {}
ProfileEditorSettings.pages.profile_editor[1366][768] = {
	archetype = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.13,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 40,
			border_thickness = 4,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 300,
			border_corner_material = "menu_frame_corner",
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 10,
			offset_y = 8,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "center",
			font_size = 36,
			offset_x = 10,
			offset_y = 5,
			font = MenuSettings.fonts.hell_shark_36,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	primary_weapon = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.24,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 55,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 300,
			border_corner_material = "menu_frame_corner",
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 8,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	secondary_weapon = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.37,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 55,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 300,
			border_corner_material = "menu_frame_corner",
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 8,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	shield = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.5,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 55,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			width = 300,
			border_corner_material = "menu_frame_corner",
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			disabled_rect_color = {
				255,
				128,
				128,
				128
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 8,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	perk1 = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.68,
		pivot_align_x = "left",
		rect = {
			border_thickness = 3,
			width = 60 * SCALE_1366,
			height = 60 * SCALE_1366,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -5,
			size = {
				10 * SCALE_1366,
				10 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk2 = {
		screen_align_y = "top",
		screen_offset_x = 0.2,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.68,
		pivot_align_x = "left",
		rect = {
			border_thickness = 3,
			width = 60 * SCALE_1366,
			height = 60 * SCALE_1366,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -5,
			size = {
				10 * SCALE_1366,
				10 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk3 = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.8,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			width = 60 * SCALE_1366,
			height = 60 * SCALE_1366,
			rect_color = {
				192,
				255,
				255,
				255
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -5,
			size = {
				10 * SCALE_1366,
				10 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk4 = {
		screen_align_y = "top",
		screen_offset_x = 0.2,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.8,
		pivot_align_x = "left",
		rect = {
			border_thickness = 3,
			width = 60 * SCALE_1366,
			height = 60 * SCALE_1366,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -5,
			size = {
				10 * SCALE_1366,
				10 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	helmets = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		screen_offset_y = -0.12,
		pivot_align_x = "right",
		pivot_offset_x = -155 * SCALE_1366,
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			},
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	taunts = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.51,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			},
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	armours = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.12,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "outfit_atlas",
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			alignment = "towards_center",
			header_font_size = 18,
			highlight_timer = 0.3,
			avoid_mouse_over = true,
			spacing = 15,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	heads = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		screen_offset_y = -0.315,
		pivot_align_x = "right",
		pivot_offset_x = -155 * SCALE_1366,
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			},
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	cloaks = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.315,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	beards = {
		screen_align_y = "top",
		screen_offset_x = -0.08,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		screen_offset_y = -0.51,
		pivot_align_x = "right",
		pivot_offset_x = -155 * SCALE_1366,
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			border_corner_material = "menu_frame_corner",
			width = 110 * SCALE_1366,
			height = 130 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			disabled_rect_color = {
				255,
				120,
				120,
				120
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 6,
			offset_y = 7,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			},
			scale = SCALE_1366
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 21,
			texture_color = {
				255,
				255,
				255,
				255
			},
			scale = SCALE_1366
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	header_items = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_offset_x = 0,
		screen_offset_y = -0.1,
		pivot_align_x = "left",
		pivot_align_y = "top",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	next_link = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_align_y = "bottom",
		screen_align_x = "right",
		pivot_offset_y = 0
	},
	prev_link = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_align_y = "bottom",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	page_name = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	team_switch = {
		screen_align_y = "bottom",
		pivot_offset_x = 0,
		screen_offset_y = 0.08,
		pivot_align_x = "right",
		pivot_align_y = "bottom",
		screen_align_x = "right",
		pivot_offset_y = 0,
		screen_offset_x = -0
	},
	profile_viewer = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		rotation_rect = {
			screen_x = 0.3,
			marker_unit = "units/menu/projection_box",
			screen_height = 0.6,
			screen_y = 0.2,
			screen_width = 0.4,
			rotation_marker = true,
			rotation_marker_offset = {
				-0.05,
				0.5,
				0.5
			},
			rotation_marker_rotation = {
				0,
				0,
				1
			},
			rotation_marker_scale = {
				1,
				1,
				1
			}
		}
	},
	profile_info = {
		screen_align_y = "bottom",
		screen_offset_x = -0.013,
		pivot_offset_x = 0,
		screen_offset_y = 0.14,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	left_background = {
		screen_align_y = "center",
		screen_offset_x = 0.037,
		pivot_align_y = "top",
		height = 0.795,
		pivot_offset_y = 0,
		screen_align_x = "left",
		absolute_width = 338,
		pivot_offset_x = 0,
		screen_offset_y = 0.409,
		pivot_align_x = "left",
		border_size = 3,
		color = {
			100,
			0,
			0,
			0
		},
		border_color = {
			150,
			0,
			0,
			0
		}
	},
	right_background = {
		screen_align_y = "center",
		screen_offset_x = -0.065,
		pivot_align_y = "top",
		height = 0.587,
		pivot_offset_y = 0,
		screen_align_x = "right",
		absolute_width = 230,
		pivot_offset_x = 0,
		screen_offset_y = 0.409,
		pivot_align_x = "right",
		border_size = 3,
		color = {
			100,
			0,
			0,
			0
		},
		border_color = {
			150,
			0,
			0,
			0
		}
	},
	name_input = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = -0.065,
		pivot_align_x = "center",
		pivot_align_y = "top",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	profile_select = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = -0.06,
		pivot_align_x = "center",
		pivot_align_y = "top",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	profile_name = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = -0.055,
		pivot_align_x = "center",
		pivot_align_y = "top",
		screen_align_x = "center",
		pivot_offset_y = 0
	}
}
ProfileEditorSettings.pages.profile_editor_selection = ProfileEditorSettings.pages.profile_editor_selection or {}
ProfileEditorSettings.pages.profile_editor_selection[1366] = {}
ProfileEditorSettings.pages.profile_editor_selection[1366][768] = {
	archetype = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.14,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 35,
			border_thickness = 4,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 300,
			border_corner_material = "menu_frame_corner",
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 10,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15,
				15
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "center",
			font_size = 36,
			offset_x = 10,
			offset_y = 5,
			font = MenuSettings.fonts.hell_shark_36,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	primary_weapon = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.24,
		pivot_align_x = "right",
		rect = {
			border_material = "menu_frame_border",
			border_thickness = 3,
			height = 60,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			avoid_highlight = true,
			width = 300,
			border_corner_material = "menu_frame_corner",
			disabled_rect_color = {
				255,
				255,
				255,
				255
			},
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15,
				15
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	secondary_weapon = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.37,
		pivot_align_x = "right",
		rect = {
			border_material = "menu_frame_border",
			border_thickness = 3,
			height = 60,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			avoid_highlight = true,
			width = 300,
			border_corner_material = "menu_frame_corner",
			disabled_rect_color = {
				255,
				255,
				255,
				255
			},
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15,
				15
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	throwing_weapon = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.4,
		pivot_align_x = "right",
		rect = {
			border_material = "menu_frame_border",
			border_thickness = 3,
			height = 40,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			avoid_highlight = true,
			width = 300,
			border_corner_material = "menu_frame_corner",
			disabled_rect_color = {
				255,
				255,
				255,
				255
			},
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15,
				15
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	shield = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.5,
		pivot_align_x = "right",
		rect = {
			border_material = "menu_frame_border",
			border_thickness = 3,
			height = 60,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			avoid_highlight = true,
			width = 300,
			border_corner_material = "menu_frame_corner",
			disabled_rect_color = {
				255,
				255,
				255,
				255
			},
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 20,
			offset_x = 5,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15,
				15
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			scale = 0.5,
			atlas = "outfit_atlas"
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		},
		text = {
			align_x = "center",
			align_y = "top",
			font_size = 16,
			offset_x = 12,
			offset_y = -15,
			font = MenuSettings.fonts.hell_shark_16,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	perk1 = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = -255,
		screen_offset_y = -0.65,
		pivot_align_x = "right",
		rect = {
			height = 45,
			avoid_highlight = true,
			border_thickness = 3,
			width = 45,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 14,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_14,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				10,
				10
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk2 = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = -105,
		screen_offset_y = -0.65,
		pivot_align_x = "right",
		rect = {
			height = 45,
			avoid_highlight = true,
			border_thickness = 3,
			width = 45,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 14,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_14,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				10,
				10
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk3 = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = -255,
		screen_offset_y = -0.78,
		pivot_align_x = "right",
		rect = {
			height = 45,
			avoid_highlight = true,
			border_thickness = 3,
			width = 45,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 14,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_14,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				10,
				10
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	perk4 = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = -105,
		screen_offset_y = -0.78,
		pivot_align_x = "right",
		rect = {
			height = 45,
			avoid_highlight = true,
			border_thickness = 3,
			width = 45,
			rect_color = {
				90,
				0,
				0,
				0
			},
			border_color = {
				120,
				0,
				0,
				0
			},
			highlighted_rect_color = {
				160,
				0,
				0,
				0
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "center",
			align_y = "top",
			font_size = 14,
			offset_x = 0,
			offset_y = 10,
			font = MenuSettings.fonts.hell_shark_14,
			color = {
				255,
				255,
				255,
				255
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				10,
				10
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		lock = {
			lock_material = "lock",
			lock_atlas = "menu_assets",
			scale = 0.75,
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
			scale = 0.75,
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			spacing = 15,
			header_font_size = 18,
			border_thickness = 3,
			text_font_size = 13,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_18,
			text_font = MenuSettings.fonts.hell_shark_13,
			width = 500 * SCALE_1366,
			background_color = {
				255,
				60,
				60,
				60
			},
			border_color = {
				255,
				0,
				0,
				0
			},
			frame_color = {
				255,
				60,
				60,
				60
			},
			text_bg_color = {
				255,
				60,
				60,
				60
			}
		}
	},
	background = {
		screen_align_y = "center",
		screen_offset_x = -0.037,
		pivot_align_y = "top",
		height = 0.748,
		pivot_offset_y = 0,
		screen_align_x = "right",
		absolute_width = 340,
		pivot_offset_x = 0,
		screen_offset_y = 0.395,
		pivot_align_x = "right",
		border_size = 3,
		color = {
			100,
			0,
			0,
			0
		},
		border_color = {
			150,
			0,
			0,
			0
		}
	},
	menu_items = {
		spacing_y = 0,
		screen_offset_x = 0.05,
		align = "right",
		pivot_align_y = "top",
		screen_align_x = "left",
		num_columns = 1,
		spacing_x = 0,
		screen_align_y = "top",
		max_shown_items = 15,
		pivot_offset_y = 0,
		render_mask = true,
		using_container = true,
		pivot_offset_x = 0,
		screen_offset_y = -0.17,
		pivot_align_x = "left",
		texture = {
			texture_atlas = "menu_assets",
			material = "menu_frame_stone_texture",
			color = {
				255,
				255,
				255,
				255
			}
		},
		border = {
			corner_material = "menu_frame_corner",
			texture_atlas = "menu_assets",
			corner_small_material = "menu_frame_corner_small",
			material = "menu_frame_border",
			thickness = 5,
			color = {
				255,
				255,
				255,
				255
			},
			corner_offset = {
				5,
				-5
			},
			corner_small_offset = {
				1,
				-5
			}
		}
	},
	header_items = {
		screen_align_y = "top",
		screen_offset_x = -0.05,
		pivot_offset_x = 0,
		screen_offset_y = -0.1,
		pivot_align_x = "right",
		pivot_align_y = "top",
		screen_align_x = "right",
		pivot_offset_y = 0
	},
	prev_link = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_align_y = "bottom",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	back_list = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "right",
		pivot_align_y = "bottom",
		screen_align_x = "right",
		pivot_offset_y = 0
	},
	page_name = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	team_switch = {
		screen_align_y = "bottom",
		screen_offset_x = 0.05,
		pivot_offset_x = 0,
		screen_offset_y = 0.08,
		pivot_align_x = "left",
		pivot_align_y = "bottom",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	profile_info = {
		screen_align_y = "bottom",
		screen_offset_x = -0.013,
		pivot_offset_x = 0,
		screen_offset_y = 0.14,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	profile_viewer = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_align_y = "bottom",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		rotation_rect = {
			screen_x = 0.3,
			marker_unit = "units/menu/projection_box",
			screen_height = 0.6,
			screen_y = 0.2,
			screen_width = 0.4,
			rotation_marker = true,
			rotation_marker_offset = {
				-0.05,
				0.5,
				-0.3
			},
			rotation_marker_rotation = {
				0,
				0,
				1
			},
			rotation_marker_scale = {
				1,
				1,
				1
			}
		}
	},
	coat_of_arms_link = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_offset_x = 0,
		screen_offset_y = -0.14,
		pivot_align_x = "left",
		pivot_align_y = "top",
		screen_align_x = "left",
		pivot_offset_y = 0
	}
}
ProfileEditorSettings.pages.ingame_profile_editor_selection = ProfileEditorSettings.pages.ingame_profile_editor_selection or {}
ProfileEditorSettings.pages.ingame_profile_editor_selection[1366] = {}
ProfileEditorSettings.pages.ingame_profile_editor_selection[1366][768] = table.clone(ProfileEditorSettings.pages.profile_editor_selection[1366][768])
ProfileEditorSettings.pages.ingame_profile_editor_selection[1366][768].menu_items.num_columns = 1
ProfileEditorSettings.pages.wotv_coat_of_arms = ProfileEditorSettings.pages.wotv_coat_of_arms or {}
ProfileEditorSettings.pages.wotv_coat_of_arms[1366] = {}
ProfileEditorSettings.pages.wotv_coat_of_arms[1366][768] = {
	header_items = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_offset_x = 0,
		screen_offset_y = -0.1,
		pivot_align_x = "left",
		pivot_align_y = "top",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	icons = {
		color_size = {
			40 * SCALE_1366,
			40 * SCALE_1366
		},
		mask_size = {
			75 * SCALE_1366,
			75 * SCALE_1366
		}
	},
	base_color = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 60,
		screen_offset_y = -0.75,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 80 * SCALE_1366,
			height = 80 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		}
	},
	mid_color = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 60,
		screen_offset_y = -0.55,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 80 * SCALE_1366,
			height = 80 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		}
	},
	top_color = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 60,
		screen_offset_y = -0.35,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 80 * SCALE_1366,
			height = 80 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		}
	},
	charge_color = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 60,
		screen_offset_y = -0.15,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 80 * SCALE_1366,
			height = 80 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				15 * SCALE_1366,
				15 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		}
	},
	base_mask = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.75,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			border_corner_material = "menu_frame_corner",
			width = 100 * SCALE_1366,
			height = 150 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			disabled_rect_color = {
				255,
				255,
				255,
				255
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13 * SCALE_1366,
				13 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			hide_shadow = true,
			offset = 0,
			highlight_offset = 0,
			texture_size = {
				75 * SCALE_1366,
				75 * SCALE_1366
			}
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 20,
			offset_x = 76,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	mid_mask = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.55,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 100 * SCALE_1366,
			height = 150 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		texture = {
			hide_shadow = true,
			atlas = "heraldry_base",
			scale = 0.5,
			masked = true
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13 * SCALE_1366,
				13 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 20,
			offset_x = 76,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	top_mask = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.35,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 100 * SCALE_1366,
			height = 150 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13 * SCALE_1366,
				13 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			hide_shadow = true,
			atlas = "heraldry_vikings",
			scale = 0.5
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 20,
			offset_x = 76,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	charge_mask = {
		screen_align_y = "top",
		screen_offset_x = -0.15,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.15,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			border_corner_material = "menu_frame_corner",
			width = 100 * SCALE_1366,
			height = 150 * SCALE_1366,
			rect_color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				255,
				255,
				255,
				255
			},
			highlighted_rect_color = {
				255,
				192,
				192,
				192
			},
			highlighted_border_color = {
				192,
				0,
				0,
				0
			},
			border_corner_offset = {
				5,
				-5
			},
			border_corner_small_offset = {
				1,
				-5
			}
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13 * SCALE_1366,
				13 * SCALE_1366
			},
			color = {
				255,
				255,
				255,
				255
			},
			border_color = {
				225,
				0,
				0,
				0
			}
		},
		texture = {
			hide_shadow = true,
			atlas = "heraldry_saxons",
			scale = 0.25
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 20,
			offset_x = 76,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_20,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	prev_link = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		pivot_align_y = "bottom",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	page_name = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	team_switch = {
		screen_align_y = "bottom",
		screen_offset_x = 0.05,
		pivot_offset_x = 0,
		screen_offset_y = 0.08,
		pivot_align_x = "left",
		pivot_align_y = "bottom",
		screen_align_x = "left",
		pivot_offset_y = 0
	},
	profile_info = {
		screen_align_y = "bottom",
		screen_offset_x = -0.013,
		pivot_offset_x = 0,
		screen_offset_y = 0.14,
		pivot_align_x = "center",
		pivot_align_y = "bottom",
		screen_align_x = "center",
		pivot_offset_y = 0
	}
}
ProfileEditorSettings.pages.archetype = ProfileEditorSettings.pages.archetype or {}
ProfileEditorSettings.pages.archetype[1366] = {}
ProfileEditorSettings.pages.archetype[1366][768] = {
	archetype = {
		spacing_y = 10,
		z = 10,
		offset_x = 0,
		num_columns = 1,
		spacing_x = 10,
		max_shown_items = 100,
		offset_y = -30,
		rect = {
			color = {
				255,
				60,
				60,
				60
			}
		},
		border = {
			thickness = 3,
			color = {
				255,
				0,
				0,
				0
			}
		}
	}
}
ProfileEditorSettings.pages.category = ProfileEditorSettings.pages.category or {}
ProfileEditorSettings.pages.category[1366] = {}
ProfileEditorSettings.pages.category[1366][768] = {
	category = {
		spacing_y = 10,
		z = 10,
		offset_x = 0,
		num_columns = 1,
		spacing_x = 10,
		max_shown_items = 100,
		offset_y = -30,
		rect = {
			color = {
				255,
				60,
				60,
				60
			}
		},
		border = {
			thickness = 3,
			color = {
				255,
				0,
				0,
				0
			}
		}
	}
}
ProfileEditorSettings.pages.gear = ProfileEditorSettings.pages.gear or {}
ProfileEditorSettings.pages.gear[1366] = {}
ProfileEditorSettings.pages.gear[1366][768] = {
	gear = {
		screen_offset_y = 0.148,
		screen_offset_x = 0,
		align = "right",
		screen_align_x = "left",
		render_mask = true,
		num_columns = 1,
		max_shown_items = 5,
		screen_align_y = "bottom",
		spacing = 0,
		pivot_offset_y = 0,
		pivot_align_y = "top",
		pivot_offset_x = 40,
		pivot_align_x = "left",
		item_layout_settings = "ProfileEditorSettings.items.gear_item",
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.shield = ProfileEditorSettings.pages.shield or {}
ProfileEditorSettings.pages.shield[1366] = {}
ProfileEditorSettings.pages.shield[1366][768] = table.clone(ProfileEditorSettings.pages.gear[1366][768])
ProfileEditorSettings.pages.shield[1366][768].item_layout_settings = "ProfileEditorSettings.items.shield_item"
ProfileEditorSettings.pages.cosmetics = ProfileEditorSettings.pages.cosmetics or {}
ProfileEditorSettings.pages.cosmetics[1366] = {}
ProfileEditorSettings.pages.cosmetics[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 4,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 4,
		render_mask = true,
		pivot_offset_x = 62 * SCALE_1366,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.beard_hair_colors = ProfileEditorSettings.pages.beard_hair_colors or {}
ProfileEditorSettings.pages.beard_hair_colors[1366] = {}
ProfileEditorSettings.pages.beard_hair_colors[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 3,
		render_mask = true,
		pivot_offset_x = 40 * SCALE_1366,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.helmet_variations = ProfileEditorSettings.pages.helmet_variations or {}
ProfileEditorSettings.pages.helmet_variations[1366] = {}
ProfileEditorSettings.pages.helmet_variations[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 3,
		render_mask = true,
		pivot_offset_x = 40 * SCALE_1366,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.colors = ProfileEditorSettings.pages.colors or {}
ProfileEditorSettings.pages.colors[1366] = {}
ProfileEditorSettings.pages.colors[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		render_mask = true,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		max_shown_items = 8,
		pivot_align_y = "top",
		pivot_offset_x = -460,
		screen_offset_y = 0,
		pivot_align_x = "left",
		num_columns = 16,
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
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.charge_colors = ProfileEditorSettings.pages.charge_colors or {}
ProfileEditorSettings.pages.charge_colors[1366] = {}
ProfileEditorSettings.pages.charge_colors[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		render_mask = true,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		max_shown_items = 16,
		pivot_align_y = "top",
		pivot_offset_x = -460,
		screen_offset_y = 0,
		pivot_align_x = "left",
		num_columns = 16,
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
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.masks = ProfileEditorSettings.pages.masks or {}
ProfileEditorSettings.pages.masks[1366] = {}
ProfileEditorSettings.pages.masks[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		render_mask = true,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		max_shown_items = 4,
		pivot_align_y = "top",
		pivot_offset_x = -510,
		screen_offset_y = 0,
		pivot_align_x = "left",
		num_columns = 4,
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
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.cloak_patterns = ProfileEditorSettings.pages.cloak_patterns or {}
ProfileEditorSettings.pages.cloak_patterns[1366] = {}
ProfileEditorSettings.pages.cloak_patterns[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 4,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		max_shown_items = 5,
		render_mask = true,
		pivot_offset_x = 40 * SCALE_1366,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.perk = ProfileEditorSettings.pages.perk or {}
ProfileEditorSettings.pages.perk[1366] = {}
ProfileEditorSettings.pages.perk[1366][768] = {
	perk = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 2,
		pivot_offset_y = 0,
		align = "right",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 40,
		screen_offset_y = 0.148,
		pivot_align_x = "left",
		max_shown_items = 7,
		render_mask = true,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		}
	}
}
ProfileEditorSettings.pages.patterns = ProfileEditorSettings.pages.patterns or {}
ProfileEditorSettings.pages.patterns[1366] = {}
ProfileEditorSettings.pages.patterns[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		alings = "left",
		pivot_offset_y = 0,
		num_columns = 5,
		screen_align_x = "left",
		max_shown_items = 5,
		pivot_offset_x = -270,
		screen_offset_y = 0.029,
		pivot_align_x = "left",
		pivot_align_y = "top",
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.pages.cloaks = ProfileEditorSettings.pages.cloaks or {}
ProfileEditorSettings.pages.cloaks[1366] = {}
ProfileEditorSettings.pages.cloaks[1366][768] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		max_shown_items = 3,
		render_mask = true,
		pivot_offset_x = 62 * SCALE_1366,
		rect = {
			color = {
				120,
				0,
				0,
				0
			}
		},
		border = {
			thickness = 3,
			color = {
				150,
				0,
				0,
				0
			}
		},
		scroller_color = {
			255,
			215,
			215,
			215
		}
	}
}
ProfileEditorSettings.items.header = ProfileEditorSettings.items.header or {}
ProfileEditorSettings.items.header[1366] = {}
ProfileEditorSettings.items.header[1366][768] = {
	font_size = 28,
	align = "right",
	font = MenuSettings.fonts.hell_shark_28
}
ProfileEditorSettings.items.archetype_header = ProfileEditorSettings.items.archetype_header or {}
ProfileEditorSettings.items.archetype_header[1366] = {}
ProfileEditorSettings.items.archetype_header[1366][768] = {
	font_size = 40,
	align = "right",
	disabled_color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.coat_of_arms_header = ProfileEditorSettings.items.coat_of_arms_header or {}
ProfileEditorSettings.items.coat_of_arms_header[1366] = {}
ProfileEditorSettings.items.coat_of_arms_header[1366][768] = {
	disabled_color_func = "cb_team_color",
	font_size = 40,
	align = "left",
	font = MenuSettings.fonts.hell_shark_36,
	drop_shadow_color_disabled = {
		255,
		30,
		30,
		30
	},
	drop_shadow_offset = {
		4,
		-4
	}
}
ProfileEditorSettings.items.archetype_header_left = ProfileEditorSettings.items.archetype_header_left or {}
ProfileEditorSettings.items.archetype_header_left[1366] = {}
ProfileEditorSettings.items.archetype_header_left[1366][768] = {
	font_size = 28,
	align = "left",
	disabled_color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_28
}
ProfileEditorSettings.items.team_colored_header = ProfileEditorSettings.items.team_colored_header or {}
ProfileEditorSettings.items.team_colored_header[1366] = {}
ProfileEditorSettings.items.team_colored_header[1366][768] = {
	font_size = 36,
	align = "right",
	color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.team_colored_header_left = ProfileEditorSettings.items.team_colored_header_left or {}
ProfileEditorSettings.items.team_colored_header_left[1366] = {}
ProfileEditorSettings.items.team_colored_header_left[1366][768] = {
	font_size = 36,
	align = "left",
	color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.prev_link = ProfileEditorSettings.items.prev_link or {}
ProfileEditorSettings.items.prev_link[1366] = {}
ProfileEditorSettings.items.prev_link[1366][768] = {
	font_size = 20,
	z = 10,
	align = "left",
	padding_bottom = 20 * SCALE_1366,
	padding_left = 10 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20,
	highlight_color = {
		255,
		255,
		255,
		255
	},
	color = {
		255,
		203,
		100,
		25
	},
	disabled_color = {
		255,
		125,
		125,
		125
	}
}
ProfileEditorSettings.items.next_link = ProfileEditorSettings.items.next_link or {}
ProfileEditorSettings.items.next_link[1366] = {}
ProfileEditorSettings.items.next_link[1366][768] = {
	z = 10,
	font_size = 20,
	align = "right",
	padding_bottom = 20 * SCALE_1366,
	padding_right = 10 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20,
	highlight_color = {
		255,
		255,
		255,
		255
	},
	color = {
		255,
		203,
		100,
		25
	},
	disabled_color = {
		255,
		125,
		125,
		125
	}
}
ProfileEditorSettings.items.name = ProfileEditorSettings.items.name or {}
ProfileEditorSettings.items.name[1366] = {}
ProfileEditorSettings.items.name[1366][768] = {
	z = 10,
	font_size = 20,
	align = "center",
	padding_bottom = 20 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20
}
ProfileEditorSettings.items.profile_name = ProfileEditorSettings.items.profile_name or {}
ProfileEditorSettings.items.profile_name[1366] = {}
ProfileEditorSettings.items.profile_name[1366][768] = {
	z = 10,
	font_size = 20,
	align = "center",
	padding_bottom = 20,
	font = MenuSettings.fonts.hell_shark_20,
	disabled_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.category_item = ProfileEditorSettings.items.category_item or {}
ProfileEditorSettings.items.category_item[1366] = {}
ProfileEditorSettings.items.category_item[1366][768] = {
	texture_atlas = "menu_assets",
	texture_offset_y = -14,
	texture_offset_x = -27,
	text_offset_x = 10,
	texture = "new_icon_horizontal",
	z = 15,
	font_size = 20,
	border_thickness = 3,
	width = 392 * SCALE_1366,
	height = 60 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	disabled_text_color = {
		128,
		128,
		128,
		128
	},
	rect_height = 30 * SCALE_1366,
	rect_color = {
		90,
		0,
		0,
		0
	},
	border_color = {
		120,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		160,
		0,
		0,
		0
	},
	highlighted_border_color = {
		192,
		0,
		0,
		0
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	scale = SCALE_1366,
	disabled_text = {
		font_size = 13,
		text_offset_y = 30,
		text_offset_x = 12,
		font = MenuSettings.fonts.hell_shark_13,
		color = {
			255,
			255,
			49,
			18
		},
		drop_shadow_color = {
			255,
			0,
			0,
			0
		}
	},
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		alignment = "towards_center",
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		}
	}
}
ProfileEditorSettings.items.gear_item = ProfileEditorSettings.items.gear_item or {}
ProfileEditorSettings.items.gear_item[1366] = {}
ProfileEditorSettings.items.gear_item[1366][768] = {
	text_offset_z = 5,
	text_offset_y = -16,
	atlas = "outfit_atlas",
	padding_bottom = 21,
	align_text_x = "left",
	texture_offset_x = 6,
	padding_top = 21,
	rect_texture_atlas = "menu_assets",
	padding_left = 10,
	align_text_y = "top",
	text_offset_x = 7,
	rect_texture = "menu_frame_stone_texture",
	padding_right = 18,
	rect_texture_atlas_material = "menu_assets_masked",
	scale_on_highlight = 1.1,
	font_size = 20,
	border_thickness = 3,
	atlas_material = "outfit_atlas_masked",
	scale = 0.47,
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
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
	rect_color = {
		192,
		255,
		255,
		255
	},
	border_color = {
		192,
		90,
		90,
		90
	},
	highlighted_rect_color = {
		192,
		160,
		160,
		160
	},
	highlighted_border_color = {
		192,
		60,
		60,
		60
	},
	drop_shadow_color = {
		160,
		0,
		0,
		0
	},
	texture_background_rect = {
		texture = "menu_frame_stone_texture",
		texture_atlas = "menu_assets",
		height = 55,
		border_thickness = 3,
		border_texture_atlas = "menu_assets",
		border_corner_small_material = "menu_frame_corner_small",
		masked = true,
		border_material = "menu_frame_border",
		width = 240,
		border_corner_material = "menu_frame_corner",
		rect_color = {
			255,
			255,
			255,
			255
		},
		border_color = {
			255,
			255,
			255,
			255
		},
		highlighted_rect_color = {
			255,
			192,
			192,
			192
		},
		highlighted_border_color = {
			192,
			0,
			0,
			0
		},
		border_corner_offset = {
			5,
			-5
		},
		border_corner_small_offset = {
			1,
			-5
		}
	},
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		},
		price = {
			font_size = 16,
			align_x = "right",
			spacing = 0,
			z = 20,
			offset_x = -10,
			icon_atlas = "menu_assets",
			align_y = "top",
			icon_material = "ring",
			offset_y = -17,
			font = MenuSettings.fonts.hell_shark_16,
			icon_offset = {
				0,
				0
			},
			shadow_offset = {
				2,
				-2
			}
		}
	},
	price = {
		offset_x = -28,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = 7,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -28,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 32,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	new_item = {
		texture = "new_icon_tilted",
		texture_atlas_masked = "menu_assets_masked",
		texture_atlas = "menu_assets",
		texture_offset_y = 20,
		texture_offset_x = 197,
		texture_color = {
			255,
			255,
			255,
			255
		},
		scale = SCALE_1366
	}
}
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_stone = table.clone(ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect)
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_stone.texture = "menu_frame_stone_texture"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_stone.border_material = "menu_frame_border_bronze"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_stone.border_corner_material = "menu_frame_corner_bronze"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_stone.border_corner_small_material = "menu_frame_corner_small_bronze"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_wood = table.clone(ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect)
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_wood.texture = "menu_frame_wood_texture"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_wood.border_material = "menu_frame_border_silver"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_wood.border_corner_material = "menu_frame_corner_silver"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_wood.border_corner_small_material = "menu_frame_corner_small_silver"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_fabric = table.clone(ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect)
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_fabric.texture = "menu_frame_fabric_texture"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_fabric.border_material = "menu_frame_border_gold"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_fabric.border_corner_material = "menu_frame_corner_gold"
ProfileEditorSettings.items.gear_item[1366][768].texture_background_rect_fabric.border_corner_small_material = "menu_frame_corner_small_gold"
ProfileEditorSettings.items.shield_item = ProfileEditorSettings.items.shield_item or {}
ProfileEditorSettings.items.shield_item[1366] = {}
ProfileEditorSettings.items.shield_item[1366][768] = table.clone(ProfileEditorSettings.items.gear_item[1366][768])
ProfileEditorSettings.items.shield_item[1366][768].texture_offset_y = -40
ProfileEditorSettings.items.gear_item_with_background = ProfileEditorSettings.items.gear_item_with_background or {}
ProfileEditorSettings.items.gear_item_with_background[1366] = {}

local gear_item_with_background = table.clone(ProfileEditorSettings.items.gear_item[1366][768])

gear_item_with_background.text_background_texture = "menu_frame_stone_texture"
gear_item_with_background.text_background_atlas = "menu_assets"
gear_item_with_background.text_background_atlas_material = "menu_assets_masked"
gear_item_with_background.text_background_color = {
	150,
	0,
	0,
	0
}
ProfileEditorSettings.items.gear_item_with_background[1366][768] = gear_item_with_background
ProfileEditorSettings.items.mask_item = ProfileEditorSettings.items.mask_item or {}
ProfileEditorSettings.items.mask_item[1366] = {}
ProfileEditorSettings.items.mask_item[1366][768] = {
	text_offset_y = -5,
	padding_bottom = 12,
	align_text_x = "left",
	scale = 0.75,
	mask = "circle_mask",
	hide_shadow = true,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	padding_top = 12,
	scale_on_highlight = 1.1,
	padding_left = 10,
	texture_func = "cb_mask_material",
	font_size = 20,
	border_thickness = 3,
	padding_right = 10,
	hide_info = true,
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	price = {
		offset_x = -18,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = -7,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
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
ProfileEditorSettings.items.mask_item_mid = ProfileEditorSettings.items.mask_item_mid or {}
ProfileEditorSettings.items.mask_item_mid[1366] = {}
ProfileEditorSettings.items.mask_item_mid[1366][768] = {
	atlas = "heraldry_base",
	text_offset_y = -5,
	padding_bottom = 12,
	align_text_x = "left",
	scale = 0.5,
	padding_top = 12,
	hide_shadow = true,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	padding_left = 10,
	padding_right = 10,
	scale_on_highlight = 1.5,
	font_size = 20,
	border_thickness = 3,
	hide_info = true,
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		0,
		0,
		0,
		0
	},
	price = {
		offset_x = -18,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = -11,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -18,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 13,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
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
ProfileEditorSettings.items.mask_item_top = ProfileEditorSettings.items.mask_item_top or {}
ProfileEditorSettings.items.mask_item_top[1366] = {}
ProfileEditorSettings.items.mask_item_top[1366][768] = {
	atlas = "heraldry_base",
	text_offset_y = -5,
	padding_bottom = 12,
	align_text_x = "left",
	scale = 0.5,
	padding_top = 12,
	hide_shadow = true,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	padding_left = 10,
	padding_right = 10,
	scale_on_highlight = 1.25,
	font_size = 20,
	border_thickness = 3,
	hide_info = true,
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		0,
		0,
		0,
		0
	},
	price = {
		offset_x = -18,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = -11,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -18,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 13,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
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
ProfileEditorSettings.items.mask_item_charge = ProfileEditorSettings.items.mask_item_charge or {}
ProfileEditorSettings.items.mask_item_charge[1366] = {}
ProfileEditorSettings.items.mask_item_charge[1366][768] = {
	atlas_func = "cb_get_team_atlas",
	text_offset_y = -5,
	padding_bottom = 12,
	align_text_x = "left",
	scale = 0.25,
	padding_top = 12,
	hide_shadow = true,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	padding_left = 10,
	padding_right = 10,
	scale_on_highlight = 1.25,
	font_size = 20,
	border_thickness = 3,
	hide_info = true,
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		0,
		0,
		0,
		0
	},
	price = {
		offset_x = -18,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = -11,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -18,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 13,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
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
ProfileEditorSettings.items.color_item = ProfileEditorSettings.items.color_item or {}
ProfileEditorSettings.items.color_item[1366] = {}
ProfileEditorSettings.items.color_item[1366][768] = {
	text_offset_y = -5,
	scale_on_highlight = 1.5,
	padding_bottom = 2.5,
	align_text_x = "left",
	drop_shadow_offset = 1,
	padding_top = 2.5,
	align_text_y = "top",
	text_offset_x = 10,
	scale = 0.75,
	padding_left = 2.5,
	padding_right = 2.5,
	texture_func = "cb_color_material",
	font_size = 20,
	border_thickness = 3,
	hide_info = true,
	size = {
		25,
		25
	},
	font = MenuSettings.fonts.hell_shark_20_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	price = {
		offset_x = -5,
		align_x = "center",
		spacing = 0,
		font_size = 18,
		z = 200,
		masked = true,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = 35,
		font = MenuSettings.fonts.hell_shark_18_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			5,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 4,
			offset_x = 7,
			size_offset_x = -15,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -24,
		font_size = 16,
		masked = true,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 38,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 7,
			z = 9,
			offset_x = 3,
			size_offset_x = 0,
			border_thickness = 2,
			size_offset_y = -16,
			color = {
				255,
				45,
				45,
				45
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
ProfileEditorSettings.items.pattern_item = ProfileEditorSettings.items.pattern_item or {}
ProfileEditorSettings.items.pattern_item[1366] = {}
ProfileEditorSettings.items.pattern_item[1366][768] = {
	scale = 0.75,
	align_text_x = "left",
	scale_on_highlight = 1.25,
	align_text_y = "top",
	texture_func = "cb_pattern_material",
	font_size = 16,
	border_thickness = 3,
	hide_info = true,
	text_offset_x = 10 * SCALE_1366,
	text_offset_y = -5 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_16_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		255,
		255,
		255
	},
	border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		0,
		255,
		255,
		255
	},
	highlighted_border_color = {
		0,
		0,
		0,
		0
	},
	highlighted_texture_color = {
		255,
		255,
		255,
		255
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	padding_top = 10 * SCALE_1366,
	padding_bottom = 10 * SCALE_1366,
	padding_left = 23 * SCALE_1366,
	padding_right = 23 * SCALE_1366,
	price = {
		offset_x = -24,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = 0,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -24,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 23,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -4,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	new_item = {
		texture = "new_icon_horizontal",
		texture_atlas_masked = "menu_assets_masked",
		texture_atlas = "menu_assets",
		texture_offset_y = 88,
		texture_offset_x = -20,
		scale = 0.75,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.archetype_item = ProfileEditorSettings.items.archetype_item or {}
ProfileEditorSettings.items.archetype_item[1366] = {}
ProfileEditorSettings.items.archetype_item[1366][768] = {
	texture_atlas = "menu_assets",
	texture_offset_y = -14,
	texture_offset_x = -27,
	text_offset_x = 10,
	texture = "new_icon_horizontal",
	z = 15,
	font_size = 20,
	border_thickness = 3,
	width = 392 * SCALE_1366,
	height = 60 * SCALE_1366,
	font = MenuSettings.fonts.hell_shark_20,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	disabled_text_color = {
		128,
		128,
		128,
		128
	},
	rect_height = 30 * SCALE_1366,
	rect_color = {
		90,
		0,
		0,
		0
	},
	border_color = {
		120,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		160,
		0,
		0,
		0
	},
	highlighted_border_color = {
		192,
		0,
		0,
		0
	},
	texture_color = {
		255,
		255,
		255,
		255
	},
	scale = SCALE_1366,
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		alignment = "towards_center",
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		}
	}
}
ProfileEditorSettings.items.perk_item = ProfileEditorSettings.items.perk_item or {}
ProfileEditorSettings.items.perk_item[1366] = {}
ProfileEditorSettings.items.perk_item[1366][768] = {
	atlas = "menu_assets",
	texture_offset_x = 5,
	text_offset_y = -5,
	align_text_x = "left",
	texture_offset_y = 0,
	atlas_default_material = "perk_icon_no_perk_menu",
	align_text_y = "top",
	text_offset_x = 80,
	scale_on_highlight = 1.2,
	font_size = 14,
	border_thickness = 3,
	atlas_material = "menu_assets_masked",
	scale = 0.75,
	font = MenuSettings.fonts.hell_shark_14_masked,
	texture_size = {
		400 * SCALE_1366,
		51
	},
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	disabled_texture_colour = {
		120,
		120,
		120,
		120
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		0,
		0,
		0
	},
	border_color = {
		120,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		120,
		0,
		0,
		0
	},
	highlighted_border_color = {
		192,
		0,
		0,
		0
	},
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		},
		price = {
			font_size = 16,
			align_x = "right",
			spacing = 0,
			z = 20,
			offset_x = -10,
			icon_atlas = "menu_assets",
			align_y = "top",
			icon_material = "ring",
			offset_y = -17,
			font = MenuSettings.fonts.hell_shark_16,
			icon_offset = {
				0,
				0
			},
			shadow_offset = {
				2,
				-2
			}
		}
	},
	price = {
		masked = true,
		font_size = 16,
		align_x = "right",
		align_y = "bottom",
		icon_material = "ring",
		z = 10,
		spacing = 0,
		offset_x = -6,
		icon_scale = 0.65,
		icon_atlas = "menu_assets",
		offset_y = 7,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		text_color = {
			255,
			255,
			255,
			255
		},
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -3,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		masked = true,
		font_size = 16,
		align_x = "right",
		align_y = "bottom",
		icon_material = "lvl",
		z = 10,
		spacing = 0,
		offset_x = -6,
		icon_scale = 0.65,
		icon_atlas = "menu_assets",
		offset_y = 30,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			0,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -3,
			border_thickness = 1,
			size_offset_y = -6,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	new_item = {
		texture = "new_icon_horizontal",
		texture_atlas_masked = "menu_assets_masked",
		texture_atlas = "menu_assets",
		texture_offset_y = -2,
		texture_offset_x = 40,
		texture_color = {
			255,
			255,
			255,
			255
		},
		scale = SCALE_1366
	}
}
ProfileEditorSettings.items.helmet_item = ProfileEditorSettings.items.helmet_item or {}
ProfileEditorSettings.items.helmet_item[1366] = {}
ProfileEditorSettings.items.helmet_item[1366][768] = {
	atlas = "menu_assets",
	text_offset_y = -5,
	align_text_x = "left",
	hide_info = true,
	atlas_default_material = "perk_icon_no_perk_menu",
	align_text_y = "top",
	text_offset_x = 10,
	scale_on_highlight = 1.1,
	font_size = 16,
	border_thickness = 3,
	scale = 0.75,
	font = MenuSettings.fonts.hell_shark_16_masked,
	disabled_rect_color = {
		60,
		0,
		0,
		0
	},
	disabled_border_color = {
		90,
		0,
		0,
		0
	},
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		0,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		100,
		0,
		0,
		0
	},
	padding_top = 10 * SCALE_1366,
	padding_bottom = 10 * SCALE_1366,
	padding_left = 20 * SCALE_1366,
	padding_right = 20 * SCALE_1366,
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		},
		price = {
			font_size = 16,
			align_x = "right",
			spacing = 0,
			z = 20,
			offset_x = -10,
			icon_atlas = "menu_assets",
			align_y = "top",
			icon_material = "ring",
			offset_y = -17,
			font = MenuSettings.fonts.hell_shark_16,
			icon_offset = {
				0,
				0
			},
			shadow_offset = {
				2,
				-2
			}
		}
	},
	price = {
		offset_x = -22,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = 0,
		font = MenuSettings.fonts.hell_shark_16_masked,
		disabled_text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			2,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 3,
			z = 9,
			offset_x = 2,
			size_offset_x = -8,
			border_thickness = 1,
			size_offset_y = -8,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -22,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 22,
		font = MenuSettings.fonts.hell_shark_16_masked,
		text_color = {
			255,
			255,
			49,
			18
		},
		icon_offset = {
			2,
			0
		},
		shadow_offset = {
			2,
			-2
		},
		background_rect = {
			offset_y = 4,
			z = 9,
			offset_x = 2,
			size_offset_x = -8,
			border_thickness = 1,
			size_offset_y = -8,
			color = {
				255,
				45,
				45,
				45
			},
			border_color = {
				255,
				0,
				0,
				0
			}
		}
	},
	new_item = {
		texture = "new_icon_horizontal",
		texture_atlas_masked = "menu_assets_masked",
		texture_atlas = "menu_assets",
		texture_offset_y = 73,
		texture_offset_x = -14,
		scale = 0.75,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.beard_item = ProfileEditorSettings.items.beard_item or {}
ProfileEditorSettings.items.beard_item[1366] = {}
ProfileEditorSettings.items.beard_item[1366][768] = table.clone(ProfileEditorSettings.items.helmet_item[1366][768])
ProfileEditorSettings.items.beard_item[1366][768].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 102,
	texture_offset_x = -19,
	scale = 0.75,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.taunt_item = ProfileEditorSettings.items.taunt_item or {}
ProfileEditorSettings.items.taunt_item[1366] = {}
ProfileEditorSettings.items.taunt_item[1366][768] = table.clone(ProfileEditorSettings.items.helmet_item[1366][768])
ProfileEditorSettings.items.taunt_item[1366][768].padding_top = 10
ProfileEditorSettings.items.taunt_item[1366][768].padding_bottom = 10
ProfileEditorSettings.items.taunt_item[1366][768].padding_left = 15
ProfileEditorSettings.items.taunt_item[1366][768].padding_right = 15
ProfileEditorSettings.items.taunt_item[1366][768].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 85,
	texture_offset_x = -29,
	scale = 0.75,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.cloak_item = ProfileEditorSettings.items.cloak_item or {}
ProfileEditorSettings.items.cloak_item[1366] = {}
ProfileEditorSettings.items.cloak_item[1366][768] = table.clone(ProfileEditorSettings.items.helmet_item[1366][768])
ProfileEditorSettings.items.cloak_item[1366][768].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 68,
	texture_offset_x = -11,
	scale = 0.75,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.armour_item = ProfileEditorSettings.items.armour_item or {}
ProfileEditorSettings.items.armour_item[1366] = {}
ProfileEditorSettings.items.armour_item[1366][768] = {
	atlas = "outfit_atlas",
	text_offset_y = -5,
	align_text_x = "left",
	align_text_y = "top",
	text_offset_x = 10,
	font_size = 16,
	border_thickness = 3,
	atlas_material = "outfit_atlas_masked",
	scale = 0.75,
	font = MenuSettings.fonts.hell_shark_16_masked,
	highlighted_text_color = {
		255,
		255,
		255,
		255
	},
	text_color = {
		128,
		255,
		255,
		255
	},
	rect_color = {
		90,
		0,
		0,
		0
	},
	border_color = {
		120,
		0,
		0,
		0
	},
	highlighted_rect_color = {
		160,
		0,
		0,
		0
	},
	highlighted_border_color = {
		192,
		0,
		0,
		0
	},
	mouse_over = {
		header_spacing = 25,
		spacing = 15,
		header_font_size = 18,
		border_thickness = 3,
		text_font_size = 13,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_18,
		text_font = MenuSettings.fonts.hell_shark_13,
		width = 500 * SCALE_1366,
		background_color = {
			255,
			60,
			60,
			60
		},
		border_color = {
			255,
			0,
			0,
			0
		},
		frame_color = {
			255,
			60,
			60,
			60
		},
		text_bg_color = {
			255,
			60,
			60,
			60
		}
	}
}
ProfileEditorSettings.items.team_switch = ProfileEditorSettings.items.team_switch or {}
ProfileEditorSettings.items.team_switch[1366] = {}
ProfileEditorSettings.items.team_switch[1366][768] = {
	texture_atlas = "menu_assets",
	texture_white_highlighted = "team_icon_saxon_glow",
	switch_icon = "team_icon_switch",
	texture_white = "team_icon_saxon",
	z = 10,
	texture_red_highlighted = "team_icon_viking_glow",
	texture_red = "team_icon_viking",
	scale = 0.55,
	active_offset = {
		0.55,
		-0.05
	},
	inactive_offset = {
		0.15,
		-0.15
	}
}
ProfileEditorSettings.items.team_switch_right = ProfileEditorSettings.items.team_switch_right or {}
ProfileEditorSettings.items.team_switch_right[1366] = {}
ProfileEditorSettings.items.team_switch_right[1366][768] = {
	texture_atlas = "menu_assets",
	texture_white_highlighted = "team_icon_saxon_glow",
	switch_icon = "team_icon_switch",
	texture_white = "team_icon_saxon",
	align = "right",
	texture_red_highlighted = "team_icon_viking_glow",
	z = 10,
	texture_red = "team_icon_viking",
	scale = 0.55,
	active_offset = {
		0.55,
		-0.05
	},
	inactive_offset = {
		0.15,
		-0.15
	}
}
ProfileEditorSettings.items.text_item = ProfileEditorSettings.items.text_item or {}
ProfileEditorSettings.items.text_item[1366] = {}
ProfileEditorSettings.items.text_item[1366][768] = {
	padding_bottom = 7,
	padding_left = 20,
	rect_width = 300,
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
ProfileEditorSettings.items.text_item_right_aligned = ProfileEditorSettings.items.text_item_right_aligned or {}
ProfileEditorSettings.items.text_item_right_aligned[1366] = {}

local text_right_aligned = table.clone(ProfileEditorSettings.items.text_item_right_aligned[1680][1050])

text_right_aligned.font = MenuSettings.fonts.hell_shark_18_masked
text_right_aligned.font_size = 18
text_right_aligned.padding_top = 0
text_right_aligned.padding_bottom = 7
text_right_aligned.padding_left = 0
text_right_aligned.padding_right = 10
text_right_aligned.rect_width = 300
text_right_aligned.rect_height = 27
ProfileEditorSettings.items.text_item_right_aligned[1366][768] = text_right_aligned
ProfileEditorSettings.items.new_unlock_text_item_right_aligned = ProfileEditorSettings.items.new_unlock_text_item_right_aligned or {}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366] = {}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768] = table.clone(ProfileEditorSettings.items.text_item_right_aligned[1366][768])
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].unlock_texture_atlas = "menu_assets"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].unlock_texture = "new_icon_horizontal"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].texture_align_x = "left"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].texture_align_y = "center"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].texture_offset_x = 30
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].texture_offset_y = -1
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].texture_color = {
	255,
	255,
	255,
	255
}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].scale = SCALE_1366
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1366][768].required_rank = {
	offset_x = 30,
	icon_material = "lvl",
	icon_scale = 0.65,
	font_size = 16,
	masked = true,
	offset_z = 10,
	icon_atlas = "menu_assets",
	offset_y = 7,
	font = MenuSettings.fonts.hell_shark_16_masked,
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
ProfileEditorSettings.items.text_item_right_aligned = ProfileEditorSettings.items.text_item_right_aligned or {}
ProfileEditorSettings.items.text_item_right_aligned[1024] = {}

local text_right_aligned = table.clone(ProfileEditorSettings.items.text_item_right_aligned[1366][768])

text_right_aligned.font = MenuSettings.fonts.hell_shark_16_masked
text_right_aligned.font_size = 16
text_right_aligned.padding_top = 0
text_right_aligned.padding_bottom = 7
text_right_aligned.padding_left = 0
text_right_aligned.padding_right = 10
text_right_aligned.rect_width = 280
text_right_aligned.rect_height = 27
ProfileEditorSettings.items.text_item_right_aligned[1024][768] = text_right_aligned
ProfileEditorSettings.items.profile_name_input = ProfileEditorSettings.items.profile_name_input or {}
ProfileEditorSettings.items.profile_name_input[1366] = {}
ProfileEditorSettings.items.profile_name_input[1366][768] = {
	font_size = 30,
	height = 0,
	marker_offset_x = 11,
	text_offset_y = 0,
	marker_offset_y = -3,
	marker_height = 3,
	marker_width = 13,
	width = 0,
	font = MenuSettings.fonts.hell_shark_30,
	text_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.change_name_item = ProfileEditorSettings.items.change_name_item or {}
ProfileEditorSettings.items.change_name_item[1366] = {}
ProfileEditorSettings.items.change_name_item[1366][768] = {
	padding_bottom = 7,
	padding_left = 8,
	rect_width = 35,
	render_rect = true,
	padding_top = 7,
	rect_height = 25,
	line_height = 32,
	rect_offset_y = -5,
	masked = "rect_masked",
	padding_right = 0,
	spacing = 13,
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
ProfileEditorSettings.items.spawn_button = ProfileEditorSettings.items.spawn_button or {}
ProfileEditorSettings.items.spawn_button[1366] = {}
ProfileEditorSettings.items.spawn_button[1366][768] = {
	padding_bottom = 7,
	padding_left = 8,
	rect_width = 65,
	render_rect = true,
	padding_top = 7,
	rect_height = 25,
	line_height = 32,
	rect_offset_y = -5,
	masked = "rect_masked",
	padding_right = 0,
	spacing = 13,
	rect_offset_x = 0,
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
ProfileEditorSettings.items.text_item_unmasked = ProfileEditorSettings.items.text_item_unmasked or {}
ProfileEditorSettings.items.text_item_unmasked[1366] = {}
ProfileEditorSettings.items.text_item_unmasked[1366][768] = {
	padding_bottom = 7,
	padding_left = 10,
	render_rect = true,
	padding_top = 7,
	rect_height = 35,
	line_height = 32,
	rect_offset_y = -4,
	padding_right = 8,
	spacing = 13,
	rect_offset_x = 0,
	font_size = 20,
	border_thickness = 3,
	rect_width = 300,
	font = MenuSettings.fonts.hell_shark_20,
	color = {
		255,
		255,
		255,
		255
	},
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
ProfileEditorSettings.items.new_unlock_text_item_unmasked = ProfileEditorSettings.items.new_unlock_text_item_unmasked or {}
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366] = {}
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768] = table.clone(ProfileEditorSettings.items.text_item_unmasked[1366][768])
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].unlock_texture_atlas = "menu_assets"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].unlock_texture = "new_icon_horizontal"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].texture_align_x = "left"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].texture_align_y = "center"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].texture_offset_x = 2
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].texture_offset_y = -4
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].texture_color = {
	255,
	255,
	255,
	255
}
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768].scale = SCALE_1366
ProfileEditorSettings.items.coat_of_arms_header_item = ProfileEditorSettings.items.coat_of_arms_header_item or {}
ProfileEditorSettings.items.coat_of_arms_header_item[1366] = {}
ProfileEditorSettings.items.coat_of_arms_header_item[1366][768] = table.clone(ProfileEditorSettings.items.new_unlock_text_item_unmasked[1366][768])
ProfileEditorSettings.items.coat_of_arms_header_item[1366][768].text_alignment = "right"
ProfileEditorSettings.items.coat_of_arms_header_item[1366][768].texture_background_rect = {
	texture = "menu_frame_stone_texture",
	texture_atlas = "menu_assets",
	height = 30,
	border_thickness = 3,
	border_texture_atlas = "menu_assets",
	border_corner_small_material = "menu_frame_corner_small",
	border_material = "menu_frame_border",
	width = 300,
	border_corner_material = "menu_frame_corner",
	rect_color = {
		255,
		255,
		255,
		255
	},
	border_color = {
		255,
		255,
		255,
		255
	},
	highlighted_rect_color = {
		255,
		192,
		192,
		192
	},
	highlighted_border_color = {
		192,
		0,
		0,
		0
	},
	border_corner_offset = {
		5,
		-5
	},
	border_corner_small_offset = {
		1,
		-5
	}
}
ProfileEditorSettings.items.next_arrow = ProfileEditorSettings.items.next_arrow or {}
ProfileEditorSettings.items.next_arrow[1366] = {}
ProfileEditorSettings.items.next_arrow[1366][768] = ProfileEditorSettings.items.next_arrow[1366][768] or {
	padding_bottom = 0,
	z = 100,
	offset_x = 10,
	padding_left = 0,
	arrow_size_x = 10,
	arrow_size_y = 10,
	arrow_facing = "right",
	offset_y = 21,
	padding_top = 0,
	drop_shadow = true,
	padding_right = 0,
	color = {
		192,
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
		2,
		2
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
ProfileEditorSettings.items.prev_arrow = ProfileEditorSettings.items.prev_arrow or {}
ProfileEditorSettings.items.prev_arrow[1366] = {}
ProfileEditorSettings.items.prev_arrow[1366][768] = ProfileEditorSettings.items.prev_arrow[1366][768] or {
	padding_bottom = 0,
	z = 100,
	offset_x = -300,
	padding_left = 0,
	arrow_size_x = 10,
	arrow_size_y = 10,
	arrow_facing = "left",
	offset_y = 32,
	padding_top = 0,
	drop_shadow = true,
	padding_right = 0,
	color = {
		192,
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
		2,
		2
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
ProfileEditorSettings.items.next_arrow_left = ProfileEditorSettings.items.next_arrow_left or {}
ProfileEditorSettings.items.next_arrow_left[1366] = {}
ProfileEditorSettings.items.next_arrow_left[1366][768] = ProfileEditorSettings.items.next_arrow_left[1366][768] or {
	padding_bottom = 0,
	z = 100,
	offset_x = 270,
	padding_left = 0,
	arrow_size_x = 10,
	arrow_size_y = 10,
	arrow_facing = "right",
	offset_y = 10,
	disabled_func = "cb_controller_enabled",
	drop_shadow = true,
	padding_right = 0,
	padding_top = 0,
	color = {
		192,
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
		2,
		2
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
ProfileEditorSettings.items.prev_arrow_left = ProfileEditorSettings.items.prev_arrow_left or {}
ProfileEditorSettings.items.prev_arrow_left[1366] = {}
ProfileEditorSettings.items.prev_arrow_left[1366][768] = ProfileEditorSettings.items.prev_arrow_left[1366][768] or {
	padding_bottom = 0,
	z = 100,
	offset_x = -270,
	padding_left = 0,
	arrow_size_x = 10,
	arrow_size_y = 10,
	arrow_facing = "left",
	offset_y = 0,
	disabled_func = "cb_controller_enabled",
	drop_shadow = true,
	padding_right = 0,
	padding_top = 0,
	color = {
		192,
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
		2,
		2
	},
	drop_shadow_color = {
		196,
		0,
		0,
		0
	}
}
ProfileEditorSettings.items.tier_item = ProfileEditorSettings.items.tier_item or {}
ProfileEditorSettings.items.tier_item[1366] = {}
ProfileEditorSettings.items.tier_item[1366][768] = ProfileEditorSettings.items.tier_item[1366][768] or {
	z = 10,
	font_size = 22,
	align = "center",
	padding_bottom = 10,
	font = MenuSettings.fonts.hell_shark_22_masked,
	disabled_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.experience_item = ProfileEditorSettings.items.experience_item or {}
ProfileEditorSettings.items.experience_item[1366] = {}
ProfileEditorSettings.items.experience_item[1366][768] = ProfileEditorSettings.items.experience_item[1366][768] or {
	align_x = "center",
	offset_x = 0,
	z = 10,
	offset_y = 0,
	spacing_x = 10 * SCALE_1366,
	spacing_y = -45 * SCALE_1366,
	current_level_box = {
		text_color_func = "cb_team_color",
		header = "menu_level",
		font_size = 16,
		header_font_size = 13,
		rect_color = {
			196,
			30,
			30,
			30
		},
		header_text_color = {
			255,
			255,
			255,
			255
		},
		header_spacing = 5 * SCALE_1366,
		rect_size = {
			40 * SCALE_1366,
			25 * SCALE_1366
		},
		font = MenuSettings.fonts.hell_shark_16,
		header_font = MenuSettings.fonts.hell_shark_13
	},
	level_bar = {
		font_size = 13,
		xp_font_size = 16,
		bar_color_func = "cb_team_color",
		header = "menu_progress_xp",
		back_color_func = "cb_team_color",
		rect_color = {
			196,
			30,
			30,
			30
		},
		bg_color = {
			255,
			15,
			15,
			15
		},
		header_text_color = {
			255,
			255,
			255,
			255
		},
		rect_size = {
			250 * SCALE_1366,
			25 * SCALE_1366
		},
		inner_rect_size = {
			230 * SCALE_1366,
			17 * SCALE_1366
		},
		header_spacing = 5 * SCALE_1366,
		font = MenuSettings.fonts.hell_shark_13,
		xp_text_offset = {
			5,
			1.5
		},
		xp_font = MenuSettings.fonts.arial_16_masked,
		xp_text_color = {
			255,
			15,
			15,
			15
		},
		back_font = MenuSettings.fonts.arial_16
	},
	next_level_box = {
		font_size = 16,
		rect_color = {
			196,
			30,
			30,
			30
		},
		level_color = {
			255,
			128,
			128,
			128
		},
		rect_size = {
			40 * SCALE_1366,
			25 * SCALE_1366
		},
		font = MenuSettings.fonts.hell_shark_16
	},
	coins_bar = {
		header = "menu_coins",
		font_size = 13,
		coin_font_size = 16,
		icon_scale = 0.5,
		icon_atlas = "menu_assets",
		icon = "ring",
		rect_color = {
			196,
			30,
			30,
			30
		},
		rect_size = {
			250 * SCALE_1366,
			25 * SCALE_1366
		},
		header_text_color = {
			255,
			255,
			255,
			255
		},
		font = MenuSettings.fonts.hell_shark_13,
		coin_font = MenuSettings.fonts.hell_shark_16,
		header_spacing = 5 * SCALE_1366
	},
	buy_loot = {
		text = "buy_gold",
		font_size = 13,
		rect_color = {
			196,
			30,
			30,
			30
		},
		highlighted_rect_color = {
			196,
			30,
			30,
			30
		},
		rect_size = {
			90 * SCALE_1366,
			25 * SCALE_1366
		},
		font = MenuSettings.fonts.hell_shark_13,
		text_color = {
			255,
			255,
			255,
			255
		},
		highlighted_text_color = {
			255,
			255,
			255,
			0
		}
	},
	frame = {
		y_offset = -10,
		border_corner_small_material = "menu_frame_corner_small",
		width_offset = 20,
		height_offset = 30,
		border_texture_atlas = "menu_assets",
		x_offset = -10,
		border_material = "menu_frame_border",
		border_corner_material = "menu_frame_corner",
		border_corner_offset = {
			5,
			-5
		},
		border_corner_small_offset = {
			1,
			-5
		}
	},
	background_texture = {
		texture = "menu_frame_stone_texture",
		texture_atlas = "menu_assets",
		color = ColorBox(255, 255, 255, 255)
	}
}
