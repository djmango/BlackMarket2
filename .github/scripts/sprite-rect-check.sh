#!/usr/bin/env bash
# Run the mod's real data stage in the headless Factorio engine, then compare every sprite rectangle the engine
# computed against the actual pixel size of the PNG it points at.
#
#   usage: FACTORIO_DIR=/path/to/factorio .github/scripts/sprite-rect-check.sh [mod dir] [gui_scale to test]
#
# Why this exists: the game client refuses a sprite whose width/height rectangle is larger than its PNG
# ("The given sprite rectangle ... is outside the actual sprite size") and crashes at load. The headless
# engine loads no graphics, so it never raises that error, and a mod can pass every other test and still
# crash every client. The headless engine does run data.lua and settings.lua, and --dump-data writes the
# prototypes it computed, so this reads the engine's numbers (not the Lua text) and applies the client's rule.
#
# Exit codes: 0 every rectangle is inside its file, 1 at least one is outside, 77 not examined (no engine),
# 2 the engine itself failed. 77 is never a pass.
set -euo pipefail

MOD="$(cd "${1:-.}" && pwd)"
SCALE="${2:-}"
FX="${FACTORIO_DIR:-}"
if [ -z "$FX" ] || [ ! -x "$FX/bin/x64/factorio" ]; then
  echo "NOT EXAMINED: set FACTORIO_DIR to an unpacked headless Factorio (needs bin/x64/factorio)." >&2
  echo "  curl -fLo f.tar.xz https://factorio.com/get-download/stable/headless/linux64 && tar -xf f.tar.xz" >&2
  exit 77
fi

NAME="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$MOD/info.json")"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/mods" "$WORK/write"
cp -r "$MOD" "$WORK/mods/$NAME"
rm -rf "$WORK/mods/$NAME/.git"
if [ -n "$SCALE" ]; then
  # Run the real data stage at another GUI scale: only the setting's default changes.
  sed -i -E "/name *= *\"BM2-gui_scale\"/,/}/ s/default_value *= *[0-9.]+/default_value = $SCALE/" "$WORK/mods/$NAME/settings.lua"
fi

cat > "$WORK/config.ini" <<EOF
[path]
read-data=$FX/data
write-data=$WORK/write
[other]
check-updates=false
EOF

"$FX/bin/x64/factorio" --config "$WORK/config.ini" --mod-directory "$WORK/mods" --dump-data > "$WORK/engine.log" 2>&1 || {
  echo "the engine failed to load the mod:" >&2; tail -20 "$WORK/engine.log" >&2; exit 2; }
DUMP="$WORK/write/script-output/data-raw-dump.json"
[ -s "$DUMP" ] || { echo "the engine wrote no prototype dump" >&2; tail -10 "$WORK/engine.log" >&2; exit 2; }

python3 - "$DUMP" "$WORK/mods/$NAME" "$NAME" <<'PY'
import json, os, struct, sys

dump, mod, name = sys.argv[1:4]
prefix = f"__{name}__/"
data = json.load(open(dump))


def png_size(path):
    with open(path, "rb") as f:
        head = f.read(24)
    if head[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit(f"not a png: {path}")
    return struct.unpack(">II", head[16:24])


bad, checked = [], 0


def walk(node, trail):
    """Find every table that names one of this mod's PNGs, wherever the engine put it."""
    global checked
    if isinstance(node, dict):
        fn = node.get("filename")
        if isinstance(fn, str) and fn.startswith(prefix):
            real = png_size(os.path.join(mod, fn[len(prefix):]))
            w, h = node.get("width"), node.get("height")
            if w is None or h is None:  # no explicit rectangle: the whole file
                w, h = real
            x, y = node.get("x", 0) or 0, node.get("y", 0) or 0
            checked += 1
            if x + w > real[0] or y + h > real[1]:
                bad.append({
                    "at": "/".join(map(str, trail)), "file": fn[len(prefix):], "rect": [x, y, w, h],
                    "file_px": list(real), "scale": node.get("scale"),
                    "outside_by_px": [max(0, x + w - real[0]), max(0, y + h - real[1])],
                })
        for k, v in node.items():
            walk(v, trail + [k])
    elif isinstance(node, list):
        for i, v in enumerate(node):
            walk(v, trail + [i])


walk(data, [])
if checked == 0:
    print(json.dumps({"verdict": "not examined", "reason": "the engine dump named none of this mod's PNGs"}))
    sys.exit(77)
print(json.dumps({"declarations_checked": checked, "outside_the_file": len(bad), "details": bad}, indent=1))
sys.exit(1 if bad else 0)
PY
