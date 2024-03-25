-- chunkname: @scripts/menu/menu_pages/gear_list_page.lua

GearListPage = class(GearListPage, MenuPage)

function GearListPage:init(config, item_groups, world)
	GearListPage.super.init(self, config, item_groups, world)

	self._mouse_pos = {
		0,
		0
	}
	self._container = SimpleGridMenuContainer.create_from_config(self._item_groups[self.config.specified_item_group])
end

function GearListPage:set_position(x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function GearListPage:set_data(item_data)
	self._item_data = item_data
	self.config.camera = item_data.camera
end

function GearListPage:sort_items(items)
	table.sort(items, function(a, b)
		return a.ui_sort_index < b.ui_sort_index
	end)
end

function GearListPage:on_enter(on_cancel)
	GearListPage.super.on_enter(self, on_cancel)
	self:_create_items()
	self._container:reset()

	for index, item in ipairs(self._items) do
		item:on_page_enter(on_cancel)
	end
end

function GearListPage:on_exit(on_cancel)
	if on_cancel then
		self:_try_callback(self.config.callback_object, self.config.reset_callback)
	end
end

function GearListPage:width()
	return self._container:width()
end

function GearListPage:height()
	return self._container:height()
end

function GearListPage:_create_items()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:remove_items(self.config.specified_item_group)
	self:sort_items(self._item_data.gear)

	for _, gear in ipairs(self._item_data.gear) do
		local config = {
			remove_func = "cb_gear_hidden",
			name = gear.ui_header,
			text = gear.ui_header,
			layout_settings = self.config.item_layout_settings or self._item_data.layout_settings,
			on_select = self._item_data.on_select,
			on_select_args = {
				gear,
				self._item_data.weapon_slot
			},
			on_highlight = self._item_data.on_highlight,
			on_highlight_args = {
				gear,
				self._item_data.weapon_slot
			},
			sounds = self.config.sounds,
			remove_args = gear,
			item_padding = {
				layout_settings.gear.spacing_x or layout_settings.gear.spacing,
				layout_settings.gear.spacing_y or layout_settings.gear.spacing
			},
			reset_callback = self.config.reset_callback,
			on_highlight_new_item = self._item_data.on_highlight_new_item,
			on_highlight_new_item_args = {
				gear
			},
			new_item = UnviewedUnlockedItems[gear.name]
		}
		local item = GearItem.create_from_config({
			world = self._world
		}, config, self.config.callback_object)

		self:add_item(item, self.config.specified_item_group)
	end
end

function GearListPage:_update_input(input)
	GearListPage.super._update_input(self, input)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._container:update_input(input, layout_settings.gear)

	if input:has("cursor") then
		self:_update_scroller(input:get("cursor"), input:get("release_left"), layout_settings.gear)
		self:_update_mouse_over(input:get("cursor"), input:get("select_left_click"), layout_settings.gear)
	end
end

function GearListPage:_update_scroller(mouse_pos, release_left, layout_settings)
	if not self._scroll_mouse_pos or release_left then
		self._scroll_mouse_pos = nil

		return
	end

	local diff = mouse_pos[2] - self._scroll_mouse_pos

	self._container:update_scroller_position(-diff * 2)

	self._scroll_mouse_pos = mouse_pos[2]
end

function GearListPage:_update_mouse_over(mouse_pos, left_click, layout_settings)
	self._mouse_pos = {
		mouse_pos[1],
		mouse_pos[2]
	}

	if not left_click then
		return
	end

	local x1 = self._container:x()
	local x2 = x1 + self._container:width()
	local y1 = self._container:y()
	local y2 = self._container:y() + self._container:height()

	if self._container:is_inside_scroller(mouse_pos, layout_settings) then
		self._scroll_mouse_pos = mouse_pos[2]
	elseif x1 > mouse_pos[1] or x2 < mouse_pos[1] or y1 > mouse_pos[2] or y2 < mouse_pos[2] then
		self:_cancel()
	end
end

function GearListPage:_is_mouse_inside()
	local x1 = self._container:x()
	local x2 = x1 + self._container:width()
	local y1 = self._container:y()
	local y2 = self._container:y() + self._container:height()

	return x1 < self._mouse_pos[1] and x2 > self._mouse_pos[1] and y1 < self._mouse_pos[2] and y2 > self._mouse_pos[2]
end

function GearListPage:_highlight_item(index, ignore_sound)
	if not Managers.input:pad_active(1) and not self:_is_mouse_inside() then
		GearListPage.super._highlight_item(self, nil)
		self:_try_callback(self.config.callback_object, self.config.reset_callback)

		return
	end

	GearListPage.super._highlight_item(self, index, ignore_sound)
end

function GearListPage:update(dt, t, update_from_child_page)
	GearListPage.super.update(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._container:update_size(dt, t, self._gui, layout_settings.gear)

	local x, y = MenuHelper:container_position(self._container, layout_settings.gear)

	self._container:update_position(dt, t, layout_settings.gear, x + self._x, y + self._y, self._z)

	if update_from_child_page then
		self._container:render_from_child_page(dt, t, self._gui, layout_settings.gear)
	else
		self._container:render(dt, t, self._gui, layout_settings.gear)
	end
end

function GearListPage:update_from_child_page(dt, t)
	self:update(dt, t, true)
end

function GearListPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "gear_list_page",
		name = page_config.name,
		parent_page = parent_page,
		items_callback = page_config.items_callback,
		items_callback_args = page_config.items_callback_args,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds or MenuSettings.sounds.default,
		render_parent_page = page_config.render_parent_page,
		specified_item_group = page_config.specified_item_group or "gear",
		item_layout_settings = MenuHelper:layout_settings(page_config.layout_settings)[page_config.specified_item_group or "gear"].item_layout_settings,
		reset_callback = page_config.reset_callback or "cb_reset_profile"
	}

	return GearListPage:new(config, item_groups, compiler_data.world)
end
