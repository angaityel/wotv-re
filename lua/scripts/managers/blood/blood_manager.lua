-- chunkname: @scripts/managers/blood/blood_manager.lua

require("scripts/settings/blood_settings")

BloodManager = class(BloodManager)

local BLOOD_DEBUG = false
local WOUND_DEBUG = false
local FIGHING_BLOOD_DEBUG = false

function BloodManager:init(world)
	self._world = world
	self._blood_splatter = {}
	self._impact_directions = {}
	self._line_object = World.create_line_object(self._world)
	self._blood_splatter_units = {
		"units/decals/decal_blood_01",
		"units/decals/decal_blood_02",
		"units/decals/decal_blood_03",
		"units/decals/decal_blood_04",
		"units/decals/decal_blood_05",
		"units/decals/decal_blood_06",
		"units/decals/decal_blood_07",
		"units/decals/decal_blood_08",
		"units/decals/decal_blood_09"
	}
	self._direction_blood_splatter_units = {
		"units/decals/decal_blood_10",
		"units/decals/decal_blood_11",
		"units/decals/decal_blood_12"
	}
	self._blood_pool_units = {
		"units/decals/decal_blood_pool_01",
		"units/decals/decal_blood_pool_02"
	}
	self._units_to_spawn = {}
	self._pools_to_spawn = {}

	Managers.state.event:register(self, "event_blood_collision", "event_blood_collision")
	Managers.state.event:register(self, "spawn_blood_ball", "event_spawn_blood_ball")
	Managers.state.event:register(self, "fighting_blood", "event_fighting_blood")
	Managers.state.event:register(self, "add_wound", "event_add_wound")
	Managers.state.event:register(self, "finish_off_blood", "event_finish_off_blood")
end

function BloodManager:add_player(player)
	self._player = player
end

function BloodManager:event_finish_off_blood(unit)
	if Application.user_setting("hide_blood") or not self._player or not Unit.alive(unit) or not BloodSettings.finish_off_blood.enabled or table.size(self._blood_splatter) > BloodSettings.max_num_decals then
		return
	end

	local position = Unit.local_position(unit, 0)
	local rotation = Unit.local_rotation(unit, 0)

	self._pools_to_spawn[#self._pools_to_spawn + 1] = {
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation)
	}
end

function BloodManager:event_add_wound(hit_unit, actor)
	if not BloodSettings.wounds.enabled or Application.user_setting("hide_blood") then
		return
	end

	local blood_zones = Unit.get_data(hit_unit, "blood_zones_lookup_table") or {}
	local new_wound_bit_value = blood_zones[actor]
	local player = Managers.player:owner(hit_unit)

	if WOUND_DEBUG then
		Unit.set_data(hit_unit, "wound_settings", 0)
	end

	if new_wound_bit_value then
		local current_wounds_bit_value = Unit.get_data(hit_unit, "wound_settings")
		local new_wound_settings = bit.bor(current_wounds_bit_value, new_wound_bit_value)
		local inventory = ScriptUnit.extension(player.player_unit, "locomotion_system"):inventory()
		local unit = inventory:armour_unit()
		local num_meshes = Unit.num_meshes(unit)

		for i = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, i)
			local num_materials = Mesh.num_materials(mesh)

			for j = 0, num_materials - 1 do
				local material = Mesh.material(mesh, j)

				Material.set_scalar(material, "blood_mask", new_wound_settings)
			end
		end

		Unit.set_data(hit_unit, "wound_settings", new_wound_settings)
	end
end

function BloodManager:event_fighting_blood(player, event)
	if not BloodSettings.fighting_blood.enabled or Application.user_setting("hide_blood") then
		return
	end

	do
		local blood_level = Unit.get_data(player.player_unit, "blood_level") or 0

		blood_level = math.clamp(blood_level + (BloodSettings.fighting_blood[event] or 0), 0, BloodSettings.fighting_blood.threshold_hack)

		if FIGHING_BLOOD_DEBUG then
			blood_level = 0
		end

		local inventory = ScriptUnit.extension(player.player_unit, "locomotion_system"):inventory()
		local unit = inventory:armour_unit()

		self:_apply_fighting_blood(unit, blood_level)
		Unit.set_data(player.player_unit, "blood_level", blood_level)
	end

	if BloodSettings.fighting_blood.weapon_blood.enabled then
		local inventory = ScriptUnit.extension(player.player_unit, "locomotion_system"):inventory()
		local wielded_slots = inventory:wielded_slots()

		for _, slot_data in pairs(wielded_slots) do
			local unit = slot_data.gear._unit
			local blood_level = Unit.get_data(unit, "blood_level") or 0

			blood_level = math.clamp(blood_level + (BloodSettings.fighting_blood.weapon_blood[event] or 0), 0, BloodSettings.fighting_blood.weapon_blood.weapon_threshold_hack)

			if FIGHING_BLOOD_DEBUG then
				blood_level = 0
			end

			self:_apply_fighting_blood(unit, blood_level)
			Unit.set_data(unit, "blood_level", blood_level)
		end
	end
end

function BloodManager:_apply_fighting_blood(unit, blood_level)
	local num_meshes = Unit.num_meshes(unit)

	for i = 0, num_meshes - 1 do
		local mesh = Unit.mesh(unit, i)
		local num_materials = Mesh.num_materials(mesh)

		for j = 0, num_materials - 1 do
			local material = Mesh.material(mesh, j)

			Material.set_scalar(material, "fight_blood_intensity", blood_level)
		end
	end
end

function BloodManager:event_spawn_blood_ball(position, impact_direction, hit_player)
	if not BloodSettings.environment_blood.enabled or Application.user_setting("hide_blood") then
		return
	end

	if not self._player or not Unit.alive(self._player.player_unit) or table.size(self._blood_splatter) > BloodSettings.max_num_decals or not hit_player.local_player and Vector3.length(position - Unit.local_position(self._player.player_unit, 0)) > BloodSettings.environment_blood.distance_spawn_threshold then
		return
	end

	local blood_unit = World.spawn_unit(self._world, "units/decals/blood_ball", position)
	local actor = Unit.actor(blood_unit, "blood_ball")

	Actor.set_velocity(actor, impact_direction * BloodSettings.environment_blood.blood_speed_multiplier)

	self._impact_directions[blood_unit] = Vector3Box(impact_direction * BloodSettings.environment_blood.blood_speed_multiplier)
end

function BloodManager:event_blood_collision(unit, position, normal, physx_unit, velocity)
	self._units_to_spawn[#self._units_to_spawn + 1] = {
		unit = unit,
		position = Vector3Box(position),
		normal = Vector3Box(normal),
		velocity = Vector3Box(velocity),
		impact_velocity = self._impact_directions[physx_unit] or Vector3Box(velocity)
	}
	self._impact_directions[physx_unit] = nil

	World.destroy_unit(self._world, physx_unit)
end

function BloodManager:update(dt, t)
	Profiler.start("Blood Manager")
	self:_update_splatter(dt, t)

	for _, data in pairs(self._units_to_spawn) do
		self:_spawn_splatter(data, t)
	end

	for _, data in pairs(self._pools_to_spawn) do
		self:_spawn_blood_pool(data, t)
	end

	self._units_to_spawn = {}
	self._pools_to_spawn = {}

	Profiler.stop()
end

function BloodManager:_spawn_splatter(data, t)
	local position = data.position:unbox()
	local normal = data.normal:unbox()
	local blood_velocity = data.velocity:unbox()
	local velocity = data.impact_velocity:unbox()
	local dot_value = Vector3.dot(normal, Vector3.normalize(velocity))
	local tangent = Vector3.normalize(Vector3.normalize(velocity) - dot_value * normal)
	local tangent_rotation = Quaternion.look(tangent, normal)
	local vel_rot, unit_name

	if Vector3.dot(normal, Vector3.normalize(blood_velocity)) < BloodSettings.environment_blood.angular_threshold then
		local texture_rotation = Quaternion(Vector3(0, 0, 1), math.degrees_to_radians(90))

		vel_rot = Quaternion.multiply(tangent_rotation, texture_rotation)
		unit_name = self._direction_blood_splatter_units[Math.random(1, #self._direction_blood_splatter_units)]
	else
		vel_rot = tangent_rotation
		unit_name = self._blood_splatter_units[Math.random(1, #self._blood_splatter_units)]
	end

	if BLOOD_DEBUG then
		self:_remove_all_blood()
	end

	local blood_unit = World.spawn_unit(self._world, unit_name, position, vel_rot)
	local mesh = Unit.mesh(blood_unit, "g_projector")
	local material = Mesh.material(mesh, "mtr_projector")

	Material.set_scalar(material, "start_time", t)
	Material.set_scalar(material, "life_time", BloodSettings.environment_blood.life_time)
	Material.set_vector3(material, "up_vector", normal)

	self._blood_splatter[blood_unit] = {
		type = "environment_blood",
		unit = blood_unit,
		life_time = BloodSettings.environment_blood.life_time,
		start_time = t
	}

	if BLOOD_DEBUG then
		LineObject.reset(self._line_object)

		local pose = Unit.local_pose(blood_unit, 0)

		LineObject.add_line(self._line_object, Color(255, 0, 0), position + normal * 0.5, position + normal * 0.5 + Vector3.flat(Vector3.normalize(velocity)))

		if tangent then
			LineObject.add_line(self._line_object, Color(255, 0, 255), position + normal, position + normal + tangent * 2)
		end

		LineObject.add_sphere(self._line_object, Color(0, 255, 0), position + normal * 0.5 + Vector3.flat(Vector3.normalize(velocity)), 0.1)
		LineObject.add_box(self._line_object, Color(0, 255, 0), pose, Vector3(0.5, 0.5, 0.5))
		LineObject.add_line(self._line_object, Color(255, 255, 0), position, position + normal)
		LineObject.dispatch(self._world, self._line_object)
	end
end

function BloodManager:_spawn_blood_pool(data, t)
	local position = data.position:unbox()
	local rotation = data.rotation:unbox()
	local unit_name = self._blood_pool_units[Math.random(1, #self._blood_pool_units)]
	local blood_unit = World.spawn_unit(self._world, unit_name, position, rotation)
	local mesh = Unit.mesh(blood_unit, "g_projector")
	local material = Mesh.material(mesh, "mtr_projector")

	Material.set_scalar(material, "start_time", t)
	Material.set_scalar(material, "life_time", BloodSettings.finish_off_blood.life_time)
	Material.set_vector3(material, "up_vector", Quaternion.up(rotation))

	self._blood_splatter[blood_unit] = {
		type = "finish_off_blood",
		unit = blood_unit,
		life_time = BloodSettings.finish_off_blood.life_time,
		start_time = t
	}
end

function BloodManager:_remove_all_blood()
	for idx, blood in pairs(self._blood_splatter) do
		if Unit.alive(blood.unit) then
			World.destroy_unit(self._world, blood.unit)
		end
	end

	self._blood_splatter = {}
end

function BloodManager:_update_splatter(dt, t)
	local player_pos = Vector3(0, 0, 0)

	if self._player and Unit.alive(self._player.player_unit) then
		player_pos = Unit.local_position(self._player.player_unit, 0)
	end

	local to_remove = {}

	for blood_unit, blood in pairs(self._blood_splatter) do
		if t > blood.start_time + blood.life_time then
			to_remove[#to_remove + 1] = blood_unit
		end

		if not blood.fading and Vector3.length(Unit.local_position(blood_unit, 0) - player_pos) > BloodSettings[blood.type].distance_fade_threshold then
			blood.start_time = t
			blood.life_time = 2
			blood.fading = true

			local mesh = Unit.mesh(blood_unit, "g_projector")
			local material = Mesh.material(mesh, "mtr_projector")

			Material.set_scalar(material, "start_time", blood.start_time)
			Material.set_scalar(material, "life_time", blood.life_time)
		end

		local scale = (t - blood.start_time) / blood.life_time
		local scale_val = BloodSettings[blood.type].dynamic_scale
		local base_val = BloodSettings[blood.type].base_scale

		Unit.set_local_scale(blood.unit, 0, Vector3(base_val + scale * scale_val, base_val + scale * scale_val, 1))
	end

	for i = 1, #to_remove do
		local blood_unit = self._blood_splatter[to_remove[i]].unit

		if Unit.alive(blood_unit) then
			World.destroy_unit(self._world, blood_unit)
		end

		self._blood_splatter[to_remove[i]] = nil
	end
end
