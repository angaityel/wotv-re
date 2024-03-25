-- chunkname: @scripts/menu/menu_pages/category_list_page.lua

CategoryListPage = class(CategoryListPage, MenuPage)

function CategoryListPage:init(config, item_groups, world)
	CategoryListPage.super.init(self, config, item_groups, world)

	self._world = world
	self._container = SimpleGridMenuContainer.create_from_config(self._item_groups.category)
end

function CategoryListPage:on_enter(on_cancel)
	CategoryListPage.super.on_enter(self, on_cancel)
	self:_create_items()
end

function CategoryListPage:on_exit(on_cancel)
	if on_cancel then
		self:_try_callback(self.config.callback_object, self.config.reset_callback)
	end
end

function CategoryListPage:set_dependency_object(object)
	self._dependency_object = object
end

function CategoryListPage:set_data(item_data)
	self._item_data = item_data
	self.config.camera = item_data.camera
end

function CategoryListPage:_create_items()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:remove_items("category")

	for _, name in ipairs(self._item_data.gear.categories) do
		local config

		if GameSettingsDevelopment.hide_unavailable_gear_categories then
			config = {
				remove_func = "cb_weapon_category_disabled",
				on_select = "cb_change_to_gear_page",
				layout_settings = "ProfileEditorSettings.items.category_item",
				name = name,
				text = name,
				ui_header = "ui_header_" .. name,
				ui_description = "ui_description_" .. name,
				on_select_args = {
					self._item_data.gear[name],
					"ProfileEditorSettings.items.gear_item",
					"cb_gear_selected",
					"cb_gear_highlighted",
					self.config.camera,
					self._item_data.weapon_slot,
					"cb_gear_highlighted_new_item",
					name
				},
				sounds = self.config.sounds,
				item_padding = {
					layout_settings.category.spacing_x or layout_settings.category.spacing,
					layout_settings.category.spacing_y or layout_settings.category.spacing
				},
				remove_args = {
					weapon_category = name
				},
				new_item = self:_unviewed_item_in_category(name)
			}
		else
			config = {
				disabled_text = "profile_editor_already_equipped",
				on_select = "cb_change_to_gear_page",
				layout_settings = "ProfileEditorSettings.items.category_item",
				disabled_func = "cb_weapon_category_disabled",
				name = name,
				text = name,
				ui_header = "ui_header_" .. name,
				ui_description = "ui_description_" .. name,
				on_select_args = {
					self._item_data.gear[name],
					"ProfileEditorSettings.items.gear_item",
					"cb_gear_selected",
					"cb_gear_highlighted",
					self.config.camera,
					self._item_data.weapon_slot,
					"cb_gear_highlighted_new_item",
					name
				},
				sounds = self.config.sounds,
				item_padding = {
					layout_settings.category.spacing_x or layout_settings.category.spacing,
					layout_settings.category.spacing_y or layout_settings.category.spacing
				},
				disabled_args = {
					weapon_category = name
				},
				new_item = self:_unviewed_item_in_category(name)
			}
		end

		local item = CategoryItem.create_from_config({
			world = self._world
		}, config, self.config.callback_object)

		self:add_item(item, "category")
	end
end

function CategoryListPage:update(dt, t, update_from_child_page)
	CategoryListPage.super.update(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self:_render(dt, t, layout_settings, update_from_child_page)
end

function CategoryListPage:update_from_child_page(dt, t)
	self:update(dt, t, true)
end

function CategoryListPage:_update_input(input)
	CategoryListPage.super._update_input(self, input)
	self:_update_mouse_over(input:get("cursor"), input:get("select_left_click"))
end

function CategoryListPage:_update_mouse_over(mouse_pos, left_click)
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

function CategoryListPage:_update_size(dt, t, layout_settings)
	local dep_width = self._dependency_object:width()
	local dep_height = self._dependency_object:height()

	self._container:update_size(dt, t, self._gui, layout_settings.category)
end

function CategoryListPage:_update_position(dt, t, layout_settings)
	local x = self._dependency_object._x
	local y = self._dependency_object._y - self._container:height()
	local z = self._dependency_object._z

	self._container:update_position(dt, t, layout_settings.category, x, y, z)
end

function CategoryListPage:_render(dt, t, layout_settings, render_from_child_page)
	if render_from_child_page then
		self._container:render_from_child_page(dt, t, self._gui, layout_settings.category)
	else
		self._container:render(dt, t, self._gui, layout_settings.category)
	end
end

function CategoryListPage:_unviewed_item_in_category(category)
	local gear_list = self._item_data.gear[category]

	for _, gear in ipairs(gear_list) do
		if UnviewedUnlockedItems[gear.name] then
			return true
		end
	end

	return false
end

function CategoryListPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "category_list_page",
		name = page_config.name,
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds or MenuSettings.sounds.default,
		render_parent_page = page_config.render_parent_page,
		camera = page_config.camera
	}

	return CategoryListPage:new(config, item_groups, compiler_data.world)
end
