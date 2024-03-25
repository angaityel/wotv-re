-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_extended_container.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")

HUDExtendedContainer = class(HUDExtendedContainer, HUDContainerElement)

function HUDExtendedContainer:update_size(dt, t, gui, layout_settings)
	local res_width, res_height = Gui.resolution()
	local num_of_elements = self:num_of_elements()

	self._width = 0
	self._height = layout_settings.height or res_height

	for id, element in pairs(self._elements) do
		element:update_size(dt, t, gui, HUDHelper:layout_settings(element.config.layout_settings))

		self._width = self._width + element:width() * element.sign
	end
end

function HUDExtendedContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	for id, element in pairs(self._elements) do
		local element_layout_settings = HUDHelper:layout_settings(element.config.layout_settings)
		local offset_x, offset_y = HUDHelper:element_position(self, element, element_layout_settings)
		local extra_offset = element_layout_settings.offset_x_func and element_layout_settings.offset_x_func(element, element_layout_settings) or 0
		local element_x = x + offset_x + extra_offset
		local element_y = offset_y + y
		local element_z = (element.config.z or 1) + z

		element:update_position(dt, t, element_layout_settings, element_x, element_y, element_z)
	end
end

function HUDExtendedContainer.create_from_config(config)
	return HUDExtendedContainer:new(config)
end
