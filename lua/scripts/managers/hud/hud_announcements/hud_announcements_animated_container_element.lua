-- chunkname: @scripts/managers/hud/hud_announcements/hud_announcements_animated_container_element.lua

HUDAnnouncementsAnimatedContainerElement = class(HUDAnnouncementsAnimatedContainerElement, HUDContainerElement)

function HUDAnnouncementsAnimatedContainerElement:init(config)
	HUDAnnouncementsAnimatedContainerElement.super.init(self, config)

	self._world = config.world
	self._t = 0
	self._running_particles = {}
	self._sound_history = {}
	self._particle_history = {}

	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)

	for name, func in pairs(layout_settings.animations) do
		self[name] = func(0)
	end
end

function HUDAnnouncementsAnimatedContainerElement:update_size(dt, t, gui, layout_settings)
	self:_update(dt, t, layout_settings)
	HUDAnnouncementsAnimatedContainerElement.super.update_size(self, dt, t, gui, layout_settings)
end

function HUDAnnouncementsAnimatedContainerElement:update_position(dt, t, layout_settings, x, y, z)
	HUDAnnouncementsAnimatedContainerElement.super.update_position(self, dt, t, layout_settings, x, y, z)
	self:_calculate_elements_extents()
end

function HUDAnnouncementsAnimatedContainerElement:render(dt, t, gui, layout_settings)
	HUDAnnouncementsAnimatedContainerElement.super.render(self, dt, t, gui, layout_settings)
	self:_render_mask(dt, t, gui, layout_settings)
end

function HUDAnnouncementsAnimatedContainerElement:_update(dt, t, layout_settings)
	self._t = self._t + dt

	for name, func in pairs(layout_settings.animations) do
		self[name] = func(math.clamp(self._t / layout_settings.anim_length, 0, 1))
	end

	self:_update_sound_events(dt, t, layout_settings)
	self:_update_particles(dt, t, layout_settings)
end

function HUDAnnouncementsAnimatedContainerElement:_update_sound_events(dt, t, layout_settings)
	local time = math.clamp(self._t / layout_settings.anim_length, 0, 1)

	for id, sound in ipairs(self.config.sound_events) do
		if time >= sound.start_time and not self._sound_history[id] then
			self:_start_sound(sound, id)
		end
	end
end

function HUDAnnouncementsAnimatedContainerElement:_update_particles(dt, t, layout_settings)
	local time = math.clamp(self._t / layout_settings.anim_length, 0, 1)

	for i = #self._running_particles, 1, -1 do
		local particle = self._running_particles[i]

		if time >= particle.stop_time then
			self:_stop_particle(particle)
			table.remove(self._running_particles, i)
		end
	end

	for id, particle in ipairs(layout_settings.particle_effects) do
		if time >= particle.start_time and not self._particle_history[id] then
			self:_start_particle(particle, id)
		end
	end
end

function HUDAnnouncementsAnimatedContainerElement:_start_sound(sound, id)
	local timpani_world = World.timpani_world(self._world)
	local event_id = TimpaniWorld.trigger_event(timpani_world, sound.event)
	local parameters = sound.parameters
	local num_parameters = #parameters

	for i = 1, num_parameters, 2 do
		local key = parameters[i]
		local value = parameters[i + 1]

		TimpaniWorld.set_parameter(timpani_world, event_id, key, value)
	end

	self._sound_history[id] = true
end

function HUDAnnouncementsAnimatedContainerElement:_start_particle(particle, id)
	local position = Vector3(particle.position_x, particle.position_z, particle.position_y)
	local particle_id = World.create_particles(self._world, particle.effect, position)

	self._particle_history[id] = true

	if particle.stop_time then
		self._running_particles[#self._running_particles + 1] = {
			id = particle_id,
			stop_time = particle.stop_time
		}
	end
end

function HUDAnnouncementsAnimatedContainerElement:_stop_particle(particle)
	World.stop_spawning_particles(self._world, particle.id)
end

function HUDAnnouncementsAnimatedContainerElement:_calculate_elements_extents()
	local min_x, max_x = math.huge, 0
	local min_y, max_y = math.huge, 0

	for id, element in pairs(self._elements) do
		local width = element:width()
		local height = element:height()
		local x1 = element:x()
		local y1 = element:y()
		local x2 = x1 + width
		local y2 = y1 + height

		min_x = x1 < min_x and x1 or min_x
		max_x = max_x < x2 and x2 or max_x
		min_y = y1 < min_y and y1 or min_y
		max_y = max_y < y2 and y2 or max_y
	end

	self._elements_x = min_x
	self._elements_y = min_y
	self._elements_width = max_x - min_x
	self._elements_height = max_y - min_y
end

function HUDAnnouncementsAnimatedContainerElement:_render_mask(dt, t, gui, layout_settings)
	if layout_settings.masked then
		local pos = Vector3(self._elements_x + (self.mask_offset_x * self._elements_width or 0), self._elements_y + (self.mask_offset_y or 0) - 2, self._z)
		local size = Vector2(self._elements_width, self._elements_height)
		local color = Color(255, 255, 255, 255)

		Gui.bitmap(gui, "mask_rect_alpha", pos, size, color)
	end
end

function HUDAnnouncementsAnimatedContainerElement:destroy()
	for i, particle in ipairs(self._running_particles) do
		self:_stop_particle(particle)
	end

	for id, element in pairs(self._elements) do
		if element.destroy then
			element:destroy()
		end
	end
end

function HUDAnnouncementsAnimatedContainerElement.create_from_config(config)
	local config = {
		world = config.world,
		layout_settings = config.layout_settings,
		sound_events = config.sound_events
	}

	return HUDAnnouncementsAnimatedContainerElement:new(config)
end
