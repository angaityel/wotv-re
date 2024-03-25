-- chunkname: @scripts/settings/heads.lua

require("scripts/settings/attachment_node_linking")

Voices = {
	commoner = {},
	noble = {},
	brian_blessed_commoner = {
		required_dlc = DLCSettings.brian_blessed
	},
	brian_blessed_noble = {
		required_dlc = DLCSettings.brian_blessed
	}
}
HeadMaterials = {
	knight = {
		material_name = "units/beings/chr_wotr_heads/chr_wotr_head_01/chr_wotr_head_01",
		ui_name = "menu_knight"
	},
	peasant = {
		material_name = "units/beings/chr_wotr_heads/chr_wotr_head_02/chr_wotr_head_02",
		ui_name = "menu_peasant"
	},
	squire = {
		material_name = "units/beings/chr_wotr_heads/chr_wotr_head_03/chr_wotr_head_03",
		ui_name = "menu_squire"
	},
	lady = {
		material_name = "units/beings/chr_wotr_heads/chr_wotr_head_04/chr_wotr_head_04",
		ui_name = "menu_lady"
	},
	viking_1 = {
		material_name = "units/beings/chr_wotr_heads/chr_viking_face_1/chr_be_viking_face_1",
		ui_name = "menu_viking_1"
	}
}
BeardVariations = {}
BeardVariations.viking = {
	"brown",
	"black",
	"gray",
	"red",
	"yellow"
}
BeardVariations.saxon = {
	"brown",
	"black",
	"red",
	"gray"
}
BeardVariations.berserker = {
	"brown_02",
	"black_02",
	"red_02",
	"gray_02"
}
BeardVariations.no_variations = {}
Beards = {
	{
		name = "no_beard",
		ui_texture = "beard_saxon_00",
		tier = 1,
		release_name = "main",
		ui_sort_index = 1,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_00",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.no_variations
	},
	{
		name = "no_beard_02",
		ui_texture = "saxon_berserker_no_hair",
		tier = 1,
		release_name = "main",
		ui_sort_index = 1,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_00",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.no_variations
	},
	{
		name = "saxon_berserker_beard_01",
		ui_texture = "saxon_berserker_hair_06",
		tier = 1,
		market_price = 3780,
		release_name = "berserk",
		ui_sort_index = 1,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_beard_01",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.berserker
	},
	{
		name = "saxon_beard_04",
		ui_texture = "beard_saxon_01",
		tier = 1,
		market_price = 320,
		release_name = "main",
		ui_sort_index = 2,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_01",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_05",
		ui_texture = "beard_saxon_02",
		tier = 1,
		market_price = 550,
		release_name = "main",
		ui_sort_index = 3,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_02",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_06",
		ui_texture = "beard_saxon_03",
		tier = 1,
		market_price = 720,
		release_name = "main",
		ui_sort_index = 4,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_03",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_07",
		ui_texture = "beard_saxon_04",
		tier = 1,
		market_price = 1200,
		release_name = "main",
		ui_sort_index = 6,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_04",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_08",
		ui_texture = "beard_saxon_05",
		tier = 1,
		market_price = 5200,
		release_name = "main",
		ui_sort_index = 10,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_05",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_09",
		ui_texture = "beard_saxon_06",
		tier = 1,
		market_price = 980,
		release_name = "main",
		ui_sort_index = 5,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_06",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_10",
		ui_texture = "beard_saxon_07",
		tier = 1,
		market_price = 6100,
		release_name = "main",
		ui_sort_index = 11,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_07",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_11",
		ui_texture = "beard_saxon_08",
		tier = 1,
		market_price = 1620,
		release_name = "main",
		ui_sort_index = 7,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_08",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_12",
		ui_texture = "beard_saxon_09",
		tier = 1,
		market_price = 2280,
		release_name = "main",
		ui_sort_index = 8,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_09",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_13",
		ui_texture = "beard_saxon_10",
		tier = 1,
		market_price = 8240,
		release_name = "main",
		ui_sort_index = 13,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_10",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_14",
		ui_texture = "beard_saxon_11",
		tier = 1,
		market_price = 3920,
		release_name = "main",
		ui_sort_index = 9,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_11",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.saxon)
	},
	{
		name = "saxon_beard_15",
		ui_texture = "beard_saxon_01",
		tier = 1,
		market_price = 320,
		release_name = "main",
		ui_sort_index = 2,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_12",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_16",
		ui_texture = "beard_saxon_02",
		tier = 1,
		market_price = 550,
		release_name = "main",
		ui_sort_index = 3,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_13",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_17",
		ui_texture = "beard_saxon_03",
		tier = 1,
		market_price = 720,
		release_name = "main",
		ui_sort_index = 4,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_14",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_18",
		ui_texture = "beard_saxon_04",
		tier = 1,
		market_price = 1200,
		release_name = "main",
		ui_sort_index = 6,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_15",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_19",
		ui_texture = "beard_saxon_05",
		tier = 1,
		market_price = 5100,
		release_name = "main",
		ui_sort_index = 10,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_16",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_20",
		ui_texture = "beard_saxon_06",
		tier = 1,
		market_price = 980,
		release_name = "main",
		ui_sort_index = 5,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_17",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_21",
		ui_texture = "beard_saxon_07",
		tier = 1,
		market_price = 6100,
		release_name = "main",
		ui_sort_index = 11,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_18",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_22",
		ui_texture = "beard_saxon_08",
		tier = 1,
		market_price = 1620,
		release_name = "main",
		ui_sort_index = 7,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_19",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_23",
		ui_texture = "beard_saxon_09",
		tier = 1,
		market_price = 2300,
		release_name = "main",
		ui_sort_index = 8,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_20",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_24",
		ui_texture = "beard_saxon_10",
		tier = 1,
		market_price = 8240,
		release_name = "main",
		ui_sort_index = 33,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_21",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_25",
		ui_texture = "beard_saxon_11",
		tier = 1,
		market_price = 3920,
		release_name = "main",
		ui_sort_index = 9,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_22",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_26",
		ui_texture = "beard_saxon_04",
		tier = 1,
		market_price = 320,
		release_name = "main",
		ui_sort_index = 24,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_23",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_27",
		ui_texture = "beard_saxon_05",
		tier = 1,
		market_price = 2280,
		release_name = "main",
		ui_sort_index = 28,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_24",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_28",
		ui_texture = "beard_saxon_06",
		tier = 1,
		market_price = 720,
		release_name = "main",
		ui_sort_index = 25,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_25",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_29",
		ui_texture = "beard_saxon_07",
		tier = 1,
		market_price = 3920,
		release_name = "main",
		ui_sort_index = 33,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_26",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_30",
		ui_texture = "beard_saxon_08",
		tier = 1,
		market_price = 1200,
		release_name = "main",
		ui_sort_index = 26,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_27",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_31",
		ui_texture = "beard_saxon_09",
		tier = 1,
		market_price = 1620,
		release_name = "main",
		ui_sort_index = 27,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_28",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_32",
		ui_texture = "beard_saxon_10",
		tier = 1,
		market_price = 8240,
		release_name = "main",
		ui_sort_index = 36,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_29",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_33",
		ui_texture = "beard_saxon_12",
		tier = 1,
		market_price = 7400,
		release_name = "main",
		ui_sort_index = 12,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_30",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_34",
		ui_texture = "beard_saxon_13",
		tier = 1,
		market_price = 9600,
		release_name = "main",
		ui_sort_index = 14,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_31",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_35",
		ui_texture = "beard_saxon_12",
		tier = 1,
		market_price = 7400,
		release_name = "main",
		ui_sort_index = 12,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_32",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_36",
		ui_texture = "beard_saxon_13",
		tier = 1,
		market_price = 9620,
		release_name = "main",
		ui_sort_index = 34,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_33",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_37",
		ui_texture = "beard_saxon_12",
		tier = 1,
		market_price = 5200,
		release_name = "main",
		ui_sort_index = 35,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_34",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_38",
		ui_texture = "beard_saxon_13",
		tier = 1,
		market_price = 9620,
		release_name = "main",
		ui_sort_index = 37,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_35",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "saxon_beard_39",
		ui_texture = "beard_contest_1",
		tier = 1,
		market_price = 1000,
		release_name = "main",
		ui_sort_index = 38,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_036_gzaba_brezona",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = BeardVariations.saxon
	},
	{
		name = "viking_beard_04",
		ui_texture = "beard_viking_01",
		tier = 1,
		market_price = 9620,
		release_name = "main",
		ui_sort_index = 9,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_01",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_05",
		ui_texture = "beard_viking_02",
		tier = 1,
		market_price = 550,
		release_name = "main",
		ui_sort_index = 3,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_02",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_berserker",
		ui_texture = "beard_viking_02",
		tier = 1,
		market_price = 3780,
		release_name = "main",
		ui_sort_index = 2,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_02",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_06",
		ui_texture = "beard_viking_03",
		tier = 1,
		market_price = 320,
		release_name = "main",
		ui_sort_index = 2,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_03",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_07",
		ui_texture = "beard_viking_04",
		tier = 1,
		market_price = 7400,
		release_name = "main",
		ui_sort_index = 8,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_04",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_08",
		ui_texture = "beard_viking_05",
		tier = 1,
		market_price = 5200,
		release_name = "main",
		ui_sort_index = 7,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_05",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_09",
		ui_texture = "beard_viking_06",
		tier = 1,
		market_price = 980,
		release_name = "main",
		ui_sort_index = 4,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_06",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_10",
		ui_texture = "beard_viking_07",
		tier = 1,
		market_price = 1200,
		release_name = "main",
		ui_sort_index = 5,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_07",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_11",
		ui_texture = "beard_viking_08",
		tier = 1,
		market_price = 2280,
		release_name = "main",
		ui_sort_index = 6,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_08",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	},
	{
		name = "viking_beard_12",
		ui_texture = "beard_contest_2",
		tier = 1,
		market_price = 1000,
		release_name = "main",
		ui_sort_index = 10,
		attachments = {
			{
				unit = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_09_tyler_e_burg",
				node_linking = AttachmentNodeLinking.beards.standard
			}
		},
		variations = table.clone(BeardVariations.viking)
	}
}
BeardColors = {
	brown = {
		release_name = "main",
		name = "brown",
		ui_texture_suffix = "",
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_kit_brown",
		ui_sort_index = 1
	},
	black = {
		release_name = "main",
		name = "black",
		ui_texture_suffix = "_black",
		market_price = 980,
		material_variation = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_kit_black",
		ui_sort_index = 3
	},
	gray = {
		release_name = "main",
		name = "gray",
		ui_texture_suffix = "_gray",
		market_price = 2080,
		material_variation = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_kit_gray",
		ui_sort_index = 5
	},
	red = {
		release_name = "main",
		name = "red",
		ui_texture_suffix = "_red",
		market_price = 1440,
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_beard_kit/arm_be_hair_saxon_beard_kit_ginger",
		ui_sort_index = 4
	},
	yellow = {
		release_name = "main",
		name = "yellow",
		ui_texture_suffix = "_blonde",
		market_price = 620,
		material_variation = "units/beings/chr_hair/arm_be_hair_viking_beard_kit/arm_be_hair_viking_beard_kit_blonde",
		ui_sort_index = 2
	},
	brown_02 = {
		release_name = "main",
		name = "brown_02",
		ui_texture_suffix = "",
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_beard_01",
		ui_sort_index = 1
	},
	black_02 = {
		release_name = "main",
		name = "black_02",
		ui_texture_suffix = "_black",
		market_price = 980,
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_beard_01_black",
		ui_sort_index = 3
	},
	gray_02 = {
		release_name = "main",
		name = "gray_02",
		ui_texture_suffix = "_gray",
		market_price = 2080,
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_beard_01_gray",
		ui_sort_index = 5
	},
	red_02 = {
		release_name = "main",
		name = "red_02",
		ui_texture_suffix = "_red",
		market_price = 1440,
		material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_beard_01_red",
		ui_sort_index = 4
	}
}
BeardNames = {}
BeardColorNames = {}

for i, beard in ipairs(Beards) do
	beard.ui_header = "ui_header_" .. beard.name
	beard.ui_description = "ui_description_" .. beard.name
	beard.ui_texture = beard.ui_texture or "default"
	beard.ui_sort_index = beard.ui_sort_index or 1
	beard.market_price = beard.market_price
	beard.entity_type = "beard"
	beard.material_variations = {}

	for _, material in ipairs(beard.variations) do
		local key = #beard.material_variations + 1
		local properties = BeardColors[material]

		beard.material_variations[key] = table.clone(properties)
		beard.material_variations[key].name = beard.name .. "_" .. properties.name
		beard.material_variations[key].beard_name = beard.name
		beard.material_variations[key].ui_header = "ui_header_" .. properties.name
		beard.material_variations[key].ui_texture = beard.ui_texture .. properties.ui_texture_suffix
		beard.material_variations[key].ui_sort_index = properties.ui_sort_index or 1
		beard.material_variations[key].entity_type = "beard_color"
		BeardColorNames[beard.name .. "_" .. properties.name] = beard.material_variations[key]
	end

	BeardNames[beard.name] = beard
end

BaseHeads = {
	knight = {
		ui_texture = "head_wotr_face_01",
		release_name = "main",
		ui_sort_index = 3,
		ui_header = "menu_knight",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_01/chr_wotr_head_01",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_04,
			BeardNames.saxon_beard_05,
			BeardNames.saxon_beard_06,
			BeardNames.saxon_beard_07,
			BeardNames.saxon_beard_08,
			BeardNames.saxon_beard_09,
			BeardNames.saxon_beard_10,
			BeardNames.saxon_beard_11,
			BeardNames.saxon_beard_12,
			BeardNames.saxon_beard_13,
			BeardNames.saxon_beard_14,
			BeardNames.saxon_beard_33,
			BeardNames.saxon_beard_34,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	knight_painted = {
		ui_texture = "head_wotr_face_08",
		market_price = 5460,
		release_name = "berserk",
		ui_sort_index = 15,
		ui_header = "menu_knight_painted",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_01/chr_wotr_head_01_painted",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_04,
			BeardNames.saxon_beard_05,
			BeardNames.saxon_beard_06,
			BeardNames.saxon_beard_07,
			BeardNames.saxon_beard_08,
			BeardNames.saxon_beard_09,
			BeardNames.saxon_beard_10,
			BeardNames.saxon_beard_11,
			BeardNames.saxon_beard_12,
			BeardNames.saxon_beard_13,
			BeardNames.saxon_beard_14,
			BeardNames.saxon_beard_33,
			BeardNames.saxon_beard_34,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	knight_scarred = {
		ui_texture = "head_wotr_face_09",
		market_price = 1940,
		release_name = "berserk",
		ui_sort_index = 7,
		ui_header = "menu_knight_scarred",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_01/chr_wotr_head_01_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_04,
			BeardNames.saxon_beard_05,
			BeardNames.saxon_beard_06,
			BeardNames.saxon_beard_07,
			BeardNames.saxon_beard_08,
			BeardNames.saxon_beard_09,
			BeardNames.saxon_beard_10,
			BeardNames.saxon_beard_11,
			BeardNames.saxon_beard_12,
			BeardNames.saxon_beard_13,
			BeardNames.saxon_beard_14,
			BeardNames.saxon_beard_33,
			BeardNames.saxon_beard_34,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	knight_bandage = {
		ui_texture = "head_wotr_face_07",
		market_price = 3780,
		release_name = "berserk",
		ui_sort_index = 11,
		ui_header = "menu_knight_bandage",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_01/chr_wotr_head_01_bandage",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_04,
			BeardNames.saxon_beard_05,
			BeardNames.saxon_beard_06,
			BeardNames.saxon_beard_07,
			BeardNames.saxon_beard_08,
			BeardNames.saxon_beard_09,
			BeardNames.saxon_beard_10,
			BeardNames.saxon_beard_11,
			BeardNames.saxon_beard_12,
			BeardNames.saxon_beard_13,
			BeardNames.saxon_beard_14,
			BeardNames.saxon_beard_33,
			BeardNames.saxon_beard_34,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	saxon_berserk = {
		ui_texture = "head_wotr_face_19",
		release_name = "berserk",
		ui_sort_index = 7,
		ui_header = "menu_saxon_berserk",
		unit = "units/beings/chr_wotr_heads/chr_saxon_face_berserk/chr_saxon_berserk_head",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard_02,
			BeardNames.saxon_berserker_beard_01
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	peasant = {
		ui_texture = "head_wotr_face_02",
		release_name = "main",
		ui_sort_index = 4,
		ui_header = "menu_peasant",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_02/chr_wotr_head_02",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_15,
			BeardNames.saxon_beard_16,
			BeardNames.saxon_beard_17,
			BeardNames.saxon_beard_18,
			BeardNames.saxon_beard_19,
			BeardNames.saxon_beard_20,
			BeardNames.saxon_beard_21,
			BeardNames.saxon_beard_22,
			BeardNames.saxon_beard_23,
			BeardNames.saxon_beard_24,
			BeardNames.saxon_beard_25,
			BeardNames.saxon_beard_35,
			BeardNames.saxon_beard_36,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	peasant_scarred = {
		ui_texture = "head_wotr_face_11",
		market_price = 1940,
		release_name = "berserk",
		ui_sort_index = 8,
		ui_header = "menu_peasant_scarred",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_02/chr_wotr_head_02_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_15,
			BeardNames.saxon_beard_16,
			BeardNames.saxon_beard_17,
			BeardNames.saxon_beard_18,
			BeardNames.saxon_beard_19,
			BeardNames.saxon_beard_20,
			BeardNames.saxon_beard_21,
			BeardNames.saxon_beard_22,
			BeardNames.saxon_beard_23,
			BeardNames.saxon_beard_24,
			BeardNames.saxon_beard_25,
			BeardNames.saxon_beard_35,
			BeardNames.saxon_beard_36,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	peasant_bandage = {
		ui_texture = "head_wotr_face_10",
		market_price = 3780,
		release_name = "berserk",
		ui_sort_index = 12,
		ui_header = "menu_peasant_bandage",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_02/chr_wotr_head_02_bandage",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_15,
			BeardNames.saxon_beard_16,
			BeardNames.saxon_beard_17,
			BeardNames.saxon_beard_18,
			BeardNames.saxon_beard_19,
			BeardNames.saxon_beard_20,
			BeardNames.saxon_beard_21,
			BeardNames.saxon_beard_22,
			BeardNames.saxon_beard_23,
			BeardNames.saxon_beard_24,
			BeardNames.saxon_beard_25,
			BeardNames.saxon_beard_35,
			BeardNames.saxon_beard_36,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	peasant_painted = {
		ui_texture = "head_wotr_face_12",
		market_price = 5460,
		release_name = "berserk",
		ui_sort_index = 16,
		ui_header = "menu_peasant_painted",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_02/chr_wotr_head_02_painted",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_15,
			BeardNames.saxon_beard_16,
			BeardNames.saxon_beard_17,
			BeardNames.saxon_beard_18,
			BeardNames.saxon_beard_19,
			BeardNames.saxon_beard_20,
			BeardNames.saxon_beard_21,
			BeardNames.saxon_beard_22,
			BeardNames.saxon_beard_23,
			BeardNames.saxon_beard_24,
			BeardNames.saxon_beard_25,
			BeardNames.saxon_beard_35,
			BeardNames.saxon_beard_36,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	squire = {
		ui_texture = "head_wotr_face_03",
		release_name = "main",
		ui_sort_index = 2,
		ui_header = "menu_squire",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_03/chr_wotr_head_03",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_26,
			BeardNames.saxon_beard_27,
			BeardNames.saxon_beard_28,
			BeardNames.saxon_beard_29,
			BeardNames.saxon_beard_30,
			BeardNames.saxon_beard_31,
			BeardNames.saxon_beard_32,
			BeardNames.saxon_beard_37,
			BeardNames.saxon_beard_38,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	squire_scarred = {
		ui_texture = "head_wotr_face_15",
		market_price = 1940,
		release_name = "berserk",
		ui_sort_index = 6,
		ui_header = "menu_squire_scarred",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_03/chr_wotr_head_03_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_26,
			BeardNames.saxon_beard_27,
			BeardNames.saxon_beard_28,
			BeardNames.saxon_beard_29,
			BeardNames.saxon_beard_30,
			BeardNames.saxon_beard_31,
			BeardNames.saxon_beard_32,
			BeardNames.saxon_beard_37,
			BeardNames.saxon_beard_38,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	squire_painted = {
		ui_texture = "head_wotr_face_14",
		market_price = 5460,
		release_name = "berserk",
		ui_sort_index = 14,
		ui_header = "menu_squire_painted",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_03/chr_wotr_head_03_painted",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_26,
			BeardNames.saxon_beard_27,
			BeardNames.saxon_beard_28,
			BeardNames.saxon_beard_29,
			BeardNames.saxon_beard_30,
			BeardNames.saxon_beard_31,
			BeardNames.saxon_beard_32,
			BeardNames.saxon_beard_37,
			BeardNames.saxon_beard_38,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	squire_bandage = {
		ui_texture = "head_wotr_face_13",
		market_price = 3780,
		release_name = "berserk",
		ui_sort_index = 10,
		ui_header = "menu_squire_bandage",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_03/chr_wotr_head_03_bandage",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.saxon_beard_26,
			BeardNames.saxon_beard_27,
			BeardNames.saxon_beard_28,
			BeardNames.saxon_beard_29,
			BeardNames.saxon_beard_30,
			BeardNames.saxon_beard_31,
			BeardNames.saxon_beard_32,
			BeardNames.saxon_beard_37,
			BeardNames.saxon_beard_38,
			BeardNames.saxon_beard_39
		},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	lady = {
		ui_texture = "head_wotr_face_04",
		ui_sort_index = 5,
		release_name = "main",
		voice = "female_saxon",
		ui_header = "menu_lady",
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_04/chr_wotr_head_04",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	lady_painted = {
		ui_texture = "head_wotr_face_17",
		release_name = "berserk",
		voice = "female_saxon",
		ui_sort_index = 17,
		ui_header = "menu_lady_painted",
		market_price = 5460,
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_04/chr_wotr_head_04_painted",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	lady_scarred = {
		ui_texture = "head_wotr_face_18",
		release_name = "berserk",
		voice = "female_saxon",
		ui_sort_index = 9,
		ui_header = "menu_lady",
		market_price = 1940,
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_04/chr_wotr_head_04_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	lady_eyepatch = {
		ui_texture = "head_wotr_face_16",
		release_name = "berserk",
		voice = "female_saxon",
		ui_sort_index = 13,
		ui_header = "menu_lady_eyepatch",
		market_price = 3780,
		unit = "units/beings/chr_wotr_heads/chr_wotr_head_04/chr_wotr_head_04_eyepatch",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	saxon_5 = {
		ui_texture = "head_wotr_face_05",
		ui_sort_index = 1,
		release_name = "vanguard",
		voice = "female_saxon",
		ui_header = "menu_warriormaiden",
		unit = "units/beings/chr_wotr_heads/chr_saxon_face_warriormaiden/chr_be_saxon_head_warriormaiden",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {
			{
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_female_short/arm_be_hair_saxon_female_short",
				unit = "units/beings/chr_hair/arm_be_hair_saxon_female_short/arm_be_hair_saxon_female_short",
				no_decapitation = true,
				node_linking = AttachmentNodeLinking.hair.standard
			}
		}
	},
	saxon_6 = {
		ui_texture = "head_wotr_face_05",
		ui_sort_index = 1,
		release_name = "vanguard",
		voice = "female_saxon",
		ui_header = "menu_warriormaiden",
		unit = "units/beings/chr_wotr_heads/chr_saxon_face_warriormaiden/chr_be_saxon_head_warriormaiden",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		hair_variations = {},
		facial_variations = {},
		attachments = {}
	},
	viking_1 = {
		ui_texture = "head_viking_face_01",
		ui_header = "menu_viking_1",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_1/chr_be_viking_face_1",
		release_name = "main",
		ui_sort_index = 2,
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_11,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_2 = {
		ui_sort_index = 5,
		ui_texture = "head_viking_face_20",
		release_name = "berserk",
		voice = "female_viking",
		ui_header = "menu_viking_2",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_female/chr_viking_face_female",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		attachments = {}
	},
	viking_3 = {
		ui_texture = "head_viking_face_03",
		ui_header = "menu_viking_3",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_youngblood/chr_viking_face_youngblood",
		release_name = "main",
		ui_sort_index = 3,
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_4 = {
		ui_texture = "head_viking_face_04",
		ui_header = "menu_viking_4",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_longtooth/chr_viking_face_longtooth",
		release_name = "berserk",
		ui_sort_index = 4,
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_5 = {
		ui_sort_index = 1,
		ui_texture = "head_viking_face_14",
		release_name = "vanguard",
		voice = "female_viking",
		ui_header = "menu_viking_5",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_shieldmaiden/chr_be_viking_head_shieldmaiden",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		attachments = {
			{
				material_variation = "units/beings/chr_hair/arm_be_hair_pocahontas/arm_be_hair_pocahontas",
				unit = "units/beings/chr_hair/arm_be_hair_pocahontas/arm_be_hair_pocahontas",
				no_decapitation = true,
				node_linking = AttachmentNodeLinking.hair.standard
			}
		}
	},
	viking_6 = {
		ui_texture = "head_viking_face_19",
		ui_header = "menu_viking_6",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_berserk/chr_viking_berserk_head",
		release_name = "berserk",
		ui_sort_index = 1,
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_berserker
		},
		attachments = {}
	},
	viking_7 = {
		market_price = 1940,
		ui_texture = "head_viking_face_06",
		release_name = "berserk",
		ui_sort_index = 8,
		ui_header = "menu_viking_7",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_longtooth/chr_viking_face_longtooth_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_8 = {
		market_price = 3780,
		ui_texture = "head_viking_face_05",
		release_name = "berserk",
		ui_sort_index = 12,
		ui_header = "menu_viking_8",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_longtooth/chr_viking_face_longtooth_eyepatch",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_9 = {
		market_price = 5460,
		ui_texture = "head_viking_face_07",
		release_name = "berserk",
		ui_sort_index = 17,
		ui_header = "menu_viking_9",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_longtooth/chr_viking_face_longtooth_tatooed",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_10 = {
		market_price = 3780,
		ui_texture = "head_viking_face_10",
		release_name = "berserk",
		ui_sort_index = 11,
		ui_header = "menu_viking_10",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_youngblood/chr_viking_face_youngblood_tatooed",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_11 = {
		market_price = 1940,
		ui_texture = "head_viking_face_09",
		release_name = "berserk",
		ui_sort_index = 7,
		ui_header = "menu_viking_11",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_youngblood/chr_viking_face_youngblood_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_12 = {
		market_price = 5460,
		ui_texture = "head_viking_face_08",
		release_name = "berserk",
		ui_sort_index = 15,
		ui_header = "menu_viking_12",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_youngblood/chr_viking_face_youngblood_mascara",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_13 = {
		ui_sort_index = 13,
		ui_texture = "head_viking_face_16",
		release_name = "berserk",
		voice = "female_viking",
		ui_header = "menu_viking_13",
		market_price = 3780,
		unit = "units/beings/chr_wotr_heads/chr_viking_face_female/chr_viking_face_female_eyepatch",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		attachments = {}
	},
	viking_14 = {
		voice = "female_viking",
		ui_texture = "head_viking_face_17",
		release_name = "berserk",
		ui_sort_index = 9,
		ui_header = "menu_viking_14",
		market_price = 1940,
		unit = "units/beings/chr_wotr_heads/chr_viking_face_female/chr_viking_face_female_scarred",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		attachments = {}
	},
	viking_15 = {
		ui_sort_index = 18,
		ui_texture = "head_viking_face_18",
		release_name = "berserk",
		voice = "female_viking",
		ui_header = "menu_viking_15",
		market_price = 5460,
		unit = "units/beings/chr_wotr_heads/chr_viking_face_female/chr_viking_face_female_tattooed",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {},
		attachments = {}
	},
	viking_16 = {
		market_price = 1940,
		ui_texture = "head_viking_face_12",
		release_name = "berserk",
		ui_sort_index = 6,
		ui_header = "menu_viking_16",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_1/chr_be_viking_face_1_scratched",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_11,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_17 = {
		market_price = 3780,
		ui_texture = "head_viking_face_11",
		release_name = "berserk",
		ui_sort_index = 10,
		ui_header = "menu_viking_17",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_1/chr_be_viking_face_1_broken_jaw",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_11,
			BeardNames.viking_beard_12
		},
		attachments = {}
	},
	viking_18 = {
		market_price = 5460,
		ui_texture = "head_viking_face_13",
		release_name = "berserk",
		ui_sort_index = 14,
		ui_header = "menu_viking_18",
		unit = "units/beings/chr_wotr_heads/chr_viking_face_1/chr_be_viking_face_1_tattooed",
		attachment_node_linking = AttachmentNodeLinking.heads.standard,
		beard_variations = {
			BeardNames.no_beard,
			BeardNames.viking_beard_04,
			BeardNames.viking_beard_05,
			BeardNames.viking_beard_06,
			BeardNames.viking_beard_07,
			BeardNames.viking_beard_08,
			BeardNames.viking_beard_09,
			BeardNames.viking_beard_10,
			BeardNames.viking_beard_11,
			BeardNames.viking_beard_12
		},
		attachments = {}
	}
}
Heads = {}

for name, head in pairs(BaseHeads) do
	head.name = name
	head.entity_type = "head"
	head.ui_description = ui_description
	head.market_price = head.market_price or nil
	head.ui_sort_index = head.ui_sort_index or 1
	Heads[name] = head
end

DEFAULT_HEAD_UNLOCK_LIST = {}

function default_head_unlocks()
	local default_unlocks = {}
	local entity_type = "head"

	for head_name, head in pairs(Heads) do
		if not head.market_price or head.unlock_this_item or DEFAULT_HEAD_UNLOCK_LIST[head_name] then
			head.market_price = nil

			local entity_name = entity_type .. "|" .. head_name

			default_unlocks[entity_name] = {
				category = entity_type,
				name = head_name
			}
		end
	end

	return default_unlocks
end
