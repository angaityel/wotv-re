-- chunkname: @scripts/managers/loot/loot_manager_server.lua

LootManagerBase = class(LootManagerBase)

function LootManagerBase:_set_gear_lootable(unit, set, ammo_lootable, ammo)
	if set then
		Unit.set_data(unit, "ammo", ammo)

		if ammo_lootable and ammo > 1 then
			Unit.set_data(unit, "auto_interacts", "ammo_loot", "ammo_loot_plural")
			Unit.set_data(unit, "interacts", "loot", "loot_plural")
		elseif ammo_lootable then
			Unit.set_data(unit, "auto_interacts", "ammo_loot", "ammo_loot")
			Unit.set_data(unit, "interacts", "loot", "loot")
		else
			Unit.set_data(unit, "interacts", "loot", "loot")
		end

		if Unit.find_actor(unit, "interaction") then
			Unit.create_actor(unit, "interaction")
		end
	else
		Unit.set_data(unit, "ammo", nil)
		Unit.set_data(unit, "interacts", "loot", nil)
		Unit.set_data(unit, "auto_interacts", "ammo_loot", nil)

		if Unit.actor(unit, "interaction") then
			Unit.destroy_actor(unit, "interaction")
		end
	end
end

LootManagerServer = class(LootManagerServer, LootManagerBase)

local MAX_LOOT = 64
local LOOT_REMOVAL_TIME = 30

function LootManagerServer:init(world)
	self._world = world
	self._unit_indices = {}
	self._unit_list = {}
	self._last_index = MAX_LOOT
	self._pending_gear = {}
end

function LootManagerServer:update(dt, t)
	for index, entry in pairs(self._unit_list) do
		local unit = entry.unit
		local removal_time = entry.removal_time

		if removal_time < t then
			self:_clear_index(index, true)
		end
	end
end

function LootManagerServer:hot_join_synch(sender, player)
	local network_manager = Managers.state.network

	for index, entry in pairs(self._unit_list) do
		local unit = entry.unit

		if Unit.alive(unit) then
			local gear_name = Unit.get_data(unit, "gear_name")
			local ammo_lootable = Gear[gear_name].ammo_lootable
			local id = network_manager:unit_game_object_id(unit)
			local dropped_actor = Unit.actor(unit, "dropped")
			local thrown_actor = Unit.actor(unit, "thrown")

			for _, actor_name in ipairs({
				"dropped",
				"thrown"
			}) do
				local actor = Unit.actor(unit, actor_name)

				if actor then
					local pos = Vector3.clamp(Actor.position(actor), NetworkConstants.position.min, NetworkConstants.position.max)
					local rot = Actor.rotation(actor)
					local velocity = Vector3.clamp(Actor.velocity(actor), NetworkConstants.velocity.min, NetworkConstants.velocity.max)
					local ammo = Unit.get_data(unit, "ammo")

					RPC.rpc_loot_manager_client_hot_join_synch(sender, id, ammo_lootable, pos, rot, velocity, NetworkLookup.loot_actors[actor_name], ammo)

					break
				end
			end
		end
	end
end

function LootManagerServer:add_gear(unit, manually_destroy_gear, ammo)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	Unit.set_data(unit, "manually_destroy_gear", manually_destroy_gear)

	local gear_name = Unit.get_data(unit, "gear_name")
	local ammo_lootable = Gear[gear_name].ammo_lootable

	self:_set_gear_lootable(unit, true, ammo_lootable, ammo)

	if game then
		local id = network_manager:unit_game_object_id(unit)

		network_manager:send_rpc_clients("rpc_loot_manager_client_add_gear", id, ammo_lootable, ammo)
	end

	self:_add_unit(unit)
end

function LootManagerServer:_add_unit(unit, t)
	local t = Managers.time:time("game")
	local index = self:_next_unit_index()

	self:_clear_index(index, true)

	self._unit_indices[unit] = index
	self._unit_list[index] = {
		unit = unit,
		removal_time = t + LOOT_REMOVAL_TIME
	}
	self._last_index = index
end

function LootManagerServer:_next_unit_index()
	return self._last_index % MAX_LOOT + 1
end

function LootManagerServer:_clear_index(index, destroy)
	local entry = self._unit_list[index]

	if entry then
		local unit = entry.unit

		self._unit_list[index] = nil
		self._unit_indices[unit] = nil

		local network_manager = Managers.state.network
		local game = network_manager:game()

		if game then
			local id = network_manager:game_object_id(unit)

			if destroy then
				self:_destroy_game_object(unit)
			else
				network_manager:send_rpc_clients("rpc_loot_manager_client_remove_gear", id)
			end
		elseif destroy then
			World.destroy_unit(self._world, unit)
		else
			self:_set_gear_lootable(unit, false)
		end
	end

	if index == self._last_index then
		self._last_index = (self._last_index - 2) % MAX_LOOT + 1
	end
end

function LootManagerServer:_destroy_game_object(unit)
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local id = network_manager:game_object_id(unit)

	if Unit.get_data(unit, "manually_destroy_gear") then
		network_manager:send_rpc_clients("rpc_loot_manager_client_destroy_gear_manually", id)
		World.destroy_unit(self._world, unit)
	end

	network_manager:destroy_game_object(id)
end

function LootManagerServer:rpc_loot_manager_server_request_ammo_loot(looter_unit, gear_unit)
	local gear_name, ammo = self:pickup_gear(gear_unit)

	self._pending_gear[gear_unit] = true

	return gear_name, ammo
end

function LootManagerServer:request_ammo_loot(looter_unit, gear_unit, cb)
	local gear_name, ammo = self:pickup_gear(gear_unit)

	self._pending_gear[gear_unit] = true

	cb(looter_unit, gear_name, ammo)
end

function LootManagerServer:ammo_loot_completed(gear_unit)
	self._pending_gear[gear_unit] = nil

	if Managers.state.network:game() then
		self:_destroy_game_object(gear_unit)
	else
		World.destroy_unit(self._world, gear_unit)
	end
end

function LootManagerServer:ammo_loot_aborted(gear_unit)
	self._pending_gear[gear_unit] = nil

	if Unit.alive(gear_unit) then
		local manually_destroy_gear = Unit.get_data(gear_unit, "manually_destroy_gear")

		self:add_gear(gear_unit, manually_destroy_gear, Unit.get_data(gear_unit, "ammo"))
	end
end

function LootManagerServer:request_pickup_gear(looter_unit, gear_unit)
	local gear_name, ammo = self:pickup_gear(gear_unit)
	local looter_eligble = true

	self._pending_gear[gear_unit] = true

	return looter_eligble and gear_name, ammo
end

function LootManagerServer:pickup_gear_completed(gear_unit)
	self._pending_gear[gear_unit] = nil

	if Unit.alive(gear_unit) then
		if Managers.state.network:game() then
			self:_destroy_game_object(gear_unit)
		else
			World.destroy_unit(self._world, unit)
		end
	end
end

function LootManagerServer:pickup_gear_aborted(gear_unit)
	self._pending_gear[gear_unit] = nil

	if Unit.alive(gear_unit) then
		local manually_destroy_gear = Unit.get_data(gear_unit, "manually_destroy_gear")

		self:add_gear(gear_unit, manually_destroy_gear, Unit.get_data(gear_unit, "ammo"))
	end
end

function LootManagerServer:pickup_gear(unit)
	local index = self._unit_indices[unit]

	if not index then
		return nil
	end

	local gear_name = Unit.get_data(unit, "gear_name")
	local ammo = Unit.get_data(unit, "ammo")

	self:_clear_index(index, false)

	return gear_name, ammo
end

function LootManagerServer:destroy()
	local world = self._world

	for unit, _ in pairs(self._unit_indices) do
		World.destroy_unit(world, unit)
	end
end
