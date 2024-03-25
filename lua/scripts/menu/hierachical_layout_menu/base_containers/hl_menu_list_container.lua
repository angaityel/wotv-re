-- chunkname: @scripts/menu/hierachical_layout_menu/base_containers/hl_menu_list_container.lua

HLMenuListContainer = class(HLMenuListContainer, HLMenuContainer)

function HLMenuListContainer:init(world, config)
	HLMenuListContainer.super.init(self, world, config)
end

function HLMenuListContainer:update_size(dt, t, gui, width, height)
	local total_component_height = 0
	local largest_component_width = 0

	for _, component in ipairs(self._components) do
		local component_width = component:calculate_width(dt, t, gui, self)
		local component_height = component:calculate_height(dt, t, gui, self)

		component:update_size(dt, t, gui, component_width, component_height)

		total_component_height = total_component_height + component_height

		if largest_component_width < component_width then
			largest_component_width = component_width
		end
	end

	HLMenuListContainer.super.update_size(self, dt, t, gui, largest_component_width, total_component_height)
end

function HLMenuListContainer:update_position(dt, t, x, y, z)
	HLMenuListContainer.super.update_position(self, dt, t, x, y, z)

	local total_height = 0

	for _, component in ipairs(self._components) do
		local component_height = component:height()
		local x = component:calculate_x(self)
		local y = self:y() + self:height() - component_height - total_height
		local z = component:calculate_z(self)

		component:update_position(dt, t, x, y, z)

		total_height = total_height + component_height
	end
end

function HLMenuListContainer.create_from_config(world, config, callback_object)
	return HLMenuListContainer:new(world, config)
end
