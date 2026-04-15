# Hyprland Desktop Cheatsheet

Mod key: `Super` (Windows/Command key)

## Applications

| Key               | Action               |
|-------------------|----------------------|
| `Super+Return`    | Open terminal (foot) |
| `Super+D`         | App launcher (wofi)  |
| `Super+Q`         | Close window         |

## Window Focus (vim-style)

| Key       | Action      |
|-----------|-------------|
| `Super+h` | Focus left  |
| `Super+j` | Focus down  |
| `Super+k` | Focus up    |
| `Super+l` | Focus right |

## Move Windows

| Key             | Action      |
|-----------------|-------------|
| `Super+Shift+h` | Move left  |
| `Super+Shift+j` | Move down  |
| `Super+Shift+k` | Move up    |
| `Super+Shift+l` | Move right |

## Resize Windows

| Key            | Action        |
|----------------|---------------|
| `Super+Ctrl+h` | Shrink left  |
| `Super+Ctrl+j` | Grow down    |
| `Super+Ctrl+k` | Shrink up    |
| `Super+Ctrl+l` | Grow right   |

## Window State

| Key           | Action          |
|---------------|-----------------|
| `Super+F`     | Fullscreen      |
| `Super+Space` | Toggle float    |
| `Super+P`     | Pseudo-tile     |
| `Super+S`     | Toggle split    |

## Workspaces

| Key              | Action                  |
|------------------|-------------------------|
| `Super+1-9`      | Switch to workspace 1-9 |
| `Super+Shift+1-9`| Move window to workspace|
| `Super+scroll`   | Cycle workspaces        |

3-finger horizontal swipe on touchpad also switches workspaces.

## Mouse

| Key                | Action        |
|--------------------|---------------|
| `Super+Left click`  | Move window  |
| `Super+Right click` | Resize window|

## Screenshots

| Key              | Action                          |
|------------------|---------------------------------|
| `Super+Shift+S`  | Screenshot region to clipboard  |

Uses `grim` + `slurp`. The screenshot is copied to clipboard via `wl-copy`.

## Media Keys

| Key                | Action           |
|--------------------|------------------|
| `Volume Up/Down`   | Adjust volume 5% |
| `Volume Mute`      | Toggle mute      |
| `Brightness Up/Down`| Adjust brightness 5% |

## Lock / Exit

| Key                  | Action         |
|----------------------|----------------|
| `Super+Shift+Delete` | Lock screen    |
| `Super+Shift+E`      | Exit Hyprland  |

## Idle Behavior (hypridle)

| Timeout | Action                              |
|---------|-------------------------------------|
| 2.5 min | Dim screen to 10% (restores on input) |
| 5 min   | Lock screen (hyprlock)              |
| 10 min  | Display off (restores on input)     |

Screen locks automatically before sleep.

## Lock Screen (hyprlock)

Blurred screenshot background with centered clock. Type password and press Enter to unlock.

## Appearance

| Setting          | Value                          |
|------------------|--------------------------------|
| Theme            | Tokyo Night (everywhere)       |
| Font             | JetBrainsMono Nerd Font        |
| Gaps (inner)     | 4px                            |
| Gaps (outer)     | 8px                            |
| Border           | 2px, blue-to-purple gradient   |
| Rounding         | 10px                           |
| Blur             | Enabled (size 6, 2 passes)     |
| Inactive opacity | 95%                            |
| Animations       | Smooth slide + fade            |

## Component Config Locations

| Component     | Config Path                       |
|---------------|-----------------------------------|
| Hyprland      | `~/.config/hypr/hyprland.conf`    |
| Theme/colors  | `~/.config/hypr/theme.conf`       |
| Keybinds      | `~/.config/hypr/keybinds.conf`    |
| Autostart     | `~/.config/hypr/autostart.conf`   |
| Idle          | `~/.config/hypr/hypridle.conf`    |
| Lock screen   | `~/.config/hypr/hyprlock.conf`    |
| Waybar        | `~/.config/waybar/`               |
| Foot terminal | `~/.config/foot/foot.ini`         |
| Notifications | `~/.config/mako/config`           |
| App launcher  | `~/.config/wofi/`                 |

## Waybar Modules (left to right)

Workspaces | Clock | Network | Volume | Backlight | Battery | Tray

## Starting Hyprland

After install, start from a TTY:
```
Hyprland
```

## Bluetooth

```sh
bluetoothctl power on
bluetoothctl scan on
bluetoothctl pair <MAC>
bluetoothctl connect <MAC>
```

## Quick Workflow

```
Super+Return          open terminal
Super+D               launch an app
Super+1-5             switch workspace
Super+Shift+2         move window to workspace 2
Super+h/j/k/l         navigate windows
Super+Shift+h/l       rearrange windows
Super+F               make current window fullscreen
Super+Q               close it
Super+Shift+Delete    lock when stepping away
```
