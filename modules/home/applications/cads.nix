{config, lib, pkgs,flake-inputs, systemConfig ? {} , ...}:

let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.applications = {
    CADs = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include CADs tools in home configuration";
    };
  };
  config = lib.mkIf (config.applications.CADs) {
    home.packages = [
      pkgs.eagle
      pkgs.kicad
      pkgs.freecad
      pkgs.blender
    ];
    services.flatpak.packages = lib.mkIf (systemConfig.services.flatpak.enable || false) [
      "com.ultimaker.cura"
    ];
  };
}