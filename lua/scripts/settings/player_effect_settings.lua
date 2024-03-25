-- chunkname: @scripts/settings/player_effect_settings.lua

Buffs = Buffs or {}
Buffs.courage = Buffs.courage or {}
Buffs.courage.charge_time = 1
Buffs.courage.activation_time = 1.3
Buffs.courage.duration = 30
Buffs.courage.cooldown_time = 90
Buffs.courage.multiplier = 1
Buffs.courage.hud_icon = "hud_buff_icon_health_small"
Buffs.courage.hud_timer_material = "hud_buff_cooldown_timer_four"
Buffs.courage.game_obj_level_key = "courage_level"
Buffs.courage.game_obj_end_time_key = "courage_end_time"
Debuffs = Debuffs or {}
Debuffs.last_stand = Debuffs.last_stand or {}
Debuffs.last_stand.dps = 2
Debuffs.last_stand.duration = 10
Debuffs.last_stand.threshold = 0.8
Debuffs.last_stand.max_dot_amount = 1
Debuffs.last_stand.hud_icon = "hud_debuff_icon_wounded_small"
Debuffs.last_stand.hud_timer_material = "hud_debuff_cooldown_timer_one"
Debuffs.bleeding = Debuffs.bleeding or {}
Debuffs.bleeding.dps = 2
Debuffs.bleeding.duration = 12
Debuffs.bleeding.max_dot_amount = 3
Debuffs.bleeding.hud_icon = "hud_debuff_icon_bleed_small"
Debuffs.bleeding.hud_timer_material = "hud_debuff_cooldown_timer_two"
Debuffs.burning = Debuffs.burning or {}
Debuffs.burning.duration = 6
Debuffs.burning.dps = 4
Debuffs.burning.max_dot_amount = 1
Debuffs.burning.hud_icon = "hud_debuff_icon_burn_small"
Debuffs.burning.hud_timer_material = "hud_debuff_cooldown_timer_three"
Debuffs.burning.fx_name = "fx/fire_dot"
Debuffs.burning.fx_node = "Spine2"
Debuffs.arrow = Debuffs.arrow or {}
Debuffs.arrow.duration = 20
Debuffs.arrow.hud_icon = "hud_debuff_icon_arrow_small"
Debuffs.arrow.hud_timer_material = "hud_debuff_cooldown_timer_four"
BuffLevelMultiplierFunctions = {
	reinforce = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 1.05
		elseif level == 3 then
			return 1.09318181818182
		elseif level == 4 then
			return 1.11477272727272
		elseif level == 5 then
			return 1.12556818181818
		elseif level == 6 then
			return 1.1309659090909
		elseif level == 7 then
			return 1.13366477272727
		else
			return 1.13636363636363
		end
	end,
	replenish = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 2
		elseif level == 3 then
			return 2.5
		elseif level == 4 then
			return 2.75
		elseif level == 5 then
			return 2.875
		elseif level == 6 then
			return 2.9375
		elseif level == 7 then
			return 2.96875
		else
			return 3
		end
	end,
	regen = function(level)
		if level == 0 then
			return 0
		elseif level == 1 then
			return 0
		elseif level == 2 then
			return 1
		elseif level == 3 then
			return 1
		elseif level == 4 then
			return 1
		elseif level == 5 then
			return 1
		elseif level == 6 then
			return 1
		elseif level == 7 then
			return 1
		else
			return 1
		end
	end,
	courage = function(level)
		if level == 0 then
			return 0
		elseif level == 1 then
			return 2.5
		elseif level == 2 then
			return 2.5
		elseif level == 3 then
			return 2.5
		elseif level == 4 then
			return 2.5
		elseif level == 5 then
			return 2.5
		elseif level == 6 then
			return 2.5
		elseif level == 7 then
			return 2.5
		else
			return 0
		end
	end,
	armour = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 1.05
		elseif level == 3 then
			return 1.09318181818182
		elseif level == 4 then
			return 1.11477272727272
		elseif level == 5 then
			return 1.12556818181818
		elseif level == 6 then
			return 1.1309659090909
		elseif level == 7 then
			return 1.13366477272727
		else
			return 1.13636363636363
		end
	end,
	march_speed = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 1.05
		elseif level == 3 then
			return 1.075
		elseif level == 4 then
			return 1.0875
		elseif level == 5 then
			return 1.09375
		elseif level == 6 then
			return 1.096875
		elseif level == 7 then
			return 1.0984375
		else
			return 1.1
		end
	end,
	mounted_speed = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 1.05
		elseif level == 3 then
			return 1.075
		elseif level == 4 then
			return 1.0875
		elseif level == 5 then
			return 1.09375
		elseif level == 6 then
			return 1.096875
		elseif level == 7 then
			return 1.0984375
		else
			return 1.1
		end
	end,
	berserker = function(level)
		if level == 0 then
			return 1
		elseif level == 1 then
			return 1
		elseif level == 2 then
			return 1.5
		elseif level == 3 then
			return 1.75
		elseif level == 4 then
			return 1.875
		elseif level == 5 then
			return 1.9375
		elseif level == 6 then
			return 1.96875
		elseif level == 7 then
			return 1.984375
		else
			return 2
		end
	end
}
PlayerEffectHUDSettings = {
	buffs = {
		container_position_y = -0.17,
		container_position_x = -0.12
	},
	debuffs = {
		container_position_y = -0.17,
		container_position_x = 0.12
	}
}
AreaBuffSettings = AreaBuffsettings or {}
AreaBuffSettings.FADE_TIME = 5
AreaBuffSettings.RANGE = 30
