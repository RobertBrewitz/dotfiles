# Dotfiles

## NPM Security

The install scripts set `ignore-scripts` to true to ignore any pre- and post-install hooks from npm packages.

```bash
npm config set ignore-scripts true
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
