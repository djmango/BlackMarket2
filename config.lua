function configure_settings() 
	resource_price = settings.global["BM2-resource_price"].value -- price of original declared resource object
	water_price = settings.global["BM2-infinite_price"].value -- price for easy infinite resource like water, air, etc...
	free_price = settings.global["BM2-free_price"].value -- price of free object (product of recipe with no ingredients)
	unknown_price = settings.global["BM2-unknown_price"].value -- price of unknown object (product or ingredient of no recipe, so skipped)

	-- vanilla resources

	vanilla_resources_prices = {
		["water"] = settings.global["BM2-water_price"].value,
		["coal"] = settings.global["BM2-coal_price"].value,
		["stone"] = settings.global["BM2-stone_price"].value,
		["iron-ore"] = settings.global["BM2-iron_price"].value,
		["copper-ore"] = settings.global["BM2-copper_price"].value,
		["crude-oil"] = settings.global["BM2-oil_price"].value,
		["uranium-ore"] = settings.global["BM2-uranium_price"].value,
	}

	-- special manually declared prices

	special_prices = {
		["ucoin"] = settings.global["BM2-ucoin"].value,

		["wood"] = settings.global["BM2-wood"].value,
		["raw-fish"] = settings.global["BM2-raw_fish"].value,

		["steam"] = settings.global["BM2-steam"].value,

		["empty-canister"] = settings.global["BM2-empty_canister"].value, -- from bob (but "empty-" is also prefix from omnibarrel exclusion...
		["empty-barrel"] = settings.global["BM2-empty_barrel"].value, -- from vanilla (but "empty-" is also prefix from omnibarrel exclusion...

	}

	energy_price= settings.global["BM2-energy_price"].value -- price for selling and buying energy (for 1MJ)
	energy_cost = settings.global["BM2-energy_cost"].value -- cost of energy unit in recipes (time, different from MJ)
	tech_ingr_cost = settings.global["BM2-tech_ingr_cost"].value -- average cost of a science pack
	tech_amortization = settings.global["BM2-tech_amortization"].value -- amortization of the tech cost in object price
	commercial_margin = settings.global["BM2-commercial_margin"].value -- commercial margin

	dynamic_prices_enabled = settings.global["BM2-dynamic_prices"].value -- if dynamic is enabled or not
	dynamic_regrowth = settings.global["BM2-dynamic_regrowth"].value -- how prices slowly return to optimal value if untouched (every day)
	dynamic_influence_item = settings.global["BM2-dynamic_influence_item"].value -- influence of sales and purchases on prices (per item, per day)
	dynamic_influence_fluid = settings.global["BM2-dynamic_influence_fluid"].value -- influence of sales and purchases on prices (per item, per day)
	dynamic_influence_energy = settings.global["BM2-dynamic_influence_energy"].value -- influence of sales and purchases on prices (per item, per day)
	dynamic_minimal = settings.global["BM2-dynamic_minimal"].value
	dynamic_maximal = settings.global["BM2-dynamic_maximal"].value

	periods = {0,1,2,3,4,6,8,12,24} -- available periods in hours
	default_n_period = 2 -- default period of a new trading chest
	default_auto = true -- default automatic mode

	thousands_separator = ","
end