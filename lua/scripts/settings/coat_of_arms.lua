-- chunkname: @scripts/settings/coat_of_arms.lua

require("scripts/settings/attachment_node_linking")

function populate_player_coat_of_arms_from_save(save_data)
	if save_data.player_coat_of_arms then
		PlayerCoatOfArms = save_data.player_coat_of_arms
	else
		save_data.player_coat_of_arms = PlayerCoatOfArms
	end
end

DefaultCoatOfArms = {
	shield = "standard",
	variation_2_type = "variations_00",
	ordinary_color = "team_secondary",
	helmet = "helmet_sutton_hoo_heavy",
	variation_1_type = "variations_00",
	title = "none",
	division_color = "team_secondary",
	division_type = "divisions_00",
	ordinary_type = "ordinaries_08",
	field_color = "team_primary",
	charge_color = "team_primary",
	charge_type = "charge_00",
	crest = "crest_torse",
	variation_1_color = "team_secondary",
	ui_team_name = "red",
	variation_2_color = "team_primary"
}
CoatOfArmsAtlasVariants = {
	red = {
		top_heraldry = "heraldry_base",
		charge_heraldry = "heraldry_vikings",
		mid_heraldry = "heraldry_base"
	},
	white = {
		top_heraldry = "heraldry_base",
		charge_heraldry = "heraldry_saxons",
		mid_heraldry = "heraldry_base"
	}
}
DefaultWotvCoatOfArms = {
	red = {
		charge_heraldry = "viking01",
		charge_heraldry_color_index = 69,
		top_heraldry_color_index = 32,
		base_color_index = 18,
		top_heraldry = "base01",
		base_heraldry_index = 255,
		mid_heraldry_color_index = 76,
		mid_heraldry = "base01"
	},
	white = {
		charge_heraldry = "saxon01",
		charge_heraldry_color_index = 41,
		top_heraldry_color_index = 115,
		base_color_index = 67,
		top_heraldry = "base01",
		base_heraldry_index = 255,
		mid_heraldry_color_index = 30,
		mid_heraldry = "base01"
	}
}
PlayerCoatOfArms = PlayerCoatOfArms or table.clone(DefaultWotvCoatOfArms)
