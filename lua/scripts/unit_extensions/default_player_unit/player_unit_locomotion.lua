-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_locomotion.lua

require("scripts/settings/player_movement_settings")
require("scripts/settings/gear_templates")
require("scripts/unit_extensions/human/base/human_locomotion")
require("scripts/unit_extensions/default_player_unit/states/player_movement_state_base")
require("scripts/unit_extensions/default_player_unit/states/player_onground")
require("scripts/unit_extensions/default_player_unit/states/player_inair")
require("scripts/unit_extensions/default_player_unit/states/player_jumping")
require("scripts/unit_extensions/default_player_unit/states/player_landing")
require("scripts/unit_extensions/default_player_unit/states/player_mounted")
require("scripts/unit_extensions/default_player_unit/states/player_knocked_down")
require("scripts/unit_extensions/default_player_unit/states/player_dead")
require("scripts/unit_extensions/default_player_unit/states/player_fake_death")
require("scripts/unit_extensions/default_player_unit/states/player_collapse")
require("scripts/unit_extensions/default_player_unit/states/player_planting_flag")
require("scripts/unit_extensions/default_player_unit/states/player_executing")
require("scripts/unit_extensions/default_player_unit/states/player_climbing")
require("scripts/unit_extensions/default_player_unit/states/player_reviving_teammate")
require("scripts/unit_extensions/default_player_unit/states/player_bandaging_teammate")
require("scripts/unit_extensions/default_player_unit/states/player_bandaging_self")
require("scripts/unit_extensions/default_player_unit/states/player_stunned")
require("scripts/unit_extensions/default_player_unit/states/player_triggering")
require("scripts/unit_extensions/default_player_unit/states/player_triggering_sp")
require("scripts/unit_extensions/default_player_unit/states/player_shield_bashing")
require("scripts/unit_extensions/default_player_unit/states/player_pushing")
require("scripts/unit_extensions/default_player_unit/states/player_charging")
require("scripts/unit_extensions/default_player_unit/states/player_special_attack")
require("scripts/unit_extensions/default_player_unit/states/player_dual_wield_attack")
require("scripts/unit_extensions/default_player_unit/states/player_dual_wield_special_attack")
require("scripts/unit_extensions/default_player_unit/states/player_special_attack_stance")
require("scripts/unit_extensions/default_player_unit/states/player_falling_attack")
require("scripts/unit_extensions/default_player_unit/states/player_taunting")
require("scripts/unit_extensions/default_player_unit/states/player_healtaunting")
require("scripts/unit_extensions/default_player_unit/states/player_dodging")
require("scripts/unit_extensions/default_player_unit/states/player_placing_trap")
require("scripts/unit_extensions/default_player_unit/states/player_looting_trap")
require("scripts/unit_extensions/default_player_unit/states/player_looting")
require("scripts/unit_extensions/default_player_unit/states/player_calling_horse")
require("scripts/unit_extensions/default_player_unit/inventory/player_unit_inventory")
require("scripts/settings/archetypes")

PlayerUnitLocomotion = class(PlayerUnitLocomotion, HumanLocomotion)
PlayerUnitLocomotion.SYSTEM = "locomotion_system"

function PlayerUnitLocomotion:_force_unit_to_ground(unit)
	local mover = Unit.mover(unit)

	Mover.move(mover, Vector3(0, 0, -2), World.delta_time(self.world))

	local pos = Mover.position(mover)

	Unit.set_local_position(unit, 0, pos)
end

function PlayerUnitLocomotion:init(world, unit, player_index, ghost_mode, profile)
	PlayerUnitLocomotion.super.init(self, world, unit)
	self:_force_unit_to_ground(unit)

	self._player_profile = profile
	self.archetype_settings = Archetypes[profile.archetype]

	local player_manager = Managers.player
	local player = player_manager:player(player_index)
	local fwd_vector = Quaternion.forward(Unit.local_rotation(unit, 0))
	local yaw = -math.atan2(fwd_vector.x, fwd_vector.y)
	local pitch = math.asin(fwd_vector.z)

	Managers.state.camera:set_pitch_yaw(player.viewport_name, pitch, yaw)
	self:_setup_debug_variables(unit)
	self:_init_internal_variables(unit, player)
	Unit.set_data(unit, "player_index", player_index)

	self.game = nil

	player_manager:assign_unit_ownership(unit, player_index, true)

	self.player = player

	player:set_camera_follow_unit(unit)

	local mount_profile = profile.mount
	local spawn_horse = mount_profile and ghost_mode

	self:_setup_states()

	if ghost_mode or spawn_horse or not Managers.state.game_mode:squad_spawn_stun(player.team) then
		self:_set_init_state("onground")
	else
		self:_set_init_state("stunned", "n/a", Vector3.up(), "squad_spawn")
	end

	if Managers.state.network:game() then
		self:_create_game_object(unit, ghost_mode, profile)
	end

	self:_setup_player_profile(profile)
	self:_setup_team_dependants(unit, player)

	if spawn_horse then
		self:spawn_new_mount(player, mount_profile, unit, ghost_mode, false)
	elseif mount_profile then
		local blackboard = self.call_horse_blackboard

		blackboard.player_unit = unit
		blackboard.mount_unit = nil
		blackboard.cooldown_duration = PlayerActionSettings.calling_horse.cooldown_duration
		blackboard.cooldown_time = 0

		Managers.state.event:trigger("own_horse_spawned", player, blackboard)
	end

	self:_setup_inventory(player)
	Managers.state.event:trigger("player_spawned", player, unit)

	if ghost_mode then
		self:_enter_ghost_mode()
	end

	Managers.state.event:register(self, "teleport_all_to", "event_teleport_all_to", "teleport_team_to", "event_teleport_team_to", "teleport_unit_to", "event_teleport_unit_to", "not_entertained", "event_not_entertained")
	Managers.state.event:trigger("event_sprint_hud_activated", player, self.sprint_hud_blackboard)
	Managers.state.event:trigger("event_parry_helper_activated", player, self.parry_helper_blackboard)
	Managers.state.event:trigger("event_player_status_hud_activated", player, self.player_status_blackboard, self._perks)
	Managers.state.event:trigger("show_game_mode_status", true)

	if HUDSettings.show_combat_text then
		Managers.state.event:trigger("event_combat_text_activated", player)
	end

	local level_settings = LevelHelper:current_level_settings()
	local flow_event = level_settings.on_spawn_flow_event

	if flow_event then
		Unit.flow_event(unit, flow_event)
	end

	self._auto_leave_ghost_mode_time = 0

	self:_freeze_lod_steps(unit)
end

function PlayerUnitLocomotion:IsHusk()
	return false
end

function PlayerUnitLocomotion:_freeze_lod_steps(unit)
	local num_lod_objects = Unit.num_lod_objects(unit)

	for i = 0, num_lod_objects - 1 do
		local lod = Unit.lod_object(unit, i)

		LODObject.set_static_select(lod, 0)
	end
end

function PlayerUnitLocomotion:_setup_debug_variables(unit)
	if Application.build() == "dev" then
		script_data.player_locomotion = self
		script_data.player = unit
	end

	self.debug_drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PLAYER_DEBUG"
	})
	self.debug_color = 0
end

function PlayerUnitLocomotion:_setup_states()
	self:_create_state("onground", PlayerOnground)
	self:_create_state("inair", PlayerInair)
	self:_create_state("jumping", PlayerJumping)
	self:_create_state("landing", PlayerLanding)
	self:_create_state("mounted", PlayerMounted)
	self:_create_state("knocked_down", PlayerKnockedDown)
	self:_create_state("dead", PlayerDead)
	self:_create_state("planting_flag", PlayerPlantingFlag)
	self:_create_state("executing", PlayerExecuting)
	self:_create_state("reviving_teammate", PlayerRevivingTeammate)
	self:_create_state("bandaging_teammate", PlayerBandagingTeammate)
	self:_create_state("bandaging_self", PlayerBandagingSelf)
	self:_create_state("climbing", PlayerClimbing)
	self:_create_state("stunned", PlayerStunned)
	self:_create_state("triggering", not Managers.lobby.lobby and PlayerTriggeringSP or PlayerTriggering)
	self:_create_state("shield_bashing", PlayerShieldBashing)
	self:_create_state("pushing", PlayerPushing)
	self:_create_state("charging", PlayerCharging)
	self:_create_state("calling_horse", PlayerCallingHorse)
	self:_create_state("special_attack", PlayerSpecialAttack)
	self:_create_state("dual_wield_attack", PlayerDualWieldAttack)
	self:_create_state("dual_wield_special_attack", PlayerDualWieldSpecialAttack)
	self:_create_state("special_attack_stance", PlayerSpecialAttackStance)
	self:_create_state("falling_attack", PlayerFallingAttack)
	self:_create_state("taunting", PlayerTaunting)
	self:_create_state("placing_trap", PlayerPlacingTrap)
	self:_create_state("looting_trap", PlayerLootingTrap)
	self:_create_state("heal_on_taunting", PlayerHealTaunting)
	self:_create_state("dodging", PlayerDodging)
	self:_create_state("looting", PlayerLooting)
	self:_create_state("fakedeath", PlayerFakeDeath)
	self:_create_state("collapse", PlayerCollapse)
end

function PlayerUnitLocomotion:_create_game_object(unit, ghost_mode, player_profile)
	local mover = Unit.mover(unit)
	local player = self.player
	local team_name = player.team.name
	local voice = player_profile["voice_" .. team_name]
	local perks = player_profile.perks
	local armour = player_profile["armour_" .. team_name]
	local helmet = player_profile["helmet_" .. team_name]
	local cloak = player_profile["cloak_" .. team_name]
	local cloak_pattern = player_profile["cloak_pattern_" .. team_name]
	local head_attachments = player_profile["head_attachments_" .. team_name]
	local helmet_variation = Helmets[helmet.name].material_variations[player_profile["helmet_variation_" .. team_name]] or Helmets[helmet.name].material_variations.default
	local beard = head_attachments.beard or 0
	local beard_color = head_attachments.beard_color or 0
	local beard_and_color = ProfileHelper:merge_beard_and_color(beard, beard_color)
	local data_table = {
		yaw_speed = 0,
		position = Mover.position(mover),
		rotation = Unit.local_rotation(unit, 0),
		game_object_created_func = NetworkLookup.game_object_functions.cb_spawn_player_unit,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_destroy_object,
		object_destroy_func = NetworkLookup.game_object_functions.cb_destroy_player_unit,
		player = player.temp_random_user_id,
		team_name = NetworkLookup.team[player.team.name],
		pose_lean_anim_blend_value = Vector3(0, 0, 0),
		aim_target = self.aim_target:unbox() - Unit.local_position(unit, 0),
		movement_state = NetworkLookup.movement_states[self.current_state_name],
		ghost_mode = ghost_mode,
		velocity = Vector3(0, 0, 0),
		in_combat = self.in_combat,
		travel_mode = self.travel_mode and true,
		stamina_state = NetworkLookup.stamina_state[self.stamina.state],
		head = NetworkLookup.heads[player_profile["head_" .. team_name]],
		beard_and_color = beard_and_color,
		helmet = NetworkLookup.helmets[helmet.name],
		helmet_variation = NetworkLookup.helmet_variations[helmet_variation and helmet_variation.material_variation or "n/a"],
		cloak = NetworkLookup.cloaks[cloak],
		cloak_pattern = NetworkLookup.cloak_patterns[cloak_pattern or "n/a"],
		armour = NetworkLookup.armours[armour],
		armour_pattern = player_profile["armour_attachments_" .. team_name].patterns or 1,
		voice = NetworkLookup.voices[voice],
		archetype = NetworkLookup.archetypes[player_profile.archetype]
	}

	for _, slot in ipairs(PerkSlots) do
		local perk = perks[slot.name]

		data_table[slot.game_object_field] = perk and NetworkLookup.perks[perk] or 0
	end

	local callback = callback(self, "cb_game_session_disconnect")

	self.id = Managers.state.network:create_game_object("player_unit", data_table, callback, "cb_local_unit_spawned", unit)
	self.game = Managers.state.network:game()
end

function PlayerUnitLocomotion:_setup_player_profile(player_profile)
	local unit = self.unit
	local t = Managers.time:time("game")
	local perks = player_profile.perks
	local team_name = self.player.team.name
	local armour = player_profile["armour_" .. team_name]
	local armour_settings = Armours[armour]
	local helmet = player_profile["helmet_" .. team_name]
	local helmet_settings = Helmets[helmet.name]
	local cloak = player_profile["cloak_pattern_" .. team_name]

	Unit.set_data(unit, "armour_type", armour_settings.armour_type)
	Unit.set_data(unit, "armour_sound_type", armour_settings.armour_sound_type)
	Unit.set_data(unit, "armour_sound_material", armour_settings.armour_sound_material)
	Unit.set_data(unit, "penetration_value", armour_settings.penetration_value)
	Unit.set_data(unit, "absorption_value", armour_settings.absorption_value)
	Unit.set_data(unit, "helmet_armour_type", helmet_settings.armour_type)
	Unit.set_data(unit, "helmet_penetration_value", helmet_settings.penetration_value)
	Unit.set_data(unit, "helmet_absorption_value", helmet_settings.absorption_value)
	Unit.set_data(unit, "assassin", table.contains(perks, "backstab") and "activated_player" or "not_activated")
	Unit.set_data(unit, "archetype", player_profile.archetype)

	for slot_name, perk in pairs(perks) do
		for key, perk_slot in ipairs(PerkSlots) do
			if slot_name == perk_slot.name then
				self._perks[key].perk_name = perk
				self._perks[key].state = Perks[perk].default_state
			end
		end
	end

	self.taunt_name = self._player_profile["taunt_" .. team_name]
end

function PlayerUnitLocomotion:spawn_new_mount(player, mount_profile, unit, ghost_mode, cavalry_perk_used)
	local pos = Unit.local_position(unit, 0)
	local rot = Unit.local_rotation(unit, 0)

	if cavalry_perk_used then
		pos = Vector3(pos.x, pos.y, pos.z + 0.3)
	end

	self.owned_mount_unit = Managers.state.spawn:spawn_mount(mount_profile, pos, rot, unit, ghost_mode)

	local blackboard = self.call_horse_blackboard

	blackboard.player_unit = unit
	blackboard.mount_unit = self.owned_mount_unit
	blackboard.cooldown_duration = PlayerActionSettings.calling_horse.cooldown_duration
	blackboard.cooldown_time = Managers.time:time("game") + PlayerActionSettings.calling_horse.cooldown_duration

	if not ghost_mode then
		Managers.state.event:trigger("own_horse_spawned", player, blackboard)
	end

	self:force_mount_unit(self.owned_mount_unit)
end

function PlayerUnitLocomotion:has_perk(perk_name, perks)
	if perks then
		return perks[perk_name] and true or false
	else
		local perk = self:_get_perk(perk_name)

		return perk and true or false
	end
end

function PlayerUnitLocomotion:perk_activation_command(perk_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before retreiving the activation command")

	return "activate_" .. perk.slot_name
end

function PlayerUnitLocomotion:get_perk_state(perk_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	return perk.state
end

function PlayerUnitLocomotion:set_perk_state(perk_name, state_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	perk.state = state_name
end

function PlayerUnitLocomotion:set_perk_data(perk_name, key, value)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	perk[key] = value
end

function PlayerUnitLocomotion:get_perk_data(perk_name, key)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	return perk[key]
end

function PlayerUnitLocomotion:_get_perk(perk_name)
	local perks = self._perks

	for i = 1, #perks do
		if perks[i].perk_name == perk_name then
			return perks[i]
		end
	end

	return nil
end

function PlayerUnitLocomotion:_setup_team_dependants(unit, player)
	local team = player.team
	local team_manager = Managers.state.team

	if team then
		Unit.set_data(unit, "team_name", team.name)
	end

	self:_disable_team_specific_actors()
end

function PlayerUnitLocomotion:_setup_inventory(player, spawn_horse)
	local inventory = PlayerUnitInventory:new(self.world, self.unit, player, self.id, self:has_perk("medium"))

	self._inventory = inventory

	local team = player.team
	local player_profile = self._player_profile

	for slot_name, profile_gear in pairs(player_profile.gear) do
		local gear_name = profile_gear.name

		inventory:add_gear(gear_name, nil, slot_name, self)
	end

	for slot_name, profile_gear in pairs(player_profile.gear) do
		if profile_gear.wielded then
			local gear_name = profile_gear.name

			fassert(inventory:can_wield(slot_name, self.current_state_name), "Can't wield gear %q in slot %q", gear_name, slot_name)

			local can_dual_wield = self:has_perk("berserk_01")
			local main_body_state, hand_anim = inventory:set_gear_wielded(slot_name, true, true, can_dual_wield)

			if main_body_state then
				self.current_state:anim_event(main_body_state, true)
			end

			if hand_anim then
				self.current_state:anim_event(hand_anim, true)
			end
		end
	end

	local team_name = player.team.name
	local armour_name = self._player_profile["armour_" .. team_name]
	local helmet = self._player_profile["helmet_" .. team_name]
	local helmet_name = helmet.name
	local helmet_settings = Helmets[helmet_name]
	local helmet_variation = helmet_settings.material_variations[self._player_profile["helmet_variation_" .. team_name]] or helmet_settings.material_variations.default or {}
	local cloak_name = self._player_profile["cloak_" .. team_name]
	local cloak_pattern = self._player_profile["cloak_pattern_" .. team_name]
	local beard = self._player_profile["head_attachments_" .. team_name].beard
	local beard_color = self._player_profile["head_attachments_" .. team_name].beard_color

	inventory:add_armour(armour_name, player_profile["armour_attachments_" .. team_name].patterns)
	inventory:add_head(self._player_profile["head_" .. team_name], self._player_profile["voice_" .. team_name], beard, beard_color)
	inventory:add_cloak(cloak_name, cloak_pattern, team_name)
	inventory:add_helmet(helmet_name, team.name, helmet_variation.material_variation)

	local pattern

	for attachment_type, attachment_name in pairs(helmet.attachments) do
		if attachment_type == "pattern" then
			pattern = helmet_settings.attachments[attachment_name]
		else
			inventory:add_helmet_attachment(helmet_name, attachment_type, attachment_name, team.name)
		end
	end

	if pattern then
		ProfileHelper:set_gear_patterns(inventory:helmet_unit(), helmet_settings.meshes, pattern)

		for attachment_type, attachment_name in pairs(helmet.attachments) do
			local attachment = helmet_settings.attachments[attachment_name]
			local attachment_meshes = attachment.meshes

			if attachment_meshes then
				local unit = inventory:helmet_attachment_unit(attachment_type)

				ProfileHelper:set_gear_patterns(unit, attachment_meshes, pattern)
			end
		end
	end

	inventory:add_coat_of_arms(PlayerCoatOfArms, team.name)
end

function PlayerUnitLocomotion:_enter_ghost_mode()
	self.ghost_mode = true

	Managers.state.event:trigger("ghost_mode_activated")

	local world = self.world

	self._ghost_mode_camera_particle_effect_id = World.create_particles(world, "fx/screenspace_ghostmode", Vector3(0, 0, 0))

	local unit = self.unit

	for _, actor_name in ipairs(PlayerUnitMovementSettings.ghost_mode.local_actors) do
		local actor = Unit.actor(unit, actor_name)

		if actor then
			Actor.set_collision_enabled(actor, false)
			Actor.set_scene_query_enabled(actor, false)
		end
	end

	local inventory = self._inventory

	inventory:enter_ghost_mode()

	local mover = Unit.mover(unit)

	Mover.set_collision_filter(mover, "ghost_mode_mover")
end

function PlayerUnitLocomotion:blend_out_of_ghost_mode()
	self._ghost_mode_blend_timer = Managers.time:time("game")
end

function PlayerUnitLocomotion:exit_ghost_mode()
	self.ghost_mode = false
	self.leaving_ghost_mode = true

	Managers.state.event:trigger("ghost_mode_deactivated")

	if self.game and self.id then
		GameSession.set_game_object_field(self.game, self.id, "ghost_mode", self.ghost_mode)
	end

	local world = self.world

	World.destroy_particles(world, self._ghost_mode_camera_particle_effect_id)

	self._ghost_mode_camera_particle_effect_id = nil

	local unit = self.unit

	for _, actor_name in ipairs(PlayerUnitMovementSettings.ghost_mode.local_actors) do
		local actor = Unit.actor(unit, actor_name)

		if actor then
			Actor.set_collision_enabled(actor, true)
			Actor.set_scene_query_enabled(actor, true)
		end
	end

	self:_disable_team_specific_actors()

	local inventory = self._inventory

	inventory:exit_ghost_mode()

	local mover = Unit.mover(unit)

	Mover.set_collision_filter(mover, "mover")
end

function PlayerUnitLocomotion:_disable_team_specific_actors()
	local team = self.player.team
	local team_manager = Managers.state.team

	for _, team_name in ipairs(team_manager:names()) do
		if not team or team_name == team.name then
			local actor = Unit.actor(self.unit, team_name)

			if actor then
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)
			end
		end
	end
end

function PlayerUnitLocomotion:cb_game_session_disconnect()
	self:_freeze()

	self.id = nil
	self.game = nil
end

function PlayerUnitLocomotion:inventory()
	return self._inventory
end

function PlayerUnitLocomotion:_init_internal_variables(unit, player)
	local rot = Unit.local_rotation(unit, 0)
	local pos = Unit.local_position(unit, 0)
	local t = Managers.time:time("game")

	PlayerUnitLocomotion.super._init_internal_variables(self, unit, t, pos, rot)

	self.couch_cooldown_time = 0
	self.current_rotation = QuaternionBox()
	self.target_rotation = QuaternionBox()
	self.camera_local_current_rotation = QuaternionBox()
	self.camera_local_target_rotation = QuaternionBox()
	self.double_time_direction = Vector3Box(Quaternion.forward(rot))
	self.move_rot = QuaternionBox(rot)
	self.riposte_time = -math.huge
	self.aim_rotation = QuaternionBox(rot)
	self.old_z = 0
	self.aim_vector = Vector3Box(Quaternion.forward(rot))
	self.velocity = Vector3Box(0, 0, 0)
	self.speed = Vector3Box(0, 0, 0)
	self.target_world_rotation = QuaternionBox(rot)
	self.move_speed = 0
	self.movement_state = nil
	self.accumulated_pose = Vector3Box(Vector3(0, 0, 0))
	self.accumulated_parry_direction = Vector3Box(Vector3(0, 0, 0))
	self.aim_target = Vector3Box(pos + Quaternion.forward(rot) * 3)
	self.look_angle = 0
	self.in_combat = false
	self._in_combat_cd_time = 0
	self.travel_mode = false
	self.backstab_charge_time = 0
	self.slope_check_last_z = -math.huge
	self.on_slope = false
	self.chase_mode = false

	local chase_raycast_callback = callback(self, "cb_chase_raycast_result")

	self._chase_raycast = PhysicsWorld.make_raycast(World.physics_world(self.world), chase_raycast_callback, "closest", "types", "both", "collision_filter", "chase_mode_check")
	self.special_attacking = false
	self.dodging = false
	self._perks = {
		{
			slot_name = "perk_1",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_2",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_3",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_4",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		}
	}
	self.stamina = {
		recharge_blocked = false,
		recharging = true,
		value = 1,
		state = "normal",
		consecutive_block_impact_time = 0,
		consecutive_block_impacts = 0,
		fail_time = -math.huge,
		recharge_timer = t,
		settings = self.archetype_settings.movement_settings.stamina,
		swing_chain_use_data = {
			multiplier = 1,
			t = 0
		},
		dodge_chain_use_data = {
			multiplier = 1,
			t = 0
		}
	}
	self.crossbow_reload_blackboard = {
		missing = false,
		circle_pos_y = 0,
		shader_value = 0,
		attempts = 3,
		texture_offset = 0,
		hitting = false,
		grab_area_rot_angle = 0,
		hook_rot_angle = 0,
		circle_pos_x = 0
	}

	local controller_settings = Managers.input:pad_active(1) and "pad360" or "keyboard_mouse"

	self.sprint_hud_blackboard = {
		cooldown_shader_value = 0,
		player = player,
		text = ActivePlayerControllerSettings[controller_settings].rush.key
	}
	self.mount_hud_blackboard = {
		cooldown_shader_value = 0,
		shader_value = 0,
		player = player,
		text = ActivePlayerControllerSettings[controller_settings].mounted_charge.key
	}
	self.charge_blackboard = {
		previous_charge_value = 0,
		posing = false,
		charge_value = 0,
		minimum_charge_value = 0
	}
	self.parry_helper_blackboard = {
		color = {
			255,
			255,
			255,
			255
		},
		attack_direction = {}
	}
	self.handgonne_reload_blackboard = {
		max_time = 0,
		timer = 0
	}
	self.lance_recharge_blackboard = {
		max_time = 0,
		timer = 0
	}
	self.perk_fast_pose_charge = {
		faster_melee_charge = {
			can_use = false
		}
	}
	self.perk_fast_aim_charge = {
		faster_bow_charge = {
			can_use = false,
			timer = 0
		}
	}
	self.perk_blade_master = {
		faster_moving = {
			time = 0
		}
	}
	self.call_horse_blackboard = {
		cooldown_time = 0,
		timer = 0,
		max_time = 10,
		cooldown_duration = PlayerActionSettings.calling_horse.max_time
	}
	self.tagging_blackboard = {
		cooldown_duration = 0,
		timer = 0,
		max_time = 0,
		cooldown_time = 0,
		player = player,
		text = ActivePlayerControllerSettings[controller_settings].activate_tag.key
	}
	self.player_status_blackboard = {
		player = player
	}
	self.dual_wield_config = {}
	self.wielding = false
	self.posing = false
	self.swinging = false
	self.aiming = false
	self.reloading = false
	self.parrying = false
	self.blocking = false
	self.dual_wield_defending = false
	self.dual_wield_attacking = false
	self.dual_wield_combo_last_slot = nil
	self.dual_wield_combo_time = -math.huge
	self.dual_wield_queued_attack_time = -math.huge
	self.dual_wield_queued_slot = nil
	self.dual_wield_queued_attack = nil
	self.block_start_time = 0
	self.pose_time = 0
	self.crouching = false
	self.attempting_parry = false
	self.pose_ready = false
	self.swing_direction = nil
	self.rush_cooldown_time = 0
	self.rush_start_time = 0
	self.double_time_timer = t + PlayerUnitMovementSettings.double_time.timer_time
	self.picking_flag = false
	self.carried_flag = nil
	self.planting_flag = false
	self.current_breathing_state = "normal"
	self.current_sway_settings = nil
	self.sway_camera = {
		pitch_angle = 0,
		previous_angle = 0,
		yaw_angle = 0
	}
	self.breathing_transition_time = 0
	self.hold_breath_timer = 0
	self.freeze = true
	self.ranged_weapon_zoom_value = 1
	self.block_broken = false
	self.tagging = false
	self.tagging_cooldown = 0
	self.tag_start_time = 0
	self.kd_tagging_cooldown = 0
	self.shield_bash_cooldown = 0
	self.push_cooldown = 0
	self.husks_in_proximity = {}
	self.current_aim_target = nil
end

function PlayerUnitLocomotion:_husks_in_proximity_overlap(dt, t)
	local physics_world = World.physics_world(self.world)
	local pose = Unit.world_pose(self.unit, 0)
	local cb = callback(self, "husks_in_proximity_overlap_cb")

	PhysicsWorld.overlap(physics_world, cb, "shape", "sphere", "pose", pose, "size", 4, "types", "dynamics", "collision_filter", "ai_husk_scan")
end

function PlayerUnitLocomotion:husks_in_proximity_overlap_cb(actors)
	table.clear(self.husks_in_proximity)

	for _, actor in ipairs(actors) do
		self.husks_in_proximity[ActorBox(actor)] = Actor.unit(actor)
	end
end

function PlayerUnitLocomotion:update(unit, input, dt, context, t)
	if self.frozen then
		return
	end

	if script_data.player_movement_debug then
		self.debug_drawer:quaternion(Unit.local_position(unit, 0), Unit.local_rotation(unit, 0), 1)
	end

	self:_husks_in_proximity_overlap(dt, t)
	Profiler.start("PlayerUnitLocomotion:update")

	self.controller = input.controller

	if script_data.debug_blade_master and self.controller and self.controller:get("switch_weapon_grip") and self:has_perk("blade_master") then
		self:_activate_blade_master_speed_boost(t)
	end

	self:_update_leave_ghost_mode(dt, t)
	self.current_state:update(dt, t)

	if not self.__destroyed then
		self:_update_state_data(dt, t)
		self.current_state:post_update(dt, t)
		self._inventory:update(dt, t)
		self._inventory:set_eye_target(self.aim_target:unbox())
		self:_update_in_combat(dt, t)
		self:_update_chase_mode(dt, t)
		self:_update_last_stand(dt, t)
	end

	self.last_controller = self.controller
	input.controller = nil
	self.controller = nil
	self.leaving_ghost_mode = false

	if Application.build() == "dev" and self.last_controller and Keyboard.pressed(Keyboard.button_index("k")) then
		Managers.command_parser:execute("/kill", self.player)
	end

	Profiler.stop()
end

function PlayerUnitLocomotion:fake_death_start_time()
	self._fake_death_end_time = Managers.time:time("round") + Perks.fake_death.duration_exp_after_up
end

function PlayerUnitLocomotion:is_getting_fake_death_bonus()
	local time = self._fake_death_end_time
	local time_left = time and time - Managers.time:time("round")

	return time_left ~= nil and time_left > 0
end

function PlayerUnitLocomotion:_update_last_stand(dt, t)
	local unit = self.unit
	local damage_ext = ScriptUnit.extension(unit, "damage_system")
	local perk_name = "last_stand"

	if not self:has_perk(perk_name) then
		return
	end

	if damage_ext:is_last_stand_active() then
		local time_start = self:get_perk_data(perk_name, "time_start")
		local time_end = self:get_perk_data(perk_name, "time_end")

		if not time_start or not time_end then
			self:set_perk_data(perk_name, "time_start", t)
			self:set_perk_data(perk_name, "time_end", t + Perks[perk_name].duration)
		end

		self:set_perk_data(perk_name, "state", "inactive")
	else
		self:set_perk_data(perk_name, "time_start", nil)
		self:set_perk_data(perk_name, "time_end", nil)
	end
end

function PlayerUnitLocomotion:_update_chase_mode(dt, t)
	local camera_manager = Managers.state.camera
	local viewport_name = self.player.viewport_name
	local camera_rotation = camera_manager:camera_rotation(viewport_name)
	local camera_position = camera_manager:camera_position(viewport_name)
	local chase_distance = PlayerUnitMovementSettings.chase_mode.max_distance
	local unit = self.unit
	local head_pos = Unit.world_position(unit, Unit.node(unit, "Head"))
	local camera_dir = Quaternion.forward(camera_rotation)
	local offset_distance = Vector3.dot(head_pos - camera_position, camera_dir)
	local from_pos = camera_position + offset_distance * camera_dir

	from_pos.z = from_pos.z + PlayerUnitMovementSettings.chase_mode.raycast_height_offset

	if script_data.chase_mode_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "immediate",
			name = "chase_mode_debug"
		})

		drawer:sphere(from_pos, 0.05, Color(0, 255, 0))
		drawer:vector(from_pos, chase_distance * camera_dir, Color(0, 255, 0))
	end

	self._chase_raycast:cast(from_pos, camera_dir, chase_distance)

	local chase_mode = self.chase_mode

	if chase_mode and t > chase_mode.last_hit_time + PlayerUnitMovementSettings.chase_mode.last_hit_timeout then
		self.chase_mode = false
	end

	if chase_mode and self:has_perk("chase_faster") then
		self:set_perk_state("chase_faster", "active")

		chase_distance = chase_distance * Perks.chase_faster.chase_mode_range_multiplier
	end

	if script_data.chase_mode_debug and chase_mode then
		Managers.state.debug_text:output_screen_text(t - chase_mode.last_hit, 12, 0, Vector3(255, 255, 255))
	end
end

function PlayerUnitLocomotion:cb_chase_raycast_result(hit, position, distance, normal, actor)
	if not self.__destroyed and hit and actor then
		local unit = Actor.unit(actor)
		local owner = Managers.player:owner(unit)

		if ScriptUnit.has_extension(unit, "locomotion_system") and owner and owner.team ~= self.player.team and ScriptUnit.extension(unit, "damage_system"):is_alive() then
			local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
			local target_aim_direction = Vector3.normalize(Vector3.flat(locomotion_extension:aim_direction()))
			local self_aim_direction = Vector3.normalize(Vector3.flat(self:aim_direction()))
			local max_angle_multiplier = self:has_perk("chase_faster") and Perks.chase_faster.chase_angle_multiplier or 1
			local max_angle = locomotion_extension:in_travel_mode() and PlayerUnitMovementSettings.chase_mode.back_max_angle_travel_mode or PlayerUnitMovementSettings.chase_mode.back_max_angle

			max_angle = max_angle * max_angle_multiplier

			local angle = (math.atan2(target_aim_direction.y, target_aim_direction.x) - math.atan2(self_aim_direction.y, self_aim_direction.x) + math.pi) % (math.pi * 2) - math.pi

			if script_data.chase_mode_debug then
				print(180 * angle / math.pi)
			end

			local player_pos = Unit.world_position(self.unit, 0)
			local target_pos = Unit.world_position(unit, 0)
			local aim_dir = self:aim_direction()
			local dot = Vector3.dot(Vector3.normalize(target_pos - player_pos), Vector3.normalize(aim_dir))

			if max_angle > math.abs(angle) and dot > 0 then
				self.chase_mode = self.chase_mode or {}
				self.chase_mode.last_hit_time = Managers.time:time("game")
				self.chase_mode.target_unit = unit
			end
		end
	end
end

function PlayerUnitLocomotion:_update_current_aim_target(dt, t)
	if self.aiming then
		-- block empty
	end
end

local IN_COMBAT_TOLERANCE = 5

function PlayerUnitLocomotion:_update_in_combat(dt, t)
	local in_combat = self.in_combat
	local game = Managers.state.network:game()
	local id = self.id
	local husks_in_proximity = self.husks_in_proximity
	local player_manager = Managers.player
	local enemies_close = false

	for _, unit in pairs(self.husks_in_proximity) do
		local owner = Unit.alive(unit) and player_manager:owner(unit)

		if owner and owner.team ~= self.player.team then
			enemies_close = true

			break
		end
	end

	local cooled_down = t > self._in_combat_cd_time

	if enemies_close then
		self._in_combat_cd_time = t + IN_COMBAT_TOLERANCE
		self.in_combat = true
	elseif not enemies_close and in_combat and cooled_down then
		self.in_combat = false
	end

	if game and id then
		GameSession.set_game_object_field(game, id, "in_combat", in_combat)
	end
end

function PlayerUnitLocomotion:_update_leave_ghost_mode(dt, t)
	local controller = self.controller
	local player = self.player

	if GameSettingsDevelopment.enable_robot_player and self.ghost_mode and t >= self._auto_leave_ghost_mode_time or controller and controller:get("leave_ghost_mode") and self.ghost_mode and Managers.state.spawn:allowed_to_leave_ghost_mode(player) then
		self._auto_leave_ghost_mode_time = t + 2

		Managers.state.spawn:request_leave_ghost_mode(player, self.unit)
	end

	local ghost_mode_blend_timer = self._ghost_mode_blend_timer

	if ghost_mode_blend_timer and t >= ghost_mode_blend_timer + EnvironmentTweaks.time_to_blend_env then
		self:exit_ghost_mode()

		if self.mounted_unit then
			local mount_locomotion = ScriptUnit.extension(self.mounted_unit, "locomotion_system")

			mount_locomotion:exit_ghost_mode()
			Managers.state.event:trigger("own_horse_spawned", player, self.call_horse_blackboard)
		end

		self._ghost_mode_blend_timer = nil
	end
end

function PlayerUnitLocomotion:post_update(unit, input, dt, context, t)
	if GameSettingsDevelopment.enable_debug_parry_stance and Keyboard.pressed(Keyboard.button_index("m")) then
		if script_data.debug_block ~= nil then
			script_data.debug_block = not script_data.debug_block
		else
			script_data.debug_block = true
		end
	end

	if GameSettingsDevelopment.debug_xp_gain and Keyboard.pressed(Keyboard.button_index("o")) then
		local network_manager = Managers.state.network

		if network_manager:game() then
			network_manager:send_rpc_server("rpc_gain_exp_test", self.player:player_id())
		end
	end

	if self.current_state.post_world_update then
		self.current_state:post_world_update(dt, t)
	end
end

function PlayerUnitLocomotion:_update_state_data(dt, t)
	local player = self.player
	local state_data = player.state_data

	if self.mounted_unit then
		local mount_locomotion = ScriptUnit.extension(self.mounted_unit, "locomotion_system")

		state_data.rush_cooldown_time = mount_locomotion.charge_cooldown
	else
		state_data.rush_cooldown_time = self.rush_cooldown_time
	end

	local built_in_overlay = self._inventory:built_in_overlay()

	if built_in_overlay then
		state_data.visor_open = false
		state_data.visor_name = built_in_overlay
	else
		state_data.visor_open = self._inventory:visor_open()
		state_data.visor_name = self._inventory:visor_name()
	end

	state_data.helmet_name = self._inventory:helmet_name()
end

function PlayerUnitLocomotion:destroy()
	PlayerUnitLocomotion.super.destroy(self)

	local unit = self.unit

	if unit == script_data.player then
		script_data.player = nil
	end

	if script_data.player_locomotion == self then
		script_data.player_locomotion = nil
	end

	self.__destroyed = true
	self.id = nil

	if self.ghost_mode then
		World.destroy_particles(self.world, self._ghost_mode_camera_particle_effect_id)

		self._ghost_mode_camera_particle_effect_id = nil
	end

	if self.stamina.exhausted_threshold then
		self.stamina.exhausted_threshold = false

		local timpani_world = World.timpani_world(self.world)

		TimpaniWorld.trigger_event(timpani_world, "stop_chr_vce_tired_loop")
	end

	Managers.state.event:unregister("teleport_all_to", self)
	Managers.state.event:unregister("teleport_team_to", self)
	Managers.state.event:unregister("teleport_unit_to", self)
	self._inventory:destroy()
	Managers.state.event:trigger("player_destroyed", unit)

	local flag = self.carried_flag

	if flag and Unit.alive(flag) and ScriptUnit.has_extension(flag, "flag_system") then
		local flag_ext = ScriptUnit.extension(flag, "flag_system")

		flag_ext:drop()
	end

	local network_manager = Managers.state.network
	local player_manager = Managers.player

	if player_manager:owner(unit) then
		Managers.player:relinquish_unit_ownership(unit)
	end
end

function PlayerUnitLocomotion:force_mount_unit(mount_unit)
	self.mounted_unit = mount_unit

	self:_change_state("mounted")
end

function PlayerUnitLocomotion:rpc_mount_denied(mount_object_id, mount_unit)
	if self.current_state_name == "mounted" and self.mounted_unit == mount_unit then
		self.current_state:force_unmount("mount_denied")
	end
end

function PlayerUnitLocomotion:rpc_unmount(mount_unit)
	self:unmount(mount_unit)
end

function PlayerUnitLocomotion:unmount(mount_unit)
	if self.current_state_name == "mounted" and self.mounted_unit == mount_unit then
		self.current_state:force_unmount("unmount")
	end
end

function PlayerUnitLocomotion:mounted()
	return self.current_state_name == "mounted"
end

function PlayerUnitLocomotion:gear_impact(impact_type, damage, impact_direction, attack_name, attacking_unit, attacking_gear_unit)
	local settings = PlayerUnitMovementSettings[impact_type]
	local t = Managers.time:time("game")
	local multiplier = settings.stamina_per_damage
	local attack_settings = Unit.get_data(attacking_gear_unit, "attacks")[attack_name]

	if impact_type == "block" then
		local stamina = self.stamina

		if t < stamina.consecutive_block_impact_time then
			stamina.consecutive_block_impacts = stamina.consecutive_block_impacts + 1
		else
			stamina.consecutive_block_impacts = 0
		end

		stamina.consecutive_block_impact_time = t + settings.consecutive_block_impact_time

		local impacts = stamina.consecutive_block_impacts

		if attack_settings.shield_breaker then
			multiplier = multiplier * attack_settings.shield_breaker
		end

		multiplier = multiplier * settings.consecutive_block_impact_multiplier^impacts
		multiplier = self:has_perk("dodge_block") and multiplier * Perks.dodge_block.block_stamina_multiplier or multiplier
	end

	if impact_type == "block" then
		local timpani_world = World.timpani_world(self.world)
		local unit = self.unit
		local id = TimpaniWorld.trigger_event(timpani_world, "chr_vce_block", unit, Unit.node(unit, "Head"))
		local voice = self._inventory:voice()

		TimpaniWorld.set_parameter(timpani_world, id, "character_vo", voice)
	end

	local stamina_settings = {
		activation_cost = damage * multiplier
	}
	local stamina_left = self.current_state:stamina_activate(stamina_settings)

	if impact_type == "parry" then
		self.riposte_time = t

		self:_blade_master_check(attacking_unit, t)

		if stamina_left == 0 then
			self:stun("torso", impact_direction, impact_type)
		end
	end

	if impact_type == "dual_wield_defend" and stamina_left == 0 and multiplier ~= 0 then
		self:stun("torso", impact_direction, impact_type)
	end

	local network_manager = Managers.state.network
	local shield_gear = self._inventory:gear("shield")

	if network_manager:game() then
		if self:_shield_destroying_attack(attack_name, attacking_unit) and impact_type == "block" and shield_gear then
			if self:has_perk("shield_maiden02") then
				local position = Unit.world_position(self.unit, Unit.node(self.unit, "Neck"))
				local attacking_player = Unit.get_data(attacking_unit, "owner_player_index")

				network_manager:send_rpc_server("rpc_send_perk_combat_text", attacking_player, NetworkLookup.perks.shield_maiden02, position)
				self._inventory:drop_gear("shield")
				self.current_state:anim_event("to_unshield")
			else
				self:gear_dead(shield_gear:unit())

				if Managers.lobby.server then
					network_manager:send_rpc_clients("rpc_shield_break", network_manager:game_object_id(attacking_unit), network_manager:game_object_id(self.unit))
				else
					network_manager:send_rpc_server("rpc_shield_break", network_manager:game_object_id(attacking_unit), network_manager:game_object_id(self.unit))
				end

				Managers.state.event:trigger("shield_break", attacking_unit, self.unit)
			end

			self:stun("torso", impact_direction, impact_type)
		elseif stamina_left == 0 and impact_type == "block" and shield_gear then
			self._inventory:drop_gear("shield")
			self.current_state:anim_event("to_unshield")
			self:stun("torso", impact_direction, impact_type)
		end
	end
end

function PlayerUnitLocomotion:_blade_master_check(attacking_unit, t)
	if self:has_perk("blade_master") == false then
		return
	end

	local attacking_loco = ScriptUnit.extension(attacking_unit, "locomotion_system")
	local attacking_team = attacking_loco.player.team.name
	local our_team = self.player.team.name

	if our_team and attacking_team and our_team == attacking_team then
		return
	end

	ScriptUnit.extension(self.unit, "damage_system"):blade_master_activated()
	self:_activate_blade_master_speed_boost(t)

	local network_manager = Managers.state.network
	local network_parrying_unit = network_manager:game_object_id(self.unit)
	local network_attacking_unit = network_manager:game_object_id(attacking_unit)

	network_manager:send_rpc_server("rpc_blade_master_got_parried", network_parrying_unit, network_attacking_unit)
end

function PlayerUnitLocomotion:blade_master_got_parried(parrying_unit, attacking_unit)
	if self.unit ~= attacking_unit then
		return
	end

	local stamina_cost = Perks.blade_master.parry_attacker_stamina_loss

	self.stamina.value = math.max(self.stamina.value - stamina_cost, 0)

	local inventory = self._inventory
	local parrying_position = Unit.world_position(parrying_unit, Unit.node(parrying_unit, "Neck"))

	if self.stamina.value == 0 then
		if not inventory:is_dual_wielding() then
			for _, slot_name in ipairs(InventorySlotPriority) do
				if slot_name ~= "dagger" and inventory:is_wielded(slot_name) then
					local timpani_world = World.timpani_world(self.world)
					local unit = inventory:gear_unit(slot_name)

					TimpaniWorld.trigger_event(timpani_world, "break_sword", unit)
					inventory:drop_gear(slot_name)
					self.current_state:react_to_blademaster_parry()
				end
			end
		end

		local attacking_position = Unit.world_position(self.unit, Unit.node(self.unit, "Neck"))
		local impact_direction = Vector3.normalize(attacking_position - parrying_position)

		self:stun("torso", impact_direction, "push_impact")
	end

	Managers.state.event:trigger("show_perk_text", self.player, Perks.blade_master.combat_text, parrying_position)
end

function PlayerUnitLocomotion:_shield_destroying_attack(attack_name, attacking_unit)
	local attacker_locomotion = ScriptUnit.extension(attacking_unit, "locomotion_system")
	local heavy_axe_special = attacker_locomotion:has_perk("heavy_02") and attack_name == "special"

	return heavy_axe_special
end

function PlayerUnitLocomotion:_activate_blade_master_speed_boost(t)
	self.perk_blade_master.faster_moving.time = t + Perks.blade_master.speed_boost.duration
	self.stamina.value = Perks.blade_master.stamina_amount ~= 0 and math.min(self.stamina.value + Perks.blade_master.stamina_amount, 1) or self.stamina.value
end

function PlayerUnitLocomotion:stun(hit_zone, impact_direction, impact_type, ...)
	if self.travel_mode and impact_type == "rush_impact" then
		impact_type = "rush_impact_travel_mode"
	end

	if type(self.current_state.stun) == "function" then
		self.current_state:stun(hit_zone, impact_direction, impact_type, ...)
	else
		self:_change_state("stunned", hit_zone, impact_direction, impact_type, ...)
	end

	local timpani_world = World.timpani_world(self.world)
	local unit = self.unit

	TimpaniWorld.trigger_event(timpani_world, "stunned_player_short", unit, Unit.node(unit, "Head"))

	local id = TimpaniWorld.trigger_event(timpani_world, "stunned_player_vce", unit, Unit.node(unit, "Head"))
	local voice = self._inventory:voice()

	TimpaniWorld.set_parameter(timpani_world, id, "character_vo", voice)
end

function PlayerUnitLocomotion:is_dodging()
	return NetworkLookup.movement_states[GameSession.game_object_field(self.game, self.id, "movement_state")] == "dodging"
end

function PlayerUnitLocomotion:pommel_bash_interrupt(hit_zone, impact_direction)
	self.current_state:safe_action_interrupt("hit_by_pommel_bash", hit_zone, impact_direction)
end

function PlayerUnitLocomotion:damage_interrupt(hit_zone, impact_direction, impact_type)
	self.current_state:safe_action_interrupt(impact_type, hit_zone, impact_direction)
	WeaponHelper:player_unit_hit_reaction_animation(self.unit, hit_zone, impact_direction, self:aim_direction(), impact_type)
end

function PlayerUnitLocomotion:received_damage(damage, front_back, direction)
	local t = Managers.time:time("game")
	local camera_manager = Managers.state.camera
	local event = front_back and "damaged_" .. front_back .. "_" .. direction or "damaged"

	camera_manager:camera_effect_sequence_event(event, t)
	camera_manager:camera_effect_shake_event(event, t)

	if self:has_perk("heal_on_taunt") and self.current_state_name == "heal_on_taunting" then
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:rpc_start_revive()
	local state_name = self.current_state_name

	assert(state_name == "knocked_down")
	self.current_state:start_revive()
end

function PlayerUnitLocomotion:rpc_abort_revive()
	local state_name = self.current_state_name

	assert(state_name == "knocked_down")
	self.current_state:abort_revive()
end

function PlayerUnitLocomotion:rpc_completed_revive()
	local state_name = self.current_state_name

	assert(state_name == "knocked_down")
	self.current_state:revived()
end

function PlayerUnitLocomotion:revive_yourself_interaction_confirmed()
	local state_name = self.current_state_name

	assert(state_name == "knocked_down")
	self.current_state:start_revive(true)
end

function PlayerUnitLocomotion:revive_yourself_interaction_denied()
	return
end

function PlayerUnitLocomotion:rpc_completed_revive_yourself()
	local state_name = self.current_state_name

	assert(state_name == "knocked_down")
	self.current_state:revived(true)
end

function PlayerUnitLocomotion:rpc_gear_dead(unit)
	self:gear_dead(unit)
end

function PlayerUnitLocomotion:player_knocked_down(hit_zone, impact_direction, damage_type)
	self:_change_state("knocked_down", hit_zone, impact_direction, damage_type)
end

function PlayerUnitLocomotion:player_collapse()
	if self.ghost_mode or self.current_state_name == "dead" or self.current_state_name == "knocked_down" or self.current_state_name == "fake_death" then
		return
	end

	self:_change_state("collapse")
end

function PlayerUnitLocomotion:player_dead(is_instakill, damage_type, hit_zone, impact_direction, finish_off)
	self:_change_state("dead", is_instakill, damage_type, hit_zone, impact_direction, finish_off)
end

function PlayerUnitLocomotion:get_velocity()
	return self.velocity:unbox()
end

function PlayerUnitLocomotion:rpc_flag_plant_complete(flag_unit)
	return
end

function PlayerUnitLocomotion:rpc_flag_pickup_confirmed(flag_unit)
	self.picking_flag = false
	self.carried_flag = flag_unit
end

function PlayerUnitLocomotion:rpc_flag_drop(flag_unit)
	assert(flag_unit == self.carried_flag, "Trying to drop other flag than the one carried.")

	self.carried_flag = nil
end

function PlayerUnitLocomotion:rpc_flag_pickup_denied()
	self.picking_flag = false
end

function PlayerUnitLocomotion:rpc_flag_plant_confirmed()
	if self.current_state_name == "planting_flag" then
		self.current_state:interaction_confirmed()
	end

	if false then
		-- block empty
	end
end

function PlayerUnitLocomotion:rpc_flag_plant_denied()
	if self.current_state_name == "planting_flag" then
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:hot_join_synch(sender, player)
	local network_manager = Managers.state.network
	local player_object_id = self.id
	local unit = self.unit

	RPC.rpc_synch_player_anim_state(sender, player_object_id, Unit.animation_get_state(unit))

	if self.mounted_unit and Managers.player:owner(self.mounted_unit) == self.player then
		local mount_object_id = network_manager:unit_game_object_id(self.mounted_unit)

		RPC.rpc_mounted_husk(sender, player_object_id, mount_object_id, self.player.temp_random_user_id)
	end

	if self.block_direction then
		RPC.rpc_hot_join_synch_parry_block(sender, player_object_id, NetworkLookup.inventory_slots[self.block_slot_name], NetworkLookup.directions[self.block_direction])
	end

	if self.carried_flag then
		RPC.rpc_flag_pickup_confirmed(sender, player_object_id, network_manager:game_object_id(self.carried_flag))
	end

	if self.posing then
		RPC.rpc_hot_join_synch_pose(sender, player_object_id, NetworkLookup.directions[self.pose_direction])
	end

	if self.current_state_name == "climbing" then
		self.current_state:synch_ladder_unit(sender)
	end

	self._inventory:hot_join_synch(sender, player, player_object_id)
end

function PlayerUnitLocomotion:anim_cb_hide_wielded_weapons()
	self._inventory:anim_cb_hide_wielded_weapons(true)
end

function PlayerUnitLocomotion:anim_cb_unhide_wielded_weapons()
	self._inventory:anim_cb_hide_wielded_weapons(false)
end

function PlayerUnitLocomotion:yield_interaction_confirmed()
	fassert(self.current_state_name == "knocked_down", "Yield confirmed but player unit %s is dead.", tostring(self.unit))
	self.current_state:yield_confirmed()
end

function PlayerUnitLocomotion:yield_interaction_denied()
	if self.current_state_name == "knocked_down" then
		self.current_state:yield_denied()
	end
end

function PlayerUnitLocomotion:execute_interaction_confirmed()
	if self.current_state_name == "executing" then
		self.current_state:interaction_confirmed()
	end
end

function PlayerUnitLocomotion:execute_interaction_denied()
	if self.current_state_name == "executing" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:bandage_interaction_confirmed()
	if self.current_state_name == "bandaging_teammate" or self.current_state_name == "bandaging_self" then
		self.current_state:interaction_confirmed()
	end
end

function PlayerUnitLocomotion:bandage_interaction_denied()
	if self.current_state_name == "bandaging_teammate" or self.current_state_name == "bandaging_self" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:loot_interaction_confirmed(ammo)
	if self.current_state_name == "looting" then
		self.current_state:interaction_confirmed(ammo)
	end
end

function PlayerUnitLocomotion:loot_interaction_denied()
	if self.current_state_name == "looting" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:loot_trap_interaction_confirmed()
	if self.current_state_name == "looting_trap" then
		self.current_state:interaction_confirmed()
	end
end

function PlayerUnitLocomotion:loot_trap_interaction_denied()
	if self.current_state_name == "looting_trap" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:revive_interaction_confirmed()
	if self.current_state_name == "reviving_teammate" then
		self.current_state:interaction_confirmed()
	end
end

function PlayerUnitLocomotion:revive_interaction_denied()
	if self.current_state_name == "reviving_teammate" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:trigger_interaction_confirmed()
	if self.current_state_name == "triggering" then
		self.current_state:interaction_confirmed()
	end
end

function PlayerUnitLocomotion:trigger_interaction_denied()
	if self.current_state_name == "triggering" then
		self.current_state:interaction_denied()
		self:_change_state("onground")
	end
end

function PlayerUnitLocomotion:aim_direction()
	return self.current_state:aim_direction()
end

function PlayerUnitLocomotion:start_execution_victim(execution_definition, attacker_unit)
	self.current_state:begin_execution(execution_definition, attacker_unit)
end

function PlayerUnitLocomotion:abort_execution_victim()
	if self.current_state_name == "dead" then
		-- block empty
	elseif self.current_state_name == "knocked_down" then
		self.current_state:abort_execution()
	else
		ferror("Trying to abort execution for player unit %q in state %q", self.unit, self.current_state_name)
	end
end

function PlayerUnitLocomotion:event_teleport_all_to(position, rotation, camera_rotation)
	self:_teleport_to(position, rotation, camera_rotation)
end

function PlayerUnitLocomotion:event_teleport_unit_to(unit, position, rotation, camera_rotation)
	if self.unit == unit then
		self:_teleport_to(position, rotation, camera_rotation)
	end
end

function PlayerUnitLocomotion:event_teleport_team_to(team_name, position, rotation, camera_rotation)
	if team_name == self.player.team.name then
		self:_teleport_to(position, rotation, camera_rotation)
	end
end

function PlayerUnitLocomotion:_teleport_to(position, rotation, camera_rotation)
	if self.current_state_name == "dead" then
		return
	end

	if camera_rotation then
		local fwd_vector = Quaternion.forward(camera_rotation)
		local yaw = -math.atan2(fwd_vector.x, fwd_vector.y)
		local pitch = math.asin(fwd_vector.z)

		Managers.state.camera:set_pitch_yaw(self.player.viewport_name, pitch, yaw)
	end

	if Unit.alive(self.mounted_unit) then
		local locomotion = ScriptUnit.extension(self.mounted_unit, "locomotion_system")

		locomotion:teleport(position, rotation)
	else
		self.current_state:set_local_position(position)

		if rotation then
			self.current_state:set_local_rotation(rotation)
		end

		Mover.set_position(Unit.mover(self.unit), position)
	end
end

function PlayerUnitLocomotion:event_not_entertained(unit)
	if type(self.current_state.not_entertained) == "function" then
		self.current_state:not_entertained(unit)
	end
end

function PlayerUnitLocomotion:dance()
	if type(self.current_state.dance) == "function" then
		self.current_state:dance()
	end
end

function PlayerUnitLocomotion:whistle()
	if type(self.current_state.whistle) == "function" then
		self.current_state:whistle()
	end
end

function PlayerUnitLocomotion:flow_cb_footstep(foot)
	self.current_state:flow_cb_footstep(foot)
end

function PlayerUnitLocomotion:set_ladder_unit(ladder_unit)
	return
end

function PlayerUnitLocomotion:in_travel_mode()
	return self.travel_mode and true
end

function PlayerUnitLocomotion:duel_confirmed(target)
	if type(self.current_state.duel_confirmed) == "function" then
		self.current_state:duel_confirmed(target)
	end
end

function PlayerUnitLocomotion:duel_denied(target)
	if type(self.current_state.duel_denied) == "function" then
		self.current_state:duel_denied(target)
	end
end

function PlayerUnitLocomotion:duel_ended(target)
	if type(self.current_state.duel_ended) == "function" then
		self.current_state:duel_ended(target)
	end
end

function PlayerUnitLocomotion:duel_started(target)
	if type(self.current_state.duel_started) == "function" then
		self.current_state:duel_started(target)
	end
end

function PlayerUnitLocomotion:perk_triggered(perk)
	if not self:has_perk(perk) then
		return
	end

	if perk == "stamina_on_kill" then
		self:set_perk_state("stamina_on_kill", "active")

		self.stamina.value = math.min(1, self.stamina.value + Perks.stamina_on_kill.stamina_back_on_kill)
	elseif perk == "heal_on_kill" then
		self:set_perk_state("heal_on_kill", "active")
		self.current_state:_play_voice("chr_vce_perk_bloodthirst_swing", true)

		local timpani_world = World.timpani_world(self.world)
		local event_id = TimpaniWorld.trigger_event(timpani_world, "perk_health_recharge")
	end
end

function PlayerUnitLocomotion:_trigger_abort_attack(reason)
	local network_manager = Managers.state.network

	if Managers.lobby.server then
		local player_unit_id = network_manager:unit_game_object_id(self.unit)

		self:abort_attack(reason)
	end
end

function PlayerUnitLocomotion:abort_attack(reason)
	self.current_state:_abort_swing(reason)
end

function PlayerUnitLocomotion:anim_event(event, force_local)
	local unit = self.unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	local event_id = NetworkLookup.anims[event]

	if not force_local and self._game and self._id then
		local network_manager = Managers.state.network

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_anim_event", event_id, self.id)
		else
			network_manager:send_rpc_server("rpc_anim_event", event_id, self.id)
		end
	end

	Unit.animation_event(unit, event)
end

function PlayerUnitLocomotion:rpc_animation_event(event)
	Unit.animation_event(self.unit, event)
end
