#!/run/current-system/sw/bin/bash

set -euo pipefail

UPGRADE=false

if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [--upgrade]"
    exit 1
fi

if [[ $# -eq 1 ]]; then
    case "$1" in
        --upgrade)
            UPGRADE=true
            ;;
        *)
            echo "Flag not recognized $1"
            echo "Usage: $0 [--upgrade]"
            exit 1
            ;;
    esac
fi

if [[ "$UPGRADE" == true ]]; then
    mkdir -p locks
    timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    cp flake.lock "locks/lock_${timestamp}.lock"
    sudo rm -f /etc/nixos/flake.lock
fi

sudo cp -r modules /etc/nixos
sudo cp flake.nix /etc/nixos

if [[ "$UPGRADE" == false ]]; then
    sudo cp flake.lock /etc/nixos
fi 

sudo nixos-rebuild switch 

if [[ "$UPGRADE" == true ]]; then
    sudo cp /etc/nixos/flake.lock ./flake.lock
    sudo chown "$(id -u):$(id -g)" ./flake.lock
fi










