# Shared kernel configuration helpers for AryaLinux.
# Sourced from kernel.sh (chroot build) and configure-kernel.sh (host tuning).

kernel_configure_from_host() {
	# Derive a starting .config from the running host kernel, not from a
	# checked-in file or a copy of /boot/config-*.
	if [ -r /proc/config.gz ]; then
		zcat /proc/config.gz > .config
		make olddefconfig
		yes "" | make localmodconfig
	else
		echo "Note: /proc/config.gz unavailable on the build host."
		echo "      Using defconfig plus localyesconfig (loaded modules from lsmod)."
		echo "      For closer host parity, enable CONFIG_IKCONFIG_PROC on the host kernel."
		make defconfig
		yes "" | make localyesconfig
	fi

	make olddefconfig
}

kernel_apply_lfs_requirements() {
	if [ ! -x scripts/config ]; then
		echo "scripts/config not found in kernel tree" >&2
		return 1
	fi

	scripts/config \
		-d CONFIG_WERROR \
		-e CONFIG_PSI \
		-d CONFIG_PSI_DEFAULT_DISABLED \
		-d CONFIG_IKHEADERS \
		-e CONFIG_CGROUPS \
		-e CONFIG_MEMCG \
		-d CONFIG_RT_GROUP_SCHED \
		-d CONFIG_EXPERT \
		-e CONFIG_RELOCATABLE \
		-e CONFIG_RANDOMIZE_BASE \
		-e CONFIG_STACKPROTECTOR \
		-e CONFIG_STACKPROTECTOR_STRONG \
		-e CONFIG_NET \
		-e CONFIG_INET \
		-e CONFIG_IPV6 \
		-d CONFIG_UEVENT_HELPER \
		-e CONFIG_DEVTMPFS \
		-e CONFIG_DEVTMPFS_MOUNT \
		-m CONFIG_FW_LOADER \
		-d CONFIG_FW_LOADER_USER_HELPER \
		-e CONFIG_DMIID \
		-e CONFIG_SYSFB_SIMPLEFB \
		-e CONFIG_DRM \
		-e CONFIG_DRM_PANIC \
		-e CONFIG_DRM_FBDEV_EMULATION \
		-e CONFIG_DRM_SIMPLEDRM \
		-e CONFIG_FRAMEBUFFER_CONSOLE \
		-e CONFIG_INOTIFY_USER \
		-e CONFIG_TMPFS \
		-e CONFIG_TMPFS_POSIX_ACL \
		-e CONFIG_TMPFS_XATTR \
		-d CONFIG_SYSFS_DEPRECATED \
		-d CONFIG_SYSFS_DEPRECATED_V2 \
		-d CONFIG_AUDIT \
		-e CONFIG_SECCOMP \
		-e CONFIG_FHANDLE \
		--set-str CONFIG_DRM_PANIC_SCREEN kmsg

	if [ "$(uname -m)" = "x86_64" ]; then
		scripts/config \
			-e CONFIG_X86_X2APIC \
			-e CONFIG_PCI \
			-e CONFIG_PCI_MSI \
			-e CONFIG_IOMMU_SUPPORT \
			-e CONFIG_IRQ_REMAP
	else
		scripts/config \
			-d CONFIG_64BIT \
			-e CONFIG_HIGHMEM4G
	fi

	if ls /dev/nvme* >/dev/null 2>&1; then
		scripts/config -e CONFIG_BLK_DEV_NVME
	fi

	make olddefconfig
}

kernel_apply_aryalinux_requirements() {
	scripts/config \
		-e CONFIG_EFI_PARTITION \
		-e CONFIG_EFI \
		-e CONFIG_EFI_MIXED \
		-e CONFIG_EFI_STUB \
		-e CONFIG_FB_EFI \
		-e CONFIG_FRAMEBUFFER_CONSOLE \
		-d CONFIG_EFI_VARS \
		-e CONFIG_EFIVAR_FS \
		-d CONFIG_UEFI_CPER \
		-d CONFIG_EARLY_PRINTK_EFI \
		-d CONFIG_DEBUG_KERNEL \
		-d CONFIG_DEBUG_FS \
		-d CONFIG_X86_VERBOSE_BOOTUP \
		-d CONFIG_FTRACE \
		-d CONFIG_STACKTRACE \
		-e CONFIG_NTFS_FS \
		-d CONFIG_NTFS_DEBUG \
		-e CONFIG_NTFS_RW \
		-e CONFIG_SND_HDA_INTEL \
		-e CONFIG_SND_HDA_CODEC_REALTEK \
		-e CONFIG_SND_HDA_GENERIC \
		-e CONFIG_SND_HDA_CODEC_ANALOG \
		-e CONFIG_SND_HDA_CODEC_SIGMATEL \
		-e CONFIG_SND_HDA_CODEC_VIA \
		-e CONFIG_SND_HDA_CODEC_HDMI \
		-e CONFIG_SND_HDA_CODEC_CIRRUS \
		-e CONFIG_SND_HDA_CODEC_CONEXANT \
		-e CONFIG_SND_HDA_CODEC_CA0110 \
		-e CONFIG_SND_HDA_CODEC_CA0132 \
		-e CONFIG_SND_HDA_CODEC_CMEDIA \
		-e CONFIG_SND_HDA_CODEC_SI3054 \
		-e CONFIG_SND_HDA_CODEC_CA0132_DSP \
		-e CONFIG_SND_HDA_PATCH_LOADER \
		-e CONFIG_SND_HDA_RECONFIG \
		-e CONFIG_SQUASHFS \
		-e CONFIG_SQUASHFS_FILE_CACHE \
		-e CONFIG_SQUASHFS_DECOMP_SINGLE \
		-e CONFIG_SQUASHFS_ZLIB \
		-e CONFIG_SQUASHFS_XZ \
		-e CONFIG_SQUASHFS_FILE_DIRECT \
		-e CONFIG_SQUASHFS_DECOMP_MULTI \
		-e CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU \
		-e CONFIG_SQUASHFS_XATTR \
		-e CONFIG_SQUASHFS_LZ4 \
		-e CONFIG_SQUASHFS_LZO \
		-e CONFIG_SQUASHFS_4K_DEVBLK_SIZE \
		-e CONFIG_SQUASHFS_EMBEDDED \
		-e CONFIG_ISO9660_FS \
		-e CONFIG_AUFS_BR_HFSPLUS \
		-d CONFIG_AUFS_BR_FUSE \
		-d CONFIG_KMEMCHECK \
		-e CONFIG_BLK_DEV_LOOP \
		-e CONFIG_BLK_DEV_CRYPTOLOOP \
		-e CONFIG_USB_OTG_FSM \
		-e CONFIG_USB_XHCI_HCD \
		-e CONFIG_USB_XHCI_PLATFORM \
		-e CONFIG_USB_EHCI_HCD \
		-e CONFIG_USB_EHCI_HCD_PLATFORM \
		-e CONFIG_USB_OHCI_HCD \
		-e CONFIG_USB_OHCI_HCD_PCI \
		-e CONFIG_USB_OHCI_HCD_PLATFORM \
		-e CONFIG_USB_UHCI_HCD \
		-e CONFIG_USB_STORAGE \
		-d CONFIG_CHARGER_ISP1704 \
		--set-val CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE 3 \
		--set-val CONFIG_MESSAGE_LOGLEVEL_DEFAULT 7

	make olddefconfig
}
