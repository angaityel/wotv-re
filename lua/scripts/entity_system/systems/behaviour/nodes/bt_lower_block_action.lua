-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_lower_block_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLowerBlockAction = class(BTLowerBlockAction, BTNode)

function BTLowerBlockAction:init(...)
	BTLowerBlockAction.super.init(self, ...)
	fassert(self._input, "No input set for node %q", self._name)
end

function BTLowerBlockAction:setup(unit, blackboard, profile)
	self._ai_props = profile.properties
	self._block_directions = {
		"up",
		"down",
		"left",
		"right"
	}
end

function BTLowerBlockAction:run(unit, blackboard, t, dt)
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	if locomotion.block_or_parry then
		locomotion:lower_block()
	end

	return not locomotion.blocking and not locomotion.parrying
end
