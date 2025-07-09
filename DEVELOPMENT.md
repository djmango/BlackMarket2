# Development Guide

This document describes the development setup and workflows for the BlackMarket2 Factorio mod.

## GitHub Actions Workflows

### Validation Workflow (`.github/workflows/validate.yml`)

Runs automatically on:
- Push to `master`, `main`, or `develop` branches
- Pull requests to `master`, `main`, or `develop` branches

**What it does:**
- ✅ Validates mod structure (required files exist)
- ✅ Validates `info.json` format and required fields
- ✅ Runs Lua linting with `luacheck`
- ✅ Validates locale files structure
- ✅ Checks for common issues (debug prints, trailing whitespace, etc.)
- ✅ Validates changelog format (if present)
- ✅ Generates a comprehensive validation report

### Release Workflow (`.github/workflows/release.yml`)

Runs automatically when:
- A version tag is pushed (format: `v1.2.3`)

**What it does:**
- ✅ Validates that the tag version matches `info.json` version
- ✅ Creates a properly packaged mod zip file
- ✅ Generates release notes from changelog
- ✅ Creates a GitHub release with the mod package

## Local Development

### Prerequisites

1. **Lua and LuaCheck** (for linting):
   ```bash
   # Install Lua (version 5.4 recommended)
   # Install LuaRocks
   luarocks install luacheck
   ```

2. **jq** (for JSON validation):
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install jq
   
   # On macOS
   brew install jq
   ```

### Linting

Run the linter locally:

```bash
# Lint all Lua files
luacheck .

# Lint specific file
luacheck control.lua

# Show only errors (no warnings)
luacheck . --no-unused
```

The project includes a `.luacheckrc` configuration file that:
- Defines Factorio-specific globals
- Ignores common Factorio mod patterns
- Sets appropriate rules for different file types

### File Structure Validation

The workflows expect this file structure:

```
BlackMarket2/
├── info.json          # Required: Mod metadata
├── control.lua        # Required: Main control script  
├── data.lua           # Required: Data stage script
├── settings.lua       # Optional: Mod settings
├── changelog.txt      # Optional: Version history
├── locale/            # Optional: Localization
│   ├── en/
│   └── cn/
├── graphics/          # Optional: Sprites and images
├── prototypes/        # Optional: Prototype definitions
└── migrations/        # Optional: Save migration scripts
```

### Version Management

1. **Update version in `info.json`**
2. **Update `changelog.txt`** with new version changes
3. **Create a git tag**: `git tag v1.2.3`
4. **Push the tag**: `git push origin v1.2.3`

The release workflow will automatically:
- Validate the version consistency
- Package the mod
- Create a GitHub release

### Common Issues and Solutions

#### Luacheck Warnings

Common warnings you might see:

- `W211` - Unused local variable
- `W212` - Unused argument  
- `W213` - Unused loop variable
- `W311` - Value assigned to local variable is unused

These are often ignored in Factorio mods due to event handler patterns.

#### Version Mismatch

If the release workflow fails with version mismatch:
1. Check that `info.json` version matches your git tag
2. Ensure the tag format is `v1.2.3` (with 'v' prefix)

#### Missing Required Fields

If validation fails, ensure `info.json` contains:
- `name` - Mod internal name
- `version` - Version string (e.g., "1.2.3")
- `factorio_version` - Compatible Factorio version
- `title` - Display name
- `author` - Author name
- `description` - Mod description

## Factorio-Specific Guidelines

### Global Variables

The linting configuration recognizes these Factorio globals:
- `game`, `script`, `defines`, `prototypes`, `settings`, `storage`
- `commands`, `log`, `remote`, `rendering`, `helpers`
- Standard Lua globals: `string`, `math`, `table`, etc.

### Event Handlers

Event handlers often have unused parameters - this is normal:

```lua
-- This is fine in Factorio mods
local function on_tick(event)  -- 'event' might be unused
    -- handler code
end
```

### File Roles

- `control.lua` - Runtime control logic, event handlers
- `data.lua` - Prototype definitions, recipes, entities
- `settings.lua` - Mod settings definitions
- `prototypes/*.lua` - Additional prototype files

## Testing

While there's no automated game testing (Factorio doesn't provide a headless test environment), the validation workflow checks for:

- Syntax errors
- Common coding issues
- Mod structure compliance
- Version consistency

For manual testing:
1. Package the mod locally
2. Install in Factorio mods directory  
3. Test in-game functionality
4. Check for error logs in Factorio's log files

## Contributing

When contributing:
1. Follow the existing code style
2. Update changelog for significant changes
3. Ensure all validation checks pass
4. Test functionality in-game
5. Update documentation if needed 
