# Shared kernel configuration helpers for AryaLinux.
# Sourced from kernel.sh (chroot build) and configure-kernel.sh (host tuning).
#
# Generic amd64 configs live in kernel-configs/ (see parser/
# aryalinux-script-generator/upgrade-kernel-config.py). Build uses the checked-in file for the kernel
# version in wget-list, then re-applies LFS/AryaLinux fragments for safety.

kernel_configs_dir() {
	echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-configs"
}

kernel_version_from_tarball() {
	local tarball=$1
	echo "$tarball" | sed -n 's/.*linux-\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p'
}

kernel_configure_from_distro() {
	local configs dir version cfg tarball

	configs=$(kernel_configs_dir)
	tarball=${LINUX_TARBALL:-}
	version=${KERNEL_VERSION:-}

	if [ -z "$version" ] && [ -n "$tarball" ]; then
		version=$(kernel_version_from_tarball "$tarball")
	fi
	if [ -z "$version" ]; then
		version=$(make -s kernelversion 2>/dev/null || true)
	fi

	cfg="$configs/linux-${version}-amd64.config"
	if [ ! -f "$cfg" ] && [ -L "$configs/current-amd64.config" ]; then
		cfg=$(readlink -f "$configs/current-amd64.config")
	fi
	if [ ! -f "$cfg" ]; then
		echo "No generic amd64 kernel config for linux-${version}." >&2
		echo "Run: python3 ../parser/aryalinux-script-generator/upgrade-kernel-config.py" >&2
		return 1
	fi

	echo "Using generic amd64 kernel config: $cfg"
	cp -v "$cfg" .config
	make olddefconfig
}

kernel_configure_from_host() {
	# Fallback when no checked-in distro config exists (developer machines).
	if [ -r /proc/config.gz ]; then
		zcat /proc/config.gz > .config
		make olddefconfig
	else
		echo "Note: /proc/config.gz unavailable; using x86_64_defconfig." >&2
		make x86_64_defconfig
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
		--set-str CONFIG_DRM_PANIC_SCREEN kmsg \
		-e CONFIG_X86_X2APIC \
		-e CONFIG_PCI \
		-e CONFIG_PCI_MSI \
		-e CONFIG_IOMMU_SUPPORT \
		-e CONFIG_IRQ_REMAP

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
		-e CONFIG_BLK_DEV_NVME \
		--set-val CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE 3 \
		--set-val CONFIG_MESSAGE_LOGLEVEL_DEFAULT 7

	make olddefconfig
}

kernel_configure_aryalinux() {
	if ! kernel_configure_from_distro; then
		echo "Falling back to host-derived kernel config." >&2
		kernel_configure_from_host
	fi
	kernel_apply_lfs_requirements
	kernel_apply_aryalinux_requirements
}
