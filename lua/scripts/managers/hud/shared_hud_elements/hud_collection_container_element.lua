-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_collection_container_element.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")

HUDCollectionContainerElement = class(HUDCollectionContainerElement, HUDContainerElement)

function HUDCollectionContainerElement:update_size(dt, t, gui, layout_settings)
	local spacing = layout_settings.spacing

	fassert(spacing, "Missing \"spacing\" in layout settings for HUDCollectionContainerElement %q.", layout_settings.name)

	local res_width, res_height = Gui.resolution()
	local height, width

	if layout_settings.alignment_y == "stacked" then
		height = -spacing
	else
		height = layout_settings.height or res_height
	end

	if layout_settings.alignment_x == "stacked" then
		width = -spacing
	else
		width = layout_settings.width or res_width
	end

	for id, element in ipairs(self._elements) do
		local element_height, element_width = 0, 0

		if element.is_table then
			for _, element_child in ipairs(element) do
				element_child:update_size(dt, t, gui, HUDHelper:layout_settings(element_child.config.layout_settings))

				element_height = math.max(element_height, element_child:height())
				element_width = math.max(element_width, element_child:width())
			end
		else
			element:update_size(dt, t, gui, HUDHelper:layout_settings(element.config.layout_settings))

			element_height = element:height()
			element_width = element:width()
		end

		if layout_settings.alignment_y == "stacked" then
			height = height + element_height + spacing
		end

		if layout_settings.alignment_x == "stacked" then
			width = width + element_width + spacing
		end
	end

	self._height = height
	self._width = width
end

function HUDCollectionContainerElement:insert_element(element, index)
	if index then
		table.insert(self._elements, index, element)
	else
		self._elements[#self._elements + 1] = element
	end
end

function HUDCollectionContainerElement:find_element(element)
	return table.find(self._elements, element)
end

function HUDCollectionContainerElement:remove_element(index)
	table.remove(self._elements, index)
end

function HUDCollectionContainerElement:remove_all_elements()
	table.clear(self._elements)
end

function HUDCollectionContainerElement:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	local element_x = x
	local element_y = y
	local element_z = z
	local spacing = layout_settings.spacing
	local alignment_x = layout_settings.alignment_x
	local alignment_y = layout_settings.alignment_y

	for id, element in ipairs(self._elements) do
		local element_height, element_width = 0, 0

		if element.is_table then
			for _, element_child in ipairs(element) do
				element_height = math.max(element_height, element_child:height())
				element_width = math.max(element_width, element_child:width())
			end
		else
			element_height = element:height()
			element_width = element:width()
		end

		if alignment_x == "stacked" then
			element_x = x
			x = x + element_width + spacing
		elseif alignment_x == "stacked_right" then
			element_x = x - element_width
			x = x - element_width - spacing
		elseif alignment_x == "left" then
			element_x = x
		elseif alignment_x == "right" then
			element_x = x + self._width - element_width
		elseif alignment_x == "center" then
			element_x = x + 0.5 * self._width - #self._elements * 0.5 * element_width + (id - 1) * element_width
		end

		if alignment_y == "stacked" then
			element_y = y
			y = y + element_height + spacing
		elseif alignment_y == "bottom" then
			element_y = y
		elseif alignment_y == "top" then
			element_y = y + self._height - element_height
		elseif alignment_y == "center" then
			element_y = y + 0.5 * (self._height - element_width * id)
		end

		if element.is_table then
			for _, element_child in ipairs(element) do
				element_z = element_child.config.override_z and element_child.config.z or element_z

				local element_child_layout_settings = HUDHelper:layout_settings(element_child.config.layout_settings)

				element_child:update_position(dt, t, element_child_layout_settings, element_x, element_y, element_z)
			end
		else
			local element_layout_settings = HUDHelper:layout_settings(element.config.layout_settings)

			element:update_position(dt, t, element_layout_settings, element_x, element_y, element_z)
		end
	end
end

function HUDCollectionContainerElement.create_from_config(config)
	return HUDCollectionContainerElement:new(config)
end
