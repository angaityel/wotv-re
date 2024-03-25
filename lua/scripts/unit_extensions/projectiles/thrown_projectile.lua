-- chunkname: @scripts/unit_extensions/projectiles/thrown_projectile.lua

require("scripts/helpers/weapon_helper")

ThrownProjectile = class(ThrownProjectile)
ThrownProjectile.SYSTEM = "projectile_system"

function ThrownProjectile:init(world, unit, owning_player_index, exit_velocity, gear_name, user_unit, is_husk)
	self._world = world
	self._unit = unit
	self._user_unit = user_unit
	self._gear_name = gear_name

	assert(gear_name, "Missing gear name!")
	Unit.set_data(unit, "gear_name", gear_name)

	self._scene_graph_data = ScriptUnit.save_scene_graph(unit)

	local actor_index = Unit.find_actor(unit, "thrown")
	local actor = Unit.create_actor(unit, actor_index, 0)

	self._physical_actor = actor

	Actor.set_velocity(actor, exit_velocity)

	actor_index = Unit.find_actor(unit, "c_weapon_collision")

	if actor_index then
		Unit.destroy_actor(unit, actor_index)
	end

	local settings = Gear[gear_name]

	self._attack_name = "throw"

	local throw_settings = settings.attacks[self._attack_name]

	self._settings = settings
	self._throw_settings = throw_settings
	self._tip_node = Unit.node(unit, throw_settings.tip_node)
	self._foot_node = Unit.node(unit, throw_settings.foot_node)

	local link_node = self._throw_settings.link_node

	if link_node then
		self._link_node = Unit.node(self._unit, link_node)
	end

	if throw_settings.spin_velocity then
		local tip_pos = Unit.world_position(unit, self._tip_node)
		local foot_pos = Unit.world_position(unit, self._foot_node)
		local dir = Vector3.normalize(exit_velocity)

		Actor.add_impulse_at(actor, -throw_settings.spin_velocity * dir, tip_pos)
		Actor.add_impulse_at(actor, throw_settings.spin_velocity * dir, foot_pos)
		Actor.set_angular_damping(actor, 0)
	end

	local inner_node_pos = Unit.world_position(unit, Unit.node(unit, throw_settings.sweep.inner_node))
	local outer_node_pos = Unit.world_position(unit, Unit.node(unit, throw_settings.sweep.outer_node))

	self._old_pos = Vector3Box((inner_node_pos + outer_node_pos) * 0.5)
	self._sweep_height = math.abs(Vector3.dot(inner_node_pos - outer_node_pos, Quaternion.up(Unit.world_rotation(unit, 0))))

	if Managers.player:player_exists(owning_player_index) then
		Managers.player:assign_unit_ownership(unit, owning_player_index)
	end

	self._owner_id = owning_player_index
	self._is_husk = is_husk

	local network_manager = Managers.state.network

	if not is_husk and network_manager:game() then
		network_manager:create_thrown_projectile_game_object(unit, gear_name, exit_velocity, user_unit, owning_player_index)
	end

	self._bounced = false
	self._time = 0

	self:_spawn_trail()
end

function ThrownProjectile:_spawn_trail()
	local unit = self._unit
	local owner = Managers.player:owner(unit)
	local particle
	local position_offset = Vector3(0, 0, 0)
	local settings = self._throw_settings
	local particles = owner and not owner.remote and settings.local_particles or settings.remote_particles
	local trails = {
		sleeping = {},
		bounced = {},
		other = {}
	}

	if particles then
		for _, particle in ipairs(particles) do
			local node = type(particle.node) == "number" and particle.node or Unit.node(unit, particle.node)
			local rotation_offset = Quaternion.look(particle.forward_direction:unbox(), Vector3.up())
			local id = ScriptWorld.create_particles_linked(self._world, particle.particle_name, unit, node, "stop", Matrix4x4.from_quaternion_position(rotation_offset, position_offset))

			trails[particle.kill or "other"][id] = particle.fade_kill
		end
	end

	self._particle_trails = trails
end

function ThrownProjectile:_update_drag(dt)
	local actor = self._physical_actor
	local rotation = Actor.rotation(actor)
	local velocity = Actor.velocity(actor)
	local velocity_rotation = Quaternion.look(Vector3.normalize(velocity), Vector3.up())
	local diff_quaternion = Quaternion.multiply(Quaternion.inverse(velocity_rotation), rotation)
	local axis, angle = Quaternion.decompose(diff_quaternion)
	local unit = self._unit
	local tip_pos = Unit.world_position(unit, self._tip_node)
	local foot_pos = Unit.world_position(unit, self._foot_node)
	local center_of_mass = Actor.center_of_mass(actor)
	local tip_length = Vector3.length(tip_pos - center_of_mass)
	local foot_length = Vector3.length(foot_pos - center_of_mass)
	local length_vector = tip_pos - foot_pos
	local DRAG_CONSTANT = 0.26
	local speed = Vector3.length(velocity)
	local force = DRAG_CONSTANT * speed * -velocity

	Actor.add_impulse_at(actor, force * dt, 0.25 * tip_pos + 0.75 * foot_pos)
end

function ThrownProjectile:flow_cb_bounce(hit_unit, actor, position, normal)
	if not self._bounced and not self._disabled then
		local unit = self._unit
		local target_type = "prop"
		local throw_settings = self._throw_settings
		local sweep_settings = throw_settings.sweep
		local inner_node_pos = Unit.world_position(unit, Unit.node(unit, sweep_settings.inner_node))
		local outer_node_pos = Unit.world_position(unit, Unit.node(unit, sweep_settings.outer_node))
		local new_pos = (inner_node_pos + outer_node_pos) * 0.5
		local from = self._old_pos:unbox()
		local to = new_pos
		local impact_direction = Vector3.normalize(to - from)
		local rotation = Quaternion.look(impact_direction, Vector3.up())
		local can_link = self:_can_link_to_hit_prop(hit_unit, position, rotation)
		local actorbox = ActorBox(actor)
		local actor_alive = true
		local hit_zones = Unit.get_data(hit_unit, "hit_zone_lookup_table")
		local hit_zone = hit_zones and hit_zones[actor] and hit_zones[actor].name
		local owner = Managers.player:owner(unit)

		if Unit.has_data(hit_unit, "archery_target") and owner then
			ScriptUnit.extension(hit_unit, "objective_system"):projectile_impact(owner, actor, position, normal)

			actor_alive = actorbox:unbox() ~= nil
		elseif not self._sent_tutorial_miss_event then
			self:_send_tutorial_miss_event()
		end

		if actor_alive and Unit.has_data(hit_unit, "health") and (not Managers.lobby.lobby or Managers.lobby.server) then
			target_type = "prop"
			can_link = self:_can_link_to_hit_prop(hit_unit, position, Quaternion.look(impact_direction, Vector3.up()))

			local weapon_velocity = Actor.velocity(self._physical_actor)
			local damage_type = throw_settings.damage_type
			local weapon_speed_max = throw_settings.speed_max
			local damage_range_type = throw_settings.damage_range_type
			local victim_velocity = WeaponHelper:locomotion_velocity(hit_unit)
			local damage, penetrated = WeaponHelper:calculate_thrown_projectile_damage(throw_settings, throw_settings.damage, damage_type, weapon_speed_max, weapon_velocity, victim_velocity, hit_unit, actor, position, normal, impact_direction, self._bounced)

			if penetrated then
				local hit_zone = hit_zones and hit_zones[actor] and hit_zones[actor].name
				local gear_name = self._gear_name
				local range = 0

				WeaponHelper:add_damage(self._world, hit_unit, owner, self._user_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, self._attack_name, hit_zone, impact_direction, nil, true, range)

				actor_alive = actorbox:unbox() ~= nil
			end
		end

		if can_link then
			if not self._is_husk and actor_alive then
				local weapon_velocity = Actor.velocity(self._physical_actor)
				local damage = 0

				self:_link(hit_unit, actor, position, weapon_velocity, damage, hit_zone, target_type, impact_direction, normal, true)
			end
		else
			local player_index = Managers.state.network:temp_player_index(self._owner_id)
			local player = Managers.player:player_exists(player_index) and Managers.player:player(player_index) or nil
			local husk = not player or player.remote

			WeaponHelper:projectile_impact(self._world, hit_unit, unit, player, position, rotation, 0, false, target_type, hit_zone, impact_direction, normal, false, self._throw_settings.sound_gear_type or self._settings.sound_gear_type, husk)

			self._bounced = true

			self:_kill_particles("bounced")
		end
	end
end

function ThrownProjectile:_can_link_to_hit_prop(hit_unit, position, rotation)
	local query_forward = Quaternion.forward(rotation)
	local query_vector = query_forward * MaterialEffectSettings.material_query_depth
	local query_start_position = position - query_vector
	local query_end_position = position + query_vector
	local material_ids = EffectHelper.query_material_surface(hit_unit, position, rotation)

	if script_data.thrown_weapon_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "thrown weapon drawer"
		})

		drawer:vector(query_start_position, query_end_position - query_start_position, Color(255, 0, 0))
	end

	local material

	if not material_ids or not material_ids[1] then
		material = DefaultSurfaceMaterial
	else
		material = MaterialIDToName.surface_material[material_ids[1]]
	end

	return MaterialThrowingWeaponLinkSettings[material] and MaterialThrowingWeaponLinkSettings[material] or false
end

function ThrownProjectile:_disable(reason)
	self._disabled = true

	if not self._bounced then
		self:_kill_particles("bounced")
	end

	self:_kill_particles("sleeping")

	if self._physical_actor then
		Actor.put_to_sleep(self._physical_actor)
	end

	if not self._is_husk then
		Managers.state.projectile:thrown_projectile_disabled(self._unit, reason)
	end
end

local DISABLE_THRESHOLD = 0.005

function ThrownProjectile:debug_draw_objects()
	if script_data.debug_draw_objects then
		local drawer = Managers.state.debug:drawer({
			mode = "immediate",
			name = "weapon_immediate"
		})
		local unit = self._unit

		for _, object in ipairs(script_data.debug_draw_objects) do
			if Unit.has_node(unit, object) then
				local node = Unit.node(unit, object)

				drawer:quaternion(Unit.world_position(unit, node), Unit.world_rotation(unit, node))
			end
		end
	end
end

function ThrownProjectile:update(unit, input, dt, context)
	self._time = self._time + dt

	self:debug_draw_objects()

	if not self._disabled and not self._throw_settings.spin_velocity then
		self:_update_drag(dt)
	end

	if not self._disabled and Vector3.length(Actor.velocity(self._physical_actor)) < DISABLE_THRESHOLD then
		self:_disable("stopped")
	end

	if self._disabled or self._is_husk then
		return
	end

	if self._time > 2 and not self._sent_tutorial_miss_event then
		self:_send_tutorial_miss_event()
	end

	local throw_settings = self._throw_settings
	local sweep_settings = throw_settings.sweep
	local inner_node_pos = Unit.world_position(unit, Unit.node(unit, sweep_settings.inner_node))
	local outer_node_pos = Unit.world_position(unit, Unit.node(unit, sweep_settings.outer_node))
	local new_pos = (inner_node_pos + outer_node_pos) * 0.5
	local from = self._old_pos:unbox()
	local to = new_pos
	local sweep_extents = Vector3(sweep_settings.width, sweep_settings.thickness, self._sweep_height) * 0.5
	local rotation = Quaternion.look(from - to, Vector3.up())
	local physics_world = World.physics_world(self._world)
	local hits = PhysicsWorld.linear_obb_sweep(physics_world, from, to, sweep_extents, rotation, 10, "types", "both", "collision_filter", "ray_projectile")

	if hits then
		self:_resolve_hits(hits, Vector3.normalize(to - from))
	end

	if script_data.weapon_collision_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})

		drawer:quaternion(Unit.world_position(unit, self._link_node or 0), Unit.world_rotation(unit, self._link_node or 0), 0.3)
		drawer:box_sweep(Matrix4x4.from_quaternion_position(rotation, from), sweep_extents, to - from)
	end

	self._old_pos:store(new_pos)
end

function ThrownProjectile:_resolve_hits(hits, impact_direction)
	local throw_settings = self._throw_settings
	local unit = self._unit
	local damage_type = throw_settings.damage_type
	local damage = throw_settings.damage
	local damage_range_type = throw_settings.damage_range_type
	local weapon_speed_max = throw_settings.speed_max
	local weapon_rotation = Unit.world_rotation(unit, 0)
	local player_manager = Managers.player
	local player_index = self._owner_id
	local player = player_manager:player_exists(player_index) and player_manager:player(player_index)

	for _, hit in ipairs(hits) do
		if script_data.weapon_collision_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon"
			})

			drawer:sphere(hit.position, 0.01, Color(255, 255, 0))
		end

		local actor = hit.actor
		local hit_unit = Actor.unit(actor)

		hit_unit, actor = WeaponHelper:helmet_hack(hit_unit, actor)

		if hit_unit == self._user_unit and not self._bounced then
			return
		end

		local hit_zones = Unit.get_data(hit_unit, "hit_zone_lookup_table")
		local locomotion_unit
		local has_hit = false
		local can_link = true
		local target_type

		if ScriptUnit.has_extension(hit_unit, "locomotion_system") then
			local game_mode = Managers.state.game_mode:game_mode_key()
			local hit_zone = hit_zones and hit_zones[actor] and hit_zones[actor].name
			local allow_hit = false

			if game_mode == "headhunter" then
				if hit_zone == "head" or hit_zone == "helmet" then
					allow_hit = true
				end
			else
				allow_hit = true
			end

			if allow_hit then
				locomotion_unit = hit_unit
				has_hit = true
				target_type = "character"
			end
		elseif Unit.has_data(hit_unit, "gear_name") then
			local gear_user = Unit.get_data(hit_unit, "user_unit")

			if Unit.alive(gear_user) then
				has_hit = true
				locomotion_unit = gear_user

				local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

				if gear_user_locomotion.blocking and gear_user_locomotion.block_unit == hit_unit then
					target_type = "blocking_gear"
				else
					target_type = "gear"
				end
			end
		elseif Unit.has_data(hit_unit, "health") then
			has_hit = true
			locomotion_unit = hit_unit
			target_type = "prop"
			can_link = self:_can_link_to_hit_prop(hit_unit, hit.position, Quaternion.look(impact_direction, Vector3.up()))
		end

		if has_hit then
			local position = hit.position
			local normal = hit.normal
			local weapon_velocity = Actor.velocity(self._physical_actor)
			local victim_velocity = WeaponHelper:locomotion_velocity(locomotion_unit)
			local damage, penetrated = WeaponHelper:calculate_thrown_projectile_damage(throw_settings, damage, damage_type, weapon_speed_max, weapon_velocity, victim_velocity, hit_unit, actor, position, normal, impact_direction, self._bounced)
			local hit_zone = hit_zones and hit_zones[actor] and hit_zones[actor].name
			local gear_name = self._gear_name
			local range = 0
			local network_manager = Managers.state.network

			if target_type == "gear" or target_type == "blocking_gear" then
				self:_link(hit_unit, actor, position, weapon_velocity, damage, hit_zone, target_type, impact_direction, normal, false)

				local damage_ext = ScriptUnit.has_extension(hit_unit, "damage_system") and ScriptUnit.extension(hit_unit, "damage_system")
				local locomotion_ext = ScriptUnit.has_extension(locomotion_unit, "locomotion_system") and ScriptUnit.extension(locomotion_unit, "locomotion_system")

				if throw_settings.shield_breaker and damage_ext then
					if locomotion_ext and not locomotion_ext:has_perk("shield_maiden02") and damage_ext:is_alive() then
						damage_ext:die()
					elseif locomotion_ext:has_perk("shield_maiden02") and network_manager:game() then
						RPC.rpc_show_perk_combat_text(player:network_id(), player:player_id(), NetworkLookup.perks.shield_maiden02, position)
					end
				end

				if network_manager:game() then
					RPC.rpc_show_shield_damage_number(player:network_id(), player_index, NetworkLookup.damage_types[damage_type], damage, position, NetworkLookup.damage_range_types[damage_range_type])
				end

				return true
			elseif penetrated then
				WeaponHelper:add_damage(self._world, hit_unit, player, self._user_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, self._attack_name, hit_zone, impact_direction, nil, true, range)

				if can_link then
					self:_link(hit_unit, actor, position, weapon_velocity, damage, hit_zone, target_type, impact_direction, normal, false)
				end

				return true
			end
		end
	end

	return false
end

function ThrownProjectile:_link(hit_unit, actor, position, velocity, damage, hit_zone, target_type, impact_direction, normal, lootable)
	local actor_node = Actor.node(actor)
	local hit_node_rot = Unit.world_rotation(hit_unit, actor_node)
	local hit_node_pos = Unit.world_position(hit_unit, actor_node)
	local projectile_rot = Unit.local_rotation(self._unit, 0)
	local local_pos, local_rot
	local link_node = self._link_node
	local penetration_depth = self._throw_settings.penetration_depth or 0.15

	if link_node then
		local projectile_pos = position + Vector3.normalize(velocity) * penetration_depth
		local rel_pos = projectile_pos - hit_node_pos
		local impact_rotation = Quaternion.look(impact_direction, Vector3.up())
		local impact_dir_forward = Quaternion.forward(impact_rotation)
		local impact_dir_up = Quaternion.up(impact_rotation)
		local old_normal

		if Vector3.dot(normal, impact_dir_forward) > 0 then
			old_normal = normal
			normal = -normal
		end

		local transformed_normal = Vector3.normalize(impact_dir_forward * Vector3.dot(normal, impact_dir_forward) + impact_dir_up * Vector3.dot(normal, impact_dir_up))
		local projectile_rot = Quaternion.look(-transformed_normal, Vector3.up())

		local_pos = Vector3(Vector3.dot(Quaternion.right(hit_node_rot), rel_pos), Vector3.dot(Quaternion.forward(hit_node_rot), rel_pos), Vector3.dot(Quaternion.up(hit_node_rot), rel_pos))
		local_rot = Quaternion.multiply(Quaternion.inverse(hit_node_rot), projectile_rot)
	else
		local projectile_pos = position + Vector3.normalize(velocity) * penetration_depth
		local rel_pos = projectile_pos - hit_node_pos

		local_pos = Vector3(Vector3.dot(Quaternion.right(hit_node_rot), rel_pos), Vector3.dot(Quaternion.forward(hit_node_rot), rel_pos), Vector3.dot(Quaternion.up(hit_node_rot), rel_pos))
		local_rot = Quaternion.multiply(Quaternion.inverse(hit_node_rot), projectile_rot)
	end

	Managers.state.projectile:link_thrown_projectile(hit_unit, actor_node, local_pos, local_rot, damage, true, target_type, self._unit, hit_zone, impact_direction, normal, lootable)
end

function ThrownProjectile:link_projectile(hit_unit, actor_node, local_pos, local_rot, damage, penetrated, target_type, hit_zone, impact_direction, normal)
	local unit = self._unit

	ScriptUnit.restore_scene_graph(self._unit, self._scene_graph_data)

	local node = self._link_node or 0

	Unit.destroy_actor(unit, "thrown")
	World.link_unit(self._world, unit, node, hit_unit, actor_node)

	local parent_scale = Unit.local_scale(hit_unit, 0)
	local new_scale = Vector3(1 / parent_scale.x, 1 / parent_scale.y, 1 / parent_scale.z)

	Unit.set_local_scale(unit, 0, new_scale)

	local scaled_local_pos = Vector3(1 / parent_scale.x * local_pos.x, 1 / parent_scale.y * local_pos.y, 1 / parent_scale.z * local_pos.z)

	Unit.set_local_position(unit, node, scaled_local_pos)
	Unit.set_local_rotation(unit, node, local_rot)
	World.update_unit(self._world, unit)

	self._physical_actor = nil

	Unit.flow_event(unit, "lua_projectile_linked")

	local position = Unit.world_position(unit, node)
	local rotation = Unit.world_rotation(unit, node)
	local player_index = Managers.state.network:temp_player_index(self._owner_id)
	local player = Managers.player:player(player_index)
	local stun = self:_stun(player, hit_unit)
	local husk = player.remote

	WeaponHelper:projectile_impact(self._world, hit_unit, unit, player, position, rotation, damage, penetrated, target_type, hit_zone, impact_direction, normal, stun, self._throw_settings.sound_gear_type or self._settings.sound_gear_type, husk)
end

function ThrownProjectile:_stun(own_player, hit_unit)
	local hit_unit_owner = Managers.player:owner(hit_unit)
	local properties = self._settings.properties

	if own_player and hit_unit_owner and hit_unit_owner.team ~= own_player.team and properties and (properties.stun or table.contains(properties, "stun")) then
		return true
	else
		return false
	end
end

function ThrownProjectile:destroy()
	local unit = self._unit

	if Managers.player:owner(unit) then
		Managers.player:relinquish_unit_ownership(unit)
	end

	local network_manager = Managers.state.network
	local game = network_manager:game()
	local id = network_manager:game_object_id(unit)

	if not self._is_husk and game and id then
		GameSession.set_game_object_field(game, id, "extension_destroyed", true)
	end

	self:_kill_particles()
end

function ThrownProjectile:_kill_particles(reason)
	if reason then
		local particle_table = self._particle_trails[reason]

		for id, fade_kill in pairs(particle_table) do
			self:_kill_particle(particle_table, id, fade_kill)
		end
	else
		for reason, particle_table in pairs(self._particle_trails) do
			for id, fade_kill in pairs(particle_table) do
				self:_kill_particle(particle_table, id, fade_kill)
			end
		end
	end
end

function ThrownProjectile:_kill_particle(particle_table, id, fade_kill)
	if fade_kill then
		World.stop_spawning_particles(self._world, id)
	else
		World.destroy_particles(self._world, id)
	end

	particle_table[id] = nil
end

function ThrownProjectile:_send_tutorial_miss_event()
	LevelHelper:flow_event(self._world, "projectile_missed_target")

	self._sent_tutorial_miss_event = true
end
