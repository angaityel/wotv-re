-- chunkname: @scripts/menu/menu_pages/teams_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")

TeamsMenuPage = class(TeamsMenuPage, MenuPage)

function TeamsMenuPage:init(config, item_groups, world)
	TeamsMenuPage.super.init(self, config, item_groups, world)

	self._world = world
	self._local_player = config.local_player

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._center_items_container = ItemListMenuContainer.create_from_config(item_groups.center_items)
	self._left_team_items_container = ItemListMenuContainer.create_from_config(item_groups.left_team_items)
	self._right_team_items_container = ItemListMenuContainer.create_from_config(item_groups.right_team_items)
	self._render_backgrounds = true
end

function TeamsMenuPage:update(dt, t)
	TeamsMenuPage.super.update(self, dt, t)
	self:_update_container_size(dt, t)
	self:_update_container_position(dt, t)
end

function TeamsMenuPage:_update_container_size(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._center_items_container:update_size(dt, t, self._gui, layout_settings.center_items)
	self._left_team_items_container:update_size(dt, t, self._gui, layout_settings.left_team_items)
	self._right_team_items_container:update_size(dt, t, self._gui, layout_settings.right_team_items)
end

function TeamsMenuPage:_update_container_position(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._center_items_container, layout_settings.center_items)

	self._center_items_container:update_position(dt, t, layout_settings.center_items, x, y, self.config.z + 15)

	local x, y = MenuHelper:container_position(self._left_team_items_container, layout_settings.left_team_items)

	self._left_team_items_container:update_position(dt, t, layout_settings.left_team_items, x, y, self.config.z + 10)

	local x, y = MenuHelper:container_position(self._right_team_items_container, layout_settings.right_team_items)

	self._right_team_items_container:update_position(dt, t, layout_settings.right_team_items, x, y, self.config.z + 10)
end

function TeamsMenuPage:render(dt, t)
	TeamsMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._center_items_container:render(dt, t, self._gui, layout_settings.center_items)
	self._left_team_items_container:render(dt, t, self._gui, layout_settings.left_team_items)
	self._right_team_items_container:render(dt, t, self._gui, layout_settings.right_team_items)
	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)
end

function TeamsMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "teams",
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_page = page_config.on_enter_page,
		on_exit_page = page_config.on_exit_page,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return TeamsMenuPage:new(config, item_groups, compiler_data.world)
end
