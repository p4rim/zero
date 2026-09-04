# Zero

Zero is a minimal Arch Linux post-install layer built around Hyprland and a native Quickshell desktop.

It boots to a TTY and does not install or enable a display manager. Log in normally and run `start-hyprland` to launch the UWSM-managed desktop session.

The default installation includes a monochrome black-and-white theme, the Quickshell bar and panels, the full non-AI command menu, interactive Arch package and AUR installers, and essential desktop utilities. Optional software is available from the menu but is not preinstalled.

Zero deliberately contains no AI integrations, installers, agents, usage widgets, configuration, or branding.

## Install

Run from an existing Arch installation:

```bash
./install.sh
```

To install only the Zero files and configuration while developing on a machine that already has the dependencies:

```bash
./install.sh --skip-packages
```

The installer backs up an existing `~/.config/hypr` or `~/.config/zero` tree under `~/.local/state/zero/backups/` before installing its defaults.

## Session

After rebooting:

```text
login: your-user
Password:

$ start-hyprland
```

The system default target is `multi-user.target`; display-manager services are disabled rather than used to start the graphical session.

## Layout

- `bin/` contains Zero commands and menu helpers.
- `config/` contains user configuration defaults.
- `default/` contains package-owned Hyprland and session defaults.
- `install/` is split into reusable system and user stages so a future ISO can call the same installation logic.
- `shell/` contains the Quickshell desktop.
- `themes/mono/` is the default monochrome theme.

## Package menus

Open the Zero menu and select `Install → Package` to search official repositories or `Install → AUR` to search AUR packages. `Remove → Package` provides the matching removal flow.

## License

Zero includes MIT-licensed components. See `LICENSE`.
