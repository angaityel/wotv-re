-- chunkname: @scripts/settings/helmets.lua

require("scripts/settings/attachment_node_linking")
require("scripts/settings/dlc_settings")

local HELMET_ABSORPTION = 0.3

HelmetCrests = {}
HelmetCoifs = {}
HelmetPlumes = {}
HelmetFeathers = {}
HelmetPatterns = {
	pattern_standard = {
		ui_description = "helmet_metal_pattern_rusty_description",
		name = "helmet_metal_pattern_rusty",
		atlas_variation = 0,
		type = "pattern",
		unlock_key = 24,
		release_name = "main",
		ui_header = "helmet_metal_pattern_rusty_header",
		pattern_variation = 0,
		encumbrance = 0
	}
}
HelmetVisors = {}
HelmetAttachments = {
	standard = {
		pattern_standard = HelmetPatterns.pattern_standard,
		default_unlocks = {}
	}
}
BaseHelmets = {
	helmet_sutton_hoo_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "helmet_sutton_hoo_helmet_light",
		market_price = 3700,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_light",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_sutton_hoo_light",
		ui_sort_index = 1,
		tier = 1,
		category = "light",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_basic_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_wessex_light_1",
		market_price = 2450,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_light",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_light",
		ui_sort_index = 1,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_light",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "saxon_helmet_wessex_light_2",
				tier = 1,
				market_price = 3750,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_hawk_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_eagle_light_1",
		market_price = 2250,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_viking_hawk_helmet_light",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_hawk_helmet_light",
		ui_sort_index = 1,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_medium",
				release_name = "main",
				tier = 1,
				ui_sort_index = 3
			},
			blue = {
				release_name = "main",
				ui_texture = "viking_helmet_eagle_light_3",
				tier = 1,
				market_price = 3450,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_blue",
				ui_sort_index = 2
			},
			black = {
				release_name = "main",
				ui_texture = "viking_helmet_eagle_light_2",
				tier = 1,
				market_price = 4710,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_black",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_viking_hood_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_hood",
		ui_sort_index = 4,
		market_price = 36200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_hood/arm_be_helmet_hood_viking",
		team = "viking",
		ui_fluff_text = "helmet_viking_hood_light_fluff",
		no_decapitation = true,
		tier = 1,
		category = "light",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_cloth"
			},
			g_be_helmet_lod1 = {
				"mtr_cloth"
			},
			g_be_helmet_lod2 = {
				"mtr_cloth"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_cloth"
			},
			g_be_helmet_lod1 = {
				"mtr_cloth"
			},
			g_be_helmet_lod2 = {
				"mtr_cloth"
			}
		}
	},
	helmet_saxon_hood_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_hood",
		ui_sort_index = 5,
		market_price = 36200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_hood/arm_be_helmet_hood_saxon",
		team = "saxon",
		ui_fluff_text = "helmet_saxon_hood_light_fluff",
		no_decapitation = true,
		tier = 1,
		category = "light",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_cloth"
			},
			g_be_helmet_lod1 = {
				"mtr_cloth"
			},
			g_be_helmet_lod2 = {
				"mtr_cloth"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_cloth"
			},
			g_be_helmet_lod1 = {
				"mtr_cloth"
			},
			g_be_helmet_lod2 = {
				"mtr_cloth"
			}
		}
	},
	yogscast_helmet_viking = {
		encumbrance = 8,
		release_name = "promo",
		armour_type = "armour_mail",
		hide_if_unavailable = true,
		ui_texture = "saxon_helmet_yogcast",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_yogscast/arm_be_helmet_yogscast",
		ui_sort_index = 8,
		team = "viking",
		ui_fluff_text = "helmet_saxon_hood_light_fluff",
		no_decapitation = true,
		tier = 1,
		category = "light",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.yogscast,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	dev_helmet = {
		team = "viking",
		release_name = "promo",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_dev_helmet",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_dev_helmet/be_dev_helmet",
		encumbrance = 8,
		ui_sort_index = 8,
		hide_if_unavailable = true,
		developer_item = true,
		ui_fluff_text = "helmet_saxon_hood_light_fluff",
		no_decapitation = true,
		tier = 1,
		category = "light",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.yogscast,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		}
	},
	helmet_viking_basic_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_basic_light_1",
		market_price = 21400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/arm_be_helmet_viking_basic_light",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_light",
		ui_sort_index = 3,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "viking_helmet_basic_light_2",
				tier = 1,
				market_price = 21200,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_cone_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_cone_1",
		market_price = 8400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_light_cone/arm_be_helmet_saxon_light_cone",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_cone_helmet_light",
		ui_sort_index = 2,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_light_cone/arm_be_helmet_saxon_light_cone",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "saxon_helmet_cone_2",
				tier = 1,
				market_price = 10400,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_light_cone/arm_be_helmet_saxon_light_cone_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_cone_cross_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_cone_cross_1",
		market_price = 12700,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_light_cone_cross/arm_be_helmet_saxon_light_cone_cross",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_cone_helmet_light",
		ui_sort_index = 3,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_light_cone_cross/arm_be_helmet_saxon_light_cone_cross",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "saxon_helmet_cone_cross_2",
				tier = 1,
				market_price = 12100,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_light_cone_cross/arm_be_helmet_saxon_light_cone_cross_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_checker_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_cheker_light_1",
		market_price = 8400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_light_checker/arm_be_helmet_viking_light_checker",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_checker_helmet_light",
		ui_sort_index = 2,
		tier = 1,
		category = "light",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "viking_helmet_cheker_light_1",
				tier = 1,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_light_checker/arm_be_helmet_viking_light_checker_rough",
				ui_sort_index = 3
			},
			gold = {
				release_name = "main",
				ui_texture = "viking_helmet_cheker_light_3",
				tier = 1,
				market_price = 13200,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_light_checker/arm_be_helmet_viking_light_checker",
				ui_sort_index = 1
			},
			gold_leather_variation = {
				release_name = "main",
				ui_texture = "viking_helmet_cheker_light_3",
				tier = 1,
				market_price = 11400,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_light_checker/arm_be_helmet_viking_light_checker_leathervariation",
				ui_sort_index = 2
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_berserk_bareheaded_viking = {
		ui_texture = "no_helmet_viking",
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		hide_if_unavailable = false,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_berserk_bareheaded/arm_be_helmet_berserk_bareheaded",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_no_helmet",
		ui_sort_index = 1,
		tier = 1,
		category = "berserk",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod1 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod2 = {
				"be_face_skin_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod1 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod2 = {
				"be_face_skin_mat"
			}
		}
	},
	helmet_berserk_bareheaded_saxon = {
		ui_texture = "saxon_berserker_no_hair",
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		hide_if_unavailable = false,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_berserk_bareheaded/arm_be_helmet_berserk_bareheaded",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_no_helmet",
		ui_sort_index = 1,
		tier = 1,
		category = "berserk",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod1 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod2 = {
				"be_face_skin_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod1 = {
				"be_face_skin_mat"
			},
			g_be_helmet_lod2 = {
				"be_face_skin_mat"
			}
		}
	},
	helmet_berserk_viking_brown = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "helmet_berserker_viking_brown",
		market_price = 7200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_berserk/arm_be_helmet_berserk_brown",
		ui_sort_index = 2,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_berserk_helmet",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		}
	},
	helmet_berserk_viking_white = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "helmet_berserker_viking_black",
		market_price = 11600,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_berserk/arm_be_helmet_berserk_white",
		ui_sort_index = 3,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_berserk_helmet_white",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		}
	},
	helmet_berserk_viking_black = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "helmet_berserker_viking_white",
		market_price = 19800,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_berserk/arm_be_helmet_berserk_black",
		ui_sort_index = 4,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_berserk_helmet_black",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_berserk"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_berserk"
			}
		}
	},
	helmet_berserk_saxon_01 = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "saxon_berserker_hair_01",
		market_price = 5480,
		penetration_value = 15,
		unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
		ui_sort_index = 3,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_berserk_helmet",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_01",
				tier = 1,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_brown",
				ui_sort_index = 1
			},
			black = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_01_black",
				tier = 1,
				market_price = 980,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_black",
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_01_red",
				tier = 1,
				market_price = 1440,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
				ui_sort_index = 3
			},
			gray = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_01_gray",
				tier = 1,
				market_price = 2080,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_gray",
				ui_sort_index = 4
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		},
		preview_unit_meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		}
	},
	helmet_berserk_saxon_02 = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "saxon_berserker_hair_02",
		market_price = 7200,
		penetration_value = 15,
		unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_02",
		ui_sort_index = 4,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_berserk_helmet_1",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_02",
				tier = 1,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_brown",
				ui_sort_index = 1
			},
			black = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_02_black",
				tier = 1,
				market_price = 980,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_black",
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_02_red",
				tier = 1,
				market_price = 1440,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
				ui_sort_index = 3
			},
			gray = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_02_gray",
				tier = 1,
				market_price = 2080,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_gray",
				ui_sort_index = 4
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		},
		preview_unit_meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		}
	},
	helmet_berserk_saxon_03 = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "saxon_berserker_hair_03",
		market_price = 9800,
		penetration_value = 15,
		unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_03",
		ui_sort_index = 5,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_berserk_helmet_3",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_03",
				tier = 1,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_brown",
				ui_sort_index = 1
			},
			black = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_03_black",
				tier = 1,
				market_price = 980,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_black",
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_03_red",
				tier = 1,
				market_price = 1440,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
				ui_sort_index = 3
			},
			gray = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_03_gray",
				tier = 1,
				market_price = 2080,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_gray",
				ui_sort_index = 4
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		},
		preview_unit_meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		}
	},
	helmet_berserk_saxon_04 = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "saxon_berserker_hair_04",
		market_price = 2460,
		penetration_value = 15,
		unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_04",
		ui_sort_index = 2,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_berserk_helmet_4",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_04",
				tier = 1,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_brown",
				ui_sort_index = 1
			},
			black = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_04_black",
				tier = 1,
				market_price = 980,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_black",
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_04_red",
				tier = 1,
				market_price = 1440,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
				ui_sort_index = 3
			},
			gray = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_04_gray",
				tier = 1,
				market_price = 2080,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_gray",
				ui_sort_index = 4
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		},
		preview_unit_meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		}
	},
	helmet_berserk_saxon_05 = {
		encumbrance = 8,
		release_name = "berserk",
		armour_type = "armour_mail",
		ui_texture = "saxon_berserker_hair_05",
		market_price = 12600,
		penetration_value = 15,
		unit = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_05",
		ui_sort_index = 6,
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_berserk_helmet_5",
		no_decapitation = true,
		tier = 1,
		category = "berserk",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_05",
				tier = 1,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_brown",
				ui_sort_index = 1
			},
			black = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_05_black",
				tier = 1,
				market_price = 980,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_black",
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_05_red",
				tier = 1,
				market_price = 1440,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01",
				ui_sort_index = 3
			},
			gray = {
				release_name = "main",
				ui_texture = "saxon_berserker_hair_05_gray",
				tier = 1,
				market_price = 2080,
				material_variation = "units/beings/chr_hair/arm_be_hair_saxon_berserker/arm_be_saxon_berserker_hair_01_gray",
				ui_sort_index = 4
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		},
		preview_unit_meshes = {
			g_berserker_hair_01 = {
				"mtr_hair"
			}
		}
	},
	helmet_sutton_hoo_medium = {
		ui_texture = "saxon_helmet_sutton_hoo_medium_1",
		hide_if_unavailable = true,
		encumbrance = 8,
		armour_type = "armour_mail",
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_medium",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_sutton_hoo_medium",
		ui_sort_index = 4,
		tier = 1,
		category = "medium",
		material_variations = {
			basic = {
				release_name = "main",
				ui_texture = "saxon_helmet_sutton_hoo_medium_2",
				tier = 1,
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_heavy",
				ui_sort_index = 1,
				required_dlc = DLCSettings.premium
			},
			default = {
				release_name = "main",
				ui_texture = "saxon_helmet_sutton_hoo_medium_1",
				tier = 1,
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_basic",
				ui_sort_index = 2,
				required_dlc = DLCSettings.premium_or_beagle
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.premium_or_beagle,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_basic_medium = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_wessex_medium_1",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_medium",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_medium",
		ui_sort_index = 1,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_light",
				release_name = "main",
				tier = 1,
				ui_sort_index = 3
			},
			gold = {
				release_name = "main",
				ui_texture = "saxon_helmet_wessex_medium_2",
				tier = 1,
				market_price = 7200,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_gold",
				ui_sort_index = 2
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_hird = {
		ui_texture = "viking_helmet_hird",
		encumbrance = 8,
		release_name = "post",
		armour_type = "armour_mail",
		hide_if_unavailable = true,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_hird/arm_be_helmet_viking_hird",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_medium",
		ui_sort_index = 6,
		tier = 1,
		category = "medium",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.shieldmaiden_dlc_helmet,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"m_iron"
			},
			g_be_helmet_lod1 = {
				"m_iron"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"m_iron"
			},
			g_be_helmet_lod1 = {
				"m_iron"
			}
		}
	},
	helmet_saxon_aide = {
		ui_texture = "saxon_helmet_aide",
		hide_if_unavailable = true,
		release_name = "post",
		armour_type = "armour_mail",
		encumbrance = 8,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_aide_helmet/arm_be_saxon_aide_helmet",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_medium",
		ui_sort_index = 4,
		tier = 1,
		category = "medium",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.shieldmaiden_dlc_helmet,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"m_iron"
			},
			g_be_helmet_lod1 = {
				"m_iron"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"m_iron"
			},
			g_be_helmet_lod1 = {
				"m_iron"
			}
		}
	},
	helmet_saxon_basic_medium_early_access = {
		ui_texture = "saxon_helmet_wessex_medium_3",
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		hide_if_unavailable = true,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_medium",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_medium",
		ui_sort_index = 2,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				ui_texture = "saxon_helmet_wessex_medium_3",
				tier = 1,
				release_name = "main",
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_black",
				ui_sort_index = 3,
				required_dlc = DLCSettings.early_access
			}
		},
		required_dlc = DLCSettings.early_access,
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_hawk_medium = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_eagle_medium_1",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_medium",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_hawk_helmet_medium",
		ui_sort_index = 1,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "viking_helmet_eagle_medium_1",
				tier = 1,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_medium",
				ui_sort_index = 2
			},
			black = {
				release_name = "main",
				ui_texture = "viking_helmet_eagle_medium_2",
				tier = 1,
				market_price = 3750,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_hawk/be_arm_helmet_viking_hawk_black",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_vendel_1 = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_vendelhelm_1",
		market_price = 19400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_1",
		team = "viking",
		ui_fluff_text = "helmet_fluff_vendel_1",
		ui_sort_index = 4,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_1",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			black = {
				release_name = "main",
				ui_texture = "viking_helmet_vendelhelm_2",
				tier = 1,
				market_price = 22600,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_black",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		}
	},
	helmet_viking_basic_medium = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_basic_medium_1",
		market_price = 7200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/arm_be_helmet_viking_basic_medium",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_medium",
		ui_sort_index = 3,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy",
				release_name = "main",
				tier = 1,
				ui_sort_index = 3
			},
			gold = {
				release_name = "main",
				ui_texture = "viking_helmet_basic_medium_2",
				tier = 1,
				market_price = 11400,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_gold",
				ui_sort_index = 2
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_basic_medium_early_access = {
		ui_texture = "viking_helmet_basic_medium_3",
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		hide_if_unavailable = true,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/arm_be_helmet_viking_basic_medium",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_medium",
		ui_sort_index = 2,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				ui_texture = "viking_helmet_basic_medium_3",
				tier = 1,
				release_name = "main",
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_black",
				ui_sort_index = 1,
				required_dlc = DLCSettings.early_access
			}
		},
		required_dlc = DLCSettings.early_access,
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_leather_light = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_leather_hat_1",
		market_price = 20400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_leather_helmet/arm_be_helmet_saxon_leather_helmet",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_medium",
		ui_sort_index = 4,
		tier = 1,
		category = "medium",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_leather_helmet/arm_be_helmet_saxon_leather_helmet",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			red = {
				release_name = "main",
				ui_texture = "saxon_helmet_leather_hat_2",
				tier = 1,
				market_price = 22600,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_leather_helmet/arm_be_helmet_saxon_leather_helmet_red",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_saxon_jarl = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_jarl_1",
		market_price = 19400,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_jarl_helmet/arm_be_helmet_saxon_jarl_helmet",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_helmet_saxon_jarl",
		ui_sort_index = 3,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				release_name = "main",
				ui_texture = "saxon_helmet_jarl_2",
				tier = 1,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_jarl_helmet/arm_be_helmet_saxon_jarl_helmet",
				ui_sort_index = 1
			},
			silver = {
				release_name = "main",
				ui_texture = "saxon_helmet_jarl_1",
				tier = 2,
				market_price = 22600,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_jarl_helmet/arm_be_helmet_saxon_jarl_silver",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		}
	},
	helmet_mask_of_hel_medium = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_mask_of_hel_medium",
		market_price = 36200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_mask_of_hel/arm_be_helmet_mask_of_hel_medium",
		team = "viking",
		ui_fluff_text = "helmet_fluff_helmet_mask_of_hel",
		ui_sort_index = 5,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_mask_of_hel_hood_medium = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_mask_of_hel_hood_medium",
		ui_sort_index = 7,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_mask_of_hel/arm_be_helmet_mask_of_hel_hood_medium",
		hide_if_unavailable = true,
		team = "viking",
		ui_fluff_text = "helmet_fluff_helmet_mask_of_hel",
		no_decapitation = true,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.premium,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {},
			g_be_helmet_lod1 = {},
			g_be_helmet_lod2 = {}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {},
			g_be_helmet_lod1 = {},
			g_be_helmet_lod2 = {}
		}
	},
	helmet_vendel_heavy = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "helmet_viking_vendel_heavy",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_heavy",
		team = "viking",
		ui_fluff_text = "helmet_fluff_vendel_1",
		ui_sort_index = 1,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_heavy",
				release_name = "main"
			},
			black = {
				release_name = "main",
				ui_texture = "viking_helmet_vendel_heavy_2",
				material_variation = "units/armour/helmets/arm_be_helmet_viking_vendel_1/arm_be_helmet_viking_vendel_heavy_black",
				market_price = 3450
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_chain_mail_mat"
			}
		}
	},
	helmet_sutton_hoo_heavy = {
		ui_texture = "saxon_helmet_sutton_hoo_heavy_1",
		release_name = "main",
		armour_type = "armour_mail",
		encumbrance = 8,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_heavy",
		hide_if_unavailable = true,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_sutton_hoo_heavy",
		ui_sort_index = 5,
		tier = 1,
		category = "heavy",
		material_variations = {
			silver = {
				ui_texture = "saxon_helmet_sutton_hoo_heavy_2",
				tier = 1,
				release_name = "main",
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_heavy",
				ui_sort_index = 1,
				required_dlc = DLCSettings.premium
			},
			default = {
				ui_texture = "saxon_helmet_sutton_hoo_heavy_1",
				tier = 1,
				release_name = "main",
				hide_if_unavailable = true,
				material_variation = "units/armour/helmets/arm_be_helmet_sutton_hoo/arm_be_sutton_hoo_helmet_basic",
				ui_sort_index = 2,
				required_dlc = DLCSettings.premium_or_beagle
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.premium_or_beagle,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_saxon_basic_heavy = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_wessex_heavy_1",
		market_price = 3000,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_heavy",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_heavy",
		ui_sort_index = 1,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_light",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "saxon_helmet_wessex_heavy_2",
				tier = 1,
				market_price = 3450,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_basic_helmet/be_arm_saxon_basic_helmet_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_basic_heavy = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_basic_heavy_1",
		market_price = 9600,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/arm_be_helmet_viking_basic_heavy",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_heavy",
		ui_sort_index = 3,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "viking_helmet_basic_heavy_2",
				tier = 1,
				market_price = 11200,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_faceguard_lod0 = {
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_faceguard_lod1 = {
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_faceguard_lod2 = {
				"mtr_be_helmet_iron_face_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat",
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat",
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat",
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_faceguard_lod0 = {
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_faceguard_lod1 = {
				"mtr_be_helmet_iron_face_mat"
			},
			g_be_faceguard_lod2 = {
				"mtr_be_helmet_iron_face_mat"
			}
		}
	},
	helmet_viking_basic_heavy_leather = {
		encumbrance = 8,
		material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_leather",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_basic_heavy_leather_1",
		release_name = "main",
		market_price = 7200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/arm_be_helmet_viking_basic_heavy_leather",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_basic_helmet_heavy_leather",
		ui_sort_index = 2,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_leather",
				release_name = "main",
				tier = 1,
				ui_sort_index = 2
			},
			leather_gold = {
				release_name = "main",
				ui_texture = "viking_helmet_basic_heavy_leather_2",
				tier = 1,
				market_price = 9600,
				material_variation = "units/armour/helmets/arm_be_helmet_viking_basic_helmet/be_arm_viking_basic_helmet_heavy_leather_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold_mat"
			}
		}
	},
	helmet_viking_snakeye_heavy = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_snakeye_heavy_2",
		market_price = 21700,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_saxon_heavy_snakeeye/arm_be_saxon_snakeeye_helmet_heavy",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_snakeye_helmet_heavy",
		ui_sort_index = 4,
		tier = 1,
		category = "heavy",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_heavy_snakeeye/arm_be_saxon_snakeeye_helmet_heavy_rough",
				release_name = "main",
				tier = 1,
				ui_sort_index = 3
			},
			rough = {
				release_name = "main",
				ui_texture = "viking_helmet_snakeye_heavy_1",
				tier = 1,
				market_price = 20800,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_heavy_snakeeye/arm_be_saxon_snakeeye_helmet_heavy",
				ui_sort_index = 2
			},
			gold = {
				release_name = "main",
				ui_texture = "viking_helmet_snakeye_heavy_3",
				tier = 1,
				market_price = 27600,
				material_variation = "units/armour/helmets/arm_be_helmet_saxon_heavy_snakeeye/arm_be_saxon_snakeeye_helmet_heavy_gold",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_mask_of_hel = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_mask_of_hel",
		market_price = 36200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_mask_of_hel/arm_be_helmet_mask_of_hel",
		team = "viking",
		ui_fluff_text = "helmet_fluff_helmet_mask_of_hel",
		ui_sort_index = 5,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_mask_of_hel_hood = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "viking_helmet_mask_of_hel_hood",
		hide_if_unavailable = true,
		ui_sort_index = 6,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_mask_of_hel/arm_be_helmet_mask_of_hel_hood",
		team = "viking",
		ui_fluff_text = "helmet_fluff_helmet_mask_of_hel",
		no_decapitation = true,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.premium,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {},
			g_be_helmet_lod1 = {},
			g_be_helmet_lod2 = {}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {},
			g_be_helmet_lod1 = {},
			g_be_helmet_lod2 = {}
		}
	},
	helmet_viking_valhalla = {
		ui_texture = "viking_helmet_valhalla",
		release_name = "main",
		armour_type = "armour_mail",
		encumbrance = 8,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_viking_valhalla/arm_be_helmet_viking_valhalla",
		hide_if_unavailable = true,
		team = "viking",
		ui_fluff_text = "helmet_fluff_helmet_mask_of_hel",
		ui_sort_index = 6,
		tier = 1,
		category = "medium",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		required_dlc = DLCSettings.premium_or_beagle,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		}
	},
	helmet_saxon_heavy_worn = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_heavy_1",
		ui_sort_index = 2,
		market_price = 7200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_saxon_heavy_helmet/arm_be_saxon_heavy_helmet",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_helmet_saxon_heavy_worn",
		no_decapitation = true,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		}
	},
	helmet_saxon_heavy_normal = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_heavy_2",
		ui_sort_index = 3,
		market_price = 21300,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_saxon_heavy_helmet/arm_be_saxon_heavy_helmet_normal",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_helmet_saxon_heavy_worn",
		no_decapitation = true,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		}
	},
	helmet_saxon_heavy_fancy = {
		encumbrance = 8,
		release_name = "main",
		armour_type = "armour_mail",
		ui_texture = "saxon_helmet_heavy_3",
		ui_sort_index = 4,
		market_price = 36200,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_saxon_heavy_helmet/arm_be_saxon_heavy_helmet_fancy",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_helmet_saxon_heavy_worn",
		no_decapitation = true,
		tier = 1,
		category = "heavy",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_chain_mail"
			}
		}
	},
	helmet_warrior_maiden_heavy = {
		ui_texture = "saxon_helmet_warrior_maiden_3",
		release_name = "vanguard",
		armour_type = "armour_mail",
		encumbrance = 8,
		market_price = 27600,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_warrior_maiden_helmet/arm_be_helmet_warrior_maiden",
		hide_if_unavailable = false,
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_heavy",
		ui_sort_index = 2,
		tier = 1,
		category = "shield_maiden",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold",
				"mtr_be_helmet_hair"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold",
				"mtr_be_helmet_hair"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold",
				"mtr_be_helmet_hair"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold",
				"mtr_be_helmet_hair"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			}
		}
	},
	helmet_warrior_maiden_02_heavy = {
		ui_texture = "saxon_helmet_warrior_maiden_1",
		encumbrance = 8,
		release_name = "vanguard",
		armour_type = "armour_mail",
		hide_if_unavailable = false,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_warrior_maiden_helmet/arm_be_helmet_warrior_maiden_02",
		team = "saxon",
		ui_fluff_text = "helmet_fluff_saxon_basic_helmet_02_heavy",
		ui_sort_index = 1,
		tier = 1,
		category = "shield_maiden",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_warrior_maiden_helmet/arm_be_helmet_warrior_maiden_03",
				hide_if_unavailable = false,
				tier = 1,
				release_name = "vanguard",
				ui_sort_index = 2
			},
			maiden_03 = {
				release_name = "vanguard",
				ui_texture = "saxon_helmet_warrior_maiden_2",
				tier = 1,
				market_price = 7200,
				hide_if_unavailable = false,
				material_variation = "units/armour/helmets/arm_be_warrior_maiden_helmet/arm_be_helmet_warrior_maiden",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat",
				"mtr_be_helmet_gold"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_leather_mat"
			}
		}
	},
	helmet_shield_maiden_ornamented_heavy = {
		ui_texture = "viking_helmet_shieldmaiden_1",
		encumbrance = 8,
		release_name = "vanguard",
		armour_type = "armour_mail",
		hide_if_unavailable = false,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_shield_maiden/arm_be_shieldmaiden_plane_helmet_heavy",
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_shield_maiden_helmet_ornamented_heavy",
		ui_sort_index = 1,
		tier = 1,
		category = "shield_maiden",
		material_variations = {
			default = {
				material_variation = "units/armour/helmets/arm_be_helmet_shield_maiden/arm_be_shieldmaiden_plane_rough_helmet_heavy",
				hide_if_unavailable = false,
				tier = 1,
				release_name = "vanguard",
				ui_sort_index = 3
			},
			rough = {
				release_name = "vanguard",
				ui_texture = "viking_helmet_shieldmaiden_2",
				tier = 1,
				market_price = 7200,
				hide_if_unavailable = false,
				material_variation = "units/armour/helmets/arm_be_helmet_shield_maiden/arm_be_shieldmaiden_plane_helmet_heavy",
				ui_sort_index = 2
			},
			extravagant_no_feathers = {
				release_name = "vanguard",
				ui_texture = "viking_helmet_shieldmaiden_3",
				tier = 1,
				market_price = 11400,
				hide_if_unavailable = false,
				material_variation = "units/armour/helmets/arm_be_helmet_shield_maiden/arm_be_shieldmaiden_extravagant_helmet_heavy",
				ui_sort_index = 1
			}
		},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat"
			}
		}
	},
	helmet_shield_maiden_extravagant_heavy = {
		ui_texture = "viking_helmet_shieldmaiden_extravagant",
		release_name = "vanguard",
		armour_type = "armour_mail",
		encumbrance = 8,
		market_price = 27600,
		penetration_value = 15,
		unit = "units/armour/helmets/arm_be_helmet_shield_maiden/arm_be_shieldmaiden_extravagant_helmet_heavy",
		hide_if_unavailable = false,
		team = "viking",
		ui_fluff_text = "helmet_fluff_viking_shield_maiden_helmet_extravagant_heavy",
		ui_sort_index = 2,
		tier = 1,
		category = "shield_maiden",
		material_variations = {},
		attachment_node_linking = AttachmentNodeLinking.helmets.standard,
		attachments = HelmetAttachments.standard,
		default_unlocks = HelmetAttachments.standard.default_unlocks,
		absorption_value = HELMET_ABSORPTION,
		ui_unit = {
			rotation = {
				{
					y = -90
				},
				{
					x = -85
				},
				{
					y = -15
				}
			},
			camera_position = Vector3Box(0, 0.4, 0.7)
		},
		meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			}
		},
		preview_unit_meshes = {
			g_be_helmet_lod0 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			},
			g_be_helmet_lod1 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			},
			g_be_helmet_lod2 = {
				"mtr_be_helmet_iron_mat",
				"mtr_be_helmet_feathers_mat"
			}
		}
	}
}
BaseHelmets.yogscast_helmet_saxon = table.clone(BaseHelmets.yogscast_helmet_viking)
BaseHelmets.yogscast_helmet_saxon.team = "saxon"
Helmets = {}
HelmetVariations = {}

for name, helmet in pairs(BaseHelmets) do
	helmet.name = name
	helmet.ui_header = "helmet_header_" .. name
	helmet.ui_description = "helmet_desc_" .. name
	helmet.ui_sort_index = helmet.ui_sort_index or 1
	helmet.entity_type = helmet.entity_type or "helmet"
	helmet.market_price = helmet.market_price

	for variation_name, variation in pairs(helmet.material_variations) do
		variation.name = helmet.name .. "_" .. variation_name
		variation.helmet_name = helmet.name
		variation.base_name = variation_name
		variation.ui_header = helmet.ui_header .. "_" .. variation_name
		variation.ui_texture = variation.ui_texture or helmet.ui_texture or "default"
		variation.ui_sort_index = variation.ui_sort_index or 1
		variation.entity_type = variation.entity_type or "helmet_variation"
		variation.market_price = variation.market_price
		HelmetVariations[variation.name] = variation
	end

	Helmets[name] = helmet
end

local unlock_keys = {}

local function check_unlock_keys(helmet_table)
	for attachment, props in pairs(helmet_table) do
		fassert(props.unlock_key, "Attachment %q missing unlock key", attachment)
		fassert(unlock_keys[props.unlock_key] == nil, "Duplicate unlock key found for %d", props.unlock_key)

		unlock_keys[props.unlock_key] = true
	end
end

check_unlock_keys(HelmetPatterns)

unlock_keys = nil
DEFAULT_HELMET_UNLOCK_LIST = {
	"helmet_viking_hawk_medium",
	"helmet_saxon_basic_medium",
	"helmet_vendel_heavy",
	"helmet_saxon_basic_heavy",
	"helmet_viking_hawk_light",
	"helmet_saxon_basic_light"
}

function default_helmet_unlocks()
	local default_unlocks = {}

	for helmet_name, props in pairs(Helmets) do
		if table.contains(DEFAULT_HELMET_UNLOCK_LIST, helmet_name) or props.required_dlc and props.required_dlc() then
			props.market_price = nil

			local entity_type = "helmet"
			local entity_name = entity_type .. "|" .. helmet_name

			default_unlocks[entity_name] = {
				category = entity_type,
				name = helmet_name
			}
		end

		local variations = props.material_variations

		if variations then
			for variation_name, variation in pairs(variations) do
				if variation.default_unlock or variation.required_dlc and variation.required_dlc() then
					default_unlocks[variation.entity_type .. "|" .. variation.name] = {
						category = variation.entity_type,
						name = variation.name
					}
				end
			end
		end
	end

	return default_unlocks
end

function default_helmet_attachment_unlocks()
	local default_unlocks = {}

	return default_unlocks
end
