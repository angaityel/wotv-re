-- chunkname: @scripts/managers/hud/hud_squad_leader_indicator/hud_squad_leader_indicator.lua

require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")

HUDSquadLeaderIndicator = class(HUDSquadLeaderIndicator, HUDAtlasTextureElement)

function HUDSquadLeaderIndicator:init(config)
	HUDSquadLeaderIndicator.super.init(self, config)
end

function HUDSquadLeaderIndicator:render(dt, t, gui, layout_settings)
	local config = self.config
	local player = config.blackboard.player
	local squad_index = player.squad_index

	layout_settings.texture = layout_settings.blank_icon_texture

	if squad_index then
		local team_name = player.team.name
		local team = Managers.state.team:team_by_name(team_name)
		local squad = team.squads[squad_index]
		local corporal = squad:corporal()

		if corporal == player then
			layout_settings.texture = layout_settings.squad_leader_icon_texture
		end
	end

	HUDSquadLeaderIndicator.super.render(self, dt, t, gui, layout_settings)
end

function HUDSquadLeaderIndicator.create_from_config(config)
	return HUDSquadLeaderIndicator:new(config)
end
