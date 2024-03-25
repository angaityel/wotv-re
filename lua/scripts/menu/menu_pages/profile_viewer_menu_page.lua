-- chunkname: @scripts/menu/menu_pages/profile_viewer_menu_page.lua

require("scripts/menu/menus/menu")
require("scripts/menu/menu_controller_settings/profile_viewer_menu_controller_settings")
require("scripts/menu/menu_definitions/profile_viewer_menu_settings_1920")
require("scripts/menu/menu_definitions/profile_viewer_menu_settings_1366")
require("scripts/menu/menu_definitions/profile_viewer_menu_definition")
require("scripts/menu/menu_callbacks/profile_viewer_menu_callbacks")
require("scripts/menu/menu_containers/free_layout_menu_container")

ProfileViewerMenuPage = class(ProfileViewerMenuPage, MenuPage)

function ProfileViewerMenuPage:init(config, item_groups, world)
	ProfileViewerMenuPage.super.init(self, config, item_groups, world)
	Managers.state.event:register(self, "profile_viewer_activate", "event_profile_viewer_activate", "profile_viewer_deactivate", "event_profile_viewer_deactivate")

	self._containers = {
		non_cosmetic = {
			container = FreeLayoutMenuContainer.create_from_config(item_groups.non_cosmetic),
			position_function = self._left_side_container_position
		}
	}
	self._container_states = {
		state_1 = {
			"non_cosmetic"
		}
	}
	self._container_status = {}

	for container_name, container_data in pairs(self._containers) do
		fassert(self._container_status[container_name] == nil, "Two or more containers share names: %s", container_name)

		self._container_status[container_name] = false
	end
end

function ProfileViewerMenuPage:event_profile_viewer_activate()
	if not self._current_state then
		self._next_state = "state_1"
	end
end

function ProfileViewerMenuPage:event_profile_viewer_deactivate()
	return
end

function ProfileViewerMenuPage:update(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local z = self.config.z
	local gui = self._gui

	self:_update_state(dt, t)

	for container_name, container_data in pairs(self._containers) do
		if self:_container_active(container_name) and container_data.visible_function and container_data.visible_function(self, t) then
			local container = container_data.container
			local container_layout_settings = layout_settings[container_name]

			container:update_size(dt, t, gui, container_layout_settings)

			local x, y = container_data.position_function(self, container_name, container, container_layout_settings, dt, t)

			container:update_position(dt, t, container_layout_settings, x, y, z + (container_layout_settings.z or 0))
			container:render(dt, t, gui, container_layout_settings)
		end
	end
end

function ProfileViewerMenuPage:_update_state(dt, t)
	if self._next_state then
		if self._current_state == nil then
			self:_activate_state(self._next_state)
		elseif self._next_state == self._current_state.name then
			self:_deactivate_current_state()
		else
			self:_deactivate_current_state(self._next_state)
		end
	end
end

function ProfileViewerMenuPage:_activate_state(new_state)
	self._current_state = {
		name = new_state,
		start_time = Managers.time:time("game")
	}

	for _, container_name in ipairs(self._container_states[new_state]) do
		self._container_status[container_name] = true
	end
end

function ProfileViewerMenuPage:_deactivate_current_state(new_state)
	return
end

function ProfileViewerMenuPage:_container_active(container_name)
	return self._container_status[container_name]
end

function ProfileViewerMenuPage:_update_input(input)
	ProfileViewerMenuPage.super._update_input(self, input)

	if not input then
		return
	end

	if input:get("state_1") then
		self._next_state = "state_1"
	end
end

function ProfileViewerMenuPage:render(dt, t)
	return
end

function ProfileViewerMenuPage:_left_side_container_position(container_name, container, container_layout_settings, dt, t)
	local current_state = self._current_state
	local start_time = current_state.start_time
	local time = t - start_time
end

function ProfileViewerMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "profile_viewer",
		parent_page = parent_page,
		callback_object = callback_object,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		local_player = compiler_data.menu_data.local_player,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return ProfileViewerMenuPage:new(config, item_groups, compiler_data.world)
end
