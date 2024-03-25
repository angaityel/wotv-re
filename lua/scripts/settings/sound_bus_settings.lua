-- chunkname: @scripts/settings/sound_bus_settings.lua

SoundBusSettings = SoundBusSettings or {}
SoundBusSettings.master_volume = {
	default = 0,
	default_headphones = 0,
	volume_min = -40,
	default_speakers = 0,
	volume_0 = -100,
	volume_max = 0
}
SoundBusSettings.voice_over = {
	default = 0,
	default_headphones = 0,
	volume_min = -40,
	default_speakers = 0,
	volume_0 = -100,
	volume_max = 0
}
SoundBusSettings.music_volume = {
	default = -4.85,
	default_headphones = -4.85,
	volume_min = -40,
	default_speakers = -4.85,
	volume_0 = -100,
	volume_max = 0
}
SoundBusSettings.sfx_volume = {
	default = 0,
	default_headphones = 0,
	volume_min = -40,
	default_speakers = 0,
	volume_0 = -100,
	volume_max = 0
}
SoundHelper = SoundHelper or {}

function SoundHelper.calculate_volume(volume_setting, bus_name, indices)
	local dB
	local settings = SoundBusSettings[bus_name]

	if volume_setting == 0 then
		dB = settings.volume_0
	else
		dB = math.lerp(settings.volume_min, settings.volume_max, (volume_setting - 1) / (indices - 1))
	end

	return dB
end

function SoundHelper.sound_volume_options(bus_name)
	local options = {}
	local saved_option = Application.user_setting(bus_name) or SoundBusSettings[bus_name].default
	local indices = 100
	local selected_index

	for i = 0, indices do
		local key = SoundHelper.calculate_volume(i, bus_name, indices)
		local option_index = #options + 1

		options[option_index] = {
			key = key,
			value = i
		}

		if not selected_index and saved_option <= key then
			selected_index = option_index
		end
	end

	return options, selected_index or indices
end
