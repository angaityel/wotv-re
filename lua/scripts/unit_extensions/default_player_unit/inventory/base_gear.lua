-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/base_gear.lua

require("scripts/settings/gear_settings")
require("scripts/settings/gear_templates")
require("scripts/settings/gear_require")
require("scripts/unit_extensions/weapons/weapon_bow")
require("scripts/unit_extensions/weapons/weapon_crossbow")
require("scripts/unit_extensions/weapons/weapon_melee")
require("scripts/unit_extensions/weapons/weapon_lance")
require("scripts/unit_extensions/weapons/weapon_shield")
require("scripts/helpers/weapon_helper")
require("scripts/utils/disable_reasons")

BaseGear = class(BaseGear)

function BaseGear:init(world, user_unit, player, name, slot_name, user_locomotion)
	self._physics_disabled_reasons = DisableReasons:new()
	self._hide_reasons = DisableReasons:new()
	self._scene_graph_links = {}

	self:set_wielded(false)

	self._extensions = {}

	self:_setup_gear_extensions(player, user_locomotion)

	if Unit.get_data(self._unit, "uses_team_material_variation") then
		self:_set_team_material_variation()
	end

	local quiver_settings = self._settings.quiver

	if quiver_settings then
		self:_spawn_quiver(quiver_settings)
	end

	self._dual_wielded = false
end

function BaseGear:_setup_gear_extensions(player, user_locomotion)
	local unit = self._unit
	local user_unit = self._user_unit
	local extensions = {}
	local i = 0

	while Unit.has_data(unit, "gear_extensions", i) do
		local class_name = Unit.get_data(unit, "gear_extensions", i, "class")
		local name = Unit.get_data(unit, "gear_extensions", i, "name")
		local class = rawget(_G, class_name)

		i = i + 1
		extensions[name] = class:new(self._world, unit, user_unit, player, self._id, user_locomotion)

		if class_name == "WeaponMelee" then
			extensions[name].gear_type = self._settings.gear_type
		end
	end

	self._extensions = extensions
end

function BaseGear:is_ranged_weapon()
	if self._settings.attacks.ranged then
		return true
	else
		return false
	end
end

function BaseGear:_set_team_material_variation()
	local unit = self._unit
	local team_name = Unit.get_data(self._user_unit, "team_name")

	if team_name then
		local unit_name = self._settings.unit
		local material_variation = unit_name .. "_" .. team_name

		Unit.set_material_variation(unit, material_variation)
	end
end

function BaseGear:settings()
	return self._settings
end

function BaseGear:_set_unit_data()
	local unit = self._unit
	local settings = self._settings

	assert(self._name, "Missing name")
	Unit.set_data(unit, "gear_name", self._name)
	Unit.set_data(unit, "user_unit", self._user_unit)
	Unit.set_data(unit, "attacks", self._settings.attacks)
	Unit.set_data(unit, "health", settings.health)
	Unit.set_data(unit, "armour_type", self._settings.armour_type)
	Unit.set_data(unit, "penetration_value", settings.penetration_value)
	Unit.set_data(unit, "absorption_value", settings.absorption_value)
	Unit.set_data(unit, "settings", self._settings)
end

function BaseGear:_link(attachment_node_linking)
	local unit = self._unit
	local user_unit = self._user_unit
	local link_table = self._scene_graph_links

	table.clear(link_table)
	self:_link_units(attachment_node_linking, user_unit, unit, link_table)
end

function BaseGear:_spawn_quiver(quiver_settings)
	local unit_name = quiver_settings.unit
	local attachment_node_linking = quiver_settings.attachment_node_linking
	local unit = World.spawn_unit(self._world, unit_name)

	if quiver_settings.material_variation then
		Unit.set_material_variation(unit, quiver_settings.material_variation)
	end

	local link_table = {}

	self:_link_units(attachment_node_linking, self._user_unit, unit, link_table)

	local quiver_data = {
		unit = unit,
		link_table = link_table,
		disable_reasons = DisableReasons:new()
	}

	self._quiver_data = quiver_data
end

function BaseGear:_link_units(attachment_node_linking, source, target, link_table)
	for i, attachment_nodes in ipairs(attachment_node_linking) do
		local source_node = attachment_nodes.source
		local target_node = attachment_nodes.target
		local source_node_index = type(source_node) == "string" and Unit.node(source, source_node) or source_node
		local target_node_index = type(target_node) == "string" and Unit.node(target, target_node) or target_node

		link_table[#link_table + 1] = {
			unit = target,
			i = target_node_index,
			parent = Unit.scene_graph_parent(target, target_node_index),
			local_pose = Matrix4x4Box(Unit.local_pose(target, target_node_index))
		}

		World.link_unit(self._world, target, target_node_index, source, source_node_index)

		local rotation = attachment_nodes.rotation

		if rotation then
			Unit.set_local_rotation(target, target_node_index, rotation:unbox())
		end
	end
end

function BaseGear:wielded()
	return self._wielded
end

function BaseGear:dual_wielded()
	return self._dual_wielded
end

function BaseGear:name()
	return self._name
end

function BaseGear:unit()
	return self._unit
end

function BaseGear:start_fire_effect()
	self._fire_effect_id = ScriptWorld.create_particles_linked(self._world, "fx/fire_dot", self._unit, 0, "stop")
end

function BaseGear:end_fire_effect()
	if self._fire_effect_id then
		World.stop_spawning_particles(self._world, self._fire_effect_id)

		self._fire_effect_id = nil
	end
end

function BaseGear:set_sheathed(sheathed, slot_name)
	local unit = self._unit
	local settings = self._settings

	World.unlink_unit(self._world, unit)

	if settings.hide_unwielded and not sheathed then
		self:unhide_gear("sheathed")
	elseif settings.hide_unwielded then
		self:hide_gear("sheathed")
	end

	self:_restore_scene_graph()

	local settings_attachment_node_linking = self._dual_wielded and settings.dual_wield_attachment_node_linking[slot_name] or settings.attachment_node_linking
	local attachment_node_linking = sheathed and settings_attachment_node_linking.unwielded or settings_attachment_node_linking.wielded

	self:_link(attachment_node_linking)

	self._sheathed = sheathed

	if self._extensions and self._extensions.base then
		self._extensions.base:set_sheathed(sheathed)
	end
end

function BaseGear:sheathed()
	return self._sheathed
end

function BaseGear:set_wielded(wielded, slot_name, dual_wielding)
	local unit = self._unit
	local settings = self._settings

	World.unlink_unit(self._world, unit)

	if settings.hide_unwielded and wielded then
		self:unhide_gear("wielded")
	elseif settings.hide_unwielded then
		self:hide_gear("wielded")
	end

	self:_restore_scene_graph()

	local settings_attachment_node_linking = dual_wielding and settings.dual_wield_attachment_node_linking[slot_name] or settings.attachment_node_linking
	local attachment_node_linking = wielded and settings_attachment_node_linking.wielded or settings_attachment_node_linking.unwielded

	self:_link(attachment_node_linking)

	self._wielded = wielded
	self._dual_wielded = dual_wielding

	if self._extensions and self._extensions.base then
		self._extensions.base:set_wielded(wielded)
	end
end

function BaseGear:set_faux_unwielded(unwielded, slot_name)
	local unit = self._unit
	local settings = self._settings

	World.unlink_unit(self._world, unit)

	if settings.hide_unwielded and not unwielded then
		self:unhide_gear("wielded")
	elseif settings.hide_unwielded then
		self:hide_gear("wielded")
	end

	self:_restore_scene_graph()

	local settings_attachment_node_linking = self._dual_wielded and settings.dual_wield_attachment_node_linking[slot_name] or settings.attachment_node_linking
	local attachment_node_linking = unwielded and settings_attachment_node_linking.unwielded or settings_attachment_node_linking.wielded

	self:_link(attachment_node_linking)

	if self._extensions and self._extensions.base and self._extensions.base.set_faux_unwielded then
		self._extensions.base:set_faux_unwielded(unwielded)
	end
end

function BaseGear:_restore_scene_graph()
	if self._scene_graph_links then
		for i, link in ipairs(self._scene_graph_links) do
			if link.parent then
				Unit.scene_graph_link(link.unit, link.i, link.parent)
				Unit.set_local_pose(link.unit, link.i, link.local_pose:unbox())
			end
		end
	end
end

function BaseGear:die()
	local unit = self._unit

	Unit.flow_event(unit, "lua_break")

	local collision_actor_index = Unit.find_actor(unit, "c_weapon_collision")

	if collision_actor_index then
		Unit.destroy_actor(unit, collision_actor_index)
	end

	collision_actor_index = Unit.find_actor(unit, "c_ranged")

	if collision_actor_index then
		Unit.destroy_actor(unit, collision_actor_index)
	end

	collision_actor_index = Unit.find_actor(unit, "c_hit_collision")

	if collision_actor_index then
		Unit.destroy_actor(unit, collision_actor_index)
	end

	self._dead = true
end

function BaseGear:extensions()
	return self._extensions
end

function BaseGear:destroy()
	local unit = self._unit

	World.unlink_unit(self._world, unit)

	if (Managers.lobby.server or not Managers.lobby.lobby) and Managers.state.entity:is_unit_registered(unit) then
		Managers.state.entity:unregister_unit(unit)
	end

	if self._dead then
		Managers.state.broken_gear:register_gear(unit)
	elseif not self._dropped then
		World.destroy_unit(self._world, unit)
	end

	local quiver = self._quiver_data and self._quiver_data.unit

	if Unit.alive(quiver) then
		World.unlink_unit(self._world, quiver)
		World.destroy_unit(self._world, quiver)
	end
end

function BaseGear:enter_ghost_mode()
	self:disable_collisions("ghost_mode")

	local extensions = self._extensions

	for _, extension in pairs(extensions) do
		extension:enter_ghost_mode()
	end
end

local function set_unit_actors_collisions_enabled(unit, enabled)
	local num_actors = Unit.num_actors(unit)

	for i = 0, num_actors - 1 do
		local actor = Unit.actor(unit, i)

		if actor then
			Actor.set_scene_query_enabled(actor, enabled)
		end
	end
end

function BaseGear:disable_collisions(reason)
	local became_disabled = self._physics_disabled_reasons:disable(reason)

	if became_disabled then
		set_unit_actors_collisions_enabled(self._unit, false)
	end
end

function BaseGear:enable_collisions(reason)
	local became_enabled = self._physics_disabled_reasons:enable(reason)

	if became_enabled then
		set_unit_actors_collisions_enabled(self._unit, true)
	end
end

function BaseGear:set_kinematic(kinematic, slot_name)
	local unit = self._unit
	local actor_index = Unit.find_actor(unit, "dropped")

	if actor_index then
		if kinematic and self._dropped then
			self._dropped = false

			local settings = self._settings
			local settings_attachment_node_linking = self._dual_wielded and settings.dual_wield_attachment_node_linking[slot_name] or settings.attachment_node_linking
			local attachment_node_linking = self._wielded and settings_attachment_node_linking.wielded or settings_attachment_node_linking.unwielded

			Unit.destroy_actor(unit, actor_index)
			self:_link(attachment_node_linking)

			if Unit.has_node(unit, "dropped") then
				Unit.set_local_pose(unit, Unit.node(unit, "dropped"), self._dropped_local_pose:unbox())
			end
		elseif not kinematic and not self._dropped then
			self._dropped = true

			if Unit.has_node(unit, "dropped") then
				self._dropped_local_pose = Matrix4x4Box(Unit.local_pose(unit, Unit.node(unit, "dropped")))
			end

			self:_restore_scene_graph()
			World.unlink_unit(self._world, unit)
			Unit.create_actor(unit, actor_index, 0)
		end
	end
end

function BaseGear:exit_ghost_mode()
	self:enable_collisions("ghost_mode")

	local extensions = self._extensions

	for _, extension in pairs(extensions) do
		extension:exit_ghost_mode()
	end
end

function BaseGear:hide_gear(reason)
	local became_hidden = self._hide_reasons:disable(reason)

	if became_hidden then
		Unit.set_visibility(self._unit, "unbroken", false)
	end
end

function BaseGear:hide_quiver(reason)
	local quiver_data = self._quiver_data

	if not quiver_data then
		return
	end

	local became_hidden = quiver_data.disable_reasons:disable(reason)

	if became_hidden then
		Unit.set_unit_visibility(quiver_data.unit, false)
	end
end

function BaseGear:unhide_quiver(reason)
	local quiver_data = self._quiver_data

	if not quiver_data then
		return
	end

	local became_unhidden = quiver_data.disable_reasons:enable(reason)

	if became_unhidden then
		Unit.set_unit_visibility(quiver_data.unit, true)
	end
end

function BaseGear:unhide_gear(reason)
	local became_unhidden = self._hide_reasons:enable(reason)

	if became_unhidden then
		Unit.set_visibility(self._unit, "unbroken", true)
	end
end

function BaseGear:trigger_timpani_event(event_config, user_has_assassin_perk)
	local timpani_world = World.timpani_world(self._world)
	local gear_settings = Gear[self._name]
	local config = gear_settings.timpani_events[event_config]

	fassert(config, "[BaseGear] Timpani event config %q missing for gear %s", event_config, self._name)

	local event_id = TimpaniWorld.trigger_event(timpani_world, config.event, Unit.world_position(self._unit, 0))

	if event_id then
		TimpaniWorld.set_parameter(timpani_world, event_id, "assasin", user_has_assassin_perk and "activated" or "not_activated")

		if config.parameters then
			for _, param in ipairs(config.parameters) do
				TimpaniWorld.set_parameter(timpani_world, event_id, param.name, param.value)
			end
		end
	elseif not event_id then
		print("[BaseGear:trigger_timpani_event] missing sound event for event_config:", event_config)
	end
end

function BaseGear:set_coat_of_arms(settings, team_name)
	if Gear[self._name].show_coat_of_arms and Unit.alive(self._unit) then
		CoatOfArmsHelper:set_material_properties(settings, self._unit, "g_heraldry_projector", "heraldry_projector", team_name)
		CoatOfArmsHelper:set_material_properties(settings, self._unit, "g_broken_heraldry_projector", "broken_heraldry_projector", team_name)
	end
end
