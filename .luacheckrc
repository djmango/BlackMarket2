std = "min"

-- Exclude directories that shouldn't be linted
exclude_files = {
    ".luarocks/**",
    ".github/**",
    "node_modules/**",
    ".vscode/**"
}

-- Global variables defined in your mod files
globals = {
    -- Factorio API
    "game", "script", "defines", "prototypes", "settings", "storage",
    "commands", "log", "table_size", "serpent", "util", "mods",
    "remote", "rcon", "rendering", "helpers", "data", "pcall",
    "ipairs", "pairs", "next", "type", "tostring", "tonumber",
    "string", "math", "table", "assert", "error", "getmetatable",
    "setmetatable", "rawget", "rawset", "rawlen", "rawequal",
    "select", "unpack",

    -- Mod-specific globals from config.lua and utils.lua
    "debug_status", "debug_mod_name", "debug_file", "debug_do_raz",
    "debug_active", "debug_print", "message_all", "message_force",
    "square_area", "distance", "distance_square", "pos_offset",
    "surface_area", "iif", "add_list", "del_list", "in_list",
    "size_list", "concat_lists", "dupli_proto", "debug_guis",
    "extract_monolith", "configure_settings",

    -- Color definitions
    "colors", "anticolors", "lightcolors",

    -- Variables from config.lua
    "resource_price", "water_price", "free_price", "unknown_price",
    "vanilla_resources_prices", "special_prices", "unknown_price_reason_logging",
    "recipe_depth_maximum", "only_items_researched", "tax_enabled",
    "dynamic_prices_enabled", "energy_price", "energy_cost", "tech_ingr_cost",
    "tech_amortization", "commercial_margin", "dynamic_regrowth",
    "dynamic_influence_item", "dynamic_influence_fluid", "dynamic_influence_energy",
    "dynamic_minimal", "dynamic_maximal", "tax_immediate", "tax_start",
    "tax_growth", "periods", "default_n_period", "default_auto", "thousands_separator",

    -- Variables from control.lua
    "prices_file", "price_log", "specials_file", "format_money", "format_evolution",
    "add_order", "gui3", "price", "item_recipe", "recipe",

    -- Other mod globals
    "mod_gui"
}

-- Read-only globals
read_globals = {
    "mod_gui", "_G", "_ENV", "require"
}

-- Ignore specific warnings that are common in Factorio mods
ignore = {
    "212", -- Unused argument (common in event handlers)
    "213", -- Unused loop variable
    "311", -- Value assigned to variable is unused
    "314", -- Field of a table literal is overwritten
    "542", -- Empty if branch
    "611", -- Line contains only whitespace
    "612", -- Line contains trailing whitespace
    "614", -- Trailing whitespace in comment
    "631", -- Line is too long
}

-- Maximum line length (increase from default 120)
max_line_length = 140
