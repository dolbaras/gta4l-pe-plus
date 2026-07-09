#!/bin/bash
# Обходы для оффлайн-сборки PixelExperience Plus A11 (инфраструктура PE частично мертва).
# Workarounds for building PixelExperience Plus A11 offline (PE infra is partly dead).
# Запускать из корня дерева ПОСЛЕ repo sync. / Run from the tree root AFTER repo sync.
set -e
ROOT="$(pwd)"

# 1) get_official_devices.py лезет на мёртвый сервер PE без таймаута -> висит вечно.
#    gta4l unofficial, правильный ответ = пусто. / hangs forever on the dead PE server; stub it.
F="$ROOT/vendor/aosp/tools/get_official_devices.py"
if [ -f "$F" ] && ! grep -q 'offline' "$F"; then
  [ -f "$F.orig" ] || cp "$F" "$F.orig"
  cat > "$F" <<'EOF'
# offline stub: original hung on the dead PixelExperience official_devices server.
# gta4l is unofficial, so the correct answer is empty.
print("")
EOF
  echo "[ok] stubbed get_official_devices.py"
fi

echo "[done] Теперь: source build/envsetup.sh && lunch aosp_gta4l-userdebug && export ALLOW_MISSING_DEPENDENCIES=true && mka bacon"
