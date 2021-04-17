# target: rpi3b
# ref: https://www.raspberrypi.org/documentation/configuration/boot_folder.md
# ref: https://www.raspberrypi.org/documentation/configuration/config-txt/README.md
# ref: https://www.raspberrypi.org/documentation/configuration/device-tree.md

ARCH ?= arm64
CROSS_COMPILE ?= aarch64-rpi3-linux-gnu-

DEFCONFIG := bcmrpi3_defconfig
DTB := bcm2837-rpi-3-b.dtb

KFW := linux/arch/$(ARCH)/boot
FW := firmware/boot
FWO := overlay/boot

kernel: | overlay/boot
	rm -f linux/.config
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)\
		$(DEFCONFIG)
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		INSTALL_MOD_PATH=../overlay \
		INSTALL_MOD_STRIP=1 \
		modules_install
	cp $(KFW)/dts/broadcom/bcm2837-rpi-3-b.dtb $(FWO)/
	cp $(KFW)/Image $(FWO)/kernel8.img

menuconfig:
	rm -f linux/.config
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(DEFCONFIG)
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(MAKE) -C linux ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) savedefconfig
	cp linux/defconfig linux/arch/$(ARCH)/configs/$(DEFCONFIG)

firmware: | overlay/boot
	cp $(FW)/bootcode.bin $(FWO)/
	cp $(FW)/start_cd.elf $(FWO)/
	cp $(FW)/fixup_cd.dat $(FWO)/
	cp config.txt $(FWO)/
	cp cmdline.txt $(FWO)/

overlay:
	mkdir overlay

overlay/boot: | overlay
	mkdir overlay/boot

.PHONY: firmware kernel menuconfig
