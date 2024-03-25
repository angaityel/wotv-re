-- chunkname: @scripts/managers/hud/hud_combat_text/hud_combat_text.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/hud_combat_text/hud_combat_text_element")
require("scripts/managers/hud/shared_hud_elements/hud_text_element")
require("scripts/managers/hud/shared_hud_elements/hud_texture_element")

HUDCombatText = class(HUDCombatText, HUDBase)

function HUDCombatText:init(world, player)
	HUDCombatText.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_world_gui(world, Matrix4x4:identity(), 1, 1, "material", "materials/hud/hud", "material", "materials/fonts/hell_shark_font", "immediate")
	self._active = false
	self._spawn_positions = {}
	self._available_ids = {
		healing_numbers = {},
		damage_numbers = {},
		perk_texts = {},
		shield_icons = {}
	}

	for element_category, ids in pairs(self._available_ids) do
		local amount = 5

		if element_category == "healing_numbers" then
			amount = 10
		end

		for i = 1, amount do
			ids[element_category .. "_" .. i] = true
		end
	end

	self._combat_text_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.combat_text.container
	})
	self._colours = {
		head = {
			255,
			238,
			19,
			19
		},
		shield = {
			255,
			255,
			255,
			255
		},
		other = {
			255,
			230,
			106,
			20
		},
		perk_text = {
			255,
			255,
			207,
			64
		},
		healing_number = {
			255,
			19,
			255,
			48
		}
	}
	self._font_sizes = {
		head = {
			size = 28,
			font = MenuSettings.fonts.hell_shark_28
		},
		shield = {
			size = 26,
			font = MenuSettings.fonts.hell_shark_26
		},
		other = {
			size = 26,
			font = MenuSettings.fonts.hell_shark_26
		},
		perk_text = {
			size = 22,
			font = MenuSettings.fonts.hell_shark_22
		},
		healing_number = {
			size = 22,
			font = MenuSettings.fonts.hell_shark_22
		}
	}
	self._healing_number_radius = 2.5
	self._healing_number_on_screen_distance = 5

	Managers.state.event:register(self, "event_combat_text_activated", "event_combat_text_activated")
	Managers.state.event:register(self, "event_combat_text_deactivated", "event_combat_text_deactivated")
	Managers.state.event:register(self, "show_damage_number", "event_show_damage_number")
	Managers.state.event:register(self, "show_healing_number", "event_show_healing_number")
	Managers.state.event:register(self, "show_perk_text", "event_show_perk_text")
	Managers.state.event:register(self, "show_shield_icon", "event_show_shield_icon")
end

function HUDCombatText:event_show_damage_number(player, damage, position, hit_zone)
	if self._player == player then
		local colour = self._colours[hit_zone] or self._colours.other
		local font_size = self._font_sizes[hit_zone] or self._font_sizes.other
		local text = math.floor(damage)

		self:_show_combat_text_element("damage_numbers", text, font_size, position, colour, false)
	end
end

function HUDCombatText:event_show_perk_text(player, text, position)
	if self._player == player then
		local colour = self._colours.perk_text
		local font_size = self._font_sizes.perk_text

		self:_show_combat_text_element("perk_texts", L(text), font_size, position, colour, false)
	end
end

function HUDCombatText:event_show_healing_number(heal_amount, position)
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local player_pos = Unit.local_position(player_unit, 0)
	local distance = Vector3.distance(player_pos, position)
	local viewport_name = self._player.viewport_name
	local camera = ScriptViewport.camera(ScriptWorld.viewport(self._world, viewport_name))
	local world_to_screen = Camera.world_to_screen(camera, position)

	if distance <= self._healing_number_radius or HUDHelper:inside_screen(world_to_screen.x, world_to_screen.y, world_to_screen.z) and distance <= self._healing_number_on_screen_distance then
		local colour = self._colours.healing_number
		local font_size = self._font_sizes.healing_number
		local text = "+ " .. math.floor(heal_amount)

		self:_show_combat_text_element("healing_numbers", text, font_size, position, colour, false)
	end
end

function HUDCombatText:event_show_shield_icon(player, damage, position)
	if self._player == player then
		local colour = self._colours.shield
		local font_size = self._font_sizes.shield

		self:_show_combat_text_element("shield_icons", damage, font_size, position, colour, true)
	end
end

function HUDCombatText:_show_combat_text_element(id_category, text, font_size, position, colour, show_shield)
	local container = self._combat_text_container
	local free_space, element_id = self:_available_element(id_category, position)

	if not free_space then
		self:_remove_combat_text_item(element_id)
	end

	local z_offset = self:_prevent_text_overlapping(position)
	local viewport_name = self._player.viewport_name
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local vertical_fov = Camera.vertical_fov(camera)
	local camera_pos = Managers.state.camera:camera_position(viewport_name)
	local distance = Vector3.distance(camera_pos, position)
	local new_position = Vector3(position.x, position.y, position.z + z_offset)
	local new_pos_box = Vector3Box()

	new_pos_box:store(new_position)

	local vertical_fov_multiplier = math.sin(vertical_fov)

	vertical_fov_multiplier = 0.8 * vertical_fov_multiplier + 0.3

	local config = {
		z = 0,
		id = element_id,
		start_time = Managers.time:time("game"),
		show_shield = show_shield,
		text = text,
		position = new_pos_box,
		colour = colour,
		text_size = font_size.size,
		font = font_size.font,
		viewport_name = viewport_name,
		ranged_size_multiplier = (distance / 19 + 1) * vertical_fov_multiplier,
		ended_function = callback(self, "cb_combat_text_time_out"),
		layout_settings = HUDSettings.combat_text.number
	}
	local element = HUDCombatTextElement.create_from_config(config)

	container:add_element(element_id, element)

	local pos_box = Vector3Box()

	pos_box:store(position)

	self._spawn_positions[element_id] = pos_box
	self._available_ids[id_category][element_id] = false
end

function HUDCombatText:cb_combat_text_time_out(id_to_remove)
	self:_remove_combat_text_item(id_to_remove)
end

function HUDCombatText:_remove_combat_text_item(id_to_remove)
	self._combat_text_container:remove_element(id_to_remove)

	for element_type, ids in pairs(self._available_ids) do
		for id, _ in pairs(ids) do
			if id_to_remove == id then
				self._spawn_positions[id] = nil
				self._available_ids[element_type][id] = true
			end
		end
	end
end

function HUDCombatText:_available_element(id_category, spawn_position)
	local elements = self._combat_text_container:elements()
	local element_id
	local free_space = false
	local oldest_element_id
	local oldest_time = math.huge

	for id, available in pairs(self._available_ids[id_category]) do
		if available then
			element_id = id
			free_space = true

			break
		else
			local element = elements[id]
			local start_time = element.config.start_time

			if start_time < oldest_time then
				oldest_element_id = id
				oldest_time = start_time
			end
		end
	end

	return free_space, free_space and element_id or oldest_element_id
end

function HUDCombatText:_prevent_text_overlapping(position)
	local elements = self._combat_text_container:elements()
	local overlap_count = 0

	for id, spawn_pos_box in pairs(self._spawn_positions) do
		local spawn_pos = spawn_pos_box:unbox()
		local distance = spawn_pos.z - position.z

		distance = distance > 0 and distance or distance * -1

		local start_time = elements[id].config.start_time

		if distance <= 0.3 and Managers.time:time("game") - start_time <= 0.2 then
			overlap_count = overlap_count + 1
		end
	end

	local camera_pos = Managers.state.camera:camera_position(self._player.viewport_name)
	local distance = Vector3.distance(camera_pos, position)
	local ranged_offset = distance / 100 * 1.5
	local z_offset = (0.3 + ranged_offset) * overlap_count

	return z_offset
end

function HUDCombatText:event_combat_text_activated(player)
	if player == self._player then
		self._active = true
	end
end

function HUDCombatText:event_combat_text_deactivated(player)
	if player == self._player then
		self._active = false
	end
end

function HUDCombatText:post_update(dt, t)
	local layout_settings = HUDHelper:layout_settings(self._combat_text_container.config.layout_settings)
	local gui = self._gui

	if self._active then
		self._combat_text_container:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._combat_text_container, layout_settings)

		self._combat_text_container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._combat_text_container:render(dt, t, gui, layout_settings)
	end
end

function HUDCombatText:destroy()
	World.destroy_gui(self._world, self._gui)
end
