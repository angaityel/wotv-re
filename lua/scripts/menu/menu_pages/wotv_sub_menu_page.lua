﻿-- chunkname: @scripts/menu/menu_pages/wotv_sub_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")
require("scripts/menu/menu_pages/wotv_menu_page")

WotvSubMenuPage = class(WotvSubMenuPage, WotvMenuPage)
WotvSubMenuPage.menu_level = 3

function WotvSubMenuPage:init(config, item_groups, world)
	WotvSubMenuPage.super.init(self, config, item_groups, world)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list = ItemListMenuContainer.create_from_config(item_groups.item_list)
	self._overlay_texture = FrameTextureMenuContainer.create_from_config()
end

function WotvSubMenuPage:_update_container_size(dt, t)
	WotvSubMenuPage.super._update_container_size(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:update_size(dt, t, self._gui, layout_settings.item_list)
end

function WotvSubMenuPage:_update_container_position(dt, t)
	WotvSubMenuPage.super._update_container_position(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._item_list, layout_settings.item_list)

	self._item_list:update_position(dt, t, layout_settings.item_list, x, y, self.config.z + 15)
end

function WotvSubMenuPage:render_from_child_page(dt, t, leef)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local page_type = self:_highlighted_item() and self:_highlighted_item().config.page and self:_highlighted_item().config.page.config.type

	if page_type == "drop_down_list" or page_type == "popup" then
		self._item_list:render(dt, t, self._gui, layout_settings.item_list)
	else
		self._item_list:render_from_child_page(dt, t, self._gui, layout_settings.item_list)
	end

	self.config.parent_page:render_from_child_page(dt, t, leef or self)
end

function WotvSubMenuPage:render(dt, t)
	WotvSubMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:render(dt, t, self._gui, layout_settings.item_list)
end

function WotvSubMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "level_3",
		render_parent_page = true,
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_page = page_config.on_enter_page,
		on_exit_page = page_config.on_exit_page,
		show_revision = page_config.show_revision,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment(),
		camera = page_config.camera or parent_page and parent_page:camera()
	}

	return WotvSubMenuPage:new(config, item_groups, compiler_data.world)
end
