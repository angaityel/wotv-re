-- chunkname: @scripts/unit_extensions/weapons/shield_unit_damage.lua

require("scripts/unit_extensions/generic/generic_unit_damage")

ShieldUnitDamage = class(ShieldUnitDamage, GenericUnitDamage)
ShieldUnitDamage.SYSTEM = "damage_system"

function ShieldUnitDamage:init(world, unit, input)
	ShieldUnitDamage.super.init(self, world, unit, input)

	self._fire_arrows_in_shield = 0
	self._on_fire_from_arrow = false
	self._on_fire_timer = 0
	self._fire_effect_id = nil
end

function ShieldUnitDamage:hit_by_flaming_arrow(duration, player)
	self._fire_arrows_in_shield = self._fire_arrows_in_shield + 1

	if self._fire_arrows_in_shield == Perks.flaming_arrows.arrows_required_to_destroy_shield then
		self:_end_fire_effect()
		self:die()
		Managers.state.event:trigger("fire_arrow_destroyed_shield", player)
	else
		self._on_fire_timer = Managers.time:time("game") + duration

		if not self._fire_effect_id then
			local unit = self._unit
			local network_manager = Managers.state.network
			local game_object_id = network_manager:unit_game_object_id(unit)

			network_manager:send_rpc_clients("rpc_start_gear_fire_effect", game_object_id)

			local gear = self:_gear()

			gear:start_fire_effect()
		end
	end
end

function ShieldUnitDamage:update(unit, input, dt, context, t)
	if self._fire_arrows_in_shield >= 1 and t > self._on_fire_timer then
		self._fire_arrows_in_shield = 0

		self:_end_fire_effect()
	end
end

function ShieldUnitDamage:_end_fire_effect()
	local network_manager = Managers.state.network
	local game_object_id = network_manager:unit_game_object_id(self._unit)

	network_manager:send_rpc_clients("rpc_end_gear_fire_effect", game_object_id)

	local gear = self:_gear()

	gear:end_fire_effect()
end

function ShieldUnitDamage:_gear()
	local user_unit = Unit.get_data(self._unit, "user_unit")
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local inventory = locomotion:inventory()

	return inventory:gear("shield")
end

function ShieldUnitDamage:hot_join_synch(sender, player, player_object_id, slot_name)
	if self._fire_arrows_in_shield >= 1 then
		local game_object_id = Managers.state.network:unit_game_object_id(self._unit)

		RPC.rpc_start_gear_fire_effect(sender, game_object_id)
	end
end
