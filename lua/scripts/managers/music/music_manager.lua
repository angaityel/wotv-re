-- chunkname: @scripts/managers/music/music_manager.lua

require("scripts/settings/sound_ducking_settings")
require("foundation/scripts/util/sound_ducking/ducking_handler")

MusicManager = class(MusicManager)
MusicManager.bus_transition_functions = {
	linear = function(transition, t)
		return math.lerp(transition.start_value, transition.target_value, t)
	end,
	sine = function(transition, t)
		return math.lerp(transition.start_value, transition.target_value, math.sin(t * math.pi * 0.5))
	end,
	smoothstep = function(transition, t)
		return math.lerp(transition.start_value, transition.target_value, math.smoothstep(t, 0, 1))
	end
}

function MusicManager:init()
	self._world = Managers.world:create_world("music_world", nil, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_RENDERING)
	self._timpani_world = World.timpani_world(self._world)
	self._bus_transitions = {}
end

function MusicManager:stop_all_sounds()
	self._timpani_world:stop_all()
end

function MusicManager:trigger_event(event_name)
	local timpani_world = self._timpani_world
	local event_id = TimpaniWorld.trigger_event(timpani_world, event_name)
	local player_manager = Managers.player
	local player = player_manager:player_exists(1) and player_manager:player(1)
	local team = player and player.team

	if team then
		self:set_parameter(event_id, "team", team.name)
	end

	return event_id
end

function MusicManager:set_parameter(id, variable, value)
	TimpaniWorld.set_parameter(self._timpani_world, id, variable, value)
end

function MusicManager:update(dt, t)
	self:_update_bus_transitions()
end

function MusicManager:_update_bus_transitions()
	local t = Managers.time:time("main")

	for bus, transition in pairs(self._bus_transitions) do
		local value

		if t > transition.start_time + transition.duration then
			self._bus_transitions[bus] = nil
			value = transition.target_value
		else
			value = transition.transition_function(transition, (t - transition.start_time) / transition.duration)
		end

		Timpani.set_bus_volume(bus, value)
	end
end

function MusicManager:start_bus_transition(bus_name, target_value, duration, transition_type, from_value)
	self._bus_transitions[bus_name] = {
		start_value = from_value,
		target_value = target_value,
		duration = duration,
		start_time = Managers.time:time("main"),
		transition_function = MusicManager.bus_transition_functions[transition_type]
	}
end
