#!/bin/bash

# core variables
REPO_ROOT=${ANDROID_BUILD_TOP}
LKM_TOOLS_DIR=${ANDROID_BUILD_TOP}/prebuilts/LKM_Tools
KBUILD_PATH=${MODULE_DIR}/lib/modules
PKG_VENDOR_BOOT=${LKM_TOOLS_DIR}/02.prepare_vendor_boot_modules.sh
BOOT_EDITOR_DIR=${ANDROID_BUILD_TOP}/prebuilts/vendor_boot

# input variables for LKM_Tools
STAGING_DIR="${KBUILD_PATH}"
SYSTEM_MAP="${KBUILD_PATH}/System.map"
STRIP_TOOL="${ANDROID_BUILD_TOP}/toolchain/clang/host/linux-x86/clang-r383902/bin/llvm-strip"
MODULES_LIST="${LKM_TOOLS_DIR}/vendor_boot/modules_list.txt"
OEM_LOAD_FILE="${LKM_TOOLS_DIR}/vendor_boot/modules.load"
OUTPUT_DIR="${BOOT_EDITOR_DIR}/build/unzip_boot/root/lib/modules"

# 01. run LKM_Tools
# Documentation: ./02.prepare_vendor_boot_modules.sh <modules_list> <staging_dir> <oem_load_file> <system_map> <strip_tool> <output_dir>
package_modules() {
    mkdir -p "${OUTPUT_DIR}" && \
        "${PKG_VENDOR_BOOT}" \
            "${MODULES_LIST}" \
            "${STAGING_DIR}" \
            "${OEM_LOAD_FILE}" \
            "${SYSTEM_MAP}" \
            "${STRIP_TOOL}" \
            "${OUTPUT_DIR}"
}

# 02. build the vendor boot
build_vendor_boot() {
    cd "${BOOT_EDITOR_DIR}" && \
        ./gradlew pack && \
        mv vendor_boot.img.signed "${REPO_ROOT}/prebuilts/vendor_boot.img" && \
        cd "${REPO_ROOT}"
}

# main execution
{ package_modules && \
    build_vendor_boot
} || {
    echo "Error: Failed to build the vendor boot"
    exit 1
}
