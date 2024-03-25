﻿-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_triggering.lua

require("scripts/unit_extensions/human/base/states/human_interacting")

PlayerTriggering = class(PlayerTriggering, HumanInteracting)

function PlayerTriggering:init(unit, internal, world)
	PlayerTriggering.super.init(self, unit, internal, world, "trigger")
end

function PlayerTriggering:enter(old_state, interaction_unit, t)
	self._interaction_unit = interaction_unit

	PlayerTriggering.super.enter(self, old_state, t)

	local internal = self._internal

	if internal.id and internal.game then
		local level_unit_index = Unit.get_data(self._interaction_unit, "level_unit_index")

		InteractionHelper:request("trigger", internal, internal.id, level_unit_index)
	end
end

function PlayerTriggering:_begin_anim_event(settings)
	return Unit.get_data(self._interaction_unit, "interact_settings", "begin_anim_event")
end

function PlayerTriggering:_end_anim_event(settings)
	return Unit.get_data(self._interaction_unit, "interact_settings", "end_anim_event")
end

function PlayerTriggering:_duration()
	return Unit.get_data(self._interaction_unit, "interact_settings", "duration")
end

function PlayerTriggering:_exit_on_fail()
	PlayerTriggering.super._exit_on_fail(self)

	local internal = self._internal

	if internal.id and internal.game then
		local level_unit_index = Unit.get_data(self._interaction_unit, "level_unit_index")

		InteractionHelper:abort("trigger", internal, internal.id, level_unit_index)
	end
end

function PlayerTriggering:_exit_on_complete()
	PlayerTriggering.super._exit_on_complete(self)

	local internal = self._internal
	local level_unit_index = Unit.get_data(self._interaction_unit, "level_unit_index")

	InteractionHelper:complete("trigger", internal, internal.id, level_unit_index)
end

function PlayerTriggering:destroy()
	return
end
