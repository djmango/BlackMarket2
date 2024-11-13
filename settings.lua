data:extend({
    {

        type = "int-setting",
        name = "mbm-qlt-1-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 100,
        default_value = 1,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-2-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 100,
        default_value = 2,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-3-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 100,
        default_value = 4,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-4-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 100,
        default_value = 7,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-5-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 100,
        default_value = 10,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-unk-div-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 20,
        default_value = 2,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-qlt-unk-mul-stg",
        setting_type = "runtime-global",
        minimum_value = 1,
        maximal_value = 20,
        default_value = 3,
        order = "aa"
    },
    -- Basic prices
    {
        type = "bool-setting",
        name = "mbm-tax-enable-stg",
        setting_type = "runtime-global",
        default_value = true,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-tax-rate-stg",
        setting_type = "runtime-global",
        minimum_value = 0,
        maximal_value = 99,
        default_value = 21,
        order = "ab"
    },
    {
        type = "bool-setting",
        name = "mbm-unknown-tech-stg",
        setting_type = "runtime-global",
        default_value = true,
        order = "aa"
    },
    {
        type = "int-setting",
        name = "mbm-time-ck-stg",
        setting_type = "runtime-global",
        minimum_value = 30,
        maximal_value = 360,
        default_value = 30,
        order = "ab"
    },
    {
        type = "string-setting",
        name = "mbm-unkn-items-stg",
        setting_type = "runtime-global",
        allow_blank = true,
        default_value = "",
        order = "ab"
    },
    {
        type = "int-setting",
        name = "BM2-resource_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 30,
        order = "ac"
    },
    {
        type = "int-setting",
        name = "BM2-infinite_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0,
        order = "ad"
    },
    {
        type = "int-setting",
        name = "BM2-free_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 0,
        order = "ae"
    },
    {
        type = "int-setting",
        name = "BM2-unknown_price",
        setting_type = "runtime-global",
        minimum_value = 0,
        default_value = 20,
        order = "af"
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
    -- other
    {
        type = "int-setting",
        name = "BM2-recipe_depth_maximum",
        setting_type = "runtime-global",
        minimum_value = 1,
        default_value = 10,
        order = "ga"
    }
})
