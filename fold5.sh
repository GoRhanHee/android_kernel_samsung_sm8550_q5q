#!/bin/bash

# Setting Color Font
source "./env.sh"

# OEM Setting
export ANDROID_BUILD_TOP=$(pwd)
export TARGET_PRODUCT=gki
export TARGET_BOARD_PLATFORM=gki
CHIPSET_NAME=kalama

# Introduce Scripts
info "================================================"
info " "
info "          Galaxy Z Fold5 Kernel Builder"
info " "
info "================================================"
info "           Import Compiling Script..."
info "================================================"

# Import Compiling Script
./build.sh || exit 1

# Success Compiling
info "================================================"
info "               Success Compiling"
info "================================================"

# Download fastbootD patched recovery
RECOVERY_URL="https://github.com/GoRhanHee/android_kernel_samsung_sm8550_q5q/releases/download/fastbootD/recovery.img"
RECOVERY_FILE=$(basename "$RECOVERY_URL")
info "      Downloading FastbootD Patched Recovery"
if [ ! -f "$RECOVERY_FILE" ]; then
    wget -q --show-progress --progress=dot:giga -O "$RECOVERY_FILE" "$RECOVERY_URL"
fi
info "       Complete Download Patched Recovery"
info "================================================"

# Cooking Flashable File
set -x
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/boot.img ./
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/boot-gz.img ./
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/boot-lz4.img ./
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/Image ./
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/Image.gz ./
cp ./out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/Image.lz4 ./
tar -cvf Galaxy_Fold5_KSUN_ODIN.tar boot.img vendor_boot.img recovery.img

zip Galaxy_Fold5_KSUN.zip Galaxy_Fold5_KSUN_ODIN.tar vendor_dlkm.img
set +x

info "        Complete Cooked Flashable File"
info "================================================"
info "             Thank you -@GoRhanHee"
info "================================================"