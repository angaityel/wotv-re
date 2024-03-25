-- chunkname: @scripts/menu/hierachical_layout_menu/hl_menu_component.lua

HLMenuComponent = class(HLMenuComponent)

function HLMenuComponent:init(world, config)
	self._world = world
	self.config = config
	self._width = 0
	self._height = 0
	self._x = 0
	self._y = 0
	self._z = 0
	self._layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
end

function HLMenuComponent:name()
	return self.config.name
end

function HLMenuComponent:namespace_path()
	return self.config.namespace_path
end

function HLMenuComponent:namespace()
	return self.config.namespace
end

function HLMenuComponent:calculate_width(dt, t, gui, parent)
	local width_policy = self:width_policy()
	local width, scale

	if width_policy == "defined" then
		local layout_settings = self:layout_settings()

		width = layout_settings.width
		scale = layout_settings.scale
	end

	fassert(width, "Invalid width policy %q or width value %q : in menu component %q", width_policy, width, self:name())

	return width * scale
end

function HLMenuComponent:width()
	return self._width
end

function HLMenuComponent:width_policy()
	local layout_settings = self:layout_settings()

	return layout_settings.width_policy
end

function HLMenuComponent:calculate_height(dt, t, gui, parent)
	local height_policy = self:height_policy()
	local height, scale

	if height_policy == "defined" then
		local layout_settings = self:layout_settings()

		height = layout_settings.height
		scale = layout_settings.scale
	end

	fassert(height, "Invalid height policy %q or height value %q : in menu component %q", height_policy, height, self:name())

	return height * scale
end

function HLMenuComponent:height()
	return self._height
end

function HLMenuComponent:height_policy()
	local layout_settings = self:layout_settings()

	return layout_settings.height_policy
end

function HLMenuComponent:calculate_x(parent)
	local layout_settings = self:layout_settings()
	local horizontal_position_policy = self:horizontal_position_policy()
	local parent_x = parent:x()
	local parent_width = parent:width()
	local self_width = self:width()
	local offset_x = layout_settings.offset_x or 0
	local x

	if horizontal_position_policy == "defined" then
		x = layout_settings.x + offset_x
	elseif horizontal_position_policy == "left" then
		x = parent_x + offset_x
	elseif horizontal_position_policy == "center" then
		x = parent_x + parent_width / 2 - self_width / 2 + offset_x
	elseif horizontal_position_policy == "right" then
		x = parent_x + parent_width - self_width + offset_x
	end

	fassert(x, "Invalid horizontal position policy %q or x value %q : in menu component %q", horizontal_position_policy, x, self:name())

	return x
end

function HLMenuComponent:x()
	return self._x
end

function HLMenuComponent:horizontal_position_policy()
	local layout_settings = self:layout_settings()

	return layout_settings.horizontal_position_policy
end

function HLMenuComponent:calculate_y(parent)
	local layout_settings = self:layout_settings()
	local vertical_position_policy = self:vertical_position_policy()
	local parent_y = parent:y()
	local parent_height = parent:height()
	local self_height = self:height()
	local offset_y = layout_settings.offset_y or 0
	local y

	if vertical_position_policy == "defined" then
		y = layout_settings.y + offset_y
	elseif vertical_position_policy == "bottom" then
		y = parent_y + offset_y
	elseif vertical_position_policy == "center" then
		y = parent_y + parent_height / 2 - self_height / 2 + offset_y
	elseif vertical_position_policy == "top" then
		y = parent_y + parent_height - self_height + offset_y
	end

	fassert(y, "Invalid vertical position policy %q or y value %q : in menu component %q", vertical_position_policy, y, self:name())

	return y
end

function HLMenuComponent:y()
	return self._y
end

function HLMenuComponent:vertical_position_policy()
	local layout_settings = self:layout_settings()

	return layout_settings.vertical_position_policy
end

function HLMenuComponent:calculate_z(parent)
	local layout_settings = self:layout_settings()
	local z = parent:z() + layout_settings.z

	return z
end

function HLMenuComponent:z()
	return self._z
end

function HLMenuComponent:layout_settings()
	return self._layout_settings
end

function HLMenuComponent:update_layout_settings()
	self._layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
end

function HLMenuComponent:update_size(dt, t, gui, width, height)
	self._width = width
	self._height = height
end

function HLMenuComponent:update_position(dt, t, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HLMenuComponent:render(dt, t, gui)
	local config = self.config
	local x = self:x()
	local y = self:y()
	local z = self:z()
	local width = self:width()
	local height = self:height()
	local background_func = config.background_func
	local border_func = config.border_func
	local position = Vector3(x, y, z)
	local size = Vector2(width, height)

	if background_func then
		background_func(self, gui, position, size)
	end

	if border_func then
		border_func(self, gui, position, size)
	end
end

function HLMenuComponent:is_mouse_inside(mouse_x, mouse_y)
	local x = self:x()
	local y = self:y()
	local width = self:width()
	local height = self:height()

	return MenuHelper:point_within_rect(mouse_x, mouse_y, x, y, width, height)
end

function HLMenuComponent:update_mouse_hover(input)
	return
end

function HLMenuComponent:on_page_enter(on_cancel)
	return
end

function HLMenuComponent:on_page_exit(on_cancel)
	return
end

function HLMenuComponent:page()
	return self.config.page
end

function HLMenuComponent:destroy()
	return
end
