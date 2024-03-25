-- chunkname: @scripts/menu/hierachical_layout_menu/base_pages/hl_menu_page.lua

require("scripts/helpers/menu_helper")
require("scripts/hud/hud_elements_buttons_x360")
require("scripts/menu/menu_assets")

HLMenuPage = class(HLMenuPage)

function HLMenuPage:init(world, config)
	self.config = config
	self._current_highlight = nil
	self._parent_item = nil
	self._gui = World.get_data(world, "menu_gui")
	self._components = {}
	self._render_rect = {}
	self._world = world
	self._width = config.width
	self._height = config.height
	self._component_shortcuts = {}
end

function HLMenuPage:update(dt, t)
	self:_update_components_layout_settings(dt, t)
	self:_update_components_sizes(dt, t)
	self:_update_components_positions(dt, t)
end

function HLMenuPage:update_from_child_page(dt, t)
	self:update(dt, t)
end

function HLMenuPage:set_input(input)
	self:_update_input(input)
	self:_update_mouse_hover(input)
end

function HLMenuPage:_update_input(input)
	if not input then
		return
	end

	if input:has("cancel") and input:get("cancel") then
		self:_try_cancel()
	end
end

function HLMenuPage:_update_mouse_hover(input)
	local mouse_pos = input:has("cursor") and input:get("cursor")

	if not mouse_pos then
		if Window.show_cursor() or not self._current_highlight then
			self:_auto_highlight_first_item()
		end

		Window.set_show_cursor(false)

		return
	elseif not Window.show_cursor() then
		Window.set_show_cursor(true)
	end

	local highlighted_item = self:_calculate_highlighted_item(mouse_pos.x, mouse_pos.y)

	if highlighted_item then
		self:_highlight_item(highlighted_item)

		if input:get("select_left_click") then
			self:_on_left_click()
		end

		if input:get("select_right_click") then
			self:_on_right_click()
		end
	else
		self:_highlight_item(nil)
	end

	for _, component in ipairs(self._components) do
		component:update_mouse_hover(input)
	end
end

function HLMenuPage:_calculate_highlighted_item(mouse_pos_x, mouse_pos_y)
	for _, component in ipairs(self._components) do
		local highlighted_item = component:calculate_highlighted_item(mouse_pos_x, mouse_pos_y)

		if highlighted_item then
			return highlighted_item
		end
	end

	return nil
end

function HLMenuPage:_auto_highlight_first_item()
	return
end

function HLMenuPage:_update_components_layout_settings(dt, t)
	for _, component in ipairs(self._components) do
		component:update_layout_settings(dt, t)
	end
end

function HLMenuPage:_update_components_sizes(dt, t)
	local gui = self._gui

	for _, component in ipairs(self._components) do
		local width = component:calculate_width(dt, t, gui, self)
		local height = component:calculate_height(dt, t, gui, self)

		component:update_size(dt, t, gui, width, height)
	end
end

function HLMenuPage:_update_components_positions(dt, t)
	for _, component in ipairs(self._components) do
		local x = component:calculate_x(self)
		local y = component:calculate_y(self)
		local z = component:calculate_z(self)

		component:update_position(dt, t, x, y, z)
	end
end

function HLMenuPage:render(dt, t)
	if self.config.render_parent_page then
		local parent_page = self:parent_page()

		parent_page:render_from_child_page(dt, t, self)
	end

	for _, component in ipairs(self._components) do
		local intersection, x, y, width, height = MenuHelper:intersection_rect(self:x(), self:y(), self:width(), self:height(), component:x(), component:y(), component:width(), component:height())

		if intersection then
			local rect = self._render_rect

			rect[1] = x
			rect[2] = y
			rect[3] = width
			rect[4] = height

			component:render(dt, t, self._gui, rect)
		end
	end
end

function HLMenuPage:_render_button_info(layout_settings)
	local button_config = layout_settings.default_buttons
	local text_data = layout_settings.text_data
	local w, h = Gui.resolution()
	local x = text_data.offset_x or 0
	local y = text_data.offset_y or 0
	local offset_x = 0
	local standard_button_size = {
		56,
		56
	}

	for _, button in ipairs(button_config) do
		local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(button.button_name)
		local button_offset = {
			type(button.button_name) == "table" and #button.button_name * standard_button_size[1] or standard_button_size[1],
			size[2] == standard_button_size[2] and standard_button_size[2] or size[2] * 1.3
		}

		if type(button.button_name) == "table" then
			for i, button_name in ipairs(button.button_name) do
				local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(button_name)
				local inner_button_offset = {
					type(button.button_name) == "table" and #button.button_name * standard_button_size[1] or standard_button_size[1],
					size[2] == standard_button_size[2] and standard_button_size[2] or size[2] * 1.3
				}

				Gui.bitmap_uv(self._button_gui, material, uv00, uv11, Vector3(x + offset_x + (i - 1) * standard_button_size[1], y - inner_button_offset[2], 999), size)
			end
		else
			Gui.bitmap_uv(self._button_gui, material, uv00, uv11, Vector3(x + offset_x, y - button_offset[2], 999), size)
		end

		local text = string.upper(L(button.text))

		Gui.text(self._button_gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + button_offset[1] + offset_x, y - standard_button_size[2] * 0.62, 999))

		if text_data.drop_shadow then
			local drop_x, drop_y = unpack(text_data.drop_shadow)

			Gui.text(self._button_gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + button_offset[1] + offset_x + drop_x, y - standard_button_size[2] * 0.62 + drop_y, 998), Color(0, 0, 0))
		end

		local min, max = Gui.text_extents(self._button_gui, text, text_data.font.font, text_data.font_size)

		offset_x = offset_x + (max[1] - min[1]) + button_offset[1]
	end
end

function HLMenuPage:render_from_child_page(dt, t)
	self:render(dt, t, true)
end

function HLMenuPage:_try_callback(callback_object, callback_name, ...)
	if callback_object and callback_name and callback_object[callback_name] then
		return callback_object[callback_name](callback_object, ...)
	end
end

function HLMenuPage:_try_cancel()
	if self.config.on_cancel_input then
		local callback_object = self.config.callback_object

		if self.config.on_cancel_input_callback_object == "page" then
			callback_object = self
		end

		self:_try_callback(callback_object, self.config.on_cancel_input, self.config.on_cancel_input_args)
	end

	if not self.config.no_cancel_to_parent_page then
		self:_cancel()
	end
end

function HLMenuPage:_on_left_click()
	local highlighted_item = self._highlighted_item

	if not highlighted_item then
		return
	end

	highlighted_item:on_select()
end

function HLMenuPage:_on_right_click(change_page_delay, ignore_sound)
	local highlighted_item = self._highlighted_item

	if not highlighted_item then
		return
	end

	if highlighted_item.on_right_click then
		highlighted_item:on_right_click(ignore_sound)
	end
end

function HLMenuPage:_cancel()
	self._menu_logic:cancel_to_parent()
end

function HLMenuPage:parent_page()
	return self.config.parent_page
end

function HLMenuPage:components()
	return self._components
end

function HLMenuPage:add_component(component)
	self._components[#self._components + 1] = component

	self:_add_component_shortcuts(component, self._component_shortcuts)
end

function HLMenuPage:_add_component_shortcuts(component, current_shortcut_table)
	local namespace_path = component:namespace_path()
	local component_shortcuts = current_shortcut_table

	self:_add_component_shortcut(component, current_shortcut_table)

	local namespace = component:namespace()

	if namespace then
		local new_namespace = {}

		fassert(not component_shortcuts[namespace], "a namespace with name %q already exists within its scope on page %q", component:name(), self:name())

		component_shortcuts[namespace] = new_namespace
		component_shortcuts = new_namespace
	end

	if component:has_components() then
		local components = component:components()

		for _, child_component in ipairs(components) do
			self:_add_component_shortcuts(child_component, component_shortcuts)
		end
	end
end

function HLMenuPage:_add_component_shortcut(component, shortcut_table)
	local name = component:name()

	if name then
		fassert(not shortcut_table[name], "a component with name %q already exists on page %q", name, self:name())

		shortcut_table[name] = component
	end
end

function HLMenuPage:component_by_namespace_path(component_name, namespace_path)
	local shortcuts = self._component_shortcuts

	for _, key in ipairs(namespace_path) do
		shortcuts = shortcuts[key]
	end

	return shortcuts[component_name]
end

function HLMenuPage:num_components()
	return #self._components
end

function HLMenuPage:set_parent_component(component)
	self._parent_component = component
end

function HLMenuPage:cb_controller_enabled()
	return Managers.input:pad_active(1)
end

function HLMenuPage:cb_controller_disabled()
	return Managers.input:active_mapping(1) == "keyboard_mouse"
end

function HLMenuPage:cb_goto_menu_page(id)
	self._menu_logic:goto(id)
end

function HLMenuPage:cb_return_true()
	return true
end

function HLMenuPage:layout_settings()
	MenuHelper:layout_settings(self.config.layout_settings)
end

function HLMenuPage:items()
	return self._components
end

function HLMenuPage:set_parent_item(item)
	self._parent_item = item
end

function HLMenuPage:menu_activated()
	return
end

function HLMenuPage:menu_deactivated()
	return
end

function HLMenuPage:camera()
	return self.config.camera
end

function HLMenuPage:set_menu_logic(menu_logic)
	self._menu_logic = menu_logic
end

function HLMenuPage:on_enter(on_cancel)
	local controller_active = Managers.input:pad_active(1)

	if controller_active and not self.config.do_not_select_first_index then
		local item = self:_first_highlightable_item()

		if item then
			self:_highlight_item(item)
		end
	elseif not self.config.do_not_select_first_index then
		self:_highlight_item(nil)
	end

	for _, component in ipairs(self._components) do
		component:on_page_enter(on_cancel)
	end

	if self.config.on_enter_highlight_item then
		self:_on_enter_highlight_item()
	end
end

function HLMenuPage:on_exit(on_cancel)
	for _, component in ipairs(self._components) do
		component:on_page_exit(on_cancel)
	end
end

function HLMenuPage:_highlight_item(item)
	local current_highlighted_item = self._highlighted_item

	if current_highlighted_item and current_highlighted_item ~= item then
		current_highlighted_item:on_lowlight()
	end

	if item and current_highlighted_item ~= item then
		item:on_highlight()
	end

	self._highlighted_item = item
end

function HLMenuPage:_first_highlightable_item()
	fassert(nil, "[HLMenuPage] No idea what logically should be the first highlighted item.")
end

function HLMenuPage:x()
	return 0
end

function HLMenuPage:y()
	return 0
end

function HLMenuPage:z()
	return 0
end

function HLMenuPage:width()
	local res_width, res_height = Gui.resolution()

	return res_width
end

function HLMenuPage:height()
	local res_width, res_height = Gui.resolution()

	return res_height
end

function HLMenuPage:name()
	return self.config.name
end

function HLMenuPage:destroy()
	if self._destroyed then
		return
	end

	self._destroyed = true

	for _, component in ipairs(self._components) do
		component:destroy()
	end
end

function HLMenuPage.create_from_config(compiler_data, page_config, parent_page, callback_object)
	page_config.local_player = compiler_data.menu_data.local_player
	page_config.parent_page = parent_page

	return HLMenuPage:new(compiler_data.world, page_config)
end
