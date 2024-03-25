-- chunkname: @scripts/unit_extensions/generic/perlin_light.lua

require("scripts/settings/perlin_light_configurations")

PerlinLight = class(PerlinLight)
PerlinLight.SYSTEM = "props_system"

function PerlinLight:init(world, unit)
	self._world = world
	self._unit = unit
	self._flicker_config_name = Unit.get_data(unit, "flicker_config")
	self._node = Unit.has_data(unit, "perlin_light_node_name") and Unit.node(unit, Unit.get_data(unit, "perlin_light_node_name")) or 0
	self._light = Unit.light(unit, 0)
	self._color = Vector3Box(Light.color(self._light))
	self._start_pos = Vector3Box(Unit.local_position(unit, self._node))
end

local PerlinLightCache = {}

function PerlinLight:update(unit, input, dt, context, t)
	local config_name = self._flicker_config_name
	local light_cache = PerlinLightCache[config_name]

	if not light_cache then
		light_cache = {
			t = -1,
			seed_flicker = Math.random(),
			seed_x = Math.random(),
			seed_y = Math.random()
		}
		PerlinLightCache[config_name] = light_cache
	end

	if light_cache.t ~= t then
		light_cache.t = t

		local config = PerlinLightConfigurations[config_name]
		local perlin_value = self:_calculate_perlin_value(t * config.frequency_multiplier, config.persistance, config.octaves, light_cache.seed_flicker)

		perlin_value = perlin_value * 0.5 + 0.5

		local min_value = config.min_value

		light_cache.light_value = perlin_value * (1 - min_value) + min_value

		if config.translation then
			local perlin_value_x = self:_calculate_perlin_value(t * config.translation.frequency_multiplier, config.translation.persistance, config.translation.octaves, light_cache.seed_x)
			local perlin_value_y = self:_calculate_perlin_value(t * config.translation.frequency_multiplier, config.translation.persistance, config.translation.octaves, light_cache.seed_y)

			light_cache.offset_vector = Vector3(perlin_value_x * 0.1, perlin_value_y * 0.1, 0)
		end
	end

	Light.set_color(self._light, self._color:unbox() * light_cache.light_value)

	local offset_vector = light_cache.offset_vector

	if offset_vector then
		Unit.set_local_position(self._unit, self._node, self._start_pos:unbox() + offset_vector)
	end
end

function PerlinLight:destroy()
	return
end

function PerlinLight:_calculate_perlin_value(x, persistance, number_of_octaves, seed)
	local total = 0
	local max_value = 0

	for i = 0, number_of_octaves do
		local frequency = 2^i
		local amplitude = persistance^i

		total = total + self:_interpolated_noise(x * frequency, seed) * amplitude
		max_value = max_value + amplitude
	end

	local normalized_total = total / max_value

	return normalized_total
end

function PerlinLight:_interpolated_noise(x, seed)
	local x_floored = math.floor(x)
	local remainder = x - x_floored
	local v1 = self:_smoothed_noise(x_floored, seed)
	local v2 = self:_smoothed_noise(x_floored + 1, seed)

	return math.lerp(v1, v2, remainder)
end

function PerlinLight:_smoothed_noise(x, seed)
	return self:_noise(x, seed) / 2 + self:_noise(x - 1, seed) / 4 + self:_noise(x + 1, seed) / 4
end

function PerlinLight:_noise(x, seed)
	local next_seed, _ = Math.next_random(x * seed)
	local _, value = Math.next_random(next_seed)

	return value * 2 - 1
end
