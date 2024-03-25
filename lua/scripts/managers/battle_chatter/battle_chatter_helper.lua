-- chunkname: @scripts/managers/battle_chatter/battle_chatter_helper.lua

BattleChatterHelper = class(BattleChatterHelper)

local DEFAULT_DISTANCE = 20

function BattleChatterHelper.get_close_units(world, unit, excludes, distance)
	local physics_world = World.physics_world(world)
	local position = Unit.world_position(unit, 0)

	excludes = excludes or {}
	distance = distance or DEFAULT_DISTANCE

	local actors = PhysicsWorld.overlap(physics_world, nil, "position", position, "size", distance, "collision_filter", "player_scan")
	local units = {}

	for _, actor in ipairs(actors) do
		local found_unit = Actor.unit(actor)

		if found_unit then
			local add_unit = true

			for _, exclude_unit in ipairs(excludes) do
				if found_unit == exclude_unit then
					add_unit = false

					break
				end
			end

			if add_unit then
				units[#units + 1] = found_unit
			end
		end
	end

	return units
end

function BattleChatterHelper.relevant_distance(unit_1, unit_2, distance_ref)
	if not Unit.alive(unit_1) or not Unit.alive(unit_2) then
		return
	end

	distance_ref = distance_ref or DEFAULT_DISTANCE

	local p1 = Unit.world_position(unit_1, 0)
	local p2 = Unit.world_position(unit_2, 0)
	local distance = Vector3.distance(p1, p2)

	return distance < distance_ref
end

function BattleChatterHelper.get_talker(talker_func_name, world, ref_unit, excludes, distance)
	local talker, responders
	local close_units = BattleChatterHelper.get_close_units(world, ref_unit, excludes, distance)

	if #close_units > 0 then
		talker, responders = BattleChatterHelper[talker_func_name](ref_unit, close_units)
	end

	return talker, responders
end

function BattleChatterHelper.get_talker_closest(unit, possible_talkers)
	local position = Unit.world_position(unit, 0)
	local closest_id
	local closest_distance = math.huge

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local talker_position = Unit.world_position(talker, 0)
			local distance = Vector3.distance(position, talker_position)

			if distance < closest_distance then
				closest_id = id
				closest_distance = distance
			end
		end
	end

	if not closest_id then
		return nil, nil
	end

	local closest = table.remove(possible_talkers, closest_id)

	if #possible_talkers > 0 then
		return closest, table.clone(possible_talkers)
	else
		return closest, nil
	end
end

function BattleChatterHelper.get_talker_closest_teammate(unit, possible_talkers)
	local unit_owner = Managers.player:owner(unit)
	local position = Unit.world_position(unit, 0)
	local closest_id
	local closest_distance = math.huge

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local owner = Managers.player:owner(talker)
			local talker_position = Unit.world_position(talker, 0)
			local distance = Vector3.distance(position, talker_position)

			if unit_owner.team == owner.team and distance < closest_distance then
				closest_id = id
				closest_distance = distance
			end
		end
	end

	if not closest_id then
		return nil, nil
	end

	local closest = table.remove(possible_talkers, closest_id)

	if #possible_talkers > 0 then
		return closest, table.clone(possible_talkers)
	else
		return closest, nil
	end
end

function BattleChatterHelper.get_talker_closest_enemy(unit, possible_talkers)
	local unit_owner = Managers.player:owner(unit)
	local position = Unit.world_position(unit, 0)
	local closest_id
	local closest_distance = math.huge

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local owner = Managers.player:owner(talker)
			local talker_position = Unit.world_position(talker, 0)
			local distance = Vector3.distance(position, talker_position)

			if unit_owner.team ~= owner.team and distance < closest_distance then
				closest_id = id
				closest_distance = distance
			end
		end
	end

	if not closest_id then
		return nil, nil
	end

	local closest = table.remove(possible_talkers, closest_id)

	if #possible_talkers > 0 then
		return closest, table.clone(possible_talkers)
	else
		return closest, nil
	end
end

function BattleChatterHelper.get_talker_furthest(unit, possible_talkers)
	local position = Unit.world_position(unit, 0)
	local furthest_id
	local furthest_distance = 0

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local talker_position = Unit.world_position(talker, 0)
			local distance = Vector3.distance(position, talker_position)

			if furthest_distance < distance then
				furthest_id = id
				furthest_distance = distance
			end
		end
	end

	local furthest = table.remove(possible_talkers, furthest_id)

	if #possible_talkers > 0 then
		return furthest, table.clone(possible_talkers)
	else
		return furthest, nil
	end
end

function BattleChatterHelper.get_talker_furthest_teammate(unit, possible_talkers)
	local unit_owner = Managers.player:owner(unit)
	local position = Unit.world_position(unit, 0)
	local furthest_id
	local furthest_distance = 0

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local owner = Managers.player:owner(talker)
			local talker_position = Unit.world_position(talker, 0)
			local distance = Vector3.distance(position, talker_position)

			if unit_owner.team == owner.team and furthest_distance < distance then
				furthest_id = id
				furthest_distance = distance
			end
		end
	end

	if not furthest_id then
		return nil, nil
	end

	local furthest = table.remove(possible_talkers, furthest_id)

	if #possible_talkers > 0 then
		return furthest, table.clone(possible_talkers)
	else
		return furthest, nil
	end
end

function BattleChatterHelper.get_talker_random(unit, possible_talkers)
	local delta = {}

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			delta[#delta + 1] = id
		end
	end

	local num_talkers = #delta

	if num_talkers == 0 then
		return
	end

	local id = delta[math.random(1, num_talkers)]
	local random = table.remove(possible_talkers, id)

	if #possible_talkers > 0 then
		return random, table.clone(possible_talkers)
	else
		return random, nil
	end
end

function BattleChatterHelper.get_talker_random_teammate(unit, possible_talkers)
	local unit_owner = Managers.player:owner(unit)
	local delta = {}

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local owner = Managers.player:owner(talker)

			if unit_owner.team == owner.team then
				delta[#delta + 1] = id
			end
		end
	end

	local num_talkers = #delta

	if num_talkers == 0 then
		return nil, nil
	end

	local id = delta[math.random(1, num_talkers)]
	local random = table.remove(possible_talkers, id)

	if #possible_talkers > 0 then
		return random, table.clone(possible_talkers)
	else
		return random, nil
	end
end

function BattleChatterHelper.get_talker_random_enemy(unit, possible_talkers)
	local unit_owner = Managers.player:owner(unit)
	local delta = {}

	for id, talker in ipairs(possible_talkers) do
		if BattleChatterHelper.talk_eligible(talker) then
			local owner = Managers.player:owner(talker)

			if unit_owner.team ~= owner.team then
				delta[#delta + 1] = id
			end
		end
	end

	local num_talkers = #delta

	if num_talkers == 0 then
		return nil, nil
	end

	local id = delta[math.random(1, num_talkers)]
	local random = table.remove(possible_talkers, id)

	if #possible_talkers > 0 then
		return random, table.clone(possible_talkers)
	else
		return random, nil
	end
end

function BattleChatterHelper.talk_eligible(unit)
	local alive = Unit.alive(unit)
	local talking = alive and Unit.get_data(unit, "bc_talking")
	local damage_ext = alive and ScriptUnit.extension(unit, "damage_system")

	return alive and not talking and not damage_ext:is_dead()
end

function BattleChatterHelper.team(unit)
	local owner = Managers.player:owner(unit)
	local team = owner.team.name

	return team == "red" and "viking" or "saxon"
end

function BattleChatterHelper.class(unit)
	local archetype = Unit.get_data(unit, "archetype")
	local head_name = Unit.get_data(unit, "head")
	local voice_config = Heads[head_name].voice
	local is_lady = archetype == "shield_maiden" or voice_config == "female_saxon" or voice_config == "female_viking"

	return is_lady and "female" or archetype
end

function BattleChatterHelper.trigger(percentage)
	local random = math.random()

	return random < percentage
end

function BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)
	local team = BattleChatterHelper.team(talker)
	local class = BattleChatterHelper.class(talker)
	local all_foreign = Application.user_setting("battle_chatter_hardcore_mode")
	local language = not all_foreign and relevant and team .. "_english" or team .. "_foreign"
	local data = {}

	data.talker = talker
	data.responders = responders
	data.config = config
	data.relevant = relevant
	data.cooldown = Managers.time:time("round") + 5
	data.parameters = {
		"language_type",
		language,
		"class",
		class
	}

	return data
end

function BattleChatterHelper.first_kill_of_round(victim_unit, attacker_unit)
	local attacker = Managers.player:owner(attacker_unit)
	local victim = Managers.player:owner(victim_unit)
	local stats_collection_manager = Managers.state.stats_collection
	local attacker_side_kills = stats_collection_manager:get(attacker:network_id(), "enemy_kills")
	local victim_side_kills = stats_collection_manager:get(victim:network_id(), "enemy_kills")

	if attacker_side_kills + victim_side_kills == 1 then
		return true
	else
		return false
	end
end

function BattleChatterHelper.teammates(unit, units)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)
	local teammates = {}

	for _, u in ipairs(units) do
		local o = player_manager:owner(u)

		if owner.team == o.team then
			table.insert(teammates, u)
		end
	end

	return teammates
end

function BattleChatterHelper.enemies(unit, units)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)
	local enemies = {}

	for _, u in ipairs(units) do
		local o = player_manager:owner(u)

		if owner.team ~= o.team then
			table.insert(enemies, u)
		end
	end

	return enemies
end

function BattleChatterHelper.num_alive(units)
	local num_alive = 0

	for _, unit in ipairs(units) do
		local damage_ext = ScriptUnit.extension(unit, "damage_system")

		if damage_ext:is_alive() then
			num_alive = num_alive + 1
		end
	end

	return num_alive
end

function BattleChatterHelper.cooldown(history, battle_chatter_name)
	if history and not history[battle_chatter_name] or not history then
		return true
	end

	local time = Managers.time:time("round")

	if time >= history[battle_chatter_name] then
		return true
	end

	return false
end
