#!/bin/bash

export vendor_boot_pwd=$(pwd)

# build vendor_boot modules
./LKM_Tools/02.prepare_vendor_boot_modules.sh \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_boot/modules_list.txt \
  $GITHUB_WORKSPACE/out/msm-kalama-kalama-gki/dist \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_boot/modules.load \
  $GITHUB_WORKSPACE/out/msm-kalama-kalama-gki/dist/System.map \
  $GITHUB_WORKSPACE/kernel_platform/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_boot/vendor_boot_modules || exit 1

# copy modules
cp $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_boot/vendor_boot_modules/* $GITHUB_WORKSPACE/vendor_custom/vendor_boot_img/build/unzip_boot/root.1/lib/modules/

# build vendor_boot.img
cd vendor_boot_img
./gradlew pack || exit 1

# copy vendor_boot.img
cd ${vendor_boot_pwd}
cp $GITHUB_WORKSPACE/vendor_custom/vendor_boot_img/vendor_boot.img.signed $GITHUB_WORKSPACE/gorhanhee/vendor_boot.img