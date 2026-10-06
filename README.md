# PixelExperience Plus (Android 11) — gta4l (SM-T505)

**[Русский](#русский) · [English](#english)**

---

## Русский

Готовое дерево для сборки PixelExperience Plus (Android 11) на Galaxy Tab A7 LTE. Использует те же device/vendor/kernel-репозитории, что и сборка LineageOS 18.1 ([gta4l-los18.1](https://github.com/dolbaras/gta4l-los18.1)) — отличается только ветка device-дерева (`eleven-plus`) и base-манифест.

### Сборка
```bash
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests
cp snippets/gta4l.xml .repo/local_manifests/     # замени YOURUSER на свой логин
repo sync -c -j$(nproc)
bash patches/fix-pe-build.sh                      # оффлайн-обходы (см. ниже)
for f in patches/*.patch; do d=$(basename $f .patch | tr _ /); git -C $d apply "$PWD/$f"; done   # платформенные правки / platform patches
source build/envsetup.sh
lunch aosp_gta4l-userdebug
mka bacon
```
Готовый zip — в `out/target/product/gta4l/`.

### Почему нужны обходы
Инфраструктура PixelExperience частично недоступна, поэтому:
- **`hardware/samsung`** добавлен в local_manifest (в манифесте PE его нет, а samsung-keymaster без него не собирается → устройство виснет на загрузке).
- **`external/faceunlock`** перенаправлен на архив `PixelExperienceArchive` (оригинал на мёртвом gitlab PE, но `frameworks/base` от него зависит).
- **`patches/fix-pe-build.sh`** глушит `get_official_devices.py` (лез на мёртвый сервер PE без таймаута).
- Если `repo sync` падает на shallow-репо (cts/exoplayer): `repo sync --force-sync -c -j$(nproc)`.

### Прошивка
Через OrangeFox/TWRP: `Install` → выбрать zip → свайп. На первую установку — `Format Data`. Перезагрузка в систему из рекавери — именно `Reboot → System` (после этой прошивки простой reboot из adb может уводить обратно в рекавери).

### Репозитории
Общие с LineageOS-сборкой (ветка `lineage-18.1`), device-дерево на ветке `eleven-plus`. Подробности — в [gta4l-los18.1](https://github.com/dolbaras/gta4l-los18.1).

### Готовые сборки
[github.com/dolbaras/gta4l-roms](https://github.com/dolbaras/gta4l-roms)

---

## English

Ready-to-build tree for PixelExperience Plus (Android 11) on the Galaxy Tab A7 LTE. It reuses the same device/vendor/kernel repos as the LineageOS 18.1 build ([gta4l-los18.1](https://github.com/dolbaras/gta4l-los18.1)) — only the device-tree branch (`eleven-plus`) and the base manifest differ.

### Build
```bash
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests
cp snippets/gta4l.xml .repo/local_manifests/     # set your GitHub user instead of YOURUSER
repo sync -c -j$(nproc)
bash patches/fix-pe-build.sh                      # offline workarounds (see below)
for f in patches/*.patch; do d=$(basename $f .patch | tr _ /); git -C $d apply "$PWD/$f"; done   # платформенные правки / platform patches
source build/envsetup.sh
lunch aosp_gta4l-userdebug
mka bacon
```
Output zip in `out/target/product/gta4l/`.

### Why the workarounds
PixelExperience infra is partly offline, so:
- **`hardware/samsung`** is added via the local_manifest (missing from PE's manifest; the samsung keymaster won't build without it → the device hangs on boot).
- **`external/faceunlock`** is redirected to the `PixelExperienceArchive` (the original is on the dead PE gitlab, but `frameworks/base` depends on it).
- **`patches/fix-pe-build.sh`** stubs `get_official_devices.py` (it hung on the dead PE server with no timeout).
- If `repo sync` fails on shallow repos (cts/exoplayer): `repo sync --force-sync -c -j$(nproc)`.

### Flashing
Via OrangeFox/TWRP: `Install` → pick the zip → swipe. `Format Data` on first install. To boot the system from recovery use `Reboot → System` (after this ROM a plain `adb reboot` may return to recovery).

### Repos
Shared with the LineageOS build (branch `lineage-18.1`), device tree on the `eleven-plus` branch. Details in [gta4l-los18.1](https://github.com/dolbaras/gta4l-los18.1).

### Prebuilt ROMs
[github.com/dolbaras/gta4l-roms](https://github.com/dolbaras/gta4l-roms)
