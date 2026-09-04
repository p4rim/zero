# Testing on fresh Arch

Use a disposable physical machine or virtual machine with a fresh, minimal Arch Linux installation. A VM snapshot taken immediately after the base installation makes repeated Zero tests much faster.

## Prepare the Arch installation

Zero's installer must run as a regular user with working `sudo` access. Before cloning Zero, make sure the machine has internet access and install the GitHub tools:

```bash
sudo pacman -Syu --needed git github-cli networkmanager
sudo systemctl enable --now NetworkManager
```

If networking is already managed another way, installing and starting NetworkManager at this point is optional; Zero will install and enable it during setup.

## Authenticate and clone

The Zero repository is private, so authenticate the new machine with the GitHub account that owns it:

```bash
gh auth login
gh repo clone p4rim/zero ~/zero
cd ~/zero
```

Choose GitHub.com and the web-browser/device-code login when prompted. You can revoke this machine's GitHub authorization after cloning if it is only a temporary test machine.

## Install Zero

Run the post-install layer from the checkout:

```bash
./install.sh
```

The installer updates Arch, installs the Zero desktop package set, installs the payload under `/usr/share/zero`, disables display-manager services, and changes the default target to `multi-user.target`.

When installation finishes, reboot:

```bash
sudo reboot
```

## First boot

The machine should stop at a normal TTY login. Log in with the regular user and verify the boot target:

```bash
systemctl get-default
```

The result should be `multi-user.target`. Start the graphical session manually:

```bash
start-hyprland
```

## Desktop smoke test

Once Hyprland starts:

1. Press `Super+Space` and confirm the monochrome Zero menu opens.
2. Open `Install → Package`, confirm the official-package picker loads, then cancel it.
3. Open `Install → AUR`, confirm the AUR picker loads, then cancel it.
4. Exercise the audio, network, Bluetooth, monitor, power, clipboard, notification, lock, and logout panels that apply to the test hardware.
5. Run `zero version` in a terminal and confirm it reports the installed version.
6. Log out and confirm the system returns to the TTY instead of a graphical login screen.

## Collect diagnostics

If the graphical session fails, remain in the TTY and capture these results before changing the machine:

```bash
start-hyprland
journalctl --user -b --no-pager | tail -200
journalctl -b --no-pager | tail -200
```

Keep the complete installer output as well. It usually identifies whether a failure occurred while installing an official package, building an AUR dependency, copying the payload, or starting the UWSM session.
