-- chunkname: @scripts/menu/menus/ingame_menu.lua

require("scripts/menu/menus/menu")
require("scripts/menu/menu_controller_settings/ingame_menu_controller_settings")
require("scripts/menu/menu_definitions/ingame_menu_definition")
require("scripts/menu/menu_callbacks/ingame_menu_callbacks")

IngameMenu = class(IngameMenu, Menu)

function IngameMenu:init(game_state, world, menu_data)
	IngameMenu.super.init(self, game_state, world, IngameMenuControllerSettings, IngameMenuSettings, IngameMenuDefinition, IngameMenuCallbacks, menu_data)

	self._world = world
	self._state = game_state
	self._local_player = menu_data.local_player
	self._camera_dummy_units = {}

	self:_spawn_banner_unit()
	Managers.state.event:register(self, "menu_camera_dummy_spawned", "event_menu_camera_dummy_spawned")
end

function IngameMenu:event_menu_camera_dummy_spawned(name, unit)
	self._camera_dummy_units[name] = unit
end

function IngameMenu:menu_banner_unit()
	return self._menu_banner_unit
end

function IngameMenu:_spawn_banner_unit()
	self._menu_banner_unit = World.spawn_unit(self._state.world, "units/menu/menu_banner")

	local camera = ScriptViewport.camera(ScriptWorld.viewport(self._state.world, self._local_player.viewport_name))
	local camera_unit = Camera.get_data(camera, "unit")

	World.link_unit(self._state.world, self._menu_banner_unit, 0, camera_unit, 0)
	Unit.set_local_position(self._menu_banner_unit, 0, Vector3(-2.7, 7.5, 0))
	Unit.set_unit_visibility(self._menu_banner_unit, false)
end

function IngameMenu:_activate_banner(activate)
	Unit.set_unit_visibility(self._menu_banner_unit, activate)

	self._banner_visible = activate
end

function IngameMenu:_update_banner()
	local page = self._menu_logic:current_page()

	if page.hide_banner then
		if self._banner_visible then
			Unit.set_unit_visibility(self._menu_banner_unit, false)

			self._banner_visible = false
		end
	elseif self._active then
		if not self._banner_visible then
			Unit.set_unit_visibility(self._menu_banner_unit, true)

			self._banner_visible = true
		end

		local unit_rot = Unit.world_rotation(self._menu_banner_unit, 0)
		local unit_pos = Unit.world_position(self._menu_banner_unit, 0)
		local unit_fwd = Quaternion.forward(unit_rot)
		local unit_rht = Quaternion.right(unit_rot)
		local unit_up = Quaternion.up(unit_rot)
		local light_pos = unit_pos + unit_fwd * 1 + math.sin(Managers.time:time("main")) * unit_rht * 1
		local light_dir = light_pos - unit_pos
		local num_meshes = Unit.num_meshes(self._menu_banner_unit)

		for i = 0, num_meshes - 1 do
			local mesh = Unit.mesh(self._menu_banner_unit, i)
			local num_materials = Mesh.num_materials(mesh)

			for material_index = 0, num_materials - 1 do
				local material = Mesh.material(mesh, material_index)

				Material.set_vector3(material, "sun_light_dir", light_dir)
			end
		end
	end
end

function IngameMenu:_load_camera()
	local viewport_name = self._local_player.viewport_name
	local camera_manager = Managers.state.camera

	camera_manager:add_viewport(viewport_name, Vector3.zero(), Quaternion.identity())
	camera_manager:load_node_tree(viewport_name, "default", "ingame_menu")
	camera_manager:set_camera_node(viewport_name, "default", "default")
	camera_manager:set_variable(viewport_name, "look_controller_input", Vector3Box(Vector3.zero()))
end

function IngameMenu:cb_on_enter_page(page)
	self._teleport_camera = true
	self._current_camera = page:camera()
end

function IngameMenu:update(dt, t)
	IngameMenu.super.update(self, dt, t)
	self:_update_camera_position(dt)
	self:_update_banner()

	local controller_active = Managers.input:pad_active(1)

	if controller_active and self:current_page_is_root() and self._input_source:get("cancel") then
		self:set_active(false)
	end
end

function IngameMenu:post_update(dt, t)
	World.update_unit(self._state.world, self._menu_banner_unit)

	local w, h = Gui.resolution()
	local distance = w / h / 1.7777777777777777

	Unit.set_local_position(self._menu_banner_unit, 0, Vector3(-2.9 * distance, 7.5, 0))
end

function IngameMenu:_update_camera_position(dt)
	local viewport_name = self._local_player.viewport_name
	local camera_dummy_unit = self._camera_dummy_units[self._current_camera]

	if camera_dummy_unit then
		local camera_manager = Managers.state.camera
		local new_position, new_rotation
		local dummy_position = Unit.local_position(camera_dummy_unit, 0)
		local dummy_rotation = Unit.local_rotation(camera_dummy_unit, 0)

		if self._teleport_camera then
			new_position = dummy_position
			new_rotation = dummy_rotation
			self._teleport_camera = false
		else
			local current_position = camera_manager:camera_position(viewport_name)
			local current_rotation = camera_manager:camera_rotation(viewport_name)

			new_position = Vector3.lerp(current_position, dummy_position, dt * MenuSettings.camera_lerp_speed)
			new_rotation = Quaternion.lerp(current_rotation, dummy_rotation, dt * MenuSettings.camera_lerp_speed)
		end

		camera_manager:set_node_tree_root_position(viewport_name, "default", new_position)
		camera_manager:set_node_tree_root_rotation(viewport_name, "default", new_rotation)
	end
end

function IngameMenu:set_active(flag)
	IngameMenu.super.set_active(self, flag)
	Window.set_show_cursor(flag)
	self:_activate_banner(flag)

	if flag then
		local camera = ScriptViewport.camera(ScriptWorld.viewport(self._state.world, self._local_player.viewport_name))
		local fov = Camera.vertical_fov(camera)

		script_data.fov_override = 48
	else
		script_data.fov_override = nil
	end

	Managers.state.event:trigger("ingame_menu_set_active", flag)

	if flag then
		Managers.state.hud:set_huds_enabled_except(false, {
			"game_mode_status",
			"spawn"
		})
	else
		Managers.state.hud:set_huds_enabled_except(true, {
			"chat",
			"chat_window"
		})
	end
end

function IngameMenu:enable_chat()
	local current_page = self:current_page()

	return current_page.config.enable_chat
end
