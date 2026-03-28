#!/bin/bash

# Import common kernel
git submodule update --init --remote --depth 1 kernel_platform/common

# Import KernelSU-Next
(cd kernel_platform/common && curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -)

# DIR Setting
SCRIPT_DIR="$(dirname $(readlink -fq $0))"

# OEM Setting
BUILD_TARGET=q5q_kor_singlex
export MODEL=$(echo $BUILD_TARGET | cut -d'_' -f1)
export PROJECT_NAME=${MODEL}
export REGION=$(echo $BUILD_TARGET | cut -d'_' -f2)
export CARRIER=$(echo $BUILD_TARGET | cut -d'_' -f3)
export TARGET_BUILD_VARIANT=user
			
CHIPSET_NAME=kalama

export ANDROID_BUILD_TOP=$(pwd)
export TARGET_PRODUCT=gki
export TARGET_BOARD_PLATFORM=gki

export ANDROID_PRODUCT_OUT=${ANDROID_BUILD_TOP}/out/target/product/${MODEL}
export OUT_DIR=${ANDROID_BUILD_TOP}/out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}
export DIST_DIR=${ANDROID_BUILD_TOP}/out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist
export MERGE_CONFIG="${ANDROID_BUILD_TOP}/kernel_platform/common/scripts/kconfig/merge_config.sh"

mkdir -p "${ANDROID_BUILD_TOP}/out/msm-${CHIPSET_NAME}-${CHIPSET_NAME}-${TARGET_PRODUCT}/dist"

export KBUILD_EXTRA_SYMBOLS="${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/mmrm-driver/Module.symvers \
		${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/mm-drivers/hw_fence/Module.symvers \
		${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/mm-drivers/sync_fence/Module.symvers \
		${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/mm-drivers/msm_ext_display/Module.symvers \
		${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/securemsm-kernel/Module.symvers \
"
export MODNAME=audio_dlkm

export KBUILD_EXT_MODULES="../vendor/qcom/opensource/mm-drivers/msm_ext_display \
  ../vendor/qcom/opensource/mm-drivers/sync_fence \
  ../vendor/qcom/opensource/mm-drivers/hw_fence \
  ../vendor/qcom/opensource/mmrm-driver \
  ../vendor/qcom/opensource/securemsm-kernel \
  ../vendor/qcom/opensource/display-drivers/msm \
  ../vendor/qcom/opensource/audio-kernel \
  ../vendor/qcom/opensource/camera-kernel \
  "

# Build Setting
export GKI_KERNEL_BUILD_OPTIONS="
    SKIP_MRPROPER=1 \
    LTO=thin \
    HERMETIC_TOOLCHAIN=0 \
    KMI_SYMBOL_LIST_STRICT_MODE=0 \
    RECOMPILE_KERNEL=1 \
    ABI_DEFINITION= \
    BUILD_BOOT_IMG=1 \
    SKIP_VENDOR_BOOT=1 \
    MKBOOTIMG_PATH=${ANDROID_BUILD_TOP}/kernel_platform/tools/mkbootimg/mkbootimg.py \
    KERNEL_BINARY=Image \
    BOOT_IMAGE_HEADER_VERSION=4 \
    AVB_SIGN_BOOT_IMG=1 \
    AVB_BOOT_PARTITION_SIZE=100663296 \
    AVB_BOOT_KEY=${ANDROID_BUILD_TOP}/kernel_platform/tools/mkbootimg/gki/testdata/testkey_rsa4096.pem \
    AVB_BOOT_ALGORITHM=SHA256_RSA4096 \
    AVB_BOOT_PARTITION_NAME=boot  
"

# MKBOOTIMG Setting
export MKBOOTIMG_EXTRA_ARGS="
    --os_version 13.0.0 \
    --os_patch_level 2026-04-05 \
    --pagesize 4096 \
"

# Import Samsung toolchain
TOOLCHAIN_URL="https://github.com/GoRhanHee/samsung_sm8550_toolchain/releases/download/toolchain/toolchain.tar.xz"
TOOLCHAIN_FILE=$(basename "$TOOLCHAIN_URL")
if [ ! -f "$TOOLCHAIN_FILE" ]; then
    wget -q --show-progress --progress=dot:giga -O "$TOOLCHAIN_FILE" "$TOOLCHAIN_URL"
fi
tar -xf "$TOOLCHAIN_FILE" -C kernel_platform --strip-components=1 toolchain/prebuilts && rm "$TOOLCHAIN_FILE"

# Cooking Kernel Soruce & boot.img
( env ${GKI_KERNEL_BUILD_OPTIONS} ${ANDROID_BUILD_TOP}/kernel_platform/build/android/prepare_vendor.sh sec ${TARGET_PRODUCT} || exit 1)