{config, lib, pkgs, ...}:
{
  imports = [
    ./docker/docker.nix
    ./pipewire.nix
    ./desktop/desktop.nix
    ./qemu/qemu.nix
    ./steam/steam.nix
    ./ssh.nix
    ./virtualbox.nix
    ./flatpacks.nix
    ./cups.nix
    ./samba.nix
    ./launchpad.nix
    ./vpn.nix
    ./sddm/sddm.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
}
