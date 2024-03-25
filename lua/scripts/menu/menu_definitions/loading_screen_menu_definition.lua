-- chunkname: @scripts/menu/menu_definitions/loading_screen_menu_definition.lua

require("scripts/settings/menu_settings")
require("scripts/menu/menu_definitions/battle_report_page_definition")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1920")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1366")

LoadingScreenMenuDuringRoundsDefinition = {
	page = {
		type = "EmptyMenuPage",
		item_groups = {
			item_list = {
				BattleReportScoreboardPageDefinition,
				{
					id = "loading_screen",
					type = "EmptyMenuItem",
					page = {
						z = 10,
						type = "LoadingScreenMenuPage",
						layout_settings = LoadingScreenMenuSettings.pages.loading_screen,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									text = "[GAME MODE NAME]",
									name = "game_mode_name",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big
								},
								{
									text = "[LEVEL NAME]",
									name = "level_name",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned
								},
								{
									text = "",
									name = "countdown",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = BattleReportSettings.items.countdown
								},
								LoadingScreenPopupQuitToLobby
							},
							arrow_list = {
								{
									name = "arrow_left",
									callback_object = "page",
									type = "ArrowMenuItem",
									on_select = "cb_previous_tip",
									layout_settings = LoadingScreenMenuSettings.items.prev_arrow
								},
								{
									name = "arrow_right",
									callback_object = "page",
									type = "ArrowMenuItem",
									on_select = "cb_next_tip",
									layout_settings = LoadingScreenMenuSettings.items.next_arrow
								}
							},
							page_links = {
								{
									text = "menu_scoreboard",
									name = "previous_page_link",
									on_select = "cb_goto_menu_page",
									type = "TextureButtonMenuItem",
									callback_object = "page",
									on_select_args = {
										"battle_report_scoreboard"
									},
									layout_settings = LoadingScreenMenuSettings.items.previous_button
								},
								{
									text = "menu_battle",
									name = "next_page_link",
									disabled_func = "cb_round_not_ready",
									type = "TextureButtonMenuItem",
									remove_func = "cb_loading_done",
									on_select = "cb_start_game",
									callback_object = "page",
									layout_settings = LoadingScreenMenuSettings.items.next_button
								}
							}
						}
					}
				}
			}
		}
	}
}
LoadingScreenMenuFirstRoundDefinition = {
	page = {
		type = "EmptyMenuPage",
		item_groups = {
			item_list = {
				{
					id = "loading_screen",
					type = "EmptyMenuItem",
					page = {
						z = 10,
						type = "LoadingScreenMenuPage",
						layout_settings = LoadingScreenMenuSettings.pages.loading_screen_first_round,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									text = "[GAME MODE NAME]",
									name = "game_mode_name",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned_big
								},
								{
									text = "[LEVEL NAME]",
									name = "level_name",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = LoadingScreenMenuSettings.items.loading_screen_header_right_aligned
								},
								{
									text = "",
									name = "countdown",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = BattleReportSettings.items.countdown
								},
								LoadingScreenPopupQuitToLobby
							},
							arrow_list = {
								{
									name = "arrow_left",
									callback_object = "page",
									type = "ArrowMenuItem",
									on_select = "cb_previous_tip",
									layout_settings = LoadingScreenMenuSettings.items.prev_arrow
								},
								{
									name = "arrow_right",
									callback_object = "page",
									type = "ArrowMenuItem",
									on_select = "cb_next_tip",
									layout_settings = LoadingScreenMenuSettings.items.next_arrow
								}
							},
							page_links = {
								{
									text = "menu_battle",
									name = "next_page_link",
									disabled_func = "cb_round_not_ready",
									type = "TextureButtonMenuItem",
									remove_func = "cb_is_server",
									on_select = "cb_start_game",
									callback_object = "page",
									layout_settings = LoadingScreenMenuSettings.items.next_button
								}
							}
						}
					}
				}
			}
		}
	}
}
