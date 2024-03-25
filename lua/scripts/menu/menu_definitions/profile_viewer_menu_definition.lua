-- chunkname: @scripts/menu/menu_definitions/profile_viewer_menu_definition.lua

ProfileViewerMenuDefinition = {
	page = {
		type = "EmptyMenuPage",
		item_groups = {
			item_list = {
				{
					id = "profile_viewer",
					type = "EmptyMenuItem",
					page = {
						z = 1,
						type = "ProfileViewerMenuPage",
						layout_settings = ProfileViewerMenuSettings.pages.main_page,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							non_cosmetic = {}
						}
					}
				}
			}
		}
	}
}
