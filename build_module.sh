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

#4. build vendor_boot & vendor_dlkm
cd vendor_custom
./vendor_boot.sh || exit 1
./vendor_dlkm.sh || exit 1

#5. Make Odin flashable .tar file
cd ${GORHANHEE} 
tar -cvf Galaxy_Fold5_SuSFS.tar boot.img vendor_boot.img
