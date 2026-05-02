# Test harness for arch.sh

Two harnesses, different cost/coverage tradeoffs.

## `smoke-test.sh` — fast, runs in ~1 min

Validates that every pacman/yay package and HTTP URL referenced in `arch.sh`
still resolves, and that both shell scripts pass `bash -n`. This catches the
most common cause of breakage on a fresh install: a package was renamed,
removed, or an upstream URL moved.

Requires: `podman` installed (rootless, no daemon).

```bash
./test/smoke-test.sh
```

What it does NOT verify:
- Runtime ordering (does cargo end up on PATH before `cargo install`?)
- Anything that needs a real kernel/GPU/display (GRUB, SDDM, Hyprland, audio, NVIDIA driver)

## `qemu-vm.sh` — full end-to-end, runs in ~30 min

Boots a fresh Arch ISO in a QEMU VM, lets you do a real `archinstall`, then
run `arch.sh` against the result. Verifies bootloader, NetworkManager, audio,
Hyprland startup, the lot.

Requires: `qemu-full edk2-ovmf` installed, `/dev/kvm` for acceleration.

```bash
sudo pacman -S --needed qemu-full edk2-ovmf

# 1. Boot installer
./test/qemu-vm.sh --install

# Inside the VM:
#   archinstall   (minimal profile, GRUB, NetworkManager)
#   poweroff

# 2. Boot the installed system
./test/qemu-vm.sh --boot-disk

# Inside the booted VM:
#   git clone <your dotfiles repo> ~/Projects/dotfiles
#   cd ~/Projects/dotfiles && ./arch.sh

# 3. Reset and start over
./test/qemu-vm.sh --reset-disk
```

Cache lives in `test/cache/` (gitignored — ISO + UEFI firmware + qcow2 disk).
First run downloads ~1 GB; subsequent runs are instant.
