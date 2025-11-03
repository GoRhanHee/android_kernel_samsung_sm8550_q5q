#!/bin/bash

export vendor_boot_pwd=$(pwd)

# build vendor_boot modules
./LKM_Tools/02.prepare_vendor_boot_modules.sh \
  ./LKM_Tools/vendor_boot/modules_list.txt \
  ../out/msm-kalama-kalama-gki/dist \
  ./LKM_Tools/vendor_boot/modules.load \
  ../out/msm-kalama-kalama-gki/dist/System.map \
  ../kernel_platform/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip \
  ./LKM_Tools/vendor_boot/vendor_boot_modules || exit 1

# copy modules
cp ./LKM_Tools/vendor_boot/vendor_boot_modules/* vendor_boot_img/build/unzip_boot/root.1/lib/modules/

# build vendor_boot.img
cd vendor_boot_img
./gradlew pack || exit 1

# copy vendor_boot.img
cd ${vendor_boot_pwd}
cp ./vendor_boot_img/vendor_boot.img.signed ../gorhanhee/vendor_boot.img