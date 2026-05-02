#!/bin/bash
# Full end-to-end test: boots a fresh Arch Linux VM in QEMU, lets you run
# archinstall and then arch.sh against a true clean system. Slow (~20-30 min
# total) but verifies every assumption — bootloader, NetworkManager, audio,
# Hyprland startup, the lot.
#
# Workflow:
#   1. Run this script. It will:
#      - download the latest Arch ISO into ./test/cache/ (~1 GB, cached)
#      - download UEFI firmware into ./test/cache/ if absent
#      - create a fresh 30 GB qcow2 disk
#      - boot QEMU with KVM acceleration and the ISO mounted
#   2. Inside the VM, do a minimal archinstall:
#         archinstall --config ... or interactive
#      Recommended: minimal profile, GRUB, NetworkManager
#   3. Reboot the VM (poweroff and re-run this script with --boot-disk)
#   4. Login, then:
#         git clone <your dotfiles> ~/Projects/dotfiles
#         cd ~/Projects/dotfiles && ./arch.sh
#   5. Confirm SDDM, Hyprland, kitty all come up.
#
# Requirements: qemu-full edk2-ovmf, KVM available (/dev/kvm).

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE="$DOTFILES/test/cache"
DISK="$CACHE/arch-test.qcow2"
ISO="$CACHE/archlinux-latest.iso"
OVMF_CODE="$CACHE/OVMF_CODE.fd"
OVMF_VARS="$CACHE/OVMF_VARS.fd"

DISK_SIZE_GB=30
RAM_MB=4096
CORES=4

mkdir -p "$CACHE"

# ---------- Sanity ----------
need() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Missing: $1"
        echo "  install with: sudo pacman -S --needed qemu-full edk2-ovmf"
        exit 1
    }
}
need qemu-system-x86_64
need qemu-img
need curl

if [ ! -e /dev/kvm ]; then
    echo "WARNING: /dev/kvm not present — VM will be 5-10x slower."
    KVM_ARGS=""
else
    KVM_ARGS="-enable-kvm -cpu host"
fi

# ---------- ISO ----------
if [ ! -f "$ISO" ]; then
    echo "==> Downloading latest Arch ISO (~1 GB)"
    # Use a known mirror. Geomirror would be better but adds complexity.
    LATEST_URL=$(curl -sL https://archlinux.org/releng/releases/json/ \
        | grep -oE '"iso_url":[[:space:]]*"[^"]+\.iso"' \
        | head -1 \
        | sed 's/.*"\(http[^"]*\)"/\1/')
    if [ -z "$LATEST_URL" ]; then
        # Fallback to the canonical "latest" symlink.
        LATEST_URL="https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
    fi
    echo "    URL: $LATEST_URL"
    curl -L --progress-bar -o "$ISO.partial" "$LATEST_URL"
    mv "$ISO.partial" "$ISO"
fi

# ---------- OVMF (UEFI firmware) ----------
# Different distros put OVMF in different paths. Try common ones,
# then fall back to copying from /usr/share if found.
find_ovmf() {
    local candidates=(
        /usr/share/edk2/x64/OVMF_CODE.4m.fd
        /usr/share/edk2-ovmf/x64/OVMF_CODE.fd
        /usr/share/OVMF/OVMF_CODE.fd
        /usr/share/ovmf/OVMF.fd
    )
    for c in "${candidates[@]}"; do
        [ -f "$c" ] && { echo "$c"; return; }
    done
    return 1
}
find_ovmf_vars() {
    local candidates=(
        /usr/share/edk2/x64/OVMF_VARS.4m.fd
        /usr/share/edk2-ovmf/x64/OVMF_VARS.fd
        /usr/share/OVMF/OVMF_VARS.fd
    )
    for c in "${candidates[@]}"; do
        [ -f "$c" ] && { echo "$c"; return; }
    done
    return 1
}

if [ ! -f "$OVMF_CODE" ]; then
    src=$(find_ovmf) || {
        echo "Could not locate OVMF firmware. Install with: sudo pacman -S edk2-ovmf"
        exit 1
    }
    cp "$src" "$OVMF_CODE"
fi
if [ ! -f "$OVMF_VARS" ]; then
    src=$(find_ovmf_vars) || {
        echo "Could not locate OVMF_VARS. Install: sudo pacman -S edk2-ovmf"
        exit 1
    }
    cp "$src" "$OVMF_VARS"
fi

# ---------- Disk ----------
if [ ! -f "$DISK" ]; then
    echo "==> Creating ${DISK_SIZE_GB}G qcow2 disk: $DISK"
    qemu-img create -f qcow2 "$DISK" "${DISK_SIZE_GB}G"
fi

# ---------- Mode ----------
MODE="${1:---install}"
case "$MODE" in
    --install)
        ISO_ARGS="-cdrom $ISO -boot d"
        echo "==> Booting VM with installer ISO"
        ;;
    --boot-disk|--boot)
        ISO_ARGS=""
        echo "==> Booting VM from installed disk"
        ;;
    --reset-disk)
        echo "==> Removing $DISK"
        rm -f "$DISK"
        echo "    Re-run without --reset-disk to recreate."
        exit 0
    ;;
    -h|--help)
        sed -n '2,30p' "$0"
        exit 0
    ;;
    *)
        echo "Unknown mode: $MODE"
        echo "Usage: $0 [--install|--boot-disk|--reset-disk]"
        exit 1
    ;;
esac

# ---------- Launch ----------
echo
echo "==> Booting QEMU. Close the window or 'poweroff' inside to exit."
echo "    After install: rerun with --boot-disk."
echo

exec qemu-system-x86_64 \
    $KVM_ARGS \
    -machine q35,smm=on \
    -m "$RAM_MB" \
    -smp "$CORES" \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file="$OVMF_VARS" \
    -drive file="$DISK",if=virtio,format=qcow2 \
    $ISO_ARGS \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0 \
    -vga virtio \
    -display gtk,gl=on \
    -device intel-hda -device hda-duplex
