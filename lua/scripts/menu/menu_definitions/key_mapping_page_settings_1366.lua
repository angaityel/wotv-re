-- chunkname: @scripts/menu/menu_definitions/key_mapping_page_settings_1366.lua

require("scripts/menu/menu_definitions/ingame_menu_settings_1366")

KeyMappingPageDefinition = KeyMappingPageDefinition or {}
SCALE_1366 = 0.7114583333333333

local page_settings = KeyMappingPageDefinition.page_settings or {}

page_settings[1366] = {}
page_settings[1366][768] = page_settings[1366][768] or table.clone(MainMenuSettings.pages.wotv_keymapping[1366][768])
page_settings[1366][768].button_info = {
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
			button_name = "a",
			text = "main_menu_select"
		},
		{
			button_name = "b",
			text = "main_menu_cancel"
		},
		{
			button_name = "x",
			text = "main_menu_apply_settings"
		},
		{
			button_name = "y",
			text = "menu_reset"
		}
	}
}
page_settings[1366][768].item_list.number_of_columns = 1
page_settings[1366][768].item_list.max_visible_rows = 30
page_settings[1366][768].item_list.column_width = {
	580 * SCALE_1366
}
page_settings[1366][768].item_list.render_mask = true

local item_page_settings = KeyMappingPageDefinition.item_page_settings or {}

item_page_settings[1366] = {}
item_page_settings[1366][768] = item_page_settings[1366][768] or table.clone(MainMenuSettings.pages.wotv_keymapping[1366][768])
item_page_settings[1366][768].render_mask = true

local key_map_item_settings = KeyMappingPageDefinition.key_map_item_settings or {}

key_map_item_settings[1366] = {}
key_map_item_settings[1366][768] = key_map_item_settings[1366][768] or {
	highlight_font_size = 16,
	font_size = 14,
	align = "left",
	line_height = 15,
	text_align = "center",
	pad_size = 30,
	key_name_align = 30,
	width = 450,
	font = MenuSettings.fonts.hell_shark_14_masked,
	highlight_font = MenuSettings.fonts.hell_shark_16_masked,
	pad_font = MenuSettings.fonts.hell_shark_30_masked,
	color = {
		160,
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
	color_render_from_child_page = {
		80,
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
	padding_top = 0 * SCALE_1366,
	padding_bottom = 6 * SCALE_1366,
	padding_left = 0 * SCALE_1366
}

local delimiter_item_settings = KeyMappingPageDefinition.delimiter_item_settings or {}

delimiter_item_settings[1366] = {}
delimiter_item_settings[1366][768] = delimiter_item_settings[1366][768] or table.clone(MainMenuSettings.items.delimiter_texture_left[1366][768])
delimiter_item_settings[1366][768].padding_top = 14 * SCALE_1366

local delimiter_item_list_settings = KeyMappingPageDefinition.delimiter_item_list_settings or {}

delimiter_item_list_settings[1366] = {}
delimiter_item_list_settings[1366][768] = delimiter_item_list_settings[1366][768] or table.clone(MainMenuSettings.items.delimiter_texture_right[1366][768])
delimiter_item_list_settings[1366][768].padding_top = 14 * SCALE_1366
KeyMappingPageDefinition.page_settings = page_settings
KeyMappingPageDefinition.item_page_settings = item_page_settings
KeyMappingPageDefinition.key_map_item_settings = key_map_item_settings
KeyMappingPageDefinition.delimiter_item_settings = delimiter_item_settings
KeyMappingPageDefinition.delimiter_item_list_settings = delimiter_item_list_settings

local page_settings = KeyMappingPageDefinition.page_settings_ingame or {}

page_settings[1366] = {}
page_settings[1366][1366] = page_settings[1366][768] or table.clone(IngameMenuSettings.pages.wotv_keymapping[1366][768])
page_settings[1366][1366].item_list.number_of_columns = 1
page_settings[1366][1366].item_list.max_visible_rows = 80
page_settings[1366][1366].item_list.column_width = {
	580
}
KeyMappingPageDefinition.page_settings_ingame = page_settings
