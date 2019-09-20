resource_price = 100 -- price of original declared resource object
resource_price_new = 99 -- price of undeclared but suspected resource object (never produced but ingredient)
water_price = 2 -- price for easy infinite resource like water, air, etc...
free_price = 0 -- price of free object (product of recipe with no ingredients)
unknown_price = 0 -- price of unknown object (product or ingredient of no recipe, so skipped)

-- vanilla resources

vanilla_resources_prices = {
	["water"] = 0,
	["coal"] = 16,
	["stone"] = 27,
	["iron-ore"] = 19,
	["copper-ore"] = 21,
	["crude-oil"] = 100,
}

-- special manually declared prices

special_prices = {
	["coin"] = 1,
	["ucoin"] = 1,
	
	["raw-wood"] = 51,
	["raw-fish"] = 30,
	["alien-artifact"] = 1000,
	
	["thermal-water"] = resource_price,
	
	["empty-canister"] = 161, -- from bob (but "empty-" is also prefix from omnibarrel exclusion...
	["empty-barrel"] = 1311, -- from vanilla (but "empty-" is also prefix from omnibarrel exclusion...
	
	["small-alien-artifact"] = 199,
	["small-alien-artifact-red"] = 201,
	["small-alien-artifact-orange"] = 201,
	["small-alien-artifact-yellow"] = 201,
	["small-alien-artifact-green"] = 201,
	["small-alien-artifact-blue"] = 201,
	["small-alien-artifact-purple"] = 201,
	
	-- ["gem-ore"] = resource_price,
	-- ["liquid-air"] = resource_price,
	-- ["liquid-air"] = 2,
	-- ["lithia-water"] = 2,
	
	["gold-plate"] = 10000,
	["gold-ingot"] = math.floor(10000 * 200 * 1.15), -- ingot get 15% boost in value
}

energy_price= 500 -- price for selling and buying energy (for 1MJ)
energy_cost = 20 -- cost of energy unit in recipes (time, different from MJ)
tech_ingr_cost = 1000 -- average cost of a science pack
tech_amortization = 0.001 -- amortization of the tech cost in object price
commercial_margin = 0.10 -- commercial margin

dynamic_regrowth = 0.05 -- how prices slowly return to optimal value if untouched (every day)
dynamic_influence_item = 0.00008 -- influence of sales and purchases on prices (per item, per day)
dynamic_influence_fluid = 0.00006 -- influence of sales and purchases on prices (per item, per day)
dynamic_influence_energy = 0.0004 -- influence of sales and purchases on prices (per item, per day)
dynamic_minimal = 0.01
dynamic_maximal = 2

periods = {0,1,2,3,4,6,8,12,24} -- available periods in hours
default_n_period = 2 -- default period of a new trading chest
default_auto = true -- default automatic mode
tax_start = 4 -- starting fee in % for one action per day
tax_growth = 0.5 -- exponential growth with frequency/day : fee = tax_start * (freq ^ tax_growth)
tax_immediate = 25 -- fee for immediate action

thousands_separator = ","

