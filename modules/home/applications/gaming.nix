{config, lib, pkgs,flake-inputs, ...}:

let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.applications = {
    gaming = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include gaming applications in home configuration";
    };
  };
  config = lib.mkIf (config.applications.gaming) {
    home.packages = [
      pkgs.discord    
      pkgs.r2modman
      unstable.suyu
    ];
  };
}