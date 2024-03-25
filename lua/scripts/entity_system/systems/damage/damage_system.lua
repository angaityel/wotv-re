-- chunkname: @scripts/entity_system/systems/damage/damage_system.lua

require("scripts/unit_extensions/generic/generic_unit_damage")
require("scripts/unit_extensions/weapons/shield_unit_damage")
require("scripts/unit_extensions/default_player_unit/player_unit_damage")
require("scripts/unit_extensions/default_player_unit/player_husk_damage")
require("scripts/unit_extensions/human/ai_player_unit/ai_unit_damage")
require("scripts/unit_extensions/objectives/objective_unit_damage")
require("scripts/unit_extensions/horse/horse_damage")

DamageSystem = class(DamageSystem, ExtensionSystemBase)

function DamageSystem:update(...)
	DamageSystem.super.update(self, ...)
end

function DamageSystem:update_extension(extension_name, dt, context, t)
	local entities = self.entity_manager:get_entities(extension_name)

	if rawget(_G, extension_name).update then
		for unit, _ in pairs(entities) do
			local internal = ScriptUnit.extension(unit, self.NAME)

			internal:update(unit, t, dt, context, t)
		end
	end
end

function DamageSystem:on_add_extension(world, unit, extension_name, extension_class, ...)
	fassert(not GameSettingsDevelopment.dev_build or extension_name ~= "GenericUnitDamage" or not Managers.lobby.lobby or Managers.lobby.server, "Trying to instantiate object with GenericUnitDamage on client")

	if script_data.extension_debug then
		print(string.format("%s:on_add_component(unit, %s)", self.NAME, extension_name))
	end

	ScriptUnit.add_extension(world, unit, extension_name, ...)

	if not table.contains(self._prioritized_extensions, extension_name) then
		self._extensions[extension_name] = (self._extensions[extension_name] or 0) + 1
	end
end
