{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:

{
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
      pkgs.shotcut
      pkgs.handbrake
    ];
    services.flatpak.packages = lib.mkIf (systemConfig.services.flatpak.enable || false) [
      "com.github.wwmm.easyeffects"
    ];
  };
}
