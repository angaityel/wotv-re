-- chunkname: @scripts/utils/script_gui.lua

ScriptGUI = ScriptGUI or {}

function ScriptGUI.text(gui, text, font, font_size, material, pos, color, drop_shadow_color, drop_shadow_offset)
	if drop_shadow_color then
		Gui.text(gui, text, font, font_size, material, pos + drop_shadow_offset, drop_shadow_color)
	end

	Gui.text(gui, text, font, font_size, material, pos, color)
end

local function bitmap_uv_tiled_y(gui, material, uv00, uv11, pos_x, pos_y, pos_z, remaining_size_x, remaining_size_y, texture_size, color)
	local texture_size_y = texture_size.y

	if texture_size_y < remaining_size_y then
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector2(pos_x, pos_y, pos_z), texture_size, color)

		return bitmap_uv_tiled_y(gui, material, uv00, uv11, pos_x, pos_y + texture_size_y, pos_z, remaining_size_x, remaining_size_y - texture_size_y, texture_size, color)
	elseif remaining_size_y >= 1 then
		local new_uv11 = Vector2(uv11.x, math.lerp(uv00.y, uv11.y, remaining_size_y / texture_size_y))
		local new_texture_size = Vector2(texture_size.x, remaining_size_y)

		Gui.bitmap_uv(gui, material, uv00, new_uv11, Vector2(pos_x, pos_y, pos_z), new_texture_size, color)
	end
end

local function bitmap_uv_tiled_x(gui, material, uv00, uv11, pos_x, pos_y, pos_z, remaining_size_x, remaining_size_y, texture_size, color)
	local texture_size_x = texture_size.x

	if texture_size_x < remaining_size_x then
		bitmap_uv_tiled_y(gui, material, uv00, uv11, pos_x, pos_y, pos_z, remaining_size_x, remaining_size_y, texture_size, color)

		return bitmap_uv_tiled_x(gui, material, uv00, uv11, pos_x + texture_size_x, pos_y, pos_z, remaining_size_x - texture_size_x, remaining_size_y, texture_size, color)
	elseif remaining_size_x >= 1 then
		local new_uv11 = Vector2(math.lerp(uv00.x, uv11.x, remaining_size_x / texture_size_x), uv11.y)
		local new_texture_size = Vector2(remaining_size_x, texture_size.y)

		return bitmap_uv_tiled_y(gui, material, uv00, new_uv11, pos_x, pos_y, pos_z, remaining_size_x, remaining_size_y, new_texture_size, color)
	end
end

function ScriptGUI.bitmap_uv_tiled(gui, material, atlas_texture_settings, position, size, color)
	local uv00 = Vector2(atlas_texture_settings.uv00[1], atlas_texture_settings.uv00[2])
	local uv11 = Vector2(atlas_texture_settings.uv11[1], atlas_texture_settings.uv11[2])
	local texture_size = Vector2(atlas_texture_settings.size[1], atlas_texture_settings.size[2])

	bitmap_uv_tiled_x(gui, material, Vector2(atlas_texture_settings.uv00[1], atlas_texture_settings.uv00[2]), Vector2(atlas_texture_settings.uv11[1], atlas_texture_settings.uv11[2]), position.x, position.y, position.z, size.x, size.y, Vector2(atlas_texture_settings.size[1], atlas_texture_settings.size[2]), color)
end
