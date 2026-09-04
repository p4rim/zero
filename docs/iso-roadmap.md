# ISO roadmap

Zero begins as a post-install layer, but its layout keeps image construction separate from desktop configuration.

The future ISO should use ArchISO only for bootstrapping, storage, networking, user creation, and copying the Zero payload. It should then call `install/system.sh` inside the target and `install/user.sh` for the created user so the installed system matches the post-install edition.

The installer interface should remain terminal-native, monochrome, and keyboard-driven. It should use the Zero ASCII identity and restrained transitions without introducing a display manager. The installed machine must boot into `multi-user.target`, present a normal TTY login, and leave `start-hyprland` as the explicit graphical-session entry point.

ISO work is intentionally deferred until the post-install package set, Quickshell session, menu helpers, hardware coverage, and upgrade contract are stable.
