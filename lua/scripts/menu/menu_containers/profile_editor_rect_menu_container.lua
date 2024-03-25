-- chunkname: @scripts/menu/menu_containers/profile_editor_rect_menu_container.lua

ProfileEditorRectMenuContainer = class(ProfileEditorRectMenuContainer, RectMenuContainer)

function ProfileEditorRectMenuContainer:init()
	ProfileEditorRectMenuContainer.super.init(self)

	self._visible = true
	self._alpha = 1
end

function ProfileEditorRectMenuContainer:set_visibility(visible)
	self._visible = visible
end

function ProfileEditorRectMenuContainer:render(dt, t, gui, layout_settings)
	self._alpha = self._visible and math.min(self._alpha + dt * 10, 1) or math.clamp(self._alpha - dt * 10, 0, 1)

	local color = Color(layout_settings.color[1] * self._alpha, layout_settings.color[2], layout_settings.color[3], layout_settings.color[4])

	Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), color)

	if layout_settings.border_size then
		local x = self._x
		local y = self._y
		local z = self._z
		local w = self._width
		local h = self._height
		local color = Color(layout_settings.border_color[1] * self._alpha, layout_settings.border_color[2], layout_settings.border_color[3], layout_settings.border_color[4])

		Gui.rect(gui, Vector3(x - layout_settings.border_size, y + h, z + 1), Vector2(w + layout_settings.border_size * 2, layout_settings.border_size), color)
		Gui.rect(gui, Vector3(x - layout_settings.border_size, y - layout_settings.border_size, z + 1), Vector2(w + layout_settings.border_size * 2, layout_settings.border_size), color)
		Gui.rect(gui, Vector3(x - layout_settings.border_size, y, z + 1), Vector2(layout_settings.border_size, h), color)
		Gui.rect(gui, Vector3(x + w, y, z + 1), Vector2(layout_settings.border_size, h), color)
	end
end

function ProfileEditorRectMenuContainer.create_from_config()
	return ProfileEditorRectMenuContainer:new()
end
