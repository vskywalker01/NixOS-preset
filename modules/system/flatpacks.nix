{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.flatpak.enable  && config.services.xserver.desktopManager.gnome.enable) {
    nixpkgs.config.allowUnfree = lib.mkForce true;
  };
}