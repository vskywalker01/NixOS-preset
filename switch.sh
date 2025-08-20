#!/run/current-system/sw/bin/bash

sudo cp -r modules /etc/nixos
sudo cp flake.lock /etc/nixos
sudo cp flake.nix /etc/nixos

sudo nixos-rebuild switch --use-remote-sudo 