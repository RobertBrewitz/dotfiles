# Dotfiles

## Setup Arch Linux

```bash
git clone git@github.com:RobertBrewitz/dotfiles.git
cd dotfiles
sh arch.sh
```

### Chrome Video Playback Fix (NVIDIA + Wayland)

Chrome has issues with VP9 hardware video decode on NVIDIA with native Wayland, causing page freezes during video playback. The workaround is to run Chrome under XWayland.

The dotfiles include a custom `.desktop` file that launches Chrome with `--ozone-platform=x11`. This is automatically symlinked to `~/.local/share/applications/` by `symlink_arch.sh`.

A shell alias is also added to `profile`:
```bash
alias chrome='google-chrome-stable --ozone-platform=x11'
```

## Package Manager Security

The dotfiles add a one-week release-age gate for npm, pnpm, Yarn, Bun, and Renovate.
The npm config also sets `ignore-scripts` to true to ignore pre- and post-install hooks from npm packages.
Deno 2.8+ also reads `min-release-age` from `.npmrc` for npm package installs.
Cargo does not currently have a stable native minimum-release-age setting.
If any of these target files already exist, the symlink scripts warn, move the existing file to a timestamped `.backup.*` path, and then link the managed security config.

```bash
~/.npmrc                         # security/npmrc.conf, min-release-age=7
~/.yarnrc.yml                    # security/yarnrc.yml, npmMinimalAgeGate: 7d
~/.config/pnpm/config.yaml        # security/pnpm.yaml, minimumReleaseAge: 10080
~/.bunfig.toml                    # security/bunfig.toml, minimumReleaseAge = 604800
~/.config/renovate/config.json    # security/renovate.json, minimumReleaseAge: 7 days
```

## Setup OS X

```bash
xcode-select --install # install command line developer tools
git clone git@github.com:RobertBrewitz/dotfiles.git
cd dotfiles
sh osx.sh
```

## Setup ChromeOS

### Prerequisite

Activate developer mode on your Chromebook.

[Chromium Documentation](https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/generic)

### Setup

Open crosh (terminal) with alt+ctrl+T in the Chrome browser

```bash
shell # to enter bash
git clone git@github.com:RobertBrewitz/dotfiles.git
cd dotfiles
sh chronos.sh
```

## Setup Windows 10 WSL

### Prerequisite

Activate developer mode on your Windows and install Ubuntu WSL.

### Setup

Open Ubuntu WSL

```bash
git clone git@github.com:RobertBrewitz/dotfiles.git
cd dotfiles
sh wsl.sh
```

## Setup Ubuntu

### Setup

Open terminal

```bash
git clone git@github.com:RobertBrewitz/dotfiles.git
cd dotfiles
sh ubuntu.sh
```

### .gitconfig-user

Update .gitconfig-user email, user, username, and signingkey if applicable.

### Hot Reloading frameworks

To have developer servers such as react and preact, filewatch limit has to be increased for users.

```bash
echo 100000 | sudo tee /proc/sys/fs/inotify/max_user_watches
echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Ubuntu on NUC Audio & Mic combojack fix

#### Get codec info

```bash
cat /proc/asound/card*/codec* | grep Codec
```

[Lookup model on kernel.org](https://www.kernel.org/doc/html/latest/sound/hd-audio/models.html)

#### Add setting to end of /etc/modprobe.d/alsa-base.conf file

```bash
options snd-hda-intel model=dell-headset-multi
```

### Ubuntu 20.04 VPN IPSec LT2P workarounds

[Known issues and workarounds](https://github.com/nm-l2tp/NetworkManager-l2tp/wiki/Known-Issues)

```bash
sudo apt install resolvconf
sudo vi /etc/NetworkManager/NetworkManager.conf
# Add `dns=dnsmasq` to `[main]`
sudo mv /etc/resolv.conf /etc/resolv.conf.systemd
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo systemctl restart NetworkManager
```

### Ubuntu 22.04 Handle OpenVPN dns push updates

```bash
sudo apt install openvpn-systemd-resolved

# add to .ovpn conf
script-security 2
up /etc/openvpn/update-systemd-resolved
up-restart
down /etc/openvpn/update-systemd-resolved
down-pre
```

### Ubuntu 22.04 disable auto updates

```bash
sudo sed -i 's/1/0/g' /etc/apt/apt.conf.d/20auto-upgrades
```

### Ubuntu 22.04 nvidia drivers

#### Disable nouveau

```bash
  echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf > /dev/null
  echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist.conf > /dev/null
  sudo update-initramfs -u
```
