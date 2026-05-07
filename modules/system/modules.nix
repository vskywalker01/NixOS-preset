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
    ./ollama.nix
    ./appimage.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
    networking.firewall.allowedUDPPorts = [ 53 67 ];
    networking.firewall.allowedTCPPorts = [ 53 ];
    # If internet works but DNS fails, you might need:
    networking.firewall.checkReversePath = "loose";
  };
}
