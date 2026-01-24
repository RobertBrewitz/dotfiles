# Arch Linux Installation Guide

## Prerequisites for Windows Dual Boot

Before starting, do these in Windows:

1. **Disable Fast Startup** (required - prevents filesystem corruption)
   - Control Panel → Power Options → Choose what power buttons do
   - Click "Change settings that are currently unavailable"
   - Uncheck "Turn on fast startup"
   - Save changes

2. **Shrink Windows partition** to make space for Arch
   - Right-click Start → Disk Management
   - Right-click Windows partition (usually C:) → Shrink Volume
   - Shrink by at least 100GB (100000 MB)
   - Leave the space as "Unallocated"

3. **Note your EFI partition** - usually 100-512MB, labeled "EFI System Partition"

4. **Disable Secure Boot** in BIOS (do this when you boot the USB)

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

# You should see something like:
# nvme0n1p1  vfat   EFI        <- Windows EFI (DO NOT TOUCH)
# nvme0n1p2         Microsoft reserved
# nvme0n1p3  ntfs   Windows    <- Windows C: drive
# nvme0n1p4  ntfs   Recovery
# (free space you created earlier)

# Create partitions in the free space
cfdisk /dev/nvme0n1
```

In cfdisk, select the "Free space" and create:
1. **Root partition** - 100GB, type "Linux filesystem"
2. **Home partition** - remaining space, type "Linux filesystem"

Write and quit.

### After partitioning you should have:

| Partition | Size | Type | Mount | Format? |
|-----------|------|------|-------|---------|
| nvme0n1p1 | 100-512M | EFI (existing) | /boot | **NO** |
| nvme0n1pX | 100G | Linux filesystem | / | Yes |
| nvme0n1pY | Remaining | Linux filesystem | /home | Yes |

### Format NEW partitions only

```bash
# ONLY format the new Linux partitions - NEVER format EFI or Windows partitions
mkfs.ext4 /dev/nvme0n1pX   # your new root partition
mkfs.ext4 /dev/nvme0n1pY   # your new home partition
```

### Mount partitions

```bash
mount /dev/nvme0n1pX /mnt              # root
mount --mkdir /dev/nvme0n1pY /mnt/home # home
mount --mkdir /dev/nvme0n1pZ /mnt/boot # existing EFI
```

---

## 5. Install Base System

```bash
# Update mirrors (optional but faster)
reflector --country US --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install base system
pacstrap -K /mnt base linux linux-firmware sudo vim git networkmanager grub efibootmgr

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
# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Enable os-prober for dual boot
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# Generate config
grub-mkconfig -o /boot/grub/grub.cfg
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

### Dual boot not showing other OS
```bash
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
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
