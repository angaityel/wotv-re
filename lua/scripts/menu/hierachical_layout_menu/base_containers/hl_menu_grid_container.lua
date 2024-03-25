-- chunkname: @scripts/menu/hierachical_layout_menu/base_containers/hl_menu_grid_container.lua

HLMenuGridContainer = class(HLMenuGridContainer, HLMenuContainer)

function HLMenuGridContainer:init(world, config)
	HLMenuGridContainer.super.init(self, world, config)

	local layout_settings = self:layout_settings()

	self._num_columns = layout_settings.num_columns
	self._num_rows = layout_settings.num_rows

	local grid_square_layout_settings = MainMenuSettings.base_grid_square

	self._grid_square_containers = self:_create_grid_squares(grid_square_layout_settings)
end

function HLMenuGridContainer:_create_grid_squares(grid_square_layout_settings)
	local grid_square_containers = {}

	for i = 1, self._num_rows do
		for j = 1, self._num_columns do
			local layout_settings = table.clone(grid_square_layout_settings)
			local config = {
				namespace_path = self:namespace_path(),
				layout_settings = layout_settings
			}
			local grid_square_container = HLMenuContainer.create_from_config(self._world, config)

			grid_square_containers[#grid_square_containers + 1] = grid_square_container
		end
	end

	return grid_square_containers
end

function HLMenuGridContainer:add_component(component)
	local index = #self._components + 1
	local grid_square = self._grid_square_containers[index]

	grid_square:add_component(component)

	self._components[index] = grid_square
end

function HLMenuGridContainer:update_size(dt, t, gui, width, height)
	HLMenuGridContainer.super.super.update_size(self, dt, t, gui, width, height)

	local num_columns = self._num_columns

	for key, component in ipairs(self._components) do
		local grid_x = (key - 1) % num_columns
		local grid_y = math.floor((key - 1) / num_columns)
		local grid_square_width = self:_calculate_grid_square_width(grid_x + 1)
		local grid_square_height = self:_calculate_grid_square_height(grid_y + 1)

		component:update_size(dt, t, gui, grid_square_width, grid_square_height)
	end
end

function HLMenuGridContainer:update_position(dt, t, x, y, z)
	HLMenuGridContainer.super.update_position(self, dt, t, x, y, z)

	local num_columns = self._num_columns

	for key, component in ipairs(self._components) do
		local grid_x = (key - 1) % num_columns
		local grid_y = math.floor((key - 1) / num_columns)
		local x = self:x() + self:_cumalative_column_width(grid_x)
		local y = self:y() + self:height() - self:_cumalative_row_height(grid_y) - component:height()
		local z = self:z()

		component:update_position(dt, t, x, y, z)
	end
end

function HLMenuGridContainer:_cumalative_column_width(zero_based_grid_pos_x)
	local cumalative_width = 0

	for i = 1, zero_based_grid_pos_x do
		cumalative_width = cumalative_width + self:_calculate_grid_square_width(i)
	end

	return cumalative_width
end

function HLMenuGridContainer:_cumalative_row_height(zero_based_grid_pos_y)
	local cumalative_height = 0

	for i = 1, zero_based_grid_pos_y do
		cumalative_height = cumalative_height + self:_calculate_grid_square_height(i)
	end

	return cumalative_height
end

function HLMenuGridContainer:_calculate_grid_square_width(grid_pos_x)
	local layout_settings = self:layout_settings()
	local num_columns = self._num_columns
	local column_widths = layout_settings.column_widths
	local width

	if column_widths then
		width = column_widths[grid_pos_x]

		fassert(width, "Grid Container column widths defined in layout settings without all column widths specified: in %q", self:name())
	else
		width = self:width() / num_columns
	end

	return width
end

function HLMenuGridContainer:_calculate_grid_square_height(grid_pos_y)
	local layout_settings = self:layout_settings()
	local num_rows = self._num_rows
	local row_heights = layout_settings.row_heights
	local height

	if row_heights then
		height = row_heights[grid_pos_y]

		fassert(height, "Grid Container row heights defined in layout settings without all row heights specified: in %q", self:name())
	else
		height = self:height() / num_rows
	end

	return height
end

function HLMenuGridContainer.create_from_config(world, config, callback_object)
	return HLMenuGridContainer:new(world, config)
end
