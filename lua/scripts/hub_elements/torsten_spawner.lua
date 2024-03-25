-- chunkname: @scripts/hub_elements/torsten_spawner.lua

TorstenSpawner = class(TorstenSpawner, AISpawner)
TorstenSpawner.SYSTEM = "spawner_system"

function TorstenSpawner:init(world, unit)
	TorstenSpawner.super.init(self, world, unit)
	Managers.state.event:register(self, "ai_unit_died", "event_ai_unit_died", "player_hit_by_damaging_source", "event_player_hit_by_damaging_source", "player_blocked", "event_player_blocked", "player_parried", "event_player_parried")
end

function TorstenSpawner:update(unit, input, dt, context, t)
	TorstenSpawner.super.update(self, unit, input, dt, context, t)
end

function TorstenSpawner:set_ai_vulnerable()
	TorstenSpawner.super.set_ai_vulnerable(self)

	for unit, _ in pairs(self._spawned_units) do
		local damage = ScriptUnit.extension(unit, "damage_system")

		damage:set_max_health(1)
	end
end

function TorstenSpawner:event_player_parried(hit_gear_unit, gear_unit)
	local attacker = Unit.get_data(gear_unit, "user_unit")
	local blocker = Unit.get_data(hit_gear_unit, "user_unit")

	for unit, _ in pairs(self._spawned_units) do
		if unit == attacker then
			Unit.flow_event(self._unit, "lua_player_parried_torsten")
		elseif unit == blocker then
			Unit.flow_event(self._unit, "lua_player_parried_by_torsten")
		end
	end
end

function TorstenSpawner:event_player_blocked(hit_gear_unit, gear_unit)
	local attacker = Unit.get_data(gear_unit, "user_unit")
	local blocker = Unit.get_data(hit_gear_unit, "user_unit")

	for unit, _ in pairs(self._spawned_units) do
		if unit == blocker then
			Unit.flow_event(self._unit, "lua_player_blocked_by_torsten")
		end
	end
end

function TorstenSpawner:event_player_hit_by_damaging_source(victim, attacker, attack_name)
	local victim_unit = victim.player_unit
	local attacker_unit = attacker.player_unit

	for unit, _ in pairs(self._spawned_units) do
		if unit == victim_unit then
			if attack_name == "special" then
				Unit.flow_event(self._unit, "lua_player_special_attacked_torsten")
			else
				Unit.flow_event(self._unit, "lua_player_hit_torsten")

				if attack_name == "left" then
					Unit.flow_event(self._unit, "lua_player_hit_torsten_left")
				elseif attack_name == "right" then
					Unit.flow_event(self._unit, "lua_player_hit_torsten_right")
				elseif attack_name == "up" then
					Unit.flow_event(self._unit, "lua_player_hit_torsten_up")
				end
			end
		elseif unit == attacker_unit then
			Unit.flow_event(self._unit, "lua_player_hit_by_torsten")
		end
	end
end

function TorstenSpawner:event_ai_unit_died(victim_unit, attacker)
	for unit, _ in pairs(self._spawned_units) do
		if unit == victim_unit then
			Unit.flow_event(self._unit, "lua_player_killed_torsten")
		end
	end
end
