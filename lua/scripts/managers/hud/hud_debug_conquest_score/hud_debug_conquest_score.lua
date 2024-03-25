-- chunkname: @scripts/managers/hud/hud_debug_conquest_score/hud_debug_conquest_score.lua

HUDDebugConquestScore = class(HUDDebugConquestScore, HUDBase)

function HUDDebugConquestScore:init(world, player)
	HUDPlayerStatus.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "material", MenuSettings.font_group_materials.hell_shark, "material", MenuSettings.font_group_materials.viking_numbers, "immediate")

	Managers.state.event:register(self, "event_debug_conquest_activate", "event_debug_conquest_activate")
end

function HUDDebugConquestScore:event_debug_conquest_activate()
	self._debug_activate = true
end

function HUDDebugConquestScore:post_update(dt, t)
	if not self._debug_activate or not self._player.team then
		return
	end

	local my_team = self._player.team.name
	local other_team = self._player.team.name == "red" and "white" or "red"
	local my_team_name = my_team == "red" and "Vikings: " or "Saxons: "
	local other_team_name = my_team == "white" and "Vikings: " or "Saxons: "
	local my_score = math.floor(Managers.state.team:team_by_name(my_team).score + 0.5)
	local other_score = math.floor(Managers.state.team:team_by_name(other_team).score + 0.5)
	local my_text = my_team_name .. my_score
	local other_text = other_team_name .. other_score
	local w, h = Gui.resolution()
	local font = MenuSettings.fonts.hell_shark_28
	local font_size = 28
end

function HUDDebugConquestScore:destroy()
	World.destroy_gui(self._world, self._gui)
end
