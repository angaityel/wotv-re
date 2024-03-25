-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_system.lua

LocomotionSystem = class(LocomotionSystem, ExtensionSystemBase)

require("scripts/unit_extensions/default_player_unit/player_unit_locomotion")
require("scripts/unit_extensions/default_player_unit/player_husk_locomotion")
require("scripts/unit_extensions/horse/horse_locomotion")

function LocomotionSystem:init(...)
	self._prioritized_extensions = {
		"PlayerHuskLocomotion",
		"HorseLocomotion",
		"PlayerUnitLocomotion"
	}

	LocomotionSystem.super.init(self, ...)
	Managers.state.event:register(self, "animation_callback", "animation_callback")
end

function LocomotionSystem:animation_callback(extension, unit, callback, param)
	local internal = ScriptUnit.extension(unit, extension)

	internal:anim_cb(callback, unit, param)
end

function LocomotionSystem:update_extension(extension_name, dt, context, t)
	Profiler.start(extension_name)

	local entities = self.entity_manager:get_entities(extension_name)

	for unit, _ in pairs(entities) do
		local input = ScriptUnit.extension_input(unit, self.NAME)
		local internal = ScriptUnit.extension(unit, self.NAME)

		assert(internal, extension_name)
		internal:update(unit, input, dt, context, t)
	end

	Profiler.stop()
end

function LocomotionSystem:post_update_extension(extension_name, dt, context, t)
	Profiler.start(extension_name)

	local entities = self.entity_manager:get_entities(extension_name)

	for unit, _ in pairs(entities) do
		local input = ScriptUnit.extension_input(unit, self.NAME)
		local internal = ScriptUnit.extension(unit, self.NAME)

		assert(internal, extension_name)

		if internal.post_update then
			internal:post_update(unit, input, dt, context, t)
		end
	end

	Profiler.stop()
end
