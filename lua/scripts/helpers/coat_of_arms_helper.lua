-- chunkname: @scripts/helpers/coat_of_arms_helper.lua

require("scripts/settings/coat_of_arms")

CoatOfArmsHelper = CoatOfArmsHelper or {}

function CoatOfArmsHelper:coat_of_arms_setting(category, name)
	for _, setting in ipairs(CoatOfArms[category]) do
		if name == setting.name then
			return setting
		end
	end
end

function CoatOfArmsHelper:set_material_properties(settings, unit, mesh_name, material_name, team_name)
	local mesh = Unit.mesh(unit, mesh_name)
	local team_name = team_name or "red"
	local material_variation = Unit.get_data(unit, "material_variations", team_name)
	local current_material = Unit.get_data(unit, "current_material_variation")

	if material_variation and current_material ~= material_variation then
		Unit.set_material_variation(unit, material_variation)
		Unit.set_data(unit, "current_material_variation", material_variation)
	end

	local material = Mesh.material(mesh, material_name)
	local coat_of_arms = settings[team_name] or settings

	for variable_name, value in pairs(coat_of_arms) do
		if type(value) == "string" then
			local atlas_name = CoatOfArmsAtlasVariants[team_name][variable_name]
			local atlas = rawget(_G, atlas_name)

			if atlas[value] then
				local _, uv00, uv11 = HUDHelper.atlas_material(atlas_name, value)
				local offset_name = variable_name .. "_uv_offset"
				local scale_name = variable_name .. "_uv_scale"

				Material.set_vector2(material, variable_name .. "_uv_offset", uv00)
				Material.set_vector2(material, variable_name .. "_uv_scale", uv11 - uv00)
			end
		else
			Material.set_scalar(material, variable_name, value)
		end
	end
end
