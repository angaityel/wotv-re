-- chunkname: @scripts/settings/gear.lua

require("scripts/settings/gear_templates")

GearCategories = {
	"spear_category_0",
	"spear_category_1",
	"spear_category_2",
	"spear_category_3",
	"spear_category_4",
	"1h_axe_category_5",
	"1h_axe_category_9",
	"1h_axe_category_6",
	"1h_axe_category_7",
	"1h_axe_category_8",
	"1h_axe_category_10",
	"2h_axe_category_10",
	"2h_axe_category_11",
	"2h_axe_category_12",
	"2h_axe_category_13",
	"2h_axe_category_14",
	"longbow_category_15",
	"longbow_category_16",
	"huntingbow_category_7",
	"huntingbow_category_8",
	"throwing_dagger_category_19",
	"throwing_axe_category_21",
	"throwing_spear_category_23",
	"throwing_dagger_category_20",
	"throwing_axe_category_22",
	"1h_sword_category_1",
	"1h_sword_category_2",
	"1h_sword_category_3",
	"1h_sword_category_4",
	"1h_sword_category_5",
	"1h_sword_category_6",
	"1h_sword_category_7",
	"1h_sword_category_9",
	"1h_sword_category_10",
	"1h_sword_category_11",
	"1h_sword_category_12",
	"1h_sword_category_13",
	"shield_category_34",
	"shield_category_new"
}
AllGear = {}
AllGear.viking_dagger = AllGear.viking_dagger or table.clone(GearTemplates.dagger)
AllGear.viking_dagger.unit = "units/weapons/be_wpn_viking_dagger/be_wpn_viking_dagger"
AllGear.viking_dagger.release_name = "main"
AllGear.viking_dagger.ui_sort_index = 1
AllGear.viking_dagger.ui_texture = "default"
AllGear.viking_dagger.market_price = 1000
AllGear.viking_dagger.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_02_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_02_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_02"
AllGear.sword_kit_sword_02_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_02_worn.market_price = 540
AllGear.sword_kit_sword_02_worn.release_name = "main"
AllGear.sword_kit_sword_02_worn.ui_sort_index = 4
AllGear.sword_kit_sword_02_worn.ui_texture = "sword_02_1"
AllGear.sword_kit_sword_02_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_02_worn.extravagance = 1
AllGear.sword_kit_sword_02_worn.tier = 27
AllGear.sword_kit_sword_07_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_07_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_07"
AllGear.sword_kit_sword_07_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_07_worn.market_price = 2380
AllGear.sword_kit_sword_07_worn.release_name = "main"
AllGear.sword_kit_sword_07_worn.ui_sort_index = 19
AllGear.sword_kit_sword_07_worn.ui_texture = "sword_07_1"
AllGear.sword_kit_sword_07_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_07_worn.extravagance = 1
AllGear.sword_kit_sword_07_worn.tier = 32
AllGear.sword_kit_sword_01_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_01_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_01"
AllGear.sword_kit_sword_01_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_01_worn.market_price = 320
AllGear.sword_kit_sword_01_worn.release_name = "main"
AllGear.sword_kit_sword_01_worn.ui_sort_index = 1
AllGear.sword_kit_sword_01_worn.ui_texture = "sword_01_1"
AllGear.sword_kit_sword_01_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_01_worn.extravagance = 1
AllGear.sword_kit_sword_01_worn.tier = 26
AllGear.sword_kit_sword_10_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_10_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_010"
AllGear.sword_kit_sword_10_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_10_worn.market_price = 3940
AllGear.sword_kit_sword_10_worn.release_name = "main"
AllGear.sword_kit_sword_10_worn.ui_sort_index = 28
AllGear.sword_kit_sword_10_worn.ui_texture = "sword_10_1"
AllGear.sword_kit_sword_10_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_10_worn.extravagance = 1
AllGear.sword_kit_sword_10_worn.tier = 35
AllGear.sword_kit_sword_03_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_03_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_03"
AllGear.sword_kit_sword_03_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_03_worn.market_price = 780
AllGear.sword_kit_sword_03_worn.release_name = "main"
AllGear.sword_kit_sword_03_worn.ui_sort_index = 7
AllGear.sword_kit_sword_03_worn.ui_texture = "sword_03_1"
AllGear.sword_kit_sword_03_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_03_worn.extravagance = 1
AllGear.sword_kit_sword_03_worn.tier = 28
AllGear.sword_kit_sword_06_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_06_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_06"
AllGear.sword_kit_sword_06_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_06_worn.market_price = 2150
AllGear.sword_kit_sword_06_worn.release_name = "main"
AllGear.sword_kit_sword_06_worn.ui_sort_index = 16
AllGear.sword_kit_sword_06_worn.ui_texture = "sword_06_1"
AllGear.sword_kit_sword_06_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_06_worn.extravagance = 1
AllGear.sword_kit_sword_06_worn.tier = 31
AllGear.sword_kit_sword_05_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_05_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_05"
AllGear.sword_kit_sword_05_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_05_worn.market_price = 1760
AllGear.sword_kit_sword_05_worn.release_name = "main"
AllGear.sword_kit_sword_05_worn.ui_sort_index = 13
AllGear.sword_kit_sword_05_worn.ui_texture = "sword_05_1"
AllGear.sword_kit_sword_05_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_05_worn.extravagance = 1
AllGear.sword_kit_sword_05_worn.tier = 30
AllGear.sword_kit_sword_04_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_04_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_04"
AllGear.sword_kit_sword_04_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_04_worn.market_price = 1140
AllGear.sword_kit_sword_04_worn.release_name = "main"
AllGear.sword_kit_sword_04_worn.ui_sort_index = 10
AllGear.sword_kit_sword_04_worn.ui_texture = "sword_04_1"
AllGear.sword_kit_sword_04_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_04_worn.extravagance = 1
AllGear.sword_kit_sword_04_worn.tier = 29
AllGear.sword_kit_sword_09_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_09_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_09"
AllGear.sword_kit_sword_09_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_09_worn.market_price = 3550
AllGear.sword_kit_sword_09_worn.release_name = "main"
AllGear.sword_kit_sword_09_worn.ui_sort_index = 25
AllGear.sword_kit_sword_09_worn.ui_texture = "sword_09_1"
AllGear.sword_kit_sword_09_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_09_worn.extravagance = 1
AllGear.sword_kit_sword_09_worn.tier = 34
AllGear.sword_kit_sword_08_worn = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_08_worn.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_08"
AllGear.sword_kit_sword_08_worn.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_worn"
AllGear.sword_kit_sword_08_worn.market_price = 3120
AllGear.sword_kit_sword_08_worn.release_name = "main"
AllGear.sword_kit_sword_08_worn.ui_sort_index = 22
AllGear.sword_kit_sword_08_worn.ui_texture = "sword_08_1"
AllGear.sword_kit_sword_08_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_08_worn.extravagance = 1
AllGear.sword_kit_sword_08_worn.tier = 33
AllGear.sword_kit_sword_02 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_02.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_02"
AllGear.sword_kit_sword_02.market_price = 1080
AllGear.sword_kit_sword_02.release_name = "main"
AllGear.sword_kit_sword_02.ui_sort_index = 5
AllGear.sword_kit_sword_02.ui_texture = "sword_02_2"
AllGear.sword_kit_sword_02.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_02.extravagance = 2
AllGear.sword_kit_sword_02.tier = 27
AllGear.sword_kit_sword_05 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_05.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_05"
AllGear.sword_kit_sword_05.market_price = 3340
AllGear.sword_kit_sword_05.release_name = "main"
AllGear.sword_kit_sword_05.ui_sort_index = 14
AllGear.sword_kit_sword_05.ui_texture = "sword_05_2"
AllGear.sword_kit_sword_05.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_05.extravagance = 2
AllGear.sword_kit_sword_05.tier = 30
AllGear.sword_kit_sword_07 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_07.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_07"
AllGear.sword_kit_sword_07.market_price = 8440
AllGear.sword_kit_sword_07.release_name = "main"
AllGear.sword_kit_sword_07.ui_sort_index = 20
AllGear.sword_kit_sword_07.ui_texture = "sword_07_2"
AllGear.sword_kit_sword_07.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_07.extravagance = 2
AllGear.sword_kit_sword_07.tier = 32
AllGear.sword_kit_sword_06 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_06.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_06"
AllGear.sword_kit_sword_06.market_price = 6100
AllGear.sword_kit_sword_06.release_name = "main"
AllGear.sword_kit_sword_06.ui_sort_index = 17
AllGear.sword_kit_sword_06.ui_texture = "sword_06_2"
AllGear.sword_kit_sword_06.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_06.extravagance = 2
AllGear.sword_kit_sword_06.tier = 31
AllGear.sword_kit_sword_010 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_010.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_010"
AllGear.sword_kit_sword_010.market_price = 14800
AllGear.sword_kit_sword_010.release_name = "main"
AllGear.sword_kit_sword_010.ui_sort_index = 29
AllGear.sword_kit_sword_010.ui_texture = "sword_10_2"
AllGear.sword_kit_sword_010.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_010.extravagance = 2
AllGear.sword_kit_sword_010.tier = 35
AllGear.sword_kit_sword_01 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_01.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_01"
AllGear.sword_kit_sword_01.market_price = 620
AllGear.sword_kit_sword_01.release_name = "main"
AllGear.sword_kit_sword_01.ui_sort_index = 2
AllGear.sword_kit_sword_01.ui_texture = "sword_01_2"
AllGear.sword_kit_sword_01.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_01.extravagance = 2
AllGear.sword_kit_sword_01.tier = 26
AllGear.sword_kit_sword_08 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_08.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_08"
AllGear.sword_kit_sword_08.market_price = 10400
AllGear.sword_kit_sword_08.release_name = "main"
AllGear.sword_kit_sword_08.ui_sort_index = 23
AllGear.sword_kit_sword_08.ui_texture = "sword_08_2"
AllGear.sword_kit_sword_08.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_08.extravagance = 2
AllGear.sword_kit_sword_08.tier = 33
AllGear.sword_kit_sword_03 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_03.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_03"
AllGear.sword_kit_sword_03.market_price = 1920
AllGear.sword_kit_sword_03.release_name = "main"
AllGear.sword_kit_sword_03.ui_sort_index = 8
AllGear.sword_kit_sword_03.ui_texture = "sword_03_2"
AllGear.sword_kit_sword_03.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_03.extravagance = 2
AllGear.sword_kit_sword_03.tier = 28
AllGear.sword_kit_sword_04 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_04.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_04"
AllGear.sword_kit_sword_04.market_price = 2780
AllGear.sword_kit_sword_04.release_name = "main"
AllGear.sword_kit_sword_04.ui_sort_index = 11
AllGear.sword_kit_sword_04.ui_texture = "sword_04_2"
AllGear.sword_kit_sword_04.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_04.extravagance = 2
AllGear.sword_kit_sword_04.tier = 29
AllGear.sword_kit_sword_09 = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_09.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_09"
AllGear.sword_kit_sword_09.market_price = 12600
AllGear.sword_kit_sword_09.release_name = "main"
AllGear.sword_kit_sword_09.ui_sort_index = 26
AllGear.sword_kit_sword_09.ui_texture = "sword_09_2"
AllGear.sword_kit_sword_09.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_09.extravagance = 2
AllGear.sword_kit_sword_09.tier = 34
AllGear.sword_kit_sword_06_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_06_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_06"
AllGear.sword_kit_sword_06_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_06_gold.market_price = 12600
AllGear.sword_kit_sword_06_gold.release_name = "main"
AllGear.sword_kit_sword_06_gold.ui_sort_index = 18
AllGear.sword_kit_sword_06_gold.ui_texture = "sword_06_3"
AllGear.sword_kit_sword_06_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_06_gold.extravagance = 3
AllGear.sword_kit_sword_06_gold.tier = 31
AllGear.sword_kit_sword_03_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_03_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_03"
AllGear.sword_kit_sword_03_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_03_gold.market_price = 6020
AllGear.sword_kit_sword_03_gold.release_name = "main"
AllGear.sword_kit_sword_03_gold.ui_sort_index = 9
AllGear.sword_kit_sword_03_gold.ui_texture = "sword_03_3"
AllGear.sword_kit_sword_03_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_03_gold.extravagance = 3
AllGear.sword_kit_sword_03_gold.tier = 28
AllGear.sword_kit_sword_05_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_05_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_05"
AllGear.sword_kit_sword_05_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_05_gold.market_price = 8320
AllGear.sword_kit_sword_05_gold.release_name = "main"
AllGear.sword_kit_sword_05_gold.ui_sort_index = 15
AllGear.sword_kit_sword_05_gold.ui_texture = "sword_05_3"
AllGear.sword_kit_sword_05_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_05_gold.extravagance = 3
AllGear.sword_kit_sword_05_gold.tier = 30
AllGear.sword_kit_sword_08_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_08_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_08"
AllGear.sword_kit_sword_08_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_08_gold.market_price = 23500
AllGear.sword_kit_sword_08_gold.release_name = "main"
AllGear.sword_kit_sword_08_gold.ui_sort_index = 24
AllGear.sword_kit_sword_08_gold.ui_texture = "sword_08_3"
AllGear.sword_kit_sword_08_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_08_gold.extravagance = 3
AllGear.sword_kit_sword_08_gold.tier = 33
AllGear.sword_kit_sword_04_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_04_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_04"
AllGear.sword_kit_sword_04_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_04_gold.market_price = 7240
AllGear.sword_kit_sword_04_gold.release_name = "main"
AllGear.sword_kit_sword_04_gold.ui_sort_index = 12
AllGear.sword_kit_sword_04_gold.ui_texture = "sword_04_3"
AllGear.sword_kit_sword_04_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_04_gold.extravagance = 3
AllGear.sword_kit_sword_04_gold.tier = 29
AllGear.sword_kit_sword_10_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_10_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_010"
AllGear.sword_kit_sword_10_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_10_gold.market_price = 28200
AllGear.sword_kit_sword_10_gold.release_name = "main"
AllGear.sword_kit_sword_10_gold.ui_sort_index = 30
AllGear.sword_kit_sword_10_gold.ui_texture = "sword_10_3"
AllGear.sword_kit_sword_10_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_10_gold.extravagance = 3
AllGear.sword_kit_sword_10_gold.tier = 35
AllGear.sword_kit_sword_07_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_07_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_07"
AllGear.sword_kit_sword_07_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_07_gold.market_price = 18200
AllGear.sword_kit_sword_07_gold.release_name = "main"
AllGear.sword_kit_sword_07_gold.ui_sort_index = 21
AllGear.sword_kit_sword_07_gold.ui_texture = "sword_07_3"
AllGear.sword_kit_sword_07_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_07_gold.extravagance = 3
AllGear.sword_kit_sword_07_gold.tier = 32
AllGear.sword_kit_sword_02_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_02_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_02"
AllGear.sword_kit_sword_02_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_02_gold.market_price = 5120
AllGear.sword_kit_sword_02_gold.release_name = "main"
AllGear.sword_kit_sword_02_gold.ui_sort_index = 6
AllGear.sword_kit_sword_02_gold.ui_texture = "sword_02_3"
AllGear.sword_kit_sword_02_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_02_gold.extravagance = 3
AllGear.sword_kit_sword_02_gold.tier = 27
AllGear.sword_kit_sword_09_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_09_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_09"
AllGear.sword_kit_sword_09_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_09_gold.market_price = 27400
AllGear.sword_kit_sword_09_gold.release_name = "main"
AllGear.sword_kit_sword_09_gold.ui_sort_index = 27
AllGear.sword_kit_sword_09_gold.ui_texture = "sword_09_3"
AllGear.sword_kit_sword_09_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_09_gold.extravagance = 3
AllGear.sword_kit_sword_09_gold.tier = 34
AllGear.sword_kit_sword_01_gold = table.clone(GearTemplates.sword_1h)
AllGear.sword_kit_sword_01_gold.unit = "units/weapons/wpn_sword_kit/wpn_sword_kit_sword_01"
AllGear.sword_kit_sword_01_gold.material_variation = "units/weapons/wpn_sword_kit/wpn_sword_kit_gold"
AllGear.sword_kit_sword_01_gold.market_price = 4100
AllGear.sword_kit_sword_01_gold.release_name = "main"
AllGear.sword_kit_sword_01_gold.ui_sort_index = 3
AllGear.sword_kit_sword_01_gold.ui_texture = "sword_01_3"
AllGear.sword_kit_sword_01_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.sword_kit_sword_01_gold.extravagance = 3
AllGear.sword_kit_sword_01_gold.tier = 26
AllGear.ulfberht_sword = table.clone(GearTemplates.sword_1h)
AllGear.ulfberht_sword.unit = "units/weapons/be_wpn_1h_ulfberht_sword/wpn_1h_ulfberht_sword"
AllGear.ulfberht_sword.market_price = 37600
AllGear.ulfberht_sword.release_name = "main"
AllGear.ulfberht_sword.ui_sort_index = 31
AllGear.ulfberht_sword.ui_texture = "sword_11_1"
AllGear.ulfberht_sword.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.ulfberht_sword.extravagance = 3
AllGear.ulfberht_sword.tier = 36
AllGear.ulfberht_sword_02 = table.clone(GearTemplates.sword_1h)
AllGear.ulfberht_sword_02.unit = "units/weapons/be_wpn_1h_ulfberht_sword/wpn_1h_ulfberht_sword"
AllGear.ulfberht_sword_02.material_variation = "units/weapons/be_wpn_1h_ulfberht_sword/wpn_1h_ulfberht_sword_02"
AllGear.ulfberht_sword_02.market_price = 42000
AllGear.ulfberht_sword_02.release_name = "main"
AllGear.ulfberht_sword_02.ui_sort_index = 32
AllGear.ulfberht_sword_02.ui_texture = "sword_11_2"
AllGear.ulfberht_sword_02.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.ulfberht_sword_02.extravagance = 3
AllGear.ulfberht_sword_02.tier = 36
AllGear.broadsword = table.clone(GearTemplates.sword_1h)
AllGear.broadsword.unit = "units/weapons/be_wpn_broadsword/be_wpn_broadsword"
AllGear.broadsword.market_price = 47600
AllGear.broadsword.release_name = "vanguard"
AllGear.broadsword.ui_sort_index = 33
AllGear.broadsword.ui_texture = "sword_broad_sword"
AllGear.broadsword.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.broadsword.extravagance = 3
AllGear.broadsword.tier = 37
AllGear.viking_axe_11 = AllGear.viking_axe_11 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_11.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_11"
AllGear.viking_axe_11.market_price = 820
AllGear.viking_axe_11.release_name = "main"
AllGear.viking_axe_11.ui_sort_index = 1
AllGear.viking_axe_11.ui_texture = "axe_01_1"
AllGear.viking_axe_11.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_11.extravagance = 1
AllGear.viking_axe_11.tier = 7
AllGear.viking_axe_21 = AllGear.viking_axe_21 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_21.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_21"
AllGear.viking_axe_21.market_price = 4400
AllGear.viking_axe_21.release_name = "main"
AllGear.viking_axe_21.ui_sort_index = 13
AllGear.viking_axe_21.ui_texture = "axe_02_1"
AllGear.viking_axe_21.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_21.extravagance = 1
AllGear.viking_axe_21.tier = 10
AllGear.viking_axe_51 = AllGear.viking_axe_51 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_51.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_51"
AllGear.viking_axe_51.market_price = 3200
AllGear.viking_axe_51.release_name = "main"
AllGear.viking_axe_51.ui_sort_index = 4
AllGear.viking_axe_51.ui_texture = "axe_05_1"
AllGear.viking_axe_51.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_51.extravagance = 1
AllGear.viking_axe_51.tier = 9
AllGear.viking_axe_31 = AllGear.viking_axe_31 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_31.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_31"
AllGear.viking_axe_31.market_price = 1640
AllGear.viking_axe_31.release_name = "main"
AllGear.viking_axe_31.ui_sort_index = 7
AllGear.viking_axe_31.ui_texture = "axe_03_1"
AllGear.viking_axe_31.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_31.extravagance = 1
AllGear.viking_axe_31.tier = 8
AllGear.viking_axe_41 = AllGear.viking_axe_41 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_41.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_41"
AllGear.viking_axe_41.market_price = 460
AllGear.viking_axe_41.release_name = "main"
AllGear.viking_axe_41.ui_sort_index = 10
AllGear.viking_axe_41.ui_texture = "axe_04_1"
AllGear.viking_axe_41.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_41.extravagance = 1
AllGear.viking_axe_41.tier = 6
AllGear.viking_axe_12 = AllGear.viking_axe_12 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_12.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_12"
AllGear.viking_axe_12.market_price = 2840
AllGear.viking_axe_12.release_name = "main"
AllGear.viking_axe_12.ui_sort_index = 2
AllGear.viking_axe_12.ui_texture = "axe_01_2"
AllGear.viking_axe_12.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_12.extravagance = 2
AllGear.viking_axe_12.tier = 7
AllGear.viking_axe_22 = AllGear.viking_axe_22 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_22.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_22"
AllGear.viking_axe_22.market_price = 12600
AllGear.viking_axe_22.release_name = "main"
AllGear.viking_axe_22.ui_sort_index = 14
AllGear.viking_axe_22.ui_texture = "axe_02_2"
AllGear.viking_axe_22.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_22.extravagance = 2
AllGear.viking_axe_22.tier = 10
AllGear.viking_axe_52 = AllGear.viking_axe_52 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_52.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_52"
AllGear.viking_axe_52.market_price = 9400
AllGear.viking_axe_52.release_name = "main"
AllGear.viking_axe_52.ui_sort_index = 5
AllGear.viking_axe_52.ui_texture = "axe_05_2"
AllGear.viking_axe_52.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_52.extravagance = 2
AllGear.viking_axe_52.tier = 9
AllGear.viking_axe_32 = AllGear.viking_axe_32 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_32.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_32"
AllGear.viking_axe_32.market_price = 4240
AllGear.viking_axe_32.release_name = "main"
AllGear.viking_axe_32.ui_sort_index = 8
AllGear.viking_axe_32.ui_texture = "axe_03_2"
AllGear.viking_axe_32.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_32.extravagance = 2
AllGear.viking_axe_32.tier = 8
AllGear.viking_axe_42 = AllGear.viking_axe_42 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_42.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_42"
AllGear.viking_axe_42.market_price = 2100
AllGear.viking_axe_42.release_name = "main"
AllGear.viking_axe_42.ui_sort_index = 11
AllGear.viking_axe_42.ui_texture = "axe_04_2"
AllGear.viking_axe_42.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_42.extravagance = 2
AllGear.viking_axe_42.tier = 6
AllGear.viking_axe_43 = AllGear.viking_axe_43 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_43.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_43"
AllGear.viking_axe_43.market_price = 4200
AllGear.viking_axe_43.release_name = "main"
AllGear.viking_axe_43.ui_sort_index = 12
AllGear.viking_axe_43.ui_texture = "axe_04_3"
AllGear.viking_axe_43.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_43.extravagance = 3
AllGear.viking_axe_43.tier = 6
AllGear.viking_axe_33 = AllGear.viking_axe_33 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_33.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_33"
AllGear.viking_axe_33.market_price = 9400
AllGear.viking_axe_33.release_name = "main"
AllGear.viking_axe_33.ui_sort_index = 9
AllGear.viking_axe_33.ui_texture = "axe_03_3"
AllGear.viking_axe_33.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_33.extravagance = 3
AllGear.viking_axe_33.tier = 8
AllGear.viking_axe_13 = AllGear.viking_axe_13 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_13.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_13"
AllGear.viking_axe_13.market_price = 5900
AllGear.viking_axe_13.release_name = "main"
AllGear.viking_axe_13.ui_sort_index = 3
AllGear.viking_axe_13.ui_texture = "axe_01_3"
AllGear.viking_axe_13.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_13.extravagance = 3
AllGear.viking_axe_13.tier = 7
AllGear.viking_axe_23 = AllGear.viking_axe_23 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_23.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_23"
AllGear.viking_axe_23.market_price = 28600
AllGear.viking_axe_23.release_name = "main"
AllGear.viking_axe_23.ui_sort_index = 15
AllGear.viking_axe_23.ui_texture = "axe_02_3"
AllGear.viking_axe_23.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_23.extravagance = 3
AllGear.viking_axe_23.tier = 10
AllGear.viking_axe_53 = AllGear.viking_axe_53 or table.clone(GearTemplates.axe_1h)
AllGear.viking_axe_53.unit = "units/weapons/be_wpn_axe_kit/wpn_1h_axe_53"
AllGear.viking_axe_53.market_price = 22000
AllGear.viking_axe_53.release_name = "main"
AllGear.viking_axe_53.ui_sort_index = 6
AllGear.viking_axe_53.ui_texture = "axe_05_3"
AllGear.viking_axe_53.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_axe_53.extravagance = 3
AllGear.viking_axe_53.tier = 9
AllGear.agile_axe = AllGear.agile_axe or table.clone(GearTemplates.axe_1h)
AllGear.agile_axe.unit = "units/weapons/be_wpn_agile_axe/be_wpn_agile_axe"
AllGear.agile_axe.market_price = 34600
AllGear.agile_axe.release_name = "berserk"
AllGear.agile_axe.ui_sort_index = 16
AllGear.agile_axe.ui_texture = "axe_agile"
AllGear.agile_axe.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.agile_axe.extravagance = 3
AllGear.agile_axe.tier = 11
AllGear.munin_axe = AllGear.munin_axe or table.clone(GearTemplates.axe_1h)
AllGear.munin_axe.unit = "units/weapons/be_wpn_1h_axe_hugin_munin/be_wpn_1h_axe_hugin_munin"
AllGear.munin_axe.material_variation = "units/weapons/be_wpn_1h_axe_hugin_munin/be_wpn_1h_axe_hugin_munin"
AllGear.munin_axe.market_price = 1000
AllGear.munin_axe.release_name = "berserk"
AllGear.munin_axe.ui_sort_index = 17
AllGear.munin_axe.ui_texture = "berserker_axe_01"
AllGear.munin_axe.extravagance = 3
AllGear.munin_axe.tier = 11
AllGear.hugin_axe = AllGear.hugin_axe or table.clone(GearTemplates.axe_1h)
AllGear.hugin_axe.unit = "units/weapons/be_wpn_1h_axe_hugin_munin/be_wpn_1h_axe_hugin_munin"
AllGear.hugin_axe.material_variation = "units/weapons/be_wpn_1h_axe_hugin_munin/be_wpn_1h_axe_hugin_munin_gold"
AllGear.hugin_axe.market_price = 1000
AllGear.hugin_axe.release_name = "berserk"
AllGear.hugin_axe.ui_sort_index = 18
AllGear.hugin_axe.ui_texture = "berserker_axe_02"
AllGear.hugin_axe.extravagance = 3
AllGear.hugin_axe.tier = 11
AllGear.twohanded_axe_11 = AllGear.twohanded_axe_11 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_11.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_11"
AllGear.twohanded_axe_11.market_price = 6300
AllGear.twohanded_axe_11.release_name = "main"
AllGear.twohanded_axe_11.ui_sort_index = 13
AllGear.twohanded_axe_11.ui_texture = "two_handed_axe_01_1"
AllGear.twohanded_axe_11.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_11.extravagance = 1
AllGear.twohanded_axe_11.tier = 16
AllGear.twohanded_axe_21 = AllGear.twohanded_axe_21 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_21.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_21"
AllGear.twohanded_axe_21.market_price = 1440
AllGear.twohanded_axe_21.release_name = "main"
AllGear.twohanded_axe_21.ui_sort_index = 4
AllGear.twohanded_axe_21.ui_texture = "two_handed_axe_02_1"
AllGear.twohanded_axe_21.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_21.extravagance = 1
AllGear.twohanded_axe_21.tier = 13
AllGear.twohanded_axe_31 = AllGear.twohanded_axe_31 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_31.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_31"
AllGear.twohanded_axe_31.market_price = 3600
AllGear.twohanded_axe_31.release_name = "main"
AllGear.twohanded_axe_31.ui_sort_index = 7
AllGear.twohanded_axe_31.ui_texture = "two_handed_axe_03_1"
AllGear.twohanded_axe_31.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_31.extravagance = 1
AllGear.twohanded_axe_31.tier = 14
AllGear.twohanded_axe_41 = AllGear.twohanded_axe_41 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_41.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_41"
AllGear.twohanded_axe_41.market_price = 4900
AllGear.twohanded_axe_41.release_name = "main"
AllGear.twohanded_axe_41.ui_sort_index = 7
AllGear.twohanded_axe_41.ui_texture = "two_handed_axe_04_1"
AllGear.twohanded_axe_41.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_41.extravagance = 1
AllGear.twohanded_axe_41.tier = 15
AllGear.twohanded_axe_51 = AllGear.twohanded_axe_51 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_51.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_51"
AllGear.twohanded_axe_51.market_price = 280
AllGear.twohanded_axe_51.release_name = "main"
AllGear.twohanded_axe_51.ui_sort_index = 1
AllGear.twohanded_axe_51.ui_texture = "two_handed_axe_05_1"
AllGear.twohanded_axe_51.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_51.extravagance = 1
AllGear.twohanded_axe_51.tier = 12
AllGear.twohanded_axe_12 = AllGear.twohanded_axe_12 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_12.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_12"
AllGear.twohanded_axe_12.market_price = 13900
AllGear.twohanded_axe_12.release_name = "main"
AllGear.twohanded_axe_12.ui_sort_index = 14
AllGear.twohanded_axe_12.ui_texture = "two_handed_axe_01_2"
AllGear.twohanded_axe_12.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_12.extravagance = 2
AllGear.twohanded_axe_12.tier = 16
AllGear.twohanded_axe_22 = AllGear.twohanded_axe_22 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_22.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_22"
AllGear.twohanded_axe_22.market_price = 4900
AllGear.twohanded_axe_22.release_name = "main"
AllGear.twohanded_axe_22.ui_sort_index = 5
AllGear.twohanded_axe_22.ui_texture = "two_handed_axe_02_2"
AllGear.twohanded_axe_22.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_22.extravagance = 2
AllGear.twohanded_axe_22.tier = 13
AllGear.twohanded_axe_32 = AllGear.twohanded_axe_32 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_32.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_32"
AllGear.twohanded_axe_32.market_price = 7200
AllGear.twohanded_axe_32.release_name = "main"
AllGear.twohanded_axe_32.ui_sort_index = 11
AllGear.twohanded_axe_32.ui_texture = "two_handed_axe_03_2"
AllGear.twohanded_axe_32.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_32.extravagance = 2
AllGear.twohanded_axe_32.tier = 14
AllGear.twohanded_axe_42 = AllGear.twohanded_axe_42 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_42.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_42"
AllGear.twohanded_axe_42.market_price = 9800
AllGear.twohanded_axe_42.release_name = "main"
AllGear.twohanded_axe_42.ui_sort_index = 8
AllGear.twohanded_axe_42.ui_texture = "two_handed_axe_04_2"
AllGear.twohanded_axe_42.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_42.extravagance = 2
AllGear.twohanded_axe_42.tier = 15
AllGear.twohanded_axe_52 = AllGear.twohanded_axe_52 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_52.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_52"
AllGear.twohanded_axe_52.market_price = 2280
AllGear.twohanded_axe_52.release_name = "main"
AllGear.twohanded_axe_52.ui_sort_index = 2
AllGear.twohanded_axe_52.ui_texture = "two_handed_axe_05_2"
AllGear.twohanded_axe_52.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_52.extravagance = 2
AllGear.twohanded_axe_52.tier = 12
AllGear.twohanded_axe_23 = AllGear.twohanded_axe_23 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_23.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_23"
AllGear.twohanded_axe_23.market_price = 11200
AllGear.twohanded_axe_23.release_name = "main"
AllGear.twohanded_axe_23.ui_sort_index = 6
AllGear.twohanded_axe_23.ui_texture = "two_handed_axe_02_3"
AllGear.twohanded_axe_23.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_23.extravagance = 3
AllGear.twohanded_axe_23.tier = 13
AllGear.twohanded_axe_13 = AllGear.twohanded_axe_13 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_13.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_13"
AllGear.twohanded_axe_13.market_price = 31800
AllGear.twohanded_axe_13.release_name = "main"
AllGear.twohanded_axe_13.ui_sort_index = 15
AllGear.twohanded_axe_13.ui_texture = "two_handed_axe_01_3"
AllGear.twohanded_axe_13.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_13.extravagance = 3
AllGear.twohanded_axe_13.tier = 16
AllGear.twohanded_axe_33 = AllGear.twohanded_axe_33 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_33.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_33"
AllGear.twohanded_axe_33.market_price = 16400
AllGear.twohanded_axe_33.release_name = "main"
AllGear.twohanded_axe_33.ui_sort_index = 12
AllGear.twohanded_axe_33.ui_texture = "two_handed_axe_03_3"
AllGear.twohanded_axe_33.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_33.extravagance = 3
AllGear.twohanded_axe_33.tier = 14
AllGear.twohanded_axe_43 = AllGear.twohanded_axe_43 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_43.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_43"
AllGear.twohanded_axe_43.market_price = 23600
AllGear.twohanded_axe_43.release_name = "main"
AllGear.twohanded_axe_43.ui_sort_index = 9
AllGear.twohanded_axe_43.ui_texture = "two_handed_axe_04_3"
AllGear.twohanded_axe_43.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_43.extravagance = 3
AllGear.twohanded_axe_43.tier = 15
AllGear.twohanded_axe_53 = AllGear.twohanded_axe_53 or table.clone(GearTemplates.axe_2h)
AllGear.twohanded_axe_53.unit = "units/weapons/be_wpn_axe_2h_kit/wpn_2h_kit_53"
AllGear.twohanded_axe_53.market_price = 7200
AllGear.twohanded_axe_53.release_name = "main"
AllGear.twohanded_axe_53.ui_sort_index = 3
AllGear.twohanded_axe_53.ui_texture = "two_handed_axe_05_3"
AllGear.twohanded_axe_53.archetypes = {
	medium = true,
	light = false,
	heavy = true
}
AllGear.twohanded_axe_53.extravagance = 3
AllGear.twohanded_axe_53.tier = 12
AllGear.shield_maiden_spear = AllGear.shield_maiden_spear or table.clone(GearTemplates.spear)
AllGear.shield_maiden_spear.unit = "units/weapons/be_wpn_shield_maiden_spear/be_wpn_shield_maiden_spear"
AllGear.shield_maiden_spear.market_price = nil
AllGear.shield_maiden_spear.release_name = "vanguard"
AllGear.shield_maiden_spear.ui_sort_index = 1
AllGear.shield_maiden_spear.ui_texture = "shield_maiden_spear"
AllGear.shield_maiden_spear.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.shield_maiden_spear.tier = 1
AllGear.warrior_maiden_spear = AllGear.warrior_maiden_spear or table.clone(GearTemplates.spear)
AllGear.warrior_maiden_spear.unit = "units/weapons/be_wpn_warrior_maiden_spear/wpn_warrior_maiden_spear"
AllGear.warrior_maiden_spear.market_price = nil
AllGear.warrior_maiden_spear.release_name = "vanguard"
AllGear.warrior_maiden_spear.ui_sort_index = 2
AllGear.warrior_maiden_spear.ui_texture = "warrior_maiden_spear"
AllGear.warrior_maiden_spear.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.warrior_maiden_spear.tier = 1
AllGear.viking_spear_11 = AllGear.viking_spear_11 or table.clone(GearTemplates.spear)
AllGear.viking_spear_11.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_11"
AllGear.viking_spear_11.market_price = 1040
AllGear.viking_spear_11.release_name = "main"
AllGear.viking_spear_11.ui_sort_index = 1
AllGear.viking_spear_11.ui_texture = "spear_01_1"
AllGear.viking_spear_11.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_11.extravagance = 1
AllGear.viking_spear_11.tier = 3
AllGear.viking_spear_21 = AllGear.viking_spear_21 or table.clone(GearTemplates.spear)
AllGear.viking_spear_21.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_21"
AllGear.viking_spear_21.market_price = 380
AllGear.viking_spear_21.release_name = "main"
AllGear.viking_spear_21.ui_sort_index = 4
AllGear.viking_spear_21.ui_texture = "spear_02_1"
AllGear.viking_spear_21.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_21.extravagance = 1
AllGear.viking_spear_21.tier = 2
AllGear.viking_spear_31 = AllGear.viking_spear_31 or table.clone(GearTemplates.spear)
AllGear.viking_spear_31.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_31"
AllGear.viking_spear_31.market_price = 1800
AllGear.viking_spear_31.release_name = "main"
AllGear.viking_spear_31.ui_sort_index = 7
AllGear.viking_spear_31.ui_texture = "spear_03_1"
AllGear.viking_spear_31.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_31.extravagance = 1
AllGear.viking_spear_31.tier = 4
AllGear.viking_spear_41 = AllGear.viking_spear_41 or table.clone(GearTemplates.spear)
AllGear.viking_spear_41.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_41"
AllGear.viking_spear_41.market_price = 6400
AllGear.viking_spear_41.release_name = "main"
AllGear.viking_spear_41.ui_sort_index = 10
AllGear.viking_spear_41.ui_texture = "spear_04_1"
AllGear.viking_spear_41.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_41.extravagance = 1
AllGear.viking_spear_41.tier = 5
AllGear.viking_spear_12 = AllGear.viking_spear_12 or table.clone(GearTemplates.spear)
AllGear.viking_spear_12.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_12"
AllGear.viking_spear_12.market_price = 4400
AllGear.viking_spear_12.release_name = "main"
AllGear.viking_spear_12.ui_sort_index = 2
AllGear.viking_spear_12.ui_texture = "spear_01_2"
AllGear.viking_spear_12.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_12.extravagance = 2
AllGear.viking_spear_12.tier = 3
AllGear.viking_spear_22 = AllGear.viking_spear_22 or table.clone(GearTemplates.spear)
AllGear.viking_spear_22.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_22"
AllGear.viking_spear_22.market_price = 2840
AllGear.viking_spear_22.release_name = "main"
AllGear.viking_spear_22.ui_sort_index = 5
AllGear.viking_spear_22.ui_texture = "spear_02_2"
AllGear.viking_spear_22.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_22.extravagance = 2
AllGear.viking_spear_22.tier = 2
AllGear.viking_spear_42 = AllGear.viking_spear_42 or table.clone(GearTemplates.spear)
AllGear.viking_spear_42.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_42"
AllGear.viking_spear_42.market_price = 9200
AllGear.viking_spear_42.release_name = "main"
AllGear.viking_spear_42.ui_sort_index = 11
AllGear.viking_spear_42.ui_texture = "spear_04_2"
AllGear.viking_spear_42.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_42.extravagance = 2
AllGear.viking_spear_42.tier = 5
AllGear.viking_spear_32 = AllGear.viking_spear_32 or table.clone(GearTemplates.spear)
AllGear.viking_spear_32.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_32"
AllGear.viking_spear_32.market_price = 6480
AllGear.viking_spear_32.release_name = "main"
AllGear.viking_spear_32.ui_sort_index = 8
AllGear.viking_spear_32.ui_texture = "spear_03_2"
AllGear.viking_spear_32.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_32.extravagance = 2
AllGear.viking_spear_32.tier = 4
AllGear.viking_spear_23 = AllGear.viking_spear_23 or table.clone(GearTemplates.spear)
AllGear.viking_spear_23.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_23"
AllGear.viking_spear_23.market_price = 6800
AllGear.viking_spear_23.release_name = "main"
AllGear.viking_spear_23.ui_sort_index = 6
AllGear.viking_spear_23.ui_texture = "spear_02_3"
AllGear.viking_spear_23.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_23.extravagance = 3
AllGear.viking_spear_23.tier = 2
AllGear.viking_spear_33 = AllGear.viking_spear_33 or table.clone(GearTemplates.spear)
AllGear.viking_spear_33.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_33"
AllGear.viking_spear_33.market_price = 14500
AllGear.viking_spear_33.release_name = "main"
AllGear.viking_spear_33.ui_sort_index = 9
AllGear.viking_spear_33.ui_texture = "spear_03_3"
AllGear.viking_spear_33.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_33.extravagance = 3
AllGear.viking_spear_33.tier = 4
AllGear.viking_spear_43 = AllGear.viking_spear_43 or table.clone(GearTemplates.spear)
AllGear.viking_spear_43.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_43"
AllGear.viking_spear_43.market_price = 19800
AllGear.viking_spear_43.release_name = "main"
AllGear.viking_spear_43.ui_sort_index = 12
AllGear.viking_spear_43.ui_texture = "spear_04_3"
AllGear.viking_spear_43.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_43.extravagance = 3
AllGear.viking_spear_43.tier = 5
AllGear.viking_spear_13 = AllGear.viking_spear_13 or table.clone(GearTemplates.spear)
AllGear.viking_spear_13.unit = "units/weapons/be_wpn_spear_kit/wpn_spear_13"
AllGear.viking_spear_13.market_price = 9200
AllGear.viking_spear_13.release_name = "main"
AllGear.viking_spear_13.ui_sort_index = 3
AllGear.viking_spear_13.ui_texture = "spear_01_3"
AllGear.viking_spear_13.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.viking_spear_13.extravagance = 3
AllGear.viking_spear_13.tier = 3
AllGear.throwing_spear = AllGear.throwing_spear or table.clone(GearTemplates.throwing_spear)
AllGear.throwing_spear.unit = "units/weapons/be_wpn_throwing_spear/wpn_throwing_spear"
AllGear.throwing_spear.starting_ammo = 1
AllGear.throwing_spear.market_price = 1140
AllGear.throwing_spear.release_name = "main"
AllGear.throwing_spear.ui_sort_index = 1
AllGear.throwing_spear.ui_texture = "throwing_spear"
AllGear.throwing_spear.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_spear.extravagance = 1
AllGear.throwing_spear.tier = 23
AllGear.throwing_spear_kit_01 = AllGear.throwing_spear_kit_01 or table.clone(GearTemplates.throwing_spear)
AllGear.throwing_spear_kit_01.unit = "units/weapons/be_wpn_throwing_spear/wpn_throwing_spear"
AllGear.throwing_spear_kit_01.starting_ammo = 1
AllGear.throwing_spear_kit_01.market_price = 2460
AllGear.throwing_spear_kit_01.release_name = "main"
AllGear.throwing_spear_kit_01.ui_sort_index = 2
AllGear.throwing_spear_kit_01.ui_texture = "throwing_spear"
AllGear.throwing_spear_kit_01.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_spear_kit_01.extravagance = 2
AllGear.throwing_spear_kit_01.tier = 23
AllGear.throwing_spear_kit_02 = AllGear.throwing_spear_kit_02 or table.clone(GearTemplates.throwing_spear)
AllGear.throwing_spear_kit_02.unit = "units/weapons/be_wpn_throwing_spear/wpn_throwing_spear"
AllGear.throwing_spear_kit_02.starting_ammo = 1
AllGear.throwing_spear_kit_02.market_price = 3920
AllGear.throwing_spear_kit_02.release_name = "main"
AllGear.throwing_spear_kit_02.ui_sort_index = 3
AllGear.throwing_spear_kit_02.ui_texture = "throwing_spear"
AllGear.throwing_spear_kit_02.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_spear_kit_02.extravagance = 3
AllGear.throwing_spear_kit_02.tier = 23
AllGear.throwing_spear_kit_03 = AllGear.throwing_spear_kit_03 or table.clone(GearTemplates.throwing_spear)
AllGear.throwing_spear_kit_03.unit = "units/weapons/be_wpn_throwing_spear/wpn_throwing_spear"
AllGear.throwing_spear_kit_03.starting_ammo = 1
AllGear.throwing_spear_kit_03.market_price = 3920
AllGear.throwing_spear_kit_03.release_name = "main"
AllGear.throwing_spear_kit_03.ui_sort_index = 4
AllGear.throwing_spear_kit_03.ui_texture = "throwing_spear"
AllGear.throwing_spear_kit_03.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_spear_kit_03.extravagance = 1
AllGear.throwing_spear_kit_03.tier = 23
AllGear.headhunter_throwing_spear = AllGear.headhunter_throwing_spear or table.clone(AllGear.throwing_spear)
AllGear.headhunter_throwing_spear.starting_ammo = 1
AllGear.headhunter_throwing_spear.archetypes = {
	medium = false,
	light = false,
	heavy = false
}
AllGear.throwing_dagger_41 = AllGear.throwing_dagger_41 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_41.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_41"
AllGear.throwing_dagger_41.starting_ammo = 4
AllGear.throwing_dagger_41.market_price = 760
AllGear.throwing_dagger_41.release_name = "main"
AllGear.throwing_dagger_41.ui_sort_index = 14
AllGear.throwing_dagger_41.ui_texture = "throw_04_1"
AllGear.throwing_dagger_41.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_41.extravagance = 1
AllGear.throwing_dagger_41.tier = 24
AllGear.throwing_dagger_11 = AllGear.throwing_dagger_11 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_11.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_11"
AllGear.throwing_dagger_11.starting_ammo = 4
AllGear.throwing_dagger_11.market_price = 160
AllGear.throwing_dagger_11.release_name = "main"
AllGear.throwing_dagger_11.ui_sort_index = 5
AllGear.throwing_dagger_11.ui_texture = "throw_01_1"
AllGear.throwing_dagger_11.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_11.extravagance = 1
AllGear.throwing_dagger_11.tier = 21
AllGear.throwing_axe_31 = AllGear.throwing_axe_31 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_31.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_31"
AllGear.throwing_axe_31.starting_ammo = 2
AllGear.throwing_axe_31.market_price = 320
AllGear.throwing_axe_31.release_name = "main"
AllGear.throwing_axe_31.ui_sort_index = 11
AllGear.throwing_axe_31.ui_texture = "throw_03_1"
AllGear.throwing_axe_31.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_31.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_31.extravagance = 1
AllGear.throwing_axe_31.tier = 22
AllGear.throwing_axe_21 = AllGear.throwing_axe_21 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_21.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_21"
AllGear.throwing_axe_21.starting_ammo = 2
AllGear.throwing_axe_21.market_price = 820
AllGear.throwing_axe_21.release_name = "main"
AllGear.throwing_axe_21.ui_sort_index = 8
AllGear.throwing_axe_21.ui_texture = "throw_02_1"
AllGear.throwing_axe_21.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_21.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_21.extravagance = 1
AllGear.throwing_axe_21.tier = 25
AllGear.throwing_dagger_12 = AllGear.throwing_dagger_12 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_12.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_12"
AllGear.throwing_dagger_12.starting_ammo = 4
AllGear.throwing_dagger_12.market_price = 1220
AllGear.throwing_dagger_12.release_name = "main"
AllGear.throwing_dagger_12.ui_sort_index = 6
AllGear.throwing_dagger_12.ui_texture = "throw_01_2"
AllGear.throwing_dagger_12.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_12.extravagance = 2
AllGear.throwing_dagger_12.tier = 21
AllGear.throwing_axe_22 = AllGear.throwing_axe_22 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_22.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_22"
AllGear.throwing_axe_22.starting_ammo = 2
AllGear.throwing_axe_22.market_price = 1920
AllGear.throwing_axe_22.release_name = "main"
AllGear.throwing_axe_22.ui_sort_index = 9
AllGear.throwing_axe_22.ui_texture = "throw_02_2"
AllGear.throwing_axe_22.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_22.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_22.extravagance = 2
AllGear.throwing_axe_22.tier = 25
AllGear.throwing_dagger_42 = AllGear.throwing_dagger_42 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_42.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_42"
AllGear.throwing_dagger_42.starting_ammo = 4
AllGear.throwing_dagger_42.market_price = 1440
AllGear.throwing_dagger_42.release_name = "main"
AllGear.throwing_dagger_42.ui_sort_index = 15
AllGear.throwing_dagger_42.ui_texture = "throw_04_2"
AllGear.throwing_dagger_42.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_42.extravagance = 2
AllGear.throwing_dagger_42.tier = 24
AllGear.throwing_axe_32 = AllGear.throwing_axe_32 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_32.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_32"
AllGear.throwing_axe_32.starting_ammo = 2
AllGear.throwing_axe_32.market_price = 1760
AllGear.throwing_axe_32.release_name = "main"
AllGear.throwing_axe_32.ui_sort_index = 12
AllGear.throwing_axe_32.ui_texture = "throw_03_2"
AllGear.throwing_axe_32.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_32.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_32.extravagance = 2
AllGear.throwing_axe_32.tier = 22
AllGear.throwing_axe_33 = AllGear.throwing_axe_33 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_33.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_33"
AllGear.throwing_axe_33.starting_ammo = 2
AllGear.throwing_axe_33.market_price = 3280
AllGear.throwing_axe_33.release_name = "main"
AllGear.throwing_axe_33.ui_sort_index = 13
AllGear.throwing_axe_33.ui_texture = "throw_03_3"
AllGear.throwing_axe_33.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_33.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_33.extravagance = 3
AllGear.throwing_axe_33.tier = 22
AllGear.throwing_axe_23 = AllGear.throwing_axe_23 or table.clone(GearTemplates.throwing_axe)
AllGear.throwing_axe_23.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_23"
AllGear.throwing_axe_23.starting_ammo = 2
AllGear.throwing_axe_23.market_price = 4120
AllGear.throwing_axe_23.release_name = "main"
AllGear.throwing_axe_23.ui_sort_index = 10
AllGear.throwing_axe_23.ui_texture = "throw_02_3"
AllGear.throwing_axe_23.attacks.throw.link_node = "throw_point"
AllGear.throwing_axe_23.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_axe_23.extravagance = 3
AllGear.throwing_axe_23.tier = 25
AllGear.throwing_dagger_13 = AllGear.throwing_dagger_13 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_13.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_13"
AllGear.throwing_dagger_13.starting_ammo = 4
AllGear.throwing_dagger_13.market_price = 2640
AllGear.throwing_dagger_13.release_name = "main"
AllGear.throwing_dagger_13.ui_sort_index = 7
AllGear.throwing_dagger_13.ui_texture = "throw_01_3"
AllGear.throwing_dagger_13.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_13.extravagance = 3
AllGear.throwing_dagger_13.tier = 21
AllGear.throwing_dagger_43 = AllGear.throwing_dagger_43 or table.clone(GearTemplates.throwing_dagger)
AllGear.throwing_dagger_43.unit = "units/weapons/be_wpn_thrown_kit/wpn_thrown_kit_43"
AllGear.throwing_dagger_43.starting_ammo = 4
AllGear.throwing_dagger_43.market_price = 3640
AllGear.throwing_dagger_43.release_name = "main"
AllGear.throwing_dagger_43.ui_sort_index = 16
AllGear.throwing_dagger_43.ui_texture = "throw_04_3"
AllGear.throwing_dagger_43.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.throwing_dagger_43.extravagance = 3
AllGear.throwing_dagger_43.tier = 24
AllGear.mjolnir = AllGear.mjolnir or table.clone(GearTemplates.throwing_axe)
AllGear.mjolnir.unit = "units/weapons/be_wpn_mjolnir/be_wpn_mjolnir"
AllGear.mjolnir.starting_ammo = 1
AllGear.mjolnir.market_price = 3640
AllGear.mjolnir.release_name = "main"
AllGear.mjolnir.ui_sort_index = 16
AllGear.mjolnir.ui_texture = "throw_04_3"
AllGear.mjolnir.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.mjolnir.extravagance = 3
AllGear.mjolnir.tier = 24
AllGear.mjolnir.developer_item = true
AllGear.mjolnir.hide_if_unavailable = true
AllGear.mjolnir.attacks.throw.damage = 50
AllGear.mjolnir.attacks.throw.pose_duration = 0.4
AllGear.mjolnir.attacks.throw.throw_duration = 0.5
AllGear.mjolnir.attacks.throw.release_factor = 0.4
AllGear.hunting_bow_rough = AllGear.hunting_bow_rough or table.clone(GearTemplates.hunting_bow)
AllGear.hunting_bow_rough.gear_type = "hunting_bow"
AllGear.hunting_bow_rough.unit = "units/weapons/wpn_huntingbow/wpn_huntingbow"
AllGear.hunting_bow_rough.material_variation = "units/weapons/wpn_huntingbow/wpn_huntingbow_rough"
AllGear.hunting_bow_rough.quiver.material_variation = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather_rough"
AllGear.hunting_bow_rough.projectiles.default = ProjectileSettings.standard_arrow_long_rough
AllGear.hunting_bow_rough.market_price = 600
AllGear.hunting_bow_rough.release_name = "main"
AllGear.hunting_bow_rough.ui_sort_index = 1
AllGear.hunting_bow_rough.ui_texture = "huntingbow_3"
AllGear.hunting_bow_rough.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.hunting_bow_rough.extravagance = 1
AllGear.hunting_bow_rough.tier = 18
AllGear.hunting_bow = AllGear.hunting_bow or table.clone(GearTemplates.hunting_bow)
AllGear.hunting_bow.unit = "units/weapons/wpn_huntingbow/wpn_huntingbow"
AllGear.hunting_bow.market_price = 2400
AllGear.hunting_bow.release_name = "main"
AllGear.hunting_bow.ui_sort_index = 2
AllGear.hunting_bow.ui_texture = "huntingbow_2"
AllGear.hunting_bow.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.hunting_bow.extravagance = 2
AllGear.hunting_bow.tier = 18
AllGear.hunting_bow_ornamented = AllGear.hunting_bow_ornamented or table.clone(GearTemplates.hunting_bow)
AllGear.hunting_bow_ornamented.gear_type = "hunting_bow"
AllGear.hunting_bow_ornamented.unit = "units/weapons/wpn_huntingbow/wpn_huntingbow"
AllGear.hunting_bow_ornamented.material_variation = "units/weapons/wpn_huntingbow/wpn_huntingbow_ornamented"
AllGear.hunting_bow_ornamented.quiver.material_variation = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather_ornamented"
AllGear.hunting_bow_ornamented.projectiles.default = ProjectileSettings.standard_arrow_long_ornamented
AllGear.hunting_bow_ornamented.market_price = 7440
AllGear.hunting_bow_ornamented.release_name = "main"
AllGear.hunting_bow_ornamented.ui_sort_index = 3
AllGear.hunting_bow_ornamented.ui_texture = "huntingbow_1"
AllGear.hunting_bow_ornamented.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.hunting_bow_ornamented.extravagance = 3
AllGear.hunting_bow_ornamented.tier = 18
AllGear.longbow_rough = AllGear.longbow_rough or table.clone(GearTemplates.longbow)
AllGear.longbow_rough.unit = "units/weapons/wpn_longbow_01/wpn_longbow_01"
AllGear.longbow_rough.material_variation = "units/weapons/wpn_longbow_01/wpn_longbow_01_rough"
AllGear.longbow_rough.attachment_node_linking = AttachmentNodeLinking.bow.standard
AllGear.longbow_rough.quiver.material_variation = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather_rough"
AllGear.longbow_rough.projectiles.default = ProjectileSettings.standard_arrow_long_rough
AllGear.longbow_rough.market_price = 720
AllGear.longbow_rough.release_name = "main"
AllGear.longbow_rough.ui_sort_index = 4
AllGear.longbow_rough.ui_texture = "longbow_3"
AllGear.longbow_rough.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.longbow_rough.extravagance = 1
AllGear.longbow_rough.tier = 17
AllGear.longbow = AllGear.longbow or table.clone(GearTemplates.longbow)
AllGear.longbow.unit = "units/weapons/wpn_longbow_01/wpn_longbow_01"
AllGear.longbow.market_price = 4400
AllGear.longbow.release_name = "main"
AllGear.longbow.ui_sort_index = 5
AllGear.longbow.ui_texture = "longbow_2"
AllGear.longbow.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.longbow.extravagance = 2
AllGear.longbow.tier = 17
AllGear.longbow_ornamented = AllGear.longbow_ornamented or table.clone(GearTemplates.longbow)
AllGear.longbow_ornamented.unit = "units/weapons/wpn_longbow_01/wpn_longbow_01"
AllGear.longbow_ornamented.material_variation = "units/weapons/wpn_longbow_01/wpn_longbow_01_ornamented"
AllGear.longbow_ornamented.quiver.material_variation = "units/weapons/quivers/wpn_quiver_leather/wpn_quiver_leather_ornamented"
AllGear.longbow_ornamented.projectiles.default = ProjectileSettings.standard_arrow_long_ornamented
AllGear.longbow_ornamented.market_price = 11800
AllGear.longbow_ornamented.release_name = "main"
AllGear.longbow_ornamented.ui_sort_index = 6
AllGear.longbow_ornamented.ui_texture = "longbow_1"
AllGear.longbow_ornamented.archetypes = {
	medium = true,
	light = true,
	heavy = false
}
AllGear.longbow_ornamented.extravagance = 3
AllGear.longbow_ornamented.tier = 17
AllGear.round_shield = AllGear.round_shield or table.clone(GearTemplates.small_shield)
AllGear.round_shield.unit = "units/weapons/be_wpn_round_shield/wpn_round_shield"
AllGear.round_shield.encumbrance = 15
AllGear.round_shield.market_price = 1280
AllGear.round_shield.release_name = "main"
AllGear.round_shield.ui_sort_index = 2
AllGear.round_shield.ui_texture = "sheild_02"
AllGear.round_shield.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.round_shield.extravagance = 2
AllGear.round_shield.tier = 38
AllGear.round_shield_worn = AllGear.round_shield_worn or table.clone(GearTemplates.small_shield)
AllGear.round_shield_worn.unit = "units/weapons/be_wpn_round_shield/wpn_round_shield_worn"
AllGear.round_shield_worn.encumbrance = 15
AllGear.round_shield_worn.market_price = 220
AllGear.round_shield_worn.release_name = "main"
AllGear.round_shield_worn.ui_sort_index = 1
AllGear.round_shield_worn.ui_texture = "sheild_01"
AllGear.round_shield_worn.extravagance = 1
AllGear.round_shield_worn.tier = 38
AllGear.round_shield_leather = AllGear.round_shield_leather or table.clone(GearTemplates.small_shield)
AllGear.round_shield_leather.unit = "units/weapons/be_wpn_round_shield_leather/wpn_round_shield_leather"
AllGear.round_shield_leather.encumbrance = 15
AllGear.round_shield_leather.market_price = 11600
AllGear.round_shield_leather.release_name = "main"
AllGear.round_shield_leather.ui_sort_index = 4
AllGear.round_shield_leather.ui_texture = "sheild_04"
AllGear.round_shield_leather.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.round_shield_leather.extravagance = 3
AllGear.round_shield_leather.tier = 38
AllGear.round_shield_leather_iron = AllGear.round_shield_leather_iron or table.clone(GearTemplates.small_shield)
AllGear.round_shield_leather_iron.unit = "units/weapons/be_wpn_round_shield_leather/wpn_round_shield_leather_iron"
AllGear.round_shield_leather_iron.encumbrance = 15
AllGear.round_shield_leather_iron.market_price = 7200
AllGear.round_shield_leather_iron.release_name = "main"
AllGear.round_shield_leather_iron.ui_sort_index = 3
AllGear.round_shield_leather_iron.ui_texture = "sheild_03"
AllGear.round_shield_leather_iron.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.round_shield_leather_iron.extravagance = 3
AllGear.round_shield_leather_iron.tier = 38
AllGear.round_shield_worn.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.snowflake_shield = AllGear.snowflake_shield or table.clone(GearTemplates.large_shield)
AllGear.snowflake_shield.unit = "units/weapons/wpn_snowflake_shield/wpn_snowflake_shield"
AllGear.snowflake_shield.encumbrance = 15
AllGear.snowflake_shield.market_price = 1280
AllGear.snowflake_shield.release_name = "vanguard"
AllGear.snowflake_shield.ui_sort_index = 2
AllGear.snowflake_shield.ui_texture = "sheild_snowflake"
AllGear.snowflake_shield.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.snowflake_shield.extravagance = 2
AllGear.snowflake_shield.hide_if_unavailable = false
AllGear.snowflake_shield.tier = 39
AllGear.snowflake_shield_gold = AllGear.snowflake_shield_gold or table.clone(GearTemplates.large_shield)
AllGear.snowflake_shield_gold.unit = "units/weapons/wpn_snowflake_shield/wpn_snowflake_shield_gold"
AllGear.snowflake_shield_gold.encumbrance = 15
AllGear.snowflake_shield_gold.market_price = 14700
AllGear.snowflake_shield_gold.release_name = "vanguard"
AllGear.snowflake_shield_gold.ui_sort_index = 2
AllGear.snowflake_shield_gold.ui_texture = "sheild_snowflake_gold"
AllGear.snowflake_shield_gold.archetypes = {
	medium = true,
	light = true,
	heavy = true
}
AllGear.snowflake_shield_gold.extravagance = 3
AllGear.snowflake_shield_gold.hide_if_unavailable = false
AllGear.snowflake_shield_gold.tier = 39
AllGear.damage_zone = AllGear.damage_zone or table.clone(GearTemplates.damage_zone)
AllGear.damage_zone.unit = "units/weapons/be_wpn_round_shield_leather/wpn_round_shield_leather_iron"
AllGear.damage_zone.release_name = "main"
AllGear.damage_zone.ui_sort_index = 1
AllGear.damage_zone.ui_texture = "default"
AllGear.damage_zone.name = "damage_zone_gear"
AllGear.damage_zone.archetypes = {
	medium = false,
	light = false,
	heavy = false
}

for gear_name, gear in pairs(AllGear) do
	for attack_name, attack in pairs(gear.attacks) do
		if attack.penalties and attack.penalties.parried then
			attack.penalties.parried_parry = attack.penalties.parried * 0.5
		end

		if attack.penalties and attack.penalties.blocked then
			attack.penalties.blocked_parry = attack.penalties.blocked * 0.5
		end

		if attack.penalties and attack.penalties.dual_wield_defended then
			attack.penalties.dual_wield_defended_parry = attack.penalties.dual_wield_defended * 0.5
		end

		if GameSettingsDevelopment.sanity_check_gear then
			fassert(attack.uncharged_attack_time, "Missing uncharged_attack_time in %s:%s", gear_name, attack_name)
			fassert(attack.charged_attack_time, "Missing charged_attack_time in %s:%s", gear_name, attack_name)
			fassert(attack.uncharged_damage, "Missing uncharged_damage in %s:%s", gear_name, attack_name)
			fassert(attack.charged_damage, "Missing charged_damage time in %s:%s", gear_name, attack_name)
		end
	end

	gear.name = gear_name
	gear.entity_type = "gear"
	gear.ui_description = gear.ui_description or "This is a generic description that I use to verify my code. When we have a description for an item, the field ui_description needs to be added to the item with the correct description"
end

Gear = {}

for name, gear in pairs(AllGear) do
	gear.base_name = gear.name
	gear.ui_header = "gear_header_" .. gear.name
	gear.ui_description = "gear_desc_" .. gear.name
	gear.ui_header_plural = "gear_header_" .. gear.name .. "_plural"
	gear.index = gear.ui_sort_index or 1
	gear.tier = gear.tier or 1
	gear.extravagance = gear.extravagance or 1
	Gear[name] = gear
end

DEFAULT_GEAR_UNLOCK_LIST = {
	"viking_axe_41",
	"longbow_rough"
}

function default_gear_unlocks()
	local default_unlocks = {}

	for gear_name, props in pairs(Gear) do
		if props.required_dlc or table.contains(DEFAULT_GEAR_UNLOCK_LIST, gear_name) then
			props.market_price = nil

			local entity_type = "gear"

			default_unlocks[entity_type .. "|" .. props.name] = {
				category = entity_type,
				name = gear_name
			}
		end
	end

	return default_unlocks
end

function default_gear_attachment_unlocks()
	local default_unlocks = {}

	for gear_name, gear_props in pairs(Gear) do
		for _, attachment_group in pairs(gear_props.attachments) do
			if attachment_group.items[1].unlock_this_item ~= false then
				local entity_type = "gear_attachment"
				local entity_name = gear_name .. "|" .. attachment_group.items[1].name

				default_unlocks[entity_type .. "|" .. entity_name] = {
					category = entity_type,
					name = entity_name
				}
			end
		end
	end

	return default_unlocks
end
