-- chunkname: @scripts/menu/menu_definitions/final_scoreboard_menu_definition.lua

FinalScoreboardMenuDefinition = {
	page = {
		type = "EmptyMenuPage",
		item_groups = {
			item_list = {
				{
					id = "final_scoreboard",
					type = "EmptyMenuItem",
					page = {
						z = 1,
						type = "FinalScoreboardMenuPage",
						layout_settings = FinalScoreboardMenuSettings.pages.main_page,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							center_items = {
								{
									text = "",
									name = "battle_result",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.battle_result
								},
								{
									text = "",
									name = "battle_details",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.battle_details
								},
								{
									name = "center_team_rose",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.center_team_rose
								}
							},
							left_team_items = {
								{
									name = "left_team_rose",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.left_team_rose
								},
								{
									text = "",
									name = "left_team_score",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.left_team_score
								},
								{
									text = "",
									name = "left_team_text",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.left_team_text
								}
							},
							right_team_items = {
								{
									name = "right_team_rose",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.right_team_rose
								},
								{
									text = "",
									name = "right_team_score",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.right_team_score
								},
								{
									text = "",
									name = "right_team_text",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.right_team_text
								}
							},
							coin_award = {
								{
									text = "coin_award_header",
									name = "header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.coin_award_header
								},
								{
									name = "header_delimiter",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.coin_award_header_delimiter
								},
								{
									text = "final_scoreboard_round_coins",
									name = "round_coins_header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.round_coins_header
								},
								{
									text = "final_scoreboard_short_term_goal_bonus",
									name = "short_term_goal_bonus_header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.short_term_goal_bonus_header
								},
								{
									text = "final_scoreboard_event_bonus",
									name = "event_bonus_header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.event_bonus_header
								},
								{
									text = "final_scoreboard_first_win_coins",
									name = "first_win_coins_header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.first_win_coins_header
								},
								{
									text = "final_scoreboard_round_total",
									name = "round_total_header",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.round_total_header
								},
								{
									text = "",
									name = "round_coins",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.round_coins
								},
								{
									text = "",
									name = "short_term_goal_bonus",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.short_term_goal_bonus
								},
								{
									text = "",
									name = "event_bonus",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.event_bonus
								},
								{
									text = "",
									name = "first_win_coins",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.first_win_coins
								},
								{
									name = "round_total_divider_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.round_total_divider_texture
								},
								{
									text = "",
									name = "round_total",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.round_total
								},
								{
									name = "round_coins_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.round_coins_texture
								},
								{
									text = "%",
									name = "short_term_goal_bonus_procent",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.short_term_goal_bonus_procent
								},
								{
									text = "%",
									name = "event_bonus_procent",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.event_bonus_procent
								},
								{
									name = "first_win_coins_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.first_win_coins_texture
								},
								{
									name = "round_total_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.round_total_texture
								},
								{
									text = "",
									name = "total_coins",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = FinalScoreboardMenuSettings.items.total_coins
								},
								{
									name = "total_coins_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.total_coins_texture
								},
								{
									name = "total_coins_chest_texture",
									disabled = true,
									type = "TextureMenuItem",
									layout_settings = FinalScoreboardMenuSettings.items.total_coins_chest_texture
								}
							}
						}
					}
				}
			}
		}
	}
}
