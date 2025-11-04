#!/bin/bash

# OEM Setting
export ANDROID_BUILD_TOP=$(pwd)
export TARGET_PRODUCT=gki
export TARGET_BOARD_PLATFORM=gki
CHIPSET_NAME=kalama

# Import toolchain
TOOLCHAIN_URL="https://github.com/GoRhanHee/samsung_sm8550_toolchain/releases/download/toolchain/toolchain.tar.xz"
TOOLCHAIN_FILE=$(basename "$TOOLCHAIN_URL")
if [ ! -f "$TOOLCHAIN_FILE" ]; then
    wget -q --show-progress --progress=dot:giga -O "$TOOLCHAIN_FILE" "$TOOLCHAIN_URL"
fi
tar -xf "$TOOLCHAIN_FILE" -C kernel_platform --strip-components=1 toolchain/prebuilts && rm "$TOOLCHAIN_FILE"

cd ${ANDROID_BUILD_TOP}

# GoRhanHee
mkdir gorhanhee
export GORHANHEE=${ANDROID_BUILD_TOP}/gorhanhee

# 4. build vendor_boot & vendor_dlkm
cd vendor_custom
./vendor_boot.sh || exit 1
./vendor_dlkm.sh || exit 1

# 5. Prepare make odin flashable .tar file
cp "${ANDROID_BUILD_TOP}/out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist/boot.img" "${GORHANHEE}/"
cp "${ANDROID_BUILD_TOP}/vendor_custom/recovery.img" "${GORHANHEE}/"

# 6. Make Odin flashable .tar file
cd ${GORHANHEE} 
tar -cvf Galaxy_Fold5_SuSFS.tar boot.img recovery.img vendor_boot.img
