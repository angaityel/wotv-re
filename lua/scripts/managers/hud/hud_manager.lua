-- chunkname: @scripts/managers/hud/hud_manager.lua

require("scripts/managers/hud/hud_base")
require("scripts/managers/hud/hud_mockup/hud_mockup")
require("scripts/managers/hud/hud_world_icons/hud_world_icons")
require("scripts/hud/hud_assets")
require("scripts/managers/hud/hud_chat/hud_chat")
require("scripts/managers/hud/hud_pose_charge/hud_pose_charge")
require("scripts/managers/hud/hud_parry_helper/hud_parry_helper")
require("scripts/managers/hud/hud_player_effects/hud_buffs")
require("scripts/managers/hud/hud_player_effects/hud_debuffs")
require("scripts/managers/hud/hud_ammo_counter/hud_ammo_counter")
require("scripts/managers/hud/hud_hit_marker/hud_hit_marker")
require("scripts/managers/hud/hud_spawn/hud_spawn")
require("scripts/managers/hud/hud_player_status/hud_player_status")
require("scripts/managers/hud/hud_deserting/hud_deserting")
require("scripts/managers/hud/hud_fade_to_black/hud_fade_to_black")
require("scripts/managers/hud/hud_game_mode_status/hud_game_mode_status")
require("scripts/managers/hud/hud_combat_log/hud_combat_log")
require("scripts/managers/hud/hud_announcements/hud_announcements")
require("scripts/managers/hud/hud_sp_tutorial/hud_sp_tutorial")
require("scripts/managers/hud/hud_combat_text/hud_combat_text")
require("scripts/managers/hud/hud_tagging/hud_tagging")
require("scripts/managers/hud/hud_xp_coins/hud_xp_coins")
require("scripts/managers/hud/hud_interaction/hud_interaction")
require("scripts/managers/hud/hud_in_range/hud_in_range_indicator")
require("scripts/managers/hud/hud_squad_leader_indicator/hud_squad_leader_indicator")
require("scripts/helpers/hud_helper")
require("scripts/managers/hud/hud_chat/chat_output_window")
require("scripts/managers/hud/hud_debug_conquest_score/hud_debug_conquest_score")
require("scripts/managers/hud/hud_domination_minimap/hud_domination_minimap")

HUDManager = class(HUDManager)

function HUDManager:init(world)
	self._world = world
	self._huds = {}
	self._active = true
end

function HUDManager:add_player(player, hud_data)
	self._huds[player] = {}

	for hud_name, hud_table in pairs(hud_data) do
		self._huds[player][hud_name] = rawget(_G, hud_table.class):new(self._world, player, hud_table.data)
	end
end

function HUDManager:set_active(active)
	self._active = active

	for player, huds in pairs(self._huds) do
		for hud_name, hud in pairs(huds) do
			if active then
				hud:on_activated()
			else
				hud:on_deactivated()
			end
		end
	end
end

function HUDManager:get_hud(player, hud_name)
	fassert(hud_name and player, "[HUDManager:get_hud] You need to specify a hud name AND a player")

	return self._huds[player] and self._huds[player][hud_name]
end

function HUDManager:active()
	return self._active
end

function HUDManager:set_hud_enabled(name, enabled)
	for player, huds in pairs(self._huds) do
		huds[name]:set_enabled(enabled)
	end
end

function HUDManager:set_huds_enabled_except(enabled, except)
	for player, huds in pairs(self._huds) do
		for hud_name, hud in pairs(huds) do
			if not except or not table.contains(except, hud_name) then
				hud:set_enabled(enabled)
			end
		end
	end
end

function HUDManager:post_update(dt, t, player)
	if self._active and HUDSettings.show_hud then
		local huds = self._huds[player]

		for _, hud in pairs(huds) do
			if hud:enabled() then
				hud:post_update(dt, t, player)
			else
				hud:disabled_post_update(dt, t)
			end
		end
	elseif HUDSettings.show_hud then
		local huds = self._huds[player]

		for _, hud in pairs(huds) do
			if hud:enabled() and hud.hud_manager_inactive_post_update then
				hud:hud_manager_inactive_post_update(dt, t, player)
			elseif not hud:enabled() and hud.hud_manager_inactive_disabled_post_update then
				hud:hud_manager_inactive_disabled_post_update(dt, t)
			end
		end
	end
end

function HUDManager:destroy()
	for player, huds in pairs(self._huds) do
		for hud_name, hud in pairs(huds) do
			hud:destroy()
		end
	end

	self._huds = {}
end

function HUDManager:post(channel_name, name, text, color, display_time)
	for player, huds in pairs(self._huds) do
		huds.chat_window:post(channel_name, name, text, color, display_time)
	end
end

function HUDManager:output_console_text(text, color)
	for player, huds in pairs(self._huds) do
		huds.chat_window:output_console_text(text, color)
	end
end

function HUDManager:network_output_console_text(text_id, color, display_time)
	for player, huds in pairs(self._huds) do
		huds.chat_window:network_output_console_text(text_id, color, display_time)
	end
end
