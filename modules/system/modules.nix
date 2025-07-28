{config, lib, pkgs, ...}:
{
  imports = [
    ./docker.nix
    ./pipewire.nix
    ./gnome.nix
    ./qemu/qemu.nix
    ./steam/steam.nix
    ./ssh.nix
    ./virtualbox.nix
    ./flatpacks.nix
    ./ollama.nix
    ./cups.nix
    ./samba.nix
    ./launchpad.nix
    ./development/development.nix
    ./cockpit.nix
  ];
}
