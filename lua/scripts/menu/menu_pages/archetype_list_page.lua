-- chunkname: @scripts/menu/menu_pages/archetype_list_page.lua

ArchetypeListPage = class(ArchetypeListPage, MenuPage)

function ArchetypeListPage:init(config, item_groups, world)
	ArchetypeListPage.super.init(self, config, item_groups, world)

	self._mouse_pos = {
		0,
		0
	}
	self._container = SimpleGridMenuContainer.create_from_config(self._item_groups.archetypes)
end

function ArchetypeListPage:set_position(x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function ArchetypeListPage:set_data(page_data)
	self._page_data = page_data
	self.config.camera = page_data.camera
end

function ArchetypeListPage:on_enter(on_cancel)
	ArchetypeListPage.super.on_enter(self, on_cancel)
	self:_create_items()
end

function ArchetypeListPage:set_dependency_object(object)
	self._dependency_object = object
end

function ArchetypeListPage:on_exit(on_cancel)
	if on_cancel then
		self:_try_callback(self.config.callback_object, self.config.reset_callback)
	end
end

function ArchetypeListPage:_create_items()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:remove_items("archetypes")

	for _, archetype_name in ipairs(self._page_data.archetypes) do
		local archetype = Archetypes[archetype_name]
		local config = {
			name = archetype.name,
			text = archetype.name,
			ui_header = "ui_header_" .. archetype.name,
			ui_description = "ui_description_" .. archetype.name,
			layout_settings = self._page_data.layout_settings,
			on_select = self._page_data.on_select,
			on_select_args = {
				archetype
			},
			remove_func = self._page_data.remove_func,
			remove_args = {
				archetype
			},
			sounds = self.config.sounds,
			item_padding = {
				layout_settings.archetype.spacing_x or layout_settings.archetype.spacing,
				layout_settings.archetype.spacing_y or layout_settings.archetype.spacing
			}
		}
		local item = CategoryItem.create_from_config({
			world = self._world
		}, config, self.config.callback_object)

		self:add_item(item, "archetypes")
	end
end

function ArchetypeListPage:_update_input(input)
	ArchetypeListPage.super._update_input(self, input)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	if input:has("cursor") then
		self:_update_mouse_over(input:get("cursor"), input:get("select_left_click"), layout_settings.archetype)
	end
end

function ArchetypeListPage:_update_scroller(mouse_pos, release_left, layout_settings)
	if not self._scroll_mouse_pos or release_left then
		self._scroll_mouse_pos = nil

		return
	end

	local diff = mouse_pos[2] - self._scroll_mouse_pos

	self._container:update_scroller_position(-diff * 2)

	self._scroll_mouse_pos = mouse_pos[2]
end

function ArchetypeListPage:_update_mouse_over(mouse_pos, left_click, layout_settings)
	self._mouse_pos = {
		mouse_pos[1],
		mouse_pos[2]
	}

	if not left_click then
		return
	end

	local x1 = self._dependency_object._x
	local x2 = x1 + self._dependency_object:width()
	local y1 = self._container:y()
	local y2 = self._dependency_object._y + self._dependency_object:height()

	if x1 > mouse_pos[1] or x2 < mouse_pos[1] or y1 > mouse_pos[2] or y2 < mouse_pos[2] then
		self:_cancel()
	end
end

function ArchetypeListPage:_is_mouse_inside()
	local x1 = self._container:x()
	local x2 = x1 + self._container:width()
	local y1 = self._container:y()
	local y2 = self._container:y() + self._container:height()

	return x1 < self._mouse_pos[1] and x2 > self._mouse_pos[1] and y1 < self._mouse_pos[2] and y2 > self._mouse_pos[2]
end

function ArchetypeListPage:_highlight_item(index, ignore_sound)
	if not Managers.input:pad_active(1) and not self:_is_mouse_inside() then
		ArchetypeListPage.super._highlight_item(self, nil)

		return
	end

	ArchetypeListPage.super._highlight_item(self, index, ignore_sound)
end

function ArchetypeListPage:update(dt, t)
	ArchetypeListPage.super.update(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self._container:render(dt, t, self._gui, layout_settings.archetype)
end

function ArchetypeListPage:_update_size(dt, t, layout_settings)
	local dep_width = self._dependency_object:width()
	local dep_height = self._dependency_object:height()

	self._container:update_size(dt, t, self._gui, layout_settings.archetype)
end

function ArchetypeListPage:_update_position(dt, t, layout_settings)
	local x = self._dependency_object._x
	local y = self._dependency_object._y - self._container:height()
	local z = self._dependency_object._z

	self._container:update_position(dt, t, layout_settings.archetype, x, y, z)
end

function ArchetypeListPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "perk_list_page",
		name = page_config.name,
		parent_page = parent_page,
		items_callback = page_config.items_callback,
		items_callback_args = page_config.items_callback_args,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds or MenuSettings.sounds.default,
		render_parent_page = page_config.render_parent_page,
		specified_item_group = page_config.specified_item_group or "archetypes",
		item_layout_settings = page_config.item_layout_settings or "ProfileSettings.items.perk_item"
	}

	return ArchetypeListPage:new(config, item_groups, compiler_data.world)
end
