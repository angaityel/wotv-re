-- chunkname: @scripts/managers/transition/transition_manager.lua

TransitionManager = class(TransitionManager)

function TransitionManager:init()
	self:_setup_names()
	self:_setup_world()

	self._color = Vector3Box(0, 0, 0)
	self._fade_state = "out"
	self._fade = 0
end

function TransitionManager:_setup_names()
	self._world_name = "transition_world"
	self._viewport_name = "transition_viewport"
end

function TransitionManager:_setup_world()
	local world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, 990, Application.DISABLE_SOUND, Application.DISABLE_PHYSICS)

	self._world = world
	self._gui = World.create_screen_gui(world, "immediate")

	local viewport = ScriptWorld.create_viewport(world, self._viewport_name, "overlay", 990)
	local camera = ScriptViewport.camera(viewport)

	Camera.set_vertical_fov(camera, 3)

	self._version_tag_world = "version_tag_world"

	local world = Managers.world:create_world(self._version_tag_world, GameSettingsDevelopment.default_environment, nil, 1000, Application.DISABLE_SOUND, Application.DISABLE_PHYSICS)

	self._version_tag_world = world
	self._version_tag_gui = World.create_screen_gui(world, "material", "materials/menu/alpha", "immediate")

	local viewport = ScriptWorld.create_viewport(world, "version_tag_viewport", "overlay", 1000)
	local camera = ScriptViewport.camera(viewport)

	Camera.set_vertical_fov(camera, 3)
end

function TransitionManager:destroy()
	Managers.world:destroy_world(self._world_name)

	if self._version_tag_world then
		Managers.world:destroy_world(self._version_tag_world)
	end
end

function TransitionManager:fade_in(speed, callback)
	self._fade_state = "fade_in"
	self._fade_speed = speed
	self._callback = callback
end

function TransitionManager:fade_out(speed, callback)
	self._fade_state = "fade_out"
	self._fade_speed = -speed
	self._callback = callback
end

function TransitionManager:force_fade_in()
	self._fade_state = "in"
	self._fade_speed = 0
	self._fade = 1

	if self._callback then
		self._callback()

		self._callback = nil
	end
end

function TransitionManager:force_fade_out()
	self._fade_state = "out"
	self._fade_speed = 0
	self._fade = 0

	if self._callback then
		self._callback()

		self._callback = nil
	end
end

function TransitionManager:_render(dt)
	local w, h = Gui.resolution()
	local color = self._color:unbox()

	Gui.rect(self._gui, Vector3(0, 0, 0), Vector2(w, h), Color(self._fade * 255, color.x, color.y, color.z))
end

function TransitionManager:_handle_version_tag(dt)
	local w, h = Gui.resolution()
	local version_data = GameSettingsDevelopment.version_states[GameSettingsDevelopment.version_state]

	if version_data and version_data.tag then
		local tag_data = version_data.tag
		local material = tag_data.material
		local pos = Vector3(0 + tag_data.offset[1], h + tag_data.offset[2], tag_data.offset[3])
		local size = Vector2(tag_data.size[1], tag_data.size[2])

		Gui.bitmap(self._version_tag_gui, material, pos, size)
	end

	if version_data and version_data.version then
		local version_data = version_data.version
		local font = version_data.font
		local material = version_data.material
		local font_size = version_data.font_size
		local color = Color(version_data.color[1], version_data.color[2], version_data.color[3], version_data.color[4])
		local pos = Vector3(version_data.offset[1], h + version_data.offset[2], version_data.offset[3])
		local app_settings = Application.settings()
		local text = version_data.version or "version missing"
		local min, max = Gui.text_extents(self._version_tag_gui, text, font, font_size)
		local extents = {
			max[1] - min[1],
			max[3] - min[3]
		}
		local offset = Vector3(0, 0, 0)

		if version_data.align == "right" then
			offset = Vector3(-extents[1], 0, 0)
		end

		Gui.text(self._version_tag_gui, text, font, font_size, material, pos + offset, color)
	end
end

function TransitionManager:update(dt)
	self:_handle_version_tag(dt)

	if self._fade_state == "out" then
		return
	elseif self._fade_state == "in" then
		self:_render(dt)

		return
	end

	self._fade = self._fade + self._fade_speed * math.min(dt, 0.03333333333333333)

	if self._fade_state == "fade_in" and self._fade >= 1 then
		self._fade = 1
		self._fade_state = "in"

		if self._callback then
			self._callback()

			self._callback = nil
		end
	elseif self._fade_state == "fade_out" and self._fade <= 0 then
		self._fade = 0
		self._fade_state = "out"

		if self._callback then
			self._callback()

			self._callback = nil
		end

		return
	end

	self:_render(dt)
end
