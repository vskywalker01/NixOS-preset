{config, lib, pkgs,flake-inputs, systemConfig ? {},...}:

{
  options.applications = {
    gaming = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include gaming applications in home configuration";
    };
  };
  config = lib.mkIf (config.applications.gaming) {
    nixpkgs.config.allowUnfree = lib.mkForce true;
    home.packages = [
      pkgs.discord    
      pkgs.r2modman
    ];
    #services.flatpak.packages = lib.mkIf (systemConfig.services.flatpak.enable || false) [
    #  "io.github.unknownskl.greenlight"
    #  "net.studio08.xbplay"
    #];
  };
}

