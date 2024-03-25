-- chunkname: @scripts/menu/menu_containers/frame_texture_menu_container.lua

require("scripts/menu/menu_containers/menu_container")

FrameTextureMenuContainer = class(FrameTextureMenuContainer, MenuContainer)

function FrameTextureMenuContainer:init()
	FrameTextureMenuContainer.super.init(self)
end

function FrameTextureMenuContainer:update_size(dt, t, gui, layout_settings)
	local width, height

	if layout_settings.stretch_width then
		width = layout_settings.stretch_width
	elseif layout_settings.stretch_relative_width then
		local res_width, _ = Gui.resolution()

		width = res_width * layout_settings.stretch_relative_width
	end

	if layout_settings.stretch_height then
		height = layout_settings.stretch_height
	elseif layout_settings.stretch_relative_height then
		local _, res_height = Gui.resolution()

		height = res_height * layout_settings.stretch_relative_height
	end

	self._width = math.clamp(width, layout_settings.texture_min_width or 0, width)
	self._height = math.clamp(height, layout_settings.texture_min_height or 0, height)
end

function FrameTextureMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function FrameTextureMenuContainer:render(dt, t, gui, layout_settings)
	local c = layout_settings.color or {
		255,
		255,
		255,
		255
	}
	local color = Color(c[1], c[2], c[3], c[4])
end

function FrameTextureMenuContainer.create_from_config()
	return FrameTextureMenuContainer:new()
end
