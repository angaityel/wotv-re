-- chunkname: @scripts/managers/stats/stats_contexts.lua

require("scripts/settings/gear")
require("scripts/settings/gear_templates")
require("scripts/settings/player_unit_damage_settings")
require("scripts/settings/achievements")
require("scripts/settings/prizes")
require("scripts/settings/medals")
require("scripts/settings/game_mode_settings")
require("scripts/settings/ranks")

StatsContexts = StatsContexts or {
	player = {
		rank = {
			value = 0,
			backend = {
				load = true,
				save = false
			}
		},
		coins = {
			value = 0,
			backend = {
				save = true,
				load = true,
				save_mode = {
					inc = "coins_round"
				}
			}
		},
		coins_round = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		coins_bonus = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		coins_saved = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		round_won = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		round_finished = {
			value = false,
			backend = {
				load = false,
				save = false
			}
		},
		wins_in_a_row = {
			value = 0,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		enemy_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		enemy_mount_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		enemy_mounted_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		enemy_kills_while_mounted = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		enemy_corporal_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		saxon_squad_leader_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		viking_squad_leader_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		throwing_dagger_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		team_hits = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		team_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		team_damage = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		enemy_damage = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		finish_offs = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		headshots = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		longshots = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		longshot_range = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		headshots_bounced = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		headshots_with_crossbow = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		enemy_kill_within_objective = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		first_kill_since_death = {
			value = false,
			backend = {
				load = false,
				save = false
			}
		},
		successive_kills = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		kill_streak = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		longest_kill_streak = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		deaths = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		squad_spawns = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		squad_spawns_round = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		squad_wipes = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		assists = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		tagged_assists = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		revives = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		team_bandages = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		domination_objectives_captured = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		domination_objectives_captured_assist = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		con_objectives_captured = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		con_objectives_captured_assist = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		battle_objectives_captured = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		battle_objectives_captured_assist = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		section_cleared_payload = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		teabags = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		placement = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		placement_team = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		placement_squad = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		short_term_goal_end_time = {
			value = 0,
			backend = {
				exclude_from_end_of_round = true,
				save = true,
				load = true,
				save_mode = "set"
			}
		},
		short_term_goal_end_xp = {
			value = 0,
			backend = {
				exclude_from_end_of_round = true,
				save = true,
				load = true,
				save_mode = "set"
			}
		},
		short_term_goal = {
			value = 0,
			backend = {
				exclude_from_end_of_round = true,
				save = true,
				load = true,
				save_mode = "set"
			}
		},
		current_short_term_level = {
			value = 0,
			backend = {
				exclude_from_end_of_round = true,
				save = true,
				load = true,
				save_mode = "set"
			}
		},
		experience = {
			value = 0,
			backend = {
				save = true,
				load = true,
				save_mode = {
					inc = "experience_round"
				}
			}
		},
		experience_round = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		experience_bonus = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		experience_saved = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		score_round = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		time_played = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		experience_round_final = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		last_win_time = {
			value = 0,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_50k = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_100k = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_early_access = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_premium = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_coins_gift = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_coins_retail_bonus = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_blood_eagle = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		coins_unlocked_coins_gift_2 = {
			value = false,
			backend = {
				save_mode = "set",
				save = true,
				load = true
			}
		},
		anti_cheat_connects = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		anti_cheat_kicks = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		anti_cheat_status_authenticated = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		anti_cheat_status_banned = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		anti_cheat_status_disconnected = {
			value = 0,
			backend = {
				save_mode = "inc",
				save = true,
				load = false
			}
		},
		elo = {
			value = 1500,
			backend = {
				save = true,
				load = true,
				save_mode = {
					inc = "elo_change"
				}
			}
		},
		elo_change = {
			value = 0,
			backend = {
				load = false,
				save = false
			}
		},
		developer = {
			value = 0,
			backend = {
				load = true,
				save = true
			}
		},
		mark_it_zero = {
			type = "derived",
			dependencies = {
				"round_finished"
			},
			value = function(stats)
				return stats.enemy_kills.value(stats) >= 10 and stats.deaths.value(stats) == 0
			end,
			backend = {
				load = false,
				save = false
			}
		},
		ragnar_lothbrok = {
			value = false,
			backend = {
				load = false,
				save = false
			}
		},
		weapon_stats = {
			type = "compound",
			data = {},
			set = function(self, weapon_name, attribute, value)
				self.data[weapon_name][attribute] = value
			end,
			get = function(self, weapon_name, attribute)
				return self.data[weapon_name][attribute]
			end,
			increment = function(self, weapon_name, attribute, value)
				self.data[weapon_name][attribute] = self.data[weapon_name][attribute] + value
			end,
			decrement = function(self, weapon_name, attribute, value)
				self.data[weapon_name][attribute] = self.data[weapon_name][attribute] - value
			end,
			value = function(self, weapon_name, attribute)
				return self.data[weapon_name][attribute]
			end,
			get_backend_data = function(self)
				local data = {}

				for weapon_name, attributes in pairs(self.data) do
					for attribute_name, attribute_value in pairs(attributes) do
						if attribute_value > 0 then
							data[#data + 1] = {
								key = attribute_name,
								value = attribute_value,
								scopes = Gear[weapon_name].hash
							}
						end
					end
				end

				return data
			end,
			backend = {
				load = false,
				save = true
			}
		},
		player_stats = {
			type = "compound",
			data = {},
			set = function(self, stat, value)
				self.data[stat] = value
			end,
			get = function(self, stat)
				return self.data[stat]
			end,
			increment = function(self, stat, value)
				self.data[stat] = self.data[stat] + value
			end,
			decrement = function(self, stat, value)
				self.data[stat] = self.data[stat] - value
			end,
			value = function(self, stat)
				return self.data[stat]
			end,
			get_backend_data = function(self, profile_id)
				local data = {}

				for stat_name, value in pairs(self.data) do
					if value > 0 then
						data[#data + 1] = {
							scopes = 0,
							key = stat_name,
							value = value
						}
					end
				end

				return data
			end,
			backend = {
				load = false,
				save = true
			}
		}
	}
}

for name, props in pairs(Gear) do
	if props.attacks then
		local stats_table = {
			knockdowns = 0,
			misses = 0,
			parries = 0,
			instakills = 0
		}

		for zone_name, zone in pairs(PlayerUnitDamageSettings.hit_zones) do
			stats_table[zone.hit_stat] = 0
			stats_table[zone.damage_stat] = 0
		end

		StatsContexts.player.weapon_stats.data[name] = stats_table
	end
end

StatsContexts.player.player_stats.data = {
	arena_round_won = 0,
	domination_round_played = 0,
	con_round_played = 0,
	battle_round_played = 0,
	domination_round_won = 0,
	deaths = 0,
	con_round_won = 0,
	kills = 0,
	tdm_round_played = 0,
	tdm_round_won = 0,
	battle_round_won = 0,
	arena_round_played = 0,
	revives = 0
}

for id, _ in pairs(Achievements.COLLECTION) do
	StatsContexts.player["achievement_" .. id] = {
		value = false,
		backend = {
			load = false,
			save = false
		}
	}
end

for name, _ in pairs(Prizes.COLLECTION) do
	StatsContexts.player[name] = {
		value = 0,
		backend = {
			save_mode = "inc",
			save = true,
			load = false
		}
	}
end

for name, props in pairs(Medals.COLLECTION) do
	StatsContexts.player[name] = {
		value = false,
		backend = {
			save_mode = "set",
			save = true,
			load = true
		}
	}
end
