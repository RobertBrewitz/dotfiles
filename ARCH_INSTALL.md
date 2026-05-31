# Arch Linux Installation Guide

## Prerequisites

### Fresh install alongside Windows

1. **Disable Fast Startup** in Windows (prevents filesystem corruption)
   - Control Panel → Power Options → Choose what power buttons do
   - Click "Change settings that are currently unavailable"
   - Uncheck "Turn on fast startup" → Save

2. **Shrink Windows partition** in Disk Management (right-click Start)
   - Right-click C: → Shrink Volume → Shrink by 100GB+

3. **Disable Secure Boot** in BIOS

### Replacing Ubuntu (keeping Windows)

If you already have Ubuntu installed:

- You can reuse Ubuntu's partitions (just format them during install)
- The EFI partition is shared - don't format it
- GRUB will be reinstalled and will detect Windows automatically

### Installing into existing unallocated space

If you already have unallocated space from removing Linux:

- Skip to Step 3 (Connect to Internet)
- In Step 4, just create new partition(s) from free space
- The EFI partition is shared - don't format it

---

## 1. Create Bootable USB

Download the ISO from https://archlinux.org/download/

```bash
# Linux/macOS - find your USB device
lsblk

# Write ISO to USB (replace /dev/sdX with your device)
sudo dd bs=4M if=archlinux-*.iso of=/dev/sdX status=progress oflag=sync
```

On Windows, use [Rufus](https://rufus.ie/) or [Ventoy](https://ventoy.net/).

---

## Quick Install with archinstall

If you prefer a guided installer over manual steps, `archinstall` ships on the Arch ISO and handles partitioning, base system, bootloader, and user creation in one TUI:

```bash
# Boot from USB, connect to internet (step 3 below), then:
archinstall
```

Recommended selections:

- **Disk layout**: Best effort (select your drive, ext4, separate /home optional)
- **Bootloader**: GRUB (needed for dual boot with os-prober)
- **Profile**: Minimal
- **Audio**: PipeWire
- **Additional packages**: `git networkmanager os-prober efibootmgr`
- **Network**: NetworkManager

After it finishes and reboots, skip to [Step 9: Apply Dotfiles](#9-post-install-apply-dotfiles).

---

## Manual Install

### 2. Boot from USB

1. Insert USB and reboot
2. Enter BIOS/UEFI (usually F2, F12, Del, or Esc)
3. Disable Secure Boot
4. Select USB as boot device
5. Select "Arch Linux install medium"

---

### 3. Connect to Internet

```bash
# Wired usually works automatically. For WiFi:
iwctl
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "SSID"
[iwd]# exit

# Verify connection
ping -c 3 archlinux.org
```

> **SSID with special characters:** If the network name contains non-ASCII or special characters that are hard to type at the console, pass it as a `$'...'` ANSI-C quoted string using the Unicode escape. For example, a name ending in `å` (U+00E5):
>
> ```bash
> iwctl station wlan0 connect $'ssid\u00E5'
> ```
>
> The shell expands `\u00E5` to `å` before handing the SSID to iwctl.

---

### 4. Partition Disks

```bash
# List disks - identify your partitions
lsblk -f
```

### If replacing Ubuntu

You'll see Ubuntu's existing partitions (ext4). Note which ones are Ubuntu's root/home:

```
nvme0n1p1  vfat   EFI         <- Shared EFI (DO NOT FORMAT)
nvme0n1p2         Microsoft reserved
nvme0n1p3  ntfs   Windows     <- Windows (DO NOT TOUCH)
nvme0n1p5  ext4   Ubuntu root <- Reuse for Arch root
nvme0n1p6  ext4   Ubuntu home <- Reuse for Arch home (or keep data)
```

You can either:

- **Reuse Ubuntu partitions** - just format them in the next step
- **Resize/repartition** - use `cfdisk /dev/nvme0n1` to adjust

### If creating new partitions from unallocated space

```bash
cfdisk /dev/nvme0n1   # or /dev/sda
```

Select "Free space" and create:

1. **Root partition** - 100GB+ (or all space if no separate home), type "Linux filesystem"
2. **Home partition** (optional) - remaining space, type "Linux filesystem"

> **cfdisk doesn't ask for a name.** New partitions default to the **Linux filesystem** type, which is what you want for root and home - so just `[ New ]` → size → Enter for these. (The optional GPT "name" is a cosmetic label; ignore it.) To change a partition's type, select its row and use the bottom `[ Type ]` menu - see the next section for the EFI example.

Write and quit (`[ Write ]` → type `yes` → `[ Quit ]`).

### Partition summary

| Partition      | Type | Mount     | Format?                  |
| -------------- | ---- | --------- | ------------------------ |
| EFI (existing) | vfat | /boot/efi | **NO**                   |
| Root           | ext4 | /         | Yes                      |
| Home           | ext4 | /home     | Yes (or No to keep data) |

### Format partitions

```bash
# Format root (REQUIRED)
mkfs.ext4 /dev/nvme0n1pX

# Format home (optional - skip to keep existing data)
mkfs.ext4 /dev/nvme0n1pY

# NEVER format EFI or Windows/NTFS partitions
```

### Mount partitions

```bash
# Mount root first
mount /dev/nvme0n1pX /mnt

# Mount home (if separate)
mount --mkdir /dev/nvme0n1pY /mnt/home

# Mount EFI at /boot/efi (keeps kernels on root, only bootloader on EFI)
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi
```

> **Note:** We mount EFI at `/boot/efi` rather than `/boot` because the Windows EFI partition is only ~200MB. This keeps your kernels on the larger ext4 root partition and only puts the GRUB bootloader on the small EFI partition.

---

## Alternative: Wipe the Entire Disk (Arch as Sole OS)

> **Skip this section if you're dual-booting.** It replaces the partition/format/mount steps above with a clean single-OS layout. Once done, continue at [Step 5](#5-install-base-system).

> **DANGER:** This erases everything on the disk - Windows, other Linux installs, all data. There is no undo. Triple-check the device name with `lsblk` before running anything.

This path creates a brand-new GPT layout with a fresh EFI partition (unlike the dual-boot paths, there is no Windows EFI to preserve).

### Wipe the disk

```bash
# Confirm the target disk - note the size to make sure it's the right one
lsblk

# Wipe all existing partition tables and signatures (replace nvme0n1 with your disk)
wipefs -a /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1
```

### Partition

```bash
cfdisk /dev/nvme0n1   # or /dev/sda
```

When prompted, select **gpt** as the label type, then create each partition with `[ New ]` → enter size → Enter:

1. **EFI partition** - 1GB
2. **Root partition** - 100GB+ (or all remaining space if no separate home)
3. **Home partition** (optional) - remaining space

Each new partition defaults to the **Linux filesystem** type. Root and home are fine as-is. For the **EFI partition**, select its row, open the bottom `[ Type ]` menu (Enter), and choose **EFI System** from the list. cfdisk never prompts for a name - the optional GPT label is cosmetic and can be skipped.

Write and quit (`[ Write ]` → type `yes` → `[ Quit ]`).

| Partition | Type         | Mount     | Format? |
| --------- | ------------ | --------- | ------- |
| EFI (new) | vfat (FAT32) | /boot/efi | Yes     |
| Root      | ext4         | /         | Yes     |
| Home      | ext4         | /home     | Yes     |

### Format and mount

Note: you **do** format the EFI partition here, since it's new.

```bash
# Format EFI as FAT32
mkfs.fat -F32 /dev/nvme0n1p1

# Format root
mkfs.ext4 /dev/nvme0n1p2

# Format home (if separate)
mkfs.ext4 /dev/nvme0n1p3

# Mount root first, then EFI and home
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi
mount --mkdir /dev/nvme0n1p3 /mnt/home   # only if separate home
```

Since this is a single-OS install, os-prober isn't needed later - it's harmless to leave enabled in Step 7 but won't find anything to detect. Continue at [Step 5: Install Base System](#5-install-base-system).

---

### 5. Install Base System

```bash
# Update mirrors (optional but faster)
reflector --country US --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install base system
pacstrap -K /mnt base linux linux-firmware sudo vim git networkmanager grub efibootmgr os-prober

# For Intel CPU, add: intel-ucode
# For AMD CPU, add: amd-ucode
```

> **NVIDIA GPU?** Don't add NVIDIA packages here. The `arch.sh` dotfiles script (Step 9) auto-detects an NVIDIA GPU and installs `nvidia-open` plus the `nvidia_drm.modeset=1` kernel parameter for you. Installing the proprietary `nvidia` package now would conflict with that.

---

### 6. Configure System

```bash
# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
arch-chroot /mnt

# Timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Locale - append the locales we want, then generate them
cat >> /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
sv_SE.UTF-8 UTF-8
pl_PL.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Verify they generated (should list en_US.utf8, sv_SE.utf8, pl_PL.utf8)
locale -a | grep -iE 'en_US|sv_SE|pl_PL'

# Hostname
echo "archbox" > /etc/hostname

# Root password
passwd

# Create user
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername

# Enable sudo for wheel group
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
# Or: %wheel ALL=(ALL:ALL) NOPASSWD: ALL

# Enable NetworkManager
systemctl enable NetworkManager
```

---

### 7. Install Bootloader

```bash
# Install GRUB (note: efi-directory matches mount point)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# Enable os-prober for dual boot
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# Generate config (should detect Windows automatically)
grub-mkconfig -o /boot/grub/grub.cfg
```

> **Sole-OS install?** Run only `grub-install` and `grub-mkconfig`. Skip the `GRUB_DISABLE_OS_PROBER=false` line and the os-prober check below - those only matter when another OS (e.g. Windows) needs to be detected.

If Windows isn't detected, make sure os-prober is installed and the Windows partition is accessible:

```bash
os-prober
# Should output something like: /dev/nvme0n1p3:Windows Boot Manager:Windows:efi
```

---

### 8. Reboot

```bash
exit
umount -R /mnt
reboot
```

Remove USB when system restarts.

---

## 9. Post-Install: Apply Dotfiles

Login as your user, then:

```bash
# Connect to WiFi
nmtui

# Clone dotfiles
mkdir -p ~/Projects
git clone https://github.com/yourusername/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles

# Run setup script (installs everything and symlinks dotfiles)
chmod +x arch.sh
./arch.sh
```

---

## 10. Start Hyprland

After reboot, SDDM will start automatically. Select Hyprland and login.

### Key bindings

| Key                     | Action                             |
| ----------------------- | ---------------------------------- |
| Super + Return          | Terminal (kitty)                   |
| Super + E               | File manager (thunar)              |
| Super + R               | App launcher (wofi)                |
| Super + Q               | Close window                       |
| Super + F               | Toggle floating                    |
| Super + T               | Toggle split direction             |
| Super + H/J/K/L         | Focus left/down/up/right           |
| Super + Shift + H/J/K/L | Move window                        |
| Super + 1-0             | Switch workspace 1-10              |
| Super + Shift + 1-0     | Move window to workspace           |
| Super + PageUp/PageDown | Previous/next workspace            |
| Super + M               | Minimize window                    |
| Super + Shift + M       | Show minimized windows             |
| Super + V               | Clipboard history                  |
| Super + Space           | Switch keyboard layout             |
| Super + Escape          | Lock screen                        |
| Super + Shift + A       | Restart PipeWire                   |
| Print                   | Fullscreen screenshot to clipboard |
| Shift + Print           | Capture menu (screenshot/record)   |
| Mouse 3 (hold)          | Voice-to-text (voxtype)            |
| F7/F8/F9                | Power saver/balanced/performance   |

---

## Troubleshooting

### No WiFi after reboot

```bash
sudo systemctl enable --now NetworkManager
nmtui
```

### `setlocale`/LC\_\* warnings (e.g. while running arch.sh)

Warnings like `bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8)` or `perl: warning: Setting locale failed` mean the locale your environment references was never generated. Fix it:

```bash
# Append and (re)generate the locales
cat <<'EOF' | sudo tee -a /etc/locale.gen
en_US.UTF-8 UTF-8
sv_SE.UTF-8 UTF-8
pl_PL.UTF-8 UTF-8
EOF
sudo locale-gen

# Set the system locale
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf

# Confirm they're available
locale -a | grep -iE 'en_US|sv_SE|pl_PL'      # should print en_US.utf8, sv_SE.utf8, pl_PL.utf8
```

If you're connected over SSH, the warnings often come from your client forwarding `LC_*`/`LANG` variables that don't exist on the Arch box. Clear them for the current shell, then re-run:

```bash
unset LC_ALL LANGUAGE LC_CTYPE
export LANG=en_US.UTF-8
```

Log out and back in (or reboot) so the new locale applies everywhere.

### NVIDIA issues

`arch.sh` installs `nvidia-open` and sets the `nvidia_drm.modeset=1` kernel parameter automatically. If you skipped the script or the parameter didn't get applied, add it manually to `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1"
```

Then run `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### Dual boot not showing Windows

```bash
# Make sure os-prober is installed
sudo pacman -S os-prober

# Check if it detects Windows
sudo os-prober

# Regenerate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### GRUB error: /boot doesn't look like EFI partition

You're mounting EFI at the wrong location. Use `/boot/efi`:

```bash
mount /dev/nvme0n1p1 /mnt/boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

### No sound

```bash
systemctl --user restart pipewire wireplumber pipewire-pulse
```

### Windows shows wrong time after booting Linux

Linux uses UTC, Windows uses local time. Fix by making Linux use local time:

```bash
timedatectl set-local-rtc 1 --adjust-system-clock
```

### Booting lands in GRUB command line

GRUB can't find its config. Boot manually:

```bash
ls                          # find your partitions
set root=(hd0,gptX)         # your root partition
linux /boot/vmlinuz-linux root=/dev/nvme0n1pX rw
initrd /boot/initramfs-linux.img
boot
```

Once booted, fix GRUB:

```bash
sudo mount /dev/nvme0n1p1 /boot/efi
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
