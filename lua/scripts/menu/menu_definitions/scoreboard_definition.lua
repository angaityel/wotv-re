-- chunkname: @scripts/menu/menu_definitions/scoreboard_definition.lua

require("scripts/settings/hud_settings")
require("scripts/menu/menu_definitions/scoreboard_settings_1920")
require("scripts/menu/menu_definitions/scoreboard_settings_1366")
require("scripts/menu/menu_definitions/battle_report_page_definition")
require("scripts/menu/menu_definitions/battle_report_page_settings_1920")
require("scripts/menu/menu_definitions/battle_report_page_settings_1366")

ScoreBoardHeaderItems = {
	{
		name = "scoreboard_header",
		disabled = true,
		type = "ScoreboardHeaderMenuItem",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.scoreboard_header
	},
	{
		text = "",
		name = "server_name",
		on_enter_text = "cb_server_name",
		type = "TextMenuItem",
		disabled = true,
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.server_name
	},
	{
		text = "",
		name = "game_mode_name",
		on_enter_text = "cb_game_mode_name",
		type = "TextMenuItem",
		disabled = true,
		layout_settings = BattleReportSettings.items.game_mode_name
	},
	{
		text = "",
		name = "countdown",
		disabled = true,
		type = "TextMenuItem",
		no_localization = true,
		layout_settings = BattleReportSettings.items.countdown
	}
}
PlayerDetails = {
	{
		text = "",
		name = "empty_value",
		disabled = true,
		type = "EmptyMenuItem",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "",
		name = "empty_value2",
		disabled = true,
		type = "EmptyMenuItem",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "0",
		name = "kills_value",
		disabled = true,
		type = "TextMenuItem",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "0",
		name = "deaths_value",
		disabled = true,
		type = "TextMenuItem",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "",
		name = "empty_name",
		disabled = true,
		type = "EmptyMenuItem",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "",
		name = "empty_name2",
		disabled = true,
		type = "EmptyMenuItem",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "scoreboard_kills",
		name = "kills_value",
		disabled = true,
		type = "TextMenuItem",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "scoreboard_deaths",
		name = "deaths",
		disabled = true,
		type = "TextMenuItem",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "0",
		name = "headshots_value",
		disabled = true,
		type = "TextMenuItem",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "0",
		name = "objectives_value",
		disabled = true,
		type = "TextMenuItem",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "PLAYER_NAME",
		name = "kills_value",
		disabled = true,
		type = "TextMenuItem",
		remove_func = "cb_is_alpha",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "PLAYER_NAME",
		name = "deaths_value",
		disabled = true,
		type = "TextMenuItem",
		remove_func = "cb_is_alpha",
		no_localization = true,
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_value
	},
	{
		text = "",
		name = "empty_value3",
		disabled = true,
		type = "EmptyMenuItem",
		remove_func = "cb_is_not_alpha",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "",
		name = "empty_value4",
		disabled = true,
		type = "EmptyMenuItem",
		remove_func = "cb_is_not_alpha",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "scoreboard_headshots",
		name = "headshots",
		disabled = true,
		type = "TextMenuItem",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "scoreboard_objectives_captured",
		name = "objectives",
		disabled = true,
		type = "TextMenuItem",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "scoreboard_killed_most",
		name = "killed_most",
		disabled = true,
		type = "TextMenuItem",
		remove_func = "cb_is_alpha",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "scoreboard_killed_by_most",
		name = "killed_by_most",
		disabled = true,
		type = "TextMenuItem",
		remove_func = "cb_is_alpha",
		callback_object = "page",
		layout_settings = BattleReportSettings.items.stat_name
	},
	{
		text = "",
		name = "empty_name3",
		disabled = true,
		type = "EmptyMenuItem",
		remove_func = "cb_is_not_alpha",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	},
	{
		text = "",
		name = "empty_name4",
		disabled = true,
		type = "EmptyMenuItem",
		remove_func = "cb_is_not_alpha",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.empty
	}
}
ScoreboardDefinition = {
	id = "ingame_scoreboard",
	type = "EmptyMenuItem",
	page = {
		z = 10,
		type = "IngameScoreboardMenuPage",
		layout_settings = BattleReportSettings.pages.scoreboard,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			header_items = ScoreBoardHeaderItems,
			player_details = PlayerDetails,
			page_links = {},
			player_items = {}
		}
	}
}
