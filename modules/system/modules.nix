{config, lib, pkgs, ...}:
{
  imports = [
    ./docker/docker.nix
    ./pipewire.nix
    ./gnome.nix
    ./qemu/qemu.nix
    ./steam/steam.nix
    ./ssh.nix
    ./virtualbox.nix
    ./flatpacks.nix
    ./cups.nix
    ./samba.nix
    ./launchpad.nix
    ./vpn.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
}
