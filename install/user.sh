#!/bin/bash

set -euo pipefail

zero_source=${ZERO_SOURCE:?ZERO_SOURCE is required}
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
state_home=${XDG_STATE_HOME:-$HOME/.local/state}
backup_root="$state_home/zero/backups/$(date +%Y%m%d-%H%M%S)"

backup_existing() {
  local existing_path=$1
  local relative_name=$2

  if [[ -e $existing_path || -L $existing_path ]]; then
    mkdir -p "$backup_root"
    mv "$existing_path" "$backup_root/$relative_name"
  fi
}

mkdir -p "$config_home" "$state_home/zero/current"

backup_existing "$config_home/hypr" hypr
backup_existing "$config_home/zero" zero

cp -a "$zero_source/config/hypr" "$config_home/hypr"
cp -a "$zero_source/config/zero" "$config_home/zero"

ln -sfn /usr/share/zero/themes/mono "$state_home/zero/current/theme"
ln -sfn /usr/share/zero/themes/mono/backgrounds/zero.svg "$state_home/zero/current/background"

systemctl --user daemon-reload >/dev/null 2>&1 || true
