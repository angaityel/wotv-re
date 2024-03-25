-- chunkname: @scripts/settings/cloaks.lua

require("scripts/settings/attachment_node_linking")

BaseCloakPatterns = {}

local tier_increase = 0.12

for i = 1, 32 do
	local pattern_table = {}

	pattern_table.name = "cloak_pattern_" .. i
	pattern_table.ui_header = "Cloak Pattern test " .. i .. " UI Header"
	pattern_table.white_cloak = "long_cloak_saxon"
	pattern_table.red_cloak = "long_cloak_viking"
	pattern_table.ui_description = "This is cloak pattern test " .. i
	pattern_table.ui_fluff_text = nil
	pattern_table.pattern_variation = 1
	pattern_table.atlas_variation = i - 1
	pattern_table.release_name = "main"
	pattern_table.index = i
	pattern_table.texture_func = "cb_base_cloak_pattern_material"

	if i == 32 then
		pattern_table.market_price = 9750
		pattern_table.tier = 5
	elseif i == 31 then
		pattern_table.market_price = 7780
		pattern_table.tier = 5
	elseif i == 30 then
		pattern_table.market_price = 6990
		pattern_table.tier = 5
	elseif i == 29 then
		pattern_table.market_price = 6240
		pattern_table.tier = 5
	elseif i == 28 then
		pattern_table.market_price = 13900
		pattern_table.tier = 4
	elseif i == 27 then
		pattern_table.market_price = 11600
		pattern_table.tier = 4
	elseif i == 26 then
		pattern_table.market_price = 9450
		pattern_table.tier = 4
	elseif i == 25 then
		pattern_table.market_price = 7110
		pattern_table.tier = 4
	elseif i > 16 then
		pattern_table.market_price = i * 140
		pattern_table.tier = 3
	elseif i > 8 then
		pattern_table.market_price = 125 + i * 36
		pattern_table.tier = 2
	elseif i > 1 then
		pattern_table.market_price = 60 + i * 18
		pattern_table.tier = 1
	else
		pattern_table.market_price = nil
		pattern_table.tier = 1
	end

	pattern_table.entity_type = "cloak_pattern"
	pattern_table.ui_sort_index = i
	BaseCloakPatterns["cloak_pattern_" .. i] = pattern_table
end

Cloaks = {
	long_cloak_viking = {
		name = "long_cloak_viking",
		entity_type = "cloak",
		ui_texture = "cloaks",
		team = "viking",
		release_name = "main",
		ui_header = "arm_be_long_cloak_01",
		market_price = 5000,
		unit = "units/armour/cloaks/arm_be_long_cloak/arm_be_long_cloak_01",
		attachment_node_linking = AttachmentNodeLinking.cloaks.standard,
		mesh_names = {
			g_mesh_lod0 = {
				"mtr_cloth"
			}
		},
		patterns = table.clone(BaseCloakPatterns)
	},
	no_cloak = {
		name = "no_cloak",
		ui_header = "no_cloak",
		entity_type = "cloak",
		ui_texture = "no_cloak",
		team = "",
		release_name = "main",
		mesh_names = {
			g_mesh_lod0 = {
				"mtr_cloth"
			}
		}
	}
}
Cloaks.long_cloak_saxon = table.clone(Cloaks.long_cloak_viking)
Cloaks.long_cloak_saxon.name = "long_cloak_saxon"
Cloaks.long_cloak_saxon.team = "saxon"
CloakPatterns = {}

for _, cloak in pairs(Cloaks) do
	cloak.name = cloak.name or "Missing name"
	cloak.ui_header = cloak.ui_header or "Missing ui_header"
	cloak.ui_description = cloak.ui_description
	cloak.ui_texture = cloak.ui_texture or "default"
	cloak.ui_sort_index = cloak.ui_sort_index or 1
	cloak.patterns = cloak.patterns or {}

	for name, cloak_pattern in pairs(cloak.patterns) do
		cloak_pattern.name = cloak.name .. "_" .. name
		cloak_pattern.cloak_name = cloak.name
		CloakPatterns[cloak.name .. "_" .. name] = cloak_pattern
	end
end

function default_cloak_pattern_unlocks()
	local default_unlocks = {}
	local entity_type = "cloak_pattern"

	for name, cloak_pattern in pairs(CloakPatterns) do
		if not cloak_pattern.market_price or cloak_pattern.unlock_this_item then
			default_unlocks[cloak_pattern.unlock_key] = {
				category = entity_type,
				name = name
			}
		end
	end

	return default_unlocks
end
