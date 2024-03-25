-- chunkname: @scripts/menu/menu_pages/wotv_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")
require("scripts/menu/menu_pages/main_menu_page")

WotvMenuPage = class(WotvMenuPage, MenuPage)

function WotvMenuPage:init(config, item_groups, world)
	WotvMenuPage.super.init(self, config, item_groups, world)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list = ItemListMenuContainer.create_from_config(item_groups.item_list)

	if layout_settings.page_name then
		self._page_name = ItemListMenuContainer.create_from_config(item_groups.page_name)
	end

	if layout_settings.links then
		self._links = ItemListMenuContainer.create_from_config(item_groups.links)
	end

	self._logo_texture = layout_settings.logo_texture and TextureMenuContainer.create_from_config()
end

function WotvMenuPage:on_enter(on_cancel)
	WotvMenuPage.super.on_enter(self, on_cancel)

	if self.config.on_enter_page then
		self:_try_callback(self.config.callback_object, self.config.on_enter_page, unpack(self.config.on_enter_page_args))
	end
end

function WotvMenuPage:update(dt, t)
	if self:_update_condition(dt, t) then
		WotvMenuPage.super.update(self, dt, t)
	end

	self:_update_container_size(dt, t)
	self:_update_container_position(dt, t)
end

function WotvMenuPage:_update_condition(dt, t)
	if not self.config.update_condition then
		return true
	else
		return self:_try_callback(self.config.callback_object, self.config.update_condition, self.config.update_condition_args and unpack(self.config.update_condition_args))
	end
end

function WotvMenuPage:_update_container_size(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:update_size(dt, t, self._gui, layout_settings.item_list)

	if self._page_name then
		self._page_name:update_size(dt, t, self._gui, layout_settings.page_name)
	end

	if self._links then
		self._links:update_size(dt, t, self._gui, layout_settings.links)
	end

	if self._logo_texture then
		self._logo_texture:update_size(dt, t, self._gui, layout_settings.logo_texture)
	end
end

function WotvMenuPage:_update_container_position(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local x, y = MenuHelper:container_position(self._item_list, layout_settings.item_list)

	self._item_list:update_position(dt, t, layout_settings.item_list, x, y, self.config.z + 15)

	if self._page_name then
		local x, y = MenuHelper:container_position(self._page_name, layout_settings.page_name)

		self._page_name:update_position(dt, t, layout_settings.page_name, x, y, self.config.z + 20)
	end

	if self._links then
		local x, y = MenuHelper:container_position(self._links, layout_settings.links)

		self._links:update_position(dt, t, layout_settings.links, x, y, self.config.z + 20)
	end

	if self._logo_texture then
		local x, y = MenuHelper:container_position(self._logo_texture, layout_settings.logo_texture)

		self._logo_texture:update_position(dt, t, layout_settings.logo_texture, x, y, self.config.z + 10)
	end
end

function WotvMenuPage:render_from_child_page(dt, t, leef)
	if script_data.hide_title_screen then
		return
	end

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._item_list:render_from_child_page(dt, t, self._gui, layout_settings.item_list)
	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)

	if self._page_name then
		self._page_name:render_from_child_page(dt, t, self._gui, layout_settings.page_name)
	end
end

function WotvMenuPage:render(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)

	if self._page_name then
		self._page_name:render(dt, t, self._gui, layout_settings.page_name)
	end

	if not self:_update_condition(dt, t) then
		return
	end

	if script_data.hide_title_screen then
		return
	end

	WotvMenuPage.super.render(self, dt, t)
	self._item_list:render(dt, t, self._gui, layout_settings.item_list)

	if layout_settings.stripe then
		self:_render_stripe(dt, t, layout_settings.stripe)
	end

	if self._links then
		self._links:render(dt, t, self._gui, layout_settings.links)
	end

	if self._logo_texture then
		self._logo_texture:render(dt, t, self._gui, layout_settings.logo_texture)
	end
end

function WotvMenuPage:_render_stripe(dt, t, layout_settings)
	local w, h = Gui.resolution()
	local width = layout_settings.width and layout_settings.width * w or w
	local height = layout_settings.height and layout_settings.height * h or w
	local x = w * 0.5 - width * 0.5
	local y = h * 0.5 - height * 0.5
	local pos = Vector3(x, y, self.config.z + (layout_settings.z or 0))

	Gui.rect(self._gui, pos, Vector2(width, height), MenuHelper:color(layout_settings.bg_color or {
		255,
		255,
		255,
		255
	}))
	MenuHelper:render_border(self._gui, {
		x,
		y,
		width,
		height
	}, layout_settings.border_thickness or 1, MenuHelper:color(layout_settings.border_color or {
		255,
		0,
		0,
		0
	}))
end

function WotvMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "wotv_menu_page",
		name = page_config.name,
		parent_page = parent_page,
		callback_object = callback_object,
		on_enter_page = page_config.on_enter_page,
		on_enter_page_args = page_config.on_enter_page_args,
		update_condition = page_config.update_condition,
		update_condition_args = page_config.update_condition_args,
		on_exit_page = page_config.on_exit_page,
		z = page_config.z,
		on_enter_highlight_item = page_config.on_enter_highlight_item,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page,
		on_cancel_input = page_config.on_cancel_input,
		on_cancel_input_args = page_config.on_cancel_input_args,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment(),
		camera = page_config.camera or parent_page and parent_page:camera()
	}

	return WotvMenuPage:new(config, item_groups, compiler_data.world)
end

function WotvMenuPage:cb_single_player_enabled()
	return true
end

function WotvMenuPage:cb_disable_single_player()
	if IS_DEMO or GameSettingsDevelopment.disable_singleplayer then
		return true
	end
end

function WotvMenuPage:cb_disable_coat_of_arms()
	if IS_DEMO or GameSettingsDevelopment.disable_coat_of_arms_editor then
		return true
	end
end

function WotvMenuPage:cb_return_to_main()
	self:_try_cancel()
end

function WotvMenuPage:cb_page_name()
	return self.config.name or "No name specified"
end
