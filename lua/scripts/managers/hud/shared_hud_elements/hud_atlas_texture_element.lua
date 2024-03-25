-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element.lua

HUDAtlasTextureElement = class(HUDAtlasTextureElement)

function HUDAtlasTextureElement:init(config)
	self._width = nil
	self._height = nil
	self.config = config
end

function HUDAtlasTextureElement:width()
	return self._width
end

function HUDAtlasTextureElement:height()
	return self._height
end

function HUDAtlasTextureElement:update_size(dt, t, gui, layout_settings)
	local texture = self:_texture(dt, t, gui, layout_settings, self.config)
	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.atlas, texture)

	self._width = (layout_settings.texture_width or size[1]) * (layout_settings.scale or self.config.blackboard and self.config.blackboard.scale or 1)
	self._height = (layout_settings.texture_height or size[2]) * (layout_settings.scale or self.config.blackboard and self.config.blackboard.scale or 1)
end

function HUDAtlasTextureElement:update_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function HUDAtlasTextureElement:update_rotation_radians(rotation)
	self._rotation = rotation
end

function HUDAtlasTextureElement:update_rotation_degrees(rotation)
	self._rotation = math.degrees_to_radians(rotation)
end

local WHITE = {
	255,
	255,
	255,
	255
}

function HUDAtlasTextureElement:_color(dt, t, gui, layout_settings, config)
	local color_table = config.blackboard and config.blackboard.color or config.color or layout_settings.color or WHITE

	return Color(color_table[1], color_table[2], color_table[3], color_table[4])
end

function HUDAtlasTextureElement:_texture(dt, t, gui, layout_settings, config)
	return config.blackboard and config.blackboard.texture or layout_settings.texture
end

function HUDAtlasTextureElement:_size()
	return Vector2(self._width, self._height)
end

function HUDAtlasTextureElement:_position()
	return Vector3(math.floor(self._x), math.floor(self._y), self._z)
end

function HUDAtlasTextureElement:render(dt, t, gui, layout_settings)
	local config = self.config
	local color = self:_color(dt, t, gui, layout_settings, config)
	local position = self:_position(dt, t, gui, layout_settings, config)
	local size = self:_size(dt, t, gui, layout_settings, config)
	local texture = self:_texture(dt, t, gui, layout_settings, self.config)
	local rotation = self._rotation

	if config.rotate_3d then
		HUDHelper.atlas_bitmap_3d(gui, layout_settings.atlas, texture, position, size, color, rotation)
	else
		HUDHelper.atlas_bitmap(gui, layout_settings.atlas, texture, position, size, color)
	end
end

function HUDAtlasTextureElement.create_from_config(config)
	return HUDAtlasTextureElement:new(config)
end
