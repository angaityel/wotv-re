-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/player_gear.lua

require("scripts/unit_extensions/default_player_unit/inventory/base_gear")

PlayerGear = class(PlayerGear, BaseGear)

function PlayerGear:init(world, user_unit, player, name, obj_id, slot_name, user_locomotion, ammo)
	self._world = world
	self._game = nil
	self._id = nil
	self._wielded = false
	self._settings = Gear[name]

	self:_spawn_unit(world)

	self._projectile_name = nil
	self._user_unit = user_unit
	self._player = player
	self._name = name
	self._thrown = false

	self:_set_unit_data()

	self._user_locomotion = user_locomotion

	local game = Managers.state.network:game()

	if game then
		self:_create_game_object(game, self._unit, slot_name, ammo)
		BaseGear.init(self, world, user_unit, player, name, slot_name, user_locomotion)
	else
		BaseGear.init(self, world, user_unit, player, name, slot_name, user_locomotion)
		Managers.state.entity:register_unit(self._world, self._unit)
	end
end

function PlayerGear:_create_game_object(game, unit, slot_name, ammo)
	local player_unit_game_object_id = Managers.state.network:unit_game_object_id(self._user_unit)

	fassert(player_unit_game_object_id, "[PlayerGear:_create_game_object] unit: '%s' does not have have a game object id.", tostring(self._user_unit))

	local data_table = {
		dropped = false,
		gear_name = NetworkLookup.inventory_gear[self._name],
		slot_name = NetworkLookup.inventory_slots[slot_name],
		user_object_id = player_unit_game_object_id,
		game_object_created_func = NetworkLookup.game_object_functions.cb_spawn_gear,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		object_destroy_func = NetworkLookup.game_object_functions.cb_destroy_gear
	}

	data_table.ammunition = ammo or self._settings.starting_ammo or 1

	local callback = callback(self, "cb_game_session_disconnect")
	local unit_type = "gear_unit_ammo"

	self._id = Managers.state.network:create_game_object(unit_type, data_table, callback, "cb_local_gear_unit_spawned", unit)
	self._game = game
end

function PlayerGear:drop()
	self:set_kinematic(false)

	self._lootable_dropped = true

	Unit.set_data(self._unit, "dropped", true)

	local network_manager = Managers.state.network
	local game = network_manager:game()
	local id = self._id

	if game and id then
		if Managers.lobby.server then
			Managers.state.loot:add_gear(self._unit, false, self:ammo() or 1)
			GameSession.set_game_object_field(game, id, "dropped", true)
			network_manager:send_rpc_clients("rpc_gear_dropped", id)
		else
			network_manager:send_rpc_server("rpc_gear_dropped", id)
		end
	end
end

function PlayerGear:cb_game_session_disconnect()
	self._frozen = true
	self._id = nil
	self._game = nil
end

function PlayerGear:_spawn_unit(world)
	self._unit = World.spawn_unit(world, self._settings.unit)
end

function PlayerGear:update(dt, t)
	if self._frozen then
		return
	end

	for _, extension in pairs(self._extensions) do
		if extension.update then
			extension:update(dt, t)
		end
	end
end

function PlayerGear:is_melee_weapon()
	local attacks = self._settings.attacks

	if attacks.up or attacks.down or attacks.right or attacks.left or attacks.left_start or attacks.right_start then
		return true
	else
		return false
	end
end

function PlayerGear:is_weapon()
	return self:is_melee_weapon() or self:is_ranged_weapon()
end

function PlayerGear:is_shield()
	return self._settings.gear_type == "shield"
end

function PlayerGear:is_one_handed()
	return self._settings.hand == "left_hand" or self._settings.hand == "right_hand"
end

function PlayerGear:is_two_handed()
	return self._settings.hand == "both_hands"
end

function PlayerGear:is_left_handed()
	return self._settings.hand == "left_hand"
end

function PlayerGear:is_right_handed()
	return self._settings.hand == "right_hand"
end

function PlayerGear:can_block()
	return self._settings.block_type
end

function PlayerGear:send_start_melee_attack(charge_factor, attack_name, attack_settings, cb_abort_attack, attack_time, abort_on_hit, riposte)
	if not Managers.lobby.server and not GameSettingsDevelopment.tutorial_mode then
		local network_manager = Managers.state.network
		local owner_unit = Unit.get_data(self._unit, "user_unit")
		local player_unit_id = network_manager:unit_game_object_id(owner_unit)
		local gear_unit_id = network_manager:unit_game_object_id(self._unit)
		local attack_index = NetworkLookup.attack_index[attack_name] or 1

		if attack_index <= 1 then
			printf("ERROR: Can't find attack_name in NetworkLookup!")
		end

		riposte = riposte or false

		network_manager:send_rpc_server("rpc_start_melee_attack", player_unit_id, gear_unit_id, attack_index, attack_time, charge_factor, riposte)
	end
end

function PlayerGear:start_melee_attack(charge_factor, attack_name, attack_settings, cb_abort_attack, attack_time, abort_on_hit, riposte)
	self._extensions.base:start_attack(charge_factor, attack_name, attack_settings, cb_abort_attack, attack_time, abort_on_hit, riposte)
end

function PlayerGear:start_couch(cb_abort_attack)
	self._extensions.base:start_couch(cb_abort_attack)
end

function PlayerGear:end_couch()
	return self._extensions.base:end_couch()
end

function PlayerGear:end_melee_attack()
	return self._extensions.base:end_attack()
end

function PlayerGear:die()
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local unit = self._unit

	if game and Managers.lobby.server then
		local object_id = network_manager:game_object_id(unit)

		network_manager:send_rpc_clients("rpc_gear_dead", object_id)
	elseif game then
		local object_id = network_manager:game_object_id(unit)

		network_manager:send_rpc_server("rpc_gear_dead", object_id)
	end

	PlayerGear.super.die(self)
end

function PlayerGear:is_thrown()
	return self._thrown
end

function PlayerGear:can_ammo_loot(amount)
	local ext = self._extensions.base
	local ammo = ext:ammo()

	if ammo < ext:starting_ammo() then
		return true
	else
		return false
	end
end

function PlayerGear:out_of_ammo()
	local ammo = self:ammo()

	return ammo and ammo < 1
end

function PlayerGear:ammo()
	local ext = self._extensions.base
	local ammo = ext.ammo and ext:ammo()

	return ammo
end

function PlayerGear:add_ammo(amount)
	local ext = self._extensions.base
	local ammo_before = ext:ammo()

	ext:add_ammo(amount)

	local ammo_after = ext:ammo()

	if ammo_before == 0 and ammo_after > 0 then
		self:unhide_gear("ammo")
	elseif ammo_before > 0 and ammo_after == 0 then
		self:hide_gear("ammo")
	end
end

function PlayerGear:throw(position, rotation, velocity)
	local gear_name_id = NetworkLookup.gear_names[self._name]
	local network_manager = Managers.state.network

	if network_manager:game() then
		local player_index = self._player:player_id()

		if script_data.throw_all_weapons then
			script_data.unlimited_ammo = true

			for name, gear in pairs(Gear) do
				if gear and gear.attacks and gear.attacks.throw then
					local gear_name_id = NetworkLookup.gear_names[name]
					local velocity_rot = Quaternion.look(Vector3.normalize(velocity), Vector3.up())
					local random_rot = Quaternion.multiply(velocity_rot, Quaternion.multiply(Quaternion(Vector3.forward(), 2 * math.pi * Math.random()), Quaternion(Vector3.right(), math.pi / 16 * Math.random())))
					local dispersed_velocity = Vector3.length(velocity) * Quaternion.forward(random_rot) * (Math.random() * 0.1 + 0.9)

					network_manager:send_rpc_server("rpc_spawn_thrown_projectile", player_index, gear_name_id, position + dispersed_velocity * 0.1 - velocity * 0.1, rotation, dispersed_velocity, network_manager:game_object_id(self._user_unit))
				end
			end
		elseif script_data.debug_mass_throw then
			for i = 1, script_data.debug_mass_throw do
				local velocity_rot = Quaternion.look(Vector3.normalize(velocity), Vector3.up())
				local random_rot = Quaternion.multiply(velocity_rot, Quaternion.multiply(Quaternion(Vector3.forward(), 2 * math.pi * Math.random()), Quaternion(Vector3.right(), math.pi / 16 * Math.random())))
				local dispersed_velocity = Vector3.length(velocity) * Quaternion.forward(random_rot) * (Math.random() * 0.1 + 0.9)

				network_manager:send_rpc_server("rpc_spawn_thrown_projectile", player_index, gear_name_id, position + dispersed_velocity * 0.1 - velocity * 0.1, rotation, dispersed_velocity, network_manager:game_object_id(self._user_unit))
			end
		else
			network_manager:send_rpc_server("rpc_spawn_thrown_projectile", player_index, gear_name_id, position, rotation, velocity, network_manager:game_object_id(self._user_unit))
		end
	else
		local player_index = self._player.index

		Managers.state.projectile:spawn_thrown_projectile(player_index, gear_name_id, position, rotation, velocity, self._user_unit)
	end

	local game_mode = Managers.state.game_mode:game_mode_key()

	if not script_data.unlimited_ammo and game_mode ~= "headhunter" then
		self:add_ammo(-1)
	end

	self:_set_thrown(true)
end

function PlayerGear:_set_thrown(set)
	fassert(set and not self._thrown or not set and self._thrown, "[PlayerGear:_set_thrown] Trying to set gear thrown when already thrown or set not thrown when not already thrown, set status: %s, current status: %s", set, self._thrown)

	if set then
		self:hide_gear("thrown")

		self._thrown = true
	else
		self:unhide_gear("thrown")

		self._thrown = false
	end
end

function PlayerGear:destroy(keep_unit)
	if Managers.state.network:game() and not self._lootable_dropped then
		Managers.state.network:destroy_game_object(self._id)
	end

	PlayerGear.super.destroy(self, keep_unit)

	local unit = self._unit

	for ext_name, ext in pairs(self._extensions) do
		ext:destroy()
	end
end
