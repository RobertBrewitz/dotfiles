# Agent Instructions

## Theming

Use **Catppuccin Mocha** for all applications with the following modifications:

- `base`: `#000000` (black)
- `mantle`: `#000000` (black)
- `crust`: `#000000` (black)

All other Catppuccin Mocha colors remain unchanged.

### Catppuccin Mocha Palette Reference

```
rosewater: #f5e0dc
flamingo:  #f2cdcd
pink:      #f5c2e7
mauve:     #cba6f7
red:       #f38ba8
maroon:    #eba0ac
peach:     #fab387
yellow:    #f9e2af
green:     #a6e3a1
teal:      #94e2d5
sky:       #89dceb
sapphire:  #74c7ec
blue:      #89b4fa
lavender:  #b4befe
text:      #cdd6f4
subtext1:  #bac2de
subtext0:  #a6adc8
overlay2:  #9399b2
overlay1:  #7f849c
overlay0:  #6c7086
surface2:  #585b70
surface1:  #45475a
surface0:  #313244
base:      #000000 (modified)
mantle:    #000000 (modified)
crust:     #000000 (modified)
```

## Applications

Configs are stored in `config/` and symlinked via `symlink_arch.sh`.

Current themed applications:
- Hyprland (`config/hypr/`)
- Waybar (`config/waybar/`)
- Kitty (`config/kitty/`)
- Wofi (`config/wofi/`)
- Dunst (`config/dunst/`)
- GTK 3/4 (`config/gtk-3.0/`, `config/gtk-4.0/`)
- Neovim (`nvim/`)

## Installation

- `arch.sh` - Full Arch Linux setup (packages + symlinks)
- `symlink_arch.sh` - Symlink configs only
