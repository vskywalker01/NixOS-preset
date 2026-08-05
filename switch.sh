#!/run/current-system/sw/bin/bash
set -euo pipefail

UPGRADE=false
REMOTE_HOST=""

usage() {
    echo "Usage: $0 [--upgrade] [--remote user@host]"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --upgrade)
            UPGRADE=true
            shift
            ;;

        --remote)
            if [[ $# -lt 2 ]]; then
                echo "Missing remote host"
                usage
            fi
            REMOTE_HOST="$2"
            shift 2
            ;;

        *)
            echo "Flag not recognized: $1"
            usage
            ;;
    esac
done


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
    sudo chown root:root /etc/nixos/flake.lock
fi


if [[ -n "$REMOTE_HOST" ]]; then
    echo "Building remotely on $REMOTE_HOST" 
    nixos-rebuild switch --build-host "$REMOTE_HOST" --target-host localhost --sudo --ask-sudo-password
else
    sudo nixos-rebuild switch
fi


if [[ "$UPGRADE" == true ]]; then
    sudo cp /etc/nixos/flake.lock ./flake.lock
    sudo chown "$(id -u):$(id -g)" ./flake.lock
fi
