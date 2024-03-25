-- chunkname: @scripts/unit_extensions/weapons/weapon_melee.lua

require("scripts/helpers/weapon_helper")
require("scripts/settings/squad_settings")

WeaponMelee = class(WeaponMelee)
SWEEP_DISTANCE_EPSILON = 0.001

function WeaponMelee:init(world, unit, user_unit, player, id, user_locomotion)
	local settings = Unit.get_data(unit, "settings")

	self._world = world
	self._unit = unit
	self._user_unit = user_unit
	self._player = player
	self._game_object_id = id
	self._user_locomotion = user_locomotion
	self._settings = settings
	self._attacks = Unit.get_data(unit, "attacks")
	self._current_attack = nil
	self._attacking = false
	self._ai_gear = false
	self._properties = {}

	Unit.set_data(unit, "extension", self)

	self._weapon_category = "melee"
	self._collision_actors = {
		Unit.actor(unit, "hit_collision"),
		Unit.actor(unit, "non_damage_hit_collision")
	}

	self:_disable_hit_collision()

	local network_manager = Managers.state.network
	local game = network_manager:game()

	self._ammo_blackboard = {
		texture = settings.ui_ammo_texture,
		glow_texture = settings.ui_ammo_glow_texture,
		starting_ammo = settings.starting_ammo or 1,
		ammo = game and id and GameSession.game_object_field(game, id, "ammunition") or settings.starting_ammo or 1
	}

	if self._ammo_blackboard.texture then
		Managers.state.event:trigger("ammo_weapon_spawned", self._player, self._user_unit, self._ammo_blackboard)
	end

	local sweep_node_script_offsets = settings.sweep_node_script_offsets

	if sweep_node_script_offsets then
		for node_name, offset_box in pairs(sweep_node_script_offsets) do
			local offset = offset_box:unbox()
			local node = Unit.node(unit, node_name)

			Unit.set_local_position(unit, node, Unit.local_position(unit, node) + offset)
		end
	end
end

function WeaponMelee:add_ammo(change)
	self._ammo_blackboard.ammo = math.clamp(self._ammo_blackboard.ammo + change, 0, self._ammo_blackboard.starting_ammo)

	local network_manager = Managers.state.network
	local game = network_manager:game()
	local id = self._game_object_id

	if game and id then
		GameSession.set_game_object_field(game, id, "ammunition", self._ammo_blackboard.ammo)
	end
end

function WeaponMelee:starting_ammo()
	return self._ammo_blackboard.starting_ammo
end

function WeaponMelee:ammo()
	return self._ammo_blackboard.ammo
end

function WeaponMelee:category()
	return self._weapon_category
end

function WeaponMelee:set_wielded(wielded)
	if not wielded and self._attacking then
		self:end_attack()
	end
end

function WeaponMelee:set_sheathed(sheathed)
	return
end

function WeaponMelee:_enable_hit_collision()
	for _, actor in ipairs(self._collision_actors) do
		Actor.set_collision_enabled(actor, true)
	end
end

function WeaponMelee:_disable_hit_collision()
	for _, actor in ipairs(self._collision_actors) do
		Actor.set_collision_enabled(actor, false)
	end
end

function WeaponMelee:update(dt, t)
	Profiler.start("WeaponMelee:update()")

	if self._attacking then
		local unit = self._unit

		World.update_unit(self._world, self._user_unit)

		local current_attack = self._current_attack
		local new_time = current_attack.attack_time + dt

		if script_data.damage_debug then
			local position = Unit.world_position(unit, 0)
			local sweep_progression = WeaponHelper:calculate_sweep_progression(current_attack)
			local debug_text_count = current_attack.debug_text_count or 0
			local size = 0.05

			Managers.state.debug_text:output_world_text(sprintf("%1.2f", sweep_progression), size, position + Vector3(0, 0, debug_text_count * size), 10, "damage_debug", Vector3(255, 255, 255))

			current_attack.debug_text_count = debug_text_count + 1

			local attack_settings = current_attack.attack_settings
			local abort_time_factor = attack_settings.abort_time_factor or 0
			local abort_time = current_attack.attack_duration * abort_time_factor

			if abort_time > current_attack.attack_time and abort_time <= new_time then
				local drawer = Managers.state.debug:drawer({
					mode = "retained",
					name = "DEBUG_DRAW_WEAPON_VELOCITY" .. tostring(unit)
				})
				local sweep_data = attack_settings and attack_settings.sweep

				if sweep_data then
					position = (Unit.world_position(unit, Unit.node(unit, sweep_data.inner_node)) + Unit.world_position(unit, Unit.node(unit, sweep_data.outer_node))) * 0.5
				end

				drawer:sphere(position, 0.05, Color(0, 255, 0))
			end
		end

		current_attack.last_attack_time = current_attack.attack_time
		current_attack.attack_time = new_time

		if script_data.damage_debug or script_data.weapon_velocity_debug then
			self:_debug_draw_weapon_velocity()
		end
	end

	self:debug_draw_sweep_area()
	self:debug_draw_objects()

	if self._sweep_collision then
		local current_attack = self._current_attack
		local start_progress = (current_attack.last_attack_time - dt) / current_attack.attack_duration
		local end_progress = (current_attack.attack_time - dt) / current_attack.attack_duration
		local start_swing = current_attack.sweep.delay
		local end_swing = current_attack.sweep.end_delay
		local length = end_progress - start_progress
		local start_interpolation_factor = 0
		local end_interpolation_factor = 1

		if end_swing < start_progress then
			Profiler.stop()

			return
		elseif start_progress < start_swing and start_swing < end_progress then
			local interpolation_factor = (start_swing - start_progress) / length

			for i, sweep in ipairs(current_attack.sweep) do
				self:_update_sweep_collision(dt, sweep, current_attack, interpolation_factor, start_swing, true)
			end

			start_interpolation_factor = interpolation_factor
		elseif start_progress < start_swing then
			for i, sweep in ipairs(current_attack.sweep) do
				self:_update_sweep_collision(dt, sweep, current_attack, 1, end_progress, true)
			end

			Profiler.stop()

			return
		end

		if end_swing < end_progress then
			end_interpolation_factor = 1 - (end_progress - end_swing) / length
		end

		local dt_epsilon = 0.001
		local fps = 1 / math.max(dt, dt_epsilon)
		local steps = math.ceil(120 / fps)
		local hard_hit

		for i = 1, steps do
			local interpolation_factor = math.lerp(start_interpolation_factor, end_interpolation_factor, i / steps)
			local progress = math.lerp(start_progress, end_progress, interpolation_factor)

			self._swing_progress = (progress - start_swing) / (end_swing - start_swing)

			for i, sweep in ipairs(current_attack.sweep) do
				hard_hit = self:_update_sweep_collision(dt, sweep, current_attack, interpolation_factor, progress)

				if hard_hit then
					break
				end
			end

			if hard_hit then
				break
			end
		end
	end

	Profiler.stop()
end

function WeaponMelee:can_throw()
	return self._ammo_blackboard.ammo >= 1
end

function WeaponMelee:can_wield()
	return self._ammo_blackboard.ammo >= 1
end

function WeaponMelee:wield_finished_anim_name()
	return nil
end

function WeaponMelee:start_attack(charge_factor, attack_name, attack_settings, abort_attack_func, attack_duration, abort_on_hit, riposte)
	self._attacking = true
	self._swing_progress = 0

	local unit = self._unit

	self._current_attack = {
		last_attack_time = 0,
		hit_characters = 0,
		attack_time = 0,
		attack_settings = attack_settings,
		no_behind_hits = attack_settings.no_behind_hits,
		attack_duration = attack_duration,
		charge_factor = charge_factor,
		attack_name = attack_name,
		abort_func = abort_attack_func,
		hits = {},
		abort_on_hit = abort_on_hit,
		riposte = riposte
	}
	self._mytable = {
		charge_factor,
		attack_name,
		attack_settings,
		abort_attack_func,
		attack_duration,
		abort_on_hit,
		riposte
	}

	Unit.set_flow_variable(unit, "swing_time", attack_duration)
	Unit.flow_event(unit, "lua_attack_started_" .. attack_name)

	if self._settings.sweep_collision then
		self:_activate_sweep_collision()
	else
		self:_enable_hit_collision()
	end
end

function WeaponMelee:end_attack()
	local current_attack = self._current_attack

	if current_attack == nil then
		return
	end

	if current_attack.hit_characters == 0 then
		local gear_name = Unit.get_data(self._unit, "gear_name")

		Managers.state.stats_collector:weapon_missed(self._player, gear_name)
	end

	self._attacking = false

	local hit = current_attack.hit_characters > 0

	if self._settings.sweep_collision then
		self:_deactivate_sweep_collision()
	else
		self:_disable_hit_collision()
	end

	self._current_attack = nil

	local swing_direction = current_attack.attack_name

	Unit.flow_event(self._unit, "lua_attack_ended_" .. swing_direction)

	local time_left = math.max(current_attack.attack_duration - current_attack.attack_time, 0)

	return swing_direction, hit, time_left
end

function WeaponMelee:_abort_attack(reason)
	local abort_func = self._current_attack.abort_func

	if abort_func then
		abort_func(reason)
	end
end

function WeaponMelee:_unit_world_position()
	return Unit.world_position(self._unit, 0)
end

function WeaponMelee:_unit_world_rotation()
	return Unit.world_rotation(self._unit, 0)
end

function WeaponMelee:debug_draw_sweep_area()
	if script_data.weapon_collision_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "immediate",
			name = "weapon_immediate"
		})
		local unit = self._unit
		local epsilon = 0.002
		local total_epsilon = 0

		drawer:matrix4x4(Unit.world_pose(unit, 0), 0.2)

		for attack, color in pairs({
			up = Color(255, 255, 0, 0),
			dodge_left = Color(255, 0, 255, 0),
			dodge_right = Color(255, 0, 255, 255),
			left = Color(255, 0, 0, 255),
			right = Color(255, 255, 255, 0),
			special = Color(255, 255, 0, 255),
			down = Color(255, 100, 230, 30)
		}) do
			script_data.attack_debug = self._attacks[attack]

			local attack_settings = self._attacks[attack]
			local sweep_data = attack_settings and attack_settings.sweep

			if sweep_data then
				local sweep_data = self:_create_sweep_settings_table(unit, sweep_data)

				for i, data in ipairs(sweep_data) do
					local x, y, z, w = Quaternion.to_elements(color)
					local use_color

					if data.hit_callback == "hit_cb" then
						use_color = Color(x, y, z, w)
					elseif data.hit_callback == "non_damage_hit_cb" then
						use_color = Color(x, y * 0.5, z * 0.5, w * 0.5)
					else
						use_color = Color(x, y * 0.25, z * 0.25, w * 0.25)
					end

					local to_center, weapon_extents, rot = self:_calculate_sweep_extents(attack_settings, data, 1, true, true)

					drawer:box(Matrix4x4.from_quaternion_position(rot, to_center), weapon_extents + Vector3(total_epsilon, total_epsilon, total_epsilon), use_color)
				end
			end
		end
	end
end

function WeaponMelee:debug_draw_objects()
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

function WeaponMelee:_activate_sweep_collision()
	self._sweep_collision = true

	local unit = self._unit
	local current_attack = self._current_attack
	local attack_settings = current_attack.attack_settings
	local attack_sweep_settings = attack_settings.sweep

	current_attack.sweep = self:_create_sweep_settings_table(unit, attack_sweep_settings)
end

function WeaponMelee:_create_sweep_settings_table(unit, sweep_settings)
	local sweep = {}

	sweep.delay = sweep_settings.delay or 0
	sweep.end_delay = sweep_settings.end_delay or 1

	for i, sweep_config in ipairs(sweep_settings) do
		local sweep_data = {}
		local inner_node = Unit.node(unit, sweep_config.inner_node)
		local outer_node = Unit.node(unit, sweep_config.outer_node)
		local inner_rot = Unit.world_rotation(unit, inner_node)
		local inner_pos = Unit.world_position(unit, inner_node)
		local outer_pos = Unit.world_position(unit, outer_node)
		local fwd = Quaternion.forward(inner_rot)
		local up = Quaternion.up(inner_rot)
		local right = Quaternion.right(inner_rot)
		local middle_local_pos = (inner_pos + outer_pos) * 0.5

		sweep_data.last_pos = Vector3Box((inner_pos + outer_pos) * 0.5)
		sweep_data.last_inner_pos = Vector3Box(inner_pos)
		sweep_data.last_outer_pos = Vector3Box(outer_pos)
		sweep_data.last_inner_rot = QuaternionBox(inner_rot)
		sweep_data.inner_node = inner_node
		sweep_data.outer_node = outer_node
		sweep_data.width = sweep_config.width
		sweep_data.thickness = sweep_config.thickness
		sweep_data.height = Vector3.dot(outer_pos - inner_pos, up)
		sweep_data.hit_callback = sweep_config.hit_callback
		sweep[i] = sweep_data
	end

	return sweep
end

function WeaponHelper:current_impact_direction(weapon_unit, current_attack_name)
	local settings = Unit.get_data(weapon_unit, "settings")
	local unit_rot = Unit.world_rotation(weapon_unit, 0)
	local hit_direction = settings.attacks[current_attack_name].forward_direction:unbox()

	return Quaternion.right(unit_rot) * hit_direction.x + Quaternion.forward(unit_rot) * hit_direction.y + Quaternion.up(unit_rot) * hit_direction.z
end

function WeaponMelee:_interpolated_position(old_pos, old_direction, new_pos, new_direction, distance, interpolation_factor)
	return Vector3.lerp(Vector3.lerp(old_pos, old_pos + old_direction * distance, interpolation_factor), Vector3.lerp(new_pos - new_direction * distance, new_pos, interpolation_factor), interpolation_factor)
end

function WeaponMelee:_calculate_sweep_extents(attack_settings, sweep_data, interpolation_factor, early_exit, no_update)
	local unit = self._unit
	local unit_inner_rot = Unit.world_rotation(unit, sweep_data.inner_node)
	local unit_inner_pos = Unit.world_position(unit, sweep_data.inner_node)
	local unit_outer_pos = Unit.world_position(unit, sweep_data.outer_node)
	local last_inner_rot = sweep_data.last_inner_rot:unbox()
	local last_inner_pos = sweep_data.last_inner_pos:unbox()
	local last_outer_pos = sweep_data.last_outer_pos:unbox()
	local local_forward_direction = attack_settings.forward_direction:unbox()
	local old_forward_direction = local_forward_direction.x * Quaternion.right(last_inner_rot) + local_forward_direction.y * Quaternion.forward(last_inner_rot) + local_forward_direction.z * Quaternion.up(last_inner_rot)
	local new_forward_direction = local_forward_direction.x * Quaternion.right(unit_inner_rot) + local_forward_direction.y * Quaternion.forward(unit_inner_rot) + local_forward_direction.z * Quaternion.up(unit_inner_rot)
	local inner_rot = Quaternion.lerp(last_inner_rot, unit_inner_rot, interpolation_factor)
	local inner_pos = self:_interpolated_position(last_inner_pos, old_forward_direction, unit_inner_pos, new_forward_direction, Vector3.length(unit_inner_pos - last_inner_pos) * 0.5, interpolation_factor)
	local outer_pos = self:_interpolated_position(last_outer_pos, old_forward_direction, unit_outer_pos, new_forward_direction, Vector3.length(unit_outer_pos - last_outer_pos) * 0.5, interpolation_factor)

	if script_data.sweep_interpolation_debug and not early_exit then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon_retained"
		})
		local pos1 = self:_interpolated_position(last_inner_pos, old_forward_direction, unit_inner_pos, new_forward_direction, Vector3.length(unit_inner_pos - last_inner_pos) * 0.5, 0)
		local pos2 = self:_interpolated_position(last_inner_pos, old_forward_direction, unit_inner_pos, new_forward_direction, Vector3.length(unit_inner_pos - last_inner_pos) * 0.5, interpolation_factor)

		drawer:line(pos1, pos2, Color(interpolation_factor * 255, (1 - interpolation_factor) * 255, 0))

		local pos1 = self:_interpolated_position(last_outer_pos, old_forward_direction, unit_outer_pos, new_forward_direction, Vector3.length(unit_outer_pos - last_outer_pos) * 0.5, 0)
		local pos2 = self:_interpolated_position(last_outer_pos, old_forward_direction, unit_outer_pos, new_forward_direction, Vector3.length(unit_outer_pos - last_outer_pos) * 0.5, interpolation_factor)

		drawer:line(pos1, pos2, Color(interpolation_factor * 255, (1 - interpolation_factor) * 255, 0))
	end

	local middle_pos = (inner_pos + outer_pos) * 0.5
	local weapon_extents = Vector3(sweep_data.width, sweep_data.thickness, sweep_data.height) / 2

	if not no_update then
		sweep_data.last_inner_pos:store(inner_pos)
		sweep_data.last_outer_pos:store(outer_pos)
		sweep_data.last_inner_rot:store(inner_rot)
	end

	return middle_pos, weapon_extents, inner_rot, outer_pos
end

function WeaponMelee:_update_sweep_collision(dt, sweep_settings, current_attack, interpolation_factor, progress, early_exit)
	local from_center = sweep_settings.last_pos:unbox()
	local last_outer_pos = sweep_settings.last_outer_pos:unbox()
	local attack_settings = current_attack.attack_settings
	local to_center, weapon_extents, rot, outer_pos2 = self:_calculate_sweep_extents(attack_settings, sweep_settings, interpolation_factor, early_exit)

	if early_exit then
		sweep_settings.last_pos:store(to_center)

		return
	end

	if Vector3.length(from_center - to_center) < SWEEP_DISTANCE_EPSILON then
		return
	end

	local hits = {}
	local physics_world = World.physics_world(self._world)
	local outer_pos1 = outer_pos2 - to_center + from_center
	local sweep_dir = outer_pos1 - last_outer_pos
	local dir_to_from_center = from_center - last_outer_pos
	local plane_normal = Vector3.cross(dir_to_from_center, sweep_dir)
	local sweep_height_dir = Vector3.normalize(Vector3.cross(sweep_dir, plane_normal))
	local half_height = Vector3.dot(sweep_height_dir, dir_to_from_center) / 2
	local sweep_extents = Vector3(sweep_settings.thickness * 0.5, sweep_settings.width * 0.5, half_height)
	local from = last_outer_pos + sweep_height_dir * half_height
	local to = outer_pos1 + sweep_height_dir * half_height
	local rotation = Quaternion.look(Vector3.normalize(sweep_dir), sweep_height_dir)

	if Vector3.length(from - to) > SWEEP_DISTANCE_EPSILON then
		hits = PhysicsWorld.linear_obb_sweep(physics_world, from, to, sweep_extents, rotation, 10, "types", "both", "collision_filter", "melee_trigger") or hits

		if script_data.weapon_collision_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon"
			})

			drawer:box_sweep(Matrix4x4.from_quaternion_position(rotation, from), sweep_extents, to - from)
		end
	end

	local from_bottom = from_center - Quaternion.up(rot) * weapon_extents.z
	local from_top = from_center + Quaternion.up(rot) * weapon_extents.z
	local from_extents = Vector3(weapon_extents.x, weapon_extents.y, 0.01)

	if Vector3.length(from_bottom - from_top) > SWEEP_DISTANCE_EPSILON then
		local new_hits = PhysicsWorld.linear_obb_sweep(physics_world, from_bottom, from_top, from_extents, rot, 10, "types", "both", "collision_filter", "melee_trigger")

		if script_data.weapon_collision_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon"
			})

			drawer:box_sweep(Matrix4x4.from_quaternion_position(rot, from_bottom), from_extents, from_top - from_bottom)
			drawer:sphere(from_bottom, 0.01, Color(0, 0, 255))
			drawer:sphere(from_top, 0.01, Color(0, 255, 255))
		end

		if new_hits then
			for _, hit in ipairs(new_hits) do
				hits[#hits + 1] = hit
			end
		end
	end

	local new_hits = PhysicsWorld.linear_obb_sweep(physics_world, from_center, to_center, weapon_extents, rot, 10, "types", "both", "collision_filter", "melee_trigger")

	if new_hits then
		for _, hit in ipairs(new_hits) do
			hits[#hits + 1] = hit
		end
	end

	if script_data.weapon_collision_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})

		drawer:box_sweep(Matrix4x4.from_quaternion_position(rot, from_center), weapon_extents, to_center - from_center)
	end

	if hits then
		local sweep_vector = to_center - from_center
		local sweep_direction = Vector3.normalize(sweep_vector)
		local sweep_length = Vector3.length(sweep_vector)

		for _, hit in ipairs(hits) do
			local hit_unit = Actor.unit(hit.actor)
			local actor = hit.actor
			local normal = hit.normal
			local position = hit.position

			if script_data.weapon_collision_debug then
				local drawer = Managers.state.debug:drawer({
					mode = "retained",
					name = "weapon_hit"
				})

				drawer:sphere(position, 0.02, Color(255, 0, 0))
			end

			local sweep_t = math.clamp(Vector3.dot(position - from_center, sweep_direction) / sweep_length, 0, 1)
			local attack_time = math.lerp(current_attack.last_attack_time, current_attack.attack_time, sweep_t)

			fassert(self[sweep_settings.hit_callback], "No hit_callback function named %q in weapon melee", sweep_settings.hit_callback)

			if self[sweep_settings.hit_callback](self, hit_unit, actor, normal, position, nil, false, attack_time) then
				return true
			end
		end
	end

	if false then
		-- block empty
	end

	sweep_settings.last_pos:store(to_center)
end

function WeaponMelee:_deactivate_sweep_collision()
	self._sweep_collision = false
end

function WeaponMelee:_is_hit_behind(position)
	local user_unit = self._user_unit

	if not Unit.alive(user_unit) then
		return true
	end

	local unit_position = Unit.world_position(user_unit, 0)
	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local aim_direction = locomotion:aim_direction()

	aim_direction.z = 0

	if Vector3.dot(Vector3.normalize(position - unit_position), Vector3.normalize(aim_direction)) < 0 then
		return true
	else
		return false
	end
end

function WeaponMelee:non_damage_hit_cb(hit_unit, actor, normal, position, self_actor, couching, interpolated_attack_time)
	if not hit_unit or not Unit.alive(hit_unit) or not self._attacking and not couching then
		return
	end

	local unit = self._unit
	local user_unit = self._user_unit
	local current_attack = self._current_attack

	if current_attack.no_behind_hits and self:_is_hit_behind(position) then
		return
	end

	hit_unit, actor = WeaponHelper:helmet_hack(hit_unit, actor)

	if hit_unit == user_unit or Unit.get_data(hit_unit, "user_unit") == user_unit or self._current_attack.hits[hit_unit] then
		return
	end

	local hard_hit
	local impact_direction = WeaponHelper:current_impact_direction(self._unit, current_attack.attack_name)

	if Unit.has_data(hit_unit, "gear_name") then
		local gear_user = self._user_unit

		if not Unit.alive(gear_user) then
			return
		end

		local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

		if not current_attack.hits[gear_user] and gear_user_locomotion.blocking and gear_user_locomotion.block_unit == hit_unit then
			hard_hit = self:_hit_blocking_gear(gear_user, gear_user_locomotion.block_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)
		end
	elseif not Unit.has_data(hit_unit, "health") then
		hard_hit = self:_hit_non_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	end

	return hard_hit
end

function WeaponMelee:hit_cb(hit_unit, actor, normal, position, self_actor, couching, interpolated_attack_time)
	if not hit_unit or not Unit.alive(hit_unit) or not self._attacking and not couching then
		return
	end

	local unit = self._unit
	local user_unit = self._user_unit
	local current_attack = self._current_attack
	local riposte = current_attack.riposte or false

	if current_attack.no_behind_hits and self:_is_hit_behind(position) then
		return
	end

	hit_unit, actor = WeaponHelper:helmet_hack(hit_unit, actor)

	if hit_unit == user_unit or Unit.get_data(hit_unit, "user_unit") == user_unit then
		return
	end

	local hit_zones = Unit.get_data(hit_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor] and hit_zones[actor].name
	local hits_to_unit = current_attack.hits[hit_unit]
	local no_hit_zones_and_first_hit = not hit_zones and not hits_to_unit
	local has_hit_zones_and_zone_hit = hit_zones and hit_zone_hit
	local unit_previously_hit_in_zone = hits_to_unit and hits_to_unit.hit_zones[hit_zone_hit]
	local hit_zone_not_hit = no_hit_zones_and_first_hit or has_hit_zones_and_zone_hit and not unit_previously_hit_in_zone

	if not hit_zone_not_hit then
		return
	end

	normal = normal or Vector3(0, 1, 0)
	position = position or Vector3(0, 0, 0)

	local hit_part, hard_hit
	local impact_direction = WeaponHelper:current_impact_direction(unit, current_attack.attack_name)

	if Unit.has_data(hit_unit, "gear_name") then
		local gear_settings = Gear[Unit.get_data(hit_unit, "gear_name")]
		local gear_user = Unit.get_data(hit_unit, "user_unit")

		if not Unit.alive(gear_user) then
			return
		end

		local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

		if not current_attack.hits[gear_user] and gear_user_locomotion.parrying and gear_user_locomotion.block_unit == hit_unit and self:_check_parry(user_unit, gear_user, not hits_to_unit, impact_direction, position) then
			hard_hit = self:_hit_parrying_gear("parrying", gear_user, gear_user_locomotion.block_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)
		elseif not current_attack.hits[gear_user] and gear_settings.gear_type == "shield" then
			hit_part = "shield"

			local player_unit = self._user_unit
			local p1 = Unit.world_position(self._unit, 0)
			local v1 = Quaternion.forward(Unit.world_rotation(player_unit, Unit.node(player_unit, "Head")))
			local p2 = Unit.world_position(hit_unit, 0)
			local v2 = Quaternion.forward(Unit.world_rotation(hit_unit, 0))
			local facing_value = Vector3.dot(Vector3.normalize(v1), Vector3.normalize(v2))

			if facing_value < 0.5 then
				local damage_ext = ScriptUnit.extension(gear_user, "damage_system")
				local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
				local dead = damage_ext:is_dead()

				if not kd and not dead then
					local inventory = gear_user_locomotion._inventory
					local gear = inventory:find_gear_by_unit(hit_unit)

					if gear and gear:wielded() then
						hard_hit = self:_hit_blocking_gear(gear_user, hit_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)

						self:_deactivate_sweep_collision()
					end
				end
			end
		end
	elseif ScriptUnit.has_extension(hit_unit, "locomotion_system") then
		local victim_locomotion = ScriptUnit.extension(hit_unit, "locomotion_system")

		if not hits_to_unit and victim_locomotion.parrying and self:_check_parry(user_unit, hit_unit, false, impact_direction, position) then
			hit_part = "parrying weapon"
			hard_hit = self:_hit_parrying_gear("parrying", hit_unit, victim_locomotion.block_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)
		elseif not hits_to_unit and victim_locomotion.dual_wield_defending and self:_check_dual_wield_defend(user_unit, hit_unit, impact_direction, position) then
			hard_hit = self:_hit_defending_gear(hit_unit, victim_locomotion.block_unit, position, normal, actor, hit_zone_hit, impact_direction, interpolated_attack_time, riposte)
		elseif not WeaponHelper:conditions_stopping_melee_character_hit(hit_unit, unit, hit_zone_hit, current_attack) then
			hard_hit = self:_hit_character(hit_unit, position, normal, actor, hit_zone_hit, impact_direction, interpolated_attack_time, riposte)
		end
	elseif Unit.get_data(hit_unit, "health") then
		hard_hit = self:_hit_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	else
		hard_hit = self:_hit_non_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	end

	return hard_hit
end

function WeaponMelee:pommel_bash_hit_cb(hit_unit, actor, normal, position, self_actor, couching, interpolated_attack_time)
	if not hit_unit or not Unit.alive(hit_unit) or not self._attacking and not couching then
		return
	end

	local unit = self._unit
	local user_unit = self._user_unit
	local current_attack = self._current_attack

	hit_unit, actor = WeaponHelper:helmet_hack(hit_unit, actor)

	if hit_unit == user_unit or Unit.get_data(hit_unit, "user_unit") == user_unit then
		return
	end

	local hit_zones = Unit.get_data(hit_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor] and hit_zones[actor].name
	local hits_to_unit = current_attack.hits[hit_unit]
	local no_hit_zones_and_first_hit = not hit_zones and not hits_to_unit
	local has_hit_zones_and_zone_hit = hit_zones and hit_zone_hit
	local unit_previously_hit_in_zone = hits_to_unit and hits_to_unit.hit_zones[hit_zone_hit]
	local hit_zone_not_hit = no_hit_zones_and_first_hit or has_hit_zones_and_zone_hit and not unit_previously_hit_in_zone

	if not hit_zone_not_hit then
		return
	end

	normal = normal or Vector3(0, 1, 0)
	position = position or Vector3(0, 0, 0)

	local hard_hit
	local impact_direction = WeaponHelper:current_impact_direction(unit, current_attack.attack_name)

	if ScriptUnit.has_extension(hit_unit, "locomotion_system") then
		local victim_locomotion = ScriptUnit.extension(hit_unit, "locomotion_system")

		if not WeaponHelper:conditions_stopping_melee_character_hit(hit_unit, unit, hit_zone_hit, current_attack) then
			hard_hit = self:_pommel_bash_hit_character(hit_unit, position, normal, actor, hit_zone_hit, impact_direction, interpolated_attack_time)
		end
	elseif Unit.has_data(hit_unit, "gear_name") then
		local gear_settings = Gear[Unit.get_data(hit_unit, "gear_name")]
		local gear_user = Unit.get_data(hit_unit, "user_unit")

		if not Unit.alive(gear_user) then
			return
		end

		local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

		if not current_attack.hits[gear_user] and gear_user_locomotion.blocking and gear_user_locomotion.block_unit == hit_unit then
			hard_hit = self:_hit_blocking_gear(gear_user, gear_user_locomotion.block_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)
		end
	else
		hard_hit = self:_hit_non_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	end

	return hard_hit
end

local PARRY_ANGLES = {
	up = 0,
	left = -math.pi * 0.5,
	right = math.pi * 0.5
}

function WeaponMelee:_check_dual_wield_defend(attacker_unit, victim_unit, impact_direction, position)
	local victim_locomotion = ScriptUnit.extension(victim_unit, "locomotion_system")
	local attack_settings = self._current_attack.attack_settings
	local parry_direction = attack_settings.parry_direction

	if not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	if victim_locomotion.block_raised_time > Managers.time:time("game") then
		return false
	end

	local attacker_locomotion = ScriptUnit.extension(attacker_unit, "locomotion_system")
	local attacker_aim = attacker_locomotion:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3.normalize(Vector3.flat(attacker_aim))
	local victim_aim_flat = Vector3.normalize(Vector3.flat(victim_aim))
	local distance_flat = Vector3.normalize(Vector3.flat(Unit.local_position(victim_unit, 0) - Unit.local_position(attacker_unit, 0)))
	local impact_direction_flat = Vector3.normalize(Vector3.flat(impact_direction))

	if parry_direction == "down" or parry_direction == "up" then
		return Vector3.dot(attacker_aim_flat, victim_aim_flat) < 0 or Vector3.dot(distance_flat, victim_aim_flat) < 0
	elseif parry_direction == "left" then
		local parry_aim_dir = Quaternion.rotate(Quaternion(Vector3.up(), -0.25 * math.pi), victim_aim_flat)

		if script_data.parry_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon_hit"
			})

			drawer:vector(position, parry_aim_dir * 0.1, Color(0, 255, 0))
			drawer:vector(position, impact_direction_flat * 0.1, Color(255, 0, 0))
		end

		return Vector3.dot(parry_aim_dir, impact_direction_flat) < 0
	elseif parry_direction == "right" then
		local parry_aim_dir = Quaternion.rotate(Quaternion(Vector3.up(), 0.25 * math.pi), victim_aim_flat)

		if script_data.parry_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon_hit"
			})

			drawer:vector(position, parry_aim_dir * 0.1, Color(0, 255, 0))
			drawer:vector(position, impact_direction_flat * 0.1, Color(255, 0, 0))
		end

		return Vector3.dot(parry_aim_dir, impact_direction_flat) < 0
	end
end

function WeaponMelee:_check_parry(attacker_unit, victim_unit, not_previously_hit, impact_direction, position)
	local victim_locomotion = ScriptUnit.extension(victim_unit, "locomotion_system")
	local attack_settings = self._current_attack.attack_settings
	local parry_direction = attack_settings.parry_direction
	local victim_block_direction = victim_locomotion.block_direction

	if not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	if victim_locomotion.block_raised_time > Managers.time:time("game") then
		return false
	end

	if not_previously_hit and (parry_direction == "left" or parry_direction == "right") and (victim_block_direction == "left" or victim_block_direction == "right") then
		return true
	end

	if victim_block_direction ~= parry_direction and (victim_block_direction ~= "right" and victim_block_direction ~= "left" or parry_direction ~= "down") then
		return false
	end

	local attacker_locomotion = ScriptUnit.extension(attacker_unit, "locomotion_system")
	local attacker_aim = attacker_locomotion:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3.normalize(Vector3.flat(attacker_aim))
	local victim_aim_flat = Vector3.normalize(Vector3.flat(victim_aim))
	local distance_flat = Vector3.normalize(Vector3.flat(Unit.local_position(victim_unit, 0) - Unit.local_position(attacker_unit, 0)))
	local impact_direction_flat = Vector3.normalize(Vector3.flat(impact_direction))

	if parry_direction == "down" or parry_direction == "up" then
		return Vector3.dot(attacker_aim_flat, victim_aim_flat) < 0 or Vector3.dot(distance_flat, victim_aim_flat) < 0
	elseif parry_direction == "left" then
		local parry_aim_dir = Quaternion.rotate(Quaternion(Vector3.up(), -0.25 * math.pi), victim_aim_flat)

		if script_data.parry_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon_hit"
			})

			drawer:vector(position, parry_aim_dir * 0.1, Color(0, 255, 0))
			drawer:vector(position, impact_direction_flat * 0.1, Color(255, 0, 0))
		end

		return Vector3.dot(parry_aim_dir, impact_direction_flat) < 0
	elseif parry_direction == "right" then
		local parry_aim_dir = Quaternion.rotate(Quaternion(Vector3.up(), 0.25 * math.pi), victim_aim_flat)

		if script_data.parry_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "weapon_hit"
			})

			drawer:vector(position, parry_aim_dir * 0.1, Color(0, 255, 0))
			drawer:vector(position, impact_direction_flat * 0.1, Color(255, 0, 0))
		end

		return Vector3.dot(parry_aim_dir, impact_direction_flat) < 0
	end
end

function WeaponMelee:_check_blocking(attacker_unit, victim_unit)
	local victim_locomotion = ScriptUnit.extension(victim_unit, "locomotion_system")

	if not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	local attacker_locomotion = ScriptUnit.extension(attacker_unit, "locomotion_system")
	local attacker_aim = attacker_locomotion:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3.flat(attacker_aim)
	local victim_aim_flat = Vector3.flat(victim_aim)
	local dot = Vector3.dot(attacker_aim_flat, victim_aim_flat)

	return dot < 0
end

function WeaponMelee:_target_type(hit_unit, current_attack, damage, hit_zone)
	local target_type
	local abort = false
	local force_soft = false
	local nullify_type = SquadSettings.nullify_friendly_fire
	local friendly_fire_hit = nullify_type and SquadSettings[nullify_type](self._player, hit_unit)

	if not friendly_fire_hit and current_attack.abort_on_hit and ScriptUnit.has_extension(hit_unit, "locomotion_system") and (not damage or damage < PlayerUnitDamageSettings.INSTAKILL_THRESHOLD or hit_zone ~= "head") then
		target_type = "hard"
		abort = true

		if damage then
			self:_play_camera_impact(current_attack, damage)
		end

		self:_abort_attack("hit_character")
	elseif Unit.get_data(hit_unit, "soft_target") then
		target_type = "soft"

		if damage then
			self:_play_camera_impact(current_attack, damage)
		end
	else
		target_type = "hard"
		abort = true

		self:_abort_attack(target_type)
	end

	return target_type, abort
end

function WeaponMelee:_play_camera_impact(current_attack, damage)
	if not GameSettingsDevelopment.tutorial_mode and self._user_locomotion and self._user_locomotion.IsHusk() then
		return
	end

	local damage_levels = DamageLevels.penetrated
	local level

	level = damage > damage_levels.heavy and "heavy" or damage > damage_levels.medium and "medium" or damage > 0 and "light" or "no_damage"

	local swing_direction = current_attack.attack_name
	local dir

	dir = not (swing_direction ~= "right" and swing_direction ~= "right_switched") and "right_" or not (swing_direction ~= "left" and swing_direction ~= "left_switched") and "left_" or not (swing_direction ~= "up" and swing_direction ~= "up_switched") and "up_" or "down_"

	local camera_event_name = "swing_impact_" .. dir .. level
	local camera_manager = Managers.state.camera
	local t = Managers.time:time("game")

	if CameraEffectSettings.shake[camera_event_name] then
		camera_manager:camera_effect_shake_event(camera_event_name, t)

		if script_data.camera_debug then
			print("SHAKE", camera_event_name)
		end
	end

	if CameraEffectSettings.sequence[camera_event_name] then
		camera_manager:camera_effect_sequence_event(camera_event_name, t)

		if script_data.camera_debug then
			print("SEQUENCE:", camera_event_name)
		end
	end
end

function WeaponMelee:_hit_defending_gear(hit_unit, gear_unit, position, normal, actor, hit_zone, impact_direction, interpolated_attack_time, riposte)
	local current_attack = self._current_attack
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local defend_damage_multiplier = 0.35
	local raw_damage, damage_type, damage, damage_range_type, real_damage = self:_add_damage(hit_unit, position, normal, actor, hit_zone, false, current_attack, impact_direction, defend_damage_multiplier, interpolated_attack_time)

	if raw_damage then
		if game then
			damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
			raw_damage = math.clamp(raw_damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
		end

		WeaponHelper:apply_damage(self._world, self._user_unit, self._unit, hit_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction, self._properties, real_damage, riposte)
	end

	self:_hit_parrying_gear("dual_wield_defending", hit_unit, gear_unit, position, normal, actor, impact_direction, interpolated_attack_time, true)

	return true
end

function WeaponMelee:_get_momentum()
	local momentum = 0
	local attack

	if self._current_attack then
		attack = self._current_attack.attack_name
	else
		return 1
	end

	if string.find(attack, "special") then
		momentum = 1 + math.sin(self._swing_progress * math.pi) * 0.1
	elseif self.gear_type == "spear" then
		momentum = 0.8 + math.sin(self._swing_progress * math.pi) * 0.2
	else
		momentum = 0.5 + math.sin(self._swing_progress * math.pi) * 0.5
	end

	return momentum
end

function WeaponMelee:_hit_character(hit_unit, position, normal, actor, hit_zone, impact_direction, interpolated_attack_time, riposte)
	local current_attack = self._current_attack
	local attack_name = current_attack.attack_name
	local settings = self._settings
	local attack_settings = current_attack.attack_settings
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local stun = false
	local raw_damage, damage_type, damage, damage_range_type, real_damage = self:_add_damage(hit_unit, position, normal, actor, hit_zone, false, current_attack, impact_direction, nil, interpolated_attack_time)
	local target_type, abort = self:_target_type(hit_unit, current_attack, real_damage, hit_zone, damage)
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")

	if raw_damage then
		local attack_data_for_victim = current_attack.hits[hit_unit]
		local player_manager = Managers.player
		local hit_player = player_manager:owner(hit_unit)
		local own_player = self._player
		local interrupt = true

		if hit_player and own_player and hit_player.team == own_player.team then
			stun = false
			interrupt = false
		elseif attack_settings.stun and not attack_data_for_victim.stun then
			stun = true
			attack_data_for_victim.stun = true
		end

		if hit_unit and ScriptUnit.has_extension(hit_unit, "locomotion_system") then
			local victim_locomotion = ScriptUnit.extension(hit_unit, "locomotion_system")

			damage = victim_locomotion.parrying and victim_locomotion:has_perk("training_wheels") and damage * Perks.training_wheels.damage_melee_total_multiplier or damage

			local momentum = self:_get_momentum()

			damage = damage * momentum
		end

		local weapon_damage_direction = attack_settings.forward_direction:unbox()

		WeaponHelper:weapon_impact_character(hit_unit, self._unit, target_type, attack_name, stun, damage, raw_damage, position, normal, self._world, hit_zone, impact_direction, weapon_damage_direction, interrupt, actor)

		if locomotion:has_perk("faster_melee_charge") and self:_fully_charged_attack(current_attack) then
			locomotion.perk_fast_pose_charge.faster_melee_charge.can_use = true
		end

		if game then
			local hit_unit_game_object_id = network_manager:game_object_id(hit_unit)
			local self_gear_game_object_id = network_manager:game_object_id(self._unit)
			local direction_id = NetworkLookup.weapon_hit_parameters[attack_name]
			local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]

			damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
			raw_damage = math.clamp(raw_damage, NetworkConstants.damage.min, NetworkConstants.damage.max)

			local num_actors = Unit.num_actors(hit_unit)
			local actor_index = 0

			for i = 0, num_actors - 1 do
				if Unit.actor(hit_unit, i) == actor then
					actor_index = i

					break
				end
			end

			if position and normal then
				if Managers.lobby.server then
					network_manager:send_rpc_clients("rpc_weapon_impact_character", hit_unit_game_object_id, self_gear_game_object_id, target_type_id, direction_id, stun, damage, raw_damage, NetworkLookup.hit_zones[hit_zone] or 0, position, normal, impact_direction, weapon_damage_direction, interrupt, actor_index)
				end
			elseif Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_wpn_impact_char_no_pos_norm", hit_unit_game_object_id, self_gear_game_object_id, target_type_id, direction_id, stun, damage, raw_damage, NetworkLookup.hit_zones[hit_zone] or 0, impact_direction, interrupt)
			end
		end

		if Managers.lobby.server or GameSettingsDevelopment.tutorial_mode then
			WeaponHelper:apply_damage(self._world, self._user_unit, self._unit, hit_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction, self._properties, real_damage, riposte)
		end
	end

	return abort
end

function WeaponMelee:_fully_charged_attack(current_attack)
	local attack_name = current_attack.attack_name
	local attack_settings = current_attack.attack_settings

	return attack_name == "couch" or current_attack.charge_factor > 0.95
end

function WeaponMelee:_push_hit_character(hit_unit, position, normal, actor, hit_zone, impact_direction)
	local current_attack = self._current_attack
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local world = self._world
	local unit = self._unit
	local user_unit = self._user_unit
	local raw_damage, damage_type, damage, damage_range_type, _ = WeaponHelper:add_perk_attack_damage(world, user_unit, unit, hit_unit, position, normal, actor, hit_zone, false, current_attack, impact_direction)

	damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)

	if raw_damage then
		WeaponHelper:apply_damage(world, user_unit, unit, hit_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction)
	end

	WeaponHelper:push_impact_character(hit_unit, damage, position, normal, world, hit_zone, impact_direction)

	if game and self._game_object_id then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_push_impact_character", self._game_object_id, network_manager:game_object_id(hit_unit), damage, position, normal, NetworkLookup.hit_zones[hit_zone], impact_direction, false)
		else
			network_manager:send_rpc_server("rpc_push_impact_character", self._game_object_id, network_manager:game_object_id(hit_unit), damage, position, normal, NetworkLookup.hit_zones[hit_zone], impact_direction, false)
		end
	end

	return false
end

function WeaponMelee:_pommel_bash_hit_character(hit_unit, position, normal, actor, hit_zone, impact_direction, interpolated_attack_time)
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local raw_damage = self:_add_damage(hit_unit, position, normal, actor, hit_zone, false, self._current_attack, impact_direction, nil, interpolated_attack_time)

	if raw_damage and game and self._game_object_id then
		if Managers.lobby.server then
			local victim_player = Managers.player:owner(hit_unit)
			local damage = Unit.alive(hit_unit) and ScriptUnit.has_extension(hit_unit, "damage_system") and ScriptUnit.extension(hit_unit, "damage_system")

			if damage and not damage:is_knocked_down() and not damage:is_dead() then
				RPC.rpc_pommel_bash_impact_character(victim_player:network_id(), network_manager:game_object_id(hit_unit), position, normal, NetworkLookup.hit_zones[hit_zone], impact_direction)
			end
		else
			network_manager:send_rpc_server("rpc_pommel_bash_impact_character", network_manager:game_object_id(hit_unit), position, normal, NetworkLookup.hit_zones[hit_zone], impact_direction)
		end
	end

	return false
end

function WeaponMelee:_hit_parrying_gear(target_type, gear_owner, hit_gear, position, normal, actor, impact_direction, interpolated_attack_time, no_damage)
	local current_attack = self._current_attack
	local attack_name = current_attack.attack_name
	local attack_settings = self._current_attack.attack_settings
	local fully_charged_attack = self:_fully_charged_attack(current_attack)
	local parry_direction = attack_settings.parry_direction
	local raw_damage, damage_type, damage, damage_range_type = self:_add_damage(hit_gear, position, normal, actor, nil, false, current_attack, impact_direction, nil, interpolated_attack_time)

	self:_abort_attack(target_type)

	if raw_damage then
		WeaponHelper:gear_impact(hit_gear, self._unit, target_type, attack_name, damage, raw_damage, position, normal, impact_direction, self._world, fully_charged_attack, parry_direction)

		local network_manager = Managers.state.network
		local game = network_manager:game()

		if game then
			local attack_name_id = NetworkLookup.weapon_hit_parameters[attack_name]
			local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]
			local hit_gear_game_object_id = network_manager:game_object_id(hit_gear)
			local self_gear_game_object_id = network_manager:game_object_id(self._unit)

			damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
			raw_damage = math.clamp(raw_damage, NetworkConstants.damage.min, NetworkConstants.damage.max)

			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_weapon_impact_gear", hit_gear_game_object_id, self_gear_game_object_id, target_type_id, attack_name_id, damage, raw_damage, fully_charged_attack, position, normal, impact_direction)
			end

			if false then
				-- block empty
			end
		end

		if not no_damage then
			WeaponHelper:apply_damage(self._world, self._user_unit, self._unit, hit_gear, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, nil, impact_direction, self._properties)
		end
	end

	return true
end

function WeaponMelee:_hit_blocking_gear(gear_owner, hit_gear, position, normal, actor, impact_direction, interpolated_attack_time, no_damage)
	local target_type = "blocking"
	local current_attack = self._current_attack
	local attack_name = current_attack.attack_name
	local attack_settings = current_attack.attack_settings
	local fully_charged_attack = self:_fully_charged_attack(current_attack)
	local raw_damage, damage_type, damage, damage_range_type, real_damage = self:_add_damage(hit_gear, position, normal, actor, nil, false, current_attack, impact_direction, 1, interpolated_attack_time)

	self:_abort_attack(target_type)

	if raw_damage then
		local network_manager = Managers.state.network
		local game = network_manager:game()

		WeaponHelper:gear_impact(hit_gear, self._unit, target_type, attack_name, damage, raw_damage, position, normal, impact_direction, self._world, fully_charged_attack)

		local user_locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")

		if user_locomotion:has_perk("heavy_02") then
			user_locomotion:set_perk_state("heavy_02", "active")
		end

		if game then
			local direction_id = NetworkLookup.weapon_hit_parameters[attack_name]
			local target_type_id = NetworkLookup.weapon_hit_parameters[target_type]
			local hit_gear_game_object_id = network_manager:game_object_id(hit_gear)
			local self_gear_game_object_id = network_manager:game_object_id(self._unit)

			damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
			raw_damage = math.clamp(raw_damage, NetworkConstants.damage.min, NetworkConstants.damage.max)

			if Managers.lobby.server then
				network_manager:send_rpc_clients("rpc_weapon_impact_gear", hit_gear_game_object_id, self_gear_game_object_id, target_type_id, direction_id, damage, raw_damage, fully_charged_attack, position, normal, impact_direction)
			end

			if false then
				-- block empty
			end
		end
	end

	if not no_damage then
		WeaponHelper:apply_damage(self._world, self._user_unit, self._unit, hit_gear, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, nil, impact_direction, self._properties)
	end

	return true
end

function WeaponMelee:_hit_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	if not self:_is_local_player() then
		return true
	end

	local target_type
	local current_attack = self._current_attack
	local attack_name = current_attack.attack_name
	local gear_settings = self._settings
	local material_effects_name = gear_settings.attacks[attack_name].impact_material_effects

	if material_effects_name then
		local impact_rotation = Quaternion.look(impact_direction, Quaternion.up(Unit.world_rotation(self._unit, 0)))

		EffectHelper.play_surface_material_effects(material_effects_name, self._world, hit_unit, position, impact_rotation, normal)

		if Managers.state.network:game() then
			EffectHelper.remote_play_surface_material_effects(material_effects_name, self._world, hit_unit, position, impact_rotation, normal)
		end
	end

	if Unit.get_data(hit_unit, "soft_target") then
		target_type = "soft"
	else
		target_type = "hard"

		self:_abort_attack(target_type)
	end

	local raw_damage, damage_type, damage, damage_range_type, real_damage = self:_add_damage(hit_unit, position, normal, actor, nil, true, current_attack, impact_direction, nil, interpolated_attack_time)

	self:_play_camera_impact(current_attack, damage)

	if target_type == "hard" then
		return true
	end
end

function WeaponMelee:_is_local_player()
	if not Managers.state.network._game then
		return true
	end

	local owner_unit = Unit.get_data(self._unit, "user_unit")
	local owner_player = Managers.player:owner(owner_unit)
	local local_player = Managers.state.network:player_from_peer_id(Network.peer_id())

	return owner_player == local_player
end

function WeaponMelee:_hit_non_damagable_prop(hit_unit, position, normal, actor, impact_direction, interpolated_attack_time)
	if not self:_is_local_player() then
		return true
	end

	local gear_owner = self._player
	local gear_name = Unit.get_data(self._unit, "gear_name")

	Managers.state.stats_collector:weapon_missed(gear_owner, gear_name)

	local current_attack = self._current_attack
	local material_effects_name = current_attack.attack_settings.impact_material_effects

	if material_effects_name then
		local impact_rotation = Quaternion.look(impact_direction, Quaternion.up(Unit.world_rotation(self._unit, 0)))

		EffectHelper.play_surface_material_effects(material_effects_name, self._world, hit_unit, position, impact_rotation, normal)

		if Managers.state.network:game() then
			EffectHelper.remote_play_surface_material_effects(material_effects_name, self._world, hit_unit, position, impact_rotation, normal)
		end
	end

	if position and normal then
		Unit.set_flow_variable(self._unit, "lua_hit_position", position)

		local rotation = Quaternion.look(normal, Vector3.up())

		Unit.set_flow_variable(self._unit, "lua_hit_rotation", rotation)
	end

	if not Unit.get_data(hit_unit, "soft_target") then
		local raw_damage, damage_type, damage, damage_range_type, real_damage = self:_add_damage(hit_unit, position, normal, actor, nil, false, current_attack, impact_direction, nil, interpolated_attack_time)

		self:_abort_attack("hard")
		self:_play_camera_impact(current_attack, 0)

		return true
	end
end

function WeaponMelee:_add_damage(victim_unit, position, normal, actor, hit_zone, apply_damage, current_attack, impact_direction, damage_multiplier, interpolated_attack_time)
	Profiler.start("WeaponMelee:_add_damage")

	local victim_hits_table = current_attack.hits[victim_unit]
	local unit = self._unit
	local attack_settings = current_attack.attack_settings
	local sweep_progression = WeaponHelper:calculate_sweep_progression(current_attack)
	local _, _, absorption_value = WeaponHelper:_armour_values(victim_unit, hit_zone)
	local damage_range_type = attack_settings.damage_range_type
	local hit_characters = current_attack.hit_characters
	local damage, raw_damage = self:_calculate_damage(attack_settings, current_attack.charge_factor, sweep_progression, absorption_value, damage_multiplier, hit_characters, hit_zone, victim_unit)
	local real_damage = damage

	if not victim_hits_table then
		victim_hits_table = {
			damage = damage,
			hit_zones = {}
		}
		current_attack.hits[victim_unit] = victim_hits_table

		local nullify_type = SquadSettings.nullify_friendly_fire

		if not nullify_type or not SquadSettings[nullify_type](self._player, victim_unit) then
			current_attack.hit_characters = hit_characters + 1
		end
	else
		local current_damage = victim_hits_table.damage

		if current_damage < damage then
			victim_hits_table.damage = damage
			damage = damage - current_damage
		else
			self:_mark_zones_hit(victim_hits_table, hit_zone)
			Profiler.stop()

			return
		end
	end

	self:_mark_zones_hit(victim_hits_table, hit_zone)

	local damage_type = self:_damage_type(attack_settings)

	if apply_damage then
		WeaponHelper:apply_damage(self._world, self._user_unit, self._unit, victim_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction, self._properties, real_damage)
	end

	Profiler.stop()

	return raw_damage, damage_type, damage, damage_range_type, real_damage
end

function WeaponMelee:_mark_zones_hit(hits_table, hit_zone)
	if hit_zone == "helmet" or hit_zone == "head" then
		hits_table.hit_zones.head = true
		hits_table.hit_zones.helmet = true
	elseif hit_zone then
		hits_table.hit_zones.head = true
		hits_table.hit_zones[hit_zone] = true
	end
end

function WeaponMelee:_calculate_damage(attack_settings, charge_value, sweep_progression, absorption_value, damage_multiplier, hit_characters, hit_zone_name, victim_unit)
	local base_uncharged_damage = attack_settings.uncharged_damage
	local base_charged_damage = attack_settings.charged_damage
	local hit_zones = Unit.get_data(victim_unit, "hit_zone_lookup_table")
	local hit_zone = hit_zones and hit_zones[hit_zone_name]
	local hit_zone_multiplier = hit_zone and hit_zone.damage_multiplier or 1
	local progression_multiplier = attack_settings.progression_multiplier_func and attack_settings.progression_multiplier_func(sweep_progression) or 1
	local multiple_hit_multiplier = PlayerUnitDamageSettings.MULTIPLE_HIT_MULTIPLIER^hit_characters
	local weapon_damage = math.lerp(base_uncharged_damage, base_charged_damage, charge_value)
	local damage_ext = Unit.alive(self._user_unit) and ScriptUnit.extension(self._user_unit, "damage_system")
	local is_last_stand_active = damage_ext and damage_ext:is_last_stand_active()
	local last_stand_multiplier = is_last_stand_active and Perks.last_stand.damage_multiplier or 1
	local damage_without_armour = weapon_damage * progression_multiplier * hit_zone_multiplier * (damage_multiplier or 1) * multiple_hit_multiplier * last_stand_multiplier
	local damage = damage_without_armour - damage_without_armour * absorption_value

	if script_data.damage_debug then
		self:_print_damage_debug(damage, damage_without_armour, weapon_damage, base_uncharged_damage, base_charged_damage, charge_value, progression_multiplier, hit_zone_name, hit_zone_multiplier, damage_multiplier, multiple_hit_multiplier, absorption_value)
	end

	return damage, damage_without_armour
end

function WeaponMelee:_print_damage_debug(damage, damage_without_armour, weapon_damage, base_uncharged_damage, base_charged_damage, charge_value, progression_multiplier, hit_zone_name, hit_zone_multiplier, damage_multiplier, multiple_hit_multiplier, absorption_value)
	printf("NET DAMAGE(%.2f) = RAW DAMAGE(%.2f) - RAW DAMAGE(%.2f)*ARMOUR(%.2f)", damage, damage_without_armour, damage_without_armour, absorption_value)

	if damage_multiplier then
		printf("raw damage(%.2f) = weapon_damage(%.2f) * progression(%.2f) * hit zone(%s %.2f) * external muliplier(%.2f) * multiple hit(%.2f)", damage_without_armour, weapon_damage, progression_multiplier, hit_zone_name, hit_zone_multiplier, damage_multiplier, multiple_hit_multiplier)
	else
		printf("raw damage(%.2f) = weapon_damage(%.2f) * progression(%.2f) * hit zone(%s %.2f) * multiple hit(%.2f)", damage_without_armour, weapon_damage, progression_multiplier, hit_zone_name, hit_zone_multiplier, multiple_hit_multiplier)
	end

	printf("weapon_damage(%.2f) = lerp(uncharged_damage(%.2f), charged_damage(%.2f), charge_value(%.2f))", weapon_damage, base_uncharged_damage, base_charged_damage, charge_value)
end

function WeaponMelee:_damage_type(attack)
	return attack.damage_type
end

function WeaponMelee:_debug_draw_weapon_velocity()
	local unit = self._unit
	local current_attack = self._current_attack
	local attack_name = current_attack.attack_name
	local velocity = WeaponHelper:melee_weapon_velocity(unit, attack_name, current_attack.attack_time, current_attack.attack_duration)
	local speed = Vector3.length(velocity)
	local speed_max = self._attacks[attack_name].speed_max
	local color = Color(255, 255 - speed / speed_max * 255, 0)
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "DEBUG_DRAW_WEAPON_VELOCITY" .. tostring(unit)
	})
	local pos = Unit.world_position(unit, 0)
	local attack_settings = current_attack.attack_settings
	local sweep_data = attack_settings and attack_settings.sweep

	if sweep_data then
		pos = (Unit.world_position(unit, Unit.node(unit, sweep_data.inner_node)) + Unit.world_position(unit, Unit.node(unit, sweep_data.outer_node))) * 0.5
	end

	drawer:vector(pos, 0.1 * Vector3.normalize(velocity), color)
end

function WeaponMelee:hot_join_synch(sender, player, player_object_id, slot_name)
	return
end

function WeaponMelee:enter_ghost_mode()
	return
end

function WeaponMelee:exit_ghost_mode()
	self:_disable_hit_collision()
end

function WeaponMelee:parry(direction, block_time, max_delay)
	if not self._ai_gear then
		local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
		local rot_angle = 0

		if direction == "down" then
			rot_angle = math.pi
		elseif direction == "left" then
			rot_angle = math.pi / 2
		elseif direction == "right" then
			rot_angle = math.pi / 2 * 3
		end

		locomotion.parry_helper_blackboard.parry_direction = rot_angle
		locomotion.parry_helper_blackboard.parry_direction_string = "parry_" .. direction
		locomotion.parry_helper_blackboard.parry_direction_delay_time = block_time
	end
end

function WeaponMelee:stop_parry()
	if not self._ai_gear then
		local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")

		locomotion.parry_helper_blackboard.parry_direction = nil
		locomotion.parry_helper_blackboard.parry_direction_string = nil
	end
end

function WeaponMelee:player_dead()
	if not self._ammo_blackboard_destroyed then
		self:_clean_up_ammo_blackboard()
	end
end

function WeaponMelee:_clean_up_ammo_blackboard()
	self._ammo_blackboard_destroyed = true

	if self._ammo_blackboard.texture then
		Managers.state.event:trigger("ammo_weapon_despawned", self._player, self._user_unit, self._ammo_blackboard)
	end
end

function WeaponMelee:destroy()
	if not self._ammo_blackboard_destroyed then
		self:_clean_up_ammo_blackboard()
	end
end
