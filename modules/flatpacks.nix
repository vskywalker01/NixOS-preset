{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.flatpacks;
in {
  options.flatpacks = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ssh server in configuration";
    };
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = lib.mkForce true;
    services.flatpak.enable = lib.mkForce true;
  };
}