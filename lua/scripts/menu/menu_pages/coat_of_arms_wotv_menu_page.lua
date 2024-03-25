-- chunkname: @scripts/menu/menu_pages/coat_of_arms_wotv_menu_page.lua

require("scripts/settings/coat_of_arms")
require("scripts/settings/shield_paints")

CoatOfArmsWotvMenuPage = class(CoatOfArmsWotvMenuPage, MenuPage)

function CoatOfArmsWotvMenuPage:init(config, item_groups, world)
	CoatOfArmsWotvMenuPage.super.init(self, config, item_groups, world)

	self._base_color = ProfileEditorContainer.create_from_config({
		name = "base_color",
		world = self._world,
		callback_object = self
	})
	self._mid_color = ProfileEditorContainer.create_from_config({
		name = "mid_color",
		world = self._world,
		callback_object = self
	})
	self._top_color = ProfileEditorContainer.create_from_config({
		name = "top_color",
		world = self._world,
		callback_object = self
	})
	self._charge_color = ProfileEditorContainer.create_from_config({
		name = "charge_color",
		world = self._world,
		callback_object = self
	})
	self._base_mask = ProfileEditorContainer.create_from_config({
		name = "base_mask",
		world = self._world,
		callback_object = self
	})
	self._mid_mask = ProfileEditorContainer.create_from_config({
		name = "mid_mask",
		world = self._world,
		callback_object = self
	})
	self._top_mask = ProfileEditorContainer.create_from_config({
		name = "top_mask",
		world = self._world,
		callback_object = self
	})
	self._charge_mask = ProfileEditorContainer.create_from_config({
		name = "charge_mask",
		world = self._world,
		callback_object = self
	})
	self._team_name = "red"
	self._save_time = 0
	self._containers = {}
	self._containers[#self._containers + 1] = self._base_color
	self._containers[#self._containers + 1] = self._mid_color
	self._containers[#self._containers + 1] = self._top_color
	self._containers[#self._containers + 1] = self._charge_color
	self._containers[#self._containers + 1] = self._base_mask
	self._containers[#self._containers + 1] = self._mid_mask
	self._containers[#self._containers + 1] = self._top_mask
	self._containers[#self._containers + 1] = self._charge_mask
end

function CoatOfArmsWotvMenuPage:_create_pages()
	local color_config = {
		layout_settings = "ProfileEditorSettings.pages.colors",
		name = "color_page",
		render_parent_page = true,
		reset_callback = "cb_reset_color",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._color_page = GearListPage.create_from_config({
		world = self._world
	}, color_config, self, {
		gear = {}
	}, self)

	local color_config = {
		layout_settings = "ProfileEditorSettings.pages.charge_colors",
		name = "charge_color_page",
		render_parent_page = true,
		reset_callback = "cb_reset_color",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._charge_color_page = GearListPage.create_from_config({
		world = self._world
	}, color_config, self, {
		gear = {}
	}, self)

	local mask_config = {
		layout_settings = "ProfileEditorSettings.pages.masks",
		name = "mask_page",
		render_parent_page = true,
		reset_callback = "cb_reset_mask",
		environment = self.config.environment,
		sounds = self.config.sounds
	}

	self._mask_page = GearListPage.create_from_config({
		world = self._world
	}, mask_config, self, {
		gear = {}
	}, self)
end

function CoatOfArmsWotvMenuPage:_update_coat_of_arms()
	self:_update_units(true)
	self:_setup_container_textures()
end

function CoatOfArmsWotvMenuPage:_save_coat_of_arms()
	local team_name = self._team_name
	local coat_of_arms_settings = self["_" .. team_name .. "_coat_of_arms"]

	for variable_name, value in pairs(coat_of_arms_settings.variables) do
		PlayerCoatOfArms[team_name][variable_name] = value
	end

	SaveData.player_coat_of_arms = PlayerCoatOfArms

	Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_coat_of_arms_saved"))
	Managers.state.event:trigger("event_save_started", "menu_saving_profile", "menu_profile_saved")
end

function CoatOfArmsWotvMenuPage:_update_units(save)
	local units = self:_try_callback(self.config.callback_object, "cb_menu_shield_units", self._team_name)

	if not units then
		return
	end

	for _, unit in pairs(units) do
		local mesh = Unit.mesh(unit, "g_heraldry_projector")
		local material = Mesh.material(mesh, "heraldry_projector")
		local coat_of_arms

		if save then
			coat_of_arms = self["_" .. self._team_name .. "_coat_of_arms"]
		else
			coat_of_arms = self["_" .. self._team_name .. "_coat_of_arms_copy"]
		end

		for variable_name, value in pairs(coat_of_arms.variables) do
			if type(value) == "string" then
				local atlas_name = CoatOfArmsAtlasVariants[self._team_name][variable_name]
				local material_name = value
				local _, uv00, uv11 = HUDHelper.atlas_material(atlas_name, material_name)

				Material.set_vector2(material, variable_name .. "_uv_offset", uv00)
				Material.set_vector2(material, variable_name .. "_uv_scale", uv11 - uv00)
			else
				Material.set_scalar(material, variable_name, value)
			end
		end
	end
end

function CoatOfArmsWotvMenuPage:_setup_container_textures()
	for _, container in pairs(self._containers) do
		self:_setup_container_texture(container)
	end
end

function CoatOfArmsWotvMenuPage:_setup_container_texture(container)
	local name = container:name()
	local coat_of_arms = self["_" .. self._team_name .. "_coat_of_arms"]
	local data = coat_of_arms.mapping[name]

	if data then
		container:set_info(data.atlas_material, data, data.texture_func, data.mask, data.mask_func, data.texture)
	end
end

function CoatOfArmsWotvMenuPage:on_enter(on_cancel)
	CoatOfArmsWotvMenuPage.super.on_enter(self, on_cancel)

	self._temporary_change = false

	if not on_cancel then
		self:_setup_team()
		self:_create_pages()
		self:_setup_data()
		self:_setup_coat_of_arms()
		self:_setup_container_textures()
		self:_update_units(true)
		self:_setup_profile_info()
	end
end

function CoatOfArmsWotvMenuPage:on_exit(on_cancel)
	CoatOfArmsWotvMenuPage.super.on_exit(self, on_cancel)
	self:_try_callback(self.config.parent_page, "cb_set_team", self._team_name)
	Managers.state.event:trigger("reload_coat_of_arms")
end

function CoatOfArmsWotvMenuPage:_setup_profile_info()
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

function CoatOfArmsWotvMenuPage:cb_experience_data()
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

function CoatOfArmsWotvMenuPage:_setup_team()
	local parent_team = self:_try_callback(self.config.parent_page, "cb_team_name")

	self._team_name = parent_team or "red"

	local item = self:find_item_by_name("team_switch")

	if item then
		item:set_team_name(self._team_name)
		self:_set_unit_material_variation()
	end
end

function CoatOfArmsWotvMenuPage:_setup_coat_of_arms()
	local red_settings = PlayerCoatOfArms.red

	self._red_coat_of_arms = self._red_coat_of_arms or {
		material_name = "coat_of_arms_test_red",
		variables = {
			base_color_index = red_settings.base_color_index,
			mid_heraldry_color_index = red_settings.mid_heraldry_color_index,
			top_heraldry_color_index = red_settings.top_heraldry_color_index,
			charge_heraldry_color_index = red_settings.charge_heraldry_color_index,
			base_heraldry_index = red_settings.base_heraldry_index,
			mid_heraldry = red_settings.mid_heraldry,
			top_heraldry = red_settings.top_heraldry,
			charge_heraldry = red_settings.charge_heraldry
		},
		mapping = {
			base_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "base_color_index",
				size = "color_size",
				material = "red_base_color_unmasked"
			},
			mid_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "mid_heraldry_color_index",
				size = "color_size",
				material = "red_mid_color_unmasked"
			},
			top_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "top_heraldry_color_index",
				size = "color_size",
				material = "red_top_color_unmasked"
			},
			charge_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "charge_heraldry_color_index",
				size = "color_size",
				material = "red_charge_color_unmasked"
			},
			base_mask = {
				variable = "base_heraldry_index",
				size = "mask_size",
				material = "cirlce",
				texture = "circle"
			},
			mid_mask = {
				variable = "mid_heraldry",
				texture_func = "cb_container_material_team"
			},
			top_mask = {
				variable = "top_heraldry",
				texture_func = "cb_container_material_team"
			},
			charge_mask = {
				variable = "charge_heraldry",
				texture_func = "cb_container_material_team"
			}
		}
	}
	self._red_coat_of_arms_copy = table.clone(self._red_coat_of_arms)

	local white_settings = PlayerCoatOfArms.white

	self._white_coat_of_arms = self._white_coat_of_arms or {
		material_name = "coat_of_arms_test_white",
		variables = {
			base_color_index = white_settings.base_color_index,
			mid_heraldry_color_index = white_settings.mid_heraldry_color_index,
			top_heraldry_color_index = white_settings.top_heraldry_color_index,
			charge_heraldry_color_index = white_settings.charge_heraldry_color_index,
			base_heraldry_index = white_settings.base_heraldry_index,
			mid_heraldry = white_settings.mid_heraldry,
			top_heraldry = white_settings.top_heraldry,
			charge_heraldry = white_settings.charge_heraldry
		},
		mapping = {
			base_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "base_color_index",
				size = "color_size",
				material = "white_base_color_unmasked"
			},
			mid_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "mid_heraldry_color_index",
				size = "color_size",
				material = "white_mid_color_unmasked"
			},
			top_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "top_heraldry_color_index",
				size = "color_size",
				material = "white_top_color_unmasked"
			},
			charge_color = {
				mask = "circle_mask",
				texture_func = "cb_container_material",
				variable = "charge_heraldry_color_index",
				size = "color_size",
				material = "white_charge_color_unmasked"
			},
			base_mask = {
				variable = "base_heraldry_index",
				size = "mask_size",
				material = "circle",
				texture = "circle"
			},
			mid_mask = {
				variable = "mid_heraldry",
				texture_func = "cb_container_material_team"
			},
			top_mask = {
				variable = "top_heraldry",
				texture_func = "cb_container_material_team"
			},
			charge_mask = {
				variable = "charge_heraldry",
				texture_func = "cb_container_material_team"
			}
		}
	}
	self._white_coat_of_arms_copy = table.clone(self._white_coat_of_arms)
end

function CoatOfArmsWotvMenuPage:_setup_data()
	local colors = {}
	local team_name_base_color = self._team_name .. "_base_color"

	for i = 0, 127 do
		colors[#colors + 1] = {
			release_name = "main",
			variable = "base_color_index",
			color_index = i,
			color_material = team_name_base_color,
			ui_sort_index = i
		}
	end

	self._base_color:set_page_data(self._color_page, {
		layout_settings = "ProfileEditorSettings.items.color_item",
		on_select = "cb_color_selected",
		on_highlight = "cb_color_highlighted",
		camera = "coat_of_arms",
		gear = colors
	})

	colors = {}

	local team_name_mid_color = self._team_name .. "_mid_color"

	for i = 0, 127 do
		colors[#colors + 1] = {
			release_name = "main",
			variable = "mid_heraldry_color_index",
			color_index = i,
			color_material = team_name_mid_color,
			ui_sort_index = i
		}
	end

	self._mid_color:set_page_data(self._color_page, {
		layout_settings = "ProfileEditorSettings.items.color_item",
		on_select = "cb_color_selected",
		on_highlight = "cb_color_highlighted",
		camera = "coat_of_arms",
		gear = colors
	})

	colors = {}

	local team_name_top_color = self._team_name .. "_top_color"

	for i = 0, 127 do
		colors[#colors + 1] = {
			release_name = "main",
			variable = "top_heraldry_color_index",
			color_index = i,
			color_material = team_name_top_color,
			ui_sort_index = i
		}
	end

	self._top_color:set_page_data(self._color_page, {
		layout_settings = "ProfileEditorSettings.items.color_item",
		on_select = "cb_color_selected",
		on_highlight = "cb_color_highlighted",
		camera = "coat_of_arms",
		gear = colors
	})

	colors = {}

	local team_name_charge_color = self._team_name .. "_charge_color"

	for i = 0, 255 do
		colors[#colors + 1] = {
			release_name = "main",
			variable = "charge_heraldry_color_index",
			color_index = i,
			color_material = team_name_charge_color,
			ui_sort_index = i
		}
	end

	self._charge_color:set_page_data(self._charge_color_page, {
		layout_settings = "ProfileEditorSettings.items.color_item",
		on_select = "cb_color_selected",
		on_highlight = "cb_color_highlighted",
		camera = "coat_of_arms",
		gear = colors
	})

	local masks = ShieldPaints[self._team_name].mid_heraldry

	self._mid_mask:set_page_data(self._mask_page, {
		layout_settings = "ProfileEditorSettings.items.mask_item_mid",
		on_select = "cb_mask_selected",
		on_highlight = "cb_mask_highlighted",
		camera = "coat_of_arms",
		gear = masks
	})

	local masks = ShieldPaints[self._team_name].top_heraldry

	self._top_mask:set_page_data(self._mask_page, {
		layout_settings = "ProfileEditorSettings.items.mask_item_top",
		on_select = "cb_mask_selected",
		on_highlight = "cb_mask_highlighted",
		camera = "coat_of_arms",
		gear = masks
	})

	local masks = ShieldPaints[self._team_name].charge_heraldry

	self._charge_mask:set_page_data(self._mask_page, {
		layout_settings = "ProfileEditorSettings.items.mask_item_charge",
		on_select = "cb_mask_selected",
		on_highlight = "cb_mask_highlighted",
		camera = "coat_of_arms",
		gear = masks
	})
end

function CoatOfArmsWotvMenuPage:update(dt, t, render_from_child_page)
	CoatOfArmsWotvMenuPage.super.update(self, dt, t, render_from_child_page)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, self._gui, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self:_render(dt, t, self._gui, layout_settings)
	self:_update_camera(t)
end

function CoatOfArmsWotvMenuPage:_update_input(input)
	CoatOfArmsWotvMenuPage.super._update_input(self, input)

	local mouse_pos = input:has("cursor") and input:get("cursor")

	if mouse_pos and input:get("select_left_click") then
		for _, container in pairs(self._containers) do
			local is_inside = container:is_mouse_inside(mouse_pos)
			local page_data = container:page_data()

			if is_inside and page_data then
				container:on_select()

				local page = page_data.page

				page:set_data(page_data.data_table)

				if page.set_dependency_object then
					page:set_dependency_object(container)
				end

				local container_name = container:name()
				local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
				local x, y, _ = MenuHelper:container_position(container, layout_settings[container_name])

				page:set_position(x + container:width(), y + container:height(), container:z())
				self._menu_logic:change_page(page)
			end
		end
	end
end

function CoatOfArmsWotvMenuPage:_update_camera(t, render_from_child_page)
	local offset = Vector3(math.cos(t) * 0.3 * 0.5, math.sin(t) * 0.5, -math.cos(t) * -0.7 * 0.5) * 0.001

	Managers.state.camera:set_variable("menu_level_viewport", "offset_position", offset)
end

function CoatOfArmsWotvMenuPage:_update_size(dt, t, gui, layout_settings)
	for _, container in pairs(self._containers) do
		container:update_size(dt, t, gui, layout_settings[container:name()])
	end

	for item_group, items in pairs(self._item_groups) do
		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:update_size(dt, t, gui, item_layout_settings)
		end
	end
end

function CoatOfArmsWotvMenuPage:_update_position(dt, t, layout_settings)
	for _, container in pairs(self._containers) do
		local x, y, z = MenuHelper:container_position(container, layout_settings[container:name()])

		container:update_position(dt, t, layout_settings[container:name()], x, y, z)
	end

	for item_group, items in pairs(self._item_groups) do
		local x, y, z = MenuHelper:container_position(nil, layout_settings[item_group])

		z = z or self.config.z or 0

		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:update_position(dt, t, item_layout_settings, x, y, item_layout_settings.z or z)

			y = y - item:height() - (item_layout_settings.spacing or 0)
		end
	end
end

function CoatOfArmsWotvMenuPage:_render(dt, t, gui, layout_settings)
	MenuHelper:render_wotv_menu_banner(dt, t, gui)

	for _, container in pairs(self._containers) do
		container:render(dt, t, gui, layout_settings[container:name()])
	end

	for item_group, items in pairs(self._item_groups) do
		for _, item in ipairs(items) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:render(dt, t, self._gui, item_layout_settings)
		end
	end

	if script_data.debug_coat_of_arms then
		self:_render_coat_of_arms(dt, t, gui, layout_settings)
	end

	self:_render_save_text(dt, t, layout_settings)
end

function CoatOfArmsWotvMenuPage:_render_save_text(dt, t, layout_settings)
	if self._save_time > 0 then
		local alpha = self._save_time / 1
		local w, h = Gui.resolution()
		local min, max = Gui.text_extents(self._gui, L("menu_save"), MenuSettings.fonts.hell_shark_36.font, 36)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}

		Gui.text(self._gui, L("menu_save"), MenuSettings.fonts.hell_shark_36.font, 36, MenuSettings.fonts.hell_shark_36.material, Vector3(w * 0.5 - extents[1] * 0.5, h * 0.1, 999), Color(alpha * 255, 255, 255, 255))

		self._save_time = self._save_time - dt
	end
end

function CoatOfArmsWotvMenuPage:_render_coat_of_arms(dt, t, gui, layout_settings)
	local coat_of_arms_copy = self["_" .. self._team_name .. "_coat_of_arms_copy"]
	local material_name = coat_of_arms_copy.material_name
	local material = Gui.material(gui, material_name)

	for variable_name, value in pairs(coat_of_arms_copy.variables) do
		if type(value) == "string" then
			local atlas_name = CoatOfArmsAtlasVariants[self._team_name][variable_name]
			local material_name = value
			local _, uv00, uv11 = HUDHelper.atlas_material(atlas_name, material_name)

			Material.set_vector2(material, variable_name .. "_uv_offset", uv00)
			Material.set_vector2(material, variable_name .. "_uv_scale", uv11 - uv00)
		else
			Material.set_scalar(material, variable_name, value)
		end
	end

	local w, h = Gui.resolution()
	local pos = Vector3(w * 0.05, h * 0.6, 100)

	Gui.bitmap(gui, material_name, pos, Vector2(200, 200))
end

function CoatOfArmsWotvMenuPage:cb_get_team_atlas()
	if self._team_name == "red" then
		return "heraldry_vikings"
	else
		return "heraldry_saxons"
	end
end

function CoatOfArmsWotvMenuPage:cb_coat_of_arms_saved(info)
	if info.error then
		Application.warning("Save error %q", info.error)
	end

	Managers.state.event:trigger("event_save_finished")

	self._save_time = 1
end

function CoatOfArmsWotvMenuPage:cb_container_material(material_info)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local icon_layout = layout_settings.icons
	local team_name = self._team_name
	local coat_of_arms = self["_" .. team_name .. "_coat_of_arms"]
	local variable = material_info.variable
	local material = material_info.material
	local size = icon_layout[material_info.size]
	local alpha = coat_of_arms.variables[variable]
	local size = Vector2(size[1], size[2])
	local color = Color(alpha, 255, 255, 255)

	return material, size, color
end

function CoatOfArmsWotvMenuPage:cb_container_material_team(material_info)
	local team_name = self._team_name
	local coat_of_arms = self["_" .. team_name .. "_coat_of_arms"]
	local variable = material_info.variable
	local material = coat_of_arms.variables[variable]
	local atlas_name = CoatOfArmsAtlasVariants[team_name][variable]
	local material, uv00, uv11, size = HUDHelper.atlas_material(atlas_name, material)

	return material, size, Color(255, 255, 255, 255), uv00, uv11
end

function CoatOfArmsWotvMenuPage:cb_reset_color()
	if self._temporary_change then
		self["_" .. self._team_name .. "_coat_of_arms_copy"] = table.clone(self["_" .. self._team_name .. "_coat_of_arms"])
		self._temporary_change = false

		self:_update_units(false)
	end
end

function CoatOfArmsWotvMenuPage:cb_reset_mask()
	if self._temporary_change then
		self["_" .. self._team_name .. "_coat_of_arms_copy"] = table.clone(self["_" .. self._team_name .. "_coat_of_arms"])
		self._temporary_change = false

		self:_update_units(false)
	end
end

function CoatOfArmsWotvMenuPage:cb_mask_material(mask, layout_settings)
	local material = mask.mask_material
	local size = layout_settings.mask_size and Vector2(layout_settings.size[1], layout_settings.size[2]) or Vector2(100, 100)
	local color = Color(mask.mask_index, 255, 255, 255)

	return material, size, color
end

function CoatOfArmsWotvMenuPage:cb_mask_selected(mask)
	local atlas_material = mask.ui_texture
	local heraldry = mask.heraldry
	local coat_of_arms = self["_" .. self._team_name .. "_coat_of_arms"]

	coat_of_arms.variables[heraldry] = atlas_material

	local coat_of_arms_copy = self["_" .. self._team_name .. "_coat_of_arms_copy"]

	coat_of_arms_copy = table.clone(coat_of_arms)
	self._temporary_change = false

	self:_update_coat_of_arms()
	self:_save_coat_of_arms()
	self._menu_logic:change_page(self)
end

function CoatOfArmsWotvMenuPage:cb_mask_highlighted(mask)
	local atlas_material = mask.ui_texture
	local heraldry = mask.heraldry
	local coat_of_arms_copy = self["_" .. self._team_name .. "_coat_of_arms_copy"]

	coat_of_arms_copy.variables[heraldry] = atlas_material
	self._temporary_change = true

	self:_update_units(false)
end

function CoatOfArmsWotvMenuPage:cb_color_material(color, layout_settings)
	local material = color.color_material
	local size = layout_settings.size and Vector2(layout_settings.size[1], layout_settings.size[2]) or Vector2(40, 40)
	local color = Color(color.color_index, 255, 255, 255)

	return material, size, color
end

function CoatOfArmsWotvMenuPage:cb_color_selected(color)
	local coat_of_arms = self["_" .. self._team_name .. "_coat_of_arms"]

	if coat_of_arms.variables[color.variable] then
		coat_of_arms.variables[color.variable] = color.color_index
	end

	local coat_of_arms_copy = self["_" .. self._team_name .. "_coat_of_arms_copy"]

	coat_of_arms_copy = table.clone(coat_of_arms)
	self._temporary_change = false

	self:_update_coat_of_arms()
	self:_save_coat_of_arms()
	self._menu_logic:change_page(self)
end

function CoatOfArmsWotvMenuPage:cb_color_highlighted(color)
	local coat_of_arms_copy = self["_" .. self._team_name .. "_coat_of_arms_copy"]

	if coat_of_arms_copy.variables[color.variable] then
		coat_of_arms_copy.variables[color.variable] = color.color_index
	end

	self._temporary_change = true

	self:_update_units(false)
end

function CoatOfArmsWotvMenuPage:cb_change_team()
	self._team_name = self._team_name == "red" and "white" or "red"

	self:_setup_data()
	self:_set_unit_material_variation()
	self:_update_coat_of_arms()
end

function CoatOfArmsWotvMenuPage:_set_unit_material_variation()
	local unit = self:_try_callback(self.config.callback_object, "cb_menu_main_shield_unit")

	if not unit then
		return
	end

	local team_name = self._team_name
	local material_variation = Unit.get_data(unit, "material_variations", team_name)

	Unit.set_material_variation(unit, material_variation)
end

function CoatOfArmsWotvMenuPage:cb_team_name()
	return self._team_name or "red"
end

function CoatOfArmsWotvMenuPage:cb_gear_hidden(item)
	local available, unavalible_reason = ProfileHelper:is_entity_avalible(item.entity_type, item.name, item.entity_type, item.name, item.release_name, item.developer_item)
	local hidden = OutfitHelper.gear_hidden(item)

	return hidden and not available
end

function CoatOfArmsWotvMenuPage:cb_team_color()
	local team_name = self._team_name

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

function CoatOfArmsWotvMenuPage:_setup_buy_gold_popup(reset_callback_name, success_callback)
	self._buy_gold_page = MenuHelper:create_buy_gold_popup_page(self._world, self, self, "cb_buy_gold_popup_enter", "cb_buy_gold_popup_item_selected", (self.config.z or 1) + 50, self.config.sounds, reset_callback_name, success_callback)
end

function CoatOfArmsWotvMenuPage:cb_buy_gold_popup_enter(args)
	self:enable_buy_gold_popup_buttons(true)
	self._buy_gold_page:find_item_by_name("text_message"):set_text(L("buy_gold_select_amount"))
end

function CoatOfArmsWotvMenuPage:cb_buy_gold_popup_item_selected(args)
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

function CoatOfArmsWotvMenuPage:cb_gold_purchase_done(success, data)
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

function CoatOfArmsWotvMenuPage:enable_buy_gold_popup_buttons(enabled)
	for _, item in ipairs(self._buy_gold_page:items_in_group("button_list")) do
		item.config.disabled = not enabled
	end
end

function CoatOfArmsWotvMenuPage:cb_profile_gold_reloaded(success)
	Managers.state.event:trigger("profile_gold_reloaded")
end

function CoatOfArmsWotvMenuPage:cb_wants_buy_gold(reset_callback_name, success_callback)
	if GameSettingsDevelopment.enable_micro_transactions then
		self:_setup_buy_gold_popup(reset_callback_name, success_callback)
		self._menu_logic:change_page(self._buy_gold_page)
	end
end

function CoatOfArmsWotvMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "coat_of_arms",
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		local_player = compiler_data.menu_data.local_player,
		camera = page_config.camera or parent_page and parent_page:camera()
	}

	return CoatOfArmsWotvMenuPage:new(config, item_groups, compiler_data.world)
end
