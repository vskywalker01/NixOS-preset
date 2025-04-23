{config, lib, pkgs, ...}:
{
  imports = [
    ./docker.nix
    ./pipewire.nix
    ./gnome.nix
    ./qemu.nix
    ./steam/steam.nix
    ./ssh.nix
    ./virtualbox.nix
    ./flatpacks.nix
    ./ollama.nix
    ./cups.nix
  ];
}
