std = "min"

-- Factorio globals
globals = {
    "game", "script", "defines", "prototypes", "settings", "storage",
    "commands", "log", "table_size", "serpent", "util", "mods",
    "remote", "rcon", "rendering", "helpers", "data", "pcall",
    "ipairs", "pairs", "next", "type", "tostring", "tonumber",
    "string", "math", "table", "assert", "error", "getmetatable",
    "setmetatable", "rawget", "rawset", "rawlen", "rawequal",
    "select", "unpack"
}

-- Read-only globals
read_globals = {
    "mod_gui", "_G", "_ENV", "require"
}

-- Ignore specific warnings that are common in Factorio mods
ignore = {
    "212", -- Unused argument (common in event handlers)
    "213", -- Unused loop variable
    "311", -- Value assigned to a local variable is unused
    "314", -- Value of field is overwritten before use
    "542", -- Empty if branch
    "611", -- Line contains only whitespace
    "612", -- Line contains trailing whitespace
    "614", -- Trailing whitespace in comment
    "621", -- Inconsistent indentation (Factorio uses mixed styles)
    "631", -- Line is too long (some Factorio code tends to be verbose)
}

-- Exclude files that don't need strict linting
exclude_files = {
    "migrations/*.lua",
    ".vscode/**",
    ".vscode/**.lua"
}

-- File-specific configurations
files["control.lua"] = {
    globals = {
        "storage", "script", "game", "defines", "prototypes", "settings",
        "remote", "commands", "debug_print", "message_all", "configure_settings",
        "debug_status", "debug_mod_name", "debug_file", "prices_file", "price_log",
        "specials_file", "mod_gui", "trader_type", "energy_name", "quality_list",
        "quality_lookup_by_name", "quality_lookup_by_level", "has_quality",
        "vanilla_quality_multipliers", "trader_signals", "periods",
        "format_money", "format_evolution", "add_order", "gui3", "price",
        "item_recipe", "recipe", "water_price", "free_price", "thousands_separator",
        "tax_enabled", "tax_immediate", "tax_start", "tax_growth",
        "tech_ingr_cost", "energy_cost", "tech_amortization", "energy_price",
        "vanilla_resources_prices", "special_prices", "resource_price",
        "unknown_price", "commercial_margin", "recipe_depth_maximum",
        "unknown_price_reason_logging", "dynamic_prices_enabled",
        "dynamic_maximal", "dynamic_minimal", "dynamic_regrowth",
        "dynamic_influence_item", "dynamic_influence_fluid",
        "dynamic_influence_energy", "only_items_researched",
        "default_auto", "default_n_period", "concat_lists"
    }
}

files["data.lua"] = {
    globals = { "data" }
}

files["prototypes/*.lua"] = {
    globals = {
        "data", "table", "dupli_proto"
    }
}

files["settings.lua"] = {
    globals = { "data" }
}

files["utils.lua"] = {
    globals = {
        "debug_print", "message_all", "iif", "concat_lists",
        "colors", "anticolors", "lightcolors", "debug_active",
        "debug_do_raz", "debug_file", "debug_mod_name", "debug_status",
        "message_force", "square_area", "distance", "distance_square",
        "pos_offset", "surface_area", "add_list", "del_list", "in_list",
        "size_list", "dupli_proto", "debug_guis", "extract_monolith"
    }
}

files["config.lua"] = {
    globals = {
        "configure_settings", "periods", "default_n_period", "default_auto",
        "tax_enabled", "tax_immediate", "tax_start", "tax_growth",
        "tech_ingr_cost", "energy_cost", "tech_amortization", "energy_price",
        "vanilla_resources_prices", "special_prices", "resource_price",
        "unknown_price", "commercial_margin", "recipe_depth_maximum",
        "unknown_price_reason_logging", "dynamic_prices_enabled",
        "dynamic_maximal", "dynamic_minimal", "dynamic_regrowth",
        "dynamic_influence_item", "dynamic_influence_fluid",
        "dynamic_influence_energy", "only_items_researched",
        "water_price", "free_price", "thousands_separator"
    }
}

-- Max line length (Factorio mods can be verbose)
max_line_length = 120
