#!/bin/bash

export vendor_dlkm_pwd=$(pwd)

# build vendor_dlkm modules
./LKM_Tools/03.prepare_vendor_dlkm.sh \
  ./LKM_Tools/vendor_dlkm/modules_list.txt \
  ../out/msm-kalama-kalama-gki/dist \
  ./LKM_Tools/vendor_dlkm/modules.load \
  ../out/msm-kalama-kalama-gki/dist/System.map \
  ../kernel_platform/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip \
  ./LKM_Tools/vendor_dlkm/vendor_dlkm_modules \
  "" \
  ""

# copy modules
cp ./LKM_Tools/vendor_dlkm/vendor_dlkm_modules/* vendor_dlkm/EXTRACTED_IMAGES/extracted_vendor_dlkm/lib/modules/

# build vendor_dlkm.img
cd vendor_dlkm
sudo ./repack-erofs-script \
  ./EXTRACTED_IMAGES/extracted_vendor_dlkm/ \
  erofs

# copy vendor_dlkm.img
cd ${vendor_dlkm_pwd}
cp ./vendor_dlkm/REPACKED_IMAGES/vendor_dlkm_repacked.img ../gorhanhee/vendor_dlkm.img
