M=$(PWD)
AUDIO_ROOT=$(KERNEL_SRC)/$(M)

KBUILD_OPTIONS+=  AUDIO_ROOT=$(AUDIO_ROOT)

# Include Makefile.include for Samsung specific configurations
$(info "run Makefile.include in audio-kernel for Samsung boards")
include $(AUDIO_ROOT)/Makefile.include

EXTRA_SYMVERS := \
    $(M)../mm-drivers/sync_fence/Module.symvers \
    $(M)../securemsm-kernel/Module.symvers \
    $(M)../mm-drivers/msm_ext_display/Module.symvers \
    $(M)../mm-drivers/hw_fence/Module.symvers \
    $(M)../mmrm-driver/Module.symvers

KBUILD_OPTIONS += KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMVERS)"

all: modules

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean

%:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) $@ $(KBUILD_OPTIONS)

