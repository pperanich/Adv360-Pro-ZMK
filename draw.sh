#!/bin/bash

set -e

echo "Drawing Adv360 Pro Keymap"
echo "========================="

# Check if uv is available and use it, otherwise fall back to system keymap
if command -v uv &>/dev/null; then
  KEYMAP_CMD="uv run keymap"
  echo "Using keymap-drawer via uv"
elif command -v keymap &>/dev/null; then
  KEYMAP_CMD="keymap"
  echo "Using system keymap-drawer"
else
  echo "Error: 'keymap-drawer' is not found. Please install with: uv sync"
  echo "   Or install manually with: pip install keymap-drawer"
  exit 1
fi

# Clean up existing keymap files
echo "Cleaning up old keymap files..."
rm -f ./adv360_keymap*

# Parse the keymap
echo "Parsing keymap..."
$KEYMAP_CMD -c keymap_drawer.config.yaml parse -z config/adv360.keymap -c 10 >adv360_keymap.yaml

# Draw the keymap using QMK layout from info.json
echo "Drawing keymap SVG..."
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json >adv360_keymap.svg

# Draw individual layers for reference
echo "Drawing individual layers..."
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json --select-layers BASE >adv360_keymap_base.svg
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json --select-layers EXT >adv360_keymap_ext.svg
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json --select-layers SYM >adv360_keymap_sym.svg
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json --select-layers MOD >adv360_keymap_mod.svg
$KEYMAP_CMD -c keymap_drawer.config.yaml draw adv360_keymap.yaml -j config/info.json --select-layers GAME >adv360_keymap_game.svg

echo "Keymap drawing complete!"
echo ""
echo "Generated files:"
echo "   All layers:     adv360_keymap.svg"
echo "   Base layer:     adv360_keymap_base.svg"
echo "   Ext layer:      adv360_keymap_ext.svg"
echo "   Sym layer:      adv360_keymap_sym.svg"
echo "   Mod layer:      adv360_keymap_mod.svg"
echo "   Game layer:     adv360_keymap_game.svg"
echo "   Parsed config:  adv360_keymap.yaml"
