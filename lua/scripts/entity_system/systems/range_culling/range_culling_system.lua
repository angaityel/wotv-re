-- chunkname: @scripts/entity_system/systems/range_culling/range_culling_system.lua

require("scripts/unit_extensions/generic/range_culling_extension")

RangeCullingSystem = class(RangeCullingSystem)

local OBJECTS_TO_UPDATE_PER_FRAME = 5

function RangeCullingSystem:init(context, system_name)
	local em = context.entity_manager

	em:register_system(self, system_name)

	self.entity_manager = em
	self._world = context.world
	self._unit_list = {}
	self._current_index = 1
end

function RangeCullingSystem:on_add_extension(world, unit, extension_name, extension_class, ...)
	local unit_list = self._unit_list

	unit_list[#unit_list + 1] = unit
end

function RangeCullingSystem:on_remove_extension(unit, extension_name)
	return
end

function RangeCullingSystem:update(context, t)
	if not Managers.player:player_exists(1) then
		return
	end

	local camera_position = Managers.state.camera:camera_position(Managers.player:player(1).viewport_name)
	local unit_list = self._unit_list
	local target = self._current_index + OBJECTS_TO_UPDATE_PER_FRAME
	local index = self._current_index

	while index <= target do
		local unit = unit_list[index]

		if not unit then
			self._current_index = 1

			return
		elseif Unit.alive(unit) then
			local unit_position = Unit.world_position(unit, 0)
			local distance = Vector3.length(unit_position - camera_position)
			local culled = Unit.get_data(unit, "RangeCullingSystem", "_culled") ~= false
			local culling_range = Unit.get_data(unit, "RangeCullingSystem", "range")

			if distance < culling_range and culled then
				Unit.set_data(unit, "RangeCullingSystem", "_culled", false)
				Unit.flow_event(unit, "lua_range_unculled")
			elseif culling_range < distance and not culled then
				Unit.set_data(unit, "RangeCullingSystem", "_culled", true)
				Unit.flow_event(unit, "lua_range_culled", true)
			end

			if script_data.range_culling_debug then
				if Unit.get_data(unit, "RangeCullingSystem", "_culled") ~= false then
					Managers.state.debug:drawer({
						mode = "immediate",
						name = "RangeCullingSystem"
					}):sphere(unit_position, 1, Color(255, 0, 0))
				else
					Managers.state.debug:drawer({
						mode = "immediate",
						name = "RangeCullingSystem"
					}):sphere(unit_position, 1, Color(0, 255, 0))
				end
			end
		end

		index = index + 1
	end

	self._current_index = index
end

function RangeCullingSystem:hot_join_synch(sender, player)
	return
end

function RangeCullingSystem:destroy()
	return
end
