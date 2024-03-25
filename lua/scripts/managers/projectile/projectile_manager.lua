-- chunkname: @scripts/managers/projectile/projectile_manager.lua

ProjectileManager = class(ProjectileManager)

local MAX_LINKED_PROJECTILES = 30
local MAX_PHYSICAL_PROJECTILES = 5

function ProjectileManager:init(world)
	self._world = world
	self._active_projectiles = {}
	self._linked_projectiles = {}
	self._linked_projectile_index = 1
	self._physical_projectiles = {}
	self._physical_projectile_index = 1
	self._thrown_weapons = {
		linked_projectile_index = 1,
		active_projectiles = {},
		linked_projectiles = {}
	}
end

function ProjectileManager:destroy()
	for _, unit in pairs(self._linked_projectiles) do
		if unit and Unit.alive(unit) then
			self:_remove_projectile(unit)
		end
	end

	for _, unit in pairs(self._thrown_weapons.linked_projectiles) do
		if unit and Unit.alive(unit) then
			self:_remove_projectile(unit)
		end
	end

	for _, unit in pairs(self._physical_projectiles) do
		if unit and Unit.alive(unit) then
			self:_remove_projectile(unit)
		end
	end
end

function ProjectileManager:update(dt, t)
	return
end

function ProjectileManager:remove_projectiles(owner)
	local network_manager = Managers.state.network
	local player_index = network_manager:temp_player_index(owner)
	local removed_projectile = false
	local replicate_remove = Managers.lobby.server and network_manager:game()
	local active_projectiles = self._active_projectiles[player_index]
	local active_thrown_projectiles = self._thrown_weapons.active_projectiles[player_index]

	if active_projectiles then
		for unit, ext in pairs(active_projectiles) do
			removed_projectile = true

			Managers.state.entity:unregister_unit(unit)
		end
	end

	if active_thrown_projectiles then
		for unit, ext in pairs(active_thrown_projectiles) do
			removed_projectile = true

			Managers.state.entity:unregister_unit(unit)
		end
	end

	if replicate_remove and removed_projectile then
		network_manager:send_rpc_clients("rpc_remove_projectiles", owner)
	end

	self._active_projectiles[player_index] = nil
	self._thrown_weapons.active_projectiles[player_index] = nil

	Managers.state.event:trigger("projectiles_updated", Managers.player:player(player_index))
end

function ProjectileManager:spawn_projectile(player_index, user_unit, weapon_unit, projectile_name_id, gear_name_id, position, exit_velocity, gravity_multiplier, charge_value, properties_id, faster_bow_charge_active)
	local projectile_name = NetworkLookup.projectiles[projectile_name_id]
	local gear_name = NetworkLookup.inventory_gear[gear_name_id]
	local projectile_settings = Gear[gear_name].projectiles[projectile_name]
	local rotation = Quaternion.look(exit_velocity, Vector3.up())
	local projectile_unit_name = projectile_settings.unit
	local unit = World.spawn_unit(self._world, projectile_unit_name, position, rotation)
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		network_manager:create_projectile_game_object(player_index, user_unit, weapon_unit, projectile_name_id, gear_name_id, position, exit_velocity, gravity_multiplier, charge_value, properties_id, projectile_unit_name, unit)
	end

	player_index = network_manager:temp_player_index(player_index)
	self._active_projectiles[player_index] = self._active_projectiles[player_index] or {}

	Managers.state.entity:register_unit(self._world, unit, player_index, user_unit, weapon_unit, false, game, projectile_name, gear_name, exit_velocity, gravity_multiplier, charge_value, properties_id, faster_bow_charge_active)

	self._active_projectiles[player_index][unit] = ScriptUnit.extension(unit, "projectile_system")
end

function ProjectileManager:link_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, local_projectile, hit_zone, impact_direction, normal, actor)
	local network_manager = Managers.state.network

	if local_projectile and network_manager:game() then
		local level = LevelHelper:current_level(self._world)
		local hit_unit_index = Level.unit_index(level, hit_unit)
		local hit_unit_game_object_id = network_manager:game_object_id(hit_unit)
		local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]
		local num_actors = Unit.num_actors(hit_unit)
		local actor_index = 0

		for i = 0, num_actors - 1 do
			if Unit.actor(hit_unit, i) == actor then
				actor_index = i

				break
			end
		end

		local damage_constant = NetworkConstants.damage
		local network_damage = math.clamp(damage, damage_constant.min, damage_constant.max)

		if hit_unit_game_object_id then
			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_link_projectile_obj_id", hit_unit_game_object_id, node_index, network_manager:game_object_id(projectile_unit), position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal, actor_index)
			else
				network_manager:send_rpc_server("rpc_link_projectile_obj_id", hit_unit_game_object_id, node_index, network_manager:game_object_id(projectile_unit), position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal, actor_index)
			end
		elseif hit_unit_index then
			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_link_projectile_lvl_id", hit_unit_index, node_index, network_manager:game_object_id(projectile_unit), position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			else
				network_manager:send_rpc_server("rpc_link_projectile_lvl_id", hit_unit_index, node_index, network_manager:game_object_id(projectile_unit), position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			end
		else
			self:drop_projectile(hit_unit, position, rotation, damage, penetrated, target_type, projectile_unit, local_projectile, hit_zone, impact_direction, normal)

			return
		end
	end

	local projectile_extension = ScriptUnit.extension(projectile_unit, "projectile_system")
	local projectile_table = Unit.get_data(hit_unit, "linked_dummy_projectiles") or {}

	projectile_table[#projectile_table + 1] = projectile_unit

	Unit.set_data(hit_unit, "linked_dummy_projectiles", projectile_table)
	projectile_extension:link_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, hit_zone, impact_direction, normal, actor)

	for _, projs in pairs(self._active_projectiles) do
		projs[projectile_unit] = nil
	end

	Managers.state.entity:unregister_unit(projectile_unit)

	local new_projectile_index = self._linked_projectile_index
	local existing_projectile = self._linked_projectiles[new_projectile_index]

	if Unit.alive(existing_projectile) then
		self:_remove_projectile(existing_projectile)
	end

	Managers.state.event:trigger("projectiles_updated", Managers.player:owner(hit_unit))

	self._linked_projectiles[new_projectile_index] = projectile_unit
	self._linked_projectile_index = new_projectile_index % MAX_LINKED_PROJECTILES + 1
end

function ProjectileManager:clear_projectiles(from_unit)
	local projectile_table = Unit.get_data(from_unit, "linked_dummy_projectiles")

	if projectile_table then
		for _, unit in ipairs(projectile_table) do
			if Unit.alive(unit) then
				self:_remove_projectile(unit)
			end
		end

		Unit.set_data(from_unit, "linked_dummy_projectiles", nil)
	end

	local throwing_weapons_table = Unit.get_data(from_unit, "linked_throwing_weapons")

	if throwing_weapons_table then
		for _, unit in ipairs(throwing_weapons_table) do
			if Unit.alive(unit) then
				local actor_index = Unit.find_actor(unit, "thrown")
				local actor = Unit.create_actor(unit, actor_index, 0)

				if Managers.lobby.server then
					Managers.state.loot:add_gear(unit, true, 1)
				end

				local linked_projectiles = self._thrown_weapons.linked_projectiles

				for key, projectile_unit in pairs(linked_projectiles) do
					if projectile_unit == unit then
						linked_projectiles[key] = nil
					end
				end
			end
		end

		Unit.set_data(from_unit, "linked_throwing_weapons", nil)
	end

	Managers.state.event:trigger("projectiles_updated", Managers.player:owner(from_unit))
end

function ProjectileManager:_remove_projectile(unit)
	World.destroy_unit(self._world, unit)
end

function ProjectileManager:drop_projectile(hit_unit, position, rotation, damage, penetrated, target_type, projectile_unit, local_projectile, hit_zone, impact_direction, normal)
	local network_manager = Managers.state.network

	if local_projectile and network_manager:game() then
		position = Vector3.clamp(position, NetworkConstants.position.min, NetworkConstants.position.max)

		local level = LevelHelper:current_level(self._world)
		local hit_unit_index = Level.unit_index(level, hit_unit)
		local hit_unit_game_object_id = network_manager:game_object_id(hit_unit)
		local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]
		local damage_constant = NetworkConstants.damage
		local network_damage = math.clamp(damage, damage_constant.min, damage_constant.max)

		if hit_unit_game_object_id then
			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_drop_projectile_obj_id", hit_unit_game_object_id, network_manager:game_object_id(projectile_unit), position, rotation, damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			else
				network_manager:send_rpc_server("rpc_drop_projectile_obj_id", hit_unit_game_object_id, network_manager:game_object_id(projectile_unit), position, rotation, damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			end
		elseif hit_unit_index then
			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_drop_projectile_lvl_id", hit_unit_index, network_manager:game_object_id(projectile_unit), position, rotation, damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			else
				network_manager:send_rpc_server("rpc_drop_projectile_lvl_id", hit_unit_index, network_manager:game_object_id(projectile_unit), position, rotation, damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal)
			end
		end
	end

	local projectile_extension = ScriptUnit.extension(projectile_unit, "projectile_system")

	projectile_extension:drop_projectile(hit_unit, position, rotation, damage, penetrated, target_type, hit_zone, impact_direction, normal)

	for _, projs in pairs(self._active_projectiles) do
		projs[projectile_unit] = nil
	end

	Managers.state.entity:unregister_unit(projectile_unit)

	local new_projectile_index = self._physical_projectile_index
	local existing_projectile = self._physical_projectiles[new_projectile_index]

	if Unit.alive(existing_projectile) then
		self:_remove_projectile(existing_projectile)
	end

	Managers.state.event:trigger("projectiles_updated", Managers.player:owner(hit_unit))

	self._physical_projectiles[new_projectile_index] = projectile_unit
	self._physical_projectile_index = new_projectile_index % MAX_LINKED_PROJECTILES + 1
end

function ProjectileManager:spawn_thrown_projectile(player_index, gear_name_id, position, rotation, exit_velocity, user_unit)
	local thrown_weapons = self._thrown_weapons
	local network_manager = Managers.state.network

	player_index = network_manager:temp_player_index(player_index)

	local gear_name = NetworkLookup.gear_names[gear_name_id]
	local gear_settings = Gear[gear_name]
	local unit = World.spawn_unit(self._world, gear_settings.unit, position, rotation)

	Unit.set_data(unit, "extensions", 0, "ThrownProjectile")
	Unit.set_data(unit, "gear_extensions", nil)

	local active_projectiles = thrown_weapons.active_projectiles

	active_projectiles[player_index] = active_projectiles[player_index] or {}

	Managers.state.entity:register_unit(self._world, unit, player_index, exit_velocity, gear_name, user_unit, false)

	active_projectiles[player_index][unit] = ScriptUnit.extension(unit, "projectile_system")
end

function ProjectileManager:link_thrown_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, projectile_unit, hit_zone, impact_direction, normal, lootable)
	local thrown_weapons = self._thrown_weapons
	local network_manager = Managers.state.network

	if Managers.lobby.server and network_manager:game() then
		local level = LevelHelper:current_level(self._world)
		local hit_unit_index = Level.unit_index(level, hit_unit)
		local hit_unit_game_object_id = network_manager:game_object_id(hit_unit)
		local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]
		local damage_constant = NetworkConstants.damage
		local network_damage = math.clamp(damage, damage_constant.min, damage_constant.max)
		local network_position = Vector3(math.clamp(position.x, -999, 999), math.clamp(position.y, -999, 999), math.clamp(position.z, -999, 999))

		if hit_unit_game_object_id then
			network_manager:send_rpc_clients("rpc_link_thrown_projectile_obj_id", hit_unit_game_object_id, node_index, network_manager:game_object_id(projectile_unit), network_position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal, lootable)
		elseif hit_unit_index then
			network_manager:send_rpc_clients("rpc_link_thrown_projectile_lvl_id", hit_unit_index, node_index, network_manager:game_object_id(projectile_unit), network_position, rotation, network_damage, penetrated, target_type_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, normal, lootable)
		end
	end

	local projectile_extension = ScriptUnit.extension(projectile_unit, "projectile_system")
	local projectile_table = Unit.get_data(hit_unit, "linked_thrown_projectiles") or {}

	projectile_table[#projectile_table + 1] = projectile_unit

	Unit.set_data(hit_unit, "linked_thrown_projectiles", projectile_table)
	projectile_extension:link_projectile(hit_unit, node_index, position, rotation, damage, penetrated, target_type, hit_zone, impact_direction, normal)

	local active_projectiles = thrown_weapons.active_projectiles

	for _, projs in pairs(active_projectiles) do
		projs[projectile_unit] = nil
	end

	Managers.state.entity:unregister_unit(projectile_unit)

	if lootable then
		if Managers.lobby.server then
			Managers.state.loot:add_gear(projectile_unit, true, 1)
		end
	else
		local projectile_table = Unit.get_data(hit_unit, "linked_throwing_weapons") or {}

		projectile_table[#projectile_table + 1] = projectile_unit

		Unit.set_data(hit_unit, "linked_throwing_weapons", projectile_table)

		local linked_projectiles = thrown_weapons.linked_projectiles
		local new_projectile_index = thrown_weapons.linked_projectile_index
		local existing_projectile = linked_projectiles[new_projectile_index]

		if Unit.alive(existing_projectile) then
			self:_remove_projectile(existing_projectile)
		end

		Managers.state.event:trigger("projectiles_updated", Managers.player:owner(hit_unit))

		linked_projectiles[new_projectile_index] = projectile_unit
		thrown_weapons.linked_projectile_index = new_projectile_index % MAX_LINKED_PROJECTILES + 1
	end
end

function ProjectileManager:thrown_projectile_disabled(projectile_unit, reason)
	local thrown_weapons = self._thrown_weapons
	local active_projectiles = thrown_weapons.active_projectiles

	for _, projs in pairs(active_projectiles) do
		projs[projectile_unit] = nil
	end

	if Managers.lobby.server then
		local network_manager = Managers.state.network
		local id = network_manager:game_object_id(projectile_unit)

		network_manager:send_rpc_clients("rpc_thrown_projectile_disabled", id)
		Managers.state.entity:unregister_unit(projectile_unit)
		Managers.state.loot:add_gear(projectile_unit, true, 1)
	else
		Managers.state.entity:unregister_unit(projectile_unit)
	end
end
