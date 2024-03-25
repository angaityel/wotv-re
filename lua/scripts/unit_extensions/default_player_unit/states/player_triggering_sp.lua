-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_triggering_sp.lua

require("scripts/unit_extensions/human/base/states/human_interacting")

PlayerTriggeringSP = class(PlayerTriggeringSP, HumanInteracting)

function PlayerTriggeringSP:init(unit, internal, world)
	PlayerTriggeringSP.super.init(self, unit, internal, world, "trigger")
end

function PlayerTriggeringSP:enter(old_state, interaction_unit, t)
	self._interaction_unit = interaction_unit

	PlayerTriggering.super.enter(self, old_state, t)

	local extension = ScriptUnit.extension(interaction_unit, "objective_system")
	local player_unit = self._internal.unit
	local player = Managers.player:owner(player_unit)
	local side = player.team.side

	if extension:active(side) then
		self._interaction_confirmed = true
	end
end

PlayerTriggeringSP._interaction_settings = PlayerTriggering._interaction_settings
PlayerTriggeringSP._begin_anim_event = PlayerTriggering._begin_anim_event
PlayerTriggeringSP._end_anim_event = PlayerTriggering._end_anim_event
PlayerTriggeringSP._duration = PlayerTriggering._duration

function PlayerTriggeringSP:_exit_on_complete()
	PlayerTriggering.super._exit_on_complete(self)

	local player_unit = self._internal.unit
	local player = Managers.player:owner(player_unit)
	local side = player.team.side
	local interactable_name = Unit.get_data(self._interaction_unit, "interact_settings", "name")
	local event_name = side .. "_" .. interactable_name .. "_triggered"
	local extension = ScriptUnit.extension(self._interaction_unit, "objective_system")

	Unit.flow_event(self._interaction_unit, event_name)
end

function PlayerTriggeringSP:destroy()
	return
end
