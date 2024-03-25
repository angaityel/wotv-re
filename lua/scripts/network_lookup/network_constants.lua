-- chunkname: @scripts/network_lookup/network_constants.lua

NetworkConstants = NetworkConstants or {}
NetworkConstants.damage = Network.type_info("damage")
NetworkConstants.health = Network.type_info("health")
NetworkConstants.velocity = Network.type_info("velocity")
NetworkConstants.VELOCITY_EPSILON = Vector3.length(Vector3(NetworkConstants.velocity.tolerance, NetworkConstants.velocity.tolerance, NetworkConstants.velocity.tolerance)) * 1.1
NetworkConstants.position = Network.type_info("position")
NetworkConstants.rotation = Network.type_info("rotation")
NetworkConstants.team_score = Network.type_info("team_score")
NetworkConstants.max_attachments = 4
NetworkConstants.time_multiplier = Network.type_info("time_multiplier")
NetworkConstants.ping = Network.type_info("ping")
NetworkConstants.animation_variable_float = Network.type_info("animation_variable_float")
NetworkConstants.coins = Network.type_info("coins")
NetworkConstants.player_xp = Network.type_info("player_xp")
NetworkConstants.game_object_funcs = Network.type_info("game_object_funcs")

assert(#NetworkLookup.game_object_functions <= NetworkConstants.game_object_funcs.max, "Too many game object functions in network lookup, time to up the network config max value")

NetworkConstants.anim_event = Network.type_info("anim_event")

assert(#NetworkLookup.anims <= NetworkConstants.anim_event.max, "Too many anim events in network lookup, time to up the network config max value")

NetworkConstants.helmet_attachment_lookup = Network.type_info("helmet_attachment_lookup")

assert(#NetworkLookup.helmet_attachments <= NetworkConstants.helmet_attachment_lookup.max, "There are more helmet attachments than the current global.network_config value for \"helmet_attachment_lookup\". Please increase the value in the network config.")

NetworkConstants.announcement = Network.type_info("announcement")

assert(#NetworkLookup.announcements <= NetworkConstants.announcement.max, "There are more announcements than the current global.network_config value for \"announcement\". Please increase the value in the network config.")

NetworkConstants.beards_colors = Network.type_info("beards_colors")

assert(ProfileHelper:merge_beard_and_color(#Beards, #BeardColors) <= NetworkConstants.beards_colors.max, "Too many beards and beard color combination, up the network config max value!")

for stat, stat_network_type in pairs(StatsSynchronizer.STATS_TO_SYNC) do
	NetworkConstants[stat_network_type] = Network.type_info(stat_network_type)
end

local anim_value_max = NetworkConstants.animation_variable_float.max

for gear_name, gear in pairs(Gear) do
	local wield_time = gear.wield_time

	fassert(wield_time < anim_value_max, "Gear %q has a wield time of %fl29 which is higher than the max for network synched animation variables (%f)", gear_name, wield_time, anim_value_max)
end
