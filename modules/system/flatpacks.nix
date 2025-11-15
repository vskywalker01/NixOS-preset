{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.flatpak.enable) {
    nixpkgs.config.allowUnfree = lib.mkForce true;
  };
}
