#!/bin/bash

export vendor_dlkm_pwd=$(pwd)

# build vendor_dlkm modules
./LKM_Tools/03.prepare_vendor_dlkm.sh \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_dlkm/modules_list.txt \
  $GITHUB_WORKSPACE/out/msm-kalama-kalama-gki/dist \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_dlkm/modules.load \
  $GITHUB_WORKSPACE/out/msm-kalama-kalama-gki/dist/System.map \
  $GITHUB_WORKSPACE/kernel_platform/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip \
  $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_dlkm/vendor_dlkm_modules \
  "" \
  ""

# copy modules
cp $GITHUB_WORKSPACE/vendor_custom/LKM_Tools/vendor_dlkm/vendor_dlkm_modules/* $GITHUB_WORKSPACE/vendor_custom/vendor_dlkm/EXTRACTED_IMAGES/extracted_vendor_dlkm/lib/modules/

# build vendor_dlkm.img
cd vendor_dlkm
sudo ./repack-erofs-script \
  $GITHUB_WORKSPACE/vendor_dlkm/EXTRACTED_IMAGES/extracted_vendor_dlkm/ \
  erofs

# copy vendor_dlkm.img
cd ${vendor_dlkm_pwd}
cp $GITHUB_WORKSPACE/vendor_custom/vendor_dlkm/REPACKED_IMAGES/vendor_dlkm_repacked.img $GITHUB_WORKSPACE/gorhanhee/vendor_dlkm.img
