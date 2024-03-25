-- chunkname: @scripts/managers/hud/hud_combat_log/hud_combat_log.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/hud_combat_log/hud_combat_log_entry")

HUDCombatLog = class(HUDCombatLog, HUDBase)

function HUDCombatLog:init(world, player)
	HUDCombatLog.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.hell_shark, "material", MenuSettings.font_group_materials.arial, "immediate")
	self._log_entries = {}
	self._log_entry_max = 10
	self._log_entry_cnt = 0

	self:_setup()

	local event_manager = Managers.state.event

	event_manager:register(self, "update_combat_log", "event_update_combat_log")
end

function HUDCombatLog:_setup()
	self._container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.combat_log.container
	})

	for i = 1, self._log_entry_max + 1 do
		local log_entry_config = {
			z = 3,
			local_player = self._player,
			gui = self._gui,
			layout_settings = table.clone(HUDSettings.combat_log.log_entry)
		}
		local log_entry = HUDCombatLogEntry.create_from_config(log_entry_config)

		self._log_entries[i] = log_entry

		self._container:add_element("log_entry_" .. i, log_entry)
	end
end

function HUDCombatLog:event_update_combat_log(attacking_player, victim_player, gear_name, hit_zone)
	self:add_entry(attacking_player, victim_player, gear_name, hit_zone)
end

function HUDCombatLog:add_entry(attacking_player, victim_player, gear_name, hit_zone)
	if not attacking_player.team or not victim_player.team then
		return
	end

	self._log_entry_cnt = self._log_entry_cnt % #self._log_entries + 1

	self._log_entries[self._log_entry_cnt]:set_entry_data(attacking_player, victim_player, gear_name, hit_zone)

	local entry = self._log_entries[self._log_entry_cnt]
	local entry_layout_settings = HUDHelper:layout_settings(entry.config.layout_settings)

	entry_layout_settings.pivot_offset_y = entry_layout_settings.height
end

function HUDCombatLog:post_update(dt, t)
	local single_player = not Managers.lobby.lobby

	if single_player then
		return
	end

	for i = 1, #self._log_entries do
		local entry_index = (i + self._log_entry_cnt - 1) % #self._log_entries + 1
		local entry = self._log_entries[entry_index]
		local entry_layout_settings = HUDHelper:layout_settings(entry.config.layout_settings)

		entry_layout_settings.pivot_offset_y = math.lerp(entry_layout_settings.pivot_offset_y, -((#self._log_entries - i) * entry_layout_settings.height), dt * 5)

		if i == 1 then
			entry_layout_settings.alpha_multiplier = math.lerp(entry_layout_settings.alpha_multiplier, 0, dt * 10)
		else
			entry_layout_settings.alpha_multiplier = math.lerp(entry_layout_settings.alpha_multiplier, 1, dt * 2)
		end
	end

	local layout_settings = HUDHelper:layout_settings(self._container.config.layout_settings)
	local gui = self._gui

	self._container:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self._container, layout_settings)

	self._container:update_position(dt, t, layout_settings, x, y, layout_settings.z)

	local spawn_state = self._player.spawn_data.state
	local allow_ghost_talking = Managers.state.game_mode:allow_ghost_talking()

	if spawn_state == "dead" or spawn_state == "not_spawned" or allow_ghost_talking then
		self._container:render(dt, t, gui, layout_settings)
	end
end

HUDCombatLog.hud_manager_inactive_post_update = HUDCombatLog.post_update

function HUDCombatLog:destroy()
	World.destroy_gui(self._world, self._gui)
end
