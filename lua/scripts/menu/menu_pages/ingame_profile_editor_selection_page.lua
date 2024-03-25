-- chunkname: @scripts/menu/menu_pages/ingame_profile_editor_selection_page.lua

IngameProfileEditorSelectionPage = class(IngameProfileEditorSelectionPage, ProfileEditorSelectionPage)

function IngameProfileEditorSelectionPage:init(config, item_groups, world)
	MenuPage.init(self, config, item_groups, world)

	self._world = world
	self._current_profile_index = 1
	self._set_profile_index = 1
	self._team_name = "red"
	self._mouse_pos = {
		0,
		0,
		disabled = true
	}
	self._local_player = config.local_player
	self.hide_banner = config.hide_banner
	self._disable_preview = config.disable_preview
	self._archetype = ProfileEditorContainer.create_from_config({
		name = "menu_class",
		world = self._world,
		callback_object = self
	})
	self._primary_weapon = ProfileEditorContainer.create_from_config({
		name = "menu_primary_weapon",
		world = self._world,
		callback_object = self
	})
	self._secondary_weapon = ProfileEditorContainer.create_from_config({
		name = "menu_secondary_weapon",
		world = self._world,
		callback_object = self
	})
	self._shield = ProfileEditorContainer.create_from_config({
		name = "menu_shield",
		world = self._world,
		callback_object = self
	})
	self._perk1 = ProfileEditorContainer.create_from_config({
		name = "menu_perk1",
		world = self._world,
		callback_object = self
	})
	self._perk2 = ProfileEditorContainer.create_from_config({
		name = "menu_perk2",
		world = self._world,
		callback_object = self
	})
	self._perk3 = ProfileEditorContainer.create_from_config({
		name = "menu_perk3",
		world = self._world,
		callback_object = self
	})
	self._perk4 = ProfileEditorContainer.create_from_config({
		name = "menu_perk4",
		world = self._world,
		callback_object = self
	})
	self._background = ProfileEditorRectMenuContainer.create_from_config()
	self._profiles = SimpleGridMenuContainer.create_from_config(self._item_groups.menu_items)
	self._containers = {}
	self._containers[#self._containers + 1] = self._archetype
	self._containers[#self._containers + 1] = self._primary_weapon
	self._containers[#self._containers + 1] = self._secondary_weapon
	self._containers[#self._containers + 1] = self._shield
	self._containers[#self._containers + 1] = self._perk1
	self._containers[#self._containers + 1] = self._perk2
	self._containers[#self._containers + 1] = self._perk3
	self._containers[#self._containers + 1] = self._perk4

	local viewer_world_name = self:_try_callback(self.config.callback_object, "cb_profile_viewer_world_name")
	local viewer_viewport = self:_try_callback(self.config.callback_object, "cb_profile_viewer_viewport_name", config.local_player)

	self._profile_viewer = ProfileViewerMenuContainer.create_from_config(viewer_world_name, viewer_viewport, MenuSettings.viewports.main_menu_profile_viewer)
	self._chat_activated = false

	Managers.state.event:register(self, "menu_alignment_dummy_spawned", "event_menu_alignment_dummy_spawned", "event_chat_input_activated", "event_chat_input_activated", "event_chat_input_deactivated", "event_chat_input_deactivated", "awarded_rank", "event_awarded_rank")
end

function IngameProfileEditorSelectionPage:event_menu_alignment_dummy_spawned(name, unit)
	if name == "player_without_mount" then
		self._profile_viewer:add_alignment_unit("player_without_mount", unit)
	elseif name == "player_with_mount" then
		self._profile_viewer:add_alignment_unit("player_with_mount", unit)
	elseif name == "mount" then
		self._profile_viewer:add_alignment_unit("mount", unit)
	end
end

function IngameProfileEditorSelectionPage:event_awarded_rank(rank)
	self._profile_data_loaded = false
end

function IngameProfileEditorSelectionPage:on_exit(on_cancel)
	if on_cancel then
		self._profile_viewer:clear()
	end

	for _, item_group in pairs(self._item_groups) do
		for _, item in pairs(item_group) do
			if item.on_deselect then
				item:on_deselect()
			end
		end
	end
end

function IngameProfileEditorSelectionPage:update(dt, t, render_from_child_page)
	ProfileEditorSelectionPage.super.update(self, dt, t, render_from_child_page)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, self._gui, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self:_render(dt, t, self._gui, layout_settings)
end

function IngameProfileEditorSelectionPage:on_enter(on_cancel)
	MenuPage.on_enter(self, on_cancel)

	if on_cancel then
		return
	end

	local team_name = self._local_player.team and self._local_player.team.name

	if not team_name or team_name == "unassigned" then
		team_name = "red"
	end

	self:set_team(team_name)

	self._current_profile_index = Application.user_setting("profile_selection") or self._current_profile_index

	if not self._profile_data_loaded then
		self:remove_items("menu_items")

		if not GameSettingsDevelopment.unlock_all then
			Managers.state.event:trigger("event_load_started", "menu_loading_profile", "menu_profile_loaded")
			Managers.persistence:connect(callback(self, "cb_backend_setup"))
		else
			local game_mode = Managers.state.game_mode:game_mode_key()
			local profiles = game_mode == "headhunter" and HeadHunterProfiles or GameSettingsDevelopment.enable_robot_player and RobotProfiles or PlayerProfiles

			self:_build_menu(profiles)

			self._profile_data_loaded = true
		end
	end

	self:cb_profile_highlighted(self._current_profile_index, true, true)

	if GameSettingsDevelopment.enable_robot_player then
		local profile = GameSettingsDevelopment.robot_player_profile
		local profile_index = profile == "random" and Math.random(1, #RobotProfiles) or profile

		self:cb_profile_selected(profile_index)
	end
end

function IngameProfileEditorSelectionPage:_build_menu(data_table)
	self:remove_items("menu_items")

	for idx, profile in ipairs(data_table) do
		local profile_index = idx
		local unlock_type = "profile"
		local unlock_key = PlayerProfiles[profile_index].unlock_key
		local entity_type = "profile"
		local entity_name = PlayerProfiles[profile_index].unlock_key
		local available, unavailable_reason = ProfileHelper:is_entity_avalible(unlock_type, unlock_key, entity_type, entity_name, PlayerProfiles[profile_index].release_name, PlayerProfiles[profile_index].developer_item, PlayerProfiles[profile_index].required_dlc)
		local required_rank = ProfileHelper:required_entity_rank(entity_type, entity_name)
		local config = {
			on_highlight = "cb_profile_highlighted",
			remove_func = "cb_profile_hidden",
			on_select = "cb_profile_selected",
			layout_settings = "ProfileEditorSettings.items.new_unlock_text_item_right_aligned",
			no_localization = true,
			name = profile.display_name,
			parent_page = self.config.parent_page,
			text = profile.display_name,
			on_select_args = {
				idx
			},
			on_highlight_args = {
				idx,
				false,
				true
			},
			sounds = self.config.sounds,
			show_required_rank = not available,
			required_rank = required_rank,
			disabled = not available,
			remove_args = {
				idx
			}
		}

		if not unavailable_reason or unavailable_reason ~= "dlc_not_equiped" then
			local item = NewUnlockTextMenuItem.create_from_config({
				world = self._world
			}, config, self)

			self:add_item(item, "menu_items")
		end
	end

	self:_load_profile()
end

function IngameProfileEditorSelectionPage:_load_profile()
	local game_mode = Managers.state.game_mode:game_mode_key()
	local profiles = game_mode == "headhunter" and HeadHunterProfiles or GameSettingsDevelopment.enable_robot_player and RobotProfiles or PlayerProfiles

	if not profiles[self._current_profile_index] then
		self._current_profile_index = 1
	end

	self._current_profile_copy = table.clone(profiles[self._current_profile_index])
	self._current_profile_archetype = Archetypes[self._current_profile_copy.archetype]

	if not self._disable_preview then
		self._profile_viewer:load_profile(self._current_profile_copy, self:cb_team_name())
		self._profile_viewer:update_coat_of_arms(self:cb_team_name())
	end

	self:_setup_locked_perks()
	self:_setup_container_textures()
end

function IngameProfileEditorSelectionPage:cb_profile_selected(profile_index)
	local game_mode = Managers.state.game_mode:game_mode_key()
	local profiles = game_mode == "headhunter" and HeadHunterProfiles or GameSettingsDevelopment.enable_robot_player and RobotProfiles or PlayerProfiles

	if profiles[profile_index] then
		self._local_player.state_data.spawn_profile = profile_index
		self._current_profile_index = profile_index
		self._set_profile_index = profile_index

		Application.set_win32_user_setting("profile_selection", profile_index)
		Application.save_win32_user_settings()
		Managers.state.spawn:request_spawn(self._local_player, true)
		self:_try_callback(self.config.callback_object, "cb_profile_selected")
		self._profile_viewer:clear()
	end
end

function IngameProfileEditorSelectionPage:set_team(team_name)
	self._team_name = team_name or "red"
end

function IngameProfileEditorSelectionPage:cb_spawn()
	local game_mode = Managers.state.game_mode:game_mode_key()
	local profiles = game_mode == "headhunter" and HeadHunterProfiles or GameSettingsDevelopment.enable_robot_player and RobotProfiles or PlayerProfiles

	if not self._current_profile_index or not profiles[self._current_profile_index] then
		self._current_profile_index = 1
	end

	self._local_player.state_data.spawn_profile = self._current_profile_index

	Managers.state.spawn:request_spawn(self._local_player, true)
	self:_try_callback(self.config.callback_object, "cb_profile_selected")
	self._profile_viewer:clear()
end

function IngameProfileEditorSelectionPage:cb_not_in_ghost_mode()
	return self._local_player.spawn_data.state ~= "cb_not_in_ghost_mode"
end

function IngameProfileEditorSelectionPage:_update_input(input)
	if not self._chat_activated then
		IngameProfileEditorSelectionPage.super._update_input(self, input)
	end
end

function IngameProfileEditorSelectionPage:_update_mouse_hover(input)
	if not self._chat_activated then
		IngameProfileEditorSelectionPage.super._update_mouse_hover(self, input)
	end
end

function IngameProfileEditorSelectionPage:event_chat_input_activated()
	self._chat_activated = true

	self:_highlight_item(nil)
end

function IngameProfileEditorSelectionPage:event_chat_input_deactivated()
	self._chat_activated = false
end

function IngameProfileEditorSelectionPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "ingame_profile_editor_selection",
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		local_player = compiler_data.menu_data.local_player,
		camera = page_config.camera or parent_page and parent_page:camera(),
		local_player = compiler_data.menu_data.local_player,
		hide_banner = page_config.hide_banner,
		disable_preview = page_config.disable_preview,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page,
		enable_chat = page_config.enable_chat
	}

	return IngameProfileEditorSelectionPage:new(config, item_groups, compiler_data.world)
end
