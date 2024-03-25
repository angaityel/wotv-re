-- chunkname: @scripts/menu/menu_pages/profile_editor_selection_page.lua

require("scripts/menu/menu_containers/simple_grid_menu_container")
require("scripts/menu/menu_containers/profile_viewer_menu_container")
require("scripts/hud/heraldry_base")
require("scripts/hud/heraldry_vikings")
require("scripts/hud/heraldry_saxons")
require("scripts/helpers/outfit_helper")

ProfileEditorSelectionPage = class(ProfileEditorSelectionPage, MenuPage)

function ProfileEditorSelectionPage:init(config, item_groups, world)
	ProfileEditorSelectionPage.super.init(self, config, item_groups, world)

	self._world = world
	self._current_profile_index = 1
	self._set_profile_index = 1
	self._team_name = "red"
	self._mouse_pos = {
		0,
		0,
		disabled = true
	}
	self._save_time = 0
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

	local alignment_dummy_units = self:_try_callback(self.config.callback_object, "cb_alignment_dummy_units")

	for name, unit in pairs(alignment_dummy_units) do
		self:add_menu_alignment_dummy(name, unit)
	end

	self:_create_editor_page()
	self:_create_name_input_page()
	self:_setup_profile_info()
	Managers.state.event:register(self, "reload_coat_of_arms", "event_reload_coat_of_arms")
end

function ProfileEditorSelectionPage:event_reload_coat_of_arms()
	self._profile_viewer:update_coat_of_arms(self:cb_team_name())
end

function ProfileEditorSelectionPage:_create_name_input_page()
	self._name_popup_page = MenuHelper:create_input_popup_page(self._world, self, self, "cb_name_popup_enter", "cb_name_popup_item_selected", "cb_name_popup_save_button_disabled", (self.config.z or 0) + 50, MenuSettings.sounds.default, "menu_rename_profile", MainMenuSettings.pages.text_input_popup, MainMenuSettings.items.popup_header, MainMenuSettings.items.popup_input, MainMenuSettings.items.popup_button, 3, 26)
end

function ProfileEditorSelectionPage:_create_editor_page()
	local page_config = {
		text = "test_menu_page",
		camera = "character_editor",
		layout_settings = "ProfileEditorSettings.pages.profile_editor",
		local_player = self.config.local_player,
		environment = self.config.environment,
		sounds = MenuSettings.sounds.default,
		profile_viewer = self._profile_viewer
	}
	local item_groups = {
		header_items = {},
		page_name = {},
		prev_link = {},
		team_switch = {},
		name_input = {},
		profile_select = {},
		profile_name = {}
	}

	self._profile_editor_page = ProfileEditorMainPage.create_from_config({
		world = self._world
	}, page_config, self, item_groups, self.config.callback_object)

	local config = {
		layout_settings = "ProfileEditorSettings.items.profile_name_input",
		name = "profile_input",
		disabled = true,
		max_text_length = 18,
		page = self._profile_editor_page,
		parent_page = self
	}
	local item = TextInputMenuItem.create_from_config({
		world = self._world
	}, config, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "name_input")

	local config = {
		text = "menu_profile_editor",
		layout_settings = "ProfileEditorSettings.items.name",
		disabled = true
	}
	local item = HeaderItem.create_from_config({
		world = self._world
	}, config, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "page_name")

	local config = {
		text = "menu_profile_name",
		layout_settings = "ProfileEditorSettings.items.profile_name",
		disabled = true
	}
	local item = HeaderItem.create_from_config({
		world = self._world
	}, config, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "profile_name")

	local config = {
		layout_settings = "ProfileEditorSettings.items.prev_link",
		name = "cancel",
		disabled_func = "cb_controller_enabled",
		text = "main_menu_cancel",
		on_select = "cb_cancel"
	}
	local item = HeaderItem.create_from_config({
		world = self._world
	}, config, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "prev_link")

	local config = {
		layout_settings = "ProfileEditorSettings.items.team_switch_right",
		name = "team_switch",
		on_select = "cb_change_team"
	}
	local item = SwitchMenuItem.create_from_config({
		world = self._world
	}, config, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "team_switch")

	local arrow_config_left = {
		layout_settings = "ProfileEditorSettings.items.prev_arrow_left",
		disabled_func = "cb_controller_enabled",
		on_select = "cb_previous_profile",
		parent_page = self._profile_editor_page
	}
	local item = ArrowMenuItem.create_from_config({
		world = self._world
	}, arrow_config_left, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "profile_select")

	local arrow_config_right = {
		layout_settings = "ProfileEditorSettings.items.next_arrow_left",
		disabled_func = "cb_controller_enabled",
		on_select = "cb_next_profile",
		parent_page = self._profile_editor_page
	}
	local item = ArrowMenuItem.create_from_config({
		world = self._world
	}, arrow_config_right, self._profile_editor_page)

	self._profile_editor_page:add_item(item, "profile_select")
end

function ProfileEditorSelectionPage:_setup_profile_info()
	self._elements = {}

	local profile_data = Managers.persistence:profile_data()

	if profile_data then
		local config = {
			layout_settings = "ProfileEditorSettings.items.experience_item",
			experience_callback = "cb_experience_data",
			on_select = "cb_wants_buy_gold",
			sounds = self.config.sounds.items.text,
			disabled_func = function()
				return not GameSettingsDevelopment.enable_micro_transactions
			end
		}
		local experience_item = ExperienceMenuItem.create_from_config({
			world = self._world
		}, config, self)

		self:add_item_group("profile_info")
		self:add_item(experience_item, "profile_info")
	end
end

function ProfileEditorSelectionPage:add_menu_alignment_dummy(name, unit)
	if name == "player_without_mount" then
		self._profile_viewer:add_alignment_unit("player_without_mount", unit)
	elseif name == "player_with_mount" then
		self._profile_viewer:add_alignment_unit("player_with_mount", unit)
	elseif name == "mount" then
		self._profile_viewer:add_alignment_unit("mount", unit)
	end
end

function ProfileEditorSelectionPage:_setup_locked_perks()
	for i = 1, 4 do
		local locked = self._current_profile_archetype.locked_perks["perk_" .. i]

		self["_perk" .. i]:set_locked(locked)
	end
end

function ProfileEditorSelectionPage:_setup_container_textures()
	self:set_archetype_info()
	self:set_primary_texture()
	self:set_secondary_texture()
	self:set_shield_texture()
	self:set_perk_texture(1)
	self:set_perk_texture(2)
	self:set_perk_texture(3)
	self:set_perk_texture(4)
end

function ProfileEditorSelectionPage:set_archetype_info()
	local name = self:cb_archetype_name()

	self._archetype:set_text(name)
end

function ProfileEditorSelectionPage:set_primary_texture()
	local primary_weapon = self._current_profile_copy.gear.primary

	if primary_weapon then
		local primary_gear = Gear[primary_weapon.name]
		local primary_texture = primary_gear.ui_texture

		self._primary_weapon:set_info(primary_texture, primary_gear)
		self._primary_weapon:set_text(primary_gear.ui_header)
	else
		self._primary_weapon:set_info(nil)
		self._primary_weapon:set_text(nil)
	end
end

function ProfileEditorSelectionPage:set_secondary_texture()
	local secondary_weapon = self._current_profile_copy.gear.secondary

	if secondary_weapon then
		local secondary_gear = Gear[secondary_weapon.name]
		local secondary_texture = secondary_gear.ui_texture

		self._secondary_weapon:set_info(secondary_texture, secondary_gear)
		self._secondary_weapon:set_text(secondary_gear.ui_header)
	else
		self._secondary_weapon:set_info(nil)
		self._secondary_weapon:set_text(nil)
	end
end

function ProfileEditorSelectionPage:set_shield_texture()
	local shield = self._current_profile_copy.gear.shield

	if shield then
		local shield_gear = Gear[shield.name]
		local shield_texture = shield_gear.ui_texture

		self._shield:set_info(shield_texture, shield_gear)
		self._shield:set_text(shield_gear.ui_header)
	else
		self._shield:set_info(nil)
		self._shield:set_text(nil)
	end
end

function ProfileEditorSelectionPage:set_perk_texture(perk_index)
	local perk_name = self._current_profile_copy.perks["perk_" .. perk_index]

	if perk_name then
		local perk = Perks[perk_name]
		local perk_texture = perk.ui_texture

		self["_perk" .. perk_index]:set_info(perk_texture, perk)

		self["_perk" .. perk_index].config.name = perk.ui_header
	else
		self["_perk" .. perk_index]:set_info(nil)

		self["_perk" .. perk_index].config.name = "menu_perk_" .. perk_index
	end
end

function ProfileEditorSelectionPage:on_exit(on_cancel)
	if on_cancel then
		self._profile_viewer:clear()
		Managers.state.camera:set_camera_node("menu_level_viewport", "default", "default")
		self:_save_settings()
	end

	for _, item_group in pairs(self._item_groups) do
		for _, item in pairs(item_group) do
			if item.on_deselect then
				item:on_deselect()
			end
		end
	end
end

function ProfileEditorSelectionPage:_save_settings()
	Application.set_user_setting("profile_selection", self._current_profile_index)
	Application.set_user_setting("profile_team", self._team_name)
	Application.save_user_settings()
end

function ProfileEditorSelectionPage:on_enter(on_cancel)
	ProfileEditorSelectionPage.super.on_enter(self, on_cancel)

	if on_cancel then
		self:_refresh_profile_names(PlayerProfiles)

		return
	end

	Managers.state.camera:set_camera_node("menu_level_viewport", "default", "sway")
	self:set_team(Application.user_setting("profile_team"))

	self._current_profile_index = Application.user_setting("profile_selection") or self._current_profile_index
	self._set_profile_index = self._current_profile_index

	if not self._profile_data_loaded then
		self:remove_items("menu_items")

		if not GameSettingsDevelopment.unlock_all then
			Managers.state.event:trigger("event_load_started", "menu_loading_profile", "menu_profile_loaded")
			Managers.persistence:connect(callback(self, "cb_backend_setup"))
		else
			self:_build_menu(PlayerProfiles)

			self._profile_data_loaded = true
		end
	else
		self:_build_menu(PlayerProfiles)
	end

	self:cb_profile_highlighted(self._current_profile_index, true)
end

function ProfileEditorSelectionPage:_build_menu(data_table)
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
			no_localization = true,
			on_highlight = "cb_profile_highlighted",
			remove_func = "cb_profile_hidden",
			on_select = "cb_profile_selected",
			layout_settings = "ProfileEditorSettings.items.new_unlock_text_item_right_aligned",
			name = "profile_" .. idx,
			parent_page = self.config.parent_page,
			text = profile.display_name,
			disabled = profile.no_editing or not available,
			on_select_args = {
				idx
			},
			on_highlight_args = {
				idx
			},
			has_unviewed_item = self:_unviewed_profile(profile),
			show_required_rank = not available,
			required_rank = required_rank,
			sounds = self.config.sounds,
			remove_args = {
				idx
			}
		}
		local item = NewUnlockTextMenuItem.create_from_config({
			world = self._world
		}, config, self)

		self:add_item(item, "menu_items")
	end

	self:_load_profile()
end

function ProfileEditorSelectionPage:_refresh_profile_names(data_table)
	for idx, profile in ipairs(data_table) do
		local item = self:find_item_by_name("profile_" .. idx)

		item:set_text(profile.display_name or "")
	end
end

function ProfileEditorSelectionPage:_load_profile()
	if not PlayerProfiles[self._current_profile_index] then
		self._current_profile_index = 1
	end

	self._current_profile_copy = table.clone(PlayerProfiles[self._current_profile_index])
	self._current_profile_archetype = Archetypes[self._current_profile_copy.archetype]

	self._profile_viewer:load_profile(self._current_profile_copy, self:cb_team_name())
	self._profile_viewer:update_coat_of_arms(self:cb_team_name())
	self:_setup_locked_perks()
	self:_setup_container_textures()
end

function ProfileEditorSelectionPage:update(dt, t, render_from_child_page)
	ProfileEditorSelectionPage.super.update(self, dt, t, render_from_child_page)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, self._gui, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self:_render(dt, t, self._gui, layout_settings)
	self:_update_camera(t)
	self._profiles:update_size(dt, t, self._gui, layout_settings.menu_items)
end

function ProfileEditorSelectionPage:_update_camera(t, render_from_child_page)
	local offset = Vector3(math.cos(t) * 0.3, math.sin(t), -math.cos(t) * -0.7) * 0.001

	Managers.state.camera:set_variable("menu_level_viewport", "offset_position", offset)
end

function ProfileEditorSelectionPage:_update_input(input)
	ProfileEditorSelectionPage.super._update_input(self, input)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._profiles:update_input(input, layout_settings.menu_items)

	local cursor = input:has("cursor") and input:get("cursor")

	if cursor then
		self:_update_scroller(cursor, input:get("release_left"), layout_settings.menu_items)
		self:_update_mouse_over(cursor, input:get("select_left_click"), layout_settings.menu_items)

		if self._profile_data_loaded then
			self._profile_viewer:update_input_rotation(input, layout_settings.profile_viewer)
		end

		for _, container in pairs(self._containers) do
			container:is_mouse_inside(cursor)
		end
	end
end

function ProfileEditorSelectionPage:_update_scroller(mouse_pos, release_left, layout_settings)
	if not mouse_pos or not self._scroll_mouse_pos or release_left then
		self._scroll_mouse_pos = nil

		return
	end

	local diff = mouse_pos[2] - self._scroll_mouse_pos

	self._profiles:update_scroller_position(-diff * 2)

	self._scroll_mouse_pos = mouse_pos[2]
end

function ProfileEditorSelectionPage:_update_mouse_over(mouse_pos, left_click, layout_settings)
	if mouse_pos then
		local mp = self._mouse_pos

		mp[1] = mouse_pos[1]
		mp[2] = mouse_pos[2]
		mp.disabled = false
	else
		self._mouse_pos.disabled = true

		return
	end

	if not left_click then
		return
	end

	local x1 = self._profiles:x()
	local x2 = x1 + self._profiles:current_width()
	local y1 = self._profiles:y() - self._profiles:current_height()
	local y2 = self._profiles:y()

	if self._profiles:is_inside_scroller(mouse_pos, layout_settings) then
		self._scroll_mouse_pos = mouse_pos[2]
	end
end

function ProfileEditorSelectionPage:_update_size(dt, t, gui, layout_settings)
	self._profile_viewer:update_size(dt, t, self._gui, layout_settings.profile_viewer)
	self._archetype:update_size(dt, t, self._gui, layout_settings.archetype)
	self._primary_weapon:update_size(dt, t, self._gui, layout_settings.primary_weapon)
	self._secondary_weapon:update_size(dt, t, self._gui, layout_settings.secondary_weapon)
	self._shield:update_size(dt, t, self._gui, layout_settings.shield)
	self._perk1:update_size(dt, t, self._gui, layout_settings.perk1)
	self._perk2:update_size(dt, t, self._gui, layout_settings.perk2)
	self._perk3:update_size(dt, t, self._gui, layout_settings.perk3)
	self._perk4:update_size(dt, t, self._gui, layout_settings.perk4)
	self._background:update_size(dt, t, self._gui, layout_settings.background)
	self._profiles:update_size(dt, t, self._gui, layout_settings.menu_items)

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:update_size(dt, t, self._gui, item_layout_settings)
			end
		end
	end
end

function ProfileEditorSelectionPage:_update_position(dt, t, layout_settings)
	local x, y, z = 0, 0, 1

	x, y = MenuHelper:container_position(self._background, layout_settings.background)

	self._background:update_position(dt, t, layout_settings.background, x, y, z)

	z = 5
	x, y = MenuHelper:container_position(self._cloaks, layout_settings.profile_viewer)

	self._profile_viewer:update_position(dt, t, layout_settings.profile_viewer, x, y, z)

	x, y = MenuHelper:container_position(self._archetype, layout_settings.archetype)

	self._archetype:update_position(dt, t, layout_settings.archetype, x, y, z)

	x, y = MenuHelper:container_position(self._primary_weapon, layout_settings.primary_weapon)

	self._primary_weapon:update_position(dt, t, layout_settings.primary_weapon, x, y, z)

	x, y = MenuHelper:container_position(self._secondary_weapon, layout_settings.secondary_weapon)

	self._secondary_weapon:update_position(dt, t, layout_settings.secondary_weapon, x, y, z)

	x, y = MenuHelper:container_position(self._shield, layout_settings.shield)

	self._shield:update_position(dt, t, layout_settings.shield, x, y, z)

	x, y = MenuHelper:container_position(self._perk1, layout_settings.perk1)

	self._perk1:update_position(dt, t, layout_settings.perk1, x, y, z)

	x, y = MenuHelper:container_position(self._perk2, layout_settings.perk2)

	self._perk2:update_position(dt, t, layout_settings.perk2, x, y, z)

	x, y = MenuHelper:container_position(self._perk3, layout_settings.perk3)

	self._perk3:update_position(dt, t, layout_settings.perk3, x, y, z)

	x, y = MenuHelper:container_position(self._perk4, layout_settings.perk4)

	self._perk4:update_position(dt, t, layout_settings.perk4, x, y, z)

	x, y = MenuHelper:container_position(self._profiles, layout_settings.menu_items)

	self._profiles:update_position(dt, t, layout_settings.menu_items, x, y, z or self.config.z or 0)

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			x, y = MenuHelper:container_position(nil, layout_settings[item_group])
			z = z or self.config.z or 0

			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:update_position(dt, t, item_layout_settings, x, y, item_layout_settings.z or z)

				y = y - item:height() - (item_layout_settings.spacing or 0)
			end
		end
	end
end

function ProfileEditorSelectionPage:_render(dt, t, gui, layout_settings)
	MenuHelper:render_wotv_menu_banner(dt, t, gui)
	self._profile_viewer:render(dt, t, self._gui, layout_settings.profile_viewer)

	if self._profile_data_loaded then
		self._archetype:render(dt, t, self._gui, layout_settings.archetype)
		self._primary_weapon:render(dt, t, self._gui, layout_settings.primary_weapon)
		self._secondary_weapon:render(dt, t, self._gui, layout_settings.secondary_weapon)
		self._shield:render(dt, t, self._gui, layout_settings.shield)
		self._perk1:render(dt, t, self._gui, layout_settings.perk1)
		self._perk2:render(dt, t, self._gui, layout_settings.perk2)
		self._perk3:render(dt, t, self._gui, layout_settings.perk3)
		self._perk4:render(dt, t, self._gui, layout_settings.perk4)
		self._background:render(dt, t, self._gui, layout_settings.background)
		self._profiles:render(dt, t, self._gui, layout_settings.menu_items)
	end

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:render(dt, t, self._gui, item_layout_settings)
			end
		end
	end
end

function ProfileEditorSelectionPage:_render_save_text(dt, t, layout_settings, render_from_child_page)
	if self._save_time > 0 then
		local alpha = self._save_time / 1
		local w, h = Gui.resolution()
		local min, max = Gui.text_extents(self._gui, "Saved", MenuSettings.fonts.hell_shark_36.font, 36)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}

		Gui.text(self._gui, "Saved", MenuSettings.fonts.hell_shark_36.font, 36, MenuSettings.fonts.hell_shark_36.material, Vector3(w * 0.5 - extents[1] * 0.5, h * 0.1, 999), Color(alpha * 255, 255, 255, 255))

		self._save_time = self._save_time - dt
	end
end

function ProfileEditorSelectionPage:set_team(team_name)
	self._team_name = team_name or "red"

	self:find_item_by_name("team_switch"):set_team_name(self._team_name)
end

function ProfileEditorSelectionPage:cb_change_name(idx)
	if self._mouse_pos.disabled or self._profiles:is_inside(self._mouse_pos) then
		local item = self:find_item_by_name("change_name_" .. idx)

		item:on_deselect()

		self._name_index = idx

		self._menu_logic:change_page(self._name_popup_page)
	end
end

function ProfileEditorSelectionPage:cb_name_popup_enter(args)
	local input_text = PlayerProfiles[self._name_index].display_name

	args.popup_page:find_item_by_name("text_input"):set_text(input_text)
end

function ProfileEditorSelectionPage:cb_name_popup_item_selected(args)
	if args.action == "save" then
		local input_text = args.popup_page:find_item_by_name("text_input"):text()

		PlayerProfiles[self._name_index].display_name = input_text

		self:find_item_by_name("profile_" .. self._name_index):set_text(input_text)
		self:_save_profile()
	end
end

function ProfileEditorSelectionPage:_save_profile()
	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_profiles_saved"))
	Managers.state.event:trigger("event_save_started", "menu_saving_profile", "menu_profile_saved")
end

function ProfileEditorSelectionPage:cb_profiles_saved(info)
	if info.error then
		Application.warning("Save error %q", info.error)
	end

	Managers.state.event:trigger("event_save_finished")

	self._save_time = 1
end

function ProfileEditorSelectionPage:cb_backend_setup(error_code)
	if error_code == nil then
		Managers.persistence:load_profile(callback(self, "cb_profile_loaded"))
	else
		Managers.state.event:trigger("event_load_finished")

		self._profile_data_loaded = true
	end
end

function ProfileEditorSelectionPage:cb_profile_loaded(data)
	Managers.state.event:trigger("event_load_finished")

	self._profile_data_loaded = true

	self:_build_menu(PlayerProfiles)
end

function ProfileEditorSelectionPage:cb_profile_selected(profile_index, override)
	if self._mouse_pos.disabled or self._profiles:is_inside(self._mouse_pos) or override then
		self._set_profile_index = profile_index

		self._profile_editor_page:set_profile_data(self._current_profile_copy, profile_index, self:cb_team_name())
		self._menu_logic:change_page(self._profile_editor_page)
	end
end

function ProfileEditorSelectionPage:cb_profile_highlighted(profile_index, override, ingame)
	if not PlayerProfiles[profile_index] then
		profile_index = 1
	end

	if self._mouse_pos.disabled or override or self._profiles:is_inside(self._mouse_pos) then
		self._current_profile_index = profile_index

		if not ingame then
			UnviewedUnlockedItemsHelper:view_item(PlayerProfiles[profile_index].unlock_key, SaveData)

			local item = self._profiles:item(profile_index)

			if item then
				self._profiles:item(profile_index):set_has_unviewed_item(false)
			end
		end

		self:_load_profile()
	end
end

function ProfileEditorSelectionPage:cb_profile_hidden(args)
	return OutfitHelper.profile_hidden(PlayerProfiles[args[1]])
end

function ProfileEditorSelectionPage:cb_experience_data()
	local profile_data = Managers.persistence:profile_data()
	local profile_attributes = profile_data and profile_data.attributes
	local coins = profile_attributes and profile_attributes.coins or 0
	local experience = profile_attributes and profile_attributes.experience or 0
	local experience_data = {
		coins = coins,
		experience = experience
	}

	return experience_data
end

function ProfileEditorSelectionPage:_setup_buy_gold_popup(reset_callback_name, success_callback)
	self._buy_gold_page = MenuHelper:create_buy_gold_popup_page(self._world, self, self, "cb_buy_gold_popup_enter", "cb_buy_gold_popup_item_selected", (self.config.z or 1) + 50, self.config.sounds, reset_callback_name, success_callback)
end

function ProfileEditorSelectionPage:cb_wants_buy_gold(reset_callback_name, success_callback)
	if GameSettingsDevelopment.enable_micro_transactions then
		self:_setup_buy_gold_popup(reset_callback_name, success_callback)
		self._menu_logic:change_page(self._buy_gold_page)
	end
end

function ProfileEditorSelectionPage:cb_gold_purchase_done(success, data)
	if data ~= "cancelled" then
		if success then
			self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_success"))

			if MenuSettings.sounds.buy_gold_success then
				local timpani_world = World.timpani_world(self._world)

				TimpaniWorld.trigger_event(timpani_world, MenuSettings.sounds.buy_gold_success)
				Managers.persistence:reload_profile_attributes(callback(self, "cb_profile_gold_reloaded"))
			end
		else
			self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_fail"))
		end
	else
		self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_select_amount"))
	end

	self:enable_buy_gold_popup_buttons(true)
end

function ProfileEditorSelectionPage:cb_profile_gold_reloaded(success)
	Managers.state.event:trigger("profile_gold_reloaded")
end

function ProfileEditorSelectionPage:enable_buy_gold_popup_buttons(enabled)
	for _, item in ipairs(self._buy_gold_page:items_in_group("button_list")) do
		item.config.disabled = not enabled
	end
end

function ProfileEditorSelectionPage:cb_buy_gold_popup_enter(args)
	self:enable_buy_gold_popup_buttons(true)
	self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_select_amount"))
end

function ProfileEditorSelectionPage:cb_buy_gold_popup_item_selected(args)
	local item_id = args.action
	local quantity = 1

	if type(args.action) == "table" and args.action[1] == "reset_character" then
		args.action[2]()
	elseif item_id then
		Managers.persistence:purchase_store_item(item_id, quantity, callback(self, "cb_gold_purchase_done"))
		self:enable_buy_gold_popup_buttons(false)
		self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_contacting_steam_store"))
	end
end

function ProfileEditorSelectionPage:cb_team_name()
	return self._team_name or "red"
end

function ProfileEditorSelectionPage:cb_change_team()
	self._team_name = self._team_name == "red" and "white" or "red"

	self:_load_profile()
end

function ProfileEditorSelectionPage:cb_set_team(team_name)
	self._team_name = team_name or self._team_name

	local item = self:find_item_by_name("team_switch")

	if item then
		item:set_team_name(self._team_name)
	end

	self:_load_profile()
end

function ProfileEditorSelectionPage:cb_team_color()
	local team_name = self:cb_team_name()

	if team_name == "white" then
		return {
			255,
			255,
			128,
			0
		}
	else
		return {
			255,
			200,
			200,
			255
		}
	end
end

function ProfileEditorSelectionPage:cb_archetype_name()
	return self._current_profile_archetype and self._current_profile_archetype.name or ""
end

function ProfileEditorSelectionPage:cb_profile_name()
	local current_profile = PlayerProfiles[self._current_profile_index]

	return current_profile.display_name or "missing"
end

function ProfileEditorSelectionPage:cb_coat_of_arms_highlighted()
	local item = self:find_item_by_name_in_group("coat_of_arms_link", "coat_of_arms_link")

	item:set_has_unviewed_item(false)
	UnviewedUnlockedItemsHelper:view_all_items_in_category("coat_of_arms", SaveData)
end

function ProfileEditorSelectionPage:cb_has_unviewed_coat_of_arms()
	return UnviewedUnlockedItemsHelper:has_unviewed_item_in_category("coat_of_arms")
end

function ProfileEditorSelectionPage:cb_controller_enabled()
	return Managers.input:pad_active(1)
end

function ProfileEditorSelectionPage:_unviewed_profile(profile)
	return UnviewedUnlockedItems[profile.unlock_key] and true or false
end

function ProfileEditorSelectionPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "profile_editor_selection",
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		local_player = compiler_data.menu_data.local_player,
		camera = page_config.camera or parent_page and parent_page:camera()
	}

	return ProfileEditorSelectionPage:new(config, item_groups, compiler_data.world)
end
