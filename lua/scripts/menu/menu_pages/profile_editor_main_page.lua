-- chunkname: @scripts/menu/menu_pages/profile_editor_main_page.lua

require("scripts/menu/menu_containers/profile_editor_container")
require("scripts/settings/archetypes")

ProfileEditorMainPage = class(ProfileEditorMainPage, MenuPage)

function ProfileEditorMainPage:init(config, item_groups, world)
	ProfileEditorMainPage.super.init(self, config, item_groups, world)

	self._world = world
	self._team_name = "red"
	self._save_time = 0
	self._altered_archetypes = {}
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
	self._helmets = ProfileEditorContainer.create_from_config({
		name = "menu_helmets",
		world = self._world,
		callback_object = self
	})
	self._armours = ProfileEditorContainer.create_from_config({
		name = "menu_patterns",
		world = self._world,
		callback_object = self
	})
	self._cloaks = ProfileEditorContainer.create_from_config({
		name = "menu_cloaks",
		world = self._world,
		callback_object = self
	})
	self._taunts = ProfileEditorContainer.create_from_config({
		name = "menu_taunts",
		world = self._world,
		callback_object = self
	})
	self._heads = ProfileEditorContainer.create_from_config({
		name = "menu_heads",
		world = self._world,
		callback_object = self
	})
	self._beards_hairs = ProfileEditorContainer.create_from_config({
		name = "menu_beards",
		world = self._world,
		callback_object = self
	})
	self._left_background = ProfileEditorRectMenuContainer.create_from_config()
	self._right_background = ProfileEditorRectMenuContainer.create_from_config()
	self._profile_viewer = self.config.profile_viewer

	local alignment_dummy_units = self:_try_callback(self.config.callback_object, "cb_alignment_dummy_units")

	for name, unit in pairs(alignment_dummy_units) do
		self:add_menu_alignment_dummy(name, unit)
	end

	self._camera_positions = {
		shield = "character_editor_shield",
		two_handed_axe = "character_editor_2h_axe",
		throwing_weapon = "character_editor_dagger",
		left = "character_editor_left",
		closeup = "character_editor_helmets",
		bow = "character_editor_bow",
		one_handed_axe = "character_editor_1h_axe",
		one_handed_sword = "character_editor_1h_sword",
		spear = "character_editor_spear",
		right = "character_editor_right"
	}
	self._containers = {}
	self._containers[#self._containers + 1] = self._archetype
	self._containers[#self._containers + 1] = self._primary_weapon
	self._containers[#self._containers + 1] = self._secondary_weapon
	self._containers[#self._containers + 1] = self._shield
	self._containers[#self._containers + 1] = self._perk1
	self._containers[#self._containers + 1] = self._perk2
	self._containers[#self._containers + 1] = self._perk3
	self._containers[#self._containers + 1] = self._perk4
	self._containers[#self._containers + 1] = self._helmets
	self._containers[#self._containers + 1] = self._armours
	self._containers[#self._containers + 1] = self._cloaks
	self._containers[#self._containers + 1] = self._taunts
	self._containers[#self._containers + 1] = self._heads
	self._containers[#self._containers + 1] = self._beards_hairs

	for index, container in pairs(self._containers) do
		container:set_highlight_func("cb_container_highlight", {
			id = index
		})
	end

	Managers.state.event:register(self, "animation_callback", "cb_animation_callback")

	self._visibility = {
		left = {
			self._archetype,
			self._primary_weapon,
			self._secondary_weapon,
			self._shield,
			self._perk1,
			self._perk2,
			self._perk3,
			self._perk4,
			self._left_background
		},
		right = {
			self._helmets,
			self._armours,
			self._cloaks,
			self._taunts,
			self._heads,
			self._beards_hairs,
			self._right_background
		}
	}

	self._helmets:set_new_item(true)
	self:_create_pages()
	self:_setup_profile_info()
end

function ProfileEditorMainPage:_setup_buy_gold_popup(reset_callback_name, success_callback)
	self._buy_gold_page = MenuHelper:create_buy_gold_popup_page(self._world, self, self, "cb_buy_gold_popup_enter", "cb_buy_gold_popup_item_selected", (self.config.z or 1) + 50, self.config.sounds, reset_callback_name, success_callback)
end

function ProfileEditorMainPage:_setup_profile_info()
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

function ProfileEditorMainPage:add_menu_alignment_dummy(name, unit)
	if name == "player_without_mount" then
		self._profile_viewer:add_alignment_unit("player_without_mount", unit)
	elseif name == "player_with_mount" then
		self._profile_viewer:add_alignment_unit("player_with_mount", unit)
	elseif name == "mount" then
		self._profile_viewer:add_alignment_unit("mount", unit)
	end
end

function ProfileEditorMainPage:_create_pages()
	local archetype_config = {
		layout_settings = "ProfileEditorSettings.pages.archetype",
		name = "archetype_page",
		specified_item_group = "archetypes",
		render_parent_page = true,
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._archetype_page = ArchetypeListPage.create_from_config({
		world = self._world
	}, archetype_config, self, {
		archetypes = {}
	}, self)

	local category_config = {
		layout_settings = "ProfileEditorSettings.pages.category",
		name = "category_page",
		render_parent_page = true,
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._category_page = CategoryListPage.create_from_config({
		world = self._world
	}, category_config, self, {
		category = {}
	}, self)

	local gear_config = {
		layout_settings = "ProfileEditorSettings.pages.gear",
		name = "gear_page",
		render_parent_page = true,
		environment = self.config.environment,
		sounds = self.config.sounds,
		tier_names = GearCategories
	}

	self._gear_page = TierListPage.create_from_config({
		world = self._world
	}, gear_config, self._category_page, {
		gear = {}
	}, self)

	local perk_config = {
		layout_settings = "ProfileEditorSettings.pages.perk",
		name = "perk_page",
		render_parent_page = true,
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._perk_page = PerkListPage.create_from_config({
		world = self._world
	}, perk_config, self, {
		perks = {}
	}, self)

	local pattern_config = {
		layout_settings = "ProfileEditorSettings.pages.cosmetics",
		name = "cosmetic_page",
		render_parent_page = true,
		reset_callback = "cb_reset_pattern",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._patterns_page = TierListPage.create_from_config({
		world = self._world
	}, pattern_config, self, {
		gear = {}
	}, self)

	local helmet_config = {
		layout_settings = "ProfileEditorSettings.pages.cosmetics",
		name = "helmet_page",
		render_parent_page = true,
		reset_callback = "cb_reset_helmet",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._helmets_page = GearListPage.create_from_config({
		world = self._world
	}, helmet_config, self, {
		gear = {}
	}, self)

	local helmet_variation_config = {
		layout_settings = "ProfileEditorSettings.pages.helmet_variations",
		name = "helmet_variation_page",
		render_parent_page = true,
		reset_callback = "cb_reset_helmet",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._helmet_variations_page = GearListPage.create_from_config({
		world = self._world
	}, helmet_variation_config, self._helmets_page, {
		gear = {}
	}, self)

	local heads_config = {
		layout_settings = "ProfileEditorSettings.pages.cosmetics",
		name = "heads_page",
		render_parent_page = true,
		reset_callback = "cb_reset_head",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._heads_page = GearListPage.create_from_config({
		world = self._world
	}, heads_config, self, {
		gear = {}
	}, self)

	local cloaks_config = {
		layout_settings = "ProfileEditorSettings.pages.cloaks",
		name = "cloaks_page",
		render_parent_page = true,
		reset_callback = "cb_reset_cloak_pattern",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._cloak_page = GearListPage.create_from_config({
		world = self._world
	}, cloaks_config, self, {
		gear = {},
		attachments = {}
	}, self)

	local cloak_patterns_config = {
		layout_settings = "ProfileEditorSettings.pages.cloak_patterns",
		name = "cloak_patterns_page",
		render_parent_page = true,
		reset_callback = "cb_reset_cloak_pattern",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._cloak_patterns_page = TierListPage.create_from_config({
		world = self._world
	}, cloak_patterns_config, self._cloak_page, {
		gear = {}
	}, self)

	local taunts_config = {
		layout_settings = "ProfileEditorSettings.pages.cosmetics",
		name = "taunt_page",
		render_parent_page = true,
		reset_callback = "cb_abort_taunt",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._taunt_page = GearListPage.create_from_config({
		world = self._world
	}, taunts_config, self, {
		gear = {}
	}, self)

	local shield_config = {
		layout_settings = "ProfileEditorSettings.pages.gear",
		name = "cosmetic_page",
		render_parent_page = true,
		environment = self.config.environment,
		sounds = self.config.sounds,
		tier_names = GearCategories
	}

	self._shield_page = TierListPage.create_from_config({
		world = self._world
	}, shield_config, self, {
		gear = {}
	}, self)

	local beard_hair_config = {
		layout_settings = "ProfileEditorSettings.pages.cosmetics",
		name = "beard_hair_page",
		render_parent_page = true,
		reset_callback = "cb_reset_head",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._beard_hair_page = GearListPage.create_from_config({
		world = self._world
	}, beard_hair_config, self, {
		gear = {}
	}, self)

	local beard_hair_colors = {
		layout_settings = "ProfileEditorSettings.pages.beard_hair_colors",
		name = "beard_hair_color_page",
		render_parent_page = true,
		reset_callback = "cb_reset_head",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._beard_hair_colors_page = GearListPage.create_from_config({
		world = self._world
	}, beard_hair_colors, self._beard_hair_page, {
		gear = {}
	}, self)
end

function ProfileEditorMainPage:update(dt, t, render_from_child_page)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_container_size(dt, t, layout_settings)
	self:_update_container_position(dt, t, layout_settings)
	self:_render_container(dt, t, layout_settings, render_from_child_page)
	MenuHelper:render_wotv_menu_banner(dt, t, self._gui)
	self:_update_camera(t, render_from_child_page)
	self:_update_animation(dt, t)
	ProfileEditorMainPage.super.update(self, dt, t)
end

function ProfileEditorMainPage:width()
	return self._width
end

function ProfileEditorMainPage:height()
	return self._height
end

function ProfileEditorMainPage:_save_profile_name()
	local item = self:find_item_by_name("profile_input")
	local text = item:text()

	if text == "" then
		text = self._current_profile_copy.original_display_name
	end

	if text ~= self._current_profile_copy.display_name then
		self._current_profile_copy.display_name = text

		self:_save_profile(true)
	end
end

function ProfileEditorMainPage:_update_camera(t, render_from_child_page)
	local offset = Vector3(math.cos(t) * 0.3, math.sin(t), -math.cos(t) * -0.7) * 0.001

	Managers.state.camera:set_variable("menu_level_viewport", "offset_position", offset)
end

function ProfileEditorMainPage:_update_animation(dt, t)
	if self._current_taunt_timer and self._current_taunt_timer < Managers.time:time("main") then
		self:cb_abort_taunt()
	end
end

function ProfileEditorMainPage:_update_container_visibility(render_from_child_page)
	for _, container in pairs(self._containers) do
		container:set_visibility(render_from_child_page and container:highlighted() or not render_from_child_page)
	end
end

function ProfileEditorMainPage:update_from_child_page(dt, t)
	self:update(dt, t, true)
end

function ProfileEditorMainPage:_update_container_size(dt, t, layout_settings)
	self._archetype:update_size(dt, t, self._gui, layout_settings.archetype)
	self._primary_weapon:update_size(dt, t, self._gui, layout_settings.primary_weapon)
	self._secondary_weapon:update_size(dt, t, self._gui, layout_settings.secondary_weapon)
	self._shield:update_size(dt, t, self._gui, layout_settings.shield)
	self._perk1:update_size(dt, t, self._gui, layout_settings.perk1)
	self._perk2:update_size(dt, t, self._gui, layout_settings.perk2)
	self._perk3:update_size(dt, t, self._gui, layout_settings.perk3)
	self._perk4:update_size(dt, t, self._gui, layout_settings.perk4)
	self._helmets:update_size(dt, t, self._gui, layout_settings.helmets)
	self._armours:update_size(dt, t, self._gui, layout_settings.armours)
	self._cloaks:update_size(dt, t, self._gui, layout_settings.cloaks)
	self._taunts:update_size(dt, t, self._gui, layout_settings.taunts)
	self._heads:update_size(dt, t, self._gui, layout_settings.heads)
	self._beards_hairs:update_size(dt, t, self._gui, layout_settings.beards)
	self._profile_viewer:update_size(dt, t, self._gui, layout_settings.profile_viewer)
	self._left_background:update_size(dt, t, self._gui, layout_settings.left_background)
	self._right_background:update_size(dt, t, self._gui, layout_settings.right_background)

	for item_group, items in pairs(self._item_groups) do
		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:update_size(dt, t, self._gui, item_layout_settings)
		end
	end
end

function ProfileEditorMainPage:_update_container_position(dt, t, layout_settings)
	local x, y, z = 0, 0, 1

	x, y = MenuHelper:container_position(self._left_background, layout_settings.left_background)

	self._left_background:update_position(dt, t, layout_settings.left_background, x, y, z)

	x, y = MenuHelper:container_position(self._right_background, layout_settings.right_background)

	self._right_background:update_position(dt, t, layout_settings.right_background, x, y, z)

	z = 5
	x, y = MenuHelper:container_position(self._archetype, layout_settings.archetype)

	self._archetype:update_position(dt, t, layout_settings.archetype, x, y, z)

	x, y = MenuHelper:container_position(self._primary_weapon, layout_settings.primary_weapon)

	self._primary_weapon:update_position(dt, t, layout_settings.primary_weapon, x, y, z)
	self._gear_page:set_position(x + self._primary_weapon:width(), y + self._primary_weapon:height(), self._primary_weapon:z())
	self._perk_page:set_position(x + self._primary_weapon:width(), y + self._primary_weapon:height(), self._primary_weapon:z())
	self._shield_page:set_position(x + self._primary_weapon:width(), y + self._primary_weapon:height(), self._primary_weapon:z())

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

	x, y = MenuHelper:container_position(self._helmets, layout_settings.helmets)

	self._helmets:update_position(dt, t, layout_settings.helmets, x, y, z)
	self._patterns_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._helmets_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._helmet_variations_page:set_position(x - self._helmets:width() - self._helmets_page:width(), y + self._helmets:height(), self._helmets:z())
	self._heads_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._cloak_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._cloak_patterns_page:set_position(x - self._helmets:width() - self._cloak_page:width(), y + self._helmets:height(), self._helmets:z())
	self._taunt_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._beard_hair_page:set_position(x - self._helmets:width(), y + self._helmets:height(), self._helmets:z())
	self._beard_hair_colors_page:set_position(x - self._helmets:width() - self._beard_hair_page:width(), y + self._helmets:height(), self._helmets:z())

	x, y = MenuHelper:container_position(self._armours, layout_settings.armours)

	self._armours:update_position(dt, t, layout_settings.armours, x, y, z)

	x, y = MenuHelper:container_position(self._cloaks, layout_settings.cloaks)

	self._cloaks:update_position(dt, t, layout_settings.cloaks, x, y, z)

	x, y = MenuHelper:container_position(self._heads, layout_settings.heads)

	self._heads:update_position(dt, t, layout_settings.heads, x, y, z)

	x, y = MenuHelper:container_position(self._taunts, layout_settings.taunts)

	self._taunts:update_position(dt, t, layout_settings.taunts, x, y, z)

	x, y = MenuHelper:container_position(self._beards_hairs, layout_settings.beards)

	self._beards_hairs:update_position(dt, t, layout_settings.beards, x, y, z)

	x, y = MenuHelper:container_position(self._cloaks, layout_settings.profile_viewer)

	self._profile_viewer:update_position(dt, t, layout_settings.profile_viewer, x, y, z)

	for item_group, items in pairs(self._item_groups) do
		x, y = MenuHelper:container_position(nil, layout_settings[item_group])
		z = self.config.z or z or 0

		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:update_position(dt, t, item_layout_settings, x, y, item_layout_settings.z or z)

			y = y - item:height()
		end
	end
end

function ProfileEditorMainPage:_render_container(dt, t, layout_settings, render_from_child_page)
	self._archetype:render(dt, t, self._gui, layout_settings.archetype, render_from_child_page)
	self._primary_weapon:render(dt, t, self._gui, layout_settings.primary_weapon, render_from_child_page)
	self._secondary_weapon:render(dt, t, self._gui, layout_settings.secondary_weapon, render_from_child_page)
	self._shield:render(dt, t, self._gui, layout_settings.shield, render_from_child_page)
	self._perk1:render(dt, t, self._gui, layout_settings.perk1, render_from_child_page)
	self._perk2:render(dt, t, self._gui, layout_settings.perk2, render_from_child_page)
	self._perk3:render(dt, t, self._gui, layout_settings.perk3, render_from_child_page)
	self._perk4:render(dt, t, self._gui, layout_settings.perk4, render_from_child_page)
	self._left_background:render(dt, t, self._gui, layout_settings.left_background)
	self._helmets:render(dt, t, self._gui, layout_settings.helmets, render_from_child_page)
	self._armours:render(dt, t, self._gui, layout_settings.armours, render_from_child_page)
	self._cloaks:render(dt, t, self._gui, layout_settings.cloaks, render_from_child_page)
	self._taunts:render(dt, t, self._gui, layout_settings.taunts, render_from_child_page)
	self._heads:render(dt, t, self._gui, layout_settings.heads, render_from_child_page)
	self._beards_hairs:render(dt, t, self._gui, layout_settings.beards, render_from_child_page)
	self._profile_viewer:render(dt, t, self._gui, layout_settings.profile_viewer)
	self._right_background:render(dt, t, self._gui, layout_settings.right_background)
	self:_render_save_text(dt, t, layout_settings, render_from_child_page)

	for item_group, items in pairs(self._item_groups) do
		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:render(dt, t, self._gui, item_layout_settings)
		end
	end
end

function ProfileEditorMainPage:_render_save_text(dt, t, layout_settings, render_from_child_page)
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

function ProfileEditorMainPage:_update_input(input)
	ProfileEditorMainPage.super._update_input(self, input)

	local selected = false
	local mouse_pos = input:has("cursor") and input:get("cursor")

	if mouse_pos then
		local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

		self._profile_viewer:update_input_rotation(input, layout_settings.profile_viewer)

		for _, container in pairs(self._containers) do
			local is_inside = container:is_mouse_inside(mouse_pos)

			if is_inside and input:get("select_left_click") then
				self:_select_container(container)

				selected = true
			end
		end
	end

	if not selected then
		self:set_visibility("both")
	end
end

function ProfileEditorMainPage:_select_container(container)
	local page_data = container:page_data()

	if page_data then
		container:on_select()
		self:set_visibility(self:_visibility_group(container))

		local page = page_data.page

		page:set_data(page_data.data_table)

		if page.set_dependency_object then
			page:set_dependency_object(container)
		end

		self._menu_logic:change_page(page)
	end
end

function ProfileEditorMainPage:move_up()
	if not self._current_container_highlight then
		return
	end

	local function include_if(index)
		local containers = self._containers
		local current_y = containers[self._current_container_highlight]:y()
		local y = containers[index]:y()

		return not containers[index]:locked() and current_y < y
	end

	local container = self._containers[self._current_container_highlight]
	local container_indices = self:_process_and_return_indices(include_if)

	container_indices = self:_closest_in_x_axis(container:x(), container_indices)
	container_indices = self:_closest_in_y_axis(container:y(), container_indices)
	self._current_container_highlight = container_indices[1] or self._current_container_highlight
end

function ProfileEditorMainPage:move_down()
	if not self._current_container_highlight then
		return
	end

	local function include_if(index)
		local containers = self._containers
		local current_y = containers[self._current_container_highlight]:y()
		local y = containers[index]:y()

		return not containers[index]:locked() and y < current_y
	end

	local container = self._containers[self._current_container_highlight]
	local container_indices = self:_process_and_return_indices(include_if)

	container_indices = self:_closest_in_x_axis(container:x(), container_indices)
	container_indices = self:_closest_in_y_axis(container:y(), container_indices)
	self._current_container_highlight = container_indices[1] or self._current_container_highlight
end

function ProfileEditorMainPage:move_left()
	if not self._current_container_highlight then
		return
	end

	local function include_if(index)
		local containers = self._containers
		local current = containers[self._current_container_highlight]:x()
		local x = containers[index]:x()

		return not containers[index]:locked() and x < current
	end

	local container = self._containers[self._current_container_highlight]
	local container_indices = self:_process_and_return_indices(include_if)

	container_indices = self:_closest_in_y_axis(container:y(), container_indices)
	container_indices = self:_closest_in_x_axis(container:x(), container_indices)
	self._current_container_highlight = container_indices[1] or self._current_container_highlight
end

function ProfileEditorMainPage:move_right()
	if not self._current_container_highlight then
		return
	end

	local function include_if(index)
		local containers = self._containers
		local current = containers[self._current_container_highlight]:x()
		local x = containers[index]:x()

		return not containers[index]:locked() and current < x
	end

	local container = self._containers[self._current_container_highlight]
	local container_indices = self:_process_and_return_indices(include_if)

	container_indices = self:_closest_in_y_axis(container:y(), container_indices)
	container_indices = self:_closest_in_x_axis(container:x(), container_indices)
	self._current_container_highlight = container_indices[1] or self._current_container_highlight
end

function ProfileEditorMainPage:_process_and_return_indices(if_include_func)
	local container_indices = {}

	for index, _ in pairs(self._containers) do
		container_indices[#container_indices + 1] = index
	end

	local indices = {}

	for _, index in ipairs(container_indices) do
		if if_include_func(index) then
			indices[#indices + 1] = index
		end
	end

	return indices
end

function ProfileEditorMainPage:_closest_in_x_axis(current_x, container_indices)
	local closest_diff = 1000
	local closest_index
	local containers = self._containers

	for _, index in ipairs(container_indices) do
		local x = containers[index]:x()
		local diff = math.abs(current_x - x)

		if diff < closest_diff then
			closest_diff = diff
			closest_index = index
		end
	end

	local new_indices = {}

	for _, index in ipairs(container_indices) do
		local x = containers[index]:x()
		local diff = math.abs(current_x - x)

		if closest_diff == diff then
			new_indices[#new_indices + 1] = index
		end
	end

	return new_indices
end

function ProfileEditorMainPage:_closest_in_y_axis(current_y, container_indices)
	local closest_diff = 1000
	local closest_index
	local containers = self._containers

	for _, index in ipairs(container_indices) do
		local y = containers[index]:y()
		local diff = math.abs(current_y - y)

		if diff < closest_diff then
			closest_diff = diff
			closest_index = index
		end
	end

	local new_indices = {}

	for _, index in ipairs(container_indices) do
		local y = containers[index]:y()
		local diff = math.abs(current_y - y)

		if closest_diff == diff then
			new_indices[#new_indices + 1] = index
		end
	end

	return new_indices
end

function ProfileEditorMainPage:_select_item()
	if self._current_container_highlight and Managers.input:pad_active(1) then
		local container = self._containers[self._current_container_highlight]

		self:_select_container(container)
	else
		ProfileEditorMainPage.super._select_item(self)
	end
end

function ProfileEditorMainPage:_auto_highlight_first_item()
	for index, item in pairs(self._containers) do
		if item:visible() then
			self._current_container_highlight = index

			break
		end
	end
end

function ProfileEditorMainPage:current_highlight()
	return self._current_container_highlight
end

function ProfileEditorMainPage:cb_container_highlight(container, args)
	if Managers.input:pad_active(1) then
		local current_container_highlight = self._current_container_highlight
		local container_index = args.id

		return current_container_highlight == container_index
	else
		return container:mouse_highlight()
	end
end

function ProfileEditorMainPage:on_enter(on_cancel)
	ProfileEditorMainPage.super.on_enter(self, on_cancel)

	if not on_cancel then
		local item = self:find_item_by_name("profile_input")
		local text = item:text()

		if text == "" then
			self:_refresh_profile_name()
		end
	end

	self._temporary_change = false

	self:_setup_data()
end

function ProfileEditorMainPage:on_exit(on_cancel)
	if on_cancel then
		self.config.parent_page:set_team(self._team_name)
		self:_save_profile_name()

		local item = self:find_item_by_name("profile_input")

		item:set_text("")
	end
end

function ProfileEditorMainPage:set_visibility(group)
	for group_name, items in pairs(self._visibility) do
		for _, item in ipairs(items) do
			local visible = group_name == group or group == "both"

			item:set_visibility(visible)
		end
	end

	self._current_visible = group
end

function ProfileEditorMainPage:_visibility_group(container)
	for group_name, items in pairs(self._visibility) do
		for _, item in ipairs(items) do
			if container == item then
				return group_name
			end
		end
	end

	return "both"
end

function ProfileEditorMainPage:set_profile_data(profile, profile_index, team_name)
	self._current_profile = PlayerProfiles[profile_index]
	self._current_profile_copy = table.clone(profile)
	self._current_archetype = Archetypes[self._current_profile.archetype]
	self._current_profile_index = profile_index
	self._altered_archetypes[self._current_profile_index] = self._altered_archetypes[self._current_profile_index] or {}
	self._altered_archetypes[self._current_profile_index][self._current_archetype.archetype_id] = table.clone(self._current_profile_copy)
	self._team_name = team_name or "red"

	self:find_item_by_name("team_switch"):set_team_name(self._team_name)

	local primary_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "primary")

	if not primary_weapon then
		self._shield:set_page_data(self._shield_page, {
			layout_settings = "ProfileEditorSettings.items.gear_item",
			on_select = "cb_gear_selected",
			weapon_slot = "shield",
			gear = self._current_archetype.gear.shield,
			camera = self._camera_positions.shield
		})
		self._shield:set_visibility(true)
	else
		local secondary_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "secondary")
		local allowed_shield = self:_check_allowed_shield(primary_weapon, secondary_weapon)

		if allowed_shield then
			self._shield:set_page_data(self._shield_page, {
				layout_settings = "ProfileEditorSettings.items.gear_item",
				on_select = "cb_gear_selected",
				on_highlight = "cb_gear_highlighted",
				weapon_slot = "shield",
				gear = self._current_archetype.gear.shield,
				camera = self._camera_positions.shield
			})
			self._shield:set_visibility(true)
		else
			self._shield:set_page_data()

			if GameSettingsDevelopment.hide_unavailable_gear_categories then
				self._shield:set_visibility(false)
			else
				self._shield:set_visibility(true)
			end
		end
	end
end

function ProfileEditorMainPage:_setup_data()
	local archetypes = {}

	for i = 1, #ArchetypeList do
		archetypes[#archetypes + 1] = ArchetypeList[i]
	end

	self._archetype:set_page_data(self._archetype_page, {
		layout_settings = "ProfileEditorSettings.items.archetype_item",
		on_select = "cb_archetype_selected",
		remove_func = "cb_archetype_hidden",
		archetypes = archetypes,
		camera = self._camera_positions.right
	})
	self._primary_weapon:set_page_data(self._category_page, {
		weapon_slot = "primary",
		gear = self._current_archetype.gear.primary,
		camera = self._camera_positions.left
	})
	self._secondary_weapon:set_page_data(self._category_page, {
		weapon_slot = "secondary",
		gear = self._current_archetype.gear.secondary,
		camera = self._camera_positions.left
	})

	for i = 1, 4 do
		local perk_slot = "perk_" .. i
		local perk_container_name = "_perk" .. i
		local locked = self._current_archetype.locked_perks[perk_slot]

		self[perk_container_name]:set_locked(locked)
		self[perk_container_name]:set_page_data()

		if not locked then
			self[perk_container_name]:set_page_data(self._perk_page, {
				layout_settings = "ProfileEditorSettings.items.perk_item",
				on_select = "cb_perk_selected",
				on_highlight = "cb_perk_highligthed",
				perks = self._current_archetype.perks,
				camera = self._camera_positions.left,
				perk_slot = perk_slot,
				archetype = self._current_archetype.archetype_id
			})
		end
	end

	local team_name = self:cb_team_name()
	local has_new = false
	local helmets = {}

	for i = 1, #self._current_archetype.cosmetics[team_name].helmet_names do
		local helmet_name = self._current_archetype.cosmetics[team_name].helmet_names[i]
		local helmet = Helmets[helmet_name]

		helmets[#helmets + 1] = helmet
		has_new = has_new or self:_has_unviewed_helmet(helmet)
	end

	self._helmets:set_page_data(self._helmets_page, {
		layout_settings = "ProfileEditorSettings.items.helmet_item",
		on_select = "cb_helmet_selected",
		on_highlight = "cb_helmet_highlighted",
		on_highlight_new_item = "cb_helmet_unviewed_item",
		gear = helmets,
		camera = self._camera_positions.closeup
	})
	self._helmets:set_new_item(has_new)

	local current_armour_name = self._current_profile_copy["armour_" .. self:cb_team_name()]
	local current_armour = Armours[current_armour_name]
	local patterns = current_armour.attachment_definitions.patterns
	local num_patterns = #patterns

	has_new = false

	for i = 1, num_patterns do
		local pattern_name = patterns[i].name

		if UnviewedUnlockedItems[pattern_name] then
			has_new = true
		end
	end

	self._armours:set_page_data(self._patterns_page, {
		layout_settings = "ProfileEditorSettings.items.pattern_item",
		on_select = "cb_pattern_selected",
		on_highlight = "cb_pattern_highlighted",
		gear = patterns,
		camera = self._camera_positions.right
	})
	self._armours:set_new_item(has_new)

	local heads = {}

	for i = 1, #self._current_archetype.cosmetics[team_name].head_names do
		local helmet_name = self._current_archetype.cosmetics[team_name].head_names[i]

		heads[#heads + 1] = Heads[helmet_name]
	end

	self._heads:set_page_data(self._heads_page, {
		layout_settings = "ProfileEditorSettings.items.helmet_item",
		on_select = "cb_head_selected",
		on_highlight = "cb_head_highlighted",
		gear = heads,
		camera = self._camera_positions.closeup
	})

	local cloaks = {}

	has_new = false

	for i = 1, #self._current_archetype.cosmetics[team_name].cloak_names do
		local cloak_name = self._current_archetype.cosmetics[team_name].cloak_names[i]
		local cloak = Cloaks[cloak_name]

		cloaks[#cloaks + 1] = cloak
		has_new = has_new or self:_has_unviewed_cloak(cloak)
	end

	self._cloaks:set_page_data(self._cloak_page, {
		layout_settings = "ProfileEditorSettings.items.cloak_item",
		on_select = "cb_cloak_selected",
		on_highlight = "cb_cloak_highlighted",
		on_highlight_new_item = "cb_cloak_unviewed_item",
		gear = cloaks,
		camera = self._camera_positions.right
	})
	self._cloaks:set_new_item(has_new)

	local taunts = {}
	local archetype = self._current_archetype
	local movement_settings = archetype.movement_settings

	has_new = false

	for name, taunt_name in ipairs(archetype.taunts) do
		taunts[#taunts + 1] = movement_settings.taunts[taunt_name]

		if UnviewedUnlockedItems[taunt_name] then
			has_new = true
		end
	end

	self._taunts:set_page_data(self._taunt_page, {
		layout_settings = "ProfileEditorSettings.items.taunt_item",
		on_select = "cb_taunt_selected",
		on_highlight = "cb_taunt_highlighted",
		gear = taunts,
		camera = self._camera_positions.right
	})
	self._taunts:set_new_item(has_new)

	local beards = {}
	local head = Heads[self._current_profile_copy["head_" .. self:cb_team_name()]]

	has_new = false

	for _, beard in ipairs(head.beard_variations) do
		beards[#beards + 1] = beard

		if self:_has_unviewed_beard(beard) then
			has_new = true
		end
	end

	self._beards_hairs:set_new_item(has_new)

	if #beards == 0 then
		self._beards_hairs:set_page_data(self._beard_hair_page, nil)
	else
		self._beards_hairs:set_page_data(self._beard_hair_page, {
			layout_settings = "ProfileEditorSettings.items.beard_item",
			on_select = "cb_beard_selected",
			on_highlight = "cb_beard_highlighted",
			on_highlight_new_item = "cb_beard_unviewed_item",
			gear = beards,
			camera = self._camera_positions.closeup
		})
	end

	self:_setup_container_textures()
end

function ProfileEditorMainPage:_refresh_profile_name()
	local item = self:find_item_by_name("profile_input")
	local text = item:text()

	item:set_text(self._current_profile_copy.display_name or "")
end

function ProfileEditorMainPage:_load_profile()
	local primary_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "primary")

	if not primary_weapon then
		self._shield:set_page_data(self._shield_page, {
			layout_settings = "ProfileEditorSettings.items.gear_item",
			on_select = "cb_gear_selected",
			on_highlight = "cb_gear_highlighted",
			weapon_slot = "shield",
			gear = self._current_archetype.gear.shield,
			camera = self._camera_positions.shield
		})
		self._shield:set_visibility(true)
	else
		local secondary_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "secondary")
		local allowed_shield = self:_check_allowed_shield(primary_weapon, secondary_weapon)

		if allowed_shield then
			self._shield:set_page_data(self._shield_page, {
				layout_settings = "ProfileEditorSettings.items.gear_item",
				on_select = "cb_gear_selected",
				on_highlight = "cb_gear_highlighted",
				weapon_slot = "shield",
				gear = self._current_archetype.gear.shield,
				camera = self._camera_positions.shield
			})
			self._shield:set_visibility(true)
		else
			self._shield:set_page_data()

			if GameSettingsDevelopment.hide_unavailable_gear_categories then
				self._shield:set_visibility(false)
			else
				self._shield:set_visibility(true)
			end
		end
	end

	self._profile_viewer:load_profile(self._current_profile_copy, self:cb_team_name())
	self._profile_viewer:update_coat_of_arms(self:cb_team_name())
end

function ProfileEditorMainPage:_check_allowed_shield(primary_weapon, secondary_weapon)
	if ProfileHelper:has_perk("berserk_01", self._current_profile_copy) then
		return false
	end

	local primary_weapon_name = primary_weapon and primary_weapon.name
	local secondary_weapon_name = secondary_weapon and secondary_weapon.name
	local primary_weapon_gear_type = primary_weapon_name and Gear[primary_weapon_name].gear_type
	local secondary_weapon_gear_type = secondary_weapon_name and Gear[secondary_weapon_name].gear_type
	local primary_allowed_shield = primary_weapon_gear_type and (ProfileHelper:has_perk("shield_maiden01", self._current_profile_copy) and primary_weapon_gear_type == "spear" or GearTypes[primary_weapon_gear_type].grants_shield)
	local secondary_allowed_shield = secondary_weapon_gear_type and GearTypes[secondary_weapon_gear_type].grants_shield and ProfileHelper:has_perk("medium", self._current_profile_copy)

	return primary_allowed_shield or secondary_allowed_shield
end

function ProfileEditorMainPage:_update_gear()
	self._profile_viewer:load_gear(self._current_profile_copy, self:cb_team_name())
end

function ProfileEditorMainPage:_update_pattern()
	local armour = Armours[self._current_profile_copy["armour_" .. self:cb_team_name()]]
	local pattern = armour.attachment_definitions.patterns[self._current_profile_copy["armour_attachments_" .. self:cb_team_name()].patterns]
	local meshes = armour.preview_unit_meshes
	local meshes_2 = armour.preview_unit_meshes_2
	local secondary_tint = pattern.secondary_tint

	ProfileHelper:set_gear_patterns(self._profile_viewer:unit("armour"), meshes, pattern)

	if meshes_2 and secondary_tint then
		ProfileHelper:set_gear_patterns(self._profile_viewer:unit("armour"), meshes_2, secondary_tint)
	end
end

function ProfileEditorMainPage:_update_helmet()
	self._profile_viewer:load_helmet(self._current_profile_copy, self:cb_team_name())
	self._profile_viewer:load_helmet_attachments(self._current_profile_copy, self:cb_team_name())
end

function ProfileEditorMainPage:_update_head()
	self._profile_viewer:load_head(self._current_profile_copy, self:cb_team_name())
end

function ProfileEditorMainPage:_update_cloak()
	self._profile_viewer:load_cloak(self._current_profile_copy, self:cb_team_name())
end

function ProfileEditorMainPage:_update_cloak_with_pattern()
	self._profile_viewer:load_cloak_with_pattern(self._current_profile_copy, self:cb_team_name())
end

function ProfileEditorMainPage:_update_cloak_pattern()
	local cloak_pattern = CloakPatterns[self._current_profile_copy["cloak_pattern_" .. self:cb_team_name()]]

	if cloak_pattern then
		local cloak = Cloaks[self._current_profile_copy["cloak_" .. self:cb_team_name()]]

		ProfileHelper:set_gear_patterns(self._profile_viewer:unit("cloak"), cloak.mesh_names, cloak_pattern)
	end
end

function ProfileEditorMainPage:_setup_container_textures()
	self:set_archetype_info()
	self:set_primary_texture()
	self:set_secondary_texture()
	self:set_shield_texture()
	self:set_pattern_texture()
	self:set_cloak_texture()
	self:set_helmet_texture()
	self:set_head_texture()
	self:set_taunt_texture()
	self:set_beards_hairs_texture()
	self:set_perk_texture(1)
	self:set_perk_texture(2)
	self:set_perk_texture(3)
	self:set_perk_texture(4)
end

function ProfileEditorMainPage:set_archetype_info()
	local name = self._current_archetype.name

	self._archetype:set_text(name)
end

function ProfileEditorMainPage:set_primary_texture()
	local two_handed_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "primary")
	local primary_weapon = two_handed_weapon or ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "secondary")
	local primary_gear = Gear[primary_weapon.name]
	local primary_texture = primary_gear.ui_texture

	self._primary_weapon:set_info(primary_texture, primary_gear)
	self._primary_weapon:set_text(primary_gear.ui_header)
end

function ProfileEditorMainPage:set_secondary_texture()
	local secondary_weapon = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "secondary")

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

function ProfileEditorMainPage:set_shield_texture()
	local shield = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "shield")

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

function ProfileEditorMainPage:set_pattern_texture()
	local armour = Armours[self._current_profile_copy["armour_" .. self:cb_team_name()]]
	local pattern = armour.attachment_definitions.patterns[self._current_profile_copy["armour_attachments_" .. self:cb_team_name()].patterns]

	self._armours:set_info(nil, pattern, "cb_pattern_material_unmasked")
end

function ProfileEditorMainPage:set_cloak_texture()
	local cloak_pattern_name = self._current_profile_copy["cloak_pattern_" .. self:cb_team_name()]
	local cloak_pattern = CloakPatterns[cloak_pattern_name]
	local cloak_name = self._current_profile_copy["cloak_" .. self:cb_team_name()]
	local cloak = Cloaks[cloak_name]

	self._cloaks:set_info(cloak.ui_texture)
end

function ProfileEditorMainPage:set_helmet_texture()
	local helmet = Helmets[self._current_profile_copy["helmet_" .. self:cb_team_name()].name]
	local variation = helmet.material_variations[self._current_profile_copy["helmet_variation_" .. self:cb_team_name()]]
	local texture = variation and variation.ui_texture or helmet.ui_texture

	self._helmets:set_info(texture)
end

function ProfileEditorMainPage:set_head_texture()
	local head = Heads[self._current_profile_copy["head_" .. self:cb_team_name()]]
	local head_texture = head.ui_texture

	self._heads:set_info(head_texture)
end

function ProfileEditorMainPage:set_taunt_texture()
	local archetype = self._current_archetype
	local movement_settings = archetype.movement_settings
	local taunt = movement_settings.taunts[self._current_profile_copy["taunt_" .. self:cb_team_name()]]

	if taunt then
		local taunt_texture = taunt.ui_texture

		self._taunts:set_info(taunt_texture)
	else
		self._taunts:set_info(nil)
	end
end

function ProfileEditorMainPage:set_beards_hairs_texture()
	local head = Heads[self._current_profile_copy["head_" .. self:cb_team_name()]]
	local beard = Beards[self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard]
	local variation = beard and beard.material_variations[self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard_color]

	if beard then
		local beard_texture = variation and variation.ui_texture or beard.ui_texture

		self._beards_hairs:set_info(beard_texture)
	else
		self._beards_hairs:set_info(nil)
	end
end

function ProfileEditorMainPage:set_perk_texture(perk_index)
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

function ProfileEditorMainPage:_update_voice()
	local team_name = self:cb_team_name()
	local head_name = self._current_profile_copy["head_" .. team_name]
	local head = Heads[head_name]
	local voice

	if head.voice then
		voice = head.voice
	else
		local team = team_name == "red" and "viking" or "saxon"
		local archetype_voice = self._current_archetype.voice

		voice = archetype_voice .. "_" .. team
	end

	self._current_profile_copy["voice_" .. team_name] = voice

	Unit.set_flow_variable(self._profile_viewer:unit("player"), "character_vo", voice)
end

function ProfileEditorMainPage:cb_archetype_name()
	return self._current_archetype.name
end

function ProfileEditorMainPage:cb_reset_profile()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		self:_load_profile()

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_reset_pattern()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		local armour = Armours[self._current_profile_copy["armour_" .. self:cb_team_name()]]
		local pattern = armour.attachment_definitions.patterns[self._current_profile_copy["armour_attachments_" .. self:cb_team_name()].patterns]
		local meshes = armour.preview_unit_meshes
		local meshes_2 = armour.preview_unit_meshes_2
		local secondary_tint = pattern.secondary_tint

		ProfileHelper:set_gear_patterns(self._profile_viewer:unit("armour"), meshes, pattern)

		if meshes_2 and secondary_tint then
			ProfileHelper:set_gear_patterns(self._profile_viewer:unit("armour"), meshes_2, secondary_tint)
		end

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_reset_helmet()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		self._profile_viewer:load_helmet(self._current_profile_copy, self:cb_team_name())
		self._profile_viewer:load_helmet_attachments(self._current_profile_copy, self:cb_team_name())

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_reset_head()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		self._profile_viewer:load_head(self._current_profile_copy, self:cb_team_name())

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_reset_cloak()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		self._profile_viewer:load_cloak(self._current_profile_copy, self:cb_team_name())

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_abort_taunt()
	if self._current_taunt then
		self._profile_viewer:animation_event(self._current_taunt.end_anim_event)

		self._current_taunt = nil
		self._current_taunt_timer = 0

		self._profile_viewer:hide_gear(self._current_profile_copy, false)
	end
end

function ProfileEditorMainPage:cb_reset_cloak_pattern()
	if self._temporary_change and self._current_profile_fallback then
		self._current_profile_copy = self._current_profile_fallback
		self._current_profile_fallback = nil

		self._profile_viewer:load_cloak_with_pattern(self._current_profile_copy, self:cb_team_name())

		self._temporary_change = false
	end
end

function ProfileEditorMainPage:cb_perk_selected(perk, perk_slot)
	self._current_profile_copy.perks[perk_slot] = perk.perk_name

	local perk_container = "_perk" .. string.gsub(perk_slot, "perk_", "")

	self[perk_container].config.name = perk.ui_header
	self._temporary_change = false

	self:_save_profile()
end

function ProfileEditorMainPage:cb_perk_highligthed(perk)
	UnviewedUnlockedItemsHelper:view_item(perk.name, SaveData)
end

function ProfileEditorMainPage:cb_perk_already_selected(perk)
	local current_perks = self._current_profile_copy.perks

	return table.contains(current_perks, perk.name) and perk.name ~= "empty"
end

function ProfileEditorMainPage:cb_gear_hidden(item)
	local available, unavalible_reason = ProfileHelper:is_entity_avalible(item.entity_type, item.name, item.entity_type, item.name, item.release_name, item.developer_item)
	local hidden = OutfitHelper.gear_hidden(item)

	return hidden and not available
end

function ProfileEditorMainPage:cb_team_name()
	return self._team_name
end

function ProfileEditorMainPage:cb_change_team()
	self._team_name = self._team_name == "red" and "white" or "red"

	self:_setup_data()
	self:_load_profile()
end

function ProfileEditorMainPage:cb_team_color()
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

function ProfileEditorMainPage:cb_experience_data()
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

function ProfileEditorMainPage:cb_profile_name()
	local current_profile = PlayerProfiles[self._current_profile_index]

	return current_profile.display_name or "missing"
end

function ProfileEditorMainPage:cb_change_to_gear_page(data, layout_settings, on_select, on_highlight, camera, weapon_slot, on_highlight_new_item, category)
	local item_data = {
		gear = data,
		layout_settings = layout_settings,
		on_select = on_select,
		on_highlight = on_highlight,
		camera = self._camera_positions[category] or camera,
		weapon_slot = weapon_slot,
		on_highlight_new_item = on_highlight_new_item
	}

	self._gear_page:set_data(item_data)
	self._menu_logic:change_page(self._gear_page)
end

function ProfileEditorMainPage:cb_gear_highlighted_new_item(gear)
	return UnviewedUnlockedItems[gear.name]
end

function ProfileEditorMainPage:cb_gear_highlighted(gear, weapon_slot)
	UnviewedUnlockedItemsHelper:view_item(gear.name, SaveData)

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_gear_selected(gear, weapon_slot, true)
	self._profile_viewer:animation_event("display")
end

function ProfileEditorMainPage:cb_gear_selected(gear, weapon_slot, avoid_page_change)
	local gear_name = gear.name

	ProfileHelper:remove_gear_by_slot(self._current_profile_copy.gear, weapon_slot)

	if gear_name then
		self._current_profile_copy.gear[weapon_slot] = {
			name = gear_name
		}
	end

	self:_update_wielded_gear(self._current_profile_copy, weapon_slot, avoid_page_change)
	self:_load_profile()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:_save_profile(no_page_change)
	PlayerProfiles[self._current_profile_index] = table.clone(self._current_profile_copy)

	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_profiles_saved", no_page_change))
	Managers.state.event:trigger("event_save_started", "menu_saving_profile", "menu_profile_saved")
end

function ProfileEditorMainPage:cb_profiles_saved(no_page_change, info)
	if info.error then
		Application.warning("Save error %q", info.error)
	end

	self._altered_archetypes[self._current_profile_index] = self._altered_archetypes[self._current_profile_index] or {}
	self._altered_archetypes[self._current_profile_index][self._current_archetype.archetype_id] = table.clone(self._current_profile_copy)

	Managers.state.event:trigger("event_save_finished")

	if not no_page_change then
		self._menu_logic:change_page(self)
	end

	self._save_time = 1
end

function ProfileEditorMainPage:cb_next_profile()
	local index = self._current_profile_index
	local profile

	repeat
		index = index % #PlayerProfiles + 1
		profile = PlayerProfiles[index]
	until self:_profile_available(profile) and not profile.no_editing

	self:set_profile_data(profile, index, self:cb_team_name())

	self._temporary_change = false

	self:_setup_data()
	self:_load_profile()
	self:_refresh_profile_name()
end

function ProfileEditorMainPage:cb_previous_profile()
	local index = self._current_profile_index
	local profile

	repeat
		index = index - 1

		if index == 0 then
			index = #PlayerProfiles
		end

		profile = PlayerProfiles[index]
	until self:_profile_available(profile) and not profile.no_editing

	self:set_profile_data(profile, index, self:cb_team_name())

	self._temporary_change = false

	self:_setup_data()
	self:_load_profile()
	self:_refresh_profile_name()
end

function ProfileEditorMainPage:_profile_available(profile)
	local unlock_type = "profile"
	local unlock_key = profile.unlock_key
	local entity_type = "profile"
	local entity_name = profile.unlock_key
	local release_name = profile.release_name
	local available, unavalable_reason = ProfileHelper:is_entity_avalible(unlock_type, unlock_key, entity_type, entity_name, release_name, profile.developer_item)

	return available
end

function ProfileEditorMainPage:_update_wielded_gear(profile_table, weapon_slot, avoid_page_change)
	for slot, gear in pairs(profile_table.gear) do
		gear.wielded = false
	end

	self:_check_has_wielded_gear(profile_table, weapon_slot, avoid_page_change)
	self:_check_complementing_wielded_gear(profile_table, avoid_page_change)
end

function ProfileEditorMainPage:_check_has_wielded_gear(profile_table, weapon_slot, avoid_page_change)
	local gear_table = profile_table.gear

	if not gear_table.primary.wielded or not gear_table.secondary.wielded or not gear_table.dagger.wielded then
		local fallback_slot
		local primary = gear_table.primary
		local secondary = gear_table.secondary

		if primary and (not gear_table.shield or not gear_table.shield.wielded) and (Gear[primary.name].gear_type ~= "lance" or profile_table.mount) then
			fallback_slot = "primary"

			local allowed_shield = self:_check_allowed_shield(primary, secondary)

			if not allowed_shield then
				gear_table.shield = nil
			end
		else
			fallback_slot = secondary and "secondary" or "dagger"
		end

		if avoid_page_change then
			profile_table.gear[weapon_slot].wielded = true

			if weapon_slot == "shield" then
				profile_table.gear.dagger.wielded = true
			end
		else
			profile_table.gear[fallback_slot].wielded = true
		end
	end
end

function ProfileEditorMainPage:_has_unviewed_cloak_pattern(cloak)
	for _, pattern in pairs(cloak.patterns) do
		if UnviewedUnlockedItems[pattern.name] then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:_has_unviewed_cloak(cloak)
	return UnviewedUnlockedItems[cloak.name] or UnviewedUnlockedItemsHelper:can_access_item(cloak) and self:_has_unviewed_cloak_pattern(cloak) or false
end

function ProfileEditorMainPage:_has_unviewed_cloaks(cloak_names)
	local num_cloaks = #cloak_names

	for i = 1, num_cloaks do
		local cloak_name = cloak_names[i]
		local cloak = Cloaks[cloak_name]

		if self:_has_unviewed_cloak(cloak) then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:_has_unviewed_helmet_variations(helmet)
	for _, variation in pairs(helmet.material_variations) do
		if UnviewedUnlockedItems[variation.name] then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:_has_unviewed_helmet(helmet)
	return UnviewedUnlockedItems[helmet.name] or UnviewedUnlockedItemsHelper:can_access_item(helmet) and self:_has_unviewed_helmet_variations(helmet)
end

function ProfileEditorMainPage:_has_unviewed_helmets(helmet_names)
	local num_helmets = #helmet_names

	for i = 1, num_helmets do
		local helmet_name = helmet_names[i]
		local helmet = Helmets[helmet_name]

		if self:_has_unviewed_helmet(helmet) then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:_has_unviewed_beard_color(beard)
	for _, variation_properties in ipairs(beard.material_variations) do
		if UnviewedUnlockedItems[variation_properties.name] then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:_has_unviewed_beard(beard)
	return UnviewedUnlockedItems[beard.name] or UnviewedUnlockedItemsHelper:can_access_item(beard) and self:_has_unviewed_beard_color(beard) or false
end

function ProfileEditorMainPage:_has_unviewed_beards(head)
	for _, beard in ipairs(head.beard_variations) do
		if self:_has_unviewed_beard(beard) then
			return true
		end
	end

	return false
end

function ProfileEditorMainPage:cb_helmet_selected(helmet, avoid_page_change)
	self._current_profile_copy["helmet_" .. self:cb_team_name()].name = helmet.name
	self._current_profile_copy["helmet_variation_" .. self:cb_team_name()] = nil

	self:_update_helmet()

	if not avoid_page_change then
		self._temporary_change = false

		local variations = {}

		for name, variation in pairs(helmet.material_variations) do
			variations[#variations + 1] = variation
		end

		if #variations > 0 then
			local item_data = {
				layout_settings = "ProfileEditorSettings.items.helmet_item",
				on_highlight = "cb_helmet_variation_highlighted",
				on_select = "cb_helmet_variation_selected",
				gear = variations,
				camera = self._camera_positions.closeup
			}

			self._helmet_variations_page:set_data(item_data)
			self._menu_logic:change_page(self._helmet_variations_page)
		else
			self:_save_profile()
		end
	end
end

function ProfileEditorMainPage:cb_helmet_variation_selected(variation, avoid_page_change)
	self._current_profile_copy["helmet_variation_" .. self:cb_team_name()] = variation.base_name

	self:_update_helmet()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_helmet_variation_highlighted(variation)
	UnviewedUnlockedItemsHelper:view_item(variation.name, SaveData)

	local team_name = self:cb_team_name()
	local helmet_names = self._current_archetype.cosmetics[team_name].helmet_names
	local has_new = self:_has_unviewed_helmets(helmet_names)

	self._helmets:set_new_item(has_new)

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_helmet_variation_selected(variation, true)
end

function ProfileEditorMainPage:cb_head_selected(head, avoid_page_change)
	self._current_profile_copy["head_" .. self:cb_team_name()] = head.name
	self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard = nil
	self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard_color = nil

	self:_update_head()
	self:_update_voice()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_beard_selected(beard, avoid_page_change)
	local number = 0

	for id, settings in ipairs(Beards) do
		if beard.name == settings.name then
			number = id

			break
		end
	end

	self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard = number
	self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard_color = #beard.material_variations > 0 and 1 or nil

	self:_update_head()

	if not avoid_page_change then
		self._temporary_change = false

		local colors = {}

		for _, color in pairs(beard.material_variations) do
			colors[#colors + 1] = color
		end

		if #colors > 0 then
			local item_data = {
				layout_settings = "ProfileEditorSettings.items.beard_item",
				on_highlight = "cb_beard_color_highlighted",
				on_select = "cb_beard_color_selected",
				gear = colors,
				camera = self._camera_positions.closeup
			}

			self._beard_hair_colors_page:set_data(item_data)
			self._menu_logic:change_page(self._beard_hair_colors_page)
		else
			self:_save_profile()
		end
	end
end

function ProfileEditorMainPage:cb_beard_highlighted(beard)
	UnviewedUnlockedItemsHelper:view_item(beard.name, SaveData)
	self._beards_hairs:set_new_item(false)

	local head = Heads[self._current_profile_copy["head_" .. self:cb_team_name()]]

	if self:_has_unviewed_beards(head) then
		self._beards_hairs:set_new_item(true)
	end

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_beard_selected(beard, true)
end

function ProfileEditorMainPage:cb_beard_color_selected(color, avoid_page_change)
	local beard = Beards[self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard]
	local number = 0

	for id, variation in ipairs(beard.material_variations) do
		if variation.name == color.name then
			number = id

			break
		end
	end

	self._current_profile_copy["head_attachments_" .. self:cb_team_name()].beard_color = number

	self:_update_head()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_beard_color_highlighted(color)
	UnviewedUnlockedItemsHelper:view_item(color.name, SaveData)
	self._beards_hairs:set_new_item(false)

	local head = Heads[self._current_profile_copy["head_" .. self:cb_team_name()]]

	if self:_has_unviewed_beards(head) then
		self._beards_hairs:set_new_item(true)
	end

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_beard_color_selected(color, true)
end

function ProfileEditorMainPage:cb_cloak_selected(cloak, avoid_page_change)
	self._current_profile_copy["cloak_" .. self:cb_team_name()] = cloak.name

	self:_update_cloak()

	if not avoid_page_change then
		self._temporary_change = false

		local archetype_name = self._current_archetype.archetype_id
		local patterns = {}

		for _, pattern in pairs(cloak.patterns) do
			patterns[pattern.index] = pattern
		end

		table.sort(patterns, function(a, b)
			return a.ui_sort_index < b.ui_sort_index
		end)

		if #patterns > 0 then
			local item_data = {
				layout_settings = "ProfileEditorSettings.items.pattern_item",
				on_highlight = "cb_cloak_pattern_highlighted",
				on_select = "cb_cloak_pattern_selected",
				gear = patterns,
				camera = self._camera_positions.right
			}

			self._cloak_patterns_page:set_data(item_data)
			self._menu_logic:change_page(self._cloak_patterns_page)
		else
			self:_save_profile()
		end
	end
end

function ProfileEditorMainPage:cb_cloak_pattern_selected(cloak_pattern, avoid_page_change)
	self._current_profile_copy["cloak_pattern_" .. self:cb_team_name()] = cloak_pattern.name

	self:_update_cloak_with_pattern()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_taunt_selected(taunt, avoid_page_change)
	self._current_profile_copy["taunt_" .. self:cb_team_name()] = taunt.name

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
		self:cb_abort_taunt()
	end
end

function ProfileEditorMainPage:cb_helmet_highlighted(helmet)
	UnviewedUnlockedItemsHelper:view_item(helmet.name, SaveData)

	local team_name = self:cb_team_name()
	local helmet_names = self._current_archetype.cosmetics[team_name].helmet_names
	local has_new = self:_has_unviewed_helmets(helmet_names)

	self._helmets:set_new_item(has_new)

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_helmet_selected(helmet, true)
end

function ProfileEditorMainPage:cb_head_highlighted(head)
	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_head_selected(head, true)
end

function ProfileEditorMainPage:cb_cloak_highlighted(cloak)
	UnviewedUnlockedItemsHelper:view_item(cloak.name, SaveData)

	local team_name = self:cb_team_name()
	local cloak_names = self._current_archetype.cosmetics[team_name].cloak_names

	self._cloaks:set_new_item(self:_has_unviewed_cloaks(cloak_names))

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_cloak_selected(cloak, true)
end

function ProfileEditorMainPage:cb_cloak_pattern_highlighted(cloak_pattern)
	UnviewedUnlockedItemsHelper:view_item(cloak_pattern.name, SaveData)
	self._cloaks:set_new_item(false)

	local team_name = self:cb_team_name()
	local cloak_names = self._current_archetype.cosmetics[team_name].cloak_names

	self._cloaks:set_new_item(self:_has_unviewed_cloaks(cloak_names))

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_cloak_pattern_selected(cloak_pattern, true)
end

function ProfileEditorMainPage:cb_taunt_highlighted(taunt)
	UnviewedUnlockedItemsHelper:view_item(taunt.name, SaveData)

	local archetype = self._current_archetype
	local movement_settings = archetype.movement_settings

	self._taunts:set_new_item(false)

	for name, taunt_name in ipairs(archetype.taunts) do
		if UnviewedUnlockedItems[taunt_name] then
			self._taunts:set_new_item(true)

			break
		end
	end

	self:cb_abort_taunt()
	self._profile_viewer:animation_event(taunt.start_anim_event)

	self._current_taunt_timer = Managers.time:time("main") + taunt.duration
	self._current_taunt = taunt
end

function ProfileEditorMainPage:cb_armour_selected(armour, avoid_page_change)
	self._current_profile_copy["armour_" .. self:cb_team_name()] = armour.name

	self:_load_profile()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_armour_highlighted(armour)
	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_armour_selected(armour, true)
end

function ProfileEditorMainPage:cb_pattern_selected(pattern, avoid_page_change)
	self._current_profile_copy["armour_attachments_" .. self:cb_team_name()].patterns = pattern.index

	self:_update_pattern()

	if not avoid_page_change then
		self._temporary_change = false

		self:_save_profile()
	end
end

function ProfileEditorMainPage:cb_cloak_unviewed_item(cloak)
	return self:_has_unviewed_cloak(cloak)
end

function ProfileEditorMainPage:cb_helmet_unviewed_item(helmet)
	return self:_has_unviewed_helmet(helmet)
end

function ProfileEditorMainPage:cb_beard_unviewed_item(beard)
	return self:_has_unviewed_beard(beard)
end

function ProfileEditorMainPage:cb_pattern_material(pattern)
	local atlas_variation = pattern.atlas_variation
	local team_name = self:cb_team_name()
	local material_name = team_name .. "_outfit_preview_masked_" .. atlas_variation

	return material_name, Vector2(64, 128)
end

function ProfileEditorMainPage:cb_pattern_material_unmasked(pattern)
	local atlas_variation = pattern.atlas_variation
	local team_name = self:cb_team_name()
	local material_name = team_name .. "_outfit_preview_" .. atlas_variation

	return material_name, Vector2(64, 128)
end

function ProfileEditorMainPage:cb_base_cloak_pattern_material(cloak_pattern)
	local material_name

	if cloak_pattern.atlas_variation then
		local atlas_variation = cloak_pattern.atlas_variation
		local team_name = self:cb_team_name()

		material_name = team_name .. "_cloak_preview_masked_" .. atlas_variation
	else
		material_name = cloak_pattern.texture .. "_masked"
	end

	return material_name, Vector2(64, 128)
end

function ProfileEditorMainPage:cb_base_cloak_pattern_material_unmasked(cloak_pattern)
	local material_name

	if cloak_pattern.atlas_variation then
		local atlas_variation = cloak_pattern.atlas_variation
		local team_name = self:cb_team_name()

		material_name = team_name .. "_cloak_preview_" .. atlas_variation
	else
		material_name = cloak_pattern.texture
	end

	return material_name, Vector2(64, 128)
end

function ProfileEditorMainPage:cb_pattern_highlighted(pattern)
	UnviewedUnlockedItemsHelper:view_item(pattern.name, SaveData)
	self._armours:set_new_item(false)

	local current_armour_name = self._current_profile_copy["armour_" .. self:cb_team_name()]
	local current_armour = Armours[current_armour_name]
	local patterns = current_armour.attachment_definitions.patterns
	local num_patterns = #patterns

	for i = 1, num_patterns do
		local pattern_name = patterns[i].name

		if UnviewedUnlockedItems[pattern_name] then
			self._armours:set_new_item(true)

			break
		end
	end

	if not self._temporary_change then
		self._temporary_change = true
		self._current_profile_fallback = table.clone(self._current_profile_copy)
	end

	self:cb_pattern_selected(pattern, true)
end

function ProfileEditorMainPage:_check_complementing_wielded_gear(profile_table, avoid_page_change)
	local num_wielded_gear = 0
	local wielded_slot

	for slot, gear in pairs(profile_table.gear) do
		if gear.wielded then
			num_wielded_gear = num_wielded_gear + 1
			wielded_slot = slot
		end
	end

	if num_wielded_gear == 1 and not avoid_page_change then
		local complementing_gear = ProfileHelper:find_complementing_gear(wielded_slot, profile_table.gear, self._current_profile_copy.archetype)

		if complementing_gear then
			complementing_gear.wielded = true
		end
	end
end

function ProfileEditorMainPage:cb_archetype_selected(archetype)
	local old_profile = self._altered_archetypes[self._current_profile_index] and self._altered_archetypes[self._current_profile_index][archetype.archetype_id]

	if old_profile then
		self._current_profile_copy = table.clone(old_profile)
	else
		local old_profile_copy = self._current_profile_copy

		self._current_profile_copy = table.clone(DefaultArchetypeProfileSettings[archetype.archetype_id])

		for name, needs_copying in pairs(DefaultArchetypeProfileSettings.clone_ignore_list) do
			if needs_copying then
				self._current_profile_copy[name] = old_profile_copy[name]
			end
		end
	end

	self._current_archetype = table.clone(archetype)

	self:_update_voice()
	self:_load_profile()
	self:_setup_data()
	self:_save_profile()
end

function ProfileEditorMainPage:cb_archetype_hidden(args)
	if OutfitHelper.gear_hidden(args[1]) then
		return true
	end

	if args[1].required_dlc then
		return DLCSettings[args[1].required_dlc] and not DLCSettings[args[1].required_dlc]()
	end

	return false
end

function ProfileEditorMainPage:cb_weapon_category_disabled(args)
	if ProfileHelper:has_perk("berserk_01", self._current_profile_copy) then
		return false
	end

	if self._primary_weapon:highlighted() then
		local gear = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "secondary")

		if gear and Gear[gear.name].category == args.weapon_category then
			return true
		end
	elseif self._secondary_weapon:highlighted() then
		local gear = ProfileHelper:find_gear_by_slot(self._current_profile_copy.gear, "primary")

		if gear and Gear[gear.name].category == args.weapon_category then
			return true
		end
	end
end

function ProfileEditorMainPage:cb_perk_disabled(args)
	local perk_name = args.perk_name

	if ProfileHelper:has_perk(perk_name, self._current_profile_copy) and perk_name ~= "empty" then
		return true
	end

	return false
end

function ProfileEditorMainPage:cb_animation_callback(extension, unit, callback_name, param)
	if callback_name == "anim_cb_hide_wielded_weapons" then
		self._profile_viewer:hide_gear(self._current_profile_copy, true)
	elseif callback_name == "anim_cb_unhide_wielded_weapons" then
		self._profile_viewer:hide_gear(self._current_profile_copy, false)
	end
end

function ProfileEditorMainPage:cb_buy_gold_popup_enter(args)
	self:enable_buy_gold_popup_buttons(true)
	self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_select_amount"))
end

function ProfileEditorMainPage:cb_buy_gold_popup_item_selected(args)
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

function ProfileEditorMainPage:cb_gold_purchase_done(success, data)
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

function ProfileEditorMainPage:enable_buy_gold_popup_buttons(enabled)
	for _, item in ipairs(self._buy_gold_page:items_in_group("button_list")) do
		item.config.disabled = not enabled
	end
end

function ProfileEditorMainPage:cb_profile_gold_reloaded(success)
	Managers.state.event:trigger("profile_gold_reloaded")
end

function ProfileEditorMainPage:cb_wants_buy_gold(reset_callback_name, success_callback)
	if GameSettingsDevelopment.enable_micro_transactions then
		self:_setup_buy_gold_popup(reset_callback_name, success_callback)
		self._menu_logic:change_page(self._buy_gold_page)
	end
end

function ProfileEditorMainPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "profile_editor_main",
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		local_player = page_config.local_player,
		camera = page_config.camera or parent_page and parent_page:camera(),
		profile_viewer = page_config.profile_viewer
	}

	return ProfileEditorMainPage:new(config, item_groups, compiler_data.world)
end
