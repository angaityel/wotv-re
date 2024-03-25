﻿-- chunkname: @scripts/flow/flow_callbacks.lua

require("scripts/flow/flow_callbacks_ai")
require("scripts/flow/flow_callbacks_foundation")

function flow_callback_odd_even(params)
	local number = params.number
	local even = number % 2 == 0
	local return_table = {}

	return_table.odd = not even
	return_table.even = even

	return return_table
end

function flow_callback_define_spawn(params)
	return
end

function flow_callback_animation_callback(params)
	Managers.state.event:trigger("animation_callback", "locomotion_system", params.unit, params.callback, params.param1)
end

function flow_callback_side_dominating_start(params)
	local side = params.team

	Managers.state.game_mode:flow_cb_side_dominating(side, true)
end

function flow_callback_side_dominating_stop(params)
	local side = params.team

	Managers.state.game_mode:flow_cb_side_dominating(side, false)
end

function flow_callback_activate_editor_spawn(params)
	Managers.state.spawn:activate_editor_spawnpoint(params.unit)
end

function flow_callback_enable_actor_draw(params)
	Managers.state.debug:enable_actor_draw(params.actor, params.color)
end

function flow_callback_disable_actor_draw(params)
	Managers.state.debug:disable_actor_draw(params.actor)
end

function flow_callback_add_squad_point(params)
	Managers.state.spawn:flow_cb_add_squad_point(params.unit)
end

function flow_callback_play_music(params)
	Managers.music:trigger_event(params.event)
end

function flow_callback_override_win_score(params)
	fassert(params.win_score, "[Flow] Win score is nil in override win score node")
	Managers.state.game_mode:override_win_score(params.win_score)
end

function flow_callback_create_spawn_area(params)
	if script_data.spawn_debug then
		print("area_spawn_activated")
		table.dump(params)
	end

	local areas = {}

	if params.area1 and params.area1 ~= "" then
		areas[#areas + 1] = params.area1
	end

	if params.area2 and params.area2 ~= "" then
		areas[#areas + 1] = params.area2
	end

	if params.area3 and params.area3 ~= "" then
		areas[#areas + 1] = params.area3
	end

	if params.area4 and params.area4 ~= "" then
		areas[#areas + 1] = params.area4
	end

	if params.area5 and params.area5 ~= "" then
		areas[#areas + 1] = params.area5
	end

	if params.area6 and params.area6 ~= "" then
		areas[#areas + 1] = params.area6
	end

	if script_data.spawn_debug then
		print("spawn_area_created", params.spawn_name, areas)
	end

	Managers.state.spawn:create_spawn_area(params.spawn_name, areas)
end

function flow_callback_activate_spawn_area(params)
	local team_name = Managers.state.team:name(params.side)

	fassert(team_name, "Trying to activate spawn area for side %s that doesn't exist.", params.side)
	Managers.state.spawn:activate_spawn_area(params.spawn_name, team_name, params.spawn_direction or Vector3.forward())
end

function flow_callback_deactivate_spawn_area(params)
	local team_name = Managers.state.team:name(params.side)

	fassert(team_name, "Trying to deactivate spawn area for side %s that doesn't exist.", params.side)
	Managers.state.spawn:deactivate_spawn_area(params.spawn_name, team_name)
end

function flow_callback_activate_sp_spawn_area(params)
	local team_name = Managers.state.team:name(params.side)

	fassert(team_name, "Trying to activate spawn area for side %s that doesn't exist.", params.side)
	Managers.state.spawn:activate_sp_spawn_area(params.spawn_name, team_name, params.spawn_direction or Vector3.forward(), params.spawn_profile)
end

function flow_callback_deactivate_sp_spawn_area(params)
	local team_name = Managers.state.team:name(params.side)

	fassert(team_name, "Trying to deactivate spawn area for side %s that doesn't exist.", params.side)
	Managers.state.spawn:deactivate_sp_spawn_area(params.spawn_name, team_name)
end

function flow_callback_activate_spawning(params)
	if script_data.spawn_debug then
		print("spawning activated")
	end

	Managers.state.spawn:activate_spawning()
end

function flow_callback_deactivate_spawning(params)
	if script_data.spawn_debug then
		print("spawning deactivated")
	end

	Managers.state.spawn:deactivate_spawning()
end

function flow_callback_activate_boundary_area(params)
	Managers.state.event:trigger("activate_boundary_area", params)
end

function flow_callback_deactivate_boundary_area(params)
	Managers.state.event:trigger("deactivate_boundary_area", params)
end

function flow_callback_set_spawn_area_priority(params)
	if params.priority == 0 then
		return
	end

	local team_name = Managers.state.team:name(params.side)

	fassert(team_name, "Trying to set spawn area priority for side %s that doesn't exist.", params.side)
	Managers.state.spawn:set_spawn_area_priority(params.spawn_name, team_name, params.priority)
end

function flow_callback_play_gear_timpani_event(params)
	local unit = params.unit
	local primary_gear = params.primary_gear
	local event_config = params.event_config
	local locomotion = ScriptUnit.extension(params.unit, "locomotion_system")
	local inventory = locomotion:inventory()
	local wielded_slots = inventory:wielded_slots()
	local wielded_slot

	if primary_gear then
		wielded_slot = wielded_slots.primary or wielded_slots.secondary or wielded_slots.dagger
	else
		wielded_slot = wielded_slots.shield
	end

	local gear = wielded_slot.gear

	gear:trigger_timpani_event(event_config, false)
end

function flow_callback_capture_point_add_unit(params)
	local trigger_unit = params.trigger_unit
	local unit = params.self_unit
	local ext = ScriptUnit.extension(unit, "objective_system")

	ext:flow_cb_add_player_unit(params.trigger_unit)
end

function flow_callback_capture_point_remove_unit(params)
	local trigger_unit = params.trigger_unit
	local unit = params.self_unit
	local ext = ScriptUnit.extension(unit, "objective_system")

	ext:flow_cb_remove_player_unit(params.trigger_unit)
end

local OBJECTIVES = {
	objective_point3 = 3,
	objective_point5 = 5,
	objective_point2 = 2,
	objective_point1 = 1,
	objective_point4 = 4
}

function flow_callback_objective_point_order(params)
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local table_size = table.size(params)

	for key, unit in pairs(params) do
		if Unit.alive(unit) then
			local objective_ext = ScriptUnit.extension(unit, "objective_system")

			objective_ext.objective_point_order_id = key

			Managers.state.event:trigger("objective_points_ordered", NetworkLookup.objective_point_order_ids[key], unit, table_size)
		end
	end

	if Managers.lobby.server then
		local objective_table = {}

		for key, unit in pairs(params) do
			if Unit.alive(unit) then
				objective_table[OBJECTIVES[key]] = unit
			end
		end

		Managers.state.game_mode:set_objective_point_order(objective_table)
	end
end

function flow_callback_add_objective_boundary_area(params)
	if Managers.lobby.server then
		local objective_unit = params.objective
		local side = params.side
		local boundary_area_name = params.boundary_area

		Managers.state.game_mode:add_objective_boundary_area(objective_unit, side, boundary_area_name)
	end
end

function flow_callback_add_objective_spawn_point(params)
	if Managers.lobby.server then
		local objective_unit = params.objective
		local side = params.side
		local spawn_point_name = params.spawn_name
		local spawn_direction = params.direction

		Managers.state.game_mode:add_objective_spawn_point(objective_unit, side, spawn_point_name, spawn_direction)
	end
end

function flow_callback_afro_enter_trigger(params)
	local unit = params.self_unit
	local ext = ScriptUnit.extension(unit, "interaction_system")

	ext:flow_cb_add_interaction_target(params.hit_unit, params.hit_actor)
end

function flow_callback_afro_exit_trigger(params)
	local unit = params.self_unit
	local ext = ScriptUnit.extension(unit, "interaction_system")

	ext:flow_cb_remove_interaction_target(params.hit_unit, params.hit_actor)
end

function flow_callback_projectile_enter_afro_trigger(params)
	local unit = params.self_unit
	local projectile_unit = params.projectile_unit

	if Unit.alive(unit) and Unit.alive(projectile_unit) and unit ~= Unit.get_data(projectile_unit, "user_unit") then
		Unit.flow_event(projectile_unit, "lua_projectile_enter_afro")

		local network_manager = Managers.state.network

		if not network_manager then
			return
		end

		local projectile_owner = Managers.player:owner(projectile_unit)

		if ScriptUnit.has_extension(unit, "locomotion_system") then
			local player = Managers.player:owner(unit)

			if player and projectile_owner then
				if projectile_owner.team ~= player.team then
					Managers.state.event:trigger("projectile_hit_afro", player, projectile_unit)

					if network_manager:game() then
						if Managers.lobby.server then
							network_manager:send_rpc_clients("rpc_projectile_hit_afro", player.game_object_id, projectile_owner.game_object_id)
						else
							network_manager:send_rpc_server("rpc_projectile_hit_afro", player.game_object_id, projectile_owner.game_object_id)
						end
					end

					Managers.state.event:trigger("bc_projectile_hit_afro", player, projectile_owner)
				end

				local projectile_owner_unit = projectile_owner.player_unit
				local projectile_owner_locomotion = ScriptUnit.has_extension(projectile_owner_unit, "locomotion_system") and ScriptUnit.extension(projectile_owner_unit, "locomotion_system")

				if projectile_owner_locomotion and projectile_owner_locomotion:has_perk("tag_on_bow_shot") then
					local tagging_manager = Managers.state.tagging

					if PlayerMechanicsHelper.tag_valid(projectile_owner, unit) and network_manager:game() then
						if Managers.lobby.server then
							if tagging_manager:can_tag_player_unit(projectile_owner, unit) then
								tagging_manager:add_player_unit_tag(projectile_owner, unit, Managers.time:time("round") + PlayerActionSettings.tagging.duration)
							end

							RPC.rpc_tagged_enemy_with_tag_on_bow_shot(projectile_owner:network_id(), network_manager:game_object_id(projectile_owner_unit))
						else
							local tagged_unit_id = network_manager:game_object_id(unit)
							local player_game_object_id

							network_manager:send_rpc_server("rpc_request_to_tag_player_unit", projectile_owner.game_object_id, tagged_unit_id)
							network_manager:send_rpc_server("rpc_tagged_enemy_with_tag_on_bow_shot", network_manager:game_object_id(projectile_owner_unit))
						end
					end
				end
			end
		end
	end
end

function flow_callback_debug_print_unit_actor(params)
	print("FLOW DEBUG: Unit: ", tostring(params.unit), "Actor: ", tostring(params.actor))
end

function flow_callback_objective_unit_spawned(params)
	return
end

function flow_callback_set_zone_name(params)
	if Unit.alive(params.unit) then
		local ext = ScriptUnit.extension(params.unit, "objective_system")

		ext:flow_cb_set_zone_name(params.volume_name)
	end
end

function flow_callback_objective_activate(params)
	print("[flow_callback_objective_activate]", params.self_unit, params.team)

	if Unit.alive(params.self_unit) then
		local ext = ScriptUnit.extension(params.self_unit, "objective_system")

		ext:flow_cb_set_active(params.team, true, false)
	end
end

function flow_callback_objective_activate_with_delay(params)
	if Unit.alive(params.self_unit) then
		local ext = ScriptUnit.extension(params.self_unit, "objective_system")

		ext:flow_cb_set_active(params.team, true, true)
	end
end

function flow_callback_objective_deactivate(params)
	if Unit.alive(params.self_unit) then
		local ext = ScriptUnit.extension(params.self_unit, "objective_system")

		ext:flow_cb_set_active(params.team, false, false)
	end
end

function flow_callback_set_team_side(params)
	Managers.state.team:flow_cb_set_team_side(params.team_name, params.game_mode_side, params.ai_controlled)
end

function flow_callback_give_score_to_side(params)
	local side = params.game_mode_side
	local score = params.score

	Managers.state.team:flow_cb_give_score(side, score)
end

function flow_callback_set_objective_owner(params)
	local ext = ScriptUnit.extension(params.self_unit, "objective_system")

	ext:flow_cb_set_owner(params.team)
end

function flow_callback_activate_auto_move(params)
	local ext = ScriptUnit.extension(params.self_unit, "objective_system")

	ext:flow_cb_set_auto_move(true)
end

function flow_callback_start_round(params)
	Managers.state.event:trigger("event_start_round", params)
end

function flow_callback_trigger_event(params)
	Unit.flow_event(params.unit, params.event)
end

function flow_callback_play_network_synched_particle_effect(params)
	local effect_name = params.effect
	local unit = params.unit
	local object_name = params.object
	local offset = params.offset or Vector3(0, 0, 0)
	local rotation_offset = params.rotation_offset or Quaternion.identity()
	local linked = params.linked or false
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local game_object_id = unit and linked and network_manager:unit_game_object_id(unit)

	assert(game, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect with no network game running.")
	assert(not unit or not linked or game_object_id, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect linked to unit not network_synched.")
	assert(unit or not object_name, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect at object in unit without defining unit.")

	local object = unit and object_name and Unit.node(unit, object_name) or 0

	Managers.state.event:trigger("event_play_particle_effect", effect_name, unit, object, offset, rotation_offset, linked)

	if unit and not game_object_id then
		local global_transform = Unit.world_pose(unit, object)
		local local_transform = Matrix4x4.from_quaternion_position(rotation_offset, offset)
		local transform = Matrix4x4.multiply(local_transform, global_transform)

		offset = Matrix4x4.translation(transform)
		rotation_offset = Matrix4x4.rotation(transform)
	end

	if Managers.lobby.server then
		network_manager:send_rpc_clients("rpc_play_particle_effect", NetworkLookup.effects[effect_name], game_object_id or 0, object, offset, rotation_offset, linked)
	else
		network_manager:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects[effect_name], game_object_id or 0, object, offset, rotation_offset, linked)
	end
end

function flow_callback_output_debug_console_text(params)
	local color = params.color or Vector3(255, 255, 255)
	local text = params.text_id

	if not text then
		print("Missing text id at:", Script.callstack())

		return
	end

	if params.number1 then
		if params.number2 then
			if params.number3 then
				text = string.format(text, params.number1, params.number2, params.number3)
			else
				text = string.format(text, params.number1, params.number2)
			end
		else
			text = string.format(text, params.number1)
		end
	end

	print(text)

	if params.network_sync then
		Managers.state.hud:network_output_console_text(text, color)
	else
		if not params.no_localization then
			text = L(text)
		end

		Managers.state.hud:output_console_text(text, color)
	end
end

function flow_callback_output_debug_screen_text(params)
	local text_size = params.text_size
	local time = params.time
	local color = params.color or Vector3(255, 255, 255)

	if not params.text_id then
		print("Missing text id at:", Script.callstack())

		return
	end

	if params.network_sync then
		Managers.state.debug_text:network_output_screen_text(params.text_id, text_size, time, color)
	else
		Managers.state.debug_text:output_screen_text(L(params.text_id), text_size, time, color)
	end
end

function flow_callback_output_debug_unit_text(params)
	local text_size = params.text_size
	local unit = params.unit
	local node_index = params.node and Unit.node(unit, params.node) or 0
	local offset = params.offset or Vector3(0, 0, 0)
	local time = params.time
	local color = params.color or Vector3(255, 255, 255)

	Managers.state.debug_text:clear_unit_text(unit, nil)

	if not params.text_id then
		print("Missing text id at:", Script.callstack())

		return
	end

	if params.network_sync then
		Managers.state.debug_text:network_output_unit_text(params.text_id, text_size, unit, node_index, offset, time, nil, color)
	else
		Managers.state.debug_text:output_unit_text(L(params.text_id), text_size, unit, node_index, offset, time, nil, color)
	end
end

function flow_callback_output_debug_world_text(params)
	local id = params.identifier
	local text_size = params.text_size
	local position = params.position + (params.offset or Vector3(0, 0, 0))
	local time = params.time
	local color = params.color or Vector3(255, 255, 255)

	assert(position, "[flow_callbacks] Position missing in flow node of type 'flow_callback_output_debug_world_text' with text_id '" .. params.text_id .. "'")
	assert(id, "[flow_callbacks] ID missing in flow node of type 'flow_callback_output_debug_world_text' with text_id '" .. params.text_id .. "'")
	Managers.state.debug_text:clear_world_text(id)

	if not params.text_id then
		print("Missing text id at:", Script.callstack())

		return
	end

	if params.network_sync then
		Managers.state.debug_text:network_output_world_text(params.text_id, text_size, position, time, id, color)
	else
		Managers.state.debug_text:output_world_text(L(params.text_id), text_size, position, time, id, color)
	end
end

function flow_callback_reload_level(params)
	local current_level = Managers.state.game_mode:level_key()
	local current_game_mode = Managers.state.game_mode:game_mode_key()

	Managers.state.network:load_next_level(current_level, current_game_mode, GameSettingsDevelopment.default_win_score, GameSettingsDevelopment.default_time_limit)
end

function flow_callback_sp_end_level(params)
	Managers.state.event:trigger("event_sp_level_ended")
end

function flow_callback_create_group(params)
	Managers.state.event:trigger("create_group", params.player_name, params.group_name, params.formation)
end

function flow_callback_menu_camera_dummy_spawned(params)
	Managers.state.event:trigger("menu_camera_dummy_spawned", params.camera_name, params.unit)
end

function flow_callback_menu_alignment_dummy_spawned(params)
	Managers.state.event:trigger("menu_alignment_dummy_spawned", params.alignment_name, params.unit)
end

function flow_callback_activate_interactable(params)
	local interactable_unit = params.interactable_unit
	local side = params.side

	if not ScriptUnit.has_extension(interactable_unit, "objective_system") then
		return
	end

	local extension = ScriptUnit.extension(interactable_unit, "objective_system")

	extension:flow_cb_activate_interactable(side)
end

function flow_callback_deactivate_interactable(params)
	local interactable_unit = params.interactable_unit
	local side = params.side

	if not ScriptUnit.has_extension(interactable_unit, "objective_system") then
		return
	end

	local extension = ScriptUnit.extension(interactable_unit, "objective_system")

	extension:flow_cb_deactivate_interactable(side)
end

function flow_callback_force_destroy_objective_unit(params)
	local objective_unit = params.objective_unit
	local extension = ScriptUnit.extension(objective_unit, "damage_system")

	extension:die(50000)
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

function flow_callback_set_interactable_owner(params)
	local unit = params.unit
	local side = params.side
	local ext = ScriptUnit.extension(unit, "objective_system")

	ext:flow_cb_set_owner(side)
end

function flow_callback_activate_cutscene(params)
	local start_camera = params.start_camera
	local end_event = params.end_event or ""

	Managers.state.entity:system("cutscene_system"):flow_cb_activate_cutscene(start_camera, end_event)
end

function flow_callback_execution_attacker_event(params)
	ExecutionHelper.attacker_event(params.unit, params.event)
end

function flow_callback_execution_victim_event(params)
	ExecutionHelper.victim_event(params.unit, params.event)
end

function flow_callback_play_head_animation(params)
	local locomotion = ScriptUnit.extension(params.unit, "locomotion_system")
	local inventory = locomotion:inventory()
	local head = inventory:head()

	if Unit.alive(head) then
		Unit.animation_event(head, params.animation_event_name)
	end
end

function flow_callback_set_default_camera_pose(params)
	local position = params.position
	local rotation = params.rotation

	assert(position, "No position passed to Set Default Camera Pose")
	assert(rotation, "No rotation passed to Set Default Camera Pose")
	Managers.state.event:trigger("set_default_camera_pose", position, rotation)
end

function flow_callback_modify_game_mode_time_limit(params)
	Managers.state.game_mode:modify_time_limit(params.time)

	local network_manager = Managers.state.network

	if network_manager:game() and Managers.lobby.server then
		local modified_time_limit = Managers.state.game_mode:time_limit()

		network_manager:send_rpc_clients("rpc_synch_game_mode_time_limit", modified_time_limit)
	end
end

function flow_callback_extend_attacker_time(params)
	local game_mode_manager = Managers.state.game_mode

	game_mode_manager:modify_time_limit(params.time)

	local network_manager = Managers.state.network

	if network_manager:game() and Managers.lobby.server then
		local modified_time_limit = Managers.state.game_mode:time_limit()

		network_manager:send_rpc_clients("rpc_synch_game_mode_time_limit", modified_time_limit)
	end

	game_mode_manager:trigger_event("time_extended", "attackers", params.time)
end

function flow_callback_assault_announcement(params)
	local side = params.side
	local announcement = params.announcement

	fassert(side and announcement and Announcements[announcement], "[flow_callback_assault_announcement] Missing side or announcement or the announcement isn't specified in Announcements")
	Managers.state.game_mode:trigger_event("assault_announcement", side, announcement)
end

function flow_callback_display_tutorial_box(params)
	local blackboard = {}
	local settings = SPTutorials[params.tutorial_name]

	blackboard.header_text = L(settings.ui_header)

	local desc = settings.ui_description

	if settings.ui_description_pad360 and Managers.input:pad_active(1) then
		desc = settings.ui_description_pad360
	end

	blackboard.text = L(desc)

	Managers.state.event:trigger("tutorial_box_activated", blackboard)
end

function flow_callback_remove_tutorial_box()
	Managers.state.event:trigger("tutorial_box_deactivated")
end

function flow_callback_set_unit_material_variation(params)
	local unit = params.unit
	local material_variation = params.material_variation

	Unit.set_material_variation(unit, material_variation)
end

function flow_callback_clear_projectiles(params)
	local unit = params.unit

	Managers.state.projectile:clear_projectiles(unit)
end

function flow_callback_setup_profiling_level_step_1()
	local mouse_fun = Mouse.pressed

	function Mouse.pressed(button_index)
		if button_index == 0 then
			Mouse.pressed = mouse_fun

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_2()
	local keyboard_fun = Keyboard.pressed

	function Keyboard.pressed(button_index)
		if button_index == 120 then
			Keyboard.pressed = keyboard_fun

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_3()
	if script_data.settings.dedicated_server then
		return
	end

	local cameras = Managers.state.entity:system("cutscene_system")._cameras
	local profiling_camera

	for camera_name, camera in pairs(cameras) do
		if camera_name == "profiling_camera" then
			profiling_camera = camera
		end
	end

	local unit = profiling_camera._unit
	local unit_pose = Unit.world_pose(unit, 0)
	local world = Application.main_world()
	local world_name = ScriptWorld.name(world)
	local viewport = ScriptWorld.global_free_flight_viewport(world, world_name)
	local free_flight_camera = ScriptViewport.camera(viewport)

	ScriptCamera.set_local_pose(free_flight_camera, unit_pose)
	Managers.state.event:trigger("force_close_ingame_menu")
end

function flow_callback_set_flow_object_set_enabled(params)
	assert(params.set, "[Flow Callback : Set Flow Object Set Enabled] No set set.")
	assert(params.enabled ~= nil, "[Flow Callback : Set Flow Object Set Enabled] No enabled set.")
	Managers.state.game_mode:flow_cb_set_flow_object_set_enabled(params.set, params.enabled)
end

flow_cb_set_flow_object_set_enabled = flow_callback_set_flow_object_set_enabled

function flow_callback_set_team_set_visibility(params)
	assert(params.side, "[Flow Callback : Set Team Object Set Visibility] No side set.")
	assert(params.set, "[Flow Callback : Set Team Object Set Visibility] No set set.")
	assert(params.visibility ~= nil, "[Flow Callback : Set Team Object Set Visibility] No visibility set.")
	Managers.state.game_mode:flow_cb_set_team_set_visibility(params.side, params.set, params.visibility)
end

function flow_callback_set_team_set_variation(params)
	assert(params.side, "[Flow Callback : Set Team Object Set Variation] No side set.")
	assert(params.set, "[Flow Callback : Set Team Object Set Variation] No set set.")
	Managers.state.game_mode:flow_cb_set_team_set_variation(params.side, params.set)
end

function flow_callback_play_footstep_surface_material_effects(params)
	EffectHelper.flow_cb_play_footstep_surface_material_effects(params.effect_name, params.unit, params.object, params.foot_direction)
end

function flow_callback_foot_step(params)
	local unit = params.unit
	local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_ext:flow_cb_footstep(params.foot)
end

function flow_callback_kill_local_player(params)
	local player = Managers.player:players()[1]
	local player_unit = player.player_unit

	if Unit.alive(player_unit) then
		local player_damage = ScriptUnit.extension(player_unit, "damage_system")

		player_damage:die(player)
	end
end

function flow_callback_set_game_mode_objective_text(params)
	Managers.state.event:trigger("set_game_mode_objective_text", params.game_mode_objective)
end

function flow_callback_trigger_sound(params)
	local timpani_world

	if params.world_name then
		local world = Managers.world:world(params.world_name)

		timpani_world = World.timpani_world(world)
	else
		local world = Application.main_world()

		timpani_world = World.timpani_world(world)
	end

	if params.unit then
		if params.actor then
			TimpaniWorld.trigger_event(timpani_world, params.event, params.unit, Unit.actor(params.unit, params.actor))
		else
			TimpaniWorld.trigger_event(timpani_world, params.event, params.unit)
		end
	elseif params.position then
		TimpaniWorld.trigger_event(timpani_world, params.event, params.position)
	else
		TimpaniWorld.trigger_event(timpani_world, params.event)
	end
end

function flow_callback_enable_invulnerability(params)
	local player = Managers.player:players()[1]
	local player_unit = player.player_unit

	if Unit.alive(player_unit) then
		local player_damage = ScriptUnit.extension(player_unit, "damage_system")

		player_damage:set_invulnerable(true)
	else
		player.spawn_as_invulnerable = true
	end
end

function flow_callback_disable_invulnerability(params)
	local player = Managers.player:players()[1]
	local player_unit = player.player_unit

	if Unit.alive(player_unit) then
		local player_damage = ScriptUnit.extension(player_unit, "damage_system")

		player_damage:set_invulnerable(false)
	else
		player.spawn_as_invulnerable = false
	end
end

function flow_callback_activate_death_zone(params)
	Managers.state.death_zone:activate_death_zone(params.volume_name)
end

function flow_callback_activate_damage_zone(params)
	Managers.state.death_zone:activate_damage_zone(params.volume_name, params.damage)
end

function flow_callback_activate_damage_over_time_zone(params)
	Managers.state.death_zone:activate_damage_over_time_zone(params.volume_name, params.damage, params.period)
end

function flow_callback_deactivate_zone(params)
	Managers.state.death_zone:deactivate_zone(params.volume_name)
end

function flow_callback_add_interactor_to_objective_unit(params)
	ScriptUnit.extension(params.self_unit, "objective_system"):flow_cb_add_player_unit(params.trigger_unit)
end

function flow_callback_remove_interactor_from_objective_unit(params)
	ScriptUnit.extension(params.self_unit, "objective_system"):flow_cb_remove_player_unit(params.trigger_unit)
end

function flow_callback_interact_assault_gate(params)
	ScriptUnit.extension(params.gate_unit, "objective_system"):interact_gate()
end

function flow_callback_open_assault_gate(params)
	ScriptUnit.extension(params.gate_unit, "objective_system"):open_gate()
end

function flow_callback_perma_open_assault_gate(params)
	ScriptUnit.extension(params.gate_unit, "objective_system"):perma_open_gate()
end

function flow_callback_crush_unit_by_assault_gate(params)
	ScriptUnit.extension(params.gate_unit, "objective_system"):crush_player_unit(params.target_unit)
end

function flow_callback_set_spline_limit(params)
	ScriptUnit.extension(params.self_unit, "objective_system"):flow_cb_set_spline_limit(params.limit_type, params.spline, params.acceleration)
end

function flow_callback_remove_spline_limit(params)
	ScriptUnit.extension(params.self_unit, "objective_system"):flow_cb_set_spline_limit(params.limit_type, nil, nil)
end

function flow_callback_print_variable(params)
	print(params.string, params.variable)
end

function flow_callback_enable_disable_destructible(params)
	local unit = params.unit
	local enable = params.enable
	local team_side = params.team_side
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	fassert(unit and damage_ext and enable ~= nil and team_side, "[FlowCallbacks] Destructible missing damage extension")
	damage_ext:enable_destructible(team_side, enable)
end

function flow_callback_award_payload_support_xp(params)
	if Managers.lobby.server then
		local friendly_units = ScriptUnit.extension(params.payload_unit, "objective_system"):friendly_units()

		for _, unit in pairs(friendly_units) do
			local player = Managers.player:owner(unit)

			Managers.state.event:trigger("section_cleared_payload", player)
		end
	end
end

function flow_callback_enable_objective_damage(params)
	local unit = params.unit
	local enable_damage = params.enable_damage
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	if damage_ext and damage_ext.enable_damage then
		damage_ext:enable_damage(enable_damage)
	end
end

function flow_callback_destroy_squad_flag(params)
	if Managers.lobby.server then
		local unit = params.unit
		local team_name = Unit.get_data(unit, "team_name")
		local team = Managers.state.team:team_by_name(team_name)

		for _, squad in pairs(team.squads) do
			local flag_unit = squad:squad_flag_unit()

			if flag_unit == unit then
				squad:destroy_squad_flag()

				return
			end
		end
	end
end

function flow_callback_start_bus_transition(params)
	Managers.music:start_bus_transition(params.bus_name, params.target_value, params.duration, params.transition_type, params.from_value)
end

function flow_callback_conquest_debug_score()
	Managers.state.event:trigger("event_debug_conquest_activate")
end

function flow_callback_game_mode_event(params)
	local announcement = params.announcement
	local side = params.side
	local param_1 = params.param_1 or ""
	local param_2 = params.param_2 or ""

	Managers.state.game_mode:trigger_event("flow", announcement, side, param_1, param_2)
end

function flow_callback_add_menu_banner(params)
	Managers.state.event:trigger("event_add_menu_banner", params.unit)
end

function flow_callback_thrown_projectile_bounce(params)
	local unit = params.unit

	if Unit.alive(unit) and ScriptUnit.has_extension(unit, "projectile_system") then
		local ext = ScriptUnit.extension(unit, "projectile_system")

		ext:flow_cb_bounce(params.hit_unit, params.hit_actor, params.position, params.normal)
	end
end

function flow_callback_is_dead_from_knocked_down(params)
	local unit = params.unit

	if Unit.alive(unit) and ScriptUnit.has_extension(unit, "damage_system") then
		local damage_ext = ScriptUnit.extension(unit, "damage_system")
		local instakilled = damage_ext:was_instakilled()
		local return_table = {}

		return_table["true"] = instakilled
		return_table["false"] = not instakilled

		return return_table
	end
end

function flow_callback_add_shield_dummy(params)
	local unit = params.unit
	local team_name = params.team_name

	Managers.state.event:trigger("add_shield_dummy", unit, team_name)
end

function flow_callback_add_main_shield_dummy(params)
	local unit = params.unit

	Managers.state.event:trigger("add_main_shield_dummy", params.unit)
end

function flow_callback_trap_touched(params)
	local trap_unit = params.trap_unit
	local victim_unit = params.victim_unit
	local victim = Managers.player:owner(victim_unit)
	local trap_manager = Managers.state.trap

	if trap_manager:can_trigger_trap(victim, trap_unit) then
		trap_manager:trigger_trap_server(victim, trap_unit)
	end
end

function flow_callback_blood_collision(params)
	local touched_unit = params.unit
	local actor = params.actor
	local my_unit = Actor.unit(actor)
	local position = params.position
	local normal = params.normal
	local velocity = Actor.velocity(actor)
	local MAX_VELOCITY = 1000

	if MAX_VELOCITY < velocity.x or velocity.x < -MAX_VELOCITY or MAX_VELOCITY < velocity.y or velocity.y < -MAX_VELOCITY or MAX_VELOCITY < velocity.z or velocity.z < -MAX_VELOCITY then
		velocity = Vector3(0, 0, -1)
	end

	Managers.state.event:trigger("event_blood_collision", touched_unit, position, normal, my_unit, velocity)
end

function flow_callback_unit_alive(params)
	local alive = Unit.alive(params.unit)
	local return_table = {}

	return_table["true"] = alive
	return_table["false"] = not alive

	return return_table
end

function flow_callback_concat_string(params)
	return {
		string = params.string1 .. params.string2
	}
end

function flow_callback_float_to_string(params)
	return {
		string = tostring(params.float)
	}
end

function flow_callback_vector3_to_string(params)
	return {
		string = tostring(params.vector3)
	}
end
