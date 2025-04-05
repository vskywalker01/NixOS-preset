{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:

let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.applications = {
    videoEditing = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include video editing tools in home configuration";
    };
  };
  config = lib.mkIf (config.applications.videoEditing) {
    home.packages = [
      pkgs.obs-studio
      pkgs.audacity
      pkgs.lightworks
      pkgs.handbrake
    ];
    services.flatpak.packages = lib.mkIf (systemConfig.services.flatpak.enable || false) [
      "com.ultimaker.cura"
    ];
  };
}