# PixelExperience Plus (Android 11) — gta4l / gta4lwifi

**[Русский](#русский) · [English](#english)** · Готовые сборки / prebuilt: [gta4l-gta4lwifi-roms](https://github.com/dolbaras/gta4l-gta4lwifi-roms)

## Русский

Дерево сборки PixelExperience Plus 11 для Galaxy Tab A7 (SM-T505 / SM-T500). Те же device/vendor/kernel-репо, что и [LineageOS 18.1](https://github.com/dolbaras/gta4l-los18.1) — отличается ветка device-дерева (`eleven-plus`) и base-манифест.

```bash
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests && cp snippets/gta4l.xml .repo/local_manifests/   # впиши свой логин
repo sync -c -j$(nproc)                 # при падении на shallow: --force-sync
bash patches/fix-pe-build.sh            # оффлайн-обходы PE-инфры
source build/envsetup.sh && lunch aosp_gta4l-userdebug
export ALLOW_MISSING_DEPENDENCIES=true && mka bacon
```

**Обходы** (инфра PE частично мертва): в local_manifest добавлен `hardware/samsung` (без него keymaster не собирается → вис на бут); `external/faceunlock` → зеркало `PixelExperienceArchive`; `fix-pe-build.sh` глушит `get_official_devices.py`. Для gta4lwifi — `lunch aosp_gta4lwifi-userdebug`.

Прошивка: OrangeFox → в Mount снять System/Vendor/Product → Install → **Format Data** (первый раз).

## English

PixelExperience Plus 11 build tree for the Galaxy Tab A7 (SM-T505 / SM-T500). Same device/vendor/kernel repos as [LineageOS 18.1](https://github.com/dolbaras/gta4l-los18.1); only the device-tree branch (`eleven-plus`) and base manifest differ.

```bash
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests && cp snippets/gta4l.xml .repo/local_manifests/   # set your GitHub user
repo sync -c -j$(nproc)                 # on shallow-repo failure: --force-sync
bash patches/fix-pe-build.sh            # PE-infra offline workarounds
source build/envsetup.sh && lunch aosp_gta4l-userdebug
export ALLOW_MISSING_DEPENDENCIES=true && mka bacon
```

**Workarounds** (PE infra is partly dead): local_manifest adds `hardware/samsung` (keymaster won't build without it → boot hang); `external/faceunlock` → `PixelExperienceArchive` mirror; `fix-pe-build.sh` stubs `get_official_devices.py`. For gta4lwifi use `lunch aosp_gta4lwifi-userdebug`.

Flash: OrangeFox → uncheck System/Vendor/Product in Mount → Install → **Format Data** (first time).
