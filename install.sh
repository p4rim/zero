#!/bin/bash

set -euo pipefail

zero_source=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skip_packages=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--skip-packages]

Installs the Zero post-install layer on Arch Linux. The system boots to a TTY;
run start-hyprland after logging in to launch the desktop.

Options:
  --skip-packages  Install files and configuration without changing packages.
  -h, --help       Show this help.
EOF
}

while (( $# > 0 )); do
  case $1 in
    --skip-packages)
      skip_packages=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if (( EUID == 0 )); then
  echo "Run install.sh as the user who will launch Zero, not as root." >&2
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  echo "Zero currently supports Arch Linux only." >&2
  exit 1
fi

sudo -v
sudo env ZERO_SOURCE="$zero_source" ZERO_USER="$USER" ZERO_SKIP_PACKAGES="$skip_packages" bash "$zero_source/install/system.sh"
ZERO_SOURCE="$zero_source" bash "$zero_source/install/user.sh"

printf '\nZero is installed. Reboot, log in on the TTY, then run: start-hyprland\n'
