-- chunkname: @scripts/menu/menu_definitions/ingame_menu_settings_1366.lua

require("scripts/settings/menu_settings")
require("scripts/menu/menu_definitions/main_menu_settings_1366")

IngameMenuSettings = IngameMenuSettings or {}
IngameMenuSettings.items = IngameMenuSettings.items or {}
IngameMenuSettings.pages = IngameMenuSettings.pages or {}
IngameMenuSettings.pages.wotv_audio_sub_level = IngameMenuSettings.pages.wotv_audio_sub_level or {}
IngameMenuSettings.pages.wotv_audio_sub_level[1366] = {}
IngameMenuSettings.pages.wotv_audio_sub_level[1366][768] = IngameMenuSettings.pages.wotv_audio_sub_level[1366][768] or table.clone(MainMenuSettings.pages.wotv_audio_sub_level[1680][1050])
IngameMenuSettings.pages.wotv_audio_sub_level[1366][768].item_list = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 150,
	screen_offset_y = -0.2,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
IngameMenuSettings.pages.wotv_video_settings = IngameMenuSettings.pages.wotv_video_settings or {}
IngameMenuSettings.pages.wotv_video_settings[1366] = {}
IngameMenuSettings.pages.wotv_video_settings[1366][768] = IngameMenuSettings.pages.wotv_video_settings[1366][768] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
IngameMenuSettings.pages.wotv_video_settings[1366][768].item_list = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 170,
	screen_offset_y = -0.1,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
IngameMenuSettings.pages.wotv_page = IngameMenuSettings.pages.wotv_page or {}
IngameMenuSettings.pages.wotv_page[1366] = {}
IngameMenuSettings.pages.wotv_page[1366][768] = IngameMenuSettings.pages.wotv_page[1366][768] or table.clone(MainMenuSettings.pages.wotv_page[1680][1050])
IngameMenuSettings.pages.wotv_page[1366][768].item_list = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 170,
	screen_offset_y = -0.5,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
IngameMenuSettings.pages.wotv_gameplay_sub_level = IngameMenuSettings.pages.wotv_gameplay_sub_level or {}
IngameMenuSettings.pages.wotv_gameplay_sub_level[1366] = {}
IngameMenuSettings.pages.wotv_gameplay_sub_level[1366][768] = IngameMenuSettings.pages.wotv_gameplay_sub_level[1366][768] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
IngameMenuSettings.pages.wotv_gameplay_sub_level[1366][768].item_list = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "left",
	res_relative_x = 1366,
	pivot_offset_x = 170,
	screen_offset_y = -0.1,
	pivot_align_x = "left",
	column_alignment = {
		"center"
	}
}
IngameMenuSettings.pages.wotv_keymapping = IngameMenuSettings.pages.wotv_keymapping or {}
IngameMenuSettings.pages.wotv_keymapping[1366] = {}
IngameMenuSettings.pages.wotv_keymapping[1366][768] = IngameMenuSettings.pages.wotv_keymapping[1366][768] or table.clone(MainMenuSettings.pages.level_4[1680][1050])
IngameMenuSettings.pages.wotv_keymapping[1366][768].item_list = {
	spacing_y = 0,
	screen_offset_x = -0.25,
	pivot_align_y = "top",
	num_columns = 1,
	align = "right",
	spacing_x = 0,
	max_visible_rows = 60,
	offset_x = 0,
	screen_align_x = "center",
	max_shown_items = 16,
	screen_align_y = "top",
	z = 10,
	spacing = 0,
	pivot_offset_y = 0,
	render_mask = true,
	max_shown_items_pad = 16,
	scroller_thickness = 10,
	pivot_offset_x = 0,
	screen_offset_y = -0.19,
	pivot_align_x = "center",
	offset_y = -30,
	column_width = {
		460
	},
	scroller_color = {
		255,
		215,
		215,
		215
	}
}

local item_list = IngameMenuSettings.pages.wotv_keymapping[1366][768].item_list

function item_list.max_shown_items_func()
	return Managers.input:active_mapping(1) ~= "keyboard_mouse" and item_list.max_shown_items_pad or item_list.max_shown_items
end

IngameMenuSettings.pages.wotv_keymapping[1366][768].header_items = {
	screen_align_y = "top",
	screen_offset_x = -0.25,
	spacing = 10,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	num_columns = 1,
	screen_align_x = "center",
	align = "center",
	offset_x = 0,
	spacing_x = 10,
	pivot_offset_x = 0,
	screen_offset_y = -0.06,
	pivot_align_x = "center",
	spacing_y = 10,
	offset_y = -30,
	z = 10
}
IngameMenuSettings.pages.wotv_keymapping[1366][768].verification_items = {
	spacing_y = 0,
	screen_offset_x = -0.25,
	num_columns = 1,
	item_position = "centered",
	pivot_offset_y = 0,
	align = "center",
	spacing_x = 0,
	screen_align_x = "center",
	screen_align_y = "top",
	z = 10,
	spacing = 0,
	offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_x = 0,
	screen_offset_y = -0.7,
	pivot_align_x = "center",
	offset_y = 0
}
IngameMenuSettings.pages.wotv_keymapping[1366][768].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
IngameMenuSettings.pages.wotv_keymapping[1366][768].background_texture = nil
IngameMenuSettings.pages.wotv_keymapping[1366][768].background_texture_top_line = nil
IngameMenuSettings.pages.wotv_keymapping[1366][768].background_texture_bottom_shadow = nil
IngameMenuSettings.pages.wotv_keymapping[1366][768].overlay_texture = nil
IngameMenuSettings.pages.wotv_sub_level = IngameMenuSettings.pages.wotv_sub_level or {}
IngameMenuSettings.pages.wotv_sub_level[1366] = {}
IngameMenuSettings.pages.wotv_sub_level[1366][768] = IngameMenuSettings.pages.wotv_sub_level[1366][768] or table.clone(MainMenuSettings.pages.wotv_sub_level[1680][1050])
IngameMenuSettings.pages.wotv_sub_level[1366][768].item_list = {
	screen_align_y = "top",
	screen_offset_x = -0.25,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = -0.5,
	pivot_align_x = "center",
	column_alignment = {
		"center"
	}
}
IngameMenuSettings.pages.wotv_sub_level[1366][768].page_name = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.01,
	pivot_align_x = "center",
	pivot_align_y = "bottom",
	screen_align_x = "center",
	pivot_offset_y = 0
}
