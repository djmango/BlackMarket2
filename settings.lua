data:extend({
    -- Overall multiplyer
    {
        type = "double-setting",
        name = "BM2-price_multiplyer",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1,
        order = "aaa"
    },
    -- Basic prices
    {
        type = "int-setting",
        name = "BM2-resource_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 100,
        order = "aab"
    },
    {
        type = "int-setting",
        name = "BM2-resource_price_new",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 99,
        order = "ab"
    },
    {
        type = "int-setting",
        name = "BM2-infinite_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 2,
        order = "ac"
    },
    {
        type = "int-setting",
        name = "BM2-free_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0,
        order = "ad"
    },
    {
        type = "int-setting",
        name = "BM2-unknown_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0,
        order = "ae"
    },

    -- Vanilla resources
    {
        type = "int-setting",
        name = "BM2-water_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0,
        order = "ba"
    },
    {
        type = "int-setting",
        name = "BM2-coal_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 16,
        order = "bb"
    },
    {
        type = "int-setting",
        name = "BM2-stone_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 27,
        order = "bc"
    },
    {
        type = "int-setting",
        name = "BM2-iron_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 19,
        order = "bd"
    },
    {
        type = "int-setting",
        name = "BM2-copper_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 21,
        order = "be"
    },
    {
        type = "int-setting",
        name = "BM2-oil_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 100,
        order = "bf"
    },
    
    -- special manually declared prices
    {
        type = "int-setting",
        name = "BM2-coin",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1,
        order = "ca"
    },
    {
        type = "int-setting",
        name = "BM2-ucoin",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1,
        order = "cb"
    },
    {
        type = "int-setting",
        name = "BM2-raw_wood",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 51,
        order = "cc"
    },
    {
        type = "int-setting",
        name = "BM2-raw_fish",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 30,
        order = "cca"
    },
    {
        type = "int-setting",
        name = "BM2-thermal_water",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 100,
        order = "cd"
    },
    {
        type = "int-setting",
        name = "BM2-empty_canister",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 161,
        order = "ce"
    },
    {
        type = "int-setting",
        name = "BM2-empty_barrel",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1331,
        order = "cf"
    },
    {
        type = "int-setting",
        name = "BM2-gold_plate",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 10000,
        order = "cg"
    },
    {
        type = "int-setting",
        name = "BM2-gold_ingot",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 11500,
        order = "ch"
    },
    
    -- other prices
    
    {
        type = "int-setting",
        name = "BM2-energy_price",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 500,
        order = "ea"
    },
    {
        type = "int-setting",
        name = "BM2-energy_cost",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 20,
        order = "eb"
    },
    {
        type = "int-setting",
        name = "BM2-tech_ingr_cost",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1000,
        order = "ec"
    },
    {
        type = "double-setting",
        name = "BM2-tech_amortization",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.001,
        order = "ed"
    },
    {
        type = "double-setting",
        name = "BM2-commercial_margin",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.10,
        order = "ee"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_regrowth",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.05,
        order = "ef"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_item",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.00008,
        order = "eg"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_fluid",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.00006,
        order = "eh"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_influence_energy",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.0004,
        order = "ei"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_minimal",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.01,
        order = "ej"
    },
    {
        type = "double-setting",
        name = "BM2-dynamic_maximal",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 2,
        order = "ek"
    },
    
    -- Tax setting
    {
        type = "int-setting",
        name = "BM2-tax_start",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 4,
        order = "fa"
    },
    {
        type = "double-setting",
        name = "BM2-tax_growth",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.5,
        order = "fb"
    },
    {
        type = "int-setting",
        name = "BM2-tax_immediate",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 25,
        order = "fc"
    }
})
