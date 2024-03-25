-- chunkname: @scripts/menu/menus/profile_viewer_menu.lua

require("scripts/menu/menus/menu")
require("scripts/menu/menu_controller_settings/profile_viewer_menu_controller_settings")
require("scripts/menu/menu_definitions/profile_viewer_menu_settings_1920")
require("scripts/menu/menu_definitions/profile_viewer_menu_settings_1366")
require("scripts/menu/menu_definitions/profile_viewer_menu_definition")
require("scripts/menu/menu_callbacks/profile_viewer_menu_callbacks")

ProfileViewerMenu = class(ProfileViewerMenu, Menu)

function ProfileViewerMenu:init(game_state, world, data)
	ProfileViewerMenu.super.init(self, game_state, world, ProfileViewerMenuControllerSettings, ProfileViewerMenuSettings, ProfileViewerMenuDefinition, ProfileViewerMenuCallbacks, data)
end
