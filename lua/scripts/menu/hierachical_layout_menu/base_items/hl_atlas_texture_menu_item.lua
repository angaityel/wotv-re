-- chunkname: @scripts/menu/hierachical_layout_menu/base_items/hl_atlas_texture_menu_item.lua

HLAtlasTextureMenuItem = class(HLAtlasTextureMenuItem, HLMenuItem)

function HLAtlasTextureMenuItem:init(world, config)
	HLAtlasTextureMenuItem.super.init(self, world, config)
end

function HLAtlasTextureMenuItem:render(dt, t, gui)
	local layout_settings = self:layout_settings()
	local texture_name = self:_texture_name()
	local position = self:_position()
	local size = self:_size()
	local color = self:_color()

	self:_render_atlas_bitmap(gui, layout_settings.atlas_name, texture_name, position, size, MenuHelper:color(color))
end

function HLAtlasTextureMenuItem:_highlighted_offset_x(gui, text, font, scale)
	local default_width = self:width()
	local highlighted_scale = self:_highlighted_scale()
	local highlighted_width = default_width * highlighted_scale

	return (highlighted_width - default_width) * 0.5
end

function HLAtlasTextureMenuItem:_highlighted_offset_y(gui, text, font, scale)
	local default_height = self:height()
	local highlighted_scale = self:_highlighted_scale()
	local highlighted_height = default_height * highlighted_scale

	return (highlighted_height - default_height) * 0.5
end

function HLAtlasTextureMenuItem:_highlighted_scale()
	local layout_settings = self:layout_settings()

	return self._highlighted and layout_settings.highlighted_scale or layout_settings.scale
end

function HLAtlasTextureMenuItem:_position()
	return Vector3(self:x() - self:_highlighted_offset_x(), self:y() - self:_highlighted_offset_y(), self:z())
end

function HLAtlasTextureMenuItem:_size()
	local highlighted_scale = self:_highlighted_scale()

	return Vector2(self:width() * highlighted_scale, self:height() * highlighted_scale)
end

function HLAtlasTextureMenuItem:_texture_name()
	local config = self.config
	local layout_settings = self:layout_settings()
	local texture_name = self:_try_callback(config.callback_object, config.texture_func)

	texture_name = texture_name or layout_settings.texture_name

	return texture_name
end

function HLAtlasTextureMenuItem:_render_atlas_bitmap(gui, atlas_name, texture_name, position, size, color)
	local material_table = self:_atlas_texture_settings(atlas_name, texture_name)
	local uv00 = material_table.uv00
	local uv11 = material_table.uv11

	Gui.bitmap_uv(gui, self:layout_settings().asset_name or atlas_name, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), position, size, color)
end

function HLAtlasTextureMenuItem:_atlas_texture_settings(atlas_name, texture_name)
	local name = self:name()
	local atlas = rawget(_G, atlas_name)

	fassert(atlas, "There is no such atlas %q : in atlas texture menu item %q", atlas_name, name)

	local material_table = atlas[texture_name]

	fassert(material_table, "There is no texture with name %q in atlas %q : in atlas texture menu item %q", texture_name, atlas_name, name)

	return material_table
end

function HLAtlasTextureMenuItem.create_from_config(world, config, callback_object)
	config.callback_object = callback_object

	return HLAtlasTextureMenuItem:new(world, config)
end
