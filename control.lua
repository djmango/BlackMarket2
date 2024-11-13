require("utils")
require("config")
mod_gui = require("mod-gui")
local table = require('__flib__.table')
configure_settings()
local market_type = { item = 1, fluid = 2, energy = 3, "item", "fluid", "energy" }
local condition_type = { '>', '<', '=', '>=', '<=', '~=' }
local energy_name = 'market-energy'
local market_opened = nil
local content_list = {  }
local content_select_order_id = nil
local tax_pay = stg_tax_rate / 100
local local_p = nil
local recalculate_price = true
if stg_tax_enable == false then
    tax_pay = 0
end
--------------------------------------------------------------------------------------
---usefulfunctions
--------------------------------------------------------------------------------------
local function print(any)
    game.print(any)
end
function str_split (str, sep)
    local result = {}
    -- Usa una regex per trovare solo le parti separate da '__'
    for part in string.gmatch(str, "([^" .. sep .. "]+)" .. sep .. "?") do
        if part ~= "" then
            table.insert(result, part)
        end
    end
    return result
end
local function isNumber(value)
    return tonumber(value) and true or false
end
local function tprint(tbl, indent)
    if not indent then
        indent = 0
    end
    local topt = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        topt = topt .. string.rep(" ", indent)
        if (type(k) == "number") then
            topt = topt .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            topt = topt .. k .. "= "
        end
        if (type(v) == "number") then
            topt = topt .. v .. ",\r\n"
        elseif (type(v) == "string") then
            topt = topt .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            topt = topt .. tprint(v, indent + 2) .. ",\r\n"
        else
            topt = topt .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    topt = topt .. string.rep(" ", indent - 2) .. "}"
    return topt
end

--------------------------------------------------------------------------------------
local quality_type = {}
local function fill_quality_type()
    local quality_tier_counter = 1
    for name, proto in pairs(prototypes.quality) do
        if #prototypes.quality == 5 then
            if proto.name == 'normal' then
                quality_type[proto.name] = 1
                quality_type[1] = proto.name
            elseif proto.name == 'uncommon' then
                quality_type[proto.name] = 2
                quality_type[2] = proto.name
            elseif proto.name == 'rare' then
                quality_type[proto.name] = 3
                quality_type[3] = proto.name
            elseif proto.name == 'epic' then
                quality_type[proto.name] = 4
                quality_type[4] = proto.name
            elseif proto.name == 'normal' then
                quality_type[proto.name] = 5
                quality_type[5] = proto.name
            end
        else
            if proto.name ~= 'quality-unknown' then
                quality_type[proto.name] = proto.level
                quality_type[quality_tier_counter] = proto.name
                --print('lvl : '..proto.level .. '    name : '..proto.name)
                quality_tier_counter = quality_tier_counter + 1
            end
        end
    end

    --table.sort(quality_type, function(a, b)
    --    return quality_type[a] <= quality_type[b]
    --end)
end
fill_quality_type()
function get_price_quality(price, quality)
    local lvl = quality_type[quality]
    if not isNumber(lvl) then
        lvl = quality_type[lvl]
    end
    lvl = tonumber(lvl)
    if lvl == nil then
        lvl = 0
    end
    lvl = lvl + 1
    if lvl <= 5 then
        return price * vanilla_quality_prices[lvl]
    else
        return price * ((lvl / quality_muiltipliers[1]) ^ quality_muiltipliers[2])
    end
end

--------------------------------------------------------------------------------------
function format_money(n)
    if n == nil then
        return ("0$")
    end

    local neg, mega

    if n > 1e12 then
        n = math.floor(n / 1e6)
        mega = true
    else
        mega = false
    end

    if n < 0 then
        n = -n
        neg = true
    else
        neg = false
    end

    local s = tostring(math.floor(n + 0.5))
    local s2 = ""
    local l = string.len(s)
    local i = l + 1

    while i > 4 do
        i = i - 3
        s2 = thousands_separator .. string.sub(s, i, i + 2) .. s2
    end

    if i > 1 then
        s2 = string.sub(s, 1, i - 1) .. s2
    end

    if mega then
        s2 = s2 .. "M$"
    else
        s2 = s2 .. "$"
    end

    if neg then
        return ("-" .. s2)
    else
        return (s2)
    end
end

--------------------------------------------------------------------------------------
function format_evolution(evol)
    if evol == nil or evol == 0 then
        return ("")
    elseif evol > 0 then
        return ("")
    else
        return ("")
    end
end

--------------------------------------------------------------------------------------
local function update_tech_cost(tech)
    local cost = 0

    cost = cost + #tech.research_unit_ingredients * tech.research_unit_count * tech_ingr_cost
    cost = cost + tech.research_unit_energy * energy_cost

    storage.techs_costs[tech.name] = cost
    for _, effect in pairs(tech.prototype.effects) do
        if effect.type == "unlock-recipe" then
            storage.recipes_tech[effect.recipe] = tech.name
        end
    end
end

--------------------------------------------------------------------------------------
local function update_techs_costs()
    storage.techs_costs = {}
    storage.recipes_tech = {}

    for name, tech in pairs(game.forces.player.technologies) do
        update_tech_cost(tech)
    end
end

--------------------------------------------------------------------------------------
local function update_objects_prices_start()
    if storage.prices_computed then
        return
    end

    storage.prices_computed = true

    storage.old_prices = storage.prices or {} -- to memorize old prices, and restore dynamics later

    storage.prices = {}
    storage.orig_resources = {}
    storage.new_resources = {}
    storage.free_products = {}
    storage.unknowns = {}
    local orig_resources = {}
    local specials = {}
    local free_products = {}
    local regular_products = {}

    local recipes = game.forces.player.recipes

    -- energy
    storage.prices[energy_name] = { overall = energy_price, tech = 0, ingrs = 0, energy = 0 }

    -- vanilla resources

    for name, price in pairs(vanilla_resources_prices) do
        storage.prices[name] = { overall = price, tech = 0, ingrs = 0, energy = 0 }
        orig_resources[name] = true
    end

    -- special objects

    for name, price in pairs(special_prices) do
        storage.prices[name] = { overall = price, tech = 0, ingrs = 0, energy = 0 }
        specials[name] = true
    end

    -- additional resources

    for name, ent in pairs(prototypes.get_entity_filtered({})) do
        -- raw resources
        if ent.type == "resource" then
            local min_prop = ent.mineable_properties
            if min_prop.minable and min_prop.products then
                -- if this object is minable give it the raw ore price
                for _, prod in pairs(min_prop.products) do
                    if storage.prices[prod.name] == nil then
                        storage.prices[prod.name] = { overall = resource_price, tech = 0, ingrs = 0, energy = 0 }
                        orig_resources[prod.name] = true
                    end
                end
            end
        end
    end

    -- mark potential undeclared new resources (that are ingredients but never produced)

    local new_resources = {}

    for _, recipe in pairs(recipes) do
        if recipe.ingredients ~= nil then
            for _, ingr in pairs(recipe.ingredients) do
                if storage.prices[ingr.name] == nil and regular_products[ingr.name] == nil and free_products[ingr.name] == nil then
                    new_resources[ingr.name] = true -- mark as possible resource
                end
            end
        end
    end

    regular_products = nil

    storage.orig_resources = orig_resources
    storage.specials = specials
    storage.new_resources = new_resources
    storage.free_products = free_products
end

--------------------------------------------------------------------------------------
local function compute_recipe_purity(recipe_name, item_name)
    local recipe = game.forces.player.recipes[recipe_name]

    local other_amount = 0      -- the other stuff that the recipe produces
    local ingredient_amount = 0 -- the stuff we are actually trying to solve for
    if recipe then
        table.for_each(recipe.products, function(product)
            -- here we categorize each of the recipes products into product or other
            if product.name == item_name then
                if product.amount ~= nil then
                    ingredient_amount = ingredient_amount + product.amount
                elseif product.amount_min and product.amount_max and product.probability then
                    ingredient_amount = ingredient_amount +
                            (product.amount_min + product.amount_max) / 2 * product.probability
                end
            elseif product.amount ~= nil then
                -- if its an other we still need to check if its a probability or an amount
                other_amount = other_amount + product.amount
            elseif product.amount_min and product.amount_max and product.probability then
                other_amount = other_amount + (product.amount_min + product.amount_max) / 2 * product.probability
            end
        end)

    end

    -- cant divide by 0
    if other_amount == 0 then
        other_amount = 1
    end

    -- if this is the new best recipe then store it
    local purity = ingredient_amount / other_amount

    return purity
end

---convenience function that sets an item's price to the default and optionally logs it
---@param item_name string
---@param reason string @*optional*
---@return table the price entry that was set for this item
local function item_cost_unknown(item_name, reason)
    if unknown_price_reason_logging == true and reason ~= nil then
        pcall(helpers.write_file, price_log, "< " .. item_name .. " > " .. reason .. "\n", true)
    end
    storage.prices[item_name] = { overall = unknown_price, tech = 0, ingrs = 0, energy = 0 }
    return storage.prices[item_name]
end

--------------------------------------------------------------------------------------
local function compute_item_cost(item_name, loops, recipes_used)
    loops = (loops or 0) + 1
    recipes_used = recipes_used or {}

    -- if this is an uncraftable item then we just assume its a raw/unknown
    if storage.item_recipes[item_name] == nil then
        return item_cost_unknown(item_name, "no recipe")
    elseif loops > recipe_depth_maximum then
        return item_cost_unknown(item_name, "recipe_depth_maximum exceeded")
    end

    -- grab the item's recipe
    local recipe_name = storage.item_recipes[item_name].recipe
    local recipe = game.forces.player.recipes[recipe_name]

    for _, recipe_used in pairs(recipes_used) do
        if recipe_used == recipe_name then
            return item_cost_unknown(item_name, "recipe_name in recipes_used")
        end
    end
    recipes_used[#recipes_used + 1] = recipe_name

    -- iterate through ingredients and make sure they have a set cost
    for _, ingredient in pairs(recipe.ingredients) do
        if storage.prices[ingredient.name] ~= nil then
            -- do we know the price already?
            -- we can move on to the next ingredient
        elseif storage.item_recipes[ingredient.name] ~= nil and storage.item_recipes[ingredient.name].recipe ~= nil then
            -- if not and we have a recipe for the ingredient then loop through and calculate it based on ingredients
            compute_item_cost(ingredient.name, loops, recipes_used)
        else
            -- unknown raw mats
            item_cost_unknown(ingredient.name, "ingredient has no price or recipe")
        end
    end

    -- okay we now know that the price of the ingredients are in the prices table, so now we can just add em up
    local ingredients_cost = 0
    for _, ingredient in pairs(recipe.ingredients) do
        if storage.prices[ingredient.name] == nil then
            compute_item_cost(ingredient.name, loops, recipes_used)
        end
        ingredients_cost = ingredients_cost + ingredient.amount * storage.prices[ingredient.name].overall
    end

    -- compute tech cost
    local tech_cost = 0
    local tech_name = storage.recipes_tech[recipe.name]
    if tech_name then
        if storage.techs_costs[tech_name] then
            tech_cost = storage.techs_costs[tech_name] * tech_amortization
        end
    end

    -- count the amount of product we are making in this recipe
    local product_amount = 0
    for _, product in pairs(recipe.products) do
        if product.name == item_name then
            if product.amount then
                product_amount = product.amount
            elseif product.amount_min and product.amount_max and product.probability then
                product_amount = (product.amount_min + product.amount_max) / 2 * product.probability
            end
        end
    end

    -- calculate energy cost
    local energy_cost = recipe.energy * energy_cost

    -- enter cost of ingredient
    if product_amount == 0 then
        -- sometimes, probability can be 0, leading to total amount = 0
        item_cost_unknown(item_name, "product_amount == 0")
    else
        local tech_total = math.floor(tech_cost)
        local ingrs_total = math.floor(ingredients_cost / product_amount + 0.5)
        local energy_total = math.floor(energy_cost / product_amount + 0.5)
        price = (tech_total + ingrs_total + energy_total) * (1 + 0.10)
        storage.prices[item_name] = {
            overall = math.floor(price),
            tech = tech_total,
            ingrs = ingrs_total,
            energy = energy_total
        }
    end
    return (storage.prices[item_name])
end

--------------------------------------------------------------------------------------
local function update_objects_prices()
    -- item_recipes looks like {..., item_name = {name, recipe_name}}

    --  this links items (products) to their recipe(s)
    for _, recipe in pairs(game.forces.player.recipes) do
        for _, product in pairs(recipe.products) do
            if game.forces.player.recipes[product.name] ~= nil then
                -- if we can find a direct recipe match for the item then we don't need to do fancy match
                item_recipe = { name = product.name, recipe = product.name }
            else
                -- recipe matching, the filters avoid recipes that cause issues for the cost computer
                item_recipe = storage.item_recipes[product.name] or { name = product.name, recipe = nil }
                -- item_recipe is the most pure recipe for product

                if item_recipe.recipe ~= nil then
                    local old_purity = compute_recipe_purity(item_recipe.recipe, product.name)

                    local new_purity = compute_recipe_purity(recipe.name, product.name)

                    -- recipe filters here, the recipes we don't want

                    -- such as fluid barreling recipes
                    local isBarrel = false
                    if string.match(recipe.name, "barrel") and not string.match(product.name, "barrel") then
                        isBarrel = true
                    end

                    -- or recipes with catalysts
                    local hasCatalyst = false
                    table.for_each(game.forces.player.recipes[recipe.name].products, function(product)
                        -- if the recipe just straight up tells us
                        if product.catalyst_amount ~= nil and product.catalyst_amount > 0 then
                            hasCatalyst = true
                            -- otherwise check for name matches
                        else
                            table.for_each(game.forces.player.recipes[recipe.name].ingredients, function(ingr)
                                if ingr.name == product.name then
                                    hasCatalyst = true
                                end
                            end)
                        end
                    end)

                    if new_purity > old_purity and isBarrel == false and hasCatalyst == false then
                        item_recipe.recipe = recipe.name
                    end -- our new king passed our filters!
                else
                    item_recipe.recipe = recipe.name
                end -- if there is no preexisting recipe our new one is king
            end

            storage.item_recipes[product.name] = item_recipe
        end
    end

    for _, item in pairs(storage.item_recipes) do
        if storage.prices[item.name] == nil or storage.prices[item.name].overall == nil then
            compute_item_cost(item.name)
        end
    end

    -- init dynamic prices for new prices, and restore old dynamics if exists, and filter errors for bad recipes

    for name_object, price in pairs(storage.prices) do
        local old_price = nil

        -- filters for all the bad values that escaped
        if price.overall == nil then
            price.overall = unknown_price
        end
        if price.overall == math.huge then
            price.overall = unknown_price
        end

        -- actually dynamic stuff
        if old_price then
            price.dynamic = old_price.dynamic or 1
            price.previous = old_price.previous or price.overall
            price.evolution = old_price.evolution or 0
        else
            price.dynamic = 1
            price.previous = price.overall or unknown_price
            price.evolution = 0
        end

        price.current = price.overall * price.dynamic
    end

    storage.old_prices = nil
    storage.prices_computed = false

    -- if only_researched_items is on then remove all that arent researched
    if not stg_unknown_tech then
        for name, object in pairs(storage.prices) do
            recipe = storage.item_recipes[name] or nil

            if recipe ~= nil and game.forces.player.recipes[recipe.recipe].enabled == false then
                storage.prices[name] = nil
            end
        end
    end

    return true
end

--------------------------------------------------------------------------------------
local function update_groups()
    -- debug_print("--------------------------------------------------------------------------------------")
    -- debug_print("update_groups")

    -- to be run after prices list end !

    local groups = {}

    for name, object in pairs(prototypes.get_item_filtered({})) do
        if storage.prices[name] ~= nil and not object.hidden then
            local group_name = object.group.name
            if groups[group_name] == nil then
                storage.prices[name].group = group_name
                groups[group_name] = { group = object.group, item = true, fluid = false }
            end
        end
    end

    for name, object in pairs(prototypes.get_fluid_filtered({})) do
        if storage.prices[name] ~= nil then
            local group_name = object.group.name
            if groups[group_name] == nil then
                groups[group_name] = { group = object.group, item = false, fluid = true }
                storage.prices[name].group = group_name
            else
                groups[group_name].fluid = true
                storage.prices[name].group = group_name
            end
        end
    end

    storage.groups = groups
end

--------------------------------------------------------------------------------------
local function init_storages()
    -- initialize or update general storages of the mod

    storage.tick = storage.tick or 0

    storage.item_recipes = {}

    if storage.prices_computed == nil then
        storage.prices_computed = false
    end

    if storage.techs_costs == nil then
        -- costs for every tech
        update_techs_costs()
    end

    storage.orig_resources = storage.orig_resources or {} -- items undeclared as resources
    storage.new_resources = storage.new_resources or
            {}                                                    -- items that could be undeclared resources (used as ingredients but never produced)
    storage.free_products = storage.free_products or {}   -- items with no prices
    storage.unknowns = storage.unknowns or {}             -- items with no prices

    if storage.prices == nil then
        -- prices for every item/fluid
        update_objects_prices_start()
    end

    storage.groups = storage.groups or {}

    if storage.groups == nil then
        update_groups()
    end
end

--------------------------------------------------------------------------------------
local function gui_clear(gui)
    for _, guiname in pairs(gui.children_names) do
        if gui[guiname] ~= nil then
            gui[guiname].destroy()

        end
    end
end
local function init_gui_money_counter(player)
    if player then

        local gui_parent = mod_gui.get_button_flow(player)
        local gui1 = gui_parent.flow_mbm
        if gui1 == nil then
            gui1 = gui_parent.add({ type = "flow", name = "flow_mbm", direction = "horizontal" })
            storage.market_money_gui[player.index] = {}
            storage.market_money_gui[player.index].lbl_money_counter = gui1.add({ type = "button", name = "btn_money_counter", caption = format_money(storage.market_money) })
            storage.market_money_gui[player.index].lbl_money_counter.style.height = 40
        end
        --storage.market_money_gui = storage.market_money_gui or { }
    end
end
local function gui_money_counter_update()
    init_gui_money_counter(player)
    for i = 1, #storage.market_money_gui do
        storage.market_money_gui[i].lbl_money_counter.caption = format_money(storage.market_money)
    end
end

--------------------------------------------------------------------------------------
local function gui_update_prices(market)
    local total = 0
    for id = 1, #market.orders do
        if market.orders[id].item then
            if not storage.prices[market.orders[id].item] then
                return
            end
            local p = get_price_quality(storage.prices[market.orders[id].item].current, market.orders[id].quality)
            market.orders[id].price_label.caption = format_money(p)
            total = total + (p * market.orders[id].quantity)
        end
    end
    market.gui_lbl_orders_total.caption = { '', { "mbm-gui-lbl-total-orders" }, ' ' .. format_money(total + (total * tax_pay)) .. '  incl.(tax : ' .. format_money(total * tax_pay) .. ')' }
end
local function gui_add_order(market, order)
    local gui = market.gui_orders_table
    local item = order.item
    local quantity = order.quantity
    local price = storage.prices[item]
    local id = order.id
    if price then
        current = price.current
        evol = price.evolution
    else
        current = 0
        evol = 0
    end
    if market.type == market_type.item then
        local btn_del = gui.add({ type = "button", name = "btn_mbm_delete_order-" .. string.format("%4d", id), caption = "X" })
        btn_del.style.width = 32
        btn_del.style.height = 32
    end
    if market.type == market_type.fluid then
        gui.add({ type = 'label', name = 'lbl_fld_empty' .. string.format("%4d", id) })
        order.item_btn = gui.add({ type = "sprite-button", name = "btn_mbm_elmnt-" .. string.format("%4d", id) })
        if prototypes['fluid'][item] and item then
            order.item_btn.sprite = "fluid/" .. item
        end
    end
    if market.type == market_type.energy then

        gui.add({ type = 'label', name = 'lbl_fld_empty1' .. string.format("%4d", id) })
    end
    if market.type == market_type.item and item then
        --local btn_mbm_elmnt = gui.add({ type = "choose-elem-button", name = "btn_mbm_elmnt-" .. string.format("%4d", id), elem_type = "item",filters={{filter='enabled'}} })
        --btn_mbm_elmnt.elem_value = itemsprite = .name
        order.item_btn = gui.add({ type = "sprite-button", name = "btn_mbm_elmnt-" .. string.format("%4d", id) })

        if prototypes['item'][item] then
            order.item_btn.sprite = "item/" .. item
        end

    end
    if market.type == market_type.energy then
        gui.add({ type = "sprite-button", sprite = "sprite_energy_blkmkt" })
    end
    local txt_mbm_qnt = gui.add({ type = "textfield", name = "txt_mbm_qnt-" .. string.format("%4d", id), text = quantity, style = "textfield_blkmkt_style", numeric = true, allow_decimal = false, allow_negative = false })
    txt_mbm_qnt.style.maximal_width = 50
    if market.type == market_type.item then
        local items_dropdown = {}

        for i = 1, #quality_type do
            table.insert(items_dropdown, i, '[quality=' .. quality_type[i] .. ']')
        end

        if next(items_dropdown) == nil then
            items_dropdown[1] = ' '
            order.quality = 1
        end
        if order.quality >= #items_dropdown then
            order.quality = #items_dropdown
        end
        local drp_mbm_qlt = gui.add({ type = "drop-down", name = "drp_mbm_qlt-" .. string.format("%4d", id), items = items_dropdown, selected_index = order.quality })
        drp_mbm_qlt.style.maximal_width = 70
    else
        gui.add({ type = 'label', name = 'lbl_fld_empty2' .. string.format("%4d", id) })
    end
    order.price_label = gui.add({ type = "label", name = 'lbl_mbm_curprice-' .. string.format("%4d", id), caption = format_money(current) .. " " .. format_evolution(evol) })
    market.orders[order.id] = order
end
local function gui_add_new_order(market)
    local gui = market.gui_orders_table
    local orders = market.orders or {}
    local n = #orders + 1
    orders[n] = { item = 'wooden-chest', quantity = 1, quality = 1, id = n }
    market.orders = orders
    gui_add_order(market, orders[n])

end
local function gui_update_orders(market)

    if market.type == market_type.fluid then
        local orders = market.orders or {}
        if next(orders) == nil then
            orders[1] = { item = 'crude-oil', quantity = 0, quality = 1 }
        end
        market.orders = orders
    end
    if market.type == market_type.energy then
        local orders = market.orders or {}
        if next(orders) == nil then
            orders[1] = { item = energy_name, quantity = 1, quality = 1 }
        end
        market.orders = orders
    end
    if market.orders ~= nil then
        for id = 1, #market.orders do
            market.orders[id].id = id
            gui_add_order(market, market.orders[id])
        end
        gui_update_prices(market)
    end
end

--------------------------------------------------------------------------------------
local function gui_buy(market)
    local total = 0
    local mymoney = storage.market_money
    if market.orders == nil then
        return
    end
    if #market.orders <= 0 then
        return
    end
    local money_buy = 0
    --if market.type == market_type.item then
    --    for id = 1, #market.orders do
    --        local p = get_price_quality(storage.prices[market.orders[id].item].current, market.orders[id].quality)
    --        total = total + (p * market.orders[id].quantity)
    --        if total < mymoney then
    --            local inv = market.entity.get_inventory(defines.inventory.chest)
    --            local stack_count = inv.count_empty_stacks(true,true)
    --            mymoney = mymoney - total
    --            money_buy = money_buy + total
    --
    --            inv.insert({ name = market.orders[id].item, count = market.orders[id].quantity, quality = quality_type[market.orders[id].quality] })
    --        end
    --    end
    --end
    if market.type == market_type.item then
        for id = 1, #market.orders do
            local order = market.orders[id]
            if not storage.prices[order.item] then
                return
            end
            local p = get_price_quality(storage.prices[order.item].current, order.quality)
            local inv = market.entity.get_inventory(defines.inventory.chest)
            local item_name = order.item
            local order_quantity = order.quantity
            local item_quality = quality_type[order.quality]
            local max_quantity = 0

            for i = 1, #inv do
                local stack = inv[i]
                if stack.valid_for_read then
                    if stack.name == item_name and stack.prototype and stack.quality.name == item_quality then
                        max_quantity = max_quantity + (stack.prototype.stack_size - stack.count)
                    end
                else
                    max_quantity = max_quantity + prototypes.item[item_name].stack_size
                end

                if max_quantity >= order_quantity then
                    max_quantity = order_quantity
                    break
                end
            end

            local quantity_to_buy = math.min(max_quantity, order_quantity)
            local order_total = p * quantity_to_buy

            if order_total <= mymoney and quantity_to_buy > 0 then
                mymoney = mymoney - order_total
                money_buy = money_buy + order_total
                inv.insert({ name = item_name, count = quantity_to_buy, quality = item_quality })
                total = total + order_total
            end
        end
    end

    if market.type == market_type.fluid then
        local order = market.orders[1]
        local tank = market.entity

        if order then
            local name = order.item
            if not storage.prices[order.item] then
                return
            end
            local price = storage.prices[name]

            local amount_box = 0
            local has_other_fluid = false

            for fluid_name, fluid_amount in pairs(tank.get_fluid_contents()) do
                if fluid_name ~= name then
                    has_other_fluid = true
                    break
                else
                    amount_box = amount_box + fluid_amount
                end
            end

            if not has_other_fluid and price then
                local purchased = math.min(order.quantity, (tank.prototype.fluid_capacity - amount_box))
                local money1 = purchased * price.current

                if purchased > 0 and money1 <= mymoney then
                    mymoney = mymoney - money1
                    money_buy = money_buy + money1
                    tank.insert_fluid({ name = name, amount = purchased })
                end
            end
        end
    end
    if market.type == market_type.energy then
        local order = market.orders[1]
        local accu = market.entity
        local name = energy_name
        local price = storage.prices[name]
        if order and price then
            local purchased = math.min(order.quantity * 1000000, (accu.electric_buffer_size - accu.energy)) / 1000000
            local money = purchased * price.current

            if purchased > 0 and money <= mymoney then

                mymoney = mymoney - money
                money_buy = money_buy + money
                accu.energy = accu.energy + (purchased * 1000000)

            end
        end
    end
    market.total_buy = market.total_buy or 0
    market.total_buy = market.total_buy + (money_buy + (money_buy * tax_pay))
    market.total_tax = market.total_tax or 0
    market.total_tax = market.total_tax + (money_buy * tax_pay)
    storage.market_money = storage.market_money - (money_buy + (money_buy * tax_pay))
    if market_opened == market then
        market.gui_lbl_money_tot.caption = format_money(market.total_buy)
        market.gui_lbl_taxes_tot.caption = format_money(market.total_tax)
    end
    gui_money_counter_update()
end
local function gui_eval_all(market)
    local money = 0
    if market.type == market_type.item then
        local inv = market.entity.get_inventory(defines.inventory.chest)
        local contents = inv.get_contents()
        local price = nil
        for i = 1, #contents, 1 do
            local name = contents[i].name
            local count = contents[i].count
            local quality = contents[i].quality
            price = storage.prices[name]
            if price ~= nil then
                money = money + count * get_price_quality(price.current, quality)
            end
        end
    end
    if market.type == market_type.fluid then
        local tank = market.entity
        if tank.fluidbox then
            local box = tank.fluidbox[1]
            if box ~= nil then
                local name = box.name
                local count = box.amount

                local price = storage.prices[name]
                if price ~= nil then
                    money = count * price.current
                end

            end
        end
    end
    if market.type == market_type.energy then
        local accu = market.entity
        local name = energy_name
        local count = accu.energy / 1000000
        local price = storage.prices[name]
        if price ~= nil then
            money = count * price.current
        end
    end
    if market_opened == market then
        if money ~= nil then
            market.gui_lbl_evaluation.caption = format_money(money - (money * tax_pay)) .. '  excl.(tax : ' .. format_money(money * tax_pay) .. ')'
        end
    end
    market.eval_price = money
end
local function gui_sell_all(market)

    gui_eval_all(market)
    if market.type == market_type.item then
        local inv = market.entity.get_inventory(defines.inventory.chest)
        for i, item in pairs(inv.get_contents()) do
            inv.remove({ name = item.name, count = item.count, quality = item.quality })
            market.last_sold_item = item.name
            if market.gui_btn_sold and market_opened and market == market_opened then
                market.gui_btn_sold.enabled = false
                market.gui_btn_sold.sprite = "item/" .. item.name
            end
        end
    end
    if market.type == market_type.fluid then
        local tank = market.entity
        for name, amount in pairs(tank.get_fluid_contents()) do
            tank.remove_fluid({ name = name, amount = amount })

            market.last_sold_item = name
            if market.gui_btn_sold and market_opened and market == market_opened then
                market.gui_btn_sold.enabled = false
                market.gui_btn_sold.sprite = "fluid/" .. name
            end
        end
    end
    if market.type == market_type.energy then
        market.last_sold_item = 'sprite_energy_blkmkt'
        if market.gui_btn_sold and market_opened and market == market_opened then
            market.gui_btn_sold.enabled = false
            market.gui_btn_sold.sprite = market.last_sold_item
        end
    end
    if market.type == market_type.energy then
        local accu = market.entity
        accu.energy = 0
    end
    storage.market_money = storage.market_money + (market.eval_price - (market.eval_price * tax_pay))
    market.total_tax = market.total_tax or 0
    market.total_tax = market.total_tax + (market.eval_price * tax_pay)
    market.total_buy = market.total_buy or 0
    market.total_buy = (market.eval_price - (market.eval_price * tax_pay)) + market.total_buy
    if market_opened == market then
        market.gui_lbl_money_tot.caption = format_money(market.total_buy)
        market.gui_lbl_taxes_tot.caption = format_money(market.total_tax)
    end
    gui_money_counter_update()
end

--------------------------------------------------------------------------------------
local function set_content_visible(group_name, state)
    for _, x in pairs(content_list[group_name]) do
        x.visible = state
    end
end
local function swap_chests(input, output)
    local inv_input = input.get_inventory(defines.inventory.chest)
    local inv_output = output.get_inventory(defines.inventory.chest)
    output.clear_items_inside()
    for i, item in pairs(inv_input.get_contents()) do
        inv_output.insert({ name = item.name, count = item.count, quality = item.quality })
        inv_input.remove({ name = item.name, conut = item.count, quality = item.quality })
    end
    input.clear_items_inside()
end

local resource_price = {
    free = 0,
    water = 0,
    unknown = 10000,
    ["wood"] = 51,
    ["coal"] = 16,
    ["stone"] = 27,
    ["iron-ore"] = 50,
    ["copper-ore"] = 50,
    ["iron-plate"] = 91,
    ["copper-ore"] = 50,
    ["copper-plate"] = 93,
    ["uranium-ore"] = 182,
    ['crude-oil'] = 100
}
----------------------------------------------------------------------
local function draw_menu(market_p, player)
    local market = market_p
    if next(market) == nil then
        return
    end
    if player.gui.relative["zra_market_menu"] then
        player.gui.relative["zra_market_menu"].destroy()
    end

    if not storage.prices_computed then

        market.total_buy = market.total_buy or 0
        market.total_tax = market.total_tax or 0
        -- open_or_close and
        local gui1, gui2, gui3
        local gui_parent
        if market.type == market_type.item then
            gui_parent = player.gui.relative.add {
                type = 'frame',
                name = 'zra_market_menu',
                caption = { "mbm-gui-gui-title" },
                anchor = { gui = defines.relative_gui_type.container_gui,
                           position = defines.relative_gui_position.left }
            }
        elseif market.type == market_type.fluid then
            gui_parent = player.gui.relative.add {
                type = 'frame',
                name = 'zra_market_menu',
                caption = { "mbm-gui-gui-title" },
                anchor = { gui = defines.relative_gui_type.storage_tank_gui,
                           position = defines.relative_gui_position.left }
            }
        elseif market.type == market_type.energy then
            gui_parent = player.gui.relative.add {
                type = 'frame',
                name = 'zra_market_menu',
                caption = { "mbm-gui-gui-title" },
                anchor = { gui = defines.relative_gui_type.accumulator_gui,
                           position = defines.relative_gui_position.left },
            }
        end

        gui_parent.style.maximal_height = 650
        gui_parent.style.maximal_width = 420
        gui1 = gui_parent
        gui1.style.minimal_height = 290
        gui1.style.minimal_width = 360
        market.main_gui = gui1
        gui1 = gui1.add({ type = "flow", direction = "vertical" })

        -----------------------------------
        ---GUI
        ---Automati

        gui2 = gui1.add({ type = "flow", direction = "horizontal" })
        local cbx_auto_trade = market.signal_cbx_auto_trade or false
        local cbx_auto_circuit = market.signal_cbx_auto_circuit or false
        gui1.add({ type = 'checkbox', name = 'cbx_mbm_activate_auto', caption = { 'mbm-gui-cbx-automatic' }, state = cbx_auto_trade })
        local gui4 = gui1.add({ type = 'table', column_count = 2 })
        market.signal_gui_radio_circuit = gui4.add({ type = 'radiobutton', name = 'rbx_mbm_activate_auto_circuit', caption = { 'mbm-gui-radio-circuits' }, state = cbx_auto_circuit, enabled = cbx_auto_trade })
        market.signal_gui_radio_self = gui4.add({ type = 'radiobutton', name = 'rbx_mbm_activate_auto_self', caption = { 'mbm-gui-radio-self-inv' }, state = not cbx_auto_circuit, enabled = cbx_auto_trade })
        gui3 = gui1.add({ type = "table", column_count = 4 })
        market.signal_gui_signal_active_a = gui3.add({ type = "choose-elem-button", name = "btn_mbm_elmnt_signal_activate_a-", elem_type = "signal", enabled = cbx_auto_trade })
        market.signal_gui_signal_active_a.elem_value = market.signal_automatic_a or nil
        local sel_index = market.signal_condition or 1
        market.signal_gui_drp_condition = gui3.add({ type = "drop-down", name = "drp_mbm_cond_signal_activate", items = { '>', '<', '=', '≥', '≤', '≠' }, selected_index = sel_index, enabled = cbx_auto_trade })
        market.signal_gui_drp_condition.style.maximal_width = 52
        local chb_state_const = market.signal_cbx_constant or false
        market.signal_gui_cbx_constant = gui3.add({ type = 'checkbox', name = 'cbx_mbm_activate_auto_cons', state = chb_state_const, enabled = cbx_auto_trade })
        market.signal_gui_table = gui3
        if chb_state_const then
            market.signal_gui_signal_active_b = gui3.add({ type = "choose-elem-button", name = "btn_mbm_elmnt_signal_activate_b", elem_type = "signal", enabled = cbx_auto_trade })
            market.signal_gui_signal_active_b.elem_value = market.signal_automatic_b or nil
        else
            market.signal_gui_signal_const_b = gui3.add({ type = "textfield", name = "txt_mbm_const_value", enabled = cbx_auto_trade, style = "textfield_blkmkt_style", numeric = true, allow_decimal = false, allow_negative = true })
            market.signal_gui_signal_const_b.style.width = 100
            local number = market.signal_constant_number or 0

            market.signal_gui_signal_const_b.text = tostring(number)
        end
        market.signal_gui_signal_a_lbl = gui3.add({ type = "label" })
        gui3.add({ type = "label" })
        gui3.add({ type = "label" })
        market.signal_gui_signal_b_lbl = gui3.add({ type = "label" })

        -----------------------------------



        local btn = nil
        if market.is_seller == true then
            btn = gui2.add({ type = "button", name = "btn_mbm_sell", caption = { "mbm-gui-btn-sell" } })
        else
            btn = gui2.add({ type = "button", name = "btn_mbm_buy", caption = { "mbm-gui-btn-buy" } })
        end
        btn.style.width = 344

        gui2 = gui1.add({ type = "table", column_count = 2 })

        if market.is_seller == false then
            gui2.add({ type = "label", caption = { "mbm-gui-lbl-money-tot" } })
            market.gui_lbl_money_tot = gui2.add({ type = "label", caption = format_money(market.total_buy) })

            gui2.add({ type = "label", caption = { "mbm-gui-lbl-tax-tot" } })
            market.gui_lbl_taxes_tot = gui2.add({ type = "label", caption = format_money(market.total_tax) })
        else
            gui2.add({ type = "label", caption = { "mbm-gui-lbl-money-tot" } })
            market.gui_lbl_money_tot = gui2.add({ type = "label", caption = format_money(market.total_buy) })
            gui2.add({ type = "label", caption = { "mbm-gui-lbl-tax-tot" } })
            market.gui_lbl_taxes_tot = gui2.add({ type = "label", caption = format_money(market.total_tax) })
            gui2.add({ type = "button", name = "btn_mbm_eval-", caption = { "mbm-gui-btn-eval" } })
            market.gui_lbl_evaluation = gui2.add({ type = "label" })
        end
        if market.is_seller then
            gui2.add({ type = "label", caption = { "mbm-gui-lbl-lso" } })
            gui3 = gui2.add({ type = "flow", direction = "horizontal" })
            market.gui_btn_sold = gui3.add({ type = "sprite-button" })
            market.last_sold_item = market.last_sold_item or nil
            if market.type == market_type.item and market.last_sold_item then
                if prototypes['item'][market.last_sold_item] then
                    market.gui_btn_sold.sprite = "item/" .. market.last_sold_item
                end

            elseif market.type == market_type.fluid and market.last_sold_item then

                if prototypes['fluid'][market.last_sold_item] then
                    market.gui_btn_sold.sprite = "fluid/" .. market.last_sold_item
                end

            elseif market.type == market_type.energy then
                market.gui_btn_sold.sprite = market.last_sold_item
            end
            market.gui_btn_sold.enabled = false
            gui3.add({ type = "label" })
        else
            if market.type == market_type.item then
                -- gui2 = gui1.add({type = "flow", direction = "horizontal", style = "horizontal_flow_blkmkt_style"})
                local btn_new = gui2.add({ type = "button", name = "btn_mbm_new_order", caption = { "mbm-gui-btn-add-order" } })
                btn_new.style.width = 170
                local btn_wipe = gui2.add({ type = "button", name = "btn_mbm_wipe_order", caption = { "mbm-gui-btn-wipe" } })
                btn_wipe.style.width = 170
            end
            market.gui_lbl_orders_total = gui1.add({ type = "label", name = "lbl_blkmkt_trader_orders", caption = { "mbm-gui-lbl-total-orders" } })
            gui2.style.maximal_height = 150
            gui2 = gui1.add({ type = "frame", direction = "horizontal" })
            gui2 = gui2.add({ type = "scroll-pane", vertical_scroll_policy = "auto" })
            gui2.style.minimal_width = 320
            gui2.style.minimal_height = 70
            gui2 = gui2.add({ type = "table", column_count = 5, draw_horizontal_lines = true, draw_horizontal_line_after_headers = true })
            gui2.style.minimal_height = 50
            local el1 = gui2.add({ type = "label" })
            el1.style.width = 50
            local el2 = gui2.add({ type = "label", caption = { "mbm-gui-tbl-item" } })
            el2.style.width = 50
            local el3 = gui2.add({ type = "label", caption = { 'mbm-gui-tbl-qnt' } })
            el3.style.width = 50
            local el4 = gui2.add({ type = "label", caption = { 'mbm-gui-tbl-qlt' } })
            el4.style.width = 50
            local el5 = gui2.add({ type = "label", caption = { "mbm-gui-tbl-price" } })
            el5.style.width = 50

            market.gui_orders_table = gui2
            gui_update_orders(market)
        end

    end
end
local function draw_elem_gui(market, player)
    if next(market) == nil then
        return
    end
    if player.gui.screen['zra_elem_menu'] then
        player.gui.screen['zra_elem_menu'].destroy()
    end
    local gui_parent = player.gui.screen.add { type = 'frame', name = 'zra_elem_menu' }

    if not storage.prices_computed then
        local main_window, item_table_holder, item_table
        main_window = gui_parent
        -- main_window = main_window.add({type = "empty-widget", ignored_by_interaction="true", name = "main_window_drag_handle", style = "flib_titlebar_drag_handle"})

        main_window = main_window.add { type = 'table', column_count = 1 }
        local title_bar = main_window.add { type = "flow", direction = "horizontal" }
        main_window = main_window.add({ type = "frame", direction = "vertical" })
        main_window.style.minimal_width = 380
        title_bar.drag_target = gui_parent

        title_bar.add { type = "label", caption = "Choose :", style = "frame_title", ignored_by_interaction = true }

        title_bar.add { type = "empty-widget", style = "draggable_space_header" }.style.horizontally_stretchable = true

        title_bar.add { type = "sprite-button", name = "btn_close_elemsel", sprite = "utility/close_fat", style = "frame_action_button" }

        local n = 1

        local table_tab = main_window.add({ type = 'table', column_count = 5 })
        local content_widget = main_window.add { type = "frame" }
        --local content_widget = main_window.add { type = 'frame' ,style = 'slot_button_deep_frame' }

        content_widget = content_widget.add { type = 'frame', style = 'inside_shallow_frame' }
        content_widget = content_widget.add { type = 'frame', style = 'slot_button_deep_frame' }
        n = 0
        local first_cat = nil
        local categorized_items = {}
        local pair_obj = nil
        if market.type == market_type.item then
            pair_obj = prototypes.get_item_filtered({})
        elseif market.type == market_type.fluid then
            pair_obj = prototypes.get_fluid_filtered({})
        end
        new_price = {}
        for name, item in pairs(pair_obj) do
            local is_fluid = (market.type == market_type.fluid)
            local recipe = player.force.recipes[name]
            local unlocked = false
            if stg_unknown_tech then
                unlocked = true
            else
                if recipe and recipe.enabled then
                    unlocked = true
                elseif is_fluid then
                    for _, technology in pairs(player.force.technologies) do
                        if technology.enabled and technology.researched then
                            for _, effect in pairs(technology.prototype.effects) do
                                if effect.type == "unlock-recipe" and effect.recipe == name then
                                    unlocked = true
                                    break
                                end
                            end
                        end
                        if unlocked then
                            break
                        end
                    end

                    if not unlocked then
                        unlocked = (item.subgroup.name == "fluid-recipes")
                    end

                    if not unlocked then
                        for _, recipe in pairs(player.force.recipes) do
                            if recipe.enabled then
                                for _, product in pairs(recipe.products) do
                                    if product.type == "fluid" and product.name == name then
                                        unlocked = true
                                        break
                                    end
                                end
                            end
                            if unlocked then
                                break
                            end
                        end
                    end
                end
            end

            if not unlocked then
                unlocked = (item.group.name == "raw-resource") or (item.subgroup.name == "raw-resource")
            end

            if unlocked then
                local group = item.group.name
                local subgroup = item.subgroup.name

                categorized_items[group] = categorized_items[group] or {}
                categorized_items[group][subgroup] = categorized_items[group][subgroup] or {}

                if first_cat == nil then
                    first_cat = group
                end

                table.insert(categorized_items[group][subgroup], item)
            end
        end

        content_list = {}
        for group_name, subgroups in pairs(categorized_items) do
            if market.type == market_type.item then
                local btn = table_tab.add { type = "sprite-button", name = 'mbm_btn_cat_sel=' .. group_name, sprite = "item-group/" .. group_name }
                btn.style.height = 100
                btn.style.width = 100
            elseif market.type == market_type.fluid then

                local btn = table_tab.add { type = "sprite-button", name = 'mbm_btn_cat_sel=' .. group_name, sprite = "item-group/" .. group_name }
                btn.style.height = 100
                btn.style.width = 100
            end
            local tab_content = content_widget.add { type = "scroll-pane", name = group_name .. "_scroll_pane" }
            local tab_content1 = tab_content.add { type = 'frame', style = 'inside_shallow_frame', direction = 'vertical', vertical_scroll_policy = 'auto' }
            local tab_content2 = tab_content1.add { type = 'frame', style = 'slot_button_deep_frame', direction = 'vertical', vertical_scroll_policy = 'auto' }
            if market.type == market_type.item then
                tab_content.style.maximal_height = 400
                tab_content.style.minimal_height = 400
                tab_content.style.minimal_width = 490
                tab_content2.style.minimal_width = 490
                tab_content2.style.minimal_height = 400
            elseif market.type == market_type.fluid then
                tab_content.style.maximal_height = 200
                tab_content.style.minimal_height = 200
                tab_content.style.minimal_width = 490
                tab_content2.style.minimal_width = 490
                tab_content2.style.minimal_height = 200
            end
            local tab_content3 = tab_content2.add({ type = 'table', column_count = 1 })

            tab_content3.style.top_margin = 0
            tab_content3.style.vertical_spacing = 0
            for subgroup_name, items in pairs(subgroups) do
                local subgroup_frame = tab_content3.add({ type = 'table', column_count = 10 })
                subgroup_frame.style.top_margin = 0
                subgroup_frame.style.vertical_spacing = 0
                subgroup_frame.style.horizontal_spacing = 0
                subgroup_frame.style.cell_padding = 0

                -- Aggiungi ogni item sbloccato del sottogruppo
                for _, item in ipairs(items) do
                    local oldprice = 0
                    if storage.prices[item.name] then
                        oldprice = storage.prices[item.name].current
                    end
                    local price_txt = format_money(oldprice) --..format_money(calculate_item_price(item.name,0,player))
                    if market.type == market_type.item then
                        subgroup_frame.add({ type = "sprite-button", name = "mbm_btn_sel_elem=" .. item.name, sprite = "item/" .. item.name, style = 'slot_button', tooltip = { '', price_txt, ' - ', item.localised_name } })
                    elseif market.type == market_type.fluid then

                        subgroup_frame.add({ type = "sprite-button", name = "mbm_btn_sel_elem=" .. item.name, sprite = "fluid/" .. item.name, style = 'slot_button', tooltip = { '', price_txt, ' - ', item.localised_name } })
                    end
                    --                                 tooltip = format_money(price.current) })
                end
            end
            content_list[group_name] = content_list[group_name] or { tab_content, tab_content1, tab_content2, tab_content3 }
            tab_content.visible = false
            tab_content1.visible = false
            tab_content2.visible = false
            tab_content3.visible = false
        end
        set_content_visible(first_cat, true)
    end

end
--------------------------------------------------------------------------------------
local function open_gui_event(event)
    local player = game.players[event.player_index]
    local surface = game.players[event.player_index].physical_surface
    local force = game.players[event.player_index].force
    if event.entity ~= nil then
        if storage.market_list ~= nil then
            if storage.market_list[event.entity.unit_number] ~= nil then
                local market = storage.market_list[event.entity.unit_number]
                if market.type == market_type.item then
                    if market.main_chest == nil then
                        local swap_entity = surface.create_entity({ name = event.entity.name, position = { x = event.entity.position.x, y = event.entity.position.y }, force = force })
                        swap_entity.destructible = false
                        swap_entity.minable = false
                        swap_chests(market.entity, swap_entity)
                        player.opened = swap_entity
                        market.main_chest = market.entity
                        market.entity = swap_entity

                    end
                end
                local signals_enable = nil
                if market.type == market_type.item then
                    signals_enable = market.main_chest.get_signals(defines.wire_connector_id.circuit_red, defines.wire_connector_id.circuit_green)
                else
                    signals_enable = market.entity.get_signals(defines.wire_connector_id.circuit_red, defines.wire_connector_id.circuit_green)
                end
                market_opened = market
                draw_menu(market, player)
                if signals_enable then
                    if market_opened.signal_cbx_auto_trade then
                        market.signal_gui_radio_circuit.enabled = true
                    end
                else
                    market.signal_gui_radio_circuit.enabled = false
                    market_opened.signal_cbx_auto_circuit = false
                    market_opened.signal_gui_radio_self.state = true
                    market_opened.signal_gui_radio_circuit.state = false
                    market_opened.signal_cbx_constant = false
                    if player.gui.relative["zra_market_menu"] then
                        player.gui.relative["zra_market_menu"].destroy()
                    end
                    draw_menu(market_opened, player)
                    storage.market_opened = market_opened
                end
            end
        end
    end
end
script.on_event(defines.events.on_gui_opened, open_gui_event)

--------------------------------------------------------------------------------------
local function close_gui_event(event)
    local player = game.players[event.player_index]
    if event.entity ~= nil then
        if next(storage.market_list) ~= nil then
            market_opened = storage.market_opened or market_opened
            if market_opened ~= nil then
                if player.gui.screen['zra_elem_menu'] then
                    player.gui.screen['zra_elem_menu'].destroy()
                end
                if player.gui.relative["zra_market_menu"] then
                    player.gui.relative["zra_market_menu"].destroy()
                    if market_opened.type == market_type.item then
                        swap_chests(market_opened.entity, market_opened.main_chest)
                        market_opened.entity.destructible = true
                        market_opened.entity.minable = true
                        market_opened.entity.destroy()
                        market_opened.entity = nil
                        market_opened.entity = market_opened.main_chest
                        market_opened.main_chest = nil

                    end
                    market_opened = nil
                    storage.market_opened = nil
                end
            end
        end
    end
end
script.on_event(defines.events.on_gui_closed, close_gui_event)

--------------------------------------------------------------------------------------
local function on_creation(event)

    local ent = event.entity
    local ent_name = ent.name
    --local player = game.players[event.player_index]
    --local surface = game.players[event.player_index].physical_surface
    --local force = game.players[event.player_index].force
    local prefix = string.sub(ent_name, 1, 15)
    local market_seller = nil
    local type = nil
    if prefix == "trader-chst-sel" and ent.destructible == true then
        market_seller = true
        type = market_type.item
    elseif prefix == "trader-chst-buy" and ent.destructible == true then
        market_seller = false
        type = market_type.item
    elseif prefix == "trader-tank-sel" and ent.destructible == true then
        market_seller = true
        type = market_type.fluid
    elseif prefix == "trader-tank-buy" and ent.destructible == true then
        market_seller = false
        type = market_type.fluid
    elseif prefix == "trader-accu-sel" and ent.destructible == true then
        market_seller = true
        type = market_type.energy
    elseif prefix == "trader-accu-buy" and ent.destructible == true then
        market_seller = false
        type = market_type.energy
    end
    if market_seller ~= nil then
        storage.market_list[ent.unit_number] = {
            type = type,
            entity = ent,
            is_seller = market_seller
        }

    end
end

script.on_event(defines.events.on_built_entity, on_creation)
script.on_event(defines.events.on_robot_built_entity, on_creation)

--------------------------------------------------------------------------------------
local function on_destruction(event)
    local ent = event.entity
    local ent_name = ent.name
    if event.entity ~= nil then
        if next(storage.market_list) ~= nil then
            if storage.market_list[event.entity.unit_number] ~= nil then
                storage.market_list[event.entity.unit_number] = nil
            end
        end
    end
end

script.on_event(defines.events.on_entity_died, on_destruction)
script.on_event(defines.events.on_robot_pre_mined, on_destruction)
script.on_event(defines.events.on_pre_player_mined_item, on_destruction)

--------------------------------------------------------------------------------------
local function show_custom_tooltip(player, item_stack)
    if storage.market_money_gui[player.index] then
        if storage.prices[item_stack.name] then
            if item_stack.quality then
                storage.market_money_gui[player.index].lbl_money_counter.caption = format_money(get_price_quality(storage.prices[item_stack.name].current, quality_type[item_stack.quality.name] + 1))
            else
                storage.market_money_gui[player.index].lbl_money_counter.caption = format_money(get_price_quality(storage.prices[item_stack.name].current, 0))
            end
        end
    end
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.get_player(event.player_index)
    local cursor_stack = player.cursor_stack

    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.valid then
        show_custom_tooltip(player, cursor_stack)
    else
        gui_money_counter_update()
    end
end)

--------------------------------------------------------------------------------------
local function on_click(event)
    local player = game.players[event.player_index]
    local elementSplit = str_split(event.element.name, '-')
    local btn = elementSplit[1]
    local order_id = tonumber(elementSplit[2])
    local catsplit = str_split(event.element.name, '=')
    local catbtn = catsplit[1] or nil
    local cat_id = catsplit[2] or nil

    if player.gui.screen['zra_elem_menu'] then

    end
    if market_opened == nil then
        return
    end

    if btn == 'btn_mbm_new_order' then
        gui_add_new_order(market_opened)
        gui_update_prices(market_opened)
    end
    if btn == 'btn_mbm_delete_order' then
        gui_clear(market_opened.gui_orders_table)
        table.remove(market_opened.orders, order_id)
        gui_update_orders(market_opened)
        gui_update_prices(market_opened)
    end
    if btn == 'btn_mbm_wipe_order' then
        market_opened.orders = {}
        gui_clear(market_opened.gui_orders_table)
        gui_update_orders(market_opened)
    end
    if btn == 'btn_mbm_buy' then
        gui_buy(market_opened)
    end
    if btn == 'btn_mbm_eval' then
        gui_eval_all(market_opened)
    end
    if btn == 'btn_mbm_sell' then
        gui_sell_all(market_opened)

    end
    if btn == 'cbx_mbm_activate_auto' then
        market_opened.signal_cbx_auto_trade = event.element.state
        market_opened.signal_gui_radio_circuit.enabled = event.element.state
        market_opened.signal_gui_radio_self.enabled = event.element.state
        market_opened.signal_gui_signal_active_a.enabled = event.element.state
        market_opened.signal_gui_drp_condition.enabled = event.element.state
        market_opened.signal_gui_cbx_constant.enabled = event.element.state
        if not market_opened.signal_cbx_constant then
            market_opened.signal_gui_signal_const_b.enabled = event.element.state
        else
            market_opened.signal_gui_signal_active_b.enabled = event.element.state
        end
    end
    if btn == 'rbx_mbm_activate_auto_circuit' then
        market_opened.signal_cbx_auto_circuit = true
        if event.element.state == true then
            market_opened.signal_gui_radio_self.state = false
            market_opened.signal_gui_radio_circuit.state = true
        end
    end
    if btn == 'rbx_mbm_activate_auto_self' then
        market_opened.signal_cbx_auto_circuit = false
        if event.element.state == true then
            market_opened.signal_gui_radio_self.state = true
            market_opened.signal_gui_radio_circuit.state = false
            market_opened.signal_cbx_constant = false
            if player.gui.relative["zra_market_menu"] then
                player.gui.relative["zra_market_menu"].destroy()
            end
            draw_menu(market_opened, player)
        end
    end
    if btn == 'cbx_mbm_activate_auto_cons' then
        local enbl = event.element.state
        if market_opened.signal_cbx_auto_circuit == false then
            event.element.state = false
        else
            market_opened.signal_cbx_constant = enbl
            if player.gui.relative["zra_market_menu"] then
                player.gui.relative["zra_market_menu"].destroy()
            end
            draw_menu(market_opened, player)
        end

    end
    if btn == 'btn_mbm_elmnt_signal_activate_a' then
        market_opened.signal_automatic_a = event.element.elem_value
    end
    if btn == 'btn_mbm_elmnt_signal_activate_b' then
        market_opened.signal_automatic_b = event.element.elem_value
    end
    if catbtn == 'mbm_btn_cat_sel' then
        if player.gui.screen['zra_elem_menu'] then
            if content_list then
                for category, _ in pairs(content_list) do

                    set_content_visible(category, false)
                    --content_list[category].visible = false
                end
                --content_list[cat_id].visible = true
                set_content_visible(cat_id, true)

            end
        end
    end
    if catbtn == 'mbm_btn_sel_elem' then
        if player.gui.screen['zra_elem_menu'] and player.gui.relative['zra_market_menu'] then
            if market_opened.type == market_type.item then

                market_opened.orders[content_select_order_id].item = cat_id
                market_opened.orders[content_select_order_id].item_btn.sprite = event.element.sprite
            elseif market_opened.type == market_type.fluid then
                market_opened.orders[1].item = cat_id
                market_opened.orders[1].item_btn.sprite = event.element.sprite
            end
            gui_update_prices(market_opened)
            if player.gui.screen['zra_elem_menu'] then
                player.gui.screen['zra_elem_menu'].destroy()
            end

        end
    end
    if btn == 'btn_close_elemsel' then
        if player.gui.screen['zra_elem_menu'] then
            player.gui.screen['zra_elem_menu'].destroy()
        end
    end
    if btn == 'btn_mbm_elmnt' then
        draw_elem_gui(market_opened, player)
        content_select_order_id = order_id
        --if event.element.elem_value ~= market_opened.orders[order_id].item then
        --    if market_opened.type ~= market_type.energy then
        --        if event.element.elem_value ~= 'fusion-plasma' and event.element.elem_value ~= 'lava' then
        --            market_opened.orders[order_id].item = event.element.elem_value
        --            gui_update_prices(market_opened)
        --
        --        end
        --        --build_menu_objects(player,true,player_mem.ask_sel)
        --    end
        --end
    end
end

script.on_event(defines.events.on_gui_elem_changed, on_click)
script.on_event(defines.events.on_gui_click, on_click)

--------------------------------------------------------------------------------------
local function on_gui_text_changed(event)
    local player = game.players[event.player_index]
    local elementSplit = str_split(event.element.name, '-')
    local btn = elementSplit[1]
    local order_id = tonumber(elementSplit[2])
    if market_opened == nil then
        return
    end
    if btn == "txt_mbm_qnt" then
        local count = tonumber(event.element.text)
        if count ~= nil then
            market_opened.orders[order_id].quantity = count
            gui_update_prices(market_opened)
        end
    end
    if btn == "txt_mbm_const_value" then
        local count = tonumber(event.element.text)
        if count ~= nil then
            market_opened.signal_constant_number = count
        end
    end
end
script.on_event(defines.events.on_gui_text_changed, on_gui_text_changed)

--------------------------------------------------------------------------------------
local function on_gui_dropdown_changed(event)
    local player = game.players[event.player_index]
    local elementSplit = str_split(event.element.name, '-')
    local btn = elementSplit[1]
    local order_id = tonumber(elementSplit[2])
    if market_opened == nil then
        return
    end
    if btn == "drp_mbm_qlt" then
        local quality = tonumber(event.element.selected_index)
        if quality ~= nil then
            if quality <= 0 then
                quality = 1
            end
            market_opened.orders[order_id].quality = quality
            gui_update_prices(market_opened)
        end
    end
    if btn == 'drp_mbm_cond_signal_activate' then
        market_opened.signal_condition = event.element.selected_index
    end
end
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_dropdown_changed)

--------------------------------------------------------------------------------------
local function on_entity_settings_pasted(event)
    local source = storage.market_list[event.source.unit_number] or nil
    local target = storage.market_list[event.destination.unit_number] or nil
    if source == nil or target == nil then
        return
    end

    target.signal_cbx_auto_trade = source.signal_cbx_auto_trade
    target.signal_cbx_auto_circuit = source.signal_cbx_auto_circuit
    target.signal_condition = source.signal_condition
    target.signal_cbx_constant = source.signal_cbx_constant
    target.signal_automatic_a = source.signal_automatic_a
    target.signal_automatic_b = source.signal_automatic_b
    target.signal_constant_number = source.signal_constant_number
    target.orders = source.orders
end
script.on_event(defines.events.on_entity_settings_pasted, on_entity_settings_pasted)

-------------------------------------------------------------------------------------
local function calculate_condition(el1, el2, condition)

    if el1 == nil or el2 == nil or condition == nil then
        return
    end
    condition = condition_type[condition]
    if condition == '<' then
        if el1 < el2 then
            return true
        end
    elseif condition == '>' then
        if el1 > el2 then
            return true
        end
    elseif condition == '=' then
        if el1 == el2 then
            return true
        end
    elseif condition == '<=' then
        if el1 <= el2 then
            return true
        end
    elseif condition == '>=' then
        if el1 >= el2 then
            return true
        end
    elseif condition == '~=' then
        if el1 ~= el2 then
            return true
        end
    end
    return false
end
local function calculate_signal_value(signal, market)

    local afc = market.signal_cbx_auto_circuit or false
    if afc then
        local signals = market.entity.get_signals(defines.wire_connector_id.circuit_red, defines.wire_connector_id.circuit_green)
        if signals then
            for _, item in pairs(signals) do
                if item.signal.name == signal then
                    return item.count
                end
            end
        else
            return nil
        end
    elseif afc == false then
        if market.type == market_type.item then
            local count = 0
            local inv = market.entity.get_inventory(defines.inventory.chest)
            for i, item in pairs(inv.get_contents()) do
                if signal == item.name then
                    count = count + item.count
                end

            end
            return count
        end
        if market.type == market_type.fluid then
            local count = 0
            for name, amount in pairs(market.entity.get_fluid_contents()) do
                count = count + amount
            end

            return count
        end
        if market.type == market_type.energy then
            return market.entity.energy
        end
    end
end

local function on_tick(event)

    if storage.tick >= (time_stg_ticks * 60) then
        if storage.market_list then
            for _, market in pairs(storage.market_list) do
                market.signal_cbx_auto_trade = market.signal_cbx_auto_trade or false

                if market.signal_cbx_auto_trade then
                    market.signal_cbx_auto_circuit = market.signal_cbx_auto_circuit or false
                    local signal_a = nil
                    if market.signal_automatic_a then
                        signal_a = market.signal_automatic_a.name or nil
                        signal_a = calculate_signal_value(signal_a, market)
                        if signal_a == nil then
                            signal_a = 0
                        end
                    end
                    if market.type == market_type.energy then
                        local energy = calculate_signal_value(energy_name, market) or nil
                        if energy then
                            signal_a = energy / 1000000
                        end
                    end
                    if market.type == market_type.fluid and market.signal_cbx_auto_circuit == false then
                        signal_a = calculate_signal_value('no-fluid', market) or nil
                    end
                    local signal_b = nil
                    if market.signal_automatic_b then
                        signal_b = market.signal_automatic_b.name or nil
                        signal_b = calculate_signal_value(signal_b, market)
                        if signal_b == nil then
                            signal_b = 0
                        end
                    end
                    local constant_b = 0
                    if market.signal_constant_number then
                        constant_b = market.signal_constant_number or nil
                        if constant_b == nil then
                            constant_b = 0
                        end
                    end
                    local constant_enable = true
                    if market.signal_cbx_constant then
                        constant_enable = market.signal_cbx_constant
                    end

                    local sel_cond = 1
                    if market.signal_condition then
                        sel_cond = market.signal_condition
                    end
                    local can_buy = false
                    if constant_enable then
                        can_buy = calculate_condition(signal_a, constant_b, sel_cond)
                    elseif constant_enable == false then
                        can_buy = calculate_condition(signal_a, signal_b, sel_cond)
                    end
                    if can_buy then
                        if market.is_seller then
                            gui_sell_all(market)
                        else
                            gui_buy(market)
                        end

                    end

                end
            end
        end
        storage.tick = 0
    elseif storage.tick % 3 == 1 then
        if market_opened then
            local signals_enable = nil
            if market_opened.type == market_type.item then
                signals_enable = market_opened.main_chest.get_circuit_network(defines.wire_connector_id.circuit_red) or market_opened.main_chest.get_circuit_network(defines.wire_connector_id.circuit_green)
            else
                signals_enable = market_opened.entity.get_circuit_network(defines.wire_connector_id.circuit_red) or market_opened.entity.get_circuit_network(defines.wire_connector_id.circuit_green)
            end
            if market_opened.signal_cbx_auto_trade == true then
                if signals_enable ~= nil then
                    market_opened.signal_gui_radio_circuit.enabled = true
                else
                    market_opened.signal_gui_radio_circuit.enabled = false
                    market_opened.signal_cbx_auto_circuit = false
                    market_opened.signal_gui_radio_self.state = true
                    market_opened.signal_gui_radio_circuit.state = false
                    market_opened.signal_cbx_constant = false
                end

            end
            if market_opened.type == market_type.item then
                local signals = nil
                signals = market_opened.main_chest.get_signals(defines.wire_connector_id.circuit_red, defines.wire_connector_id.circuit_green)
                if signals then
                    for i = 1, #signals do
                        if market_opened.signal_automatic_a then
                            if market_opened.signal_automatic_a.name == signals[i].signal.name then
                                if market_opened.signal_cbx_auto_circuit then
                                    market_opened.signal_gui_signal_a_lbl.caption = signals[i].count
                                    --market_opened.signal_gui_signal_active_a.number = signals[i].count
                                    --TODO ADD number to spriteButton > NEED SPRITE MENU TO SELECT SIGNAL :|
                                else
                                    market_opened.signal_gui_signal_a_lbl.caption = calculate_signal_value(market_opened.signal_automatic_a.name, market_opened)
                                end
                            end
                        end
                        if market_opened.signal_automatic_b and market_opened.signal_cbx_constant == true then
                            if market_opened.signal_automatic_b.name == signals[i].signal.name then
                                market_opened.signal_gui_signal_b_lbl.caption = signals[i].count
                            end
                        elseif market_opened.signal_cbx_constant == false then
                            market_opened.signal_gui_signal_b_lbl.caption = ''
                        end
                    end

                end
            end
        end

    elseif storage.tick % 5 == 1 then

        if market_opened == nil then
            for _, player in pairs(game.players) do
                if player.gui.screen['zra_elem_menu'] then
                    player.opened = nil
                end
                if player.gui.relative['zra_market_menu'] then
                    player.opened = nil
                end
                init_gui_money_counter(player)
            end
        end
    end
    storage.tick = storage.tick + 1
    if recalculate_price then
        recalculate_price = false
        update_techs_costs()
        update_objects_prices()
    end
end
script.on_event(defines.events.on_tick, on_tick)

-------------------------------------------------------------------------------------
local function configure_settings_local()
    fill_quality_type()
    tax_pay = stg_tax_rate / 100
    if stg_tax_enable == false then
        tax_pay = 0
    end
    configure_settings()
    update_objects_prices_start()
    update_objects_prices()
    update_groups()
end
script.on_event(defines.events.on_runtime_mod_setting_changed, configure_settings_local)

-------------------------------------------------------------------------------------
local function set_local_p(event)
    local_p = game.players[event.player_index]
end
script.on_event(defines.events.on_player_changed_position, set_local_p)

--------------------------------------------------------------------------------------
local function initModSetting()
    storage.market_list = storage.market_list or {}
    storage.market_money = storage.market_money or 0
    storage.market_money_gui = storage.market_money_gui or { }
    init_storages()
    update_techs_costs()
    update_objects_prices()
    --

end
script.on_init(initModSetting)
-------------------------------------------------------------------------------------