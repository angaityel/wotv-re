-- chunkname: @scripts/settings/squad_settings.lua

require("scripts/settings/player_effect_settings")

SquadSettings = {
	autojoin_squad = false,
	render_health = "squad",
	instakill_corporal = true,
	use_flag_in_range_check = true,
	can_bandage = "squad",
	Fbuff_level = 1,
	instakill_within_range = true,
	far_range = 30,
	buff_duration = 36000,
	setup_area_time = 0.5,
	range_check = "squad_members_range_check",
	squad_flag_plant_delay = 60,
	nullify_friendly_fire = "nullify_team",
	squad_colours = {
		{
			name = "squad_colour_01",
			colour = {
				255,
				175,
				165,
				76
			}
		},
		{
			name = "squad_colour_02",
			colour = {
				255,
				81,
				69,
				61
			}
		},
		{
			name = "squad_colour_03",
			colour = {
				255,
				109,
				26,
				26
			}
		},
		{
			name = "squad_colour_04",
			colour = {
				255,
				40,
				79,
				119
			}
		},
		{
			name = "squad_colour_05",
			colour = {
				255,
				67,
				90,
				52
			}
		},
		{
			name = "squad_colour_06",
			colour = {
				255,
				81,
				58,
				98
			}
		},
		{
			name = "squad_colour_07",
			colour = {
				255,
				127,
				76,
				27
			}
		},
		{
			name = "squad_colour_08",
			colour = {
				255,
				27,
				127,
				123
			}
		}
	},
	squad_animals = {
		{
			texture = "squad_menu_animal_owl",
			name = "squad_animal_01"
		},
		{
			texture = "squad_menu_animal_fox",
			name = "squad_animal_02"
		},
		{
			texture = "squad_menu_animal_moose",
			name = "squad_animal_03"
		},
		{
			texture = "squad_menu_animal_bore",
			name = "squad_animal_04"
		},
		{
			texture = "squad_menu_animal_wolf",
			name = "squad_animal_05"
		},
		{
			texture = "squad_menu_animal_bear",
			name = "squad_animal_06"
		},
		{
			texture = "squad_menu_animal_raven",
			name = "squad_animal_07"
		},
		{
			texture = "squad_menu_animal_eagle",
			name = "squad_animal_08"
		}
	},
	default_buff = {
		level = 1,
		shape = "cylinder",
		radius = 10,
		type = "courage"
	},
	status_icons_on_squad_only = GameSettingsDevelopment.squad_first
}

function SquadSettings.nullify_team(player, hit_unit)
	local hit_player_index = Unit.get_data(hit_unit, "player_index")

	if not hit_player_index then
		return false
	end

	local hit_player = Managers.player:player(hit_player_index)

	return hit_player.team == player.team
end

function SquadSettings.nullify_squad(player, hit_unit)
	local hit_player_index = Unit.get_data(hit_unit, "player_index")

	if not hit_player_index then
		return false
	end

	local hit_player = Managers.player:player(hit_player_index)

	if hit_player.team ~= player.team then
		return false
	end

	if not player.squad_index then
		return false
	end

	return hit_player.squad_index == player.squad_index
end
