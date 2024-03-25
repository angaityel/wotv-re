-- chunkname: @scripts/menu/menu_pages/sheet_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")

SheetMenuPage = class(SheetMenuPage, MenuPage)

function SheetMenuPage:init(config, item_groups, world)
	SheetMenuPage.super.init(self, config, item_groups, world)

	self._world = world

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._background_rect = RectMenuContainer.create_from_config()
	self._horizontal_line_texture_top = TextureMenuContainer.create_from_config()
	self._horizontal_line_texture_bottom = TextureMenuContainer.create_from_config()
end

function SheetMenuPage:update(dt, t)
	SheetMenuPage.super.update(self, dt, t)
	self:_update_container_size(dt, t)
	self:_update_container_position(dt, t)
end

function SheetMenuPage:_update_container_size(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._background_rect:update_size(dt, t, self._gui, layout_settings.background_rect)

	if layout_settings.horizontal_line_texture_top then
		self._horizontal_line_texture_top:update_size(dt, t, self._gui, layout_settings.horizontal_line_texture_top)
	end

	if layout_settings.horizontal_line_texture_bottom then
		self._horizontal_line_texture_bottom:update_size(dt, t, self._gui, layout_settings.horizontal_line_texture_bottom)
	end
end

function SheetMenuPage:_update_container_position(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._background_rect, layout_settings.background_rect)

	self._background_rect:update_position(dt, t, layout_settings.background_rect, x, y, self.config.z)

	if layout_settings.horizontal_line_texture_top then
		local x, y = MenuHelper:container_position(self._horizontal_line_texture_top, layout_settings.horizontal_line_texture_top)

		self._horizontal_line_texture_top:update_position(dt, t, layout_settings.horizontal_line_texture_top, x, y, self.config.z + 1)
	end

	if layout_settings.horizontal_line_texture_bottom then
		local x, y = MenuHelper:container_position(self._horizontal_line_texture_bottom, layout_settings.horizontal_line_texture_bottom)

		self._horizontal_line_texture_bottom:update_position(dt, t, layout_settings.horizontal_line_texture_bottom, x, y, self.config.z + 1)
	end
end

function SheetMenuPage:render(dt, t)
	SheetMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._background_rect:render(dt, t, self._gui, layout_settings.background_rect)

	if layout_settings.horizontal_line_texture_top then
		self._horizontal_line_texture_top:render(dt, t, self._gui, layout_settings.horizontal_line_texture_top)
	end

	if layout_settings.horizontal_line_texture_bottom then
		self._horizontal_line_texture_bottom:render(dt, t, self._gui, layout_settings.horizontal_line_texture_bottom)
	end
end
