-- chunkname: @scripts/managers/hud/hud_player_status/hud_player_status.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_chunky_bar_element")
require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")
require("scripts/managers/hud/shared_hud_elements/hud_fading_texture_element")
require("scripts/managers/hud/shared_hud_elements/hud_fading_text_element")
require("scripts/managers/hud/hud_player_status/hud_power_bar_element")
require("scripts/managers/hud/hud_player_status/hud_perk_icon")
require("scripts/managers/hud/hud_player_status/hud_inactive_perk_icon")
require("scripts/managers/hud/hud_player_status/hud_perk_key_binding")
require("scripts/managers/hud/hud_squad_leader_indicator/hud_squad_leader_indicator")

HUDPlayerStatus = class(HUDPlayerStatus, HUDBase)

function HUDPlayerStatus:init(world, player)
	HUDPlayerStatus.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "material", MenuSettings.font_group_materials.hell_shark, "material", MenuSettings.font_group_materials.viking_numbers, "immediate")
	self._short_term_goal_settings = {
		short_term_goal = 0,
		new_data = false,
		end_time = 0,
		end_xp = 0
	}

	self:_setup_player_status()
	Managers.state.event:register(self, "event_player_status_hud_activated", "event_player_status_hud_activated", "short_term_goal_set", "event_short_term_goal_set", "awarded_rank", "event_awarded_rank")
	Managers.persistence:reload_profile_attributes(callback(self, "cb_profile_attributes_reloaded"))
end

function HUDPlayerStatus:cb_profile_attributes_reloaded(success)
	if success then
		local profile_data = Managers.persistence:profile_data()

		self._profile_data_loaded = true
		self._stats_collection = Managers.state.stats_collection
		self._player_rank = profile_data.attributes.rank
		self._current_xp = profile_data.attributes.experience
	end
end

function HUDPlayerStatus:_setup_player_status()
	self._bar_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.player_status.container
	})

	local bg_config = {
		z = 1,
		layout_settings = HUDSettings.player_status.background
	}

	self._bar_container:add_element("background_texture", HUDAtlasTextureElement.create_from_config(bg_config))

	local upcoming_level_config = {
		layout_settings = "HUDSettings.player_status.upcoming_level",
		z = -1
	}

	self._bar_container:add_element("upcoming_level_texture", HUDAtlasTextureElement.create_from_config(upcoming_level_config))

	local rank_up_upcoming_level_config = {
		z = 0,
		layout_settings = HUDSettings.player_status.rank_up_upcoming_level
	}

	self._rank_up_upcoming_level = HUDFadingTextureElement.create_from_config(rank_up_upcoming_level_config)

	self._bar_container:add_element("rank_up_upcoming_level", self._rank_up_upcoming_level)

	local current_level_config = {
		layout_settings = "HUDSettings.player_status.current_level",
		z = -1
	}

	self._bar_container:add_element("current_level_texture", HUDAtlasTextureElement.create_from_config(current_level_config))

	local dirt_fg_config = {
		z = 4,
		layout_settings = HUDSettings.player_status.dirt_foreground
	}

	self._bar_container:add_element("dirt_fg_texture", HUDAtlasTextureElement.create_from_config(dirt_fg_config))

	local health_bar_config = {
		z = 2,
		layout_settings = HUDSettings.player_status.health_bar
	}

	self._bar_container:add_element("health_bar", HUDChunkyBarElement.create_from_config(health_bar_config))

	local stamina_bar_config = {
		z = 3,
		layout_settings = HUDSettings.player_status.stamina_bar
	}

	self._bar_container:add_element("stamina_bar", HUDChunkyBarElement.create_from_config(stamina_bar_config))

	local exp_bar_config = {
		z = 3,
		layout_settings = HUDSettings.player_status.exp_bar
	}

	self._exp_bar = HUDChunkyBarElement.create_from_config(exp_bar_config)

	self._bar_container:add_element("exp_bar", self._exp_bar)

	local rank_up_exp_bar_config = {
		z = 4,
		layout_settings = HUDSettings.player_status.rank_up_exp_bar
	}

	self._rank_up_exp_bar = HUDFadingTextureElement.create_from_config(rank_up_exp_bar_config)

	self._bar_container:add_element("rank_up_exp_bar", self._rank_up_exp_bar)

	local short_term_goal_bar_config = {
		z = 2,
		layout_settings = HUDSettings.player_status.short_term_goal_bar
	}

	self._short_term_goal_bar = HUDChunkyBarElement.create_from_config(short_term_goal_bar_config)

	self._bar_container:add_element("short_term_goal_bar", self._short_term_goal_bar)

	local exp_bar_divider_config = {
		z = 5,
		layout_settings = HUDSettings.player_status.exp_divider
	}

	self._num_dividers = 9

	for i = 1, self._num_dividers do
		self._bar_container:add_element("exp_bar_divider_" .. tostring(i), HUDAtlasTextureElement.create_from_config(exp_bar_divider_config))
	end

	local exp_bar_end_config = {
		z = 8,
		layout_settings = HUDSettings.player_status.exp_bar_end
	}

	self._rank_up_exp_bar_end = HUDAtlasTextureElement.create_from_config(table.clone(exp_bar_end_config))
	self._short_term_goal_bar_end = HUDAtlasTextureElement.create_from_config(table.clone(exp_bar_end_config))

	local power_bar_config = {
		z = 2,
		layout_settings = HUDSettings.player_status.power_bar
	}

	self._power_bar = HUDPowerBarElement.create_from_config(power_bar_config)
	self._short_term_goal_container = HUDContainerElement.create_from_config({
		z = 0,
		layout_settings = HUDSettings.player_status.short_term_goal.container
	})

	local short_term_goal_timer_config = {
		text = "",
		z = 6,
		layout_settings = table.clone(HUDSettings.player_status.short_term_goal.timer)
	}

	self._short_term_goal_timer = HUDFadingTextElement.create_from_config(short_term_goal_timer_config)

	self._short_term_goal_container:add_element("short_term_goal_timer", self._short_term_goal_timer)

	local short_term_goal_bonus_config = {
		text = "",
		z = 6,
		layout_settings = table.clone(HUDSettings.player_status.short_term_goal.bonus)
	}

	self._short_term_goal_bonus = HUDFadingTextElement.create_from_config(short_term_goal_bonus_config)

	self._short_term_goal_container:add_element("short_term_goal_bonus", self._short_term_goal_bonus)

	local short_term_goal_background_config = {
		z = 5,
		layout_settings = table.clone(HUDSettings.player_status.short_term_goal.background)
	}

	self._short_term_goal_background = HUDFadingTextureElement.create_from_config(short_term_goal_background_config)

	self._short_term_goal_container:add_element("short_term_goal_background", self._short_term_goal_background)

	self._perks_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.player_status.perks.container
	})

	local perk_icon_config = {
		layout_settings = HUDSettings.player_status.perks.perk_icon
	}

	for i = 1, 4 do
		self._perks_container:add_element("perk_icon_" .. tostring(i), HUDPerkIcon.create_from_config(table.clone(perk_icon_config)))
		self._perks_container:add_element("perk_icon_" .. tostring(i + 4), HUDPerkIcon.create_from_config(table.clone(perk_icon_config)))
		self._perks_container:add_element("perk_icon_" .. tostring(i + 8), HUDInactivePerkIcon.create_from_config(table.clone(perk_icon_config)))
	end

	local perk_key_binding_config = {
		z = 2,
		layout_settings = HUDSettings.player_status.perks.perk_key_binding
	}

	for i = 1, 4 do
		self._perks_container:add_element("perk_key_binding_" .. tostring(i), HUDPerkKeyBinding.create_from_config(table.clone(perk_key_binding_config)))
	end

	self._bar_container:add_element("perks_container", self._perks_container)

	local squad_leader_icon_config = {
		layout_settings = HUDSettings.player_status.squad_icons.squad_leader_indicator
	}

	self._bar_container:add_element("squad_leader_icon", HUDSquadLeaderIndicator.create_from_config(squad_leader_icon_config))

	local squad_in_range_icon_config = {
		z = 2,
		layout_settings = HUDSettings.player_status.squad_icons.in_range_indicator
	}

	self._bar_container:add_element("squad_in_range_bg_icon", HUDAtlasTextureElement.create_from_config(table.clone(squad_in_range_icon_config)))

	squad_in_range_icon_config.z = squad_in_range_icon_config.z + 1

	self._bar_container:add_element("squad_in_range_icon", HUDInRangeIndicator.create_from_config(table.clone(squad_in_range_icon_config)))

	local flag_in_range_icon_config = {
		layout_settings = HUDSettings.player_status.squad_icons.squad_flag_range_indicator
	}

	self._bar_container:add_element("flag_in_range_icon", HUDAtlasTextureElement.create_from_config(flag_in_range_icon_config))
end

function HUDPlayerStatus:event_player_status_hud_activated(player, blackboard, perk_blackboard)
	if player == self._player then
		self._active = true

		local elements = self._bar_container:elements()

		for id, element in pairs(elements) do
			element.config.blackboard = blackboard
		end

		elements = self._perks_container:elements()

		for key, perk in ipairs(perk_blackboard) do
			local element_active = "perk_icon_" .. key
			local element_default = "perk_icon_" .. key + 4
			local element_inactive = "perk_icon_" .. key + 8
			local key_binding = "perk_key_binding_" .. key

			elements[element_active].config.blackboard = perk_blackboard
			elements[element_default].config.blackboard = perk_blackboard
			elements[element_inactive].config.blackboard = perk_blackboard
			elements[key_binding].config.blackboard = perk_blackboard
			elements[element_active].config.slot_number = key
			elements[element_default].config.slot_number = key
			elements[element_inactive].config.slot_number = key
			elements[key_binding].config.slot_number = key
			elements[element_active].config.z = 3
			elements[element_default].config.z = 0
			elements[element_inactive].config.z = 0
			elements[element_active].config.render_function = "_render_active_icon"
			elements[element_default].config.render_function = "_render_default_icon"

			local l_hud_assets = hud_assets
			local p_name = perk_blackboard[key].perk_name
			local h_text = Perks[p_name].hud_texture_default

			elements[element_inactive].config.atlas = "hud_atlas"
			elements[element_inactive].config.texture_atlas = "hud_assets_wipe_slot" .. key
			elements[element_inactive].config.material = "hud_assets_wipe_slot" .. key
			elements[element_inactive].config.texture_atlas_settings = l_hud_assets[h_text]
			elements[element_active].config.owning_player = player
			elements[element_default].config.owning_player = player
			elements[element_inactive].config.owning_player = player
			elements[key_binding].config.owning_player = player
		end
	end
end

function HUDPlayerStatus:event_awarded_rank(rank)
	self._player_rank = rank

	self._rank_up_exp_bar:fade_animation()
	self._rank_up_upcoming_level:fade_animation()
end

function HUDPlayerStatus:event_short_term_goal_set(end_time, end_xp, short_term_goal)
	self._short_term_goal_settings.new_data = true
	self._short_term_goal_settings.end_time = end_time
	self._short_term_goal_settings.end_xp = end_xp
	self._short_term_goal_settings.short_term_goal = short_term_goal
	self._display_failed_short_term_goal = false
end

function HUDPlayerStatus:_update_levels(dt, t, x, y, layout_setting)
	if GameSettingsDevelopment.disable_level_bar then
		return
	end

	local profile_data = Managers.persistence:profile_data()
	local rank, next_rank

	if self._profile_data_loaded then
		local rank_info = RANKS[self._player_rank]
		local round_xp = self._stats_collection:get(self._player:network_id(), "experience_round")
		local progress = (self._current_xp + round_xp - rank_info.xp.base) / rank_info.xp.span

		self._exp_bar:set_progress(progress)

		rank = self._player_rank
		next_rank = RANKS[rank + 1] ~= nil and rank + 1 or rank
	end

	local rank_text = string.format("%1.0f", rank or 0)
	local settings = HUDHelper:layout_settings("HUDSettings.player_status.current_level")
	local position = Vector3(x + settings.text_offset_x, y + settings.text_offset_y, 3)
	local offset = HUDHelper.text_align(self._gui, rank_text, settings.text_font, settings.text_size)

	ScriptGUI.text(self._gui, rank_text, settings.text_font, settings.text_size, settings.text_font_material, position + offset, Color(205, 0, 0, 0))

	rank_text = string.format("%1.0f", next_rank or 0)
	settings = HUDHelper:layout_settings("HUDSettings.player_status.upcoming_level")
	position = Vector3(x + settings.text_offset_x, y + settings.text_offset_y, 3)
	offset = HUDHelper.text_align(self._gui, rank_text, settings.text_font, settings.text_size)

	ScriptGUI.text(self._gui, rank_text, settings.text_font, settings.text_size, settings.text_font_material, position + offset, Color(205, 0, 0, 0))

	local bar_setting = HUDHelper:layout_settings(self._exp_bar.config.layout_settings)
	local step_x = bar_setting.bar_width / (self._num_dividers + 1)
	local start_x = -bar_setting.bar_width / 2
	local div_x = start_x

	for i = 1, self._num_dividers do
		div_x = div_x + step_x

		self._bar_container:element("exp_bar_divider_" .. tostring(i)):update_position(dt, t, layout_setting, x + div_x, y, layout_setting.z + 4)
	end
end

function HUDPlayerStatus:_update_power(t)
	local unit = self._player.player_unit

	if Unit.alive(unit) then
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")
		local blackboard = locomotion.charge_blackboard

		if blackboard.posing or blackboard.aiming or blackboard.charging_backstab then
			local power_bar = self._power_bar

			if blackboard.aiming then
				power_bar.config.layout_settings = HUDSettings.player_status.power_bar_aiming
			else
				power_bar.config.layout_settings = HUDSettings.player_status.power_bar
			end

			self._power_bar_active = true

			power_bar:set_glow_value(blackboard.overcharge_value)
			power_bar:set_transition_value(blackboard.minimum_charge_value)
			power_bar:set_value(blackboard.charge_value)
		elseif self._power_bar_active then
			self._power_bar_active = false

			self._power_bar:set_done()
		end
	end
end

function HUDPlayerStatus:_update_health()
	if Unit.alive(self._player.player_unit) then
		local state_data = self._player.state_data
		local health = 1 - state_data.damage / state_data.health

		self._bar_container:element("health_bar"):set_progress(health)

		self._old_health = health
	end
end

function HUDPlayerStatus:_update_stamina(dt, t)
	local unit = self._player.player_unit

	if Unit.alive(unit) and ScriptUnit.has_extension(unit, "locomotion_system") then
		local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")
		local stamina = locomotion_ext.stamina
		local value = stamina.value
		local stamina_element = self._bar_container:element("stamina_bar")

		if stamina.recharging and value < 1 then
			stamina_element:set_progress(stamina.value)
		elseif value == 1 then
			stamina_element:set_progress(stamina.value)
		else
			stamina_element:set_progress(stamina.value)
		end

		if stamina.denied_activation then
			stamina_element:set_progress_fail(stamina.denied_activation)

			stamina.denied_activation = nil
		end
	end
end

SET_HEALTH_VALUE = false
SET_STAMINA_VALUE = false
SET_EXP_VALUE = false
GIVE_DAMAGE = false
SET_STAMINA_FAIL = false

function HUDPlayerStatus:post_update(dt, t)
	local player = self._player
	local spawn_state = player.spawn_data.state

	if spawn_state == "dead" or spawn_state == "not_spawned" then
		self._active = false
	end

	if not self._active then
		return
	end

	if GIVE_DAMAGE then
		local unit = player.player_unit
		local damage = 10
		local damage_extension = ScriptUnit.extension(unit, "damage_system")

		damage_extension:add_damage(player, unit, "death_zone", damage, nil, nil, nil, "melee", nil, nil, "torso", Vector3.zero(), damage, nil, nil)

		GIVE_DAMAGE = false
	end

	self:_update_health()
	self:_update_stamina(dt, t)
	self:_update_power(t)

	if SET_HEALTH_VALUE then
		self._bar_container:element("health_bar"):set_progress(SET_HEALTH_VALUE)

		SET_HEALTH_VALUE = false
	end

	if SET_STAMINA_FAIL then
		self._bar_container:element("stamina_bar"):set_progress_fail(SET_STAMINA_FAIL)

		SET_STAMINA_FAIL = false
	end

	if SET_STAMINA_VALUE then
		self._bar_container:element("stamina_bar"):set_progress(SET_STAMINA_VALUE)

		SET_STAMINA_VALUE = false
	end

	if SET_EXP_VALUE then
		self._bar_container:element("exp_bar"):set_progress(SET_EXP_VALUE)

		SET_EXP_VALUE = false
	end

	local layout_setting = HUDHelper:layout_settings(self._bar_container.config.layout_settings)
	local gui = self._gui

	self._bar_container:update_size(dt, t, gui, layout_setting)

	local x, y = HUDHelper:element_position(nil, self._bar_container, layout_setting)

	self._bar_container:update_position(dt, t, layout_setting, x, y, layout_setting.z)
	self:_update_levels(dt, t, x, y, layout_setting)
	self._bar_container:render(dt, t, gui, layout_setting)

	if HUDSettings.show_pose_charge_helper then
		local layout_settings = HUDHelper:layout_settings(self._power_bar.config.layout_settings)

		self._power_bar:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._power_bar, layout_settings)

		self._power_bar:update_position(dt, t, layout_settings, x, y, layout_setting.z)
		self._power_bar:render(dt, t, gui, layout_settings)
	end

	local perk_elements = self._perks_container:elements()

	for id, perk_element in pairs(perk_elements) do
		local config = perk_element.config
		local blackboard = config.blackboard[config.slot_number]

		blackboard.state = Perks[blackboard.perk_name].default_state
	end

	if self._profile_data_loaded then
		local short_term_goal_settings = self._short_term_goal_settings
		local show_short_term_goal_hud = false

		if short_term_goal_settings.new_data then
			local rank_info = RANKS[self._player_rank]
			local goal_progress = (short_term_goal_settings.end_xp - rank_info.xp.base) / rank_info.xp.span

			self._short_term_goal_bar:set_progress(goal_progress)

			self._short_term_goal_settings.new_data = false
			show_short_term_goal_hud = true
		end

		local short_term_goal_time = self._short_term_goal_settings.end_time - Application.utc_time()

		if short_term_goal_time > 0 then
			local xp_needed = self._short_term_goal_settings.end_xp - (self._stats_collection:get(self._player:network_id(), "experience_round") + self._current_xp)

			self._short_term_goal_timer.config.text = string.format("%s XP -  %s", xp_needed, self:_format_timer_text(short_term_goal_time))

			local current_goal = self._short_term_goal_settings.short_term_goal
			local goal_settings = ShortTermGoals[current_goal]

			self._short_term_goal_bonus.config.text = string.format(L("short_term_goal_level"), goal_settings.name)
		else
			self._short_term_goal_timer.config.text = ""
			self._short_term_goal_bonus.config.text = L("short_term_goal_failed")

			if not self._display_failed_short_term_goal then
				show_short_term_goal_hud = true
				self._display_failed_short_term_goal = true
			end
		end

		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if show_short_term_goal_hud and game_mode_key ~= "sp" then
			self._short_term_goal_timer:fade_animation()
			self._short_term_goal_bonus:fade_animation()
			self._short_term_goal_background:fade_animation()
		end

		self:_render_object_at_end_of_bar(dt, t, gui, self._short_term_goal_bar, self._short_term_goal_container)
		self:_render_object_at_end_of_bar(dt, t, gui, self._short_term_goal_bar, self._short_term_goal_bar_end)
		self:_render_object_at_end_of_bar(dt, t, gui, self._exp_bar, self._rank_up_exp_bar_end)
	end
end

function HUDPlayerStatus:_render_object_at_end_of_bar(dt, t, gui, bar, object)
	local object_layout_settings = HUDHelper:layout_settings(object.config.layout_settings)

	object:update_size(dt, t, gui, object_layout_settings)

	local x, y = HUDHelper:element_position(nil, object, object_layout_settings)
	local bar_layout_settings = HUDHelper:layout_settings(bar.config.layout_settings)

	x = bar:x() + bar:current_width(bar_layout_settings) - object_layout_settings.width / 2 + object_layout_settings.pivot_offset_x

	object:update_position(dt, t, object_layout_settings, x, y, object.config.z)
	object:render(dt, t, gui, object_layout_settings)
end

function HUDPlayerStatus:_format_timer_text(seconds)
	local t = seconds
	local hours = math.floor(t / 3600)

	t = t - hours * 3600

	local minutes = math.floor(t / 60)

	t = t - minutes * 60

	return string.format("%02.f:%02.f:%02.f", hours, minutes, t)
end

function HUDPlayerStatus:destroy()
	World.destroy_gui(self._world, self._gui)
end
