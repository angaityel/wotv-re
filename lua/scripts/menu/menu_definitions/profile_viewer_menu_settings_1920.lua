-- chunkname: @scripts/menu/menu_definitions/profile_viewer_menu_settings_1920.lua

require("scripts/settings/hud_settings")

ProfileViewerMenuSettings = ProfileViewerMenuSettings or {}
ProfileViewerMenuSettings.items = ProfileViewerMenuSettings.items or {}
ProfileViewerMenuSettings.pages = ProfileViewerMenuSettings.pages or {}
ProfileViewerMenuSettings.pages.main_page = ProfileViewerMenuSettings.pages.main_page or {}
ProfileViewerMenuSettings.pages.main_page[1680] = ProfileViewerMenuSettings.pages.main_page[1680] or {}
ProfileViewerMenuSettings.pages.main_page[1680][1050] = {
	non_cosmetic = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_align_y = "center",
		height = 800,
		pivot_offset_y = 0,
		screen_align_x = "left",
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "left",
		width = 300,
		render_rect = {
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
		anim_from = {
			screen_align_y = "center",
			screen_offset_x = 0,
			pivot_align_y = "center",
			interpolation = "smoothstep",
			pivot_offset_y = 0,
			screen_align_x = "left",
			pivot_offset_x = -400,
			screen_offset_y = 0,
			pivot_align_x = "left",
			duration = 0.25
		}
	}
}
