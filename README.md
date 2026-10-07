# PixelExperience Plus build — Galaxy Tab A7 10.4 (SM-T505 / SM-T500)

**[Русский](#русский) · [English](#english)** · Готовые сборки / ROMs: [gta4l-gta4lwifi-roms](https://github.com/dolbaras/gta4l-gta4lwifi-roms)

---

## Русский

Всё для сборки PixelExperience Plus 11 (Android 11) для Galaxy Tab A7 10.4: **SM-T505** (LTE, gta4l) и **SM-T500** (Wi-Fi, gta4lwifi). Репозитории устройства те же, что у [LineageOS 18.1](https://github.com/dolbaras/gta4l-los18.1), только деревья устройств берутся из ветки `eleven-plus`.

### Сборка
```bash
git clone https://github.com/dolbaras/gta4l-pe-plus
mkdir pe11 && cd pe11
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests && cp ../gta4l-pe-plus/snippets/gta4l.xml .repo/local_manifests/
repo sync -c -j$(nproc)                  # при ошибке shallow-клона: --force-sync
../gta4l-pe-plus/apply-patches.sh .
bash ../gta4l-pe-plus/patches/fix-pe-build.sh
# камера: см. ниже
source build/envsetup.sh
lunch aosp_gta4l-user                    # SM-T500: aosp_gta4lwifi-user
mka bacon
```
Готовый zip — в `out/target/product/<устройство>/`.

**Камера.** Стоковая GoogleCamera из `vendor/gapps` падает на этом железе (ей нужны функции камеры Pixel). В сборки входит порт **MGC 8.1.101 от BSG** (пакет `com.android.MGC`, версия `8.1.101.345618084`, [celsoazevedo.com](https://www.celsoazevedo.com/files/android/google-camera/)). Перед сборкой положите его вместо `vendor/gapps/product/packages/apps/GoogleCamera/GoogleCamera.apk`; SHA-256 файла из сборок: `7d8db41b7bcaa3e887f08046903bb82617f63e8ccf9a490b1188c7b5f61418df`.

### Инфраструктура PE
Часть серверов PixelExperience больше не работает, поэтому:
- манифест добавляет `hardware/samsung` из LineageOS (без него не собирается keymaster и система не загружается);
- `external/faceunlock` берётся из архива `PixelExperienceArchive`;
- `fix-pe-build.sh` заменяет `get_official_devices.py`, который зависает на недоступном сервере.

### Патчи платформы (`patches/`)
| Патч | Что исправляет |
|---|---|
| `system_vold` | после захода в рекавери Android 12 восстанавливает метки каталогов пользователя (Bluetooth, профили ART) |
| `hardware_qcom-caf_sm8250_media` | кодек записи экрана получает некэшируемые буферы: вдвое меньше нагрузка на процессор |
| `frameworks_base` | запись экрана в разрешении, которое поддерживает кодек; подмена устройства на Pixel 5 не применяется к Play Маркету (он вылетал) и скрывает цепочку аттестации ключей от DroidGuard |
| `system_iorap` | компилятор трасс iorap не копирует таблицу файлов на каждое событие: 134 с → 3 с на трассу |
| `external_perfetto` | трассировка не падает на событии f2fs с полем-массивом |
| `hardware_samsung` | отключены модули только для LineageOS (AdvancedDisplay, SamsungDoze, power HAL): без них дерево PE не собирается, из репозитория нужен только keymaster |
| `vendor_gapps` | приложения и настройки только для Pixel и американских операторов не устанавливаются; GoogleCamera ставится на gta4l/gta4lwifi без AOT-компиляции (порт MGC её не проходит) |

---

## English

Everything to build PixelExperience Plus 11 (Android 11) for the Galaxy Tab A7 10.4: **SM-T505** (LTE, gta4l) and **SM-T500** (Wi-Fi, gta4lwifi). The device repositories are the ones [LineageOS 18.1](https://github.com/dolbaras/gta4l-los18.1) uses; only the device trees come from the `eleven-plus` branch.

### Build
```bash
git clone https://github.com/dolbaras/gta4l-pe-plus
mkdir pe11 && cd pe11
repo init -u https://github.com/PixelExperience/manifest -b eleven-plus --git-lfs
mkdir -p .repo/local_manifests && cp ../gta4l-pe-plus/snippets/gta4l.xml .repo/local_manifests/
repo sync -c -j$(nproc)                  # on a shallow-clone error: --force-sync
../gta4l-pe-plus/apply-patches.sh .
bash ../gta4l-pe-plus/patches/fix-pe-build.sh
# camera: see below
source build/envsetup.sh
lunch aosp_gta4l-user                    # SM-T500: aosp_gta4lwifi-user
mka bacon
```
The zip is in `out/target/product/<device>/`.

**Camera.** The stock GoogleCamera in `vendor/gapps` crashes on this hardware (it needs Pixel camera features). The ROMs ship the **BSG MGC 8.1.101** port (package `com.android.MGC`, version `8.1.101.345618084`, [celsoazevedo.com](https://www.celsoazevedo.com/files/android/google-camera/)). Before building, put it in place of `vendor/gapps/product/packages/apps/GoogleCamera/GoogleCamera.apk`; SHA-256 of the file in the ROMs: `7d8db41b7bcaa3e887f08046903bb82617f63e8ccf9a490b1188c7b5f61418df`.

### PE infrastructure
Some PixelExperience servers are gone, so:
- the manifest adds `hardware/samsung` from LineageOS (without it keymaster does not build and the system does not boot);
- `external/faceunlock` comes from the `PixelExperienceArchive` mirror;
- `fix-pe-build.sh` replaces `get_official_devices.py`, which hangs on the unreachable server.

### Platform patches (`patches/`)
| Patch | Fixes |
|---|---|
| `system_vold` | after a recovery visit, restores the user directory labels Android 12 changed (Bluetooth, ART profiles) |
| `hardware_qcom-caf_sm8250_media` | the screen recording encoder gets uncached buffers: half the CPU load |
| `frameworks_base` | screen recording at a resolution the encoder supports; the Pixel 5 spoof is not applied to the Play Store (it crashed) and hides the key attestation chain from DroidGuard |
| `system_iorap` | the iorap trace compiler no longer copies the file table per event: 134 s → 3 s per trace |
| `external_perfetto` | tracing no longer aborts on an f2fs event with an array field |
| `hardware_samsung` | disables LineageOS-only modules (AdvancedDisplay, SamsungDoze, power HAL) that break the PE build; only keymaster is needed from this repository |
| `vendor_gapps` | apps and settings meant only for Pixel and US carriers are not installed; GoogleCamera is installed on gta4l/gta4lwifi without AOT compilation (the MGC port fails it) |
