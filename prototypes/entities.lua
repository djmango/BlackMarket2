require("utils")
require("config")

data:extend(
	{
		----------------------------------------------------------------------------------
		{
			type = "item-group",
			name = "black-market-group",
			icon = "__BlackMarket2__/graphics/black-market-group.png",
			icon_size = 64,
			inventory_order = "n",
			order = "n"
		},
		{
			type = "item-subgroup",
			name = "black-market-general",
			group = "black-market-group",
			order = "a"
		},
		{
			type = "item-subgroup",
			name = "black-market-chests",
			group = "black-market-group",
			order = "b"
		},
		{
			type = "item-subgroup",
			name = "black-market-tanks",
			group = "black-market-group",
			order = "c"
		},
		{
			type = "item-subgroup",
			name = "black-market-accumulators",
			group = "black-market-group",
			order = "d"
		},
		--------------------------------------------------------------------------------------
		{
			type = "item",
			name = "ucoin",
			icon = "__BlackMarket2__/graphics/ucoin.png",
			icon_size = 32,
			subgroup = "black-market-general",
			order = "y",
			stack_size = 1000000
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-item",
			icon = "__BlackMarket2__/graphics/black-market-item.png",
			icon_size = 128,
			enabled = true,
			unit = {
				count = 75,
				ingredients = {
					{"automation-science-pack", 1},
				},
				time = 15
			},
			effects =
			{
				{
					type = "unlock-recipe",
					recipe = "trader-chst-buy",
				},
			},
			order = "k-z-a",
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-fluid",
			icon = "__BlackMarket2__/graphics/black-market-fluid.png",
			icon_size = 128,
			enabled = true,
			prerequisites = { "black-market-item", "fluid-handling" },
			unit = {
				count = 75,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
				},
				time = 20
			},
			effects =
			{
				{
					type = "unlock-recipe",
					recipe = "trader-tank-sel",
				},
				{
					type = "unlock-recipe",
					recipe = "trader-tank-buy",
				},
			},
			order = "k-z-b",
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-energy",
			icon = "__BlackMarket2__/graphics/black-market-energy.png",
			icon_size = 128,
			enabled = true,
			prerequisites = { "black-market-item", "electric-energy-accumulators" },
			unit = {
				count = 150,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
				},
				time = 25
			},
			effects =
			{
				{
					type = "unlock-recipe",
					recipe = "trader-accu-sel",
				},
				{
					type = "unlock-recipe",
					recipe = "trader-accu-buy",
				},
			},
			order = "k-z-c",
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-mk2",
			icon = "__BlackMarket2__/graphics/black-market-mk.png",
			icon_size = 128,
			enabled = true,
			upgrade = true,
			prerequisites = {"steel-processing", "black-market-item", "black-market-fluid", "black-market-energy" },
			unit = {
				count = 150,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
				},
				time = 15
			},
			effects =
			{
			},
			order = "k-z-d",
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-mk3",
			icon = "__BlackMarket2__/graphics/black-market-mk.png",
			icon_size = 128,
			enabled = true,
			upgrade = true,
			prerequisites = { "black-market-mk2" },
			unit = {
				count = 200,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
				},
				time = 15
			},
			effects =
			{
			},
			order = "k-z-d",
		},
		--------------------------------------------------------------------------------------
		{
			type = "technology",
			name = "black-market-mk4",
			icon = "__BlackMarket2__/graphics/black-market-mk.png",
			icon_size = 128,
			enabled = true,
			upgrade = true,
			prerequisites = { "black-market-mk3" },
			unit = {
				count = 250,
				ingredients = {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
				},
				time = 15
			},
			effects =
			{
			},
			order = "k-z-f",
		},
	}
)

local names_pastable = {}
local names_chests = {}
local names_tanks = {}
local names_accus = {}

--------------------------------------------------------------------------------------

local function add_chests(level)
	local name_sell = "trader-chst-sel"
	local name_buy = "trader-chst-buy"
	if level > 1 then
		name_sell = name_sell .. "-mk" .. level
		name_buy = name_buy .. "-mk" .. level
	end
	table.insert(names_chests,name_sell)
	table.insert(names_pastable,name_sell)
	local inventory_size = level == 1 and 16 or (50 + 100 * (level - 2)) -- vanilla 48
	--------------------------------------------------------------------------------------
	local ingredients = {{type="item", name="wooden-chest", amount=1}}
	local proto = "wooden-chest"
	local enabled = true
	
	if level > 1 then
		ingredients = {
			{type="item", name="steel-chest", amount=level},
			{type="item", name="electronic-circuit", amount=2 * level}
		}
		proto = "steel-chest"
		enabled = false
	end

	local chest_sell = dupli_proto( "container", proto, name_sell )
	chest_sell.inventory_size = inventory_size
	chest_sell.picture = 
		{
			filename = "__BlackMarket2__/graphics/trading-chest-sell.png",
			priority = "extra-high",
			width = 48,
			height = 34,
			shift = {0.1875, 0}
		}
	
	-- Add circuit network connectivity
	chest_sell.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
	chest_sell.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
	chest_sell.circuit_wire_max_distance = default_circuit_wire_max_distance

	
	data:extend(
		{
			chest_sell,

			{
				type = "item",
				name = name_sell,
				icon = "__BlackMarket2__/graphics/trading-chest-sell-icon.png",
				icon_size = 32,
				subgroup = "black-market-chests",
				order = level .. "a",
				place_result = name_sell,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_sell,
				enabled = enabled ,
				energy_required = 1,
				ingredients = ingredients,
				results = {{type="item", name=name_sell, amount=1}},
			},
		}
	)
	
	table.insert(names_chests,name_buy)
	table.insert(names_pastable,name_buy)
	--------------------------------------------------------------------------------------
	local chest_buy = dupli_proto( "container", proto, name_buy )
	chest_buy.inventory_size = inventory_size
	chest_buy.picture = 
		{
			filename = "__BlackMarket2__/graphics/trading-chest-buy.png",
			priority = "extra-high",
			width = 48,
			height = 34,
			shift = {0.1875, 0}
		}
	
	-- Add circuit network connectivity
	chest_buy.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
	chest_buy.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
	chest_buy.circuit_wire_max_distance = default_circuit_wire_max_distance

	data:extend(
		{
			chest_buy,

			{
				type = "item",
				name = name_buy,
				icon = "__BlackMarket2__/graphics/trading-chest-buy-icon.png",
				icon_size = 32,
				subgroup = "black-market-chests",
				order = level .. "b",
				place_result = name_buy,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_buy,
				enabled = false,
				energy_required = 1,
				ingredients = ingredients,
				results = {{type="item", name=name_buy, amount=1}},
			},
		}
	)
	
	if level > 1 then
		local techno_name = "black-market-mk" .. level
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_sell,
			}
		)
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_buy,
			}
		)
	end
end

	
add_chests(1)
add_chests(2)
add_chests(3)
add_chests(4)

--------------------------------------------------------------------------------------

local function add_tanks(level)
	local name_sell = "trader-tank-sel"
	local name_buy = "trader-tank-buy"
	if level > 1 then
		name_sell = name_sell .. "-mk" .. level
		name_buy = name_buy .. "-mk" .. level
	end
	table.insert(names_tanks,name_sell)
	table.insert(names_tanks,name_buy)
	table.insert(names_pastable,name_sell)
	table.insert(names_pastable,name_buy)
	local tank_max -- vanilla 25000
	if level == 1 then tank_max = 25000 end
	if level == 2 then tank_max = 100000 end
	if level == 3 then tank_max = 200000 end
	if level == 4 then tank_max = 400000 end
	--------------------------------------------------------------------------------------
	local tank_sell = dupli_proto( "storage-tank", "storage-tank", name_sell )
	tank_sell.pictures.picture.sheets[1].filename = "__BlackMarket2__/graphics/trading-tank-sell.png"
	tank_sell.pictures.picture.sheets[1].height = 216
	tank_sell.fluid_box.volume = tank_max
	
	-- Add circuit network connectivity
	tank_sell.circuit_wire_connection_point = circuit_connector_definitions["storage_tank"].points
	tank_sell.circuit_connector_sprites = circuit_connector_definitions["storage_tank"].sprites
	tank_sell.circuit_wire_max_distance = default_circuit_wire_max_distance

	data:extend(
		{
			tank_sell,

			{
				type = "item",
				name = name_sell,
				icon = "__BlackMarket2__/graphics/trading-tank-sell-icon.png",
				icon_size = 32,
				subgroup = "black-market-tanks",
				order = level .. "a",
				place_result = name_sell,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_sell,
				enabled = false,
				energy_required = 4,
				ingredients = {
					{type="item", name="storage-tank", amount=level},
					{type="item", name="electronic-circuit", amount=2*level},
				},
				results = {{type="item", name=name_sell, amount=1}},
			},
		}
	)

	--------------------------------------------------------------------------------------
	local tank_buy = dupli_proto( "storage-tank", "storage-tank", name_buy )
	tank_buy.pictures.picture.sheets[1].filename = "__BlackMarket2__/graphics/trading-tank-buy.png"
	tank_buy.pictures.picture.sheets[1].height = 216
	tank_buy.fluid_box.volume = tank_max
	
	-- Add circuit network connectivity
	tank_buy.circuit_wire_connection_point = circuit_connector_definitions["storage_tank"].points
	tank_buy.circuit_connector_sprites = circuit_connector_definitions["storage_tank"].sprites
	tank_buy.circuit_wire_max_distance = default_circuit_wire_max_distance

	data:extend(
		{
			tank_buy,

			{
				type = "item",
				name = name_buy,
				icon = "__BlackMarket2__/graphics/trading-tank-buy-icon.png",
				icon_size = 32,
				subgroup = "black-market-tanks",
				order = level .. "b",
				place_result = name_buy,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_buy,
				enabled = false,
				energy_required = 4,
				ingredients = {
					{type="item", name="storage-tank", amount=level},
					{type="item", name="electronic-circuit", amount=2*level},
				},
				results = {{type="item", name=name_buy, amount=1}},
			},
		}
	)
	if level > 1 then
		local techno_name = "black-market-mk" .. level
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_sell,
			}
		)
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_buy,
			}
		)
	end
end

add_tanks(1)
add_tanks(2)
add_tanks(3)
add_tanks(4)

--------------------------------------------------------------------------------------

local function add_accus(level)
	local name_sell = "trader-accu-sel"
	local name_buy = "trader-accu-buy"
	if level > 1 then
		name_sell = name_sell .. "-mk" .. level
		name_buy = name_buy .. "-mk" .. level
	end
	table.insert(names_accus,name_sell)
	table.insert(names_accus,name_buy)
	table.insert(names_pastable,name_sell)
	table.insert(names_pastable,name_buy)
	local accu_max -- vanilla 5MJ
	if level == 1 then accu_max = 10 end
	if level == 2 then accu_max = 100 end
	if level == 3 then accu_max = 250 end
	if level == 4 then accu_max = 500 end
	local flow_limit -- vanilla 300kW
	if level == 1 then flow_limit = 1 end
	if level == 2 then flow_limit = 5 end
	if level == 3 then flow_limit = 10 end
	if level == 4 then flow_limit = 25 end
	--------------------------------------------------------------------------------------
	local accu_sell = dupli_proto( "accumulator", "accumulator", name_sell )
	accu_sell.energy_source.buffer_capacity = accu_max .. "MJ"
	accu_sell.energy_source.input_flow_limit = flow_limit .. "MW"
	accu_sell.energy_source.output_flow_limit = "0MW"
	accu_sell.chargable_graphics.picture.filename = "__BlackMarket2__/graphics/trading-accumulator-sell.png"
	accu_sell.chargable_graphics.charge_animation.filename = "__BlackMarket2__/graphics/trading-accumulator-sell-charge.png"
	accu_sell.chargable_graphics.discharge_animation.filename = "__BlackMarket2__/graphics/trading-accumulator-sell-discharge.png"

	data:extend(
		{
			accu_sell,

			{
				type = "item",
				name = name_sell,
				icon = "__BlackMarket2__/graphics/trading-accumulator-sell-icon.png",
				icon_size = 32,
				subgroup = "black-market-accumulators",
				order = level .. "a",
				place_result = name_sell,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_sell,
				enabled = false,
				energy_required = 20,
				ingredients = {
					{type="item", name="accumulator", amount=2+(level-1)*2},
					{type="item", name="electronic-circuit", amount=2*level},
				},
				results = {{type="item", name=name_sell, amount=1}},
			},
		}
	)

	--------------------------------------------------------------------------------------
	local accu_buy = dupli_proto( "accumulator", "accumulator", name_buy )
	accu_buy.energy_source.buffer_capacity = accu_max .. "MJ"
	accu_buy.energy_source.input_flow_limit = "0MW"
	accu_buy.energy_source.output_flow_limit = flow_limit .. "MW"
	accu_buy.chargable_graphics.picture.filename = "__BlackMarket2__/graphics/trading-accumulator-buy.png"
	accu_buy.chargable_graphics.charge_animation.filename = "__BlackMarket2__/graphics/trading-accumulator-buy-charge.png"
	accu_buy.chargable_graphics.discharge_animation.filename = "__BlackMarket2__/graphics/trading-accumulator-buy-discharge.png"

	data:extend(
		{
			accu_buy,

			{
				type = "item",
				name = name_buy,
				icon = "__BlackMarket2__/graphics/trading-accumulator-buy-icon.png",
				icon_size = 32,
				subgroup = "black-market-accumulators",
				order = level .. "b",
				place_result = name_buy,
				stack_size = 50,
			},
			
			{
				type = "recipe",
				name = name_buy,
				enabled = false,
				energy_required = 20,
				ingredients = {
					{type="item", name="accumulator", amount=2+(level-1)*2},
					{type="item", name="electronic-circuit", amount=2*level},
				},
				results = {{type="item", name=name_buy, amount=1}},
			},
		}
	)
	if level > 1 then
		local techno_name = "black-market-mk" .. level
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_sell,
			}
		)
		table.insert( data.raw["technology"][techno_name].effects,
			{
				type = "unlock-recipe",
				recipe = name_buy,
			}
		)
	end
end

add_accus(1)
add_accus(2)
add_accus(3)
add_accus(4)

--------------------------------------------------------------------------------------
for _, name in pairs(names_chests) do
	data.raw["container"][name].additional_pastable_entities = names_pastable
end

for _, name in pairs(names_tanks) do
	data.raw["storage-tank"][name].additional_pastable_entities = names_pastable
end

for _, name in pairs(names_accus) do
	data.raw["accumulator"][name].additional_pastable_entities = names_pastable
end
