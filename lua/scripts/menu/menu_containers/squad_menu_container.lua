-- chunkname: @scripts/menu/menu_containers/squad_menu_container.lua

SquadMenuContainer = class(SquadMenuContainer, MenuContainer)

function SquadMenuContainer:init(config)
	SquadMenuContainer.super.init(self)

	self.config = config
	self._visible = true
end

function SquadMenuContainer:name()
	return self.config.name
end

function SquadMenuContainer:set_visibility(visible)
	self._visible = visible
end

function SquadMenuContainer:visible()
	return self._visible
end

function SquadMenuContainer:highlighted()
	return self._highlighted
end

function SquadMenuContainer:locked()
	return self._locked
end

function SquadMenuContainer:set_locked(locked)
	self._locked = locked
end

function SquadMenuContainer:on_select()
	if self.config.sounds.select then
		local timpani_world = World.timpani_world(self.config.world)

		TimpaniWorld.trigger_event(timpani_world, self.config.sounds.select)
	end
end

function SquadMenuContainer:page_data()
	return self.config.page_data
end

function SquadMenuContainer:render(dt, t, gui, layout_settings, render_from_child_page)
	if not self._current_texture and not self._available then
		return
	end
end

function SquadMenuContainer.create_from_config(config)
	return SquadMenuContainer:new(config)
end
