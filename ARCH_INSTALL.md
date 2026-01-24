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

## 2. Boot from USB

1. Insert USB and reboot
2. Enter BIOS/UEFI (usually F2, F12, Del, or Esc)
3. Disable Secure Boot
4. Select USB as boot device
5. Select "Arch Linux install medium"

---

## 3. Connect to Internet

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

---

## 4. Partition Disks

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

Write and quit.

### Partition summary

| Partition | Type | Mount | Format? |
|-----------|------|-------|---------|
| EFI (existing) | vfat | /boot/efi | **NO** |
| Root | ext4 | / | Yes |
| Home | ext4 | /home | Yes (or No to keep data) |

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

## 5. Install Base System

```bash
# Update mirrors (optional but faster)
reflector --country US --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install base system
pacstrap -K /mnt base linux linux-firmware sudo vim git networkmanager grub efibootmgr os-prober

# For Intel CPU, add: intel-ucode
# For AMD CPU, add: amd-ucode
# For NVIDIA GPU, add: nvidia nvidia-utils
```

---

## 6. Configure System

```bash
# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
arch-chroot /mnt

# Timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

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

# Enable NetworkManager
systemctl enable NetworkManager
```

---

## 7. Install Bootloader

```bash
# Install GRUB (note: efi-directory matches mount point)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# Enable os-prober for dual boot
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# Generate config (should detect Windows automatically)
grub-mkconfig -o /boot/grub/grub.cfg
```

If Windows isn't detected, make sure os-prober is installed and the Windows partition is accessible:
```bash
os-prober
# Should output something like: /dev/nvme0n1p3:Windows Boot Manager:Windows:efi
```

---

## 8. Reboot

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
git clone https://github.com/yourusername/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles

# Create symlinks
ln -sf ~/Projects/dotfiles/profile ~/.profile
ln -sf ~/Projects/dotfiles/vimrc ~/.vimrc
ln -sf ~/Projects/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/Projects/dotfiles/gitconfig ~/.gitconfig
mkdir -p ~/.config
ln -sf ~/Projects/dotfiles/config/hypr ~/.config/hypr
ln -sf ~/Projects/dotfiles/config/foot ~/.config/foot
ln -sf ~/Projects/dotfiles/config/waybar ~/.config/waybar
ln -sf ~/Projects/dotfiles/config/nvim ~/.config/nvim

# Run setup script
chmod +x arch.sh
./arch.sh
```

---

## 10. Start Hyprland

After reboot, SDDM will start automatically. Select Hyprland and login.

### Key bindings

| Key | Action |
|-----|--------|
| Super + Return | Terminal (foot) |
| Super + E | File manager (thunar) |
| Super + P | App launcher (wofi) |
| Super + Q | Close window |
| Super + H/J/K/L | Focus left/down/up/right |
| Super + 1-4 | Switch workspace |
| Super + Shift + 1-4 | Move window to workspace |
| Super + V | Clipboard history |
| Super + R | Record screen region |
| Super + Shift + R | Stop recording |
| Super + Escape | Lock screen |
| Super + Shift + E | Exit Hyprland |
| Print | Screenshot region to file |
| Ctrl + Print | Screenshot region to clipboard |

---

## Troubleshooting

### No WiFi after reboot
```bash
sudo systemctl enable --now NetworkManager
nmtui
```

### NVIDIA issues
Add to kernel parameters in `/etc/default/grub`:
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
