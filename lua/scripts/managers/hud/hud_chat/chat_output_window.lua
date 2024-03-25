-- chunkname: @scripts/managers/hud/hud_chat/chat_output_window.lua

require("scripts/settings/hud_settings")
require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_text_input_element")

ChatOutputWindow = class(ChatOutputWindow)

local function smoothstep(a, b, t)
	local c = math.max(0, math.min(t, 1))

	return a + c * c * (3 - 2 * c) * (b - a)
end

function ChatOutputWindow:init(world, player, hud_data)
	self:_setup_variables(hud_data)
	self:_setup_gui(world)

	self._world = world

	if hud_data.register_events then
		self:_register_events()
	end
end

function ChatOutputWindow:set_text_data(text_data)
	self._texts = text_data and text_data.texts or {}
	self._total_extents = text_data and text_data.text_extents or 0
end

function ChatOutputWindow:_setup_variables(hud_data)
	local text_data = hud_data and hud_data.text_data
	local input_source = hud_data and hud_data.input_source

	self._hud_data = hud_data
	self._layout_settings = hud_data.output_window_layout_settings
	self._flood_control = {}
	self._texts = text_data and text_data.texts or {}
	self._active = false
	self._shutdown_light = false
	self._scroll_offset = 0
	self._scroll_value = 0
	self._total_extents = text_data and text_data.text_extents or 0
	self._input_source = input_source
	self._elements = {}
	self._width = nil
	self._height = nil
end

function ChatOutputWindow:_setup_gui(world)
	self._gui = World.create_screen_gui(world, "material", "materials/menu/menu", "material", "materials/fonts/arial", "material", "materials/hud/buttons", "material", "materials/fonts/hell_shark_font", "immediate")
end

function ChatOutputWindow:_register_events()
	Managers.state.event:register(self, "event_chat_initiated", "event_chat_initiated")
	Managers.state.event:register(self, "event_chat_input_activated", "event_chat_activated")
	Managers.state.event:register(self, "event_chat_input_deactivated", "event_chat_deactivated")
	Managers.state.event:register(self, "event_chat_message", "event_chat_message")
	Managers.state.event:register(self, "event_admin_chat_message", "event_admin_chat_message")
	Managers.state.event:register(self, "event_rcon_chat_message", "event_rcon_chat_message")
end

function ChatOutputWindow:event_chat_initiated(blackboard)
	local input_text_config = {
		text = "",
		blackboard = blackboard,
		layout_settings = self._hud_data.input_text_layout_settings
	}

	self:add_element("text_input", HUDTextInputElement.create_from_config(input_text_config))
end

function ChatOutputWindow:event_chat_activated()
	Window.set_show_cursor(true)

	self._active = true
end

function ChatOutputWindow:event_chat_deactivated(shutdown_light)
	Window.set_show_cursor(false)

	self._active = false
	self._shutdown_light = shutdown_light
end

function ChatOutputWindow:hud_manager_inactive_post_update(dt, t, player)
	self:post_update(dt, t, player)
end

function ChatOutputWindow:width()
	return self._width
end

function ChatOutputWindow:height()
	return self._height
end

function ChatOutputWindow:post_update(dt, t, player)
	self:_render_mask(dt)
	self:_update_scroll_input(player)

	local layout_settings = HUDHelper:layout_settings(self._layout_settings)

	self:_handle_elements(dt, t)
	self:_update_scroll(layout_settings, dt)
	self:_render_scroller(layout_settings, dt, t)
	self:_render_texts(layout_settings, dt, t)
	self:_render_window(layout_settings, dt, t)
end

function ChatOutputWindow:_handle_elements(dt, t)
	if not self._active then
		return
	end

	local layout_settings = HUDHelper:layout_settings(self._layout_settings)

	self:_update_elements_size(dt, t, self._gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self, layout_settings)

	self:_update_elements_position(dt, t, layout_settings, x, y, layout_settings.z)
	self:_render_elements(dt, t, self._gui, layout_settings)
end

function ChatOutputWindow:add_element(id, element)
	self._elements[id] = element
end

function ChatOutputWindow:_update_elements_size(dt, t, gui, layout_settings)
	local res_width, res_height = Gui.resolution()

	self._width = layout_settings.width or res_width
	self._height = layout_settings.height or res_height

	for id, element in pairs(self._elements) do
		element:update_size(dt, t, gui, HUDHelper:layout_settings(element.config.layout_settings))
	end
end

function ChatOutputWindow:_update_elements_position(dt, t, layout_settings, x, y, z)
	self._x = x
	self._y = y
	self._z = z

	for id, element in pairs(self._elements) do
		local element_layout_settings = HUDHelper:layout_settings(element.config.layout_settings)
		local offset_x, offset_y = HUDHelper:element_position(self, element, element_layout_settings)
		local element_x = offset_x + x
		local element_y = offset_y + y
		local element_z = (element.config.z or 1) + z

		element:update_position(dt, t, element_layout_settings, element_x, element_y, element_z)
	end
end

function ChatOutputWindow:_update_scroll(layout_settings, dt)
	if self._active then
		if self._scroll_value >= 0 then
			self._scroll_value = math.max(self._scroll_value - math.sign(self._scroll_value) * dt * 4, 0)
		else
			self._scroll_value = math.min(self._scroll_value - math.sign(self._scroll_value) * dt * 4, 0)
		end

		self._scroll_offset = math.clamp(self._scroll_offset + self._scroll_value * layout_settings.text_scroller.scroll_speed * dt, 0, math.max(self._total_extents - layout_settings.inner_window.height, 0))
	else
		self._scroll_offset = 0
	end
end

function ChatOutputWindow:_render_mask(dt, t)
	local w, h = Gui.resolution()

	Gui.bitmap(self._gui, "mask_rect_alpha", Vector3(0, 0, 0), Vector2(w, h), Color(0, 0, 0, 0))
end

function ChatOutputWindow:_update_scroll_input(player, dt)
	if self._active then
		local input_source = self._input_source or player.input_source

		if input_source:has("mouse_scroll") then
			self._scroll_value = math.abs(input_source:get("mouse_scroll").y) > 0 and input_source:get("mouse_scroll").y or self._scroll_value or 0
		else
			self._scroll_value = 0
		end
	else
		self._scroll_value = 0
	end
end

function ChatOutputWindow:_render_scroller(layout_settings, dt, t)
	if not self._active then
		return
	end

	local x, y, z = HUDHelper:element_position(nil, self, layout_settings)
	local text_input_element = self._elements.text_input
	local base_width = text_input_element:base_width()
	local frame_width = text_input_element:frame_width()
	local frame_diff = frame_width - base_width

	if self._total_extents > layout_settings.inner_window.height then
		local percentage = self._scroll_offset / (self._total_extents - layout_settings.inner_window.height)
		local max_size = layout_settings.inner_window.height - layout_settings.inner_window.offset_y * 2
		local scroller_size = math.clamp(max_size * layout_settings.inner_window.height / self._total_extents, layout_settings.text_scroller.min_size, max_size)

		x = x + layout_settings.inner_window.width - layout_settings.text_scroller.width + layout_settings.text_scroller.offset_x + frame_diff
		y = y + layout_settings.inner_window.offset_y + layout_settings.text_scroller.offset_y
		y = y + (layout_settings.inner_window.height - scroller_size - layout_settings.text_scroller.offset_y * 2) * percentage

		Gui.rect(self._gui, Vector3(x, y, layout_settings.text_scroller.z), Vector2(layout_settings.text_scroller.width, scroller_size), MenuHelper:color(layout_settings.text_scroller.color))
		MenuHelper:render_border(self._gui, {
			x,
			y,
			layout_settings.text_scroller.width,
			scroller_size
		}, layout_settings.text_scroller.border_thickness, MenuHelper:color(layout_settings.text_scroller.border_color))
	end
end

function ChatOutputWindow:_render_window(layout_settings, dt)
	local x, y, z = HUDHelper:element_position(nil, self, layout_settings)

	if self._active then
		local text_input_element = self._elements.text_input
		local base_width = text_input_element:base_width()
		local frame_width = text_input_element:frame_width()
		local frame_diff = frame_width - base_width

		if layout_settings.outer_window then
			local start_x = x
			local start_y = y

			if text_input_element then
				start_x = x + text_input_element:frame_width() * 0.5 - (layout_settings.outer_window.width + frame_diff) * 0.5 + layout_settings.outer_window.offset_x
				start_y = y + layout_settings.outer_window.offset_y
			end

			Gui.rect(self._gui, Vector3(start_x, start_y, layout_settings.outer_window.z), Vector2(layout_settings.outer_window.width + frame_diff, layout_settings.outer_window.height), MenuHelper:color(layout_settings.outer_window.color))
			MenuHelper:render_border(self._gui, {
				start_x,
				start_y,
				layout_settings.outer_window.width + frame_diff,
				layout_settings.outer_window.height
			}, layout_settings.outer_window.border_thickness, MenuHelper:color(layout_settings.outer_window.border_color))
		end

		if layout_settings.inner_window then
			local start_x = x + layout_settings.inner_window.offset_x
			local start_y = y + layout_settings.inner_window.offset_y
			local pos = Vector3(start_x, start_y, layout_settings.inner_window.z)
			local size = Vector2(layout_settings.inner_window.width + frame_diff, layout_settings.inner_window.height)

			Gui.bitmap(self._gui, "mask_rect_alpha", pos, size, Color(255, 0, 0, 0))
			Gui.rect(self._gui, pos, size, MenuHelper:color(layout_settings.inner_window.color))
			MenuHelper:render_border(self._gui, {
				start_x,
				start_y,
				layout_settings.inner_window.width + frame_diff,
				layout_settings.inner_window.height
			}, layout_settings.inner_window.border_thickness, MenuHelper:color(layout_settings.inner_window.border_color))
		end

		if text_input_element then
			local start_x = text_input_element._x
			local start_y = text_input_element._y
			local pos = Vector3(start_x, start_y, text_input_element._z - 1)
			local size = Vector2(layout_settings.inner_window.width + frame_diff, text_input_element:height())

			Gui.bitmap(self._gui, "mask_rect_alpha", pos, Vector2(layout_settings.inner_window.width + frame_diff, layout_settings.text_settings.spacing), Color(255, 0, 0, 0))
			Gui.rect(self._gui, pos, size, MenuHelper:color(layout_settings.inner_window.color))
			MenuHelper:render_border(self._gui, {
				start_x,
				start_y,
				size[1],
				size[2]
			}, layout_settings.inner_window.border_thickness, MenuHelper:color(layout_settings.inner_window.border_color))
		end

		if Managers.input:pad_active(1) then
			self:_render_buttons()
		end
	elseif layout_settings.inner_window then
		local start_x = x + layout_settings.inner_window.offset_x
		local start_y = y + layout_settings.inner_window.offset_y
		local pos = Vector3(start_x, start_y, layout_settings.inner_window.z)
		local size = Vector2(layout_settings.inner_window.width, layout_settings.inner_window.height)

		Gui.bitmap(self._gui, "mask_rect_alpha", pos, size, Color(255, 0, 0, 0))
	end
end

function ChatOutputWindow:_render_buttons()
	local fitta = HUDSettings
	local layout_settings = MenuHelper:layout_settings(HUDSettings.default_button_info)
	local button_config = layout_settings.default_buttons
	local text_data = layout_settings.text_data
	local w, h = Gui.resolution()
	local x = text_data.offset_x or 0
	local y = text_data.offset_y or 0
	local offset_x = 0
	local standard_button_size = {
		56,
		56
	}

	for _, button in ipairs(button_config) do
		local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(button.button_name)
		local button_offset = {
			type(button.button_name) == "table" and #button.button_name * standard_button_size[1] or standard_button_size[1],
			size[2] == standard_button_size[2] and standard_button_size[2] or size[2] * 1.3
		}

		if type(button.button_name) == "table" then
			for i, button_name in ipairs(button.button_name) do
				local material, uv00, uv11, size = HUDHelper.get_360_button_bitmap(button_name)
				local inner_button_offset = {
					type(button.button_name) == "table" and #button.button_name * standard_button_size[1] or standard_button_size[1],
					size[2] == standard_button_size[2] and standard_button_size[2] or size[2] * 1.3
				}

				Gui.bitmap_uv(self._gui, material, uv00, uv11, Vector3(x + offset_x + (i - 1) * standard_button_size[1], y - inner_button_offset[2], 999), size)
			end
		else
			Gui.bitmap_uv(self._gui, material, uv00, uv11, Vector3(x + offset_x, y - button_offset[2], 999), size)
		end

		local text = string.upper(L(button.text))

		Gui.text(self._gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + button_offset[1] + offset_x, y - standard_button_size[2] * 0.62, 999))

		if text_data.drop_shadow then
			local drop_x, drop_y = unpack(text_data.drop_shadow)

			Gui.text(self._gui, text, text_data.font.font, text_data.font_size, text_data.font.material, Vector3(x + button_offset[1] + offset_x + drop_x, y - standard_button_size[2] * 0.62 + drop_y, 998), Color(0, 0, 0))
		end

		local min, max = Gui.text_extents(self._gui, text, text_data.font.font, text_data.font_size)

		offset_x = offset_x + (max[1] - min[1]) + button_offset[1]
	end
end

function ChatOutputWindow:_render_texts(layout_settings, dt, t)
	if layout_settings.text_settings then
		local x, y, z = HUDHelper:element_position(nil, self, layout_settings)
		local min_height = y + layout_settings.inner_window.offset_y - layout_settings.text_settings.spacing

		if layout_settings.text_settings.text_method == "bottom" then
			local bottom_offset = self:_calculate_bottom_offset(layout_settings, t)
			local current_pos = Vector3(x + layout_settings.inner_window.offset_x + layout_settings.text_settings.offset_x, y + layout_settings.inner_window.offset_y + layout_settings.text_settings.offset_y + bottom_offset - self._scroll_offset, layout_settings.text_settings.z)

			for i = #self._texts, 1, -1 do
				local message_table = self._texts[i].message_table
				local color = table.clone(layout_settings.text_settings.text_color)
				local shadow_color = table.clone(layout_settings.text_settings.shadow_color)
				local alpha = 1

				if not self._active then
					local diff = self._texts[i].time + layout_settings.text_settings.life_time - Managers.time:time("main")

					if diff >= 0 and diff <= layout_settings.text_settings.fade_time then
						alpha = diff / layout_settings.text_settings.fade_time
					elseif diff < 0 then
						alpha = 0
					end

					color[1] = color[1] * alpha
					shadow_color[1] = shadow_color[1] * alpha * alpha
				end

				if alpha > 0 then
					for j = #message_table, 1, -1 do
						if min_height <= current_pos[2] then
							Gui.text(self._gui, message_table[j], layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos, MenuHelper:color(color))
							Gui.text(self._gui, message_table[j], layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos + Vector3(layout_settings.text_settings.shadow_offset, -layout_settings.text_settings.shadow_offset, -1), MenuHelper:color(shadow_color))

							if j == 1 then
								local prefix = "[" .. self._texts[i].channel_name .. "] " .. self._texts[i].name
								local c = self._texts[i].color:unbox()
								local color = {
									255 * alpha,
									c[1],
									c[2],
									c[3]
								}

								Gui.text(self._gui, prefix, layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos + Vector3(0, 0, 1), MenuHelper:color(color))
							end
						end

						current_pos[2] = current_pos[2] + layout_settings.text_settings.spacing

						if current_pos[2] > y + layout_settings.inner_window.height + layout_settings.inner_window.offset_y then
							return
						end
					end
				end
			end
		else
			local top_offset = self:_calculate_top_offset(layout_settings)
			local current_pos = Vector3(x + layout_settings.inner_window.offset_x + layout_settings.text_settings.offset_x, y + layout_settings.inner_window.offset_y + layout_settings.text_settings.offset_y - self._scroll_offset + layout_settings.inner_window.height + top_offset - layout_settings.text_settings.spacing, layout_settings.text_settings.z)

			for i = 1, #self._texts do
				local color = table.clone(layout_settings.text_settings.text_color)
				local shadow_color = table.clone(layout_settings.text_settings.shadow_color)
				local message_table = self._texts[i].message_table
				local alpha = 1

				if not self._active then
					local diff = self._texts[i].time + layout_settings.text_settings.life_time - Managers.time:time("main")

					if diff >= 0 and diff <= layout_settings.text_settings.fade_time then
						alpha = diff / layout_settings.text_settings.fade_time
					elseif diff < 0 then
						alpha = 0
					end

					color[1] = color[1] * alpha
					shadow_color[1] = shadow_color[1] * alpha * alpha
				end

				if alpha > 0 then
					for j = 1, #message_table do
						if current_pos[2] < y + layout_settings.inner_window.height + layout_settings.inner_window.offset_y then
							Gui.text(self._gui, message_table[j], layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos, MenuHelper:color(color))
							Gui.text(self._gui, message_table[j], layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos + Vector3(layout_settings.text_settings.shadow_offset, -layout_settings.text_settings.shadow_offset, -1), MenuHelper:color(shadow_color))

							if j == 1 and self._texts[i].channel_name and self._texts[i].name then
								local prefix = "[" .. self._texts[i].channel_name .. "] " .. self._texts[i].name
								local c = self._texts[i].color:unbox()
								local color = {
									255 * alpha,
									c[1],
									c[2],
									c[3]
								}

								Gui.text(self._gui, prefix, layout_settings.text_settings.font.font, layout_settings.text_settings.font_size, layout_settings.text_settings.font.material, current_pos + Vector3(0, 0, 1), MenuHelper:color(color))
							end
						end

						current_pos[2] = current_pos[2] - layout_settings.text_settings.spacing

						if min_height >= current_pos[2] then
							return
						end
					end
				end
			end
		end
	end
end

function ChatOutputWindow:_render_elements(dt, t, gui, layout_settings)
	for id, element in pairs(self._elements) do
		element:render(dt, t, gui, HUDHelper:layout_settings(element.config.layout_settings))
	end

	if layout_settings.background_color then
		local color = Color(layout_settings.background_color[1], layout_settings.background_color[2], layout_settings.background_color[3], layout_settings.background_color[4])

		Gui.rect(gui, Vector3(self._x, self._y, self._z), Vector2(self._width, self._height), color)
	end
end

function ChatOutputWindow:_calculate_top_offset(layout_settings)
	local top_offset = 0
	local soft_offset = 0
	local current_time = Managers.time:time("main")
	local total_extents = self._total_extents

	if not self._active then
		total_extents = 0

		for i = 1, #self._texts do
			local end_time = self._texts[i].time + layout_settings.text_settings.life_time

			if current_time < end_time then
				total_extents = total_extents + #self._texts[i].message_table * layout_settings.text_settings.spacing
			elseif current_time < end_time + layout_settings.text_settings.text_scroll_time then
				local percentage = (end_time + layout_settings.text_settings.text_scroll_time - current_time) / layout_settings.text_settings.text_scroll_time

				soft_offset = soft_offset + #self._texts[i].message_table * layout_settings.text_settings.spacing * percentage
			end
		end
	else
		total_extents = 0

		for i = 1, #self._texts do
			total_extents = total_extents + #self._texts[i].message_table * layout_settings.text_settings.spacing
		end
	end

	if layout_settings.inner_window.height - total_extents < 0 then
		top_offset = math.max(total_extents - layout_settings.inner_window.height, 0)

		for i = #self._texts, 1, -1 do
			if current_time < self._texts[i].time + layout_settings.text_settings.text_scroll_time then
				soft_offset = soft_offset + (self._texts[i].time + layout_settings.text_settings.text_scroll_time - current_time) / layout_settings.text_settings.text_scroll_time * #self._texts[i].message_table * layout_settings.text_settings.spacing
			end
		end
	end

	top_offset = top_offset - soft_offset

	return top_offset
end

function ChatOutputWindow:_calculate_bottom_offset(layout_settings)
	local current_time = Managers.time:time("main")
	local bottom_offset = 0

	for i = #self._texts, 1, -1 do
		local message_table = self._texts[i].message_table
		local time = self._texts[i].time + layout_settings.text_settings.text_scroll_time

		if current_time < time then
			local offset = 0

			for j = 1, #message_table do
				offset = offset + layout_settings.text_settings.spacing
			end

			local percentage = smoothstep(0, 1, (time - current_time) / layout_settings.text_settings.text_scroll_time)

			bottom_offset = bottom_offset - percentage * offset
		end
	end

	return bottom_offset
end

function ChatOutputWindow:post(channel_name, name, message, color)
	local layout_settings = MenuHelper:layout_settings(self._layout_settings)
	local message_table = self:_format_message(layout_settings, message)

	if self:_post_allowed(layout_settings, name) then
		self._texts[#self._texts + 1] = {
			name = name,
			channel_name = channel_name,
			message_table = message_table,
			message = message,
			color = color and Vector3Box(color),
			time = Managers.time:time("main")
		}
		self._total_extents = self._total_extents + #message_table * layout_settings.text_settings.spacing
	end
end

function ChatOutputWindow:_post_allowed(layout_settings, name)
	if not name then
		return true
	end

	local current_time = math.floor(Managers.time:time("main") + 0.5)

	self._flood_control[name] = self._flood_control[name] or {
		posts = 1,
		post_time = current_time
	}

	if current_time - self._flood_control[name].post_time > layout_settings.text_settings.post_time then
		self._flood_control[name] = {
			posts = 1,
			post_time = current_time
		}
	elseif self._flood_control[name].posts > layout_settings.text_settings.max_posts then
		return false
	else
		self._flood_control[name].posts = self._flood_control[name].posts + 1
	end

	return true
end

function ChatOutputWindow:_format_message(layout_settings, message)
	local width = layout_settings.inner_window.width - layout_settings.text_settings.offset_x * 2
	local font = layout_settings.text_settings.font.font
	local font_size = layout_settings.text_settings.font_size

	return MenuHelper:format_text(message, self._gui, font, font_size, width)
end

function ChatOutputWindow:event_chat_message(channel_id, sender, message)
	local channel = NetworkLookup.chat_channels[channel_id]
	local channel_name = L("chat_" .. channel)
	local name = rawget(_G, "Steam") and Steam.user_name(sender) or ""
	local color_table = HUDSettings.chat_text_colors
	local color = Vector3(255, 255, 255)

	if channel == "dead_team_red" or channel == "dead_team_white" or channel == "dead_unassigned" then
		local state = Managers.player:player_exists(1) and Managers.player:player(1).spawn_data.state

		if state == "dead" or state == "not_spawned" then
			if Network.peer_id() == sender then
				color = Vector3(color_table.self_team[1], color_table.self_team[2], color_table.self_team[3])
			else
				color = Vector3(color_table.team[1], color_table.team[2], color_table.team[3])
			end
		else
			return
		end
	elseif channel == "team_red" or channel == "team_white" or channel == "team_unassigned" then
		if Network.peer_id() == sender then
			color = Vector3(color_table.self_team[1], color_table.self_team[2], color_table.self_team[3])
		else
			color = Vector3(color_table.team[1], color_table.team[2], color_table.team[3])
		end
	elseif channel == "dead" then
		local state = Managers.player:player_exists(1) and Managers.player:player(1).spawn_data.state

		if state == "dead" or state == "not_spawned" then
			if Network.peer_id() == sender then
				color = Vector3(color_table.self_all[1], color_table.self_all[2], color_table.self_all[3])
			else
				color = Vector3(color_table.all[1], color_table.all[2], color_table.all[3])
			end
		else
			return
		end
	elseif channel == "all" then
		local stats_collection = Managers.state.stats_collection
		local has_context = stats_collection and stats_collection:has_context(sender)
		local developer = has_context and stats_collection:get(sender, "developer") > 0 or false

		if developer then
			color = Vector3(color_table.developer_all[1], color_table.developer_all[2], color_table.developer_all[3])
		elseif Network.peer_id() == sender then
			color = Vector3(color_table.self_all[1], color_table.self_all[2], color_table.self_all[3])
		else
			color = Vector3(color_table.all[1], color_table.all[2], color_table.all[3])
		end
	end

	local event = Application.user_setting("chat_sound") or "hud_chat_ver_10"

	if event ~= "off" then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, event)
	end

	self:post(channel_name, name, "[" .. channel_name .. "] " .. name .. ": " .. message, color)
end

function ChatOutputWindow:event_admin_chat_message(channel_id, sender, message)
	local channel = NetworkLookup.chat_channels[channel_id]
	local channel_name = L("chat_" .. channel)

	self:post(nil, nil, "Admin: " .. message, Vector3(255, 255, 255))
end

function ChatOutputWindow:event_rcon_chat_message(channel_id, sender, message)
	local channel = NetworkLookup.chat_channels[channel_id]
	local channel_name = L("chat_" .. channel)

	self:post(nil, nil, message, Vector3(255, 255, 255))
end

function ChatOutputWindow:output_console_text(text, color)
	self:post(nil, nil, text, color)
end

function ChatOutputWindow:network_output_console_text(text_id, color, display_time)
	local network_manager = Managers.state.network

	assert(network_manager:game(), "[DebugTextManager] Tried to send network synched debug text without a network game")

	if Managers.lobby.server then
		network_manager:send_rpc_clients("rpc_output_debug_console_text", NetworkLookup.localized_strings[text_id], color, display_time or 0)
	else
		network_manager:send_rpc_server("rpc_output_debug_console_text", NetworkLookup.localized_strings[text_id], color, display_time or 0)
	end

	self:post(nil, nil, L(text_id), color)
end

function ChatOutputWindow:text_data()
	return {
		texts = self._texts,
		text_extents = self._total_extents
	}
end

function ChatOutputWindow:on_activated(active)
	return
end

function ChatOutputWindow:on_deactivated(active)
	return
end

function ChatOutputWindow:set_enabled(enabled)
	return
end

function ChatOutputWindow:disabled_post_update(dt, t)
	return
end

function ChatOutputWindow:enabled()
	return true
end

function ChatOutputWindow:destroy()
	if self._world_name then
		Managers.world:destroy_world(self._world_name)
	end
end
