#!/bin/bash

set -euo pipefail

zero_source=${ZERO_SOURCE:?ZERO_SOURCE is required}
zero_user=${ZERO_USER:?ZERO_USER is required}
zero_target=/usr/share/zero

if (( EUID != 0 )); then
  echo "install/system.sh must run as root." >&2
  exit 1
fi

install_packages() {
  local package_name build_dir
  local -a official_packages=()
  local -a aur_packages=()

  pacman -Syu --needed --noconfirm base-devel git

  while IFS= read -r package_name; do
    [[ -n $package_name ]] || continue
    [[ $package_name == \#* ]] && continue

    if pacman -Si "$package_name" >/dev/null 2>&1; then
      official_packages+=("$package_name")
    else
      aur_packages+=("$package_name")
    fi
  done <"$zero_source/install/packages.core"

  if (( ${#official_packages[@]} > 0 )); then
    pacman -S --needed --noconfirm "${official_packages[@]}"
  fi

  if (( ${#aur_packages[@]} > 0 )); then
    if ! command -v yay >/dev/null 2>&1; then
      build_dir=$(mktemp -d /tmp/zero-yay.XXXXXX)
      chown "$zero_user:$zero_user" "$build_dir"
      runuser -u "$zero_user" -- git clone https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
      runuser -u "$zero_user" -- bash -lc 'cd "$1" && makepkg -si --noconfirm' _ "$build_dir/yay-bin"
    fi

    runuser -u "$zero_user" -- yay -S --needed --noconfirm "${aur_packages[@]}"
  fi
}

install_payload() {
  local source_entry command_file command_name

  install -d -m 0755 "$zero_target"
  for source_entry in bin config default etc install shell themes LICENSE README.md icon.txt logo.txt version; do
    [[ -e $zero_source/$source_entry ]] || continue
    cp -a "$zero_source/$source_entry" "$zero_target/"
  done

  while IFS= read -r command_file; do
    command_name=${command_file##*/}
    chmod 0755 "$command_file"
    ln -sfn "$command_file" "/usr/local/bin/$command_name"
  done < <(find "$zero_target/bin" -mindepth 1 -maxdepth 1 -type f | sort)

  install -Dm0644 "$zero_target/default/profile.d/zero.sh" /etc/profile.d/zero.sh
  install -Dm0644 "$zero_target/default/uwsm/env.d/10-zero" /usr/share/uwsm/env.d/10-zero
  install -Dm0644 "$zero_target/etc/fastfetch/config.jsonc" /etc/fastfetch/config.jsonc
}

configure_tty_boot() {
  systemctl disable display-manager.service >/dev/null 2>&1 || true
  systemctl disable sddm.service gdm.service lightdm.service greetd.service >/dev/null 2>&1 || true
  systemctl set-default multi-user.target
}

enable_services() {
  systemctl enable NetworkManager.service
  systemctl enable bluetooth.service
  systemctl enable power-profiles-daemon.service
}

if [[ ${ZERO_SKIP_PACKAGES:-0} == "0" ]]; then
  install_packages
fi

install_payload
configure_tty_boot
enable_services
