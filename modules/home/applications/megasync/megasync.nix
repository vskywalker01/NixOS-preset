{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.applications = {
    megasync = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include MegaSync in home configuration";
    };
  };
  
  config = lib.mkIf (config.applications.megasync) {
    nixpkgs.config.allowUnfree = lib.mkForce true;
    home.packages = with pkgs; [
      megasync    
    ];

    home.file.".config/autostart/megasync.desktop".source =./megasync.desktop;
  };
}