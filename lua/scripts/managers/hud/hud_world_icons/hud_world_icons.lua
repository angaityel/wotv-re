-- chunkname: @scripts/managers/hud/hud_world_icons/hud_world_icons.lua

require("scripts/managers/hud/hud_world_icons/floating_hud_icon")
require("scripts/managers/hud/hud_world_icons/floating_player_hud_icon")
require("scripts/managers/hud/hud_world_icons/floating_objective_hud_icon")

HUDWorldIcons = class(HUDWorldIcons, HUDBase)

function HUDWorldIcons:init(world, player)
	HUDWorldIcons.super.init(self, world, player)

	self._world = world
	self._player = player

	local viewport_name = player.viewport_name
	local viewport = ScriptWorld.viewport(world, viewport_name)

	self._camera = ScriptViewport.camera(viewport)
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "material", MenuSettings.font_group_materials.hell_shark, "material", MenuSettings.font_group_materials.viking_numbers, "immediate")
	self._floating_icons = {}
	self._raycast_queue = {}
	self._icon_active_units = {}

	Managers.state.event:register(self, "objective_activated", "event_objective_activated", "objective_deactivated", "event_objective_deactivated", "event_flag_spawned", "event_flag_spawned", "event_flag_destroyed", "event_flag_destroyed", "player_spawned", "event_player_spawned", "player_destroyed", "event_player_destroyed", "received_help_request", "event_received_help_request", "completed_revive", "event_completed_revive", "update_hud_objective_icons", "event_update_hud_objective_icons")
end

function HUDWorldIcons:event_update_hud_objective_icons(unit, icon_name, icon_name_2)
	fassert(self._floating_icons[unit], "No HUD objective icons exists for unit %s", unit)
	Unit.set_data(unit, "hud", "icon_name", icon_name)
	Unit.set_data(unit, "hud", "icon_name_2", icon_name_2)

	local floating_icon = self._floating_icons[unit].objective_icon_background
	local blackboard = floating_icon._blackboard

	self:_create_icons(blackboard, unit)
end

function HUDWorldIcons:event_objective_activated(blackboard, unit)
	if not self._floating_icons[unit] then
		self:_create_icons(blackboard, unit)
	end
end

function HUDWorldIcons:_create_icons(blackboard, unit)
	local icon_name = Unit.get_data(unit, "hud", "icon_name")

	if icon_name and icon_name ~= "" then
		self._floating_icons[unit] = {}

		local background_layout_settings = HUDSettings.world_icons[icon_name]

		self._floating_icons[unit].objective_icon_background = FloatingObjectiveHUDIcon:new(blackboard, self._gui, unit, self._camera, self._world, background_layout_settings, self._player)

		local icon_name_2 = Unit.get_data(unit, "hud", "icon_name_2")
		local owning_team_layout_settings

		if icon_name_2 and icon_name_2 ~= "" then
			owning_team_layout_settings = HUDSettings.world_icons[icon_name_2]
		end

		self._floating_icons[unit].objective_icon_owning_team = FloatingObjectiveHUDIcon:new(blackboard, self._gui, unit, self._camera, self._world, owning_team_layout_settings, self._player)

		local tagging_layout_settings = HUDSettings.world_icons.objective_tag

		self._floating_icons[unit].objective_icon_tagged = FloatingObjectiveHUDIcon:new(blackboard, self._gui, unit, self._camera, self._world, tagging_layout_settings, self._player)

		local locked_layout_settings = HUDSettings.world_icons.objective_lock_icon

		self._floating_icons[unit].objective_icon_locked = FloatingObjectiveHUDIcon:new(blackboard, self._gui, unit, self._camera, self._world, locked_layout_settings, self._player)
	end
end

function HUDWorldIcons:event_objective_deactivated(unit)
	self:_destroy_icon(unit)
end

function HUDWorldIcons:event_flag_spawned(blackboard, unit)
	local icon_name = Unit.get_data(unit, "hud", "icon_name")
	local layout_settings = HUDSettings.world_icons[icon_name]

	self._floating_icons[unit] = {}
	self._floating_icons[unit].flag_icon = FloatingHUDIcon:new(blackboard, self._gui, unit, self._camera, self._world, layout_settings, self._player)
end

function HUDWorldIcons:event_flag_destroyed(unit)
	self:_destroy_icon(unit)
end

function HUDWorldIcons:event_player_spawned(player, unit)
	if not self._floating_icons[unit] then
		self._floating_icons[unit] = {}

		local icon_name = Unit.get_data(unit, "hud", "icon_name")
		local layout_settings = HUDSettings.world_icons[icon_name]

		self._floating_icons[unit].name_tag = FloatingPlayerHUDIcon:new(self._gui, self._player, unit, self._camera, self._world, layout_settings)
	end
end

function HUDWorldIcons:_destroy_icon(unit)
	local icon = self._floating_icons[unit]

	if icon then
		for key, object in pairs(icon) do
			if type(object) == "table" and object.destroy then
				object:destroy()
			end
		end
	end

	self._floating_icons[unit] = nil
	self._raycast_queue[unit] = nil
end

function HUDWorldIcons:event_player_destroyed(unit)
	self:_destroy_icon(unit)
end

function HUDWorldIcons:event_received_help_request(unit)
	if self._floating_icons[unit] then
		self._floating_icons[unit].name_tag:help_requested()
	end
end

function HUDWorldIcons:event_completed_revive(unit)
	if self._floating_icons[unit] then
		self._floating_icons[unit].name_tag:help_no_longer_requested()
	end
end

function HUDWorldIcons:post_update(dt, t)
	Profiler.start("HUDWorldIcons:post_update()")
	Profiler.start("clearing active table")

	local active_units = self._icon_active_units

	table.clear(active_units)
	Profiler.stop()
	Profiler.start("updating line of sight checks")

	for unit, icons in pairs(self._floating_icons) do
		local active = false

		for _, icon in pairs(icons) do
			if icon.wants_line_of_sight_check and icon:wants_line_of_sight_check() and not self._raycast_queue[icon:unit()] then
				self._raycast_queue[icon:unit()] = t
			end

			local is_active = icon:post_update(dt, t)

			active = active or is_active
		end

		if active then
			active_units[#active_units + 1] = unit
		end
	end

	Profiler.stop()
	Profiler.start("setting active tagging icon")

	local taggable_unit = Managers.state.tagging:set_icon_active_units(self._player, self._camera, active_units)

	Profiler.stop()
	Profiler.start("rendering icons")

	for unit, icons in pairs(self._floating_icons) do
		for _, icon in pairs(icons) do
			icon:render(dt, t, taggable_unit == unit)
		end
	end

	Profiler.stop()
	Profiler.start("HUDWorldIcons:_update_raycast_queue()")
	self:_update_raycast_queue()
	Profiler.stop()
	Profiler.stop()
end

function HUDWorldIcons:_update_raycast_queue()
	local oldest_t = math.huge
	local unit

	for u, t in pairs(self._raycast_queue) do
		if t < oldest_t then
			oldest_t = t
			unit = u
		end
	end

	if unit then
		for _, icon in pairs(self._floating_icons[unit]) do
			if icon.wants_line_of_sight_check and icon:wants_line_of_sight_check() then
				icon:check_line_of_sight()
			end
		end

		self._raycast_queue[unit] = nil
	end
end

function HUDWorldIcons:destroy()
	World.destroy_gui(self._world, self._gui)
end
