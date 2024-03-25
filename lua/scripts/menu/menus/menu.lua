-- chunkname: @scripts/menu/menus/menu.lua

require("scripts/menu/menu_compiler")
require("scripts/menu/menu_logic")

Menu = class(Menu)

function Menu:init(state, world, controller_settings, menu_settings, menu_definition, menu_callbacks, menu_data)
	self._world = world
	self._menu_settings = menu_settings

	self:_create_gui(menu_data.gui_init_parameters)
	World.set_data(self._world, "menu_gui", self._gui)

	local menu_callbacks = menu_callbacks:new(state)
	local compiler_data = {
		callback_object = menu_callbacks,
		world = world,
		menu_data = menu_data
	}
	local compiler = MenuCompiler:new(compiler_data)
	local compiled_menu_definition, menu_shortcuts = compiler:compile(menu_definition)
	local on_enter_page_callback = callback(self, "cb_on_enter_page")

	self._menu_logic = MenuLogic:new(compiled_menu_definition, menu_shortcuts, world, on_enter_page_callback)
	self._input_source = Managers.input:map_slot(1, controller_settings, nil)
	self._active = false

	self:_try_play_music_events("on_menu_init")
end

function Menu:_create_gui(params)
	self._gui = World.create_screen_gui(self._world, unpack(params))
end

function Menu:update(dt, t)
	if self._active then
		self._menu_logic:update(dt, t, self._input_source)
	end
end

function Menu:goto(id)
	self._menu_logic:goto(id)
end

function Menu:current_page()
	return self._menu_logic:current_page()
end

function Menu:current_page_type()
	return self._menu_logic:current_page_type()
end

function Menu:current_parent_page_type()
	return self._menu_logic:current_parent_page_type()
end

function Menu:cancel_to(page_id)
	self._menu_logic:cancel_to(page_id)
end

function Menu:active()
	return self._active
end

function Menu:set_active(active)
	self._active = active

	if active then
		self._menu_logic:menu_activated()
		self:_try_play_music_events("on_menu_activate")
	else
		self._menu_logic:menu_deactivated()
		self:_try_play_music_events("on_menu_deactivate")
	end
end

function Menu:current_page_is_root()
	return self._menu_logic:current_page_is_root()
end

function Menu:_try_play_music_events(menu_event)
	local music_events = self._menu_settings.music_events

	if music_events and music_events[menu_event] then
		for i, music_event in ipairs(music_events[menu_event]) do
			Managers.music:trigger_event(music_event)
		end
	end
end

function Menu:cb_on_enter_page(page)
	return
end

function Menu:destroy()
	Managers.input:unmap_input_source(self._input_source)
	self._menu_logic:destroy()

	self._menu_logic = nil

	self:_try_play_music_events("on_menu_destroy")
end
