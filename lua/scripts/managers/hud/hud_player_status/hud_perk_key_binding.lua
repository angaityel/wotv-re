-- chunkname: @scripts/managers/hud/hud_player_status/hud_perk_key_binding.lua

require("scripts/managers/hud/shared_hud_elements/hud_text_element")

HUDPerkKeyBinding = class(HUDPerkKeyBinding, HUDTextElement)

function HUDPerkKeyBinding:init(config)
	HUDPerkKeyBinding.super.init(self, config)
end

function HUDPerkKeyBinding:render(dt, t, gui, layout_settings)
	local config = self.config
	local slot_number = config.slot_number
	local blackboard = config.blackboard[slot_number]
	local perk_name = blackboard.perk_name
	local perk = Perks[perk_name]
	local current_state = blackboard.state
	local pad_active = Managers.input:pad_active(1)
	local controller_settings = pad_active and "pad360" or "keyboard_mouse"
	local player_unit = config.owning_player.player_unit
	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")

	config.text = ActivePlayerControllerSettings[controller_settings][locomotion:perk_activation_command(perk_name)].key
	layout_settings.pivot_offset_x = layout_settings.offset_x + slot_number * layout_settings.perk_slot_x_difference
	layout_settings.text_color[1] = current_state == "ready" and 255 or 130

	if perk.activatable then
		HUDPerkKeyBinding.super.render(self, dt, t, gui, layout_settings)
	end
end

function HUDPerkKeyBinding.create_from_config(config)
	return HUDPerkKeyBinding:new(config)
end
