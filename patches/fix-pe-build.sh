#!/bin/bash
# Works around PixelExperience infrastructure that is gone. Run from the source tree root
# after repo sync.
set -e
ROOT="$(pwd)"

# get_official_devices.py queries the defunct PixelExperience official devices server with
# no timeout and hangs the build. The device is unofficial, so the right answer is empty.
F="$ROOT/vendor/aosp/tools/get_official_devices.py"
if [ -f "$F" ] && ! grep -q 'offline' "$F"; then
  cat > "$F" <<'EOF'
# offline stub: the PixelExperience official devices server is gone, and the device is
# unofficial, so the list is empty.
print("")
EOF
  echo "[ok] stubbed get_official_devices.py"
fi

echo "[done] source build/envsetup.sh && lunch aosp_gta4l-user && mka bacon"
