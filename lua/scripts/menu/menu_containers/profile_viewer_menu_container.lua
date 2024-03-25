-- chunkname: @scripts/menu/menu_containers/profile_viewer_menu_container.lua

require("scripts/menu/menu_containers/unit_viewer_menu_container")
require("scripts/helpers/coat_of_arms_helper")

ProfileViewerMenuContainer = class(ProfileViewerMenuContainer, UnitViewerMenuContainer)

local ROTATION_SPEED = 10

function ProfileViewerMenuContainer:init(world_name, viewport_name, menu_settings, local_player)
	ProfileViewerMenuContainer.super.init(self, world_name)

	self._viewport_name = viewport_name
	self._menu_settings = menu_settings
	self._alignment_units = {}
	self._local_player = local_player
	self._current_rotation = 0
	self._rotation_offset = 0
end

function ProfileViewerMenuContainer:add_alignment_unit(name, unit)
	self._alignment_units[name] = unit
end

function ProfileViewerMenuContainer:clear()
	self:remove_unit("player")
	self:remove_unit("armour")
	self:remove_unit("mount")

	if Unit.alive(self._marker_unit) then
		local world = Managers.world:world(self._world_name)

		World.destroy_unit(world, self._marker_unit)

		self._marker_unit = nil
	end
end

function ProfileViewerMenuContainer:remove_unit(name)
	ProfileViewerMenuContainer.super.remove_unit(self, name)

	if name == "mount" and self:unit("player") then
		if self._alignment_units.player_without_mount then
			self:_align_unit_position_rotation("player", self._alignment_units.player_without_mount)
		else
			local position_offset = self._menu_settings.units.player_without_mount.position_offset:unbox()
			local rotation_offset = self._menu_settings.units.player_without_mount.rotation_offset

			self:_set_unit_position_rotation("player", position_offset, rotation_offset)
		end
	end
end

function ProfileViewerMenuContainer:_set_unit_position_rotation(unit_name, position_offset, rotation_offset)
	local camera_unit = self:_camera_unit()
	local cam_pos = Unit.local_position(camera_unit, 0)
	local cam_rot = Unit.local_rotation(camera_unit, 0)
	local position = cam_pos + Quaternion.forward(cam_rot) * position_offset.y + Quaternion.up(cam_rot) * position_offset.z + Quaternion.right(cam_rot) * position_offset.x

	self:set_unit_position(unit_name, position)

	local rotation = Quaternion.multiply(cam_rot, Quaternion(Vector3(0, 0, 1), rotation_offset))

	self:set_unit_rotation(unit_name, rotation)
end

function ProfileViewerMenuContainer:_set_unit_offset_rotation(unit_name, rotation_offset)
	local camera_unit = self:_camera_unit()
	local cam_rot = Unit.local_rotation(camera_unit, 0)
	local rotation = Quaternion.multiply(cam_rot, Quaternion(Vector3(0, 0, 1), rotation_offset))

	self:set_unit_rotation(unit_name, rotation)
end

function ProfileViewerMenuContainer:_align_unit_position_rotation(unit_name, alignment_unit)
	local position = Unit.local_position(alignment_unit, 0)

	self:set_unit_position(unit_name, position)

	local rotation = Unit.local_rotation(alignment_unit, 0)

	self:set_unit_rotation(unit_name, rotation)
end

function ProfileViewerMenuContainer:update_input_rotation(input, layout_settings)
	local mouse_pos = input:get("cursor")
	local mouse_click = input:get("select_left_click")
	local mouse_down = input:get("select_down") > 0
	local w, h = Gui.resolution()
	local rect = {
		w * layout_settings.rotation_rect.screen_x,
		h * layout_settings.rotation_rect.screen_y,
		w * layout_settings.rotation_rect.screen_x + w * layout_settings.rotation_rect.screen_width,
		h * layout_settings.rotation_rect.screen_y + h * layout_settings.rotation_rect.screen_height
	}

	if mouse_click then
		if mouse_pos[1] > rect[1] and mouse_pos[1] < rect[3] and mouse_pos[2] > rect[2] and mouse_pos[2] < rect[4] then
			self._rotation_active = true
			self._mouse_x = mouse_pos[1]
		end
	elseif self._rotation_active and mouse_down then
		local diff = (mouse_pos[1] - self._mouse_x) / w * ROTATION_SPEED

		self._rotation_offset = self._rotation_offset + diff
		self._mouse_x = mouse_pos[1]
	else
		self._rotation_active = false
	end

	if layout_settings.rotation_rect.rotation_marker and mouse_pos then
		self:_handle_marker_unit(layout_settings.rotation_rect, rect, mouse_pos)
	end

	if self._unit_rotation and math.abs(self._current_rotation - self._rotation_offset) > 0.05 then
		self._current_rotation = self._current_rotation + (self._rotation_offset - self._current_rotation) * 0.2

		local new_rotation = Quaternion.multiply(self._unit_rotation:unbox(), Quaternion(Vector3(0, 0, 1), self._current_rotation))
		local player_unit = self:unit("player")

		if Unit.alive(player_unit) then
			Unit.set_local_rotation(self:unit("player"), 0, new_rotation)
		end
	end
end

function ProfileViewerMenuContainer:_handle_marker_unit(layout_settings, rect, mouse_pos)
	if not self._rotation_active and not self._marker_unit and mouse_pos[1] > rect[1] and mouse_pos[1] < rect[3] and mouse_pos[2] > rect[2] and mouse_pos[2] < rect[4] then
		local player_unit = self:unit("player")

		if not Unit.alive(player_unit) then
			return
		end

		local player_pos = Unit.local_position(player_unit, 0)
		local world = Managers.world:world(self._world_name)
		local unit_name = layout_settings.marker_unit
		local marker_rot_dir = Vector3(layout_settings.rotation_marker_rotation[1], layout_settings.rotation_marker_rotation[2], layout_settings.rotation_marker_rotation[3])
		local marker_offset = Vector3(layout_settings.rotation_marker_offset[1], layout_settings.rotation_marker_offset[2], layout_settings.rotation_marker_offset[3])
		local marker_scale = Vector3(layout_settings.rotation_marker_scale[1], layout_settings.rotation_marker_scale[2], layout_settings.rotation_marker_scale[3])

		self._marker_unit = World.spawn_unit(world, unit_name, player_pos + marker_offset, Quaternion.look(marker_rot_dir))

		Unit.set_local_scale(self._marker_unit, 0, marker_scale)
	elseif not (mouse_pos[1] > rect[1]) or not (mouse_pos[1] < rect[3]) or not (mouse_pos[2] > rect[2]) or not (mouse_pos[2] < rect[4]) then
		if Unit.alive(self._marker_unit) then
			World.destroy_unit(Managers.world:world(self._world_name), self._marker_unit)
		end

		self._marker_unit = nil
	end
end

function ProfileViewerMenuContainer:load_profile(player_profile, team_name)
	local team_name = player_profile.team and player_profile.team.name or team_name or "red"

	self:remove_unit("player")
	self:remove_unit("armour")
	self:remove_unit("mount")
	self:load_player(player_profile, team_name)
	self:load_gear(player_profile, team_name)
	self:load_head(player_profile, team_name)
	self:load_helmet(player_profile, team_name)
	self:load_cloak_with_pattern(player_profile, team_name)
	self:load_helmet_attachments(player_profile, team_name)

	if player_profile.mount then
		self:load_mount(MountProfiles[player_profile.mount])
	end

	self._rotation_offset = 0
	self._current_rotation = 0
	self._unit_rotation = QuaternionBox(Unit.local_rotation(self:unit("player"), 0))

	Unit.set_flow_variable(self:unit("player"), "character_vo", player_profile["voice_" .. team_name])
end

function ProfileViewerMenuContainer:_camera_unit()
	local world = Managers.world:world(self._world_name)
	local viewport = ScriptWorld.viewport(world, self._viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local camera_unit = Camera.get_data(camera, "unit")

	return camera_unit
end

function ProfileViewerMenuContainer:load_player(player_profile, team_name)
	local armour = Armours[player_profile["armour_" .. team_name]]
	local spawn_config = {
		unit_name = DefaultUnits.standard.preview
	}

	self:spawn_unit(nil, "player", spawn_config)

	local position_offset, rotation_offset

	if player_profile.mount then
		if self._alignment_units.player_with_mount then
			self:_align_unit_position_rotation("player", self._alignment_units.player_with_mount)
		else
			local position_offset = self._menu_settings.units.player_with_mount.position_offset:unbox()
			local rotation_offset = self._menu_settings.units.player_with_mount.rotation_offset

			self:_set_unit_position_rotation("player", position_offset, rotation_offset)
		end
	elseif self._alignment_units.player_without_mount then
		self:_align_unit_position_rotation("player", self._alignment_units.player_without_mount)
	else
		local position_offset = self._menu_settings.units.player_without_mount.position_offset:unbox()
		local rotation_offset = self._menu_settings.units.player_without_mount.rotation_offset

		self:_set_unit_position_rotation("player", position_offset, rotation_offset)
	end

	self:_load_armour(armour.armour_unit)

	local pattern_name = player_profile["armour_attachments_" .. team_name].patterns
	local pattern = armour.attachment_definitions.patterns[pattern_name]
	local meshes = armour.preview_unit_meshes

	ProfileHelper:set_gear_patterns(self:unit("armour"), meshes, pattern)

	local meshes_2 = armour.preview_unit_meshes_2
	local secondary_tint = pattern.secondary_tint

	if meshes_2 and secondary_tint then
		ProfileHelper:set_gear_patterns(self:unit("armour"), meshes_2, secondary_tint)
	end
end

function ProfileViewerMenuContainer:_load_armour(armour_unit)
	self:spawn_unit(nil, "armour", {
		unit_name = armour_unit
	})
	self:_attachment_node_linking(self:unit("player"), self:unit("armour"), AttachmentNodeLinking.full_body.standard)
end

function ProfileViewerMenuContainer:_attachment_node_linking(source_unit, target_unit, linking_setup)
	for i, attachment_nodes in ipairs(linking_setup) do
		local source_node = attachment_nodes.source
		local target_node = attachment_nodes.target
		local source_node_index = type(source_node) == "string" and Unit.node(source_unit, source_node) or source_node
		local target_node_index = type(target_node) == "string" and Unit.node(target_unit, target_node) or target_node
		local world = Managers.world:world(self._world_name)

		World.link_unit(world, target_unit, target_node_index, source_unit, source_node_index)
	end
end

function ProfileViewerMenuContainer:player_unit()
	return self:unit("player")
end

function ProfileViewerMenuContainer:update_coat_of_arms(team_name)
	if GameSettingsDevelopment.use_armour_heraldry_projection then
		CoatOfArmsHelper:set_material_properties(PlayerCoatOfArms, self:unit("armour"), "g_heraldry_projection", "heraldry_projection", team_name)
	end

	local shield = self:unit("shield")

	if shield then
		local shield_name = self:unit_meta_data("shield", "gear_name")

		if Gear[shield_name].show_coat_of_arms then
			CoatOfArmsHelper:set_material_properties(PlayerCoatOfArms, shield, "g_heraldry_projector", "heraldry_projector", team_name)
		end
	end
end

function ProfileViewerMenuContainer:load_mount(mount_profile, team_name)
	local spawn_config = {
		unit_name = mount_profile.preview_unit,
		material_variation = mount_profile.material_variation
	}

	self:spawn_unit(nil, "mount", spawn_config)

	if self._alignment_units.mount then
		self:_align_unit_position_rotation("mount", self._alignment_units.mount)
	else
		local position_offset = self._menu_settings.units.mount.position_offset:unbox()
		local rotation_offset = self._menu_settings.units.mount.rotation_offset

		self:_set_unit_position_rotation("mount", position_offset, rotation_offset)
	end

	if self:unit("player") then
		if self._alignment_units.player_with_mount then
			self:_align_unit_position_rotation("player", self._alignment_units.player_with_mount)
		else
			local position_offset = self._menu_settings.units.player_with_mount.position_offset:unbox()
			local rotation_offset = self._menu_settings.units.player_with_mount.rotation_offset

			self:_set_unit_position_rotation("player", position_offset, rotation_offset)
		end
	end
end

function ProfileViewerMenuContainer:load_gear(player_profile, team_name)
	for slot, gear in pairs(player_profile.gear) do
		local gear_name = gear.name
		local gear_settings = Gear[gear_name]

		if gear.wielded then
			self:_load_wielded_gear(slot, gear_name, player_profile.gear)
		else
			self:_load_unwielded_gear(slot, gear_name)
		end
	end
end

function ProfileViewerMenuContainer:hide_gear(player_profile, hide)
	for slot, gear in pairs(player_profile.gear) do
		local gear_name = gear.name
		local gear_settings = Gear[gear_name]
		local wielded = gear.wielded
		local visibility = not hide
		local unit = self:unit(slot)

		if Unit.has_visibility_group(unit, "unbroken") then
			Unit.set_visibility(unit, "unbroken", visibility)
		else
			Unit.set_unit_visibility(unit, visibility)
		end
	end
end

function ProfileViewerMenuContainer:animation_event(anim)
	if Unit.has_animation_event(self:unit("player"), anim) then
		Unit.animation_event(self:unit("player"), anim)
	else
		print("Missing event:", anim)
	end
end

function ProfileViewerMenuContainer:_load_wielded_gear(name, gear_name, gear)
	local gear_settings = Gear[gear_name]
	local gear_type = gear_settings.gear_type
	local hand = gear_settings.hand
	local main_body_state = ""

	if gear_type ~= "shield" then
		if gear.shield and gear.shield.wielded then
			main_body_state = GearTypes.shield.cd_wield_main_body_state .. "_"
		end

		main_body_state = main_body_state .. GearTypes[gear_type].cd_wield_main_body_state
	end

	local hand_anim = gear_settings.hand .. "/empty"

	if gear_settings.hand_anim then
		hand_anim = gear_settings.hand_anim
	end

	local spawn_config = {
		unit_name = gear_settings.husk_unit,
		attachment_node_linking = gear_settings.attachment_node_linking.wielded,
		animation_events = {
			main_body_state,
			hand_anim
		},
		material_variation = gear_settings.material_variation
	}

	self:spawn_unit("player", name, spawn_config, {
		gear_name = gear_name
	})

	if gear_type == "longbow" or gear_type == "hunting_bow" or gear_type == "short_bow" then
		local quiver_settings = gear_settings.quiver
		local quiver_spawn_config = {
			unit_name = quiver_settings.unit,
			attachment_node_linking = quiver_settings.attachment_node_linking,
			animation_events = {
				main_body_state,
				hand_anim
			},
			material_variation = quiver_settings.material_variation
		}

		self:spawn_unit("player", "quiver", quiver_spawn_config)
	end
end

function ProfileViewerMenuContainer:_load_unwielded_gear(name, gear_name)
	local gear_settings = Gear[gear_name]
	local spawn_config = {
		unit_name = gear_settings.husk_unit,
		attachment_node_linking = gear_settings.attachment_node_linking.unwielded,
		animation_events = {},
		material_variation = gear_settings.material_variation
	}

	self:spawn_unit("player", name, spawn_config, {
		gear_name = gear_name
	})
end

function ProfileViewerMenuContainer:load_head(player_profile, team_name)
	local head = Heads[player_profile["head_" .. team_name]]
	local spawn_config = {
		unit_name = head.unit,
		attachment_node_linking = head.attachment_node_linking,
		animation_events = {},
		material_variation = head.material_variation
	}

	self:spawn_unit("player", "head", spawn_config)

	local beard = Beards[player_profile["head_attachments_" .. team_name].beard]

	if beard then
		local settings = beard.material_variations[player_profile["head_attachments_" .. team_name].beard_color]
		local material_variation = settings and settings.material_variation

		for index, attachment in ipairs(beard.attachments) do
			local spawn_config = {
				unit_name = attachment.unit,
				attachment_node_linking = attachment.node_linking,
				animation_events = {},
				material_variation = material_variation
			}

			self:spawn_unit("head", index, spawn_config)
		end
	else
		for index, attachment in ipairs(head.attachments) do
			local spawn_config = {
				unit_name = attachment.unit,
				attachment_node_linking = attachment.node_linking,
				animation_events = {},
				material_variation = attachment.material_variation
			}

			self:spawn_unit("head", index, spawn_config)
		end
	end
end

function ProfileViewerMenuContainer:load_helmet(player_profile, team_name)
	local helmet = Helmets[player_profile["helmet_" .. team_name].name]
	local material_variation = helmet.material_variations[player_profile["helmet_variation_" .. team_name]] or helmet.material_variations.default
	local spawn_config = {
		unit_name = helmet.unit,
		attachment_node_linking = helmet.attachment_node_linking,
		material_variation = material_variation and material_variation.material_variation or nil,
		animation_events = {}
	}

	self:spawn_unit("player", "helmet", spawn_config)
	self:set_unit_visibility("head", "head_all", true)

	if helmet.hide_head_visibility_group then
		self:set_unit_visibility("head", helmet.hide_head_visibility_group, false)
	end
end

function ProfileViewerMenuContainer:load_cloak(player_profile, team_name)
	local cloak = Cloaks[player_profile["cloak_" .. team_name]]

	if not cloak or not cloak.unit then
		if self._units.cloak then
			self:remove_unit("cloak")
		end

		return
	end

	local spawn_config = {
		unit_name = cloak.unit,
		attachment_node_linking = cloak.attachment_node_linking,
		animation_events = {}
	}

	self:spawn_unit("player", "cloak", spawn_config)
end

function ProfileViewerMenuContainer:load_cloak_with_pattern(player_profile, team_name)
	local cloak = Cloaks[player_profile["cloak_" .. team_name]]

	if not cloak or not cloak.unit then
		if self._units.cloak then
			self:remove_unit("cloak")
		end

		return
	end

	local spawn_config = {
		unit_name = cloak.unit,
		attachment_node_linking = cloak.attachment_node_linking,
		animation_events = {}
	}

	self:spawn_unit("player", "cloak", spawn_config)

	local cloak_pattern = CloakPatterns[player_profile["cloak_pattern_" .. team_name]]

	if cloak_pattern then
		local material_variation = cloak.unit .. "_" .. team_name

		ProfileHelper:set_gear_patterns(self:unit("cloak"), cloak.mesh_names, cloak_pattern, material_variation)
	end
end

function ProfileViewerMenuContainer:load_helmet_attachments(player_profile, team_name)
	local profile_helmet_data = player_profile["helmet_" .. team_name]
	local helmet = Helmets[profile_helmet_data.name]
	local pattern

	for attachment_type, attachment_name in pairs(profile_helmet_data.attachments) do
		local attachment = helmet.attachments[attachment_name]

		if attachment_type == "pattern" then
			pattern = attachment
		else
			local spawn_config = {
				unit_name = attachment.unit,
				attachment_node_linking = attachment.attachment_node_linking,
				animation_events = {},
				material_variation = attachment.material_variation
			}

			self:spawn_unit("helmet", attachment_type, spawn_config)
		end
	end

	if pattern then
		ProfileHelper:set_gear_patterns(self:unit("helmet"), helmet.preview_unit_meshes, pattern)

		for attachment_type, attachment_name in pairs(profile_helmet_data.attachments) do
			local attachment = helmet.attachments[attachment_name]
			local attachment_meshes = attachment.preview_unit_meshes

			if attachment_meshes then
				local unit = self:unit(attachment_type)

				ProfileHelper:set_gear_patterns(unit, attachment_meshes, pattern)
			end
		end
	end
end

function ProfileViewerMenuContainer:load_armour_attachments(player_profile, team_name)
	local armour = Armours[player_profile.armour]
	local pattern = armour.attachment_definitions.patterns[player_profile["armour_attachments_" .. team_name].patterns]
	local meshes = armour.preview_unit_meshes

	ProfileHelper:set_gear_patterns(self:unit("armour"), meshes, pattern)

	local meshes_2 = armour.preview_unit_meshes_2
	local secondary_tint = pattern.secondary_tint

	if meshes_2 and secondary_tint then
		ProfileHelper:set_gear_patterns(self:unit("armour"), meshes_2, secondary_tint)
	end
end

function ProfileViewerMenuContainer:render(dt, t, gui, layout_settings)
	local world = Managers.world:world(self._world_name)
	local viewport = ScriptWorld.viewport(world, self._viewport_name)
	local res_width, res_height = Gui.resolution()
	local width = self._width / res_width
	local height = self._height / res_height

	self._viewport_x = self._x / res_width
	self._viewport_y = math.floor(res_height - self._y - self._height) / res_height

	Viewport.set_rect(viewport, self._viewport_x, self._viewport_y, width, height)
end

function ProfileViewerMenuContainer.create_from_config(world_name, viewport_name, menu_settings, local_player)
	return ProfileViewerMenuContainer:new(world_name, viewport_name, menu_settings, local_player)
end
