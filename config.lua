function configure_settings()

    local function str_split (str, sep)
        local result = {}
        -- Usa una regex per trovare solo le parti separate da '__'
        for part in string.gmatch(str, "([^" .. sep .. "]+)" .. sep .. "?") do
            if part ~= "" then
                table.insert(result, part)
            end
        end
        return result
    end
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
    vanilla_quality_prices = {
        settings.global["mbm-qlt-1-stg"].value,
        settings.global["mbm-qlt-2-stg"].value,
        settings.global["mbm-qlt-3-stg"].value,
        settings.global["mbm-qlt-4-stg"].value,
        settings.global["mbm-qlt-5-stg"].value
    }
    quality_muiltipliers = {
        settings.global["mbm-qlt-unk-div-stg"].value,
        settings.global["mbm-qlt-unk-mul-stg"].value
    }
    -- special manually declared prices

    special_prices = {
        ["ucoin"] = settings.global["BM2-ucoin"].value,

        ["wood"] = settings.global["BM2-wood"].value,
        ["raw-fish"] = settings.global["BM2-raw_fish"].value,

        ["steam"] = settings.global["BM2-steam"].value,
    }

    --unknown_price_reason_logging = settings.global["BM2-unknown_price_reason_logging"]

    recipe_depth_maximum = settings.global["BM2-recipe_depth_maximum"].value -- the maximum depth the recipe search can go
    --only_items_researched = settings.global["BM2-only_items_researched"].value -- if only want researched items enabled or not
    --tax_enabled = settings.global["BM2-enable_tax"].value -- if taxes enabled or not
    --dynamic_prices_enabled = settings.global["BM2-dynamic_prices"].value -- if dynamic is enabled or not
    stg_tax_rate = settings.global['mbm-tax-rate-stg'].value--TAX RATE -> /100
    stg_tax_enable = settings.global['mbm-tax-enable-stg'].value
    stg_unknown_tech = settings.global['mbm-unknown-tech-stg'].value
    time_stg_ticks = settings.global['mbm-time-ck-stg'].value

    energy_price = settings.global["BM2-energy_price"].value -- price for selling and buying energy (for 1MJ)
    energy_cost = settings.global["BM2-energy_cost"].value -- cost of energy unit in recipes (time, different from MJ)
    tech_ingr_cost = settings.global["BM2-tech_ingr_cost"].value -- average cost of a science pack
    tech_amortization = settings.global["BM2-tech_amortization"].value -- amortization of the tech cost in object price
    --commercial_margin = settings.global["BM2-commercial_margin"].value -- commercial margin

    --dynamic_regrowth = settings.global["BM2-dynamic_regrowth"].value -- how prices slowly return to optimal value if untouched (every day)
    --dynamic_influence_item = settings.global["BM2-dynamic_influence_item"].value -- influence of sales and purchases on prices (per item, per day)
    --dynamic_influence_fluid = settings.global["BM2-dynamic_influence_fluid"].value -- influence of sales and purchases on prices (per item, per day)
    --dynamic_influence_energy = settings.global["BM2-dynamic_influence_energy"].value -- influence of sales and purchases on prices (per item, per day)
    --dynamic_minimal = settings.global["BM2-dynamic_minimal"].value
    --dynamic_maximal = settings.global["BM2-dynamic_maximal"].value

    --tax_immediate = settings.global["BM2-tax_immediate"].value -- starting fee in % for one action per day
    --tax_start = settings.global["BM2-tax_start"].value -- exponential growth with frequency/day : fee = tax_start * (freq ^ tax_growth)
    --tax_growth = settings.global["BM2-tax_growth"].value -- % fee for immediate action

    --periods = {0,1,2,3,4,6,8,12,24} -- available periods in hours
    --default_n_period = 2 -- default period of a new trading chest
    --default_auto = settings.global["BM2-default_auto"].value -- default automatic mode

    thousands_separator = ","
end