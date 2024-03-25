-- chunkname: @scripts/menu/hierachical_layout_menu/base_containers/hl_menu_scroll_container.lua

HLMenuScrollContainer = class(HLMenuScrollContainer, HLMenuContainer)

function HLMenuScrollContainer:init(world, config)
	HLMenuScrollContainer.super.init(self, world, config)

	local layout_settings = self:layout_settings()
	local scroll_bar_layout_settings = MainMenuSettings.base_scroll_bar
	local config = {
		namespace_path = self:namespace_path(),
		layout_settings = scroll_bar_layout_settings,
		background_func = config.scroll_bar_background_func,
		border_func = config.scroll_bar_border_func
	}

	self._scroll_bar_container = HLMenuContainer.create_from_config(self._world, config)
	self._slider_delta = 0
	self._scrolling = false
end

function HLMenuScrollContainer:add_component(component)
	HLMenuScrollContainer.super.add_component(self, component)
end

function HLMenuScrollContainer:update_size(dt, t, gui, width, height)
	HLMenuScrollContainer.super.update_size(self, dt, t, gui, width, height)

	local layout_settings = self:layout_settings()
	local show_scroll_bar = self:_show_scroll_bar()
	local bar_width = show_scroll_bar and layout_settings.scroll_bar_width or 0
	local bar_height = self:height()

	self._scroll_bar_container:update_size(dt, t, gui, bar_width, bar_height)
end

function HLMenuScrollContainer:update_position(dt, t, x, y, z)
	HLMenuScrollContainer.super.super.update_position(self, dt, t, x, y, z)

	for _, component in ipairs(self._components) do
		local self_y = self:y()
		local self_height = self:height()
		local component_height = component:height()
		local component_x = component:calculate_x(self)
		local component_y = self_y + self_height - component_height + self._slider_delta * (component_height - self_height)
		local component_z = component:calculate_z(self)

		component:update_position(dt, t, component_x, component_y, component_z)
	end

	local layout_settings = self:layout_settings()
	local bar_x = layout_settings.scroll_bar_alignment == "right" and self:x() + self:width() or self:x() - layout_settings.scroll_bar_width
	local bar_y = self:y()
	local bar_z = self:z()

	self._scroll_bar_container:update_position(dt, t, bar_x, bar_y, bar_z)
end

function HLMenuScrollContainer:render(dt, t, gui, render_rect)
	HLMenuScrollContainer.super.render(self, dt, t, gui, render_rect)

	local layout_settings = self:layout_settings()
	local show_scroll_bar = self:_show_scroll_bar()

	if show_scroll_bar then
		self._scroll_bar_container:render(dt, t, gui)

		local slider_x, sider_y, slider_width, slider_height = self:_slider_settings()
		local c = layout_settings.slider_color

		Gui.rect(gui, Vector3(slider_x, sider_y, self:z()), Vector2(slider_width, slider_height), Color(c[1], c[2], c[3], c[4]))
	end

	local width, height = Gui.resolution()

	Gui.bitmap(gui, "mask_rect_alpha", Vector3(0, 0, 0), Vector2(width, height), Color(0, 0, 0, 0))
	Gui.bitmap(gui, "mask_rect_alpha", Vector3(self:x(), self:y(), self:z()), Vector2(self:width(), self:height()), Color(255, 0, 0, 0))
end

function HLMenuScrollContainer:_show_scroll_bar()
	local total_component_height = 0
	local show = false

	for _, component in ipairs(self._components) do
		total_component_height = total_component_height + component:height()
	end

	show = total_component_height > self:height()

	return show
end

function HLMenuScrollContainer:_slider_settings()
	local total_component_height = 0
	local layout_settings = self:layout_settings()

	for _, component in ipairs(self._components) do
		total_component_height = total_component_height + component:height()
	end

	local self_height = self:height()
	local scroll_bar = self._scroll_bar_container
	local slider_margin = layout_settings.slider_margin
	local width = scroll_bar:width() - slider_margin * 2
	local height = self_height / total_component_height * self_height
	local x = self._scroll_bar_container:x() + slider_margin
	local y = scroll_bar:y() + scroll_bar:height() - height - slider_margin - self._slider_delta * (scroll_bar:height() - height - slider_margin * 2)

	return x, y, width, height
end

function HLMenuScrollContainer:update_mouse_hover(input)
	local mouse_pos = input:get("cursor")
	local mouse_x = mouse_pos.x
	local mouse_y = mouse_pos.y
	local layout_settings = self:layout_settings()
	local scroll_bar = self._scroll_bar_container

	if self:_show_scroll_bar() then
		local x, y, width, height = self:_slider_settings()
		local mouse_in_scroll_bar = scroll_bar:is_mouse_inside(mouse_x, mouse_y)

		if mouse_in_scroll_bar or self._scrolling then
			if input:get("select_down") > 0 then
				local slider_margin = layout_settings.slider_margin
				local top_y = scroll_bar:y() + scroll_bar:height() - height * 0.5 - slider_margin
				local bot_y = scroll_bar:y() + height * 0.5 + slider_margin

				if bot_y < mouse_y and mouse_y < top_y then
					self._slider_delta = (top_y - mouse_y) / (top_y - bot_y)
				elseif mouse_y <= bot_y then
					self._slider_delta = 1
				elseif top_y <= mouse_y then
					self._slider_delta = 0
				end

				self._scrolling = true
			else
				self._scrolling = false
			end
		end

		if (self:is_mouse_inside(mouse_x, mouse_y) or mouse_in_scroll_bar) and not self._scrolling and input:has("wheel") then
			local y = input:get("wheel").y
			local scroll_speed = 0.15 * height / scroll_bar:height()
			local scroll_sensitivity = 0.9

			if y ~= 0 then
				if y < -scroll_sensitivity then
					self._slider_delta = self._slider_delta + scroll_speed < 1 and self._slider_delta + scroll_speed or 1
				elseif scroll_sensitivity < y then
					self._slider_delta = self._slider_delta - scroll_speed > 0 and self._slider_delta - scroll_speed or 0
				end
			end
		end
	end
end

function HLMenuScrollContainer:on_page_enter(on_cancel)
	HLMenuScrollContainer.super.on_page_enter(self, on_cancel)

	self._slider_delta = 0
end

function HLMenuScrollContainer.create_from_config(world, config, callback_object)
	return HLMenuScrollContainer:new(world, config)
end
