-- chunkname: @scripts/managers/hud/hud_chat/hud_chat.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_text_input_element")

HUDChat = class(HUDChat, HUDBase)

function HUDChat:init(world, player, data)
	HUDChat.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", MenuSettings.font_group_materials.arial, "material", "materials/fonts/hell_shark_font", "immediate")
	self._enabled = false
	self._hud_data = data

	self:_setup_chat(self._hud_data)
	Managers.state.event:register(self, "event_chat_initiated", "event_chat_initiated")
	Managers.state.event:register(self, "event_chat_input_activated", "event_chat_input_activated")
	Managers.state.event:register(self, "event_chat_input_deactivated", "event_chat_input_deactivated")
end

function HUDChat:_setup_chat(data)
	self._chat_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.chat.container
	})
end

function HUDChat:event_chat_initiated(blackboard)
	local input_text_config = {
		text = "",
		blackboard = blackboard,
		layout_settings = self._hud_data.input_text_layout_settings
	}

	self._chat_container:add_element("text_input", HUDTextInputElement.create_from_config(input_text_config))
end

function HUDChat:event_chat_input_activated()
	self:set_enabled(true)
end

function HUDChat:event_chat_input_deactivated()
	self:set_enabled(false)
end

function HUDChat:hud_manager_inactive_post_update(dt, t)
	self:post_update(dt, t)
end

function HUDChat:post_update(dt, t)
	local layout_settings = HUDHelper:layout_settings(self._chat_container.config.layout_settings)
	local gui = self._gui

	self._chat_container:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self._chat_container, layout_settings)

	self._chat_container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
	self._chat_container:render(dt, t, gui, layout_settings)
end

function HUDChat:destroy()
	World.destroy_gui(self._world, self._gui)
end
