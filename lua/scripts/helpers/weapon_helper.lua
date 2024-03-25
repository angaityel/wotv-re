-- chunkname: @scripts/helpers/weapon_helper.lua

require("scripts/helpers/effect_helper")
require("scripts/helpers/effect_helper")

WeaponHelper = WeaponHelper or {}

function WeaponHelper:locomotion_velocity(u)
	local unit = Unit.has_data(u, "user_unit") and Unit.get_data(u, "user_unit") or u
	local velocity = Vector3(0, 0, 0)

	if Unit.alive(unit) then
		local has_locomotion = ScriptUnit.has_extension(unit, "locomotion_system")

		if has_locomotion then
			velocity = ScriptUnit.extension(unit, "locomotion_system"):get_velocity()
		end
	end

	return velocity
end

function WeaponHelper:gear_impact(hit_gear_unit, gear_unit, target_type, attack_name, damage, damage_without_armour, position, normal, impact_direction, world, fully_charged_attack, parry_direction)
	local hit_gear_owner_unit = Unit.get_data(hit_gear_unit, "user_unit")
	local gear_owner_unit = Unit.get_data(gear_unit, "user_unit")

	if self:skip_impact_effect(hit_gear_owner_unit, gear_unit) then
		return
	end

	local rotation

	if position and normal then
		rotation = Quaternion.look(normal, Vector3.up())
	else
		position = Unit.world_position(gear_unit, 0) + 0.75 * Quaternion.up(Unit.world_rotation(gear_unit, 0))
		rotation = Quaternion.identity()
	end

	Unit.set_flow_variable(gear_unit, "lua_hit_position", position)
	Unit.set_flow_variable(gear_unit, "lua_hit_rotation", rotation)

	local locomotion = ScriptUnit.extension(hit_gear_owner_unit, "locomotion_system")

	if target_type == "blocking" and hit_gear_unit then
		local dropped = Unit.get_data(hit_gear_unit, "dropped")

		if not dropped then
			local damage_ext = ScriptUnit.extension(hit_gear_owner_unit, "damage_system")
			local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
			local dead = damage_ext:is_dead()

			if not kd and not dead then
				Unit.flow_event(gear_unit, "lua_hit_blocking_target")
				Unit.flow_event(gear_unit, "lua_hit_blocking_target_" .. attack_name)
				Unit.animation_event(hit_gear_owner_unit, "hit_reaction_shield_impact")
				locomotion:gear_impact("block", damage_without_armour, impact_direction, attack_name, gear_owner_unit, gear_unit)
				Managers.state.event:trigger("player_blocked", hit_gear_unit, gear_unit, fully_charged_attack)
			end
		end
	elseif target_type == "parrying" then
		Unit.flow_event(gear_unit, "lua_hit_parrying_target")
		Unit.flow_event(gear_unit, "lua_hit_parrying_target_" .. parry_direction)
		Unit.animation_event(hit_gear_owner_unit, "hit_reaction_parry_impact_" .. parry_direction)
		locomotion:gear_impact("parry", damage_without_armour, impact_direction, attack_name, gear_owner_unit, gear_unit)
		Managers.state.event:trigger("player_parried", hit_gear_unit, gear_unit, fully_charged_attack)
	elseif target_type == "dual_wield_defending" then
		Unit.flow_event(gear_unit, "lua_hit_parrying_target")
		Unit.flow_event(gear_unit, "lua_hit_parrying_target_left")
		Unit.animation_event(hit_gear_owner_unit, "hit_reaction_parry_impact")
		locomotion:gear_impact("dual_wield_defend", damage_without_armour, impact_direction, attack_name, gear_owner_unit, gear_unit)
		Managers.state.event:trigger("player_parried", hit_gear_unit, gear_unit, fully_charged_attack)
	else
		ferror("[WeaponHelper:gear_impact()]Incorrect target type '%s'", target_type)
	end

	self:_hit_sound_event(world, gear_unit, hit_gear_unit, "gear", damage, damage_without_armour, attack_name)
end

function WeaponHelper:destroy_blocking_gear(gear_unit)
	local damage_extension = ScriptUnit.has_extension(gear_unit, "damage_system") and ScriptUnit.extension(gear_unit, "damage_system")

	if damage_extension then
		damage_extension:die()
	end
end

function WeaponHelper:shield_impact_character(hit_character_unit, damage, position, normal, world, hit_zone, impact_direction)
	self:_player_hit_by_damaging_source(hit_character_unit, damage)

	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		locomotion_ext:stun(hit_zone, impact_direction, "shield_bash_impact")
	end
end

function WeaponHelper:push_impact_character(hit_character_unit, position, normal, world, impact_direction, scaled)
	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		if scaled then
			locomotion_ext:stun(nil, impact_direction, "push_impact_scaled")
		else
			locomotion_ext:stun(nil, impact_direction, "push_impact")
		end
	end
end

function WeaponHelper:rush_impact_character(hit_character_unit, position, normal, world, impact_direction, aggressor_unit)
	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		locomotion_ext:stun(nil, impact_direction, "rush_impact")
	end

	Managers.state.event:trigger("rush_impact_character", aggressor_unit, hit_character_unit)
end

function WeaponHelper:mount_impact_character(hit_character_unit, damage_without_armour, position, normal, world, hit_zone, impact_direction)
	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		locomotion_ext:stun(hit_zone, impact_direction, "mount_impact")
	end
end

function WeaponHelper:skip_impact_effect(unit1, unit2)
	local immediate_hit_effects = Application.user_setting("immediate_hit_effects")
	local network_manager = Managers.state.network

	if not network_manager._game then
		return false
	end

	if Managers.lobby.server then
		return false
	end

	local unit1_id = network_manager:game_object_id(unit1)
	local unit2_id = network_manager:game_object_id(unit2)
	local owner_unit = Unit.get_data(unit2, "user_unit")
	local player
	local ping = 0

	if owner_unit then
		player = Managers.player:owner(owner_unit)

		if player then
			if player.remote or player.ai_player then
				return false
			end

			local server_id = network_manager._lobby:game_session_host()
			local ping = Network.ping(server_id) or 0

			if not immediate_hit_effects or ping > 0.1 then
				return self:is_hit_confirmed(player, unit1_id, unit2_id)
			end

			return self:already_played_impact_effect(player, unit1_id, unit2_id, ping)
		end
	end

	return false
end

function WeaponHelper:already_played_impact_effect(player, unit1_id, unit2_id, ping)
	if Managers.lobby.server then
		return true
	end

	local hit_id = unit1_id * 10000 + unit2_id
	local last_hit_id = player._last_hit_id or 0
	local t = Managers.time:time("main")
	local last_hit_time = player._last_hit_time or 0

	if hit_id == last_hit_id and t < last_hit_time + ping + 0.2 then
		player._last_hit_id = 0
		player._last_hit_time = 0

		return true
	end

	player._last_hit_id = unit1_id * 10000 + unit2_id
	player._last_hit_time = t

	return false
end

function WeaponHelper:is_hit_confirmed(player, unit1_id, unit2_id)
	local hit_id = unit1_id
	local last_hit_id = player._last_hit_id or 0

	if hit_id ~= last_hit_id then
		player._last_hit_id = hit_id

		return true
	end

	player._last_hit_id = 0

	return false
end

function WeaponHelper:weapon_impact_character(hit_character_unit, gear_unit, target_type, direction, stun, damage, damage_without_armour, position, normal, world, hit_zone, impact_direction, weapon_damage_direction, interrupt, actor)
	if self:skip_impact_effect(hit_character_unit, gear_unit) then
		return
	end

	self:_player_hit_by_damaging_source(hit_character_unit, damage, impact_direction)

	local gear_owner_unit = Unit.get_data(gear_unit, "user_unit")
	local attacking_player = Managers.player:owner(gear_owner_unit)
	local hit_player = Managers.player:owner(hit_character_unit)

	Managers.state.event:trigger("add_wound", hit_character_unit, actor)
	Managers.state.event:trigger("spawn_blood_ball", position, impact_direction, hit_player)
	Managers.state.event:trigger("fighting_blood", attacking_player, "hit")

	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if stun and not kd and not dead then
		locomotion_ext:stun(hit_zone, impact_direction, "melee_damage")
	elseif not kd and not dead and target_type ~= "not_penetrated" and not self:_perks_stopping_damage_interupt(hit_character_unit, damage, position, attacking_player, "melee_damage") and interrupt then
		locomotion_ext:damage_interrupt(hit_zone, impact_direction, "melee_damage", attacking_player)
	end

	local rotation

	if position and normal then
		rotation = Quaternion.look(normal, Vector3.up())
	else
		position = Unit.world_position(gear_unit, 0) + 0.75 * Quaternion.up(Unit.world_rotation(gear_unit, 0))
		rotation = Quaternion.identity()
	end

	Unit.set_flow_variable(gear_unit, "lua_hit_position", position)
	Unit.set_flow_variable(gear_unit, "lua_hit_rotation", rotation)
	Unit.flow_event(gear_unit, "lua_hit_soft_target")
	Unit.flow_event(gear_unit, "lua_hit_soft_target_" .. direction)
	self:_blood_trail(world, gear_unit, position, rotation, weapon_damage_direction)
	self:_blood_splat_decal(world, position, impact_direction)
	self:_hit_sound_event(world, gear_unit, hit_character_unit, "character", damage, damage_without_armour, direction)
	self:_hurt_sound_event(hit_character_unit, damage, world, gear_owner_unit)
end

function WeaponHelper:_perks_stopping_damage_interupt(hit_unit, damage, position, attacking_player, impact_type)
	local locomotion_ext = ScriptUnit.extension(hit_unit, "locomotion_system")
	local posing_or_swinging_or_blocking_or_parry = locomotion_ext.posing or locomotion_ext.attempting_pose or locomotion_ext.pose_ready or locomotion_ext.swinging or locomotion_ext.blocking or locomotion_ext.parrying or locomotion_ext.attempting_parry

	if locomotion_ext:has_perk("heavy_02") and impact_type == "projectile_damage" and posing_or_swinging_or_blocking_or_parry and damage < Perks.heavy_02.damage_interupt_threshold then
		local player = Managers.player:owner(hit_unit)

		if player and not player.remote then
			locomotion_ext:set_perk_state("heavy_02", "active")
		end

		Managers.state.event:trigger("show_perk_text", attacking_player, Perks.heavy_02.combat_text, position)

		return true
	elseif locomotion_ext:has_perk("no_knockdown") and locomotion_ext:in_travel_mode() then
		local player = Managers.player:owner(hit_unit)

		if player and not player.remote then
			locomotion_ext:set_perk_state("no_knockdown", "active")
		end

		Managers.state.event:trigger("show_perk_text", attacking_player, Perks.no_knockdown.combat_text, position)

		return true
	end

	return false
end

function WeaponHelper:_blood_trail(world, unit, position, rotation, weapon_damage_direction)
	local unit_rot = Unit.world_rotation(unit, 0)
	local unit_pos = Unit.world_position(unit, 0)
	local offset_pos = position - unit_pos
	local local_offset_pos = Vector3(Vector3.dot(Quaternion.right(unit_rot), offset_pos), Vector3.dot(Quaternion.forward(unit_rot), offset_pos), Vector3.dot(Quaternion.up(unit_rot), offset_pos))
	local local_offset_rotation = Quaternion.look(weapon_damage_direction, Vector3.up())
	local pose = Matrix4x4.from_quaternion_position(local_offset_rotation, local_offset_pos)
	local trail_effect_name = "fx/impact_blood_weapon_trail"
	local impact_effect_name = "fx/impact_blood"

	ScriptWorld.create_particles_linked(world, trail_effect_name, unit, 0, "stop", pose)
	World.create_particles(world, impact_effect_name, position, rotation)
end

function WeaponHelper:handgonne_impact_character(hit_character_unit, position, damage, world, stun, hit_zone, impact_direction)
	self:_player_hit_by_damaging_source(hit_character_unit, damage)

	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
	local dead = damage_ext:is_dead()

	if stun and not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		locomotion_ext:stun(hit_zone, impact_direction, "projectile_damage")
	elseif not kd and not dead then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")

		locomotion_ext:damage_interrupt(hit_zone, impact_direction, "projectile_damage")
	end

	local armour_type = Unit.get_data(hit_character_unit, "armour_type")

	if not armour_type then
		return
	end

	local armour_type_short

	if string.sub(armour_type, 0, string.len("weapon_")) == "weapon_" then
		armour_type_short = string.sub(armour_type, string.len("weapon_") + 1)
	elseif string.sub(armour_type, 0, string.len("armour_")) == "armour_" then
		armour_type_short = string.sub(armour_type, string.len("armour_") + 1)
	end

	if armour_type_short then
		local timpani_world = World.timpani_world(world)
		local event_id = TimpaniWorld.trigger_event(timpani_world, "bullet_hit", position)

		TimpaniWorld.set_parameter(timpani_world, event_id, "armour_type", armour_type_short)
	end

	self:_hurt_sound_event(hit_character_unit, damage, world)

	local effect_name = "fx/impact_blood"

	World.create_particles(world, effect_name, position)
end

function WeaponHelper:projectile_impact(world, hit_unit, projectile_unit, player, position, rotation, damage, penetrated, target_type, hit_zone, impact_direction, normal, stun, gear_sound_type, is_husk, actor)
	if target_type == "character" then
		self:_player_hit_by_damaging_source(hit_unit, damage)

		local damage_ext = ScriptUnit.extension(hit_unit, "damage_system")
		local kd = damage_ext.is_knocked_down and damage_ext:is_knocked_down()
		local dead = damage_ext:is_dead()
		local hit_player = Managers.player:owner(hit_unit)

		Managers.state.event:trigger("add_wound", hit_unit, actor)
		Managers.state.event:trigger("spawn_blood_ball", position, impact_direction, hit_player)

		local opposing_teams = hit_player and hit_player.team and player and player.team and player.team ~= hit_player.team

		if stun and not kd and not dead and opposing_teams then
			local locomotion_ext = ScriptUnit.extension(hit_unit, "locomotion_system")

			locomotion_ext:stun(hit_zone, impact_direction, "projectile_damage")
		elseif not kd and not dead and opposing_teams then
			local locomotion_ext = ScriptUnit.extension(hit_unit, "locomotion_system")

			if not self:_perks_stopping_damage_interupt(hit_unit, damage, position, player, "projectile_damage") then
				locomotion_ext:damage_interrupt(hit_zone, impact_direction, "projectile_damage", player)
			end
		end

		World.create_particles(world, "fx/impact_blood", position)
		self:_hurt_sound_event(hit_unit, damage, world)
		self:_projectile_impact_sound_event(hit_unit, position, penetrated, player, world, hit_zone, gear_sound_type)
		Managers.state.event:trigger("event_hit_marker_activated", player, Managers.player:owner(hit_unit))
	elseif target_type == "blocking_gear" then
		World.create_particles(world, "fx/sword_sparks", position)
		self:_projectile_impact_sound_event(hit_unit, position, penetrated, player, world, hit_zone, gear_sound_type)

		local gear_owner_unit = Unit.get_data(hit_unit, "user_unit")

		Unit.animation_event(gear_owner_unit, "hit_reaction_shield_impact")
	elseif target_type == "gear" then
		World.create_particles(world, "fx/sword_sparks", position)
		self:_projectile_impact_sound_event(hit_unit, position, penetrated, player, world, hit_zone, gear_sound_type)
	elseif target_type == "prop" then
		local effect_name = gear_sound_type .. "_projectile_impact" .. (is_husk and "_husk" or "")

		EffectHelper.play_surface_material_effects(effect_name, world, hit_unit, position, rotation, normal)
	end

	Unit.flow_event(projectile_unit, "lua_hit_target")
end

function WeaponHelper:_projectile_impact_sound_event(hit_unit, position, penetrated, player, world, hit_zone, gear_sound_type)
	local timpani_world = World.timpani_world(world)
	local is_local_player = player and not player.remote and not player.ai_player

	if is_local_player then
		local event

		event = not (hit_zone ~= "head" and hit_zone ~= "helmet") and "projectile_hit_headshot" or "projectile_hit_feedback"

		local event_id = TimpaniWorld.trigger_event(timpani_world, event)
	end

	local armour_type = Unit.get_data(hit_unit, "armour_type")

	if not armour_type then
		return
	end

	local armour_type_short = self:_armour_type_sound_parameter(hit_unit)
	local event_name
	local victim = Managers.player:owner(Unit.get_data(hit_unit, "user_unit") or hit_unit)
	local victim_is_local_player = victim and not victim.remote and not victim.ai_player

	event_name = is_local_player and "projectile_hit" or victim_is_local_player and "projectile_hit_self" or "projectile_hit_husk"

	local event_id = TimpaniWorld.trigger_event(timpani_world, event_name, position)

	TimpaniWorld.set_parameter(timpani_world, event_id, "armour_type", armour_type_short)
	TimpaniWorld.set_parameter(timpani_world, event_id, "weapon_type", gear_sound_type)

	if hit_zone then
		TimpaniWorld.set_parameter(timpani_world, event_id, "hit_zone", hit_zone)
	end

	if script_data.sound_debug then
		print("projectile impact sound:", event_name, armour_type_short, gear_sound_type)
	end
end

function WeaponHelper:_hurt_sound_event(hit_character_unit, damage, world, attacker_unit)
	local timpani_world = World.timpani_world(world)
	local damage_level = "light"

	if damage > DamageLevels.penetrated.heavy then
		damage_level = "heavy"
	elseif damage > DamageLevels.penetrated.medium then
		damage_level = "medium"
	end

	local function play_sound(unit, locomotion_ext, event_name)
		local hit_unit_position = Unit.world_position(unit, 0)
		local event_id = TimpaniWorld.trigger_event(timpani_world, event_name, hit_unit_position)

		TimpaniWorld.set_parameter(timpani_world, event_id, "damage", damage_level)
		TimpaniWorld.set_parameter(timpani_world, event_id, "character_vo", locomotion_ext:inventory():voice())
	end

	local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")
	local damage_ext = ScriptUnit.extension(hit_character_unit, "damage_system")
	local event_name = locomotion_ext:hurt_sound_event()

	if event_name and not damage_ext:is_dead() then
		play_sound(hit_character_unit, locomotion_ext, event_name)
	end
end

function WeaponHelper:_blood_splat_decal(world, raycast_position, raycast_direction)
	local physics_world = World.physics_world(world)
	local hit_cb = callback(self, "_blood_splat_decal_raycast_result", raycast_direction, world)
	local max_range = MaterialEffectSettings.blood_splat_raycast_max_range

	PhysicsWorld.make_raycast(physics_world, hit_cb, "closest", "types", "statics"):cast(raycast_position, raycast_direction, max_range, world)

	if script_data.debug_material_effects then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
		})

		drawer:vector(raycast_position, raycast_direction * 0.5, Color(0, 255, 0))
		drawer:sphere(raycast_position, 0.05, Color(0, 255, 0))
	end
end

function WeaponHelper:_blood_splat_decal_raycast_result(raycast_direction, world, hit, position, distance, normal, actor)
	if hit and actor then
		local unit = Actor.unit(actor)
		local rotation = Quaternion.look(-normal, Vector3.up())

		EffectHelper.play_surface_material_effects("blood_splat", world, unit, position, rotation, normal)
	elseif hit then
		print("[WeaponHelper] ERROR! Trying to project blood decal and got hit without getting actor.")
	end
end

function WeaponHelper:_player_hit_by_damaging_source(hit_character_unit, damage, impact_direction)
	if damage > 0 then
		local locomotion_ext = ScriptUnit.extension(hit_character_unit, "locomotion_system")
		local front_back, direction

		if impact_direction then
			front_back, direction = self:_impact_direction_strings(hit_character_unit, impact_direction)
		end

		locomotion_ext:received_damage(damage, front_back, direction)
	end
end

local UP_HIT_REACTION_THRESHOLD = -math.sin(math.pi * 0.25)
local SIDE_HIT_REACTION_THRESHOLD = math.cos(math.pi * 0.3333)
local HIT_REACTION_ANIM_EVENTS = {
	front = {
		helmet = {
			down = "hurt_front_head_down",
			up = "hurt_front_head_up",
			left = "hurt_front_head_left",
			right = "hurt_front_head_right"
		},
		head = {
			down = "hurt_front_head_down",
			up = "hurt_front_head_up",
			left = "hurt_front_head_left",
			right = "hurt_front_head_right"
		},
		torso = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		stomach = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		arms = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		forearms = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		legs = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		hands = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		feet = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		calfs = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		}
	},
	back = {
		helmet = {
			down = "hurt_back_head_down",
			up = "hurt_back_head_up",
			left = "hurt_back_head_left",
			right = "hurt_back_head_right"
		},
		head = {
			down = "hurt_back_head_down",
			up = "hurt_back_head_up",
			left = "hurt_back_head_left",
			right = "hurt_back_head_right"
		},
		torso = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		stomach = {
			down = "hurt_front_torso_down",
			up = "hurt_front_torso_up",
			left = "hurt_front_torso_left",
			right = "hurt_front_torso_right"
		},
		arms = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		forearms = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		legs = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		hands = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		feet = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		},
		calfs = {
			down = "hurt_back_torso_down",
			up = "hurt_back_torso_up",
			left = "hurt_back_torso_left",
			right = "hurt_back_torso_right"
		}
	}
}
local UP_STUN_THRESHOLD = -math.sin(math.pi * 0.25)
local SIDE_STUN_THRESHOLD = math.cos(math.pi * 0.33)
local STUN_ANIM_EVENTS = {
	front = {
		rush_impact_travel_mode = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			}
		},
		travel_mode_damage = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			}
		},
		mounted_stun_dismount = {
			up = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			down = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			left = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			right = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			}
		},
		mount_impact_slow = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		mount_impact_fast = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		shield_bash_impact = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			}
		},
		push_impact = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun_push.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(0, -1, 0)
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(1, 0, 0)
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(-1, 0, 0)
			}
		},
		rush_impact = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitMovementSettings.rush.stun_front_duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitMovementSettings.rush.stun_front_duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitMovementSettings.rush.stun_front_duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitMovementSettings.rush.stun_front_duration
			}
		},
		head = {
			up = {
				event = "stun_front_head_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_head_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_head_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_head_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		helmet = {
			up = {
				event = "stun_front_head_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_head_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_head_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_head_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		torso = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		stomach = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		arms = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		forearms = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		legs = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		hands = {
			up = {
				event = "stun_front_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		feet = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		calfs = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_front_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_front_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		}
	},
	back = {
		mounted_stun_dismount = {
			up = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			down = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			left = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			},
			right = {
				event = "mounted_stun_land",
				duration = PlayerUnitDamageSettings.stun_dismount.duration
			}
		},
		mount_impact_slow = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		travel_mode_damage = {
			up = {
				event = "stun_back_legs_up",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			down = {
				event = "stun_back_legs_down",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			left = {
				event = "stun_back_legs_left",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			},
			right = {
				event = "stun_back_legs_right",
				duration = PlayerUnitMovementSettings.travel_mode.damage_stun_duration
			}
		},
		mount_impact_fast = {
			up = {
				event = "stun_back_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		shield_bash_impact = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun_shield_bash.duration
			}
		},
		push_impact = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun_push.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(0, 1, 0)
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(1, 0, 0)
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun_push.duration,
				forward_direction = Vector3Box(-1, 0, 0)
			}
		},
		rush_impact = {
			up = {
				event = "stun_front_legs_up",
				duration = PlayerUnitMovementSettings.rush.stun_back_duration
			},
			down = {
				event = "stun_front_legs_down",
				duration = PlayerUnitMovementSettings.rush.stun_back_duration
			},
			left = {
				event = "stun_front_legs_right",
				duration = PlayerUnitMovementSettings.rush.stun_back_duration
			},
			right = {
				event = "stun_front_legs_left",
				duration = PlayerUnitMovementSettings.rush.stun_back_duration
			}
		},
		rush_impact_travel_mode = {
			up = {
				event = "stun_travel_back",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			down = {
				event = "stun_travel_back",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			left = {
				event = "stun_travel_back",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			},
			right = {
				event = "stun_travel_back",
				duration = PlayerUnitMovementSettings.travel_mode.tackle_stun_duration
			}
		},
		head = {
			up = {
				event = "stun_back_head_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_head_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_head_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_head_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		helmet = {
			up = {
				event = "stun_back_head_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_head_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_head_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_head_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		torso = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		stomach = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		arms = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		forearms = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		legs = {
			up = {
				event = "stun_back_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		hands = {
			up = {
				event = "stun_back_torso_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_torso_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_torso_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_torso_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		feet = {
			up = {
				event = "stun_back_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		},
		calfs = {
			up = {
				event = "stun_back_legs_up",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			down = {
				event = "stun_back_legs_down",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			left = {
				event = "stun_back_legs_left",
				duration = PlayerUnitDamageSettings.stun.duration
			},
			right = {
				event = "stun_back_legs_right",
				duration = PlayerUnitDamageSettings.stun.duration
			}
		}
	}
}

function WeaponHelper:player_unit_hit_reaction_animation(unit, hit_zone, impact_direction, aim_direction)
	if script_data.impact_direction_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})

		drawer:vector(Unit.world_position(unit, 0), impact_direction, Color(255, 0, 0))
	end

	local flat_aim_dir = Vector3.normalize(Vector3.flat(aim_direction))
	local flat_impact_dir = Vector3.normalize(Vector3.flat(impact_direction))
	local up = impact_direction.z < UP_HIT_REACTION_THRESHOLD
	local front_back = Vector3.dot(flat_impact_dir, flat_aim_dir) > 0 and "back" or "front"
	local anim_event

	if up then
		anim_event = HIT_REACTION_ANIM_EVENTS[front_back][hit_zone].up
	else
		local aim_right = Vector3.cross(flat_aim_dir, Vector3.up())
		local damage_dot = Vector3.dot(aim_right, flat_impact_dir)
		local direction = damage_dot > SIDE_HIT_REACTION_THRESHOLD and "left" or damage_dot < -SIDE_HIT_REACTION_THRESHOLD and "right" or "down"

		anim_event = HIT_REACTION_ANIM_EVENTS[front_back][hit_zone][direction]
	end

	Unit.animation_event(unit, anim_event)
end

function WeaponHelper:player_unit_stun_animation(unit, hit_zone, impact_direction)
	if script_data.impact_direction_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})

		drawer:vector(Unit.world_position(unit, 0), impact_direction, Color(255, 0, 0))
	end

	local unit_rot = Unit.world_rotation(unit, 0)
	local unit_forward = Quaternion.forward(unit_rot)
	local flat_impact_dir = Vector3.normalize(Vector3.flat(impact_direction))
	local up = impact_direction.z < UP_STUN_THRESHOLD
	local front_back = Vector3.dot(flat_impact_dir, unit_forward) > 0 and "back" or "front"
	local anim_event, anim_time, forward_direction

	if up then
		local stun = STUN_ANIM_EVENTS[front_back][hit_zone].up

		anim_event = stun.event
		anim_time = stun.duration
		forward_direction = stun.forward_direction
	else
		local unit_right = Quaternion.right(unit_rot)
		local damage_dot = Vector3.dot(unit_right, flat_impact_dir)
		local direction = damage_dot > SIDE_STUN_THRESHOLD and "left" or damage_dot < -SIDE_STUN_THRESHOLD and "right" or "down"
		local stun = STUN_ANIM_EVENTS[front_back][hit_zone][direction]

		anim_event = stun.event
		anim_time = stun.duration
		forward_direction = stun.forward_direction
	end

	return anim_event, anim_time, forward_direction
end

function WeaponHelper:_impact_direction_strings(unit, impact_direction)
	local unit_rot = Unit.world_rotation(unit, 0)
	local unit_forward = Quaternion.forward(unit_rot)
	local flat_impact_dir = Vector3.normalize(Vector3.flat(impact_direction))
	local unit_right = Quaternion.right(unit_rot)
	local damage_dot = Vector3.dot(unit_right, flat_impact_dir)
	local front_back = Vector3.dot(flat_impact_dir, unit_forward) > 0 and "back" or "front"
	local direction = impact_direction.z < UP_STUN_THRESHOLD and "up" or damage_dot > SIDE_STUN_THRESHOLD and "left" or damage_dot < -SIDE_STUN_THRESHOLD and "right" or "down"

	return front_back, direction
end

function WeaponHelper:_hit_sound_event(world, weapon_unit, hit_unit, hit_unit_type, damage, damage_without_armor, attack_name)
	local weapon_gear_name = Unit.get_data(weapon_unit, "gear_name")
	local gear_settings = Gear[weapon_gear_name]
	local damage_type = gear_settings.attacks[attack_name].damage_type
	local armour_type_short = self:_armour_type_sound_parameter(hit_unit)
	local damage_level, damage_description

	if damage > 0 then
		damage_level = damage > DamageLevels.penetrated.heavy and "heavy" or damage > DamageLevels.penetrated.medium and "medium" or "light"
		damage_description = "penetrated"
	else
		damage_level = damage_without_armor > DamageLevels.no_damage.heavy and "heavy" or "light"
		damage_description = "no_damage"
	end

	WeaponHelper:_play_melee_hit_sound_event(hit_unit, weapon_unit, world, damage_type, armour_type_short, damage_level, damage_description, gear_settings.sound_gear_type, attack_name)
end

local SHORT_ARMOUR_TYPES = {
	armour_mail = "mail",
	weapon_metal = "metal",
	weapon_wood = "wood",
	armour_cloth = "cloth",
	armour_plate = "plate",
	armour_leather = "leather",
	none = "none"
}
local SHAFT_TYPES = {
	metal = "metal_shaft",
	wood = "wood_shaft"
}

function WeaponHelper:_armour_type_sound_parameter(unit)
	if Unit.has_data(unit, "armour_sound_material") then
		return Unit.get_data(unit, "armour_sound_material")
	else
		local armour_type = Unit.get_data(unit, "armour_type")
		local armour_type_short = SHORT_ARMOUR_TYPES[armour_type]

		fassert(armour_type_short, "[WeaponHelper:_hit_sound_event()] Hit unit %q with incorrect armour_type %q", unit, armour_type)

		return armour_type_short
	end
end

function WeaponHelper:_play_melee_hit_sound_event(hit_unit, weapon_unit, world, damage_type, armour_type_short, damage_level, damage_description, weapon_type, attack_name)
	local event_id
	local timpani_world = World.timpani_world(world)
	local attacker_is_husk = Unit.get_data(weapon_unit, "husk")
	local victim_is_local = false
	local unit_owner = Managers.player:owner(hit_unit)

	if unit_owner then
		victim_is_local = unit_owner.local_player
	end

	local melee_hit_sound_event = Unit.get_data(hit_unit, "melee_hit_sound_event")

	if melee_hit_sound_event then
		event_id = TimpaniWorld.trigger_event(timpani_world, melee_hit_sound_event, weapon_unit)
	elseif damage_level == "heavy" then
		local event = victim_is_local and "melee_hit_heavy_self" or attacker_is_husk and "melee_hit_heavy_husk" or "melee_hit_heavy"

		event_id = TimpaniWorld.trigger_event(timpani_world, event, weapon_unit)
	else
		local event = victim_is_local and "melee_hit_self" or attacker_is_husk and "melee_hit_husk" or "melee_hit"

		event_id = TimpaniWorld.trigger_event(timpani_world, event, weapon_unit)
	end

	if event_id then
		local melee_hit_damage_type = Unit.get_data(weapon_unit, "melee_hit_damage_type")

		if weapon_type then
			TimpaniWorld.set_parameter(timpani_world, event_id, "weapon_type", weapon_type)
		end

		if attack_name then
			TimpaniWorld.set_parameter(timpani_world, event_id, "attack_type", attack_name)
		end

		if melee_hit_damage_type then
			TimpaniWorld.set_parameter(timpani_world, event_id, "damage_type", melee_hit_damage_type)
		else
			TimpaniWorld.set_parameter(timpani_world, event_id, "damage_type", damage_type)
		end

		TimpaniWorld.set_parameter(timpani_world, event_id, "armour_type", armour_type_short)

		if damage_level then
			TimpaniWorld.set_parameter(timpani_world, event_id, "damage_level", damage_level)
		end

		if damage_description then
			TimpaniWorld.set_parameter(timpani_world, event_id, "damage", damage_description)
		end
	else
		print("[WeaponHelper:_hit_sound_event] missing melee_hit sound event for:", weapon_unit)
	end

	if script_data.sound_debug then
		print("damage_type: " .. tostring(damage_type) .. "  armour_type: " .. tostring(armour_type_short) .. "  damage_level: " .. tostring(damage_level) .. "  damage: " .. tostring(damage_description))
	end
end

function WeaponHelper:shaft_damage_type(weapon_unit)
	return SHAFT_TYPES[self:_armour_type_sound_parameter(weapon_unit)]
end

function WeaponHelper:non_damage_hit_sound_event(world, weapon_unit, hit_unit)
	local armour_type_short = self:_armour_type_sound_parameter(hit_unit)
	local damage_type = self:shaft_damage_type(weapon_unit)

	WeaponHelper:_play_melee_hit_sound_event(hit_unit, weapon_unit, world, damage_type, armour_type_short)
end

function WeaponHelper:melee_weapon_velocity(weapon_unit, attack_name, attack_time, duration)
	if attack_name == "couch" then
		local attack_settings = Unit.get_data(weapon_unit, "attacks")[attack_name]
		local forward_direction = attack_settings.forward_direction:unbox()
		local rotation = Unit.world_rotation(weapon_unit, 0)
		local direction = Quaternion.rotate(rotation, forward_direction)
		local velocity = direction

		return velocity
	end

	local attack_settings = Unit.get_data(weapon_unit, "attacks")[attack_name]
	local speed_func = attack_settings.speed_function
	local speed_max = attack_settings.speed_max
	local forward_direction = attack_settings.forward_direction:unbox()
	local t = math.min(attack_time, duration) / duration
	local speed = AttackSpeedFunctions[speed_func](t, speed_max)
	local rotation = Unit.world_rotation(weapon_unit, 0)
	local direction = Quaternion.rotate(rotation, forward_direction)
	local velocity = speed * direction

	return velocity
end

function WeaponHelper:calculate_sweep_progression(current_attack)
	local sweep_settings = current_attack.sweep
	local delay = sweep_settings.delay
	local attack_time = current_attack.attack_time
	local attack_duration = current_attack.attack_duration
	local sweep_start_time = delay * attack_duration
	local sweep_end_time = attack_duration
	local progression = (attack_time - sweep_start_time) / attack_duration

	return progression
end

function WeaponHelper:_debug_melee_damage(print_to_chat, base_uncharged_damage, base_charged_damage, charge_value, hit_zone_hit, hit_zone_multiplier, sweep_progression, progression_multiplier, damage_without_armour, damage_type, armour_type, absorption_value, absorption_coefficient, net_absorption_value, damage)
	local hud_manager = Managers.state.hud

	local function print_func(str, color)
		if print_to_chat then
			hud_manager:output_console_text(str, color)
		end

		print(str)
	end

	print_func("====DAMAGE DEBUG====", Vector3(255, 0, 0))
	print_func("base uncharged damage = " .. base_uncharged_damage)
	print_func("base charged damage = " .. base_charged_damage)
	print_func("charge value = " .. charge_value)
	print_func("hit zone = " .. (hit_zone_hit and hit_zone_hit.name or "n/a") .. " multiplier = " .. hit_zone_multiplier)
	print_func("progression value = " .. sweep_progression .. " progression multiplier = " .. progression_multiplier)
	print_func("damage_without armour = " .. damage_without_armour .. "(charge_value*charged_base_damage + (1-charged_value)*uncharged_base_damage * progression_multiplier * hit_zone_multiplier)")
	print_func("==armour==", Vector3(255, 0, 0))
	print_func("damage type = " .. damage_type .. " armour type = " .. armour_type .. " absorption value = " .. absorption_value .. " absorption coefficient = " .. absorption_coefficient)
	print_func("net absorption value = " .. net_absorption_value .. " (absorption_value * absorption_coefficient)")
	print_func("net damage = " .. damage .. " ((damage without armour)*(1-(net absorption value)))")
end

function WeaponHelper:calculate_perk_attack_damage(weapon_unit, attacker_unit, victim_unit, attack_name, damage_type, charge_time, actor, impact_direction)
	local attack_settings = Unit.get_data(weapon_unit, "attacks")[attack_name]
	local base_damage = attack_settings.base_damage
	local damage_range_type = attack_settings.damage_range_type
	local hit_zones = Unit.get_data(victim_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor]
	local hit_zone_multiplier = hit_zone_hit and hit_zone_hit.damage_multiplier or 1
	local armour_type, penetration_value, absorption_value = self:_armour_values(victim_unit, hit_zone_hit and hit_zone_hit.name, actor, impact_direction)
	local penetration_coefficient = DamageTypes[damage_type].penetration_modifiers[armour_type]
	local charge_value = charge_time and charge_time > 0 and math.min(1, attack_settings.uncharged_damage_factor + (1 - attack_settings.uncharged_damage_factor) * (charge_time / attack_settings.charge_time)) or 1
	local damage_without_armor = base_damage * charge_value
	local absorption_coefficient = DamageTypes[damage_type].absorption_modifiers[armour_type]
	local damage = base_damage - damage_without_armor * absorption_value * absorption_coefficient
	local penetrated

	if damage > penetration_value * penetration_coefficient then
		penetrated = true
	else
		penetrated = false
		damage = 0
	end

	return damage, damage_range_type, damage_without_armor, penetrated
end

function WeaponHelper:calculate_thrown_projectile_damage(attack_settings, base_damage, damage_type, weapon_speed_max, weapon_velocity, victim_velocity, victim_unit, actor, position, normal, impact_direction, bounced)
	local impact_speed = self:_weapon_impact_speed(Vector3(0, 0, 0), weapon_velocity, victim_velocity)
	local hit_zones = Unit.get_data(victim_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor]
	local hit_zone_multiplier = hit_zone_hit and (hit_zone_hit.damage_multiplier_ranged or hit_zone_hit.damage_multiplier or 1) * (attack_settings.head_shot_multiplier or 1) or 1
	local armour_type, penetration_value, absorption_value = self:_armour_values(victim_unit, hit_zone_hit and hit_zone_hit.name, actor, impact_direction)
	local velocity_multiplier = bounced and math.pow(impact_speed, 2) / math.pow(weapon_speed_max, 2) or 1
	local damage_without_armor = base_damage * velocity_multiplier
	local damage, absorption_coefficient
	local impact_dot = Vector3.dot(normal, impact_direction)
	local impact_multiplier = math.min(math.max(math.abs(impact_dot) * 1.5 - 0.5, 0.1), 1)

	absorption_coefficient = DamageTypes[damage_type].absorption_modifiers[armour_type]
	damage = damage_without_armor * hit_zone_multiplier - damage_without_armor * absorption_value * absorption_coefficient * impact_multiplier

	return damage, true
end

function WeaponHelper:calculate_projectile_damage(attacker_velocity, weapon_velocity, victim_velocity, firing_gear_name, projectile_unit, victim_unit, attacker_unit, projectile_settings, actor, position, normal, impact_direction, properties, charge_value, range, user_has_faster_bow_charge_perk, user_has_bow_zoom_perk, user_has_light_01_perk)
	local attack_settings = Gear[firing_gear_name].attacks.ranged
	local impact_speed = self:_weapon_impact_speed(attacker_velocity, weapon_velocity, victim_velocity)
	local uncharged_damage = attack_settings.uncharged_damage
	local charged_damage = attack_settings.charged_damage
	local damage_type = projectile_settings.damage_type
	local damage_range_type = attack_settings.damage_range_type
	local weapon_speed_max = attack_settings.speed_max
	local hit_zones = Unit.get_data(victim_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor]
	local hit_zone_multiplier = hit_zone_hit and (hit_zone_hit.damage_multiplier_ranged or hit_zone_hit.damage_multiplier) or 1

	if hit_zone_hit and (hit_zone_hit.name == "helmet" or hit_zone_hit.name == "head") and user_has_light_01_perk then
		hit_zone_multiplier = hit_zone_multiplier * Perks.light_01.head_shot_multiplier * (attack_settings.head_shot_multiplier or 1)
	end

	local armour_type, penetration_value, absorption_value = self:_armour_values(victim_unit, hit_zone_hit and hit_zone_hit.name, actor, impact_direction)
	local impact_dot = Vector3.dot(normal, impact_direction)
	local scaled_penetration_value

	if impact_dot > 0 then
		scaled_penetration_value = 10 * penetration_value
	else
		local angle = math.acos(math.clamp(-impact_dot, -1, 1))
		local val = math.max((angle - math.pi * 0.25) * 2, 0)

		scaled_penetration_value = math.min(penetration_value + math.tan(val) * penetration_value, 10 * penetration_value)
	end

	local penetration_property_multiplier = self:_weapon_has_property(properties, "penetration") and PenetrationPropertyMultipliers[damage_type].penetration_multipliers[armour_type] or 1
	local penetration_coefficient = penetration_property_multiplier * DamageTypes[damage_type].penetration_modifiers[armour_type]
	local perk_multiplier = 1

	if user_has_bow_zoom_perk then
		if Unit.alive(attacker_unit) then
			local player = Managers.player:owner(attacker_unit)
			local network_manager = Managers.state.network

			RPC.rpc_hit_with_bow_zoom_longshot(player:network_id(), network_manager:game_object_id(attacker_unit))
		end

		perk_multiplier = range >= Perks.bow_zoom.minimum_yards_before_bonus and range / Perks.bow_zoom.minimum_yards_before_bonus * Perks.bow_zoom.damage_multiplier_tweak or perk_multiplier
	end

	local damage_without_armor = math.lerp(uncharged_damage, charged_damage, charge_value) * perk_multiplier * math.pow(impact_speed, 2) / math.pow(weapon_speed_max, 2)
	local damage, absorption_coefficient, penetrated

	absorption_coefficient = DamageTypes[damage_type].absorption_modifiers[armour_type]
	damage = damage_without_armor - damage_without_armor * absorption_value * absorption_coefficient

	if script_data.perk_debug then
		print("---Eagle Eye Range Damage---")
		print("Range: ", range)
		print("Multiplier: ", perk_multiplier)
		print("Damage Without Armour: ", damage_without_armor)
		print("Damage: ", damage)
		print("----------------------------")
	end

	if damage > penetration_value * penetration_coefficient then
		penetrated = true

		local impact_dot = Vector3.dot(normal, impact_direction)
		local impact_multiplier = math.min(math.max(math.abs(impact_dot) * 1.5 - 0.5, 0.25), 1)

		damage = damage * hit_zone_multiplier * impact_multiplier
	else
		penetrated = false
		damage = 0
	end

	if Managers.state.network:game() then
		damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
	end

	if script_data.damage_debug then
		self:_debug_projectile_damage(uncharged_damage, charged_damage, charge_value, impact_speed, weapon_speed_max, damage_without_armor, penetration_value, penetration_coefficient, penetrated, actor, hit_zone_multiplier, absorption_value, absorption_coefficient, damage, scaled_penetration_value)
		self:_debug_projectile_penetration(position, normal, impact_direction)
	end

	return damage, damage_range_type, penetrated
end

function WeaponHelper:_debug_projectile_penetration(position, normal, impact_direction)
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "weapon"
	})

	drawer:vector(position, normal * 0.25, Color(255, 255, 0))
	drawer:vector(position, impact_direction * 0.25, Color(255, 0, 0))
end

function WeaponHelper:conditions_stopping_melee_character_hit(hit_unit, weapon_unit, hit_zone_hit, current_attack)
	local weapon_settings = Unit.get_data(weapon_unit, "settings")
	local attacks = Unit.get_data(weapon_unit, "attacks")
	local dodge_hit_zones_to_ignore = attacks[current_attack.attack_name].dodge_hit_zones_to_ignore
	local locomotion = ScriptUnit.extension(hit_unit, "locomotion_system")

	if dodge_hit_zones_to_ignore and locomotion:is_dodging() then
		for _, hit_zone in pairs(dodge_hit_zones_to_ignore) do
			if hit_zone_hit == hit_zone then
				return true
			end
		end
	end

	return false
end

function WeaponHelper:hit_zone(unit, actor)
	local hit_zones = Unit.get_data(unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor] and hit_zones[actor].name

	return hit_zone_hit
end

function WeaponHelper:_weapon_impact_speed(attacker_velocity, weapon_velocity, victim_velocity)
	local weapon_speed = Vector3.length(weapon_velocity)
	local weapon_direction = Vector3.normalize(weapon_velocity)
	local attacker_speed = Vector3.dot(attacker_velocity, weapon_direction)
	local victim_speed = Vector3.dot(victim_velocity, weapon_direction)
	local impact_speed = math.max(weapon_speed + attacker_speed - victim_speed, 0)

	return impact_speed
end

function WeaponHelper:_armour_values(victim_unit, hit_zone_hit)
	local armour_type, penetration_value, absorption_value, inventory

	if ScriptUnit.has_extension(victim_unit, "locomotion_system") then
		local locomotion_ext = ScriptUnit.extension(victim_unit, "locomotion_system")

		inventory = locomotion_ext.inventory and locomotion_ext:inventory()
	end

	if inventory then
		fassert(hit_zone_hit, "Unit %s, Hitzone %s", victim_unit, hit_zone_hit)

		armour_type, penetration_value, absorption_value = inventory:armour_values(hit_zone_hit)
	else
		armour_type = Unit.get_data(victim_unit, "armour_type") or "none"
		penetration_value = Unit.get_data(victim_unit, "penetration_value") or 0
		absorption_value = Unit.get_data(victim_unit, "absorption_value") or 0
	end

	return armour_type, penetration_value, absorption_value
end

function WeaponHelper:_debug_projectile_damage(uncharged_damage, charged_damage, charge_value, impact_speed, weapon_speed_max, damage_without_armor, penetration_value, penetration_coefficient, penetrated, actor, hit_zone_multiplier, absorption_value, absorption_coefficient, damage, scaled_penetration_value)
	print("*** DAMAGE DEBUG START ***************************")
	print("uncharged_damage = " .. uncharged_damage)
	print("charged_damage = " .. charged_damage)
	print("charge_value = " .. charge_value)
	print("impact_speed = " .. impact_speed)
	print("weapon_speed_max = " .. weapon_speed_max)
	print("damage_without_armor = " .. damage_without_armor .. " = base_damage * math.pow( impact_speed, 2 ) / math.pow( weapon_speed_max, 2 )")
	print("penetration_value = " .. penetration_value)
	print("penetration_coefficient = " .. penetration_coefficient)
	print("impact_angle_scaled_penetration_value = " .. scaled_penetration_value)

	if penetrated then
		print("ARMOUR PENETRATED")
		print("actor = " .. tostring(actor))
		print("hit_zone_multiplier = " .. hit_zone_multiplier)
		print("absorption_value = " .. absorption_value)
		print("absorption_coefficient = " .. absorption_coefficient)
		print("damage = " .. damage .. " = hit_zone_multiplier * ( damage_without_armor  - ( absorption_value * absorption_coefficient ) )")
	else
		print("ARMOUR NOT PENETRATED")
		print("damage = " .. damage)
	end

	print("*** DAMAGE DEBUG END ****************************")
end

function WeaponHelper:_debug_handgonne_damage(base_damage, damage_without_armor, penetration_value, penetration_coefficient, penetrated, actor, hit_zone_multiplier, absorption_value, absorption_coefficient, damage)
	print("*** DAMAGE DEBUG START ***************************")
	print("base_damage = " .. base_damage)
	print("damage_without_armor = " .. damage_without_armor .. " = base_damage")
	print("penetration_value = " .. penetration_value)
	print("penetration_coefficient = " .. penetration_coefficient)

	if penetrated then
		print("ARMOUR PENETRATED")
		print("actor = " .. tostring(actor))
		print("hit_zone_multiplier = " .. hit_zone_multiplier)
		print("absorption_value = " .. absorption_value)
		print("absorption_coefficient = " .. absorption_coefficient)
		print("damage = " .. damage .. " = hit_zone_multiplier * ( damage_without_armor  - ( absorption_value * absorption_coefficient ) )")
	else
		print("ARMOUR NOT PENETRATED")
		print("damage = " .. damage)
	end

	print("*** DAMAGE DEBUG END ****************************")
end

function WeaponHelper:projectile_fire_position_from_camera(weapon_unit, user_unit, projectile_settings)
	local attack_settings = Unit.get_data(weapon_unit, "attacks").ranged
	local weapon_name = Unit.get_data(weapon_unit, "gear_name")
	local parent_link_node_name = projectile_settings.parent_link_node
	local parent_link_node = Unit.node(user_unit, parent_link_node_name)
	local projectile_position = Unit.world_position(user_unit, parent_link_node)
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(user_unit, "viewport_name")
	local camera_position = camera_manager:camera_position(viewport_name)
	local camera_rotation = camera_manager:camera_rotation(viewport_name)
	local camera_forward = Quaternion.forward(camera_rotation)

	if script_data.weapon_debug then
		local dot = Vector3.dot(projectile_position - camera_position, camera_forward)

		print("projectile_release_distance: " .. dot)
	end

	local position = camera_position + camera_forward * attack_settings.projectile_release_distance

	return position
end

function WeaponHelper:handgonne_fire_position_from_camera(gear_unit, user_unit, muzzle_position, max_bullet_spread)
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(user_unit, "viewport_name")
	local camera_position = camera_manager:camera_position(viewport_name)
	local camera_rotation = camera_manager:camera_rotation(viewport_name)
	local camera_forward = Quaternion.forward(camera_rotation)
	local resultant_vector = muzzle_position - camera_position
	local resultant_distance = Vector3.dot(resultant_vector, camera_forward)
	local relative_position = resultant_distance * camera_forward
	local raycast_position = relative_position + camera_position
	local direction = self:_add_spread(camera_rotation, max_bullet_spread, user_unit)

	return raycast_position, direction
end

function WeaponHelper:handgonne_fire_position_from_handgonne(gear_unit, user_unit, muzzle_position, max_bullet_spread)
	local locomotion_ext = ScriptUnit.extension(user_unit, "locomotion_system")
	local look_target = locomotion_ext:look_target()
	local resultant_vector = look_target - muzzle_position
	local rotation = Quaternion.look(resultant_vector, Vector3.up())
	local direction = self:_add_spread(rotation, max_bullet_spread, user_unit)

	return muzzle_position, direction
end

function WeaponHelper:_add_spread(rotation, max_spread_angle, user_unit)
	local locomotion_ext = ScriptUnit.extension(user_unit, "locomotion_system")
	local spread_multiplier = locomotion_ext:has_perk("handgonner_training") and Perks.handgonner_training.spread_multiplier or 1
	local spread_angle = math.random() * (max_spread_angle / 180) * math.pi * spread_multiplier
	local rand_roll = math.random() * math.pi * 2
	local roll_rotation = Quaternion(Vector3.forward(), rand_roll)
	local pitch_rotation = Quaternion(Vector3.right(), spread_angle)
	local final_rotation = Quaternion.multiply(Quaternion.multiply(rotation, roll_rotation), pitch_rotation)
	local fire_dir = Quaternion.forward(final_rotation)

	return fire_dir
end

function WeaponHelper:bow_projectile_fire_velocity_from_camera(weapon_unit, user_unit)
	local attack_settings = Unit.get_data(weapon_unit, "attacks").ranged
	local speed_max = attack_settings.speed_max
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(user_unit, "viewport_name")
	local camera_position = camera_manager:camera_position(viewport_name)
	local camera_rotation = camera_manager:camera_rotation(viewport_name)
	local pitch = attack_settings.projectile_release_pitch * math.pi / 180
	local rotation = Quaternion.multiply(camera_rotation, Quaternion(Vector3(1, 0, 0), pitch))
	local direction = Quaternion.forward(rotation)
	local velocity = speed_max * direction

	return velocity, direction
end

function WeaponHelper:crossbow_projectile_fire_velocity_from_camera(weapon_unit, user_unit)
	local attack_settings = Unit.get_data(weapon_unit, "attacks").ranged
	local speed_max = attack_settings.speed_max
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(user_unit, "viewport_name")
	local camera_position = camera_manager:camera_position(viewport_name)
	local camera_rotation = camera_manager:camera_rotation(viewport_name)
	local pitch = attack_settings.projectile_release_pitch * math.pi / 180
	local rotation = Quaternion.multiply(camera_rotation, Quaternion(Vector3(1, 0, 0), pitch))
	local direction = Quaternion.forward(rotation)
	local velocity = speed_max * direction

	fassert(Vector3.length(velocity) < 200, "Speed_max = %f, direction = %s, pitch = %f, rotation = %s, direction = %s, camera_rotation = %s", speed_max, direction, pitch, rotation, direction, camera_rotation)

	return velocity, direction
end

function WeaponHelper:projectile_fire_position_from_ranged_weapon(weapon_unit, user_unit, projectile_name)
	local weapon_name = Unit.get_data(weapon_unit, "gear_name")
	local projectile_settings = self:attachment_settings(weapon_name, "projectile_head", projectile_name)
	local parent_link_node_name = projectile_settings.parent_link_node
	local parent_link_node = Unit.node(user_unit, parent_link_node_name)
	local projectile_position = Unit.world_position(user_unit, parent_link_node)

	return projectile_position
end

function WeaponHelper:projectile_fire_velocity_from_bow(weapon_unit, aim_direction, draw_time)
	local attack_settings = Unit.get_data(weapon_unit, "attacks").ranged
	local speed_func = attack_settings.speed_function
	local speed_max = attack_settings.speed_max

	return speed_max * aim_direction
end

function WeaponHelper:wanted_projectile_angle(distance_vector, projectile_gravity, projectile_speed)
	local x = Vector3.length(Vector3.flat(distance_vector))
	local y = distance_vector.z
	local g = projectile_gravity
	local v = projectile_speed
	local aux = x^2 - g^2 * x^4 / v^4 + 2 * g * x^2 * y / v^2

	if aux >= 0 then
		local angle_1 = math.atan(v^2 * (-x + math.sqrt(aux)) / (g * x^2))
		local angle_2 = math.atan(v^2 * (-x - math.sqrt(aux)) / (g * x^2))

		return angle_1, angle_2
	end
end

function WeaponHelper:wanted_projectile_speed(distance_vector, projectile_gravity, wanted_angle)
	local x = Vector3.length(Vector3.flat(distance_vector))
	local y = distance_vector.z
	local g = math.abs(projectile_gravity)
	local aux = g / (2 * (x * math.tan(wanted_angle) - y))

	if aux >= 0 then
		return x / math.cos(wanted_angle) * math.sqrt(aux)
	end
end

function WeaponHelper:remove_projectiles(unit)
	if Managers.state.projectile then
		Managers.state.projectile:clear_projectiles(unit)
	end
end

function WeaponHelper:charge_factor(time_posed, minimum_pose_time, charge_timer, charge_buffer_multiplier)
	local charge_factor = (time_posed - minimum_pose_time) / charge_timer
	local charge_value = time_posed / (minimum_pose_time + charge_timer)
	local overcharge_value = 0

	if charge_factor > 1 then
		local overcharge_time = time_posed - minimum_pose_time - charge_timer
		local overcharge_buffer = 0.15 * charge_buffer_multiplier

		if overcharge_time <= overcharge_buffer then
			charge_factor = 1
			charge_value = 1
			overcharge_value = 2 * (0.5 - math.abs(0.5 - overcharge_time / overcharge_buffer))
		elseif overcharge_time - overcharge_buffer <= charge_timer * 1.5 then
			charge_factor = 1 - math.sirp(0, 1, (overcharge_time - overcharge_buffer) / (charge_timer * 1.5))
			charge_value = math.lerp(minimum_pose_time / (charge_timer + minimum_pose_time), 1, charge_factor)
		else
			charge_factor = 0
			charge_value = math.lerp(minimum_pose_time / (charge_timer + minimum_pose_time), 1, charge_factor)
		end
	end

	return charge_factor, charge_value, overcharge_value
end

function WeaponHelper:add_damage(world, victim_unit, player, player_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, attack_name, hit_zone, impact_direction, real_damage, show_damage, range, riposte)
	local network_manager = Managers.state.network

	real_damage = real_damage or damage

	local damage_extension = ScriptUnit.has_extension(victim_unit, "damage_system") and ScriptUnit.extension(victim_unit, "damage_system")
	local friendly_fire_multiplier = Managers.state.team:friendly_fire_multiplier(player_unit, victim_unit, damage_range_type)
	local ff_damage = friendly_fire_multiplier * damage
	local hit_zones = Unit.get_data(victim_unit, "hit_zone_lookup_table")
	local hit_zone_hit = hit_zones and hit_zones[actor]
	local armour_type = self:_armour_values(victim_unit, hit_zone_hit and hit_zone_hit.name, actor, impact_direction)

	if network_manager:game() then
		local victim_obj_id = network_manager:unit_game_object_id(victim_unit)
		local player_obj_id = Unit.alive(player_unit) and network_manager:unit_game_object_id(player_unit) or 0
		local player_id = player:player_id()

		damage = math.clamp(damage, NetworkConstants.damage.min, NetworkConstants.damage.max)
		real_damage = math.clamp(real_damage, NetworkConstants.damage.min, NetworkConstants.damage.max)

		if victim_obj_id then
			network_manager:send_rpc_server("rpc_add_damage", player_id, player_obj_id, victim_obj_id, NetworkLookup.damage_types[damage_type], damage, position, normal, NetworkLookup.damage_range_types[damage_range_type], NetworkLookup.gear_names[gear_name], NetworkLookup.weapon_hit_parameters[attack_name or "nil"], NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, real_damage, range or 0, riposte)

			return
		end

		local current_level = LevelHelper:current_level(world)
		local victim_lvl_id = Level.unit_index(current_level, victim_unit)

		if victim_lvl_id then
			network_manager:send_rpc_server("rpc_add_generic_damage", player_id, player_obj_id, victim_lvl_id, NetworkLookup.damage_types[damage_type], damage, position, normal, NetworkLookup.damage_range_types[damage_range_type], NetworkLookup.gear_names[gear_name], NetworkLookup.weapon_hit_parameters[attack_name or "nil"], NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction)

			return
		end
	elseif not Managers.lobby.lobby and show_damage and (not damage_extension or not damage_extension.can_receive_damage or damage_extension:can_receive_damage(player_unit)) then
		Managers.state.event:trigger("show_damage_number", player, ff_damage, position, hit_zone_hit)
	end

	damage_extension:add_damage(player, player_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, attack_name, hit_zone, impact_direction, real_damage, nil, riposte)
end

function WeaponHelper:add_damage_over_time(world, victim_unit, player, damage_type)
	local network_manager = Managers.state.network

	if network_manager:game() then
		local victim_obj_id = network_manager:unit_game_object_id(victim_unit)
		local player_id = player:player_id()

		if victim_obj_id then
			network_manager:send_rpc_server("rpc_add_damage_over_time", player_id, victim_obj_id, NetworkLookup.damage_over_time_types[damage_type])

			return
		end

		local current_level = LevelHelper:current_level(world)
		local victim_lvl_id = Level.unit_index(current_level, victim_unit)

		if victim_lvl_id then
			return
		end
	end

	local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")

	damage_extension:add_damage_over_time(player, damage_type)
end

function WeaponHelper:add_custom_damage_over_time(world, victim_unit, player, damage_type, duration, dps)
	local network_manager = Managers.state.network

	if network_manager:game() then
		local victim_obj_id = network_manager:unit_game_object_id(victim_unit)
		local player_id = player:player_id()

		if victim_obj_id then
			network_manager:send_rpc_server("rpc_add_custom_damage_over_time", player_id, victim_obj_id, NetworkLookup.damage_over_time_types[damage_type], duration, dps)

			return
		end

		local current_level = LevelHelper:current_level(world)
		local victim_lvl_id = Level.unit_index(current_level, victim_unit)

		if victim_lvl_id then
			return
		end
	end

	local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")

	damage_extension:add_custom_damage_over_time(player, damage_type, duration, dps)
end

function WeaponHelper:damage_over_time_property(property)
	return property == "bleeding" or property == "burning"
end

function WeaponHelper:attachment_items_by_category(gear_name, category)
	local gear_settings = Gear[gear_name]

	for _, config in ipairs(gear_settings.attachments) do
		if config.category == category then
			return config.items
		end
	end
end

function WeaponHelper:attachment_settings(gear_name, category, name)
	if category == "projectile_head" then
		return Gear[gear_name].projectiles[name]
	end

	local attachment_items = self:attachment_items_by_category(gear_name, category) or {}

	for _, item in ipairs(attachment_items) do
		if item.name == name then
			return item
		end
	end
end

function WeaponHelper:_weapon_has_property(properties, value)
	for _, property in ipairs(properties) do
		if property == value then
			return true
		end
	end

	return false
end

function WeaponHelper:current_impact_direction(weapon_unit, current_attack_name)
	local settings = Unit.get_data(weapon_unit, "settings")
	local unit_rot = Unit.world_rotation(weapon_unit, 0)
	local hit_direction = settings.attacks[current_attack_name].forward_direction:unbox()

	return Quaternion.right(unit_rot) * hit_direction.x + Quaternion.forward(unit_rot) * hit_direction.y + Quaternion.up(unit_rot) * hit_direction.z
end

function WeaponHelper:perk_attack_hit_damagable_prop(world, user_unit, weapon_unit, hit_unit, position, normal, actor, current_attack, impact_direction)
	self:add_perk_attack_damage(world, user_unit, weapon_unit, hit_unit, position, normal, actor, nil, true, current_attack, impact_direction)

	return not Unit.get_data(hit_unit, "soft_target")
end

function WeaponHelper:perk_attack_hit_non_damagable_prop(world, user_unit, weapon_unit, hit_unit, position, normal, actor, current_attack, impact_direction)
	if not Unit.get_data(hit_unit, "soft_target") then
		local raw_damage, damage_type, damage, damage_range_type, penetrated = self:add_perk_attack_damage(world, user_unit, weapon_unit, hit_unit, position, normal, actor, nil, false, current_attack, impact_direction)

		return true
	end

	return false
end

function WeaponHelper:add_perk_attack_damage(world, user_unit, weapon_unit, victim_unit, position, normal, actor, hit_zone, apply_damage, current_attack, impact_direction)
	local hits_table = current_attack.hits[victim_unit]
	local attack_name = current_attack.attack_name
	local attacks = Unit.get_data(weapon_unit, "attacks")
	local attack = attacks[attack_name]
	local damage_type = attack.damage_type
	local damage, damage_range_type, raw_damage, penetrated = self:calculate_perk_attack_damage(weapon_unit, user_unit, victim_unit, attack_name, damage_type, current_attack.charge_time, actor, impact_direction)

	if not hits_table then
		hits_table = {
			damage = damage,
			hit_zones = {},
			penetrated = penetrated
		}
		current_attack.hits[victim_unit] = hits_table
	end

	if apply_damage then
		self:apply_damage(world, user_unit, weapon_unit, victim_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction)
	end

	return raw_damage, damage_type, damage, damage_range_type, penetrated
end

function WeaponHelper:apply_damage(world, user_unit, weapon_unit, victim_unit, position, normal, actor, damage_type, damage, damage_range_type, raw_damage, current_attack, hit_zone, impact_direction, weapon_properties, real_damage, riposte)
	local victim_position = Unit.world_position(victim_unit, 0)
	local user_player = Managers.player:owner(user_unit)
	local gear_name = Unit.get_data(weapon_unit, "gear_name")

	self:add_damage(world, victim_unit, user_player, user_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, current_attack.attack_name, hit_zone, impact_direction, real_damage, true, nil, riposte)

	weapon_properties = weapon_properties or {}

	for _, property in ipairs(weapon_properties) do
		if self:damage_over_time_property(property) and damage > 0 then
			self:add_damage_over_time(world, victim_unit, user_player, property)
		end
	end
end

function WeaponHelper:helmet_hack(hit_unit, actor)
	if Unit.has_data(hit_unit, "armour_owner") then
		local owner_unit = Unit.get_data(hit_unit, "armour_owner")

		if actor == Unit.actor(hit_unit, "c_head") or actor == Unit.actor(hit_unit, "c_neck") then
			actor = Unit.actor(owner_unit, "c_head")
		else
			actor = Unit.actor(owner_unit, "helmet")
		end

		hit_unit = owner_unit
	end

	return hit_unit, actor
end
