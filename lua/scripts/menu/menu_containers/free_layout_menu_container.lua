-- chunkname: @scripts/menu/menu_containers/free_layout_menu_container.lua

FreeLayoutMenuContainer = class(FreeLayoutMenuContainer, MenuContainer)

function FreeLayoutMenuContainer:init(items)
	FreeLayoutMenuContainer.super.init(self, items)

	self._items = items
end

function FreeLayoutMenuContainer:update_size(dt, t, gui, layout_settings)
	local x, y = Gui.resolution()

	self._width = layout_settings.width or x
	self._height = layout_settings.height or y

	for _, item in pairs(self._items) do
		local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

		item:update_size(dt, t, gui, item_layout_settings)
	end
end

function FreeLayoutMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	for _, item in ipairs(self._items) do
		local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)
		local item_x, item_y = HUDHelper:element_position(self, item, item_layout_settings)

		item:update_position(dt, t, item_layout_settings, item_x + x, item_y + y, z + 1)
	end
end

function FreeLayoutMenuContainer:render(dt, t, gui, layout_settings)
	for i, item in ipairs(self._items) do
		if item:visible() then
			item:render(dt, t, gui, MenuHelper:layout_settings(item.config.layout_settings))
		end
	end

	if layout_settings.render_rect then
		self:_render_rect(dt, t, gui, layout_settings.render_rect)
	end
end

function FreeLayoutMenuContainer:_render_rect(dt, t, gui, layout_settings)
	local color = Color(layout_settings.color[1], layout_settings.color[2], layout_settings.color[3], layout_settings.color[4])

	Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), color)

	if layout_settings.border_size then
		local x = self._x
		local y = self._y
		local z = self._z
		local w = self._width
		local h = self._height
		local color = Color(layout_settings.border_color[1], layout_settings.border_color[2], layout_settings.border_color[3], layout_settings.border_color[4])

		Gui.rect(gui, Vector3(x - layout_settings.border_size, y + h, z + 1), Vector2(w + layout_settings.border_size * 2, layout_settings.border_size), color)
		Gui.rect(gui, Vector3(x - layout_settings.border_size, y - layout_settings.border_size, z + 1), Vector2(w + layout_settings.border_size * 2, layout_settings.border_size), color)
		Gui.rect(gui, Vector3(x - layout_settings.border_size, y, z + 1), Vector2(layout_settings.border_size, h), color)
		Gui.rect(gui, Vector3(x + w, y, z + 1), Vector2(layout_settings.border_size, h), color)
	end
end

function FreeLayoutMenuContainer.create_from_config(items)
	return FreeLayoutMenuContainer:new(items)
end
