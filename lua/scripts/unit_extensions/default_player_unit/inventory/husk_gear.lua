-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/husk_gear.lua

require("scripts/unit_extensions/default_player_unit/inventory/base_gear")

HuskGear = class(HuskGear, BaseGear)

function HuskGear:init(world, user_unit, player, name, obj_id, slot_name, user_locomotion, ammo)
	self._world = world
	self._settings = Gear[name]

	self:_spawn_unit(world)

	self._name = name
	self._projectile_name = nil
	self._user_unit = user_unit
	self._player = player
	self._user_locomotion = user_locomotion

	self:_set_unit_data()
	BaseGear.init(self, world, user_unit, player, name, slot_name, user_locomotion)

	self._id = obj_id
	self._extensions = {}

	local name = "WeaponMelee"
	local class = rawget(_G, name)

	self._extensions[name] = class:new(self._world, self._unit, user_unit, player, self._id, user_locomotion)
	self._extensions[name].gear_type = self._settings.gear_type
end

function HuskGear:update(dt, t)
	self._extensions.WeaponMelee:update(dt, t)
end

function HuskGear:set_collision(enable)
	self._extensions.WeaponMelee:_activate_sweep_collision(enable)
end

function HuskGear:_spawn_unit(world)
	self._unit = World.spawn_unit(world, self._settings.husk_unit)

	if self._unit then
		Unit.set_data(self._unit, "husk", true)
	end
end

function HuskGear:start_melee_attack(charge_factor, attack_name, attack_settings, cb_abort_attack, attack_time, abort_on_hit, riposte)
	if Managers.lobby.server then
		cb_abort_attack = callback(self, "cb_abort_attack")

		self._extensions.WeaponMelee:start_attack(charge_factor, attack_name, attack_settings, cb_abort_attack, attack_time, abort_on_hit, riposte)
	end
end

function HuskGear:cb_abort_attack(reason)
	self._user_locomotion:_trigger_abort_attack(reason)
end

function HuskGear:drop()
	local unit = self._unit

	Unit.set_data(unit, "dropped", true)

	local lod_object = Unit.lod_object(unit, "LOD")

	LODObject.set_orientation_node(lod_object, unit, 0)

	if Managers.state and Managers.state.outline then
		Managers.state.outline:outline_unit(unit, "outline_unit", false)
	end

	self:set_kinematic(false)

	self._dropped = true
end

function HuskGear:is_shield()
	return self._settings.gear_type == "shield"
end

function HuskGear:enter_ghost_mode()
	self:hide_gear("ghost_mode")
	self:hide_quiver("ghost_mode")
	HuskGear.super.enter_ghost_mode(self)
end

function HuskGear:exit_ghost_mode()
	self:unhide_gear("ghost_mode")
	self:unhide_quiver("ghost_mode")
	HuskGear.super.exit_ghost_mode(self)
end

function HuskGear:destroy()
	local unit = self._unit

	if Unit.alive(unit) then
		local lod_object = Unit.lod_object(unit, "LOD")

		LODObject.set_orientation_node(lod_object, unit, 0)

		if Managers.state and Managers.state.outline then
			Managers.state.outline:outline_unit(unit, "outline_unit", false)
		end
	end

	HuskGear.super.destroy(self)
end
