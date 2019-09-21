require("utils")
require("stdlib/utils/table")

if mods["GoldMining"] and data.raw.technology["gold-processing"] ~= nil then

	-- add recipes for crafting ucoin from gold
	data:extend({
		{
			type = "recipe",
			name = "ucoin-from-gold-plate",
			category = "advanced-crafting",
			icon = "__BlackMarket2__/graphics/ucoin.png",
			icon_size = 32,
			enabled = false,
			energy_required = 1,
			ingredients = {
				{"gold-plate", 1}
			},
			results = {
				{
					name = "ucoin",
					amount = 10000
				},
			},
			order="a"
		}
	
	})
	
	-- update GoldMining technologies
	table.insert(data.raw.technology["gold-processing"].effects, {
		type = "unlock-recipe",
		recipe = "ucoin-from-gold-plate"
	})
		
	
	-- slighty update gold processing technologies to not waste stone
	table.each(data.raw.recipe["gold-processing"].results, function(result)
		if result.name == "stone" then
			result.amount = 3
		end
	end)

end