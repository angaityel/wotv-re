-- chunkname: @scripts/menu/menu_pages/pdx_os_popup_menu_page.lua

require("scripts/menu/menu_containers/pdx_os_text_box_menu_container")

PDXPopupMenuPage = class(PDXPopupMenuPage, PopupMenuPage)

function PDXPopupMenuPage:init(config, item_groups, world)
	PDXPopupMenuPage.super.init(self, config, item_groups, world)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._warning_text_container = PdxOsTextBoxMenuContainer.create_from_config()

	self._warning_text_container:set_text(L("paradox_os_latin_character_warning"), layout_settings.warning_text, self._gui)
end

function PDXPopupMenuPage:on_enter()
	PDXPopupMenuPage.super.on_enter(self)
	self:_set_input_focus("popup_email")
end

function PDXPopupMenuPage:_update_input(input)
	if not self._big_picture_input_handler_active then
		if input:get("tab") then
			self:_switch_input_focus()
		end

		if input:get("select") then
			self:_log_in()
		end
	end
end

function PDXPopupMenuPage:_set_input_focus(name)
	local item, index = self:find_item_and_index_by_name(name)

	if item then
		self._current_highlight = index

		self:_select_item()
	end
end

function PDXPopupMenuPage:_switch_input_focus()
	local current_focus_index = self:_current_input_focus()

	if not current_focus_index then
		return
	end

	local item_list = self._items
	local num_items = #item_list
	local i = current_focus_index

	while true do
		i = i + 1

		if num_items < i then
			i = 1
		end

		local item = item_list[i]

		if item.config.type == "selectable_text_input" then
			break
		end
	end

	self._current_highlight = i

	self:_select_item()
end

function PDXPopupMenuPage:_current_input_focus()
	local item_list = self._items
	local num_items = #item_list

	for i = 1, num_items do
		local item = item_list[i]

		if item.config.type == "selectable_text_input" and item:selected() then
			return i
		end
	end
end

function PDXPopupMenuPage:_log_in()
	local item, index = self:find_item_and_index_by_name("popup_login")

	if item and not item.config.disabled then
		self._current_highlight = index

		self:_select_item()
	end
end

function PDXPopupMenuPage:find_item_and_index_by_name(name)
	local items = self._items
	local num_items = #items

	for i = 1, num_items do
		local item = items[i]

		if item.config.name == name then
			return item, i
		end
	end
end

function PDXPopupMenuPage:_update_container_size(dt, t)
	PDXPopupMenuPage.super._update_container_size(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._warning_text_container:update_size(dt, t, self._gui, layout_settings.warning_text)
end

function PDXPopupMenuPage:_update_container_position(dt, t)
	PDXPopupMenuPage.super._update_container_position(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._warning_text_container, layout_settings.warning_text)

	self._warning_text_container:update_position(dt, t, layout_settings.warning_text, x, y, self.config.z + 2)
end

function PDXPopupMenuPage:render(dt, t)
	PDXPopupMenuPage.super.render(self, dt, t)

	if not self._big_picture_input_handler_active then
		local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

		self._warning_text_container:render(dt, t, self._gui, layout_settings.warning_text)
	end
end

function PDXPopupMenuPage:_select_item(change_page_delay, ignore_sound)
	self:_deselect_items(self._current_highlight)
	PDXPopupMenuPage.super._select_item(self, change_page_delay, ignore_sound)
end

function PDXPopupMenuPage:_deselect_items(current_highlight)
	local highlight = current_highlight or -1

	for index, item in ipairs(self._items) do
		if index ~= highlight then
			item:on_deselect()
		end
	end
end

function PDXPopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "popup",
		render_parent_page = true,
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_options = page_config.on_enter_options,
		on_enter_options_args = page_config.on_enter_options_args or {},
		on_item_selected = page_config.on_item_selected,
		on_cancel_exit = page_config.on_cancel_exit,
		on_cancel_input = page_config.on_cancel_input,
		on_cancel_input_args = page_config.on_cancel_args,
		show_revision = page_config.show_revision,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment(),
		in_splash_screen = page_config.in_splash_screen,
		try_big_picture_input = page_config.try_big_picture_input,
		big_picture_input_params = page_config.big_picture_input_params,
		hide_banner = page_config.hide_banner
	}

	return PDXPopupMenuPage:new(config, item_groups, compiler_data.world)
end
