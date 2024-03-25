-- chunkname: @scripts/menu/menu_definitions/battle_report_page_definition.lua

require("scripts/settings/menu_settings")
require("scripts/menu/menu_definitions/scoreboard_definition")
require("scripts/menu/menu_definitions/battle_report_page_settings_1920")
require("scripts/menu/menu_definitions/battle_report_page_settings_1366")
require("scripts/menu/menu_definitions/squad_menu_settings_1920")
require("scripts/menu/menu_definitions/squad_menu_settings_1366")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1920")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1366")

LoadingScreenPopupQuitToLobby = {
	name = "quit_to_lobby",
	type = "EmptyMenuItem",
	layout_settings = MainMenuSettings.items.empty,
	page = {
		z = 200,
		callback_object = "parent_page",
		type = "PopupMenuPage",
		on_item_selected = "cb_quit_to_lobby",
		layout_settings = MainMenuSettings.pages.text_input_popup,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			header_list = {
				{
					text = "menu_empty",
					disabled = true,
					type = "TextMenuItem",
					layout_settings = MainMenuSettings.items.popup_header
				}
			},
			item_list = {
				{
					text = "menu_popup_confirm_leave_battle",
					disabled = true,
					type = "TextBoxMenuItem",
					layout_settings = MainMenuSettings.items.popup_textbox
				}
			},
			button_list = {
				{
					text = "main_menu_yes",
					callback_object = "page",
					type = "TextureButtonMenuItem",
					on_select = "cb_item_selected",
					on_select_args = {
						"close",
						"yes"
					},
					layout_settings = MainMenuSettings.items.popup_button
				},
				{
					text = "main_menu_no",
					callback_object = "page",
					type = "TextureButtonMenuItem",
					on_select = "cb_item_selected",
					on_select_args = {
						"close",
						"no"
					},
					layout_settings = MainMenuSettings.items.popup_button
				}
			}
		}
	}
}
BattleReportScoreboardPageDefinition = {
	id = "battle_report_scoreboard",
	type = "EmptyMenuItem",
	page = {
		z = 10,
		type = "BattleReportScoreboardMenuPage",
		layout_settings = BattleReportSettings.pages.scoreboard,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			header_items = ScoreBoardHeaderItems,
			player_details = PlayerDetails,
			item_list = {
				LoadingScreenPopupQuitToLobby
			},
			page_links = {
				{
					text = "menu_close",
					name = "next_page_link",
					on_select = "cb_goto_menu_page",
					type = "TextureButtonMenuItem",
					callback_object = "page",
					on_select_args = {
						"loading_screen"
					},
					layout_settings = LoadingScreenMenuSettings.items.next_button
				}
			},
			player_items = {}
		}
	}
}
