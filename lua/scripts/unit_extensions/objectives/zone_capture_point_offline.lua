-- chunkname: @scripts/unit_extensions/objectives/zone_capture_point_offline.lua

ZoneCapturePointOffline = class(ZoneCapturePointOffline, ZoneCapturePointServer)
ZoneCapturePointOffline.SERVER_ONLY = false
ZoneCapturePointOffline.OFFLINE_ONLY = true

function bit_encode(value_1, bits_1, value_2, bits_2)
	local part_1 = value_1
	local part_2 = value_2 * 2^bits_1

	return part_1 + part_2
end

function bit_decode(total_value, bits_1, bits_2)
	local value_2 = math.floor(total_value / 2^bits_1)
	local value_1 = total_value % 2^bits_1

	return value_1, value_2
end
