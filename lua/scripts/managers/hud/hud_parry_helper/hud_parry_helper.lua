-- chunkname: @scripts/managers/hud/hud_parry_helper/hud_parry_helper.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/hud_parry_helper/hud_parry_helper_element")
require("scripts/managers/hud/hud_parry_helper/hud_parry_element")
require("scripts/hud/hud_assets")

HUDParryHelper = class(HUDParryHelper, HUDBase)

function HUDParryHelper:init(world, player)
	HUDParryHelper.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "immediate")

	self:_setup_parry_helper()

	self._active = false

	Managers.state.event:register(self, "event_parry_helper_activated", "event_parry_helper_activated", "event_parry_helper_deactivated", "event_parry_helper_deactivated")
end

function HUDParryHelper:_setup_parry_helper()
	self._parry_helper_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.parry_helper.container
	})

	local pose_top_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.attack_top
	}

	self._parry_helper_container:add_element("attack_up", HUDParryElement.create_from_config(pose_top_config))

	local pose_left_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.attack_left
	}

	self._parry_helper_container:add_element("attack_right", HUDParryElement.create_from_config(pose_left_config))

	local pose_right_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.attack_right
	}

	self._parry_helper_container:add_element("attack_left", HUDParryElement.create_from_config(pose_right_config))

	local pose_top_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.parry_top
	}

	self._parry_helper_container:add_element("parry_up", HUDParryElement.create_from_config(pose_top_config))

	local pose_left_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.parry_left
	}

	self._parry_helper_container:add_element("parry_right", HUDParryElement.create_from_config(pose_left_config))

	local pose_right_config = {
		alpha_multiplier = 1,
		z = 10,
		layout_settings = HUDSettings.pose_charge.parry_right
	}

	self._parry_helper_container:add_element("parry_left", HUDParryElement.create_from_config(pose_right_config))
end

function HUDParryHelper:event_parry_helper_activated(player, blackboard)
	if not HUDSettings.show_parry_helper then
		return
	end

	if player == self._player then
		self._active = true
		self._blackboard = blackboard

		local elements = self._parry_helper_container:elements()

		for id, element in pairs(elements) do
			element.config.blackboard = blackboard
			element.config.name = id
		end
	end
end

function HUDParryHelper:event_parry_helper_deactivated(player)
	if player == self._player then
		self._active = false

		local elements = self._parry_helper_container:elements()

		for id, element in pairs(elements) do
			element.config.blackboard = nil
		end
	end
end

function HUDParryHelper:post_update(dt, t)
	local layout_settings = HUDHelper:layout_settings(self._parry_helper_container.config.layout_settings)
	local gui = self._gui

	if self._active then
		self._parry_helper_container:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._parry_helper_container, layout_settings)

		self._parry_helper_container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._parry_helper_container:render(dt, t, gui, layout_settings)
	end
end

function HUDParryHelper:destroy()
	World.destroy_gui(self._world, self._gui)
end
