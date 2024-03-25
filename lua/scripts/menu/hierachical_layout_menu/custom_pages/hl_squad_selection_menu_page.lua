-- chunkname: @scripts/menu/hierachical_layout_menu/custom_pages/hl_squad_selection_menu_page.lua

HLSquadSelectionMenuPage = class(HLSquadSelectionMenuPage, HLMenuPage)

function HLSquadSelectionMenuPage:init(world, config)
	HLSquadSelectionMenuPage.super.init(self, world, config)

	local namespace_mappings = {
		"squad_1",
		"squad_2",
		"squad_3",
		"squad_4",
		"squad_5",
		"squad_6",
		"squad_7",
		"squad_8"
	}

	self._squad_namespace_mappings = MenuHelper:create_lookup_table(namespace_mappings)
	self._gamepad_grid_vector = {
		x = 1,
		y = 0
	}
	self.hide_banner = config.hide_banner

	local event_manager = Managers.state.event

	event_manager:register(self, "player_joined_team", "event_player_joined_team")
	event_manager:register(self, "player_left_team", "event_player_left_team")
	event_manager:register(self, "player_joined_squad", "event_player_joined_squad")
	event_manager:register(self, "player_left_squad", "event_player_left_squad")
end

function HLSquadSelectionMenuPage:update(dt, t)
	local local_player = self.config.local_player

	if local_player.team then
		Profiler.start("update squad menu layout_settings")
		self:_update_components_layout_settings(dt, t)
		Profiler.stop()
		Profiler.start("update squad menu component sizes")
		self:_update_components_sizes(dt, t)
		Profiler.stop()
		Profiler.start("update squad menu component positions")
		self:_update_components_positions(dt, t)
		Profiler.stop()
	else
		print("Attempting to UPDATE the squad screen without the player being on a team, should the squad screen be open?")
	end
end

function HLSquadSelectionMenuPage:set_input(input)
	local local_player = self.config.local_player

	if local_player.team then
		HLSquadSelectionMenuPage.super.set_input(self, input)

		local controller = Managers.input:active_mapping(input.slot)

		if controller == "pad360" then
			self:_update_pad_input(input)
		end
	else
		print("Attempting to SET INPUT in the squad screen without the player being on a team, should the squad screen be open?")
	end
end

function HLSquadSelectionMenuPage:_update_pad_input(input)
	local x, y = self._gamepad_grid_vector.x, self._gamepad_grid_vector.y

	if input:get("move_up") then
		y = math.max(y - 1, 0)
	elseif input:get("move_down") then
		y = math.min(y + 1, 1)
	end

	if input:get("move_left") then
		x = math.max(x - 1, 1)
	elseif input:get("move_right") then
		x = math.min(x + 1, 4)
	end

	self._gamepad_grid_vector.x = x
	self._gamepad_grid_vector.y = y

	local component, namespace_path = self:_get_gamepad_highlighted_item()

	self:_highlight_item(self:_get_gamepad_highlighted_item())

	if input:get("select_squad") then
		local local_player = self.config.local_player
		local squad = self:_get_squad(namespace_path)

		if self._squad_namespace_mappings[namespace_path[1]] == local_player.squad_index then
			squad:request_to_leave(local_player)
		else
			squad:request_to_join(local_player)
		end
	end

	if input:get("select") then
		self._menu_logic:goto("select_profile")
	end
end

function HLSquadSelectionMenuPage:_first_highlightable_item()
	return self:_get_gamepad_highlighted_item()
end

function HLSquadSelectionMenuPage:_get_gamepad_highlighted_item()
	local x, y = self._gamepad_grid_vector.x, self._gamepad_grid_vector.y
	local index = x + 1 + y * 4 - 1
	local namespace = self._squad_namespace_mappings[index]
	local namespace_path = {
		namespace
	}
	local component = self:component_by_namespace_path("join_squad_text", namespace_path)

	return component, namespace_path
end

function HLSquadSelectionMenuPage:event_player_joined_team(player)
	local local_player = self.config.local_player

	if not local_player.team or local_player.team.name == "unassigned" then
		return
	end

	if local_player == player then
		local team = local_player.team
		local members = team:get_members()
		local squads = team.squads

		for _, squad in ipairs(squads) do
			local namespace = self._squad_namespace_mappings[squad:index()]
			local namespace_path = {
				namespace
			}
			local squad_members_container = self:component_by_namespace_path("squad_members_container", namespace_path)
			local player_name_items = squad_members_container:components()

			for i = #player_name_items, 1, -1 do
				squad_members_container:remove_component(player_name_items[i])
			end
		end

		local namespace_path = {}
		local squadless_members_container = self:component_by_namespace_path("squadless_members_container", namespace_path)
		local player_name_items = squadless_members_container:components()

		for i = #player_name_items, 1, -1 do
			squadless_members_container:remove_component(player_name_items[i])
		end

		for _, member in pairs(members) do
			local squad_index = member.squad_index

			if squad_index then
				local namespace = self._squad_namespace_mappings[squad_index]
				local namespace_path = {
					namespace
				}

				self:_add_player_to_squad("squad_members_container", namespace_path, member)
			else
				local namespace_path = {}

				self:_add_player_to_squad("squadless_members_container", namespace_path, member)
			end
		end
	elseif local_player.team == player.team then
		local namespace_path = {}

		self:_add_player_to_squad("squadless_members_container", namespace_path, player)
	end
end

function HLSquadSelectionMenuPage:event_player_left_team(player)
	local local_player = self.config.local_player

	if local_player == player or local_player.team == player.team then
		local namespace_path = {}

		self:_remove_player_from_squad("squadless_members_container", namespace_path, player)
	end
end

function HLSquadSelectionMenuPage:event_player_joined_squad(player, squad_index)
	local local_player = self.config.local_player

	if local_player == player or local_player.team == player.team then
		local namespace = self._squad_namespace_mappings[squad_index]
		local namespace_path = {}

		self:_remove_player_from_squad("squadless_members_container", namespace_path, player)

		namespace_path = {
			namespace
		}

		self:_add_player_to_squad("squad_members_container", namespace_path, player)
	end

	if local_player == player then
		local timpani_world = World.timpani_world(self._world)
		local event_id = TimpaniWorld.trigger_event(timpani_world, "hud_join_squad")
	end
end

function HLSquadSelectionMenuPage:event_player_left_squad(player, squad_index)
	local local_player = self.config.local_player

	if local_player == player or local_player.team == player.team then
		local namespace = self._squad_namespace_mappings[squad_index]
		local namespace_path = {
			namespace
		}

		self:_remove_player_from_squad("squad_members_container", namespace_path, player)

		namespace_path = {}

		self:_add_player_to_squad("squadless_members_container", namespace_path, player)
	end
end

function HLSquadSelectionMenuPage:render(dt, t)
	local local_player = self.config.local_player

	if local_player.team then
		HLSquadSelectionMenuPage.super.render(self, dt, t)
	else
		print("Attempting to RENDER the squad screen without the player being on a team, should the squad screen be open?")
	end

	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)
end

function HLSquadSelectionMenuPage:cb_can_highlight_join_squad(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	return squad:can_join(local_player)
end

function HLSquadSelectionMenuPage:cb_join_squad_selected(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	squad:request_to_join(local_player)
end

function HLSquadSelectionMenuPage:cb_join_squad_text(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	return squad:locked() and "squad_locked" or squad:full() and "squad_full" or "join_squad"
end

function HLSquadSelectionMenuPage:cb_can_highlight_join_squadless(component_name, namespace_path)
	local local_player = self.config.local_player

	return local_player.squad_index and true or false
end

function HLSquadSelectionMenuPage:cb_join_squadless_selected(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad_id = local_player.squad_index

	if squad_id then
		local squad = local_player.team.squads[squad_id]

		squad:request_to_leave(local_player)
	end
end

function HLSquadSelectionMenuPage:cb_can_highlight_animal(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	return squad:corporal() == local_player
end

function HLSquadSelectionMenuPage:cb_animal_selected(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	squad:next_animal_index()
end

function HLSquadSelectionMenuPage:cb_squad_animal_background_colour(component_name, namespace_path)
	local squad_namespace = namespace_path[1]
	local squad_id = self._squad_namespace_mappings[squad_namespace]
	local colour = SquadSettings.squad_colours[squad_id].colour
	local alpha = self:_in_squad_alpha(namespace_path)

	return {
		alpha,
		colour[2],
		colour[3],
		colour[4]
	}
end

function HLSquadSelectionMenuPage:cb_squad_animal_texture(component_name, namespace_path)
	local squad = self:_get_squad(namespace_path)

	return SquadSettings.squad_animals[squad:animal_index()].texture
end

function HLSquadSelectionMenuPage:cb_squad_animal_colour(component_name, namespace_path)
	local item = self:component_by_namespace_path(component_name, namespace_path)
	local colour = item:default_colour()
	local alpha = self:_in_squad_alpha(namespace_path)

	return {
		alpha,
		colour[2],
		colour[3],
		colour[4]
	}
end

function HLSquadSelectionMenuPage:cb_squad_header_background_colour(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad_namespace = namespace_path[1]
	local squad_id = self._squad_namespace_mappings[squad_namespace]
	local squad = self:_get_squad(namespace_path)
	local colour = not (not squad:can_join() and local_player.squad_index ~= squad_id) and SquadSettings.squad_colours[squad_id].colour or {
		255,
		255,
		255,
		255
	}
	local alpha = self:_in_squad_alpha(namespace_path)

	return {
		alpha,
		colour[2],
		colour[3],
		colour[4]
	}
end

function HLSquadSelectionMenuPage:cb_squad_header_text(component_name, namespace_path)
	local squad = self:_get_squad(namespace_path)

	return squad:name()
end

function HLSquadSelectionMenuPage:cb_squad_header_text_colour(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)
	local item = self:component_by_namespace_path(component_name, namespace_path)
	local default_colour = item:default_colour()
	local colour = local_player.squad_index == squad:index() and HUDSettings.player_colors.squad_member or default_colour
	local alpha = self:_in_squad_alpha(namespace_path)

	return {
		alpha,
		colour[2],
		colour[3],
		colour[4]
	}
end

function HLSquadSelectionMenuPage:cb_join_squad_button_color(component_name, namespace_path)
	if Managers.input:active_mapping(1) ~= "pad360" then
		return {
			0,
			0,
			0,
			0
		}
	end

	local index = self._squad_namespace_mappings[namespace_path[1]]
	local x, y = self._gamepad_grid_vector.x, self._gamepad_grid_vector.y
	local position_index = x + 1 + y * 4 - 1
	local squad = self:_get_squad(namespace_path)
	local alpha = index ~= position_index and 0 or squad:full() and 75 or 255

	return {
		alpha,
		255,
		255,
		255
	}
end

function HLSquadSelectionMenuPage:cb_can_highlight_lock(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	return squad:corporal() == local_player
end

function HLSquadSelectionMenuPage:cb_lock_selected(component_name, namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)

	squad:next_lock_state()
end

function HLSquadSelectionMenuPage:cb_lock_texture(component_name, namespace_path)
	local squad = self:_get_squad(namespace_path)

	return squad:locked() and "squad_menu_locked" or "squad_menu_unlocked"
end

function HLSquadSelectionMenuPage:cb_select_team_pressed(component_name, namespace_path)
	self._menu_logic:goto("select_team")
end

function HLSquadSelectionMenuPage:cb_select_profile_pressed(component_name, namespace_path)
	self._menu_logic:goto("select_profile")
end

function HLSquadSelectionMenuPage:cb_can_highlight_player(component_name, namespace_path)
	local local_player = self.config.local_player

	return local_player.squad_index and local_player.is_corporal
end

function HLSquadSelectionMenuPage:_in_squad_alpha(namespace_path)
	local local_player = self.config.local_player
	local squad = self:_get_squad(namespace_path)
	local player_squad_index = local_player.squad_index

	return player_squad_index and player_squad_index ~= squad:index() and 120 or 255
end

function HLSquadSelectionMenuPage:_get_squad(namespace_path)
	local squad_namespace = namespace_path[1]
	local squad_id = self._squad_namespace_mappings[squad_namespace]
	local local_player = self.config.local_player
	local squad = local_player.team.squads[squad_id]

	return squad
end

function HLSquadSelectionMenuPage:_add_player_to_squad(component_name, namespace_path, player)
	local squad_members_container = self:component_by_namespace_path(component_name, namespace_path)
	local config = {
		name = "player_name",
		highlightable_func = "cb_can_highlight_player",
		namespace_path = squad_members_container:namespace_path(),
		player = player,
		layout_settings = component_name == "squadless_members_container" and SquadMenuSettings.squadless_member_name or SquadMenuSettings.squad_member_name
	}
	local player_name_item = HLSquadMemberNameMenuItem.create_from_config(self._world, config, self)

	squad_members_container:add_component(player_name_item)
end

function HLSquadSelectionMenuPage:_remove_player_from_squad(component_name, namespace_path, player)
	local squad_members_container = self:component_by_namespace_path(component_name, namespace_path)
	local player_name_items = squad_members_container:components()
	local component_to_remove

	for _, player_name_item in ipairs(player_name_items) do
		if player == player_name_item:player() then
			component_to_remove = player_name_item

			break
		end
	end

	if component_to_remove then
		squad_members_container:remove_component(component_to_remove)
	end
end

function HLSquadSelectionMenuPage.create_from_config(compiler_data, page_config, parent_page, callback_object)
	page_config.local_player = compiler_data.menu_data.local_player
	page_config.parent_page = parent_page

	return HLSquadSelectionMenuPage:new(compiler_data.world, page_config)
end
