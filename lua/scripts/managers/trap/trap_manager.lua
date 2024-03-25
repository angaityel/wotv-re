-- chunkname: @scripts/managers/trap/trap_manager.lua

TrapManager = class(TrapManager)

function TrapManager:init(world)
	self._world = world
	self._registered_traps = {}
	self._trap_names = {
		"trap_1",
		"trap_2",
		"trap_3",
		"trap_4"
	}
	self._trigger_functions = {
		alert = "_trigger_trap_alert"
	}
	self._trap_owners = {}
	self._pending_traps = {}
end

function TrapManager:add_trap_server(player, position)
	local player_traps = self._registered_traps[player] or {}

	if #player_traps == Perks.alert_trap.max_allowed_traps then
		self:_remove_trap_limit_reached(player_traps)
	end

	local trap_unit = World.spawn_unit(self._world, "units/gameplay/traps/perk_bell_trap/perk_bell_trap", position)
	local trap_name = self:_find_name_for_trap(player_traps, player)

	Unit.set_data(trap_unit, "trap_name", trap_name)

	local new_trap = {
		type = "alert",
		unit = trap_unit,
		name = trap_name,
		position = Vector3Box(position)
	}
	local network_manager = Managers.state.network
	local player_id = player:player_id()
	local trap_name_id = NetworkLookup.trap_names[trap_name]

	network_manager:send_rpc_clients("rpc_place_alert_trap", player_id, position, trap_name_id)

	player_traps[#player_traps + 1] = new_trap
	self._registered_traps[player] = player_traps
	self._trap_owners[trap_unit] = player
end

function TrapManager:add_trap_client(player, position, trap_name)
	local player_traps = self._registered_traps[player] or {}

	if #player_traps == Perks.alert_trap.max_allowed_traps then
		self:_remove_trap_limit_reached(player_traps)
	end

	local trap_unit = World.spawn_unit(self._world, "units/gameplay/traps/perk_bell_trap/perk_bell_trap_husk", position)

	Unit.set_data(trap_unit, "trap_name", trap_name)

	local new_trap = {
		type = "alert",
		unit = trap_unit,
		name = trap_name,
		position = Vector3Box(position)
	}

	player_traps[#player_traps + 1] = new_trap
	self._registered_traps[player] = player_traps
	self._trap_owners[trap_unit] = player

	if player.local_player and Unit.find_actor(trap_unit, "interaction") then
		Unit.create_actor(trap_unit, "interaction")
	end

	Managers.state.event:trigger("trap_added", trap_unit)
end

function TrapManager:trigger_trap_server(victim, trap_unit)
	local trap_owner = self:owner(trap_unit)
	local trap_name = Unit.get_data(trap_unit, "trap_name")
	local trap = self:trap_from_name(trap_owner, trap_name)
	local network_manager = Managers.state.network
	local victim_id = victim:player_id()
	local trap_owner_id = trap_owner:player_id()
	local trap_name_id = NetworkLookup.trap_names[trap_name]

	network_manager:send_rpc_clients("rpc_trigger_trap", trap_owner_id, victim_id, trap_name_id)
	self:_destroy_trap(trap_owner, trap_name)
end

function TrapManager:trigger_trap_client(player, victim, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)

	self[self._trigger_functions[trap.type]](self, player, victim, trap)
end

function TrapManager:_trigger_trap_alert(player, victim, trap)
	local timpani_world = World.timpani_world(self._world)

	TimpaniWorld.trigger_event(timpani_world, "trap_activate", trap.position:unbox())

	local player_manager = Managers.player
	local local_player = player_manager:player_exists(1) and player_manager:player(1)

	if local_player == player then
		Managers.state.event:trigger("alert_trap_triggered", player, victim, trap.unit)
		TimpaniWorld.trigger_event(timpani_world, "hud_trap_notification")
	end

	self:_destroy_trap(player, trap.name)
end

function TrapManager:trap_from_name(player, trap_name)
	local player_traps = self._registered_traps[player] or {}

	for i, trap in ipairs(player_traps) do
		if trap.name == trap_name then
			return trap, i
		end
	end
end

function TrapManager:owner(trap_unit)
	return self._trap_owners[trap_unit]
end

function TrapManager:_remove_trap_limit_reached(player_traps)
	local trap = player_traps[1]
	local trap_unit = trap.unit

	self._trap_owners[trap_unit] = nil

	World.destroy_unit(self._world, trap_unit)
	table.remove(player_traps, 1)
end

function TrapManager:_find_name_for_trap(player_traps, player)
	for _, name in ipairs(self._trap_names) do
		local name_taken = false

		for _, trap in ipairs(player_traps) do
			if trap.name == name then
				name_taken = true

				break
			end
		end

		if not name_taken then
			return name
		end
	end
end

function TrapManager:_destroy_trap(player, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)

	Managers.state.event:trigger("trap_destroyed", player, trap.unit)

	self._trap_owners[trap.unit] = nil

	World.destroy_unit(self._world, trap.unit)
	table.remove(self._registered_traps[player], id)
end

function TrapManager:loot_trap_server(player, trap_name)
	self:_register_pending_trap_server(player, trap_name)
end

function TrapManager:loot_trap_client(player, trap_name)
	self:_register_pending_trap_client(player, trap_name)
end

function TrapManager:loot_trap_complete_server(player, trap_name)
	self:_unregister_pending_trap_server(player, trap_name)
	self:_destroy_trap(player, trap_name)

	local network_manager = Managers.state.network
	local player_unit = player.player_unit
	local player_unit_id = network_manager:unit_game_object_id(player_unit)
	local trap_name_id = NetworkLookup.trap_names[trap_name]

	network_manager:send_rpc_clients("rpc_loot_trap_complete", player_unit_id, trap_name_id)
end

function TrapManager:loot_trap_complete_client(player, trap_name)
	self:_unregister_pending_trap_client(player, trap_name)
	self:_destroy_trap(player, trap_name)
end

function TrapManager:loot_trap_aborted_server(player, trap_name)
	self:_unregister_pending_trap_server(player, trap_name)

	local network_manager = Managers.state.network
	local player_unit = player.player_unit
	local player_unit_id = network_manager:unit_game_object_id(player_unit)
	local trap_name_id = NetworkLookup.trap_names[trap_name]

	network_manager:send_rpc_clients("rpc_loot_trap_abort", player_unit_id, trap_name_id)
end

function TrapManager:loot_trap_aborted_client(player, trap_name)
	self:_unregister_pending_trap_client(player, trap_name)
end

function TrapManager:can_loot_trap(player, trap_unit)
	local owner = self:owner(trap_unit)
	local owns_trap = player == owner

	if owns_trap and not self._pending_traps[trap_unit] then
		return true
	else
		return false
	end
end

function TrapManager:can_trigger_trap(trigger_player, trap_unit)
	local owner = self:owner(trap_unit)
	local enemy_trap = trigger_player.team.name ~= owner.team.name

	if enemy_trap and not self._pending_traps[trap_unit] then
		return true
	else
		return false
	end
end

function TrapManager:_register_pending_trap_server(player, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)
	local trap_unit = trap.unit

	self._pending_traps[trap_unit] = trap

	Unit.destroy_actor(trap_unit, "physics_trigger")
end

function TrapManager:_register_pending_trap_client(player, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)

	self._pending_traps[trap.unit] = trap
end

function TrapManager:_unregister_pending_trap_server(player, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)
	local trap_unit = trap.unit

	self._pending_traps[trap_unit] = nil

	Unit.create_actor(trap_unit, "physics_trigger")
end

function TrapManager:_unregister_pending_trap_client(player, trap_name)
	local trap, id = self:trap_from_name(player, trap_name)

	self._pending_traps[trap.unit] = nil
end

function TrapManager:remove_player_traps_server(player)
	local traps = self._registered_traps[player] or {}

	for _, trap in ipairs(traps) do
		self._pending_traps[trap.unit] = nil

		World.destroy_unit(self._world, trap.unit)
	end

	self._registered_traps[player] = nil

	local network_manager = Managers.state.network
	local player_id = player:player_id()

	network_manager:send_rpc_clients("rpc_remove_player_traps", player_id)
end

function TrapManager:remove_player_traps_client(player)
	local traps = self._registered_traps[player] or {}

	for _, trap in ipairs(traps) do
		self._pending_traps[trap.unit] = nil

		Managers.state.event:trigger("trap_destroyed", player, trap.unit)
		World.destroy_unit(self._world, trap.unit)
	end

	self._registered_traps[player] = nil
end

function TrapManager:hot_join_synch(sender, player)
	for owning_player, traps in pairs(self._registered_traps) do
		for _, trap in ipairs(traps) do
			local player_id = player:player_id()

			RPC.rpc_place_alert_trap(sender, owning_player:player_id(), trap.position:unbox(), NetworkLookup.trap_names[trap.name])
		end
	end
end

function TrapManager:destroy()
	for player, traps in pairs(self._registered_traps) do
		for _, trap in ipairs(traps) do
			World.destroy_unit(self._world, trap.unit)
		end
	end
end
