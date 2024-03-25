-- chunkname: @scripts/menu/menu_definitions/profile_editor_settings_1920.lua

ProfileEditorSettings = ProfileEditorSettings or {}
ProfileEditorSettings.pages = ProfileEditorSettings.pages or {}
ProfileEditorSettings.items = ProfileEditorSettings.items or {}
ProfileEditorSettings.pages.profile_editor = ProfileEditorSettings.pages.profile_editor or {}
ProfileEditorSettings.pages.profile_editor[1680] = {}
ProfileEditorSettings.pages.profile_editor[1680][1050] = {
	archetype = {
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.12,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 55,
			border_thickness = 4,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 400,
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			font_size = 40,
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
		screen_offset_y = -0.23,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 90,
			border_thickness = 4,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 400,
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
		texture = {
			scale = 0.8,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 90,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 400,
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
		texture = {
			scale = 0.8,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			height = 90,
			width = 400,
			border_corner_material = "menu_frame_corner",
			disabled_rect_color = {
				255,
				128,
				128,
				128
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
		texture = {
			scale = 0.75,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		screen_offset_x = 0.17,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.68,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 60,
			border_thickness = 3,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		screen_offset_x = 0.17,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = -0.8,
		pivot_align_x = "left",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -155,
		screen_offset_y = -0.12,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
			}
		},
		mouse_over = {
			header_spacing = 25,
			offset_y = 15,
			alignment = "towards_center",
			header_font_size = 20,
			highlight_timer = 0.3,
			avoid_mouse_over = true,
			spacing = 15,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			width = 500,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -155,
		screen_offset_y = -0.315,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -155,
		screen_offset_y = -0.51,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 130,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			width = 110,
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
			align = "left",
			border_thickness = 1.5,
			offset_x = 7,
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
			atlas = "menu_assets",
			drop_shadow_color = {
				90,
				0,
				0,
				0
			}
		},
		new_item = {
			texture = "new_icon_tilted",
			texture_atlas = "menu_assets",
			texture_offset_y = -2,
			texture_offset_x = 29,
			texture_color = {
				255,
				255,
				255,
				255
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		screen_offset_x = -0.05,
		pivot_offset_x = 0,
		screen_offset_y = 0.08,
		pivot_align_x = "right",
		pivot_align_y = "bottom",
		screen_align_x = "right",
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
		absolute_width = 450,
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
		absolute_width = 318,
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
		screen_offset_y = -0.065,
		pivot_align_x = "center",
		pivot_align_y = "top",
		screen_align_x = "center",
		pivot_offset_y = 0
	},
	profile_name = {
		screen_align_y = "top",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = -0.05,
		pivot_align_x = "center",
		pivot_align_y = "top",
		screen_align_x = "center",
		pivot_offset_y = 0
	}
}
ProfileEditorSettings.pages.profile_editor_selection = ProfileEditorSettings.pages.profile_editor_selection or {}
ProfileEditorSettings.pages.profile_editor_selection[1680] = {}
ProfileEditorSettings.pages.profile_editor_selection[1680][1050] = {
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
			height = 55,
			border_thickness = 4,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 400,
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			font_size = 40,
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
			height = 90,
			avoid_highlight = true,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			border_thickness = 3,
			width = 400,
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
		texture = {
			scale = 0.8,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
			height = 90,
			avoid_highlight = true,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			border_thickness = 3,
			width = 400,
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
		texture = {
			scale = 0.8,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		screen_offset_x = -0.05,
		pivot_align_y = "top",
		pivot_offset_y = 0,
		screen_align_x = "right",
		pivot_offset_x = 0,
		screen_offset_y = -0.5,
		pivot_align_x = "right",
		rect = {
			border_material = "menu_frame_border",
			height = 90,
			avoid_highlight = true,
			texture_atlas = "menu_assets",
			border_texture_atlas = "menu_assets",
			texture = "menu_frame_stone_texture",
			border_corner_small_material = "menu_frame_corner_small",
			border_thickness = 3,
			width = 400,
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
		texture = {
			scale = 0.8,
			atlas = "outfit_atlas"
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
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -340,
		screen_offset_y = -0.65,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			avoid_highlight = true,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -140,
		screen_offset_y = -0.65,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			avoid_highlight = true,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -340,
		screen_offset_y = -0.78,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			avoid_highlight = true,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		pivot_offset_x = -140,
		screen_offset_y = -0.78,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 60,
			border_thickness = 3,
			avoid_highlight = true,
			width = 60,
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
			font_size = 20,
			offset_x = -5,
			offset_y = 15,
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
			lock_color = {
				255,
				255,
				255,
				255
			}
		},
		texture = {
			atlas = "menu_assets",
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
			header_font_size = 20,
			border_thickness = 3,
			text_font_size = 16,
			header_color_func = "cb_team_color",
			alignment = "towards_center",
			width = 500,
			highlight_timer = 0.3,
			header_font = MenuSettings.fonts.hell_shark_20,
			text_font = MenuSettings.fonts.hell_shark_16,
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
		absolute_width = 450,
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
		screen_align_y = "top",
		screen_offset_x = 0.05,
		pivot_align_y = "top",
		max_shown_items = 15,
		pivot_offset_y = 0,
		align = "right",
		screen_align_x = "left",
		using_container = true,
		num_columns = 1,
		pivot_offset_x = 0,
		screen_offset_y = -0.17,
		pivot_align_x = "left",
		render_mask = true,
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
		pivot_offset_x = 6,
		screen_offset_y = -0.14,
		pivot_align_x = "left",
		pivot_align_y = "top",
		screen_align_x = "left",
		pivot_offset_y = 0
	}
}
ProfileEditorSettings.pages.ingame_profile_editor_selection = {}
ProfileEditorSettings.pages.ingame_profile_editor_selection[1680] = {}
ProfileEditorSettings.pages.ingame_profile_editor_selection[1680][1050] = table.clone(ProfileEditorSettings.pages.profile_editor_selection[1680][1050])
ProfileEditorSettings.pages.ingame_profile_editor_selection[1680][1050].menu_items.num_columns = 1
BASE_PROFILE_EDITOR_CONTAINER = {
	screen_align_y = "top",
	screen_offset_x = -0.05,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "right",
	pivot_offset_x = 0,
	screen_offset_y = -0.05,
	pivot_align_x = "right",
	rect = {
		texture = "menu_frame_stone_texture",
		texture_atlas = "menu_assets",
		height = 200,
		border_thickness = 3,
		border_texture_atlas = "menu_assets",
		border_corner_small_material = "menu_frame_corner_small",
		border_material = "menu_frame_border",
		width = 150,
		border_corner_material = "menu_frame_corner",
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
		width = 500,
		spacing = 15,
		header_font_size = 20,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
ProfileEditorSettings.pages.wotv_coat_of_arms = ProfileEditorSettings.pages.wotv_coat_of_arms or {}
ProfileEditorSettings.pages.wotv_coat_of_arms[1680] = {}
ProfileEditorSettings.pages.wotv_coat_of_arms[1680][1050] = {
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
			40,
			40
		},
		mask_size = {
			75,
			75
		}
	},
	base_color = {
		screen_align_y = "top",
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 40,
		screen_offset_y = -0.75,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 80,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 80,
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
		}
	},
	mid_color = {
		screen_align_y = "top",
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 40,
		screen_offset_y = -0.55,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 80,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 80,
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
		}
	},
	top_color = {
		screen_align_y = "top",
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 40,
		screen_offset_y = -0.35,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 80,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 80,
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
		}
	},
	charge_color = {
		screen_align_y = "top",
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 40,
		screen_offset_y = -0.15,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 80,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 80,
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
		}
	},
	base_mask = {
		screen_align_y = "top",
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.75,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 150,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_material = "menu_frame_border",
			border_corner_small_material = "menu_frame_corner_small",
			width = 100,
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
				13,
				13
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
				75,
				75
			}
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 24,
			offset_x = 102,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_24,
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
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.55,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 150,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 100,
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
		texture = {
			hide_shadow = true,
			atlas = "heraldry_base",
			scale = 0.5
		},
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13,
				13
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
			font_size = 24,
			offset_x = 102,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_24,
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
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.35,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 150,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 100,
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
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13,
				13
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
			atlas = "heraldry_base",
			scale = 0.5
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 24,
			offset_x = 102,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_24,
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
		screen_offset_x = -0.1,
		pivot_align_y = "top",
		pivot_offset_y = 70,
		screen_align_x = "right",
		pivot_offset_x = 160,
		screen_offset_y = -0.15,
		pivot_align_x = "right",
		rect = {
			texture = "menu_frame_stone_texture",
			texture_atlas = "menu_assets",
			height = 150,
			border_thickness = 3,
			border_texture_atlas = "menu_assets",
			border_corner_small_material = "menu_frame_corner_small",
			border_material = "menu_frame_border",
			width = 100,
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
		arrow = {
			align = "right",
			border_thickness = 1.5,
			offset_x = -5,
			offset_y = -10,
			size = {
				13,
				13
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
			scale = 0.25
		},
		header = {
			align_x = "left",
			align_y = "top",
			font_size = 24,
			offset_x = 102,
			offset_y = 12,
			font = MenuSettings.fonts.hell_shark_24,
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
ProfileEditorSettings.pages.archetype[1680] = {}
ProfileEditorSettings.pages.archetype[1680][1050] = {
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
ProfileEditorSettings.pages.category[1680] = {}
ProfileEditorSettings.pages.category[1680][1050] = {
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
ProfileEditorSettings.pages.gear[1680] = {}
ProfileEditorSettings.pages.gear[1680][1050] = {
	gear = {
		screen_offset_y = 0.139,
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
		pivot_offset_x = 45,
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
ProfileEditorSettings.pages.shield[1680] = {}
ProfileEditorSettings.pages.shield[1680][1050] = table.clone(ProfileEditorSettings.pages.gear[1680][1050])
ProfileEditorSettings.pages.shield[1680][1050].item_layout_settings = "ProfileEditorSettings.items.shield_item"
ProfileEditorSettings.pages.cosmetics = ProfileEditorSettings.pages.cosmetics or {}
ProfileEditorSettings.pages.cosmetics[1680] = {}
ProfileEditorSettings.pages.cosmetics[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 4,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 62,
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 4,
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
ProfileEditorSettings.pages.beard_hair_colors[1680] = {}
ProfileEditorSettings.pages.beard_hair_colors[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 40,
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 3,
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
ProfileEditorSettings.pages.helmet_variations[1680] = {}
ProfileEditorSettings.pages.helmet_variations[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		max_shown_items = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 40,
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		num_columns = 3,
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
ProfileEditorSettings.pages.colors[1680] = {}
ProfileEditorSettings.pages.colors[1680][1050] = {
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
		pivot_offset_x = -600,
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
ProfileEditorSettings.pages.charge_colors[1680] = {}
ProfileEditorSettings.pages.charge_colors[1680][1050] = {
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
		pivot_offset_x = -600,
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
ProfileEditorSettings.pages.masks[1680] = {}
ProfileEditorSettings.pages.masks[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		render_mask = true,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		max_shown_items = 5,
		pivot_align_y = "top",
		pivot_offset_x = -560,
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
ProfileEditorSettings.pages.patterns = ProfileEditorSettings.pages.patterns or {}
ProfileEditorSettings.pages.patterns[1680] = {}
ProfileEditorSettings.pages.patterns[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 5,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = -358,
		screen_offset_y = 0.029,
		pivot_align_x = "left",
		max_shown_items = 5,
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
ProfileEditorSettings.pages.cloaks[1680] = {}
ProfileEditorSettings.pages.cloaks[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 3,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 62,
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		max_shown_items = 3,
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
ProfileEditorSettings.pages.cloak_patterns[1680] = {}
ProfileEditorSettings.pages.cloak_patterns[1680][1050] = {
	gear = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 4,
		pivot_offset_y = 0,
		align = "left",
		screen_align_x = "left",
		pivot_align_y = "top",
		pivot_offset_x = 40,
		screen_offset_y = 0.029,
		pivot_align_x = "right",
		max_shown_items = 5,
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
ProfileEditorSettings.pages.perk[1680] = {}
ProfileEditorSettings.pages.perk[1680][1050] = {
	perk = {
		screen_align_y = "bottom",
		screen_offset_x = 0,
		spacing = 0,
		num_columns = 2,
		pivot_offset_y = 0,
		align = "right",
		screen_align_x = "left",
		render_mask = true,
		pivot_align_y = "top",
		pivot_offset_x = 45,
		screen_offset_y = 0.139,
		pivot_align_x = "left",
		max_shown_items = 7,
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
ProfileEditorSettings.items.header = ProfileEditorSettings.items.header or {}
ProfileEditorSettings.items.header[1680] = {}
ProfileEditorSettings.items.header[1680][1050] = {
	font_size = 40,
	align = "right",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.archetype_header = ProfileEditorSettings.items.archetype_header or {}
ProfileEditorSettings.items.archetype_header[1680] = {}
ProfileEditorSettings.items.archetype_header[1680][1050] = {
	font_size = 60,
	align = "right",
	disabled_color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.coat_of_arms_header = ProfileEditorSettings.items.coat_of_arms_header or {}
ProfileEditorSettings.items.coat_of_arms_header[1680] = {}
ProfileEditorSettings.items.coat_of_arms_header[1680][1050] = {
	disabled_color_func = "cb_team_color",
	font_size = 50,
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
ProfileEditorSettings.items.archetype_header_left[1680] = {}
ProfileEditorSettings.items.archetype_header_left[1680][1050] = {
	font_size = 40,
	align = "left",
	disabled_color_func = "cb_team_color",
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.text_item = ProfileEditorSettings.items.text_item or {}
ProfileEditorSettings.items.text_item[1680] = {}
ProfileEditorSettings.items.text_item[1680][1050] = {
	padding_bottom = 7,
	padding_left = 20,
	rect_width = 420,
	render_rect = true,
	padding_top = 7,
	rect_height = 35,
	line_height = 32,
	rect_offset_y = -5,
	masked = "rect_masked",
	padding_right = 20,
	spacing = 13,
	rect_offset_x = -10,
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
ProfileEditorSettings.items.text_item_right_aligned = ProfileEditorSettings.items.text_item_right_aligned or {}
ProfileEditorSettings.items.text_item_right_aligned[1680] = {}
ProfileEditorSettings.items.text_item_right_aligned[1680][1050] = {
	padding_top = 0,
	padding_left = 15,
	render_rect = true,
	text_alignment = "right",
	rect_width = 430,
	padding_bottom = 10,
	line_height = 32,
	rect_offset_y = 0,
	rect_height = 40,
	masked = "rect_masked",
	rect_offset_x = 0,
	padding_right = 15,
	spacing = 13,
	font_size = 28,
	border_thickness = 0.5,
	offset_z = 1,
	font = MenuSettings.fonts.hell_shark_28_masked,
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
		175,
		175,
		175
	},
	color_render_from_child_page = {
		160,
		0,
		0,
		0
	},
	rect_color = {
		0,
		0,
		0,
		0
	},
	rect_color_highlighted = {
		75,
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
ProfileEditorSettings.items.new_unlock_text_item_right_aligned = ProfileEditorSettings.items.new_unlock_text_item_right_aligned or {}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680] = {}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050] = table.clone(ProfileEditorSettings.items.text_item_right_aligned[1680][1050])
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].unlock_texture_atlas = "menu_assets"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].unlock_texture = "new_icon_horizontal"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].texture_align_x = "left"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].texture_align_y = "center"
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].texture_offset_x = 45
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].texture_offset_y = -1
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].texture_color = {
	255,
	255,
	255,
	255
}
ProfileEditorSettings.items.new_unlock_text_item_right_aligned[1680][1050].required_rank = {
	offset_x = 38,
	icon_material = "lvl",
	masked = true,
	font_size = 18,
	offset_z = 10,
	icon_atlas = "menu_assets",
	offset_y = 13,
	font = MenuSettings.fonts.hell_shark_18_masked,
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
ProfileEditorSettings.items.profile_name_input = ProfileEditorSettings.items.profile_name_input or {}
ProfileEditorSettings.items.profile_name_input[1680] = {}
ProfileEditorSettings.items.profile_name_input[1680][1050] = {
	font_size = 40,
	height = 0,
	marker_offset_x = 10,
	text_offset_y = 0,
	marker_offset_y = -3,
	marker_height = 4,
	marker_width = 15,
	width = 0,
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.change_name_item = ProfileEditorSettings.items.change_name_item or {}
ProfileEditorSettings.items.change_name_item[1680] = {}
ProfileEditorSettings.items.change_name_item[1680][1050] = {
	padding_bottom = 7,
	padding_left = 8,
	rect_width = 35,
	render_rect = true,
	padding_top = 7,
	rect_height = 35,
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
ProfileEditorSettings.items.text_item_unmasked = ProfileEditorSettings.items.text_item_unmasked or {}
ProfileEditorSettings.items.text_item_unmasked[1680] = {}
ProfileEditorSettings.items.text_item_unmasked[1680][1050] = {
	padding_bottom = 7,
	padding_left = 10,
	render_rect = true,
	padding_top = 10,
	rect_height = 35,
	line_height = 32,
	rect_offset_y = -2,
	padding_right = 8,
	spacing = 13,
	rect_offset_x = 0,
	font_size = 28,
	border_thickness = 3,
	rect_width = 420,
	font = MenuSettings.fonts.hell_shark_28,
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
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680] = {}
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050] = table.clone(ProfileEditorSettings.items.text_item_unmasked[1680][1050])
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].unlock_texture_atlas = "menu_assets"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].unlock_texture = "new_icon_horizontal"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].texture_align_x = "left"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].texture_align_y = "center"
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].texture_offset_x = 0
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].texture_offset_y = -3
ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050].texture_color = {
	255,
	255,
	255,
	255
}
ProfileEditorSettings.items.coat_of_arms_header_item = ProfileEditorSettings.items.coat_of_arms_header_item or {}
ProfileEditorSettings.items.coat_of_arms_header_item[1680] = {}
ProfileEditorSettings.items.coat_of_arms_header_item[1680][1050] = table.clone(ProfileEditorSettings.items.new_unlock_text_item_unmasked[1680][1050])
ProfileEditorSettings.items.coat_of_arms_header_item[1680][1050].text_alignment = "right"
ProfileEditorSettings.items.coat_of_arms_header_item[1680][1050].texture_background_rect = {
	texture = "menu_frame_stone_texture",
	texture_atlas = "menu_assets",
	height = 40,
	border_thickness = 3,
	border_texture_atlas = "menu_assets",
	border_corner_small_material = "menu_frame_corner_small",
	border_material = "menu_frame_border",
	width = 430,
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
ProfileEditorSettings.items.team_colored_header = ProfileEditorSettings.items.team_colored_header or {}
ProfileEditorSettings.items.team_colored_header[1680] = {}
ProfileEditorSettings.items.team_colored_header[1680][1050] = {
	color_func = "cb_team_color",
	font_size = 50,
	align = "right",
	padding_bottom = 5,
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.team_colored_header_left = ProfileEditorSettings.items.team_colored_header_left or {}
ProfileEditorSettings.items.team_colored_header_left[1680] = {}
ProfileEditorSettings.items.team_colored_header_left[1680][1050] = {
	color_func = "cb_team_color",
	font_size = 50,
	align = "left",
	padding_bottom = 3,
	font = MenuSettings.fonts.hell_shark_36
}
ProfileEditorSettings.items.prev_link = ProfileEditorSettings.items.prev_link or {}
ProfileEditorSettings.items.prev_link[1680] = {}
ProfileEditorSettings.items.prev_link[1680][1050] = {
	font_size = 28,
	z = 10,
	padding_left = 10,
	align = "left",
	padding_bottom = 20,
	font = MenuSettings.fonts.hell_shark_28,
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
ProfileEditorSettings.items.next_link[1680] = {}
ProfileEditorSettings.items.next_link[1680][1050] = {
	z = 10,
	font_size = 28,
	align = "right",
	padding_bottom = 20,
	padding_right = 10,
	font = MenuSettings.fonts.hell_shark_28,
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
ProfileEditorSettings.items.name[1680] = {}
ProfileEditorSettings.items.name[1680][1050] = {
	z = 10,
	font_size = 28,
	align = "center",
	padding_bottom = 20,
	font = MenuSettings.fonts.hell_shark_28
}
ProfileEditorSettings.items.profile_name = ProfileEditorSettings.items.profile_name or {}
ProfileEditorSettings.items.profile_name[1680] = {}
ProfileEditorSettings.items.profile_name[1680][1050] = {
	z = 10,
	font_size = 24,
	align = "center",
	padding_bottom = 20,
	font = MenuSettings.fonts.hell_shark_24,
	disabled_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.category_item = ProfileEditorSettings.items.category_item or {}
ProfileEditorSettings.items.category_item[1680] = {}
ProfileEditorSettings.items.category_item[1680][1050] = {
	height = 60,
	texture_atlas = "menu_assets",
	rect_height = 30,
	texture_offset_y = -20,
	texture_offset_x = -30,
	text_offset_x = 10,
	texture = "new_icon_horizontal",
	z = 10,
	font_size = 28,
	border_thickness = 3,
	width = 380,
	font = MenuSettings.fonts.hell_shark_28,
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
	disabled_text = {
		font_size = 16,
		text_offset_y = 43,
		text_offset_x = 12,
		font = MenuSettings.fonts.hell_shark_16,
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
		offset_y = 15,
		alignment = "towards_center",
		header_font_size = 20,
		highlight_timer = 0.3,
		text_width = 400,
		spacing = 15,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		width = 500,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
ProfileEditorSettings.items.gear_item[1680] = {}
ProfileEditorSettings.items.gear_item[1680][1050] = {
	atlas = "outfit_atlas",
	text_offset_y = -19,
	rect_texture_atlas = "menu_assets",
	padding_bottom = 24,
	align_text_x = "left",
	padding_top = 24,
	texture_offset_x = 7,
	padding_left = 14,
	padding_right = 22,
	align_text_y = "top",
	text_offset_x = 12,
	rect_texture = "menu_frame_stone_texture",
	rect_texture_atlas_material = "menu_assets_masked",
	scale_on_highlight = 1.1,
	font_size = 22,
	border_thickness = 3,
	atlas_material = "outfit_atlas_masked",
	scale = 0.77,
	font = MenuSettings.fonts.hell_shark_22_masked,
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
		height = 90,
		border_thickness = 3,
		border_texture_atlas = "menu_assets",
		border_corner_small_material = "menu_frame_corner_small",
		masked = true,
		border_material = "menu_frame_border",
		width = 365,
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
		offset_y = 15,
		header_font_size = 20,
		highlight_timer = 0.3,
		text_width = 400,
		spacing = 15,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		width = 500,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
		offset_x = -44,
		align_x = "right",
		spacing = 0,
		font_size = 16,
		masked = true,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "ring",
		offset_y = 12,
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
	},
	required_rank = {
		align_x = "right",
		spacing = 0,
		offset_x = -44,
		font_size = 16,
		masked = true,
		z = 10,
		icon_atlas = "menu_assets",
		align_y = "bottom",
		icon_material = "lvl",
		offset_y = 43,
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
	},
	new_item = {
		texture = "new_icon_tilted",
		texture_atlas_masked = "menu_assets_masked",
		texture_atlas = "menu_assets",
		texture_offset_y = 23,
		texture_offset_x = 302,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_stone = table.clone(ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect)
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_stone.texture = "menu_frame_stone_texture"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_stone.border_material = "menu_frame_border_bronze"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_stone.border_corner_material = "menu_frame_corner_bronze"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_stone.border_corner_small_material = "menu_frame_corner_small_bronze"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_wood = table.clone(ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect)
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_wood.texture = "menu_frame_wood_texture"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_wood.border_material = "menu_frame_border_silver"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_wood.border_corner_material = "menu_frame_corner_silver"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_wood.border_corner_small_material = "menu_frame_corner_small_silver"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_fabric = table.clone(ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect)
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_fabric.texture = "menu_frame_fabric_texture"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_fabric.border_material = "menu_frame_border_gold"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_fabric.border_corner_material = "menu_frame_corner_gold"
ProfileEditorSettings.items.gear_item[1680][1050].texture_background_rect_fabric.border_corner_small_material = "menu_frame_corner_small_gold"
ProfileEditorSettings.items.shield_item = ProfileEditorSettings.items.shield_item or {}
ProfileEditorSettings.items.shield_item[1680] = {}
ProfileEditorSettings.items.shield_item[1680][1050] = table.clone(ProfileEditorSettings.items.gear_item[1680][1050])
ProfileEditorSettings.items.shield_item[1680][1050].texture_offset_y = -40
ProfileEditorSettings.items.mask_item = ProfileEditorSettings.items.mask_item or {}
ProfileEditorSettings.items.mask_item[1680] = {}
ProfileEditorSettings.items.mask_item[1680][1050] = {
	text_offset_y = -5,
	padding_bottom = 12,
	align_text_x = "left",
	mask = "circle_mask",
	padding_top = 12,
	hide_shadow = true,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	scale_on_highlight = 1.1,
	padding_left = 10,
	padding_right = 10,
	texture_func = "cb_mask_material",
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
ProfileEditorSettings.items.mask_item_charge = ProfileEditorSettings.items.mask_item_charge or {}
ProfileEditorSettings.items.mask_item_charge[1680] = {}
ProfileEditorSettings.items.mask_item_charge[1680][1050] = {
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
ProfileEditorSettings.items.mask_item_top = ProfileEditorSettings.items.mask_item_top or {}
ProfileEditorSettings.items.mask_item_top[1680] = {}
ProfileEditorSettings.items.mask_item_top[1680][1050] = {
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
ProfileEditorSettings.items.mask_item_mid = ProfileEditorSettings.items.mask_item_mid or {}
ProfileEditorSettings.items.mask_item_mid[1680] = {}
ProfileEditorSettings.items.mask_item_mid[1680][1050] = {
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
ProfileEditorSettings.items.color_item = ProfileEditorSettings.items.color_item or {}
ProfileEditorSettings.items.color_item[1680] = {}
ProfileEditorSettings.items.color_item[1680][1050] = {
	text_offset_y = -5,
	scale_on_highlight = 1.25,
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
	font = MenuSettings.fonts.hell_shark_20_masked,
	size = {
		35,
		35
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
				30,
				30,
				30
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
			border_thickness = 2,
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
	}
}
ProfileEditorSettings.items.pattern_item = ProfileEditorSettings.items.pattern_item or {}
ProfileEditorSettings.items.pattern_item[1680] = {}
ProfileEditorSettings.items.pattern_item[1680][1050] = {
	text_offset_y = -5,
	scale_on_highlight = 1.25,
	padding_bottom = 10,
	align_text_x = "left",
	padding_top = 10,
	padding_left = 10,
	drop_shadow_offset = 1,
	align_text_y = "top",
	text_offset_x = 10,
	padding_right = 10,
	texture_func = "cb_pattern_material",
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
			offset_y = 4,
			z = 9,
			offset_x = 2,
			size_offset_x = -8,
			border_thickness = 2,
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
		offset_y = 24,
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
			border_thickness = 2,
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
		texture_offset_y = 115,
		texture_offset_x = -38,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.archetype_item = ProfileEditorSettings.items.archetype_item or {}
ProfileEditorSettings.items.archetype_item[1680] = {}
ProfileEditorSettings.items.archetype_item[1680][1050] = {
	texture_atlas = "menu_assets",
	rect_height = 30,
	text_offset_y = 4,
	height = 60,
	texture_offset_x = -30,
	texture_offset_y = -20,
	text_offset_x = 10,
	texture = "new_icon_horizontal",
	z = 10,
	font_size = 28,
	border_thickness = 3,
	width = 380,
	font = MenuSettings.fonts.hell_shark_28,
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
	mouse_over = {
		header_spacing = 25,
		offset_y = 15,
		alignment = "towards_center",
		header_font_size = 20,
		highlight_timer = 0.3,
		text_width = 400,
		spacing = 15,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		width = 500,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
ProfileEditorSettings.items.perk_item[1680] = {}
ProfileEditorSettings.items.perk_item[1680][1050] = {
	atlas = "menu_assets",
	texture_offset_x = 10,
	text_offset_y = -5,
	padding_bottom = 0,
	align_text_x = "left",
	texture_offset_y = 0,
	atlas_default_material = "perk_icon_no_perk_menu",
	align_text_y = "top",
	text_offset_x = 100,
	padding_top = 0,
	scale_on_highlight = 1.2,
	font_size = 20,
	border_thickness = 3,
	atlas_material = "menu_assets_masked",
	font = MenuSettings.fonts.hell_shark_20_masked,
	texture_size = {
		400,
		68
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
		header_spacing = 35,
		offset_y = 15,
		header_font_size = 20,
		highlight_timer = 0.3,
		text_width = 500,
		spacing = 15,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		width = 500,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
		offset_x = -4,
		icon_scale = 0.65,
		icon_atlas = "menu_assets",
		offset_y = 12,
		font = MenuSettings.fonts.hell_shark_16_masked,
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
			border_thickness = 2,
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
		offset_x = -4,
		font_size = 16,
		masked = true,
		icon_scale = 0.65,
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
			border_thickness = 2,
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
		texture_offset_y = -3,
		texture_offset_x = 44,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.helmet_item = ProfileEditorSettings.items.helmet_item or {}
ProfileEditorSettings.items.helmet_item[1680] = {}
ProfileEditorSettings.items.helmet_item[1680][1050] = {
	atlas = "menu_assets",
	text_offset_y = -5,
	padding_top = 10,
	padding_bottom = 10,
	align_text_x = "left",
	padding_left = 10,
	padding_right = 10,
	atlas_default_material = "perk_icon_no_perk_menu",
	align_text_y = "top",
	text_offset_x = 10,
	scale_on_highlight = 1.1,
	font_size = 20,
	border_thickness = 3,
	hide_info = true,
	font = MenuSettings.fonts.hell_shark_20_masked,
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
	border_color = {
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
	mouse_over = {
		header_spacing = 25,
		offset_y = 15,
		header_font_size = 20,
		highlight_timer = 0.3,
		z = 60,
		spacing = 15,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		width = 500,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
			border_thickness = 2,
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
			border_thickness = 2,
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
		texture_offset_y = 95,
		texture_offset_x = -26,
		texture_color = {
			255,
			255,
			255,
			255
		}
	}
}
ProfileEditorSettings.items.beard_item = ProfileEditorSettings.items.beard_item or {}
ProfileEditorSettings.items.beard_item[1680] = {}
ProfileEditorSettings.items.beard_item[1680][1050] = table.clone(ProfileEditorSettings.items.helmet_item[1680][1050])
ProfileEditorSettings.items.beard_item[1680][1050].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 135,
	texture_offset_x = -33,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.taunt_item = ProfileEditorSettings.items.taunt_item or {}
ProfileEditorSettings.items.taunt_item[1680] = {}
ProfileEditorSettings.items.taunt_item[1680][1050] = table.clone(ProfileEditorSettings.items.helmet_item[1680][1050])
ProfileEditorSettings.items.taunt_item[1680][1050].padding_top = 20
ProfileEditorSettings.items.taunt_item[1680][1050].padding_bottom = 20
ProfileEditorSettings.items.taunt_item[1680][1050].padding_left = 10
ProfileEditorSettings.items.taunt_item[1680][1050].padding_right = 10
ProfileEditorSettings.items.taunt_item[1680][1050].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 115,
	texture_offset_x = -36,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.cloak_item = ProfileEditorSettings.items.cloak_item or {}
ProfileEditorSettings.items.cloak_item[1680] = {}
ProfileEditorSettings.items.cloak_item[1680][1050] = table.clone(ProfileEditorSettings.items.helmet_item[1680][1050])
ProfileEditorSettings.items.cloak_item[1680][1050].new_item = {
	texture = "new_icon_horizontal",
	texture_atlas_masked = "menu_assets_masked",
	texture_atlas = "menu_assets",
	texture_offset_y = 95,
	texture_offset_x = -23,
	texture_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.armour_item = ProfileEditorSettings.items.armour_item or {}
ProfileEditorSettings.items.armour_item[1680] = {}
ProfileEditorSettings.items.armour_item[1680][1050] = {
	atlas = "outfit_atlas",
	font_size = 20,
	text_offset_y = -5,
	align_text_x = "left",
	border_thickness = 3,
	atlas_material = "outfit_atlas_masked",
	align_text_y = "top",
	text_offset_x = 10,
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
		width = 500,
		spacing = 15,
		header_font_size = 20,
		border_thickness = 3,
		text_font_size = 16,
		header_color_func = "cb_team_color",
		highlight_timer = 0.3,
		offset_y = 15,
		header_font = MenuSettings.fonts.hell_shark_20,
		text_font = MenuSettings.fonts.hell_shark_16,
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
ProfileEditorSettings.items.team_switch[1680] = {}
ProfileEditorSettings.items.team_switch[1680][1050] = {
	texture_atlas = "menu_assets",
	texture_white_highlighted = "team_icon_saxon_glow",
	switch_icon = "team_icon_switch",
	texture_white = "team_icon_saxon",
	z = 10,
	texture_red_highlighted = "team_icon_viking_glow",
	texture_red = "team_icon_viking",
	scale = 0.85,
	active_offset = {
		0.6,
		0.05
	},
	inactive_offset = {
		0.2,
		-0.05
	}
}
ProfileEditorSettings.items.team_switch_right = ProfileEditorSettings.items.team_switch_right or {}
ProfileEditorSettings.items.team_switch_right[1680] = {}
ProfileEditorSettings.items.team_switch_right[1680][1050] = {
	texture_atlas = "menu_assets",
	texture_white_highlighted = "team_icon_saxon_glow",
	switch_icon = "team_icon_switch",
	texture_white = "team_icon_saxon",
	align = "right",
	texture_red_highlighted = "team_icon_viking_glow",
	z = 10,
	texture_red = "team_icon_viking",
	scale = 0.85,
	active_offset = {
		0.6,
		0.05
	},
	inactive_offset = {
		0.2,
		-0.05
	}
}
ProfileEditorSettings.items.next_arrow = ProfileEditorSettings.items.next_arrow or {}
ProfileEditorSettings.items.next_arrow[1680] = {}
ProfileEditorSettings.items.next_arrow[1680][1050] = ProfileEditorSettings.items.next_arrow[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = 25,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
	arrow_facing = "right",
	offset_y = 30,
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
ProfileEditorSettings.items.prev_arrow[1680] = {}
ProfileEditorSettings.items.prev_arrow[1680][1050] = ProfileEditorSettings.items.prev_arrow[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = -430,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
	arrow_facing = "left",
	offset_y = 50,
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
ProfileEditorSettings.items.next_arrow_left[1680] = {}
ProfileEditorSettings.items.next_arrow_left[1680][1050] = ProfileEditorSettings.items.next_arrow_left[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = 340,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
	arrow_facing = "right",
	offset_y = 20,
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
ProfileEditorSettings.items.prev_arrow_left[1680] = {}
ProfileEditorSettings.items.prev_arrow_left[1680][1050] = ProfileEditorSettings.items.prev_arrow_left[1680][1050] or {
	padding_bottom = 0,
	z = 100,
	offset_x = -340,
	padding_left = 0,
	arrow_size_x = 20,
	arrow_size_y = 20,
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
ProfileEditorSettings.items.tier_item[1680] = {}
ProfileEditorSettings.items.tier_item[1680][1050] = ProfileEditorSettings.items.tier_item[1680][1050] or {
	z = 10,
	font_size = 26,
	align = "center",
	padding_bottom = 10,
	font = MenuSettings.fonts.hell_shark_26_masked,
	disabled_color = {
		255,
		255,
		255,
		255
	}
}
ProfileEditorSettings.items.experience_item = ProfileEditorSettings.items.experience_item or {}
ProfileEditorSettings.items.experience_item[1680] = {}
ProfileEditorSettings.items.experience_item[1680][1050] = ProfileEditorSettings.items.experience_item[1680][1050] or {
	spacing_y = -45,
	align_x = "center",
	offset_x = 0,
	spacing_x = 10,
	z = 10,
	offset_y = 0,
	current_level_box = {
		header_spacing = 5,
		text_color_func = "cb_team_color",
		header = "menu_level",
		font_size = 20,
		header_font_size = 16,
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
		rect_size = {
			40,
			25
		},
		font = MenuSettings.fonts.hell_shark_20,
		header_font = MenuSettings.fonts.hell_shark_16
	},
	level_bar = {
		header_spacing = 5,
		font_size = 16,
		xp_font_size = 22,
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
			250,
			25
		},
		inner_rect_size = {
			230,
			17
		},
		font = MenuSettings.fonts.hell_shark_16,
		xp_text_offset = {
			5,
			2
		},
		xp_font = MenuSettings.fonts.arial_22_masked,
		xp_text_color = {
			255,
			15,
			15,
			15
		},
		back_font = MenuSettings.fonts.arial_22
	},
	next_level_box = {
		font_size = 20,
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
			40,
			25
		},
		font = MenuSettings.fonts.hell_shark_20
	},
	coins_bar = {
		header_spacing = 5,
		header = "menu_coins",
		font_size = 16,
		coin_font_size = 20,
		icon_atlas = "menu_assets",
		icon = "ring",
		rect_color = {
			196,
			30,
			30,
			30
		},
		rect_size = {
			250,
			25
		},
		header_text_color = {
			255,
			255,
			255,
			255
		},
		font = MenuSettings.fonts.hell_shark_16,
		coin_font = MenuSettings.fonts.hell_shark_20
	},
	buy_loot = {
		text = "buy_gold",
		font_size = 16,
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
			90,
			25
		},
		font = MenuSettings.fonts.hell_shark_16,
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
ProfileEditorSettings.items.buy_loot_button = {}
ProfileEditorSettings.items.buy_loot_button[1680] = {}
ProfileEditorSettings.items.buy_loot_button[1680][1050] = {
	padding_bottom = -13,
	padding_left = 108,
	render_rect = true,
	padding_top = 0,
	rect_height = 24,
	line_height = 22,
	rect_offset_y = -19,
	rect_offset_x = 100,
	padding_right = 0,
	font_size = 16,
	border_thickness = 0,
	rect_width = 97,
	font = MenuSettings.fonts.hell_shark_16,
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
	rect_color_highlighted = {
		255,
		255,
		255,
		255
	},
	rect_color = {
		196,
		30,
		30,
		30
	},
	border_color = {
		255,
		0,
		0,
		0
	}
}
ProfileEditorSettings.items.coat_of_arms_item = {}
ProfileEditorSettings.items.coat_of_arms_item[1680] = {}
ProfileEditorSettings.items.coat_of_arms_item[1680][1050] = {
	font_size = 20,
	font = MenuSettings.fonts.hell_shark_20
}

local function name_items(table)
	for key, item in pairs(table) do
		if item[1366] and item[1366][768] then
			item[1366][768].layout_name = key
		end

		if item[1680] and item[1680][1050] then
			item[1680][1050].layout_name = key
		end
	end
end

name_items(ProfileEditorSettings.pages)
name_items(ProfileEditorSettings.items)
