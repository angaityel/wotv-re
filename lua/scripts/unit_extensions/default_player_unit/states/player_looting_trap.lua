-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_looting_trap.lua

require("scripts/unit_extensions/human/base/states/human_interacting")

PlayerLootingTrap = class(PlayerLootingTrap, HumanInteracting)

function PlayerLootingTrap:init(unit, internal, world)
	PlayerLootingTrap.super.init(self, unit, internal, world, "loot_trap")
end

function PlayerLootingTrap:enter(old_state, trap, t, interaction)
	PlayerLootingTrap.super.enter(self, old_state, t)

	self._trap_unit = trap

	local internal = self._internal

	if internal.id and internal.game then
		local trap_name = Unit.get_data(trap, "trap_name")
		local trap_name_id = NetworkLookup.trap_names[trap_name]

		self._trap_name_id = trap_name_id

		InteractionHelper:request("loot_trap", internal, internal.id, trap_name_id)
	end
end

function PlayerLootingTrap:_exit_on_fail()
	PlayerLootingTrap.super._exit_on_fail(self)

	local internal = self._internal

	if internal.id and internal.game then
		InteractionHelper:abort("loot_trap", internal, internal.id, self._trap_name_id)
	end
end

function PlayerLootingTrap:_exit_on_complete()
	PlayerLootingTrap.super._exit_on_complete(self)

	local internal = self._internal

	InteractionHelper:complete("loot_trap", internal, internal.id, self._trap_name_id)
end

function PlayerLootingTrap:destroy()
	return
end
