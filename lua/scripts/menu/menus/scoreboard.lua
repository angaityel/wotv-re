-- chunkname: @scripts/menu/menus/scoreboard.lua

require("scripts/menu/menus/menu")
require("scripts/menu/menu_controller_settings/scoreboard_controller_settings")
require("scripts/menu/menu_definitions/scoreboard_definition")
require("scripts/menu/menu_callbacks/scoreboard_callbacks")

Scoreboard = class(Scoreboard, Menu)

function Scoreboard:init(game_state, world, data)
	Scoreboard.super.init(self, game_state, world, ScoreboardControllerSettings, ScoreboardSettings, ScoreboardDefinition, ScoreboardCallbacks, data)
end

function Scoreboard:set_active(flag, on_pad)
	Scoreboard.super.set_active(self, flag)

	if not on_pad then
		Window.set_show_cursor(flag)
	end

	if flag then
		Managers.state.hud:set_huds_enabled_except(false)
	else
		Managers.state.hud:set_huds_enabled_except(true, {
			"chat",
			"chat_window"
		})
	end
end
