-- chunkname: @scripts/managers/battle_chatter/battle_chatter_handler.lua

BattleChatterHandler = class(BattleChatterHandler)

local RELEVANT_CHATTERS_CAP = 2
local IRRELEVANT_CHATTERS_CAP = 10

function BattleChatterHandler:init(world)
	self._world = world
	self._relevant_chatters = {}
	self._irrelevant_chatters = {}
	self._queue_list = {}
	self._history = {}
	self._drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "BattleChatterHandler"
	})
end

function BattleChatterHandler:update(dt, t)
	self:_update_queue_list(dt, t)
	self:_update_chatter(self._relevant_chatters, dt, t)
	self:_update_chatter(self._irrelevant_chatters, dt, t)
end

function BattleChatterHandler:_update_queue_list(dt, t)
	local i = 1

	while i <= #self._queue_list do
		local chatter = self._queue_list[i]

		self:_debug_draw(chatter)

		local queue_config = chatter.config.queue_config

		if self:_can_start(chatter) then
			self:_start_chatter(chatter)
			table.remove(self._queue_list, i)
		else
			chatter.timer = chatter.timer + dt

			if chatter.timer >= queue_config.queue_time then
				table.remove(self._queue_list, i)
			else
				i = i + 1
			end
		end
	end
end

function BattleChatterHandler:_update_chatter(chatter_list, dt, t)
	for name, chatters in pairs(chatter_list) do
		local i = 1

		while i <= #chatters do
			local data = chatters[i]

			if Unit.alive(data.talker) then
				self:_debug_draw(data)

				if not data.started then
					data.timer = data.timer + dt

					local config = data.config

					if data.timer >= config.delay then
						self:_begin_chatter(data)
					end

					i = i + 1
				elseif self:_chatter_done(data) then
					self:_end_chatter(data)
					table.remove(chatters, i)
				else
					i = i + 1
				end
			else
				table.remove(chatters, i)
			end
		end
	end
end

function BattleChatterHandler:add_chatter(data)
	data.timer = 0

	if self:_can_start(data) then
		self:_start_chatter(data)
	else
		self:_add_queue(data)
	end

	self:_add_history(data)
end

function BattleChatterHandler:_add_queue(data)
	data.queue = true

	if data.relevant then
		local idx

		for id, chatter in ipairs(self._queue_list) do
			if not chatter.relevant then
				idx = id

				break
			end
		end

		if idx then
			table.insert(self._queue_list, idx, data)
		else
			table.insert(self._queue_list, data)
		end
	else
		table.insert(self._queue_list, data)
	end
end

function BattleChatterHandler:history(unit)
	return self._history[unit]
end

function BattleChatterHandler:_add_history(data)
	self._history[data.talker] = self._history[data.talker] or {}
	self._history[data.talker][data.config.name] = data.cooldown
end

function BattleChatterHandler:_can_start(data)
	if data.relevant then
		local num_chatters, num_of_type = self:_active_chatters(self._relevant_chatters, data.config.name)

		if num_chatters < RELEVANT_CHATTERS_CAP and num_of_type < data.config.relevant_active then
			return BattleChatterHelper.talk_eligible(data.talker)
		end
	else
		local num_chatters, num_of_type = self:_active_chatters(self._irrelevant_chatters, data.config.name)

		if num_chatters < IRRELEVANT_CHATTERS_CAP and num_of_type < data.config.irrelevant_active then
			return BattleChatterHelper.talk_eligible(data.talker)
		end
	end

	return false
end

function BattleChatterHandler:_start_chatter(data)
	data.queue = false

	Unit.set_data(data.talker, "bc_talking", true)

	if data.relevant then
		self._relevant_chatters[data.config.name] = self._relevant_chatters[data.config.name] or {}

		table.insert(self._relevant_chatters[data.config.name], data)
	else
		self._irrelevant_chatters[data.config.name] = self._irrelevant_chatters[data.config.name] or {}

		table.insert(self._irrelevant_chatters[data.config.name], data)
	end
end

function BattleChatterHandler:_begin_chatter(data)
	local timpani_world = World.timpani_world(self._world)
	local timpani_event, response = self:_get_event(data.config.timpani_events)

	data.id = TimpaniWorld.trigger_event(timpani_world, timpani_event, data.talker, Unit.node(data.talker, "Head"))

	self:_set_parameters(timpani_world, data.id, data.parameters)

	data.started = true
	data.response = response
end

function BattleChatterHandler:_end_chatter(data)
	local talker = data.talker

	Unit.set_data(talker, "bc_talking", false)
	self:_handle_responses(data)
end

function BattleChatterHandler:_chatter_done(data)
	local timpani_world = World.timpani_world(self._world)
	local playing = TimpaniWorld.is_playing(timpani_world, data.id)

	return not playing
end

function BattleChatterHandler:_handle_responses(data)
	local response = data.response

	if response then
		response(data)
	end
end

function BattleChatterHandler:_get_event(events)
	local total_weight = 0

	for _, data in pairs(events) do
		local weight = data.weight or 1

		total_weight = total_weight + weight
	end

	local selected_weight = math.random(1, total_weight)
	local current_weight = 0

	for _, data in pairs(events) do
		current_weight = current_weight + data.weight

		if selected_weight <= current_weight then
			return data.event, data.response
		end
	end
end

function BattleChatterHandler:_set_parameters(timpani_world, id, parameters)
	for i = 1, #parameters, 2 do
		local parameter = parameters[i]
		local value = parameters[i + 1]

		TimpaniWorld.set_parameter(timpani_world, id, parameter, value)
	end
end

function BattleChatterHandler:_active_chatters(chatter_table, wanted_type)
	local num_chatters = 0
	local num_of_type = 0

	for name, chatter_type in pairs(chatter_table) do
		for _, chatter in ipairs(chatter_type) do
			num_chatters = num_chatters + 1

			if chatter_type == wanted_type then
				num_of_type = num_of_type + 1
			end
		end
	end

	return num_chatters, num_of_type
end

function BattleChatterHandler:_debug_draw(data)
	if script_data.debug_battle_chatter then
		local color, size

		if data.queue then
			color = Color(255, 255, 0, 0)

			local timer = data.timer
			local queue_time = data.config.queue_config.queue_time

			if queue_time == 0 then
				queue_time = 0.01
			end

			size = 0.5 * (timer / queue_time)
		elseif data.started then
			color = Color(255, 0, 255, 0)
			size = 0.5
		else
			local timer = data.timer
			local delay = data.config.delay

			if delay == 0 then
				delay = 0.01
			end

			local diff = timer / delay

			math.clamp(diff, 0, 1)

			local r = 255 * (1 - diff)
			local g = 255 * diff

			color = Color(255, r, g, 0)
			size = 0.5
		end

		if color and size then
			local talker = data.talker
			local position = Unit.world_position(talker, Unit.node(talker, "Head"))

			self._drawer:sphere(position, size, color)
		end
	end
end

function BattleChatterHandler:destroy()
	self._chatters = nil
end
