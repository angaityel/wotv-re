-- chunkname: @scripts/managers/outline/outline_manager.lua

local function color_from_table(t)
	return Color(t[1], t[2], t[3], t[4])
end

OutlineManager = class(OutlineManager)

function OutlineManager:init(player)
	self._player = player
	self._squad_outlines = {}
	self._squad_flag_unit = nil
	self._tagged_outlines = {}
	self._team_outlines = {}
	self._enemy_outline_masks = {}
	self._projectiles = {}
	self._show_team_outlines = not Application.user_setting("hide_team_outlines")

	Managers.state.event:register(self, "projectiles_updated", "event_projectiles_updated")
end

local debug_print = GameSettingsDevelopment.debug_outlines and print or function()
	return
end

function OutlineManager:update(player)
	if not EDITOR_LAUNCH then
		self._show_team_outlines = not Application.user_setting("hide_team_outlines")

		Profiler.start("OutlineManager:update")
		Profiler.start("handle_squad_outlines")
		self:_handle_squad_outlines()
		Profiler.stop()
		Profiler.start("handle_team_outlines")
		self:_handle_team_outlines()
		Profiler.stop()
		Profiler.start("handle_tagged_outlines")
		self:_handle_tagged_outlines()
		Profiler.stop()
		Profiler.start("handle_outline_mask")
		self:_handle_outline_mask()
		Profiler.stop()
		Profiler.start("handle_enemies")
		self:_handle_enemies()
		Profiler.stop()
		Profiler.start("cleanup_dead_players")
		self:_cleanup_dead_players()
		Profiler.stop()
		Profiler.stop()
	end
end

function OutlineManager:event_projectiles_updated(player)
	local player_unit = player and player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local projectiles
	local num_projectiles = 0
	local linked_thrown_weapons = Unit.get_data(player_unit, "linked_throwing_weapons")

	if linked_thrown_weapons then
		projectiles = {}
		num_projectiles = #linked_thrown_weapons

		for i = 1, num_projectiles do
			projectiles[i] = linked_thrown_weapons[i]
		end
	end

	local linked_projectiles = Unit.get_data(player_unit, "linked_dummy_projectiles")

	if linked_projectiles then
		projectiles = projectiles or {}

		local num_linked_projectiles = #linked_projectiles

		for i = 1, num_linked_projectiles do
			projectiles[i + num_projectiles] = linked_projectiles[i]
		end

		num_projectiles = num_projectiles + num_linked_projectiles
	end

	self:_clear_projectile_outlines(player)

	if num_projectiles > 0 then
		local channel = Color(0, 0, 0, 0)

		self:_outline_projectiles(player, projectiles, num_projectiles, "outline_unit", channel)
	end
end

function OutlineManager:_clear_projectile_outlines(player)
	local projectile_outlines = self._projectiles[player]

	if not projectile_outlines then
		return
	end

	local Unit_alive = Unit.alive
	local projectiles = projectile_outlines.projectiles

	for i = 1, projectile_outlines.num_projectiles do
		local unit = projectiles[i]

		if Unit_alive(unit) then
			self:outline_unit(unit, projectile_outlines.flag, false)
		end
	end

	self._projectiles[player] = nil
end

function OutlineManager:_outline_projectiles(player, projectiles, num_projectiles, flag, channel)
	local Unit_alive = Unit.alive

	for i = 1, num_projectiles do
		local unit = projectiles[i]

		if Unit_alive(unit) then
			self:outline_unit(unit, flag, true, channel)
		end
	end

	self._projectiles[player] = {
		projectiles = projectiles,
		num_projectiles = num_projectiles,
		flag = flag
	}
end

function OutlineManager:_handle_squad_outlines()
	local Unit_alive = Unit.alive
	local ScriptUnit_has_extension, ScriptUnit_extension = ScriptUnit.has_extension, ScriptUnit.extension
	local local_player = self._player
	local squad_index = local_player.squad_index
	local self_squad_outlines, self_team_outlines = self._squad_outlines, self._team_outlines
	local channel = color_from_table(HUDSettings.outline_colors.squad_member.channel)
	local damage_ext = Unit_alive(local_player.player_unit) and ScriptUnit_extension(local_player.player_unit, "damage_system")

	if squad_index and damage_ext and not damage_ext:is_dead() and local_player.team and self._show_team_outlines then
		local squad = local_player.team.squads[squad_index]
		local members = squad:members()

		for member_player, _ in pairs(members) do
			if member_player ~= local_player and not self_squad_outlines[member_player] then
				local player_unit = member_player.player_unit
				local is_alive = Unit_alive(player_unit) and ScriptUnit_has_extension(player_unit, "damage_system") and not ScriptUnit_extension(player_unit, "damage_system"):is_dead()

				if is_alive then
					debug_print("adding outline :", member_player:name(), "squad")
					self:_outline_meshes(member_player, "outline_unit", channel, self_squad_outlines)

					self_team_outlines[member_player] = nil
				end
			end
		end

		local squad_flag_unit = squad:squad_flag_unit()

		if self._squad_flag_unit ~= squad_flag_unit and Unit_alive(squad_flag_unit) then
			self:outline_unit(squad_flag_unit, "outline_unit", true, channel)

			self._squad_flag_unit = squad_flag_unit
		end

		self:_cleanup_squad_outlines(squad)
	else
		for player, units in pairs(self_squad_outlines) do
			debug_print("removing:", player:name(), "squad")

			for _, unit in ipairs(units) do
				if Unit_alive(unit) then
					self:outline_unit(unit, "outline_unit", false)
				end
			end

			self_squad_outlines[player] = nil
		end

		local squad_flag_unit = self._squad_flag_unit

		if Unit_alive(squad_flag_unit) then
			self:outline_unit(squad_flag_unit, "outline_unit", false)
		end

		self._squad_flag_unit = nil
	end
end

function OutlineManager:_cleanup_squad_outlines(squad)
	local Unit_alive = Unit.alive
	local self_squad_outlines = self._squad_outlines

	for player, units in pairs(self_squad_outlines) do
		local squad_members = squad:members()

		if not squad_members[player] then
			for _, unit in ipairs(units) do
				if Unit_alive(unit) then
					self:outline_unit(unit, "outline_unit", false)
				end
			end

			self_squad_outlines[player] = nil
		end
	end
end

function OutlineManager:_cleanup_tagging_outlines()
	local Unit_alive = Unit.alive
	local self_tagged_outlines = self._tagged_outlines
	local self_player = self._player

	for tagged_player, units in pairs(self_tagged_outlines) do
		if not PlayerMechanicsHelper.player_unit_tagged(self_player, tagged_player.player_unit) then
			for _, unit in ipairs(units) do
				if Unit_alive(unit) then
					self:outline_unit(unit, "outline_unit", false)
				end
			end

			self_tagged_outlines[tagged_player] = nil
		end
	end
end

function OutlineManager:_cleanup_dead_players()
	self:_cleanup_table(self._team_outlines)
	self:_cleanup_table(self._squad_outlines)
	self:_cleanup_table(self._tagged_outlines)
end

local temp_cleanup_players_to_remove = {}

function OutlineManager:_cleanup_table(outline_table)
	local Unit_alive = Unit.alive
	local ScriptUnit_extension = ScriptUnit.extension
	local players_to_remove = temp_cleanup_players_to_remove
	local num_players_to_remove = 0

	for member, units in pairs(outline_table) do
		local player_unit = member.player_unit

		if Unit_alive(player_unit) then
			local damage_ext = ScriptUnit_extension(player_unit, "damage_system")

			if damage_ext:is_dead() then
				for _, unit in ipairs(units) do
					if Unit_alive(unit) then
						self:outline_unit(unit, "outline_unit", false)
					end
				end

				num_players_to_remove = num_players_to_remove + 1
				players_to_remove[num_players_to_remove] = member
			end
		else
			num_players_to_remove = num_players_to_remove + 1
			players_to_remove[num_players_to_remove] = member
		end
	end

	for i = 1, num_players_to_remove do
		local player = players_to_remove[i]

		outline_table[player] = nil
		players_to_remove[i] = nil
	end
end

function OutlineManager:_outline_meshes(player, flag, channel, outline_table)
	local Unit_alive = Unit.alive
	local player_unit = player.player_unit
	local locomotion_ext = ScriptUnit.extension(player_unit, "locomotion_system")
	local inventory = locomotion_ext:inventory()
	local player_outlines, num_player_outlines = {}, 0

	outline_table[player] = player_outlines

	local armour_unit = inventory:armour_unit()

	num_player_outlines = num_player_outlines + 1
	player_outlines[num_player_outlines] = armour_unit

	self:outline_unit(armour_unit, flag, true, channel)

	local head_unit = inventory:head()

	num_player_outlines = num_player_outlines + 1
	player_outlines[num_player_outlines] = head_unit

	self:outline_unit(head_unit, flag, true, channel)

	local helmet_unit = inventory:helmet_unit()

	num_player_outlines = num_player_outlines + 1
	player_outlines[num_player_outlines] = helmet_unit

	self:outline_unit(helmet_unit, flag, true, channel)

	local head_attachments = inventory:head_attachments()

	for _, attachment_unit in ipairs(head_attachments) do
		num_player_outlines = num_player_outlines + 1
		player_outlines[num_player_outlines] = attachment_unit

		self:outline_unit(attachment_unit, flag, true, channel)
	end

	local cloak_unit = inventory:cloak()

	if Unit_alive(cloak_unit) then
		num_player_outlines = num_player_outlines + 1
		player_outlines[num_player_outlines] = cloak_unit

		self:outline_unit(cloak_unit, flag, true, channel)
	end

	local weapon_slots = inventory:slots()

	for _, weapon_info in pairs(weapon_slots) do
		local gear = weapon_info.gear
		local gear_unit = gear and gear._unit

		if Unit_alive(gear_unit) then
			num_player_outlines = num_player_outlines + 1
			player_outlines[num_player_outlines] = gear_unit

			self:outline_unit(gear_unit, flag, true, channel)
		end
	end
end

function OutlineManager:_handle_tagged_outlines()
	local Unit_alive = Unit.alive
	local ScriptUnit_has_extension, ScriptUnit_extension = ScriptUnit.has_extension, ScriptUnit.extension
	local local_player = self._player
	local squad_index = local_player.squad_index
	local self_tagged_outlines = self._tagged_outlines
	local channel = color_from_table(HUDSettings.outline_colors.enemy.channel)
	local damage_ext = Unit_alive(local_player.player_unit) and ScriptUnit_extension(local_player.player_unit, "damage_system")

	if damage_ext and not damage_ext:is_dead() and local_player.team and self._show_team_outlines then
		local tagged_units = PlayerMechanicsHelper.squads_tagged_units(local_player)

		for tagged_unit, _ in pairs(tagged_units) do
			local tagged_unit_owner = Managers.player:owner(tagged_unit)

			if tagged_unit_owner and local_player ~= tagged_unit_owner and not self_tagged_outlines[tagged_unit_owner] then
				local tagged_unit_is_alive = Unit_alive(tagged_unit) and ScriptUnit_has_extension(tagged_unit, "locomotion_system") and ScriptUnit_has_extension(tagged_unit, "damage_system") and not ScriptUnit_extension(tagged_unit, "damage_system"):is_dead()

				if tagged_unit_is_alive then
					self:_outline_meshes(tagged_unit_owner, "outline_unit", channel, self_tagged_outlines)
				end
			end
		end

		self:_cleanup_tagging_outlines()
	else
		for player, units in pairs(self_tagged_outlines) do
			debug_print("removing:", local_player:name(), "tag")

			for _, unit in ipairs(units) do
				if Unit_alive(unit) then
					self:outline_unit(unit, "outline_unit", false)
				end
			end

			self_tagged_outlines[player] = nil
		end
	end
end

function OutlineManager:_handle_enemies()
	local local_player = self._player
	local player_team = local_player.team

	if not player_team then
		return
	end

	local enemy_team = Managers.state.team:opposite_team(player_team)

	if not enemy_team then
		return
	end

	local Unit_alive = Unit.alive
	local self_enemy_outline_masks = self._enemy_outline_masks
	local self_tagged_outlines = self._tagged_outlines
	local enemies = enemy_team.members
	local no_color = Color(0, 0, 0, 0)

	for _, enemy_member in pairs(enemies) do
		if not self_tagged_outlines[enemy_member] then
			local unit = enemy_member.player_unit

			if Unit_alive(unit) then
				if not self_enemy_outline_masks[enemy_member] then
					debug_print("adding:", enemy_member.name, "enemy")
					self:_outline_meshes(enemy_member, "outline_unit", no_color, self_enemy_outline_masks)
				end
			else
				self_enemy_outline_masks[enemy_member] = nil
			end
		else
			self_enemy_outline_masks[enemy_member] = nil
		end
	end
end

function OutlineManager:_handle_team_outlines()
	local Unit_alive = Unit.alive
	local ScriptUnit_has_extension, ScriptUnit_extension = ScriptUnit.has_extension, ScriptUnit.extension
	local local_player = self._player
	local squad_index = local_player.squad_index
	local self_team_outlines = self._team_outlines
	local self_squad_outlines = self._squad_outlines
	local channel = color_from_table(HUDSettings.outline_colors.team_member.channel)
	local damage_ext = Unit_alive(local_player.player_unit) and ScriptUnit_extension(local_player.player_unit, "damage_system")

	if damage_ext and not damage_ext:is_dead() and local_player.team and self._show_team_outlines then
		local members = local_player.team.members

		for _, team_member in pairs(members) do
			local member_squad_index = team_member.squad_index

			if (not member_squad_index or member_squad_index ~= squad_index) and team_member ~= local_player and not self_team_outlines[team_member] then
				local team_player_unit = team_member.player_unit
				local is_alive = Unit_alive(team_player_unit) and ScriptUnit_has_extension(team_player_unit, "damage_system") and not ScriptUnit_extension(team_player_unit, "damage_system"):is_dead()

				if is_alive then
					debug_print("adding:", team_member:name(), "team")
					self:_outline_meshes(team_member, "outline_unit_z", channel, self_team_outlines)

					self_squad_outlines[team_member] = nil
				end
			end
		end
	else
		for player, units in pairs(self_team_outlines) do
			for _, unit in ipairs(units) do
				if Unit_alive(unit) then
					self:outline_unit(unit, "outline_unit_z", false)
				end
			end

			self_team_outlines[player] = nil
		end
	end
end

local temp_disabled_meshes = {}

local function get_disabled_unit_meshes(unit)
	local Unit_get_data = Unit.get_data
	local disabled_meshes = temp_disabled_meshes
	local i = 0
	local mesh_name = Unit_get_data(unit, "outline", "disabled_meshes", i)

	while mesh_name do
		i = i + 1
		disabled_meshes[i] = mesh_name
		mesh_name = Unit_get_data(unit, "outline", "disabled_meshes", i)
	end

	return disabled_meshes, i
end

local function array_contains(array, array_size, element)
	for i = 1, array_size do
		if array[i] == element then
			return true
		end
	end

	return false
end

function OutlineManager:outline_unit(unit, flag, enable, color)
	local num_meshes = Unit.num_meshes(unit)
	local disabled_meshes, num_disabled_meshes = get_disabled_unit_meshes(unit)
	local Unit_mesh = Unit.mesh

	for i = 0, num_meshes - 1 do
		local mesh = Unit_mesh(unit, i)

		if not array_contains(disabled_meshes, num_disabled_meshes, mesh) then
			self:_outline_mesh(mesh, flag, enable, color)
		end
	end
end

function OutlineManager:_outline_mesh(mesh, flag, enable, color)
	Mesh.set_shader_pass_flag(mesh, flag, enable)

	local last_material_index = Mesh.num_materials(mesh) - 1
	local outline_color = enable and color or Color(0, 0, 0, 0)
	local Mesh_material, Material_set_color = Mesh.material, Material.set_color

	for material_index = 0, last_material_index do
		local material = Mesh_material(mesh, material_index)

		Material_set_color(material, "outline_color", outline_color)
	end
end

function OutlineManager:_handle_outline_mask()
	if Managers.lobby.lobby then
		local unit = self._player.player_unit

		if Unit.alive(unit) then
			self:_outline_meshes(self._player, "outline_unit", Color(0, 0, 0, 0), {})
		end
	end
end

function OutlineManager:destroy()
	return
end
