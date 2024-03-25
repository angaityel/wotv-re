﻿-- chunkname: @scripts/menu/menu_definitions/credits_page_settings_1920.lua

CreditsPageSettings = CreditsPageSettings or {}
CreditsPageSettings.items = CreditsPageSettings.items or {}
CreditsPageSettings.pages = CreditsPageSettings.pages or {}
CreditsPageSettings.pages.credits = CreditsPageSettings.pages.credits or {}
CreditsPageSettings.pages.credits[1680] = CreditsPageSettings.pages.credits[1680] or {}
CreditsPageSettings.pages.credits[1680][1050] = CreditsPageSettings.pages.credits[1680][1050] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
CreditsPageSettings.pages.credits[1680][1050].item_list = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	column_alignment = {
		"center"
	}
}
CreditsPageSettings.items.company = CreditsPageSettings.items.company or {}
CreditsPageSettings.items.company[1680] = CreditsPageSettings.items.company[1680] or {}
CreditsPageSettings.items.company[1680][1050] = CreditsPageSettings.items.company[1680][1050] or {
	padding_bottom = 20,
	padding_left = 0,
	font_size = 36,
	padding_top = 130,
	line_height = 36,
	padding_right = 0,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color_disabled = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		4,
		-4
	}
}
CreditsPageSettings.items.company_small = CreditsPageSettings.items.company_small or {}
CreditsPageSettings.items.company_small[1680] = CreditsPageSettings.items.company_small[1680] or {}
CreditsPageSettings.items.company_small[1680][1050] = CreditsPageSettings.items.company_small[1680][1050] or {
	line_height = 44,
	padding_left = 0,
	padding_right = 0,
	font_size = 38,
	padding_top = 130,
	padding_bottom = 20,
	font = MenuSettings.fonts.font_gradient_100,
	color_disabled = {
		255,
		255,
		255,
		255
	}
}
CreditsPageSettings.items.title = CreditsPageSettings.items.title or {}
CreditsPageSettings.items.title[1680] = CreditsPageSettings.items.title[1680] or {}
CreditsPageSettings.items.title[1680][1050] = CreditsPageSettings.items.title[1680][1050] or {
	padding_bottom = 4,
	padding_left = 0,
	font_size = 28,
	padding_top = 24,
	line_height = 28,
	padding_right = 0,
	font = MenuSettings.fonts.arial_28,
	color_disabled = {
		255,
		87,
		163,
		199
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
CreditsPageSettings.items.person = CreditsPageSettings.items.person or {}
CreditsPageSettings.items.person[1680] = CreditsPageSettings.items.person[1680] or {}
CreditsPageSettings.items.person[1680][1050] = CreditsPageSettings.items.person[1680][1050] or {
	padding_bottom = 2,
	padding_left = 0,
	font_size = 22,
	padding_top = 2,
	line_height = 22,
	padding_right = 0,
	font = MenuSettings.fonts.arial_22,
	color_disabled = {
		255,
		255,
		255,
		255
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
CreditsPageSettings.items.info = CreditsPageSettings.items.info or {}
CreditsPageSettings.items.info[1680] = CreditsPageSettings.items.info[1680] or {}
CreditsPageSettings.items.info[1680][1050] = CreditsPageSettings.items.info[1680][1050] or {
	padding_left = 0,
	padding_right = 0,
	font_size = 20,
	padding_top = 50,
	text_align = "center",
	padding_bottom = 10,
	line_height = 20,
	width = 700,
	font = MenuSettings.fonts.arial_20,
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
CreditsPageSettings.items.texture = CreditsPageSettings.items.texture or {}
CreditsPageSettings.items.texture[1680] = CreditsPageSettings.items.texture[1680] or {}
CreditsPageSettings.items.texture[1680][1050] = CreditsPageSettings.items.texture[1680][1050] or {
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
