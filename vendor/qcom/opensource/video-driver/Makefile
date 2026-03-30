# SPDX-License-Identifier: GPL-2.0-only

VIDEO_ROOT = $(KERNEL_SRC)/$(M)
KBUILD_OPTIONS+= VIDEO_ROOT=$(VIDEO_ROOT)

VIDEO_COMPILE_TIME = $(shell date)
VIDEO_COMPILE_BY = $(shell whoami | sed 's/\\/\\\\/')
VIDEO_COMPILE_HOST = $(shell uname -n)
VIDEO_GEN_PATH = $(VIDEO_ROOT)/driver/vidc/inc/video_generated_h

EXTRA_SYMVERS := \
    $(M)../mm-drivers/sync_fence/Module.symvers \
    $(M)../securemsm-kernel/Module.symvers \
    $(M)../mm-drivers/msm_ext_display/Module.symvers \
    $(M)../mm-drivers/hw_fence/Module.symvers \
    $(M)../mmrm-driver/Module.symvers

KBUILD_OPTIONS += KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMVERS)"

all: modules

$(VIDEO_GEN_PATH): $(shell find . -type f \( -iname \*.c -o -iname \*.h -o -iname \*.mk \))
	echo '#define VIDEO_COMPILE_TIME "$(VIDEO_COMPILE_TIME)"' > $(VIDEO_GEN_PATH)
	echo '#define VIDEO_COMPILE_BY "$(VIDEO_COMPILE_BY)"' >> $(VIDEO_GEN_PATH)
	echo '#define VIDEO_COMPILE_HOST "$(VIDEO_COMPILE_HOST)"' >> $(VIDEO_GEN_PATH)

modules: $(VIDEO_GEN_PATH)
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(M) modules_install

%:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) $@ $(KBUILD_OPTIONS)

clean:
	rm -f *.o *.ko *.mod.c *.mod.o *~ .*.cmd Module.symvers
	rm -rf .tmp_versions
