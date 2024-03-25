-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_interaction.lua

require("scripts/settings/squad_settings")

PlayerUnitInteraction = class(PlayerUnitInteraction)
PlayerUnitInteraction.SYSTEM = "interaction_system"

function PlayerUnitInteraction:init(world, unit, player_index)
	self._interactions = {}

	for index, interact_category in ipairs(PlayerUnitMovementSettings.interaction) do
		local category_table = self:_init_interaction_categories(index, interact_category)

		self._interactions[index] = category_table
	end

	self._interaction_targets = {}
	self._unit = unit
	self._world = world
	self._locomotion = ScriptUnit.extension(unit, "locomotion_system")
	self._player = Managers.player:player(player_index)
	self._auto_interaction = {}
	self._pending_auto_interactions = {}
end

function PlayerUnitInteraction:_init_interaction_categories(index, interact_category)
	local category_table = {}

	category_table.interaction_target = nil
	category_table.interaction_type = nil
	category_table.settings = interact_category

	return category_table
end

for interact_name, settings in pairs(PlayerUnitMovementSettings.auto_interaction.settings) do
	settings.can_interact_function = "can_" .. interact_name
	settings.interact_function = "initiate_" .. interact_name
	settings.finished_interact_function = "finished_" .. interact_name
end

function PlayerUnitInteraction:update(unit, input, dt, context, t)
	self:_update_auto_interacts(t)

	for index, interaction in ipairs(self._interactions) do
		self:_update_target(t, interaction)
	end
end

function PlayerUnitInteraction:get_interaction_target(index)
	local interaction = self._interactions[index]

	if interaction.interaction_target and not Unit.alive(interaction.interaction_target) then
		self:_clear_interaction_target(interaction)
	end

	return interaction.interaction_target, interaction.interaction_type
end

function PlayerUnitInteraction:flow_cb_add_interaction_target(unit, actor)
	self:add(unit)
end

function PlayerUnitInteraction:add(unit)
	self._interaction_targets[unit] = true
end

function PlayerUnitInteraction:remove(unit)
	self._interaction_targets[unit] = nil

	for index, interaction in ipairs(self._interactions) do
		if unit == interaction.interaction_target then
			self:_clear_interaction_target(interaction)
		end
	end
end

function PlayerUnitInteraction:flow_cb_remove_interaction_target(unit, actor)
	self:remove(unit)
end

function PlayerUnitInteraction:_set_interaction_target(interaction, unit, type, t, arg1, arg2)
	local settings = interaction.settings
	local interaction_name_variable = settings.state_data_name
	local interaction_arg_1_variable = settings.state_data_arg1
	local interaction_arg_2_variable = settings.state_data_arg2

	self._player.state_data[interaction_name_variable] = "interact_" .. tostring(Unit.get_data(unit, "interacts", type))
	self._player.state_data[interaction_arg_1_variable] = arg1
	self._player.state_data[interaction_arg_2_variable] = arg2
	interaction.interaction_target = unit
	interaction.interaction_type = type
end

function PlayerUnitInteraction:_clear_interaction_target(interaction)
	local settings = interaction.settings
	local interaction_name_variable = settings.state_data_name

	self._player.state_data[interaction_name_variable] = nil
	interaction.interaction_target = nil
	interaction.interaction_type = nil
end

function PlayerUnitInteraction:_update_auto_interacts(t)
	for unit, _ in pairs(self._interaction_targets) do
		if Unit.alive(unit) then
			for _, interact_type in ipairs(PlayerUnitMovementSettings.auto_interaction.priorities) do
				if self:_can_auto_interact(unit, interact_type, t) then
					self[PlayerUnitMovementSettings.auto_interaction.settings[interact_type].interact_function](self, unit, t)

					self._pending_auto_interactions[unit] = true
				end
			end
		end
	end
end

function PlayerUnitInteraction:_can_auto_interact(unit, interact_type, t)
	return not self._pending_auto_interactions[unit] and Unit.has_data(unit, "auto_interacts", interact_type) and self[PlayerUnitMovementSettings.auto_interaction.settings[interact_type].can_interact_function](self, unit, t)
end

function PlayerUnitInteraction:can_ammo_loot(unit, t)
	if Managers.lobby.lobby and not Managers.state.network:game_object_id(unit) then
		return false
	end

	local inventory = self._locomotion:inventory()
	local can_loot, slot_name = inventory:can_ammo_loot(unit)

	return can_loot
end

function PlayerUnitInteraction:initiate_ammo_loot(unit, t)
	Managers.state.loot:request_ammo_loot(self._unit, unit, callback(self, "finish_ammo_loot", unit))
end

function PlayerUnitInteraction:finish_ammo_loot(gear_unit, self_unit, gear_name, ammo)
	if gear_name then
		local inventory = self._locomotion:inventory()
		local can_loot, slot_name = inventory:can_ammo_loot(gear_unit)

		if can_loot then
			inventory:add_ammo(slot_name, ammo)

			local gear = inventory:gear(slot_name)

			gear:trigger_timpani_event("unwield")
			Managers.state.loot:ammo_loot_completed(gear_unit)
		else
			Managers.state.loot:ammo_loot_aborted(gear_unit)
		end
	end

	self._pending_auto_interactions[gear_unit] = nil
end

function PlayerUnitInteraction:_update_target(t, interaction)
	self:_clear_interaction_target(interaction)

	local chase_mode = self._locomotion.chase_mode
	local chase_target = chase_mode and chase_mode.target_unit or nil

	for _, interact_type in ipairs(interaction.settings.priorities) do
		if Unit.alive(chase_target) then
			local can_interact, priority, arg1, arg2 = self:_can_interact(interaction, chase_target, interact_type, t)

			if can_interact then
				self:_set_interaction_target(interaction, chase_target, interact_type, t, arg1, arg2)

				return
			end
		end

		local best_priority = -math.huge
		local best_target, best_target_arg1, best_target_arg2

		for unit, _ in pairs(self._interaction_targets) do
			if Unit.alive(unit) and unit ~= chase_target then
				local can_interact, priority, arg1, arg2 = self:_can_interact(interaction, unit, interact_type, t)

				if can_interact and not priority then
					self:_set_interaction_target(interaction, unit, interact_type, t, arg1, arg2)

					return
				elseif can_interact and best_priority < priority then
					best_priority = priority
					best_target = unit
					best_target_arg1 = arg1
					best_target_arg2 = arg2
				end
			elseif not Unit.alive(unit) then
				self._interaction_targets[unit] = nil
			end
		end

		if best_target then
			self:_set_interaction_target(interaction, best_target, interact_type, t, best_target_arg1, best_target_arg2)

			return
		end
	end
end

function PlayerUnitInteraction:_can_interact(interaction, unit, interact_type, t)
	local allowed = not self._pending_auto_interactions[unit] and Unit.has_data(unit, "interacts", interact_type)

	if allowed then
		local can_loot, priority, arg1, arg2 = self[interact_type](self, unit, t, interaction)

		return can_loot, priority, arg1, arg2
	end

	return false
end

function PlayerUnitInteraction:revive(unit, t)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)
	local damage_ext = ScriptUnit.extension(unit, "damage_system")
	local can_revive = self._locomotion:can("can_revive", t)

	return can_revive and damage_ext:can_be_revived() and owner and owner.team == self._player.team and (not GameSettingsDevelopment.squad_first or self._player.squad_index and owner.squad_index == self._player.squad_index)
end

function PlayerUnitInteraction:travel_mode_tackle(unit, t, interaction)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)
	local target_locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local self_locomotion = self._locomotion
	local self_unit = self._unit
	local distance = Vector3.length(Unit.local_position(self_unit, 0) - Unit.local_position(unit, 0))
	local settings = PlayerUnitMovementSettings.travel_mode.tackle

	return distance < settings.range and self_locomotion.chase_mode and self_locomotion.chase_mode.target_unit == unit and t - self_locomotion.chase_mode.last_hit_time < settings.stun_last_chase_mode_hit_timer and target_locomotion:in_travel_mode() and owner and owner.team ~= self._player.team and self_locomotion:can("can_rush", t, settings.stamina_settings)
end

function PlayerUnitInteraction:backstab(unit, t, interaction)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)
	local target_locomotion = ScriptUnit.extension(unit, "locomotion_system")
	local self_locomotion = self._locomotion
	local distance = Vector3.distance(Unit.world_position(unit, 0), Unit.world_position(self._unit, 0))
	local perk_settings = Perks.backstab
	local return_val = self_locomotion.chase_mode and self_locomotion.chase_mode.target_unit == unit and t - self_locomotion.chase_mode.last_hit_time < PlayerUnitMovementSettings.travel_mode.tackle.stun_last_chase_mode_hit_timer and owner and owner.team ~= self._player.team and self_locomotion:can("can_backstab", t, unit) and self_locomotion.charging_backstab and t >= self_locomotion.start_backstab_charge_time + perk_settings.charge_time and distance <= perk_settings.attack_range

	if return_val then
		self._locomotion:set_perk_state("backstab", "ready")

		return true
	end

	return false
end

function PlayerUnitInteraction:execute(unit, t, interaction)
	return false
end

function PlayerUnitInteraction:bandage(unit, t, interaction)
	local player_manager = Managers.player
	local owner = player_manager:owner(unit)

	if not owner then
		return false
	end

	local damage_ext = ScriptUnit.extension(unit, "damage_system")
	local can_bandage = self._locomotion:can("can_bandage", t)
	local bandaging_allowed = false

	if SquadSettings.can_bandage == "team" then
		bandaging_allowed = owner.team == self._player.team
	elseif SquadSettings.can_bandage == "squad" then
		bandaging_allowed = owner.team == self._player.team and self._player.squad_index and self._player.squad_index == owner.squad_index
	elseif SquadSettings.can_bandage == "none" then
		bandaging_allowed = false
	else
		fassert(false, "PlayerUnitInteraction:bandage() : SquadSettings.can_bandage has incorrect value %s", SquadSettings.can_bandage)
	end

	local range = PlayerUnitMovementSettings.interaction[1].settings.bandage.initiate_distance
	local in_range = range > Vector3.length(Unit.world_position(self._unit, 0) - Unit.world_position(unit, 0))

	return in_range and bandaging_allowed and can_bandage and damage_ext:can_be_team_bandaged()
end

function PlayerUnitInteraction:climb(unit, t, interaction)
	return self._locomotion:can("can_climb", t)
end

function PlayerUnitInteraction:_looking_at_weight(position)
	local player = self._player
	local viewport = ScriptWorld.viewport(self._world, player.viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local screen_coords = Camera.world_to_screen(camera, position)
	local res_width, res_height = Gui.resolution()
	local middle_offset = Vector3(res_width * 0.5 - screen_coords.x, res_height * 0.5 - screen_coords.z, 0)
	local distance = Vector3.length(middle_offset) / res_width
	local zone = 0.2

	if distance < zone then
		local scaled_distance = distance / zone
		local score_value = math.sqrt(1 - scaled_distance^2)

		return score_value
	end
end

function PlayerUnitInteraction:loot(unit, t, interaction)
	local can_loot = self._locomotion:can("can_loot", unit, t)
	local actor = Unit.actor(unit, "dropped") or Unit.actor(unit, "thrown")
	local sleeping = actor and Vector3.length(Actor.velocity(actor)) < 0.1

	if can_loot and sleeping then
		local priority = self:_looking_at_weight(Actor.center_of_mass(actor))
		local lootable = priority and true or false

		if Unit.get_data(unit, "interacts", "loot") == "loot_plural" then
			local gear_name = L(Gear[Unit.get_data(unit, "gear_name")].ui_header_plural)
			local ammo = Unit.get_data(unit, "ammo")

			return lootable, priority, ammo, gear_name
		else
			local gear_name = L(Gear[Unit.get_data(unit, "gear_name")].ui_header)

			return lootable, priority, gear_name
		end
	end

	return false
end

function PlayerUnitInteraction:loot_trap(unit, t, interaction)
	local can_loot_trap = self._locomotion:can("can_loot_trap", unit, t)

	if can_loot_trap then
		local priority = self:_looking_at_weight(Unit.world_position(unit, 0))
		local lootable = priority and true or false

		return lootable
	end

	return false
end

function PlayerUnitInteraction:switch_item(unit, t)
	local can_switch = self._locomotion:can("can_switch_item", unit, t)

	if can_switch then
		local priority = self:_looking_at_weight(Unit.world_position(unit, 0))
		local switchable = priority and true or false
		local gear_name = L(Gear[Unit.get_data(unit, "gear")].ui_header)

		return switchable, priority, gear_name
	end

	return false
end

function PlayerUnitInteraction:trigger(unit, t, interaction)
	if not self._player.team then
		return false
	end

	local side = self._player.team.side
	local extension = ScriptUnit.extension(unit, "objective_system")

	return extension:active(side) and not extension:interactor() and extension:can_interact(self._player)
end

function PlayerUnitInteraction:destroy(u, input)
	return
end
