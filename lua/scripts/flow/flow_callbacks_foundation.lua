﻿-- chunkname: @scripts/flow/flow_callbacks_foundation.lua

function flow_query_script_data(params)
	local output_value

	if params.table then
		output_value = Unit.get_data(params.unit, params.table, params.scriptdata)
	else
		output_value = Unit.get_data(params.unit, params.scriptdata)
	end

	local returns = {
		value = output_value
	}

	return returns
end

function flow_set_script_data(params)
	if params.table then
		Unit.set_data(params.unit, params.table, params.scriptdata, params.value)
	else
		Unit.set_data(params.unit, params.scriptdata, params.value)
	end
end

function flow_script_data_compare_bool(params)
	local script_data_value
	local ref_value = params.reference
	local returns

	if params.table then
		local tab = split(params.table, "/")

		table.insert(tab, params.scriptdata)

		script_data_value = Unit.get_data(params.unit, unpack(tab))
	else
		script_data_value = Unit.get_data(params.unit, params.scriptdata)
	end

	if type(script_data_value) == "boolean" then
		if script_data_value == ref_value then
			returns = {
				equal = true,
				unequal = false
			}
		else
			returns = {
				equal = false,
				unequal = true
			}
		end

		return returns
	end
end

function flow_script_data_compare_string(params)
	local script_data_value
	local ref_value = params.reference
	local returns

	if params.table then
		local tab = split(params.table, "/")

		table.insert(tab, params.scriptdata)

		script_data_value = Unit.get_data(params.unit, unpack(tab))
	else
		script_data_value = Unit.get_data(params.unit, params.scriptdata)
	end

	if type(script_data_value) == "string" then
		if script_data_value == ref_value then
			returns = {
				equal = true
			}
		else
			returns = {
				unequal = true
			}
		end

		return returns
	end
end

function flow_script_data_compare_number(params)
	local script_data_value
	local ref_value = params.reference
	local returns

	if params.table then
		local tab = split(params.table, "/")

		table.insert(tab, params.scriptdata)

		script_data_value = Unit.get_data(params.unit, unpack(tab))
	else
		script_data_value = Unit.get_data(params.unit, params.scriptdata)
	end

	if type(script_data_value) == "number" then
		if script_data_value < ref_value then
			returns = {
				less = true
			}
		elseif script_data_value <= ref_value then
			returns = {
				less_or_equal = true
			}
		elseif script_data_value == ref_value then
			returns = {
				equal = true
			}
		elseif script_data_value ~= ref_value then
			returns = {
				unequal = true
			}
		elseif ref_value <= script_data_value then
			returns = {
				more_or_equal = true
			}
		elseif ref_value < script_data_value then
			returns = {
				more = true
			}
		end

		return returns
	end
end

function flow_callback_state_false(params)
	local returns = {
		updated = true,
		state = false
	}

	return returns
end

function flow_callback_state_true(params)
	local returns = {
		updated = true,
		state = true
	}

	return returns
end

function flow_callback_construct_vector3(params)
	local v = Vector3(params.x, params.y, params.z)
	local returns = {
		vector = v
	}

	return returns
end

function flow_callback_store_float(params)
	local stored_value = params.invalue
	local returns = {
		updated = true,
		state = true,
		outvalue = stored_value
	}

	return returns
end

function flow_callback_store_boolean(params)
	local stored_bool = params.inbool
	local returns = {
		updated = true,
		state = true,
		outbool = stored_bool
	}

	return returns
end

function flow_callback_math_addition(params)
	local term_one = params.term_one
	local term_two = params.term_two

	return {
		value = term_one + term_two
	}
end

function flow_callback_rotate_vector3(params)
	local direction = params.direction
	local vector3 = params.vector3

	vector3 = Quaternion.rotate(direction, vector3)

	return {
		vector = vector3
	}
end

function flow_callback_math_subtraction(params)
	local term_one = params.term_one
	local term_two = params.term_two

	return {
		value = term_one - term_two
	}
end

function flow_callback_math_multiplication(params)
	local factor_one = params.factor_one
	local factor_two = params.factor_two

	return {
		value = factor_one * factor_two
	}
end

function flow_callback_math_multiplication_vector3(params)
	local vector = params.vector
	local float = params.float

	return {
		value = vector * float
	}
end

function flow_callback_math_division(params)
	local dividend = params.dividend
	local divisor = params.divisor

	return {
		value = dividend / divisor
	}
end

function flow_callback_math_vector3_length(params)
	local vec = params.vector

	return Vector3.length(vec)
end

function flow_callback_trigger_event(params)
	Unit.flow_event(params.unit, params.event)
end

function flow_callback_set_unit_visibility(params)
	Unit.set_visibility(params.unit, params.group, params.visibility)
end

function flow_callback_reset_player_health(params)
	local damage = ScriptUnit.extension(player_base, "damage_system")

	damage:reset_health()
end

function flow_callback_distance_between(params)
	local unit = params.unit
	local node_1 = params.node1
	local node_2 = params.node2
	local node_index_1 = Unit.node(unit, node_1)
	local node_index_2 = Unit.node(unit, node_2)
	local world_position_1 = Unit.world_position(unit, node_index_1)
	local world_position_2 = Unit.world_position(unit, node_index_2)
	local distance_between = Vector3.distance(world_position_1, world_position_2)
	local returns = {
		distance = distance_between
	}

	return returns
end

function flow_callback_set_actor_enabled(params)
	local unit = params.unit

	assert(unit, "Set Actor Enabled flow node is missing unit")

	local actor = params.actor or Unit.actor(unit, params.actor_name)

	fassert(actor, "Set Actor Enabled flow node referring to unit %s is missing actor %s", tostring(unit), tostring(params.actor or params.actor_name))
	Actor.set_collision_enabled(actor, params.enabled)
	Actor.set_scene_query_enabled(actor, params.enabled)
end

function flow_callback_set_actor_kinematic(params)
	local unit = params.unit

	assert(unit, "Set Actor Kinematic flow node is missing unit")

	local actor = params.actor or Unit.actor(unit, params.actor_name)

	fassert(actor, "Set Actor Kinematic flow node referring to unit %s is missing actor %s", tostring(unit), tostring(params.actor or params.actor_name))
	Actor.set_kinematic(actor, params.enabled)
end

function flow_callback_spawn_actor(params)
	local unit = params.unit

	assert(unit, "Spawn Actor flow node is missing unit")

	local actor = params.actor_name

	Unit.create_actor(unit, actor)
end

function flow_callback_destroy_actor(params)
	local unit = params.unit

	assert(unit, "Destroy Actor flow node is missing unit")

	local actor = params.actor_name

	Unit.destroy_actor(unit, actor)
end

function flow_callback_set_actor_initial_velocity(params)
	local unit = params.unit

	assert(unit, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(unit, true)
end

function flow_callback_set_actor_initial_velocity(params)
	local unit = params.unit

	assert(unit, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(unit, true)
end

function flow_callback_set_unit_material_variation(params)
	local unit = params.unit
	local material_variation = params.material_variation

	Unit.set_material_variation(unit, material_variation)
end

function flow_callback_set_material_property_scalar(params)
	local unit = params.unit
	local mesh = params.mesh
	local material = params.material
	local variable = params.variable
	local value = params.value

	mesh = Unit.mesh(unit, mesh)
	material = Mesh.material(mesh, material)

	Material.set_scalar(material, variable, value)
end

function flow_callback_set_material_property_vector2(params)
	local unit = params.unit
	local mesh = params.mesh
	local material = params.material
	local variable = params.variable
	local value = Vector2(params.value.x, params.value.y)

	mesh = Unit.mesh(unit, mesh)
	material = Mesh.material(mesh, material)

	Material.set_vector2(material, variable, value)
end

function flow_callback_set_material_property_vector3(params)
	local unit = params.unit
	local mesh = params.mesh
	local material = params.material
	local variable = params.variable
	local value = params.value

	mesh = Unit.mesh(unit, mesh)
	material = Mesh.material(mesh, material)

	Material.set_vector3(material, variable, value)
end

function flow_callback_set_material_property_color(params)
	local unit = params.unit
	local mesh = params.mesh
	local material = params.material
	local variable = params.variable
	local color = params.color

	mesh = Unit.mesh(unit, mesh)
	material = Mesh.material(mesh, material)

	Material.set_color(material, variable, color)
end

function flow_callback_set_unit_light_state(params)
	local unit = params.unit
	local state = params.state
	local all_lights = params.all_lights

	if all_lights then
		local num_lights = Unit.num_lights(unit)

		if num_lights then
			for i = 1, num_lights do
				local light = Unit.light(unit, i - 1)

				Light.set_enabled(light, state)
			end
		else
			print("No Lights in unit")
		end
	else
		local light = params.light

		if light then
			local light = Unit.light(unit, light)

			Light.set_enabled(light, state)
		else
			print("No light named ", light, " in scene")
		end
	end
end

function flow_callback_set_unit_light_color(params)
	local unit = params.unit
	local color = params.color
	local all_lights = params.all_lights

	if all_lights then
		local num_lights = Unit.num_lights(unit)

		if num_lights then
			for i = 1, num_lights do
				local light = Unit.light(unit, i - 1)

				Light.set_color(light, color)
			end
		else
			print("No Lights in unit")
		end
	else
		local light = params.light

		if light then
			local light = Unit.light(unit, light)

			Light.set_color(light, color)
		else
			print("No light named ", light, " in scene")
		end
	end
end

function flow_callback_debug_print(params)
	local print_string

	if params.prefix then
		print_string = string.format("[flow:%s]", params.prefix)
	else
		print_string = "[flow]"
	end

	if params.unit then
		print_string = print_string .. string.format(" unit=%q", tostring(params.unit))
	end

	if params.actor then
		print_string = print_string .. string.format(" actor=%q", tostring(params.actor))
	end

	if params.bool then
		print_string = print_string .. string.format(" bool=%q", tostring(params.bool))
	end

	if params.string then
		print_string = print_string .. string.format(" string=%q", params.string)
	end

	if params.mover then
		print_string = print_string .. string.format(" mover=%q", tostring(params.mover))
	end

	if params.vector3 then
		print_string = print_string .. string.format(" vector3=%q", tostring(params.vector3))
	end

	if params.quaternion then
		print_string = print_string .. string.format(" quaternion=%q", tostring(params.quaternion))
	end

	if params.float then
		print_string = print_string .. string.format(" float=%f.2", params.float)
	end

	print(print_string)
end

function flow_callback_link_objects_in_units(params)
	local parentunit = params.parent_unit
	local childunit = params.child_unit
	local parentnodes = split(params.parent_nodes, ";")
	local childnodes = split(params.child_nodes, ";")
	local world = Unit.world(parentunit)

	for i = 1, #parentnodes - 1 do
		local parentnodeindex = Unit.node(parentunit, parentnodes[i])
		local childnode = childnodes[i]
		local childnodeindex

		if string.find(string.lower(childnode), "index(.)") then
			childnodeindex = tonumber(string.match(childnode, "%d+"))
		else
			childnodeindex = Unit.node(childunit, childnode)
		end

		World.link_unit(world, childunit, childnodeindex, parentunit, parentnodeindex)

		if params.parent_lod_object and params.child_lod_object then
			local parent_lod_object = Unit.lod_object(parentunit, params.parent_lod_object)
			local child_lod_object = Unit.lod_object(childunit, params.child_lod_object)

			LODObject.set_bounding_volume(child_lod_object, LODObject.bounding_volume(parent_lod_object))
			LODObject.set_orientation_node(child_lod_object, parentunit, LODObject.node(parent_lod_object))
		end
	end
end

function flow_callback_get_local_transform(params)
	local node = params.node
	local unit = params.unit
	local nodeindex

	if string.find(string.lower(node), "index(.)") then
		nodeindex = tonumber(string.match(node, "%d+"))
	else
		nodeindex = Unit.node(unit, node)
	end

	return {
		position = Unit.local_position(unit, nodeindex),
		rotation = Unit.local_rotation(unit, nodeindex),
		scale = Unit.local_scale(unit, nodeindex)
	}
end

function flow_callback_get_world_transform(params)
	local node = params.node
	local unit = params.unit
	local nodeindex

	if string.find(string.lower(node), "index(.)") then
		nodeindex = tonumber(string.match(node, "%d+"))
	else
		nodeindex = Unit.node(unit, node)
	end

	return {
		position = Unit.world_position(unit, nodeindex),
		rotation = Unit.world_rotation(unit, nodeindex)
	}
end

function flow_callback_render_cubemap(params)
	local unit = params.unit
	local path = params.path
	local unitPosition = Unit.world_position(unit, 0)

	LevelEditor.cubemap_generator:create(unitPosition, LevelEditor.shading_environment, path)
	Application.console_command("reload", "texture")
end

function split(text, sep)
	sep = sep or "\n"

	local lines = {}
	local pos = 1

	while true do
		local b, e = text:find(sep, pos)

		if not b then
			table.insert(lines, text:sub(pos))

			break
		end

		table.insert(lines, text:sub(pos, b - 1))

		pos = e + 1
	end

	return lines
end
