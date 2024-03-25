-- chunkname: @scripts/helpers/debug_helper.lua

DebugHelper = DebugHelper or {}

function DebugHelper.remove_debug_stuff()
	function Commands.script()
		return
	end

	function Commands.console()
		return
	end

	function Managers.free_flight.update()
		return
	end

	function Commands.game_speed()
		return
	end

	function Commands.fov()
		return
	end

	function Commands.free_flight_settings()
		return
	end

	function Commands.lag()
		return
	end

	function Commands.location()
		return
	end

	function Commands.next_level()
		return
	end
end

function DebugHelper.debug_unit_movement(unit, unit_name)
	if not script_data.core_debug_enabled then
		Application.set_autoload_enabled(true)
		require("core/debug/init")

		script_data.core_debug_enabled = true
	end

	local debug_horse_pos = Vector3Box()

	Profiler.record_statistics("horse_speed", 0)
	Profiler.record_statistics("horse_speed_components", Vector3(0, 0, 0))
	debug_horse_pos:store(Unit.local_position(script_data.horse_unit, 0))
	Core.Debug.add_updator(function(dt)
		local new_pos = Unit.local_position(unit, 0)
		local velocity = (new_pos - debug_horse_pos:unbox()) / dt
		local rot = Unit.local_rotation(unit, 0)
		local fwd_speed = Vector3.dot(velocity, Quaternion.forward(rot))
		local right_speed = Vector3.dot(velocity, Quaternion.right(rot))
		local up_speed = Vector3.dot(velocity, Quaternion.up(rot))

		Profiler.record_statistics(unit_name .. "_speed_components", Vector3(right_speed, fwd_speed, up_speed))
		Profiler.record_statistics(unit_name .. "_speed", Vector3.length(velocity))
		debug_horse_pos:store(new_pos)
	end)
end

function DebugHelper.debug_entity_manager(activate)
	if activate and not World.old_destroy_unit then
		World.old_destroy_unit = World.destroy_unit

		function World.destroy_unit(world, unit, ...)
			assert(not Managers or not Managers.state or not Managers.state.entity or not Managers.state.entity:is_unit_registered(unit), "Deleting unit that is still registered in the entity manager")
			World.old_destroy_unit(world, unit, ...)
		end
	elseif not activate and World.old_destroy_unit then
		World.destroy_unit = World.old_destroy_unit
		World.old_destroy_unit = nil
	end
end

function DebugHelper.debug_positions_and_rotations(activate)
	if activate then
		if not Unit.old_set_local_position then
			Unit.old_set_local_position = Unit.set_local_position

			function Unit.set_local_position(unit, node, position)
				assert(Vector3.is_valid(position), "Vector3 used for Unit.set_local_position not valid!")
				Unit.old_set_local_position(unit, node, position)
			end
		end

		if not Unit.old_set_local_rotation then
			Unit.old_set_local_rotation = Unit.set_local_rotation

			function Unit.set_local_rotation(unit, node, rotation)
				fassert(Quaternion.is_valid(rotation), "Quaternion used for Unit.set_local_position not valid!")

				local length = Quaternion.norm(rotation) < 10

				fassert(length, "Quaternion length is way to large, it should be normalized and thus have a length of 1, not %f", length)
				Unit.old_set_local_rotation(unit, node, rotation)
			end
		end
	else
		if Unit.old_set_local_position then
			Unit.set_local_position = Unit.old_set_local_position
			Unit.old_set_local_position = nil
		end

		if Unit.old_set_local_rotation then
			Unit.set_local_rotation = Unit.old_set_local_rotation
			Unit.old_set_local_rotation = nil
		end
	end
end

function DebugHelper.debug_rpcs(activate)
	local rpc_old = rawget(_G, "RPC_old")

	if activate and not rpc_old then
		print("DebugHelper.debug_rpcs(true)")
		rawset(_G, "RPC_old", RPC)

		RPC = {}

		local meta = {
			__index = function(t, k)
				return function(receiver, ...)
					local lobby = Managers.lobby.lobby
					local host = lobby and lobby:game_session_host()
					local peer_id = Network.peer_id()

					fassert(not host or host == peer_id or receiver == host, "Trying to send %q to clients without being server. Destination: %q Self: %q, Server: %q", k, receiver, peer_id, host)
					RPC_old[k](receiver, ...)
				end
			end
		}

		setmetatable(RPC, meta)
	elseif not activate and rpc_old then
		print("DebugHelper.debug_rpcs(false)")

		RPC = rpc_old

		rawset(_G, "RPC_old", nil)
	end
end

function DebugHelper.enable_physics_dump()
	local physics_namespaces = {
		"PhysicsWorld",
		"Actor",
		"Mover"
	}

	for _, namespace in pairs(physics_namespaces) do
		local namespace_to_debug = _G[namespace]

		for func_name, func in pairs(namespace_to_debug) do
			if type(func) == "function" then
				namespace_to_debug[func_name] = function(...)
					local output = string.format("%s.%s() : ", namespace, func_name)

					print(output, select(2, ...))

					return func(...)
				end
			end
		end
	end
end

function DebugHelper.spawn_test(player, max_amount, interval, position, radius, duration)
	local game_time = Managers.time:time("game")
	local data_table = {
		spawn_index = 1,
		position = Vector3Box(position),
		player = player,
		max_amount = max_amount,
		interval = interval,
		radius = radius,
		spawned = {},
		last_spawn = game_time,
		end_time = (duration or math.huge) + game_time
	}

	local function update_func(dt, data)
		if not Managers.state.network:game() then
			return true
		end

		local t = Managers.time:time("game")
		local last_spawn = data.last_spawn
		local interval = data.interval
		local next_spawn = last_spawn + interval
		local spawned = data.spawned
		local max_amount = data.max_amount
		local position = data.position:unbox()
		local player = data.player
		local end_time = data.end_time
		local hit_zones = {
			"head",
			"helmet",
			"torso",
			"stomach",
			"arms",
			"forearms",
			"hands",
			"legs",
			"calfs",
			"feet"
		}

		local function kill_unit(old_unit)
			local damage_ext = ScriptUnit.extension(old_unit, "damage_system")
			local random_direction = Quaternion.forward(Quaternion.multiply(Quaternion(Vector3.up(), 2 * math.pi * Math.random()), Quaternion(Vector3.forward(), math.acos(1 - 2 * Math.random()))))
			local hit_zone = hit_zones[Math.random(1, #hit_zones)]

			damage_ext:die(player, nil, true, "blunt", "up", hit_zone, random_direction, false, false, 0, "melee")
		end

		while next_spawn < t do
			local spawn_index = data.spawn_index
			local old_unit = spawned[spawn_index]

			if Unit.alive(old_unit) then
				kill_unit(old_unit)
			end

			local angle = Math.random() * 2 * math.pi
			local spawn_pos = position + radius * math.sqrt(Math.random()) * Vector3(math.sin(angle), math.cos(angle), 0)
			local unit = Managers.state.spawn:_spawn_player_unit(player, spawn_pos, Quaternion.identity(), false, 1)

			spawned[spawn_index] = unit

			if not unit then
				for _, unit in pairs(player.owned_units) do
					if Unit.alive(unit) and ScriptUnit.extension(unit, "damage_system"):is_alive() then
						kill_unit(unit)
					end
				end
			end

			data.spawn_index = spawn_index % max_amount + 1
			data.last_spawn = next_spawn
			next_spawn = next_spawn + interval

			if end_time < next_spawn then
				for _, unit in ipairs(spawned) do
					kill_unit(unit)
				end

				return true
			end
		end
	end

	Managers.state.debug:register_test(data_table, update_func)
end
