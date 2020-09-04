data:extend({
    -- High-level settings
    {
        type = "double-setting",
        name = "BM2-price_multiplyer",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 1,
        order = "aaa"
    },
    {
        type = "bool-setting",
        name = "BM2-only_items_researched",
        setting_type = "runtime-global",
        default_value = false,
        order = "aab"
    },
    -- Basic prices
    {
        type = "int-setting",
        name = "BM2-resource_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 100,
        order = "ab"
    },
    {
        type = "int-setting",
        name = "BM2-infinite_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 2,
        order = "ac"
    },
    {
        type = "int-setting",
        name = "BM2-free_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0,
        order = "ad"
    },
    {
        type = "int-setting",
        name = "BM2-unknown_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 20,
        order = "ae"
    },

    -- Vanilla resources
    {
        type = "int-setting",
        name = "BM2-water_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0,
        order = "ba"
    },
    {
        type = "int-setting",
        name = "BM2-coal_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 16,
        order = "bb"
    },
    {
        type = "int-setting",
        name = "BM2-stone_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 27,
        order = "bc"
    },
    {
        type = "int-setting",
        name = "BM2-iron_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 19,
        order = "bd"
    },
    {
        type = "int-setting",
        name = "BM2-copper_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 21,
        order = "be"
    },
    {
        type = "int-setting",
        name = "BM2-uranium_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 182,
        order = "be"
    },
    {
        type = "int-setting",
        name = "BM2-oil_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 100,
        order = "bf"
    },
    
    -- special manually declared prices
    {
        type = "int-setting",
        name = "BM2-ucoin",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 1,
        order = "cb"
    },
    {
        type = "int-setting",
        name = "BM2-wood",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 51,
        order = "cc"
    },
    {
        type = "int-setting",
        name = "BM2-raw_fish",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 30,
        order = "cca"
    },
    {
        type = "int-setting",
        name = "BM2-steam",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 100,
        order = "cd"
    },
    {
        type = "int-setting",
        name = "BM2-empty_canister",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 161,
        order = "ce"
    },
    {
        type = "int-setting",
        name = "BM2-empty_barrel",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 1331,
        order = "cf"
    },
    
    -- other prices
    
    {
        type = "int-setting",
        name = "BM2-energy_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 500,
        order = "ea"
    },
    {
        type = "int-setting",
        name = "BM2-energy_cost",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 20,
        order = "eb"
    },
    {
        type = "int-setting",
        name = "BM2-tech_ingr_cost",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 1000,
        order = "ec"
    },
    {
        type = "double-setting",
        name = "BM2-tech_amortization",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.001,
        order = "ed"
    },
    {
        type = "double-setting",
        name = "BM2-commercial_margin",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.10,
        order = "ee"
    },
    -- dynamic price stuff
    {
        type = "bool-setting",
        name = "BM2-dynamic_prices",
        setting_type = "runtime-global",
        default_value = true,
        order = "aa"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_regrowth",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.05,
        order = "ef"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_item",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.00008,
        order = "eg"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_fluid",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.00006,
        order = "eh"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_energy",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.0004,
        order = "ei"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_minimal",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.01,
        order = "ej"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_maximal",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 2,
        order = "ek"
    },
    
    -- Tax setting
    {
        type = "int-setting",
        name = "BM2-tax_start",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 4,
        order = "fa"
    },
    {
        type = "double-setting",
        name = "BM2-tax_growth",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0.5,
        order = "fb"
    },
    {
        type = "int-setting",
        name = "BM2-tax_immediate",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 25,
        order = "fc"
    }
})
