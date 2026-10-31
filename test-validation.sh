#!/bin/bash

# Local test script for GitHub Actions validation
# This mimics the .github/workflows/validate.yml workflow

echo "🧪 Local GitHub Actions Validation Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Check required files
echo "1. Checking required files..."
if [ ! -f "info.json" ]; then
    echo "❌ Missing info.json"
    exit 1
fi
if [ ! -f "control.lua" ]; then
    echo "❌ Missing control.lua"
    exit 1
fi
if [ ! -f "data.lua" ]; then
    echo "❌ Missing data.lua"
    exit 1
fi
echo "✅ Required files present"

# Test 2: Validate info.json
echo ""
echo "2. Validating info.json..."
if ! jq empty info.json 2>/dev/null; then
    echo "❌ info.json is not valid JSON"
    exit 1
fi

# Check required fields
name=$(jq -r '.name // empty' info.json)
version=$(jq -r '.version // empty' info.json)
title=$(jq -r '.title // empty' info.json)
author=$(jq -r '.author // empty' info.json)
factorio_version=$(jq -r '.factorio_version // empty' info.json)

if [ -z "$name" ] || [ -z "$version" ] || [ -z "$title" ] || [ -z "$author" ] || [ -z "$factorio_version" ]; then
    echo "❌ Missing required fields in info.json"
    exit 1
fi

echo "✅ info.json validation passed"
echo "📋 Mod: $name v$version by $author"
echo "📋 Factorio version: $factorio_version"

# Test 3: Run Lua linting
echo ""
echo "3. Running Lua linting..."

# Add LuaRocks bin directory to PATH
export PATH="$HOME/.luarocks/bin:$PATH"

# Check if luacheck is available
if ! command -v luacheck &>/dev/null; then
    echo "⚠️  luacheck not found. Installing..."
    if ! luarocks install --local luacheck; then
        echo "❌ Failed to install luacheck"
        exit 1
    fi
fi

# Run luacheck
if luacheck --config .luacheckrc --formatter=plain -- control.lua data.lua settings.lua utils.lua prototypes/; then
    echo "✅ Lua linting passed"
else
    echo "❌ Lua linting failed"
    exit 1
fi

# Test 4: Check locale structure
echo ""
echo "4. Checking locale structure..."
if [ -d "locale" ]; then
    cfg_files=$(find locale -name "*.cfg" 2>/dev/null | wc -l)
    if [ "$cfg_files" -eq 0 ]; then
        echo "⚠️  No .cfg files found in locale directory"
    else
        echo "✅ Found $cfg_files locale file(s)"
    fi
else
    echo "⚠️  No locale directory found"
fi

# Test 5: Check for common issues
echo ""
echo "5. Checking for common issues..."
debug_prints=$(grep -r "game\.print\|game\.players\[.*\]\.print" . --include="*.lua" 2>/dev/null | wc -l)
if [ "$debug_prints" -gt 0 ]; then
    echo "⚠️  Found $debug_prints potential debug prints"
else
    echo "✅ No debug prints found"
fi

# Test 6: Validate changelog (if present)
echo ""
echo "6. Validating changelog (if present)..."
if [ -f "changelog.txt" ]; then
    if ! grep -q "^Version:" changelog.txt; then
        echo "⚠️  Changelog doesn't follow standard format"
    else
        echo "✅ Changelog format looks good"
    fi
else
    echo "⚠️  No changelog.txt found"
fi

# Test 7: sprite rectangles against the PNGs they point at (the client crashes on a rectangle larger than its file)
echo ""
echo "7. Checking sprite rectangles against their PNG files..."
if [ -n "${FACTORIO_DIR:-}" ]; then
    for scale in "" 0.5 1.0 3.0; do
        if ! .github/scripts/sprite-rect-check.sh . $scale > /tmp/sprite-rect-check.out 2>&1; then
            echo "FAILED at gui_scale ${scale:-default}:"
            cat /tmp/sprite-rect-check.out
            exit 1
        fi
    done
    echo "✅ Every sprite rectangle is inside its PNG (default, 0.5, 1.0, 3.0)"
else
    echo "⚠️  NOT EXAMINED: set FACTORIO_DIR to an unpacked headless Factorio to run this check"
fi

echo ""
echo "🎯 Local Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All validation checks completed successfully!"
echo "🚀 Your mod should pass the GitHub Actions validation!"
