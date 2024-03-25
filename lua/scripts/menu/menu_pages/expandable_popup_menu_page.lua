-- chunkname: @scripts/menu/menu_pages/expandable_popup_menu_page.lua

ExpandablePopupMenuPage = class(ExpandablePopupMenuPage, MenuPage)

function ExpandablePopupMenuPage:init(config, item_groups, world)
	ExpandablePopupMenuPage.super.init(self, config, item_groups, world)

	self._world = world
	self.config.on_enter_options_args.popup_page = self
	self._item_list = ItemListMenuContainer.create_from_config(item_groups.item_list)
	self._background_rect = RectMenuContainer.create_from_config()
	self._background_texture = TextureMenuContainer.create_from_config()
end

function ExpandablePopupMenuPage:on_enter()
	ExpandablePopupMenuPage.super.on_enter(self)

	self._scroll_bar = self._item_groups.scroll_bar[1]

	self:_try_callback(self.config.callback_object, self.config.on_enter_options, self.config.on_enter_options_args)
end

function ExpandablePopupMenuPage:update(dt, t)
	ExpandablePopupMenuPage.super.update(self, dt, t)
	self:_update_container_size(dt, t)
	self:_update_container_position(dt, t)
end

function ExpandablePopupMenuPage:_update_container_size(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:update_size(dt, t, self._gui, layout_settings.item_list)
	self._background_texture:update_size(dt, t, self._gui, layout_settings.background_texture)

	layout_settings.background_rect.absolute_height = self._item_list:height()

	self._background_rect:update_size(dt, t, self._gui, layout_settings.background_rect)

	local layout_settings = MenuHelper:layout_settings(SplashScreenSettings.items.scroll_bar)
	local popup_text = self._item_list:get_item_by_name("popup_text")
	local popup_text_height = popup_text and popup_text:height() or self._item_list:height()

	if self._scroll_bar then
		self._scroll_bar:update_size(dt, t, self._gui, layout_settings, layout_settings.scroll_bar_handle_width, popup_text_height, popup_text_height)
	end
end

function ExpandablePopupMenuPage:_update_container_position(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._item_list, layout_settings.item_list)

	self._item_list:update_position(dt, t, layout_settings.item_list, x, y, self.config.z + 3)

	local x = self._item_list:x() + self._item_list:width() - self._background_texture:width()
	local y = self._item_list:y()

	self._background_texture:update_position(dt, t, layout_settings.background_texture, x, y, self.config.z + 1)

	local x, y = MenuHelper:container_position(self._background_rect, layout_settings.background_rect)

	self._background_rect:update_position(dt, t, layout_settings.background_rect, x, y, self.config.z + 1)

	local layout_settings = MenuHelper:layout_settings(SplashScreenSettings.items.scroll_bar)
	local popup_text = self._item_list:get_item_by_name("popup_text")
	local x = self._item_list:x() + self._item_list:width() - layout_settings.scroll_bar_handle_width
	local y = popup_text and popup_text:y() or self._item_list:y()

	if self._scroll_bar then
		self._scroll_bar:update_position(dt, t, layout_settings, x, y, self.config.z + 2)
	end
end

function ExpandablePopupMenuPage:render(dt, t)
	ExpandablePopupMenuPage.super.render(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:render(dt, t, self._gui, layout_settings.item_list)
	self._background_texture:render(dt, t, self._gui, layout_settings.background_texture)
	self._background_rect:render(dt, t, self._gui, layout_settings.background_rect)

	local layout_settings = MenuHelper:layout_settings(SplashScreenSettings.items.scroll_bar)

	if self._scroll_bar then
		self._scroll_bar:render(dt, t, self._gui, layout_settings)
	end
end

function ExpandablePopupMenuPage:cb_item_selected(popup_action, parent_page_action)
	local parent_page_args = {
		action = parent_page_action,
		popup_page = self
	}

	self:_try_callback(self.config.callback_object, self.config.on_item_selected, parent_page_args)

	if popup_action == "close" then
		self._menu_logic:change_page(self.config.parent_page)
	end
end

function ExpandablePopupMenuPage:cb_item_disabled(disabled_func)
	local parent_page_args = {
		popup_page = self
	}

	return self:_try_callback(self.config.callback_object, disabled_func, parent_page_args)
end

function ExpandablePopupMenuPage:cb_scroll_select_down(row)
	local popup_text = self._item_list:get_item_by_name("popup_text")

	if not popup_text then
		return true
	end

	popup_text:set_current_row(row)
end

function ExpandablePopupMenuPage:cb_scroll_disabled()
	if not self._scroll_bar then
		return true
	end

	local popup_text = self._item_list:get_item_by_name("popup_text")

	if not popup_text then
		return true
	end

	local top_visible_row, num_visible_rows, total_num_of_rows = popup_text:get_scroll_data()

	if not top_visible_row or not num_visible_rows or not total_num_of_rows then
		return true
	end

	if num_visible_rows < total_num_of_rows then
		self._scroll_bar:set_grid_properties(top_visible_row, num_visible_rows, total_num_of_rows)

		return false
	end

	return true
end

function ExpandablePopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "popup",
		render_parent_page = true,
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_options = page_config.on_enter_options,
		on_enter_options_args = page_config.on_enter_options_args or {},
		on_item_selected = page_config.on_item_selected,
		on_cancel_exit = page_config.on_cancel_exit,
		reverse_input_direction = page_config.reverse_input_direction,
		show_revision = page_config.show_revision,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment(),
		in_splash_screen = page_config.in_splash_screen
	}

	return ExpandablePopupMenuPage:new(config, item_groups, compiler_data.world)
end
