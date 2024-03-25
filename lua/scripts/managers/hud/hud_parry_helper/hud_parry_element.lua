-- chunkname: @scripts/managers/hud/hud_parry_helper/hud_parry_element.lua

require("scripts/managers/hud/shared_hud_elements/hud_texture_element")

HUDParryElement = class(HUDParryElement)

function HUDParryElement:init(config)
	self._width = nil
	self._height = nil
	self._fade_time = math.huge
	self.config = config
end

function HUDParryElement:update_size(dt, t, gui, layout_settings)
	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.material)

	self._width = size[1] * layout_settings.scale
	self._height = size[2] * layout_settings.scale
end

function HUDParryElement:width()
	return self._width
end

function HUDParryElement:height()
	return self._height
end

function HUDParryElement:update_position(dt, t, layout_settings, x, y, z)
	self._x = x + layout_settings.offset_x
	self._y = y + layout_settings.offset_y
	self._z = z + (layout_settings.z or 0)
end

function HUDParryElement:render(dt, t, gui, layout_settings)
	local config = self.config
	local blackboard = config.blackboard
	local level = blackboard.attack_direction[config.name]
	local color
	local render = false

	if level then
		color = Color(255 * HUDSettings.parry_helper.alpha_multipliers[level] * config.alpha_multiplier, layout_settings.color[2], layout_settings.color[3], layout_settings.color[4])
		render = true
	elseif blackboard.parry_direction_string == config.name and blackboard.parry_direction_delay_time and t > blackboard.parry_direction_delay_time then
		local t_val = (t - blackboard.parry_direction_delay_time) / 0.15
		local multiplier = math.min(t_val^2, 1) * 0.75 + 0.25

		color = Color(255 * config.alpha_multiplier, multiplier * layout_settings.color[2], multiplier * layout_settings.color[3], multiplier * layout_settings.color[4])
		render = true
	elseif blackboard.parry_direction_string == config.name and blackboard.parry_direction_delay_time then
		color = Color(255 * config.alpha_multiplier, 0.25, 0.25, 0.25)
		render = true
	end

	if render then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.texture_atlas, layout_settings.material, layout_settings.masked)

		if layout_settings.flip_horizontal then
			local temp = uv00[1]

			uv00[1] = uv11[1]
			uv11[1] = temp
		elseif layout_settings.flip_vertically then
			local temp = uv00[2]

			uv00[2] = uv11[2]
			uv11[2] = temp
		end

		local pos = Vector3(self._x, self._y, self._z)
		local size = Vector2(self._width, self._height)

		Gui.bitmap_uv(gui, material, uv00, uv11, pos, size, color)

		if layout_settings.add_mask then
			local pos = pos + Vector3(layout_settings.mask_offset_x, layout_settings.mask_offset_y, 0)

			if layout_settings.mask_rot then
				local tm = Rotation2D(Vector2(0, 0), math.degrees_to_radians(layout_settings.mask_rot), Vector2(pos[1] + layout_settings.mask_size[1] * 0.5, pos[2] + layout_settings.mask_size[2] * 0.5))

				Gui.bitmap_3d(gui, "mask_rect", tm, pos, 0, Vector2(layout_settings.mask_size[1], layout_settings.mask_size[2]), Color(0, 0, 0, 0))
			else
				Gui.bitmap(gui, "mask_rect", pos, Vector2(layout_settings.mask_size[1], layout_settings.mask_size[2]), Color(0, 0, 0, 0))
			end
		end
	end
end

function HUDParryElement.create_from_config(config)
	return HUDParryElement:new(config)
end
