-- chunkname: @scripts/managers/loot/loot_manager_client.lua

LootManagerClient = class(LootManagerClient, LootManagerBase)

function LootManagerClient:init(world)
	self._world = world
	self._ammo_loot_requests = {}
end

function LootManagerClient:update(dt, t)
	return
end

function LootManagerClient:rpc_loot_manager_client_remove_gear(unit)
	self:_set_gear_lootable(unit, false)
end

function LootManagerClient:rpc_loot_manager_client_add_gear(unit, ammo_lootable, ammo)
	self:_set_gear_lootable(unit, true, ammo_lootable, ammo)
end

function LootManagerClient:add_gear(unit, manually_destroy, ammo)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		local id = network_manager:unit_game_object_id(unit)

		network_manager:send_rpc_server("rpc_loot_manager_server_add_gear", id, ammo)
	end
end

function LootManagerClient:request_ammo_loot(looter_unit, gear_unit, cb)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		local looter_id = network_manager:unit_game_object_id(looter_unit)
		local gear_id = network_manager:unit_game_object_id(gear_unit)

		self._ammo_loot_requests[tostring(looter_id) .. "_" .. tostring(gear_id)] = cb

		network_manager:send_rpc_server("rpc_loot_manager_server_request_ammo_loot", looter_id, gear_id)
	end
end

function LootManagerClient:rpc_loot_manager_client_request_ammo_confirmed(looter_id, gear_id, looter_unit, gear_unit, gear_name, ammo)
	local request_id = tostring(looter_id) .. "_" .. tostring(gear_id)
	local cb = self._ammo_loot_requests[request_id]

	self._ammo_loot_requests[request_id] = nil

	if Unit.alive(looter_unit) then
		cb(looter_unit, gear_name, ammo)
	end
end

function LootManagerClient:rpc_loot_manager_client_request_ammo_denied(looter_id, gear_id, looter_unit, gear_unit)
	local request_id = tostring(looter_id) .. "_" .. tostring(gear_id)
	local cb = self._ammo_loot_requests[request_id]

	self._ammo_loot_requests[request_id] = nil

	if Unit.alive(looter_unit) then
		cb(looter_unit)
	end
end

function LootManagerClient:ammo_loot_completed(gear_unit)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		local gear_id = network_manager:unit_game_object_id(gear_unit)

		network_manager:send_rpc_server("rpc_ammo_loot_completed", gear_id)
	end
end

function LootManagerClient:ammo_loot_aborted(gear_unit)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		local gear_id = network_manager:unit_game_object_id(gear_unit)

		network_manager:send_rpc_server("rpc_ammo_loot_aborted", gear_id)
	end
end

function LootManagerClient:destroy()
	return
end
