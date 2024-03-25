-- chunkname: @scripts/settings/input_filters.lua

VikingFilterAxisScaleRampDt = class(VikingFilterAxisScaleRampDt)

local RAISED = 5
local HIGHER_ORDER_THRESHOLD = 0.999
local HIGHER_ORDER_THRESHOLD_HIGH = HIGHER_ORDER_THRESHOLD^RAISED
local HIGHER_ORDER_THRESHOLD_DIVIDED = HIGHER_ORDER_THRESHOLD_HIGH / HIGHER_ORDER_THRESHOLD
local MIN_MOVE = 0.03
local TIME_ACC_START_THRESHOLD = 0.95
local TIME_ACC_START = 0.2
local TIME_ACC_MAX_TIME_FACTOR = 3

function VikingFilterAxisScaleRampDt:init(params, controller)
	self._controller = controller
	self._params = params

	fassert(params.scale_x, "no scale_x defined!")
	fassert(params.scale_y, "no scale_y defined!")
end

function VikingFilterAxisScaleRampDt:evaluate(source)
	return self._update_value
end

function VikingFilterAxisScaleRampDt:update(source, dt)
	local params = self._params
	local axis = source:get(self._params.axis)
	local x, y
	local scale_x = params.scale_x
	local scale_y = params.scale_y
	local min_move = params.min_move or MIN_MOVE
	local x_abs = math.abs(axis.x)

	if x_abs > HIGHER_ORDER_THRESHOLD then
		x = x_abs^RAISED

		local hi_scale_x = params.hi_scale_x

		if hi_scale_x then
			local norm_mult = (x_abs - HIGHER_ORDER_THRESHOLD) / (1 - HIGHER_ORDER_THRESHOLD)

			scale_x = scale_x + hi_scale_x * norm_mult
		end
	elseif x_abs > MIN_MOVE then
		x = min_move + x_abs * HIGHER_ORDER_THRESHOLD_DIVIDED
	else
		x = 0
	end

	if axis.x < 0 then
		x = -x
	end

	local y_abs = math.abs(axis.y)

	if y_abs > HIGHER_ORDER_THRESHOLD then
		y = y_abs^RAISED
	elseif y_abs > 0.01 then
		y = min_move + y_abs * HIGHER_ORDER_THRESHOLD_DIVIDED
	else
		y = 0
	end

	if axis.y < 0 then
		y = -y
	end

	local time_acc_multiplier = params.time_acc_multiplier

	if time_acc_multiplier then
		local len = Vector3.length(axis)

		if len > TIME_ACC_START_THRESHOLD and not self._acc_timer then
			self._acc_timer = 0
		elseif len > TIME_ACC_START_THRESHOLD then
			self._acc_timer = self._acc_timer + dt

			local multiplier = 1 + time_acc_multiplier * math.clamp((self._acc_timer - TIME_ACC_START) * TIME_ACC_MAX_TIME_FACTOR, 0, 1)

			x = x * multiplier
			y = y * multiplier
		else
			self._acc_timer = nil
		end
	end

	self._update_value = Vector3(x * scale_x, y * scale_y, 0) * dt
end

InputFilterClasses.FilterAxisScaleRampDt = VikingFilterAxisScaleRampDt
FilterAverage = class(FilterAverage)

function FilterAverage:init(params, controller)
	fassert(next(params), "FilterAverage needs at least one input")

	self._controller = controller
	self._params = params
end

function FilterAverage:evaluate(source)
	local sum = 0

	for _, input in ipairs(self._params) do
		sum = sum + source:get(input)
	end

	return sum / #self._params
end

InputFilterClasses.FilterAverage = FilterAverage
