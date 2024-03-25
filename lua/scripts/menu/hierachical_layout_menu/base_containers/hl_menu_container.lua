-- chunkname: @scripts/menu/hierachical_layout_menu/base_containers/hl_menu_container.lua

HLMenuContainer = class(HLMenuContainer, HLMenuComponent)

function HLMenuContainer:init(world, config)
	HLMenuContainer.super.init(self, world, config)

	self._components = {}
	self._render_rect = {}
end

function HLMenuContainer:add_component(component)
	self._components[#self._components + 1] = component
end

function HLMenuContainer:remove_component(component_to_remove)
	local index_to_remove

	for key, component in ipairs(self._components) do
		if component_to_remove == component then
			index_to_remove = key

			break
		end
	end

	fassert(index_to_remove, "trying to remove a component from container %q that does not exisit within it", component_to_remove:name())
	table.remove(self._components, index_to_remove)
end

function HLMenuContainer:components()
	return self._components
end

function HLMenuContainer:has_components()
	return #self._components > 0
end

function HLMenuContainer:update_layout_settings(dt, t)
	HLMenuContainer.super.update_layout_settings(self, dt, t)

	for _, component in ipairs(self._components) do
		component:update_layout_settings(dt, t)
	end
end

function HLMenuContainer:update_size(dt, t, gui, width, height)
	HLMenuContainer.super.update_size(self, dt, t, gui, width, height)

	for _, component in ipairs(self._components) do
		local component_width = component:calculate_width(dt, t, gui, self)
		local component_height = component:calculate_height(dt, t, gui, self)

		component:update_size(dt, t, gui, component_width, component_height)
	end
end

function HLMenuContainer:update_position(dt, t, x, y, z)
	HLMenuContainer.super.update_position(self, dt, t, x, y, z)

	for _, component in ipairs(self._components) do
		local component_x = component:calculate_x(self)
		local component_y = component:calculate_y(self)
		local component_z = component:calculate_z(self)

		component:update_position(dt, t, component_x, component_y, component_z)
	end
end

function HLMenuContainer:render(dt, t, gui, render_rect)
	HLMenuContainer.super.render(self, dt, t, gui, render_rect)

	for _, component in ipairs(self._components) do
		local intersection, x, y, width, height = MenuHelper:intersection_rect(render_rect[1], render_rect[2], render_rect[3], render_rect[4], component:x(), component:y(), component:width(), component:height())

		if intersection then
			local rect = self._render_rect

			rect[1] = x
			rect[2] = y
			rect[3] = width
			rect[4] = height

			component:render(dt, t, gui, rect)
		end
	end
end

function HLMenuContainer:update_mouse_hover(input)
	HLMenuContainer.super.update_mouse_hover(self, input)

	for _, component in ipairs(self._components) do
		component:update_mouse_hover(input)
	end
end

function HLMenuContainer:calculate_highlighted_item(mouse_x, mouse_y)
	for _, component in ipairs(self._components) do
		local highlighted_item = component:calculate_highlighted_item(mouse_x, mouse_y)

		if highlighted_item then
			return highlighted_item
		end
	end

	return nil
end

function HLMenuContainer:on_page_enter(on_cancel)
	HLMenuContainer.super.on_page_enter(self, on_cancel)

	for _, component in ipairs(self._components) do
		component:on_page_enter(on_cancel)
	end
end

function HLMenuContainer:destroy()
	return
end

function HLMenuContainer.create_from_config(world, config, callback_object)
	return HLMenuContainer:new(world, config)
end
