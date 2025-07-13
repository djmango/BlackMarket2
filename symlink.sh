#!/bin/bash

# Get the current version from info.json
VERSION=$(jq -r '.version' info.json)
FACTORIO_MODS_DIR="$HOME/Library/Application Support/factorio/mods"
MOD_NAME="BlackMarket2"

echo "Setting up development symlink for $MOD_NAME v$VERSION"

# Remove any existing zip files for this mod
echo "Removing existing zip files..."
rm -f "$FACTORIO_MODS_DIR/${MOD_NAME}_"*.zip

# Remove any existing symlinks
echo "Removing existing symlinks..."
rm -f "$FACTORIO_MODS_DIR/${MOD_NAME}_"*

# Create the symlink with the current version
SYMLINK_NAME="${MOD_NAME}_${VERSION}"
SYMLINK_PATH="$FACTORIO_MODS_DIR/$SYMLINK_NAME"

echo "Creating symlink: $SYMLINK_PATH -> $(pwd)"
ln -sf "$(pwd)" "$SYMLINK_PATH"

# Verify the symlink was created
if [ -L "$SYMLINK_PATH" ]; then
    echo "✅ Symlink created successfully!"
    echo "🎯 You can now test your mod in Factorio"
    echo "📁 Symlink: $SYMLINK_PATH"
    echo "🔗 Points to: $(readlink "$SYMLINK_PATH")"
else
    echo "❌ Failed to create symlink"
    exit 1
fi
