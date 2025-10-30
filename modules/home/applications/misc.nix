{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.applications = {
    misc = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include misc applications in home configuration";
    };
  };
  config = lib.mkIf (config.applications.misc) {
    home.packages = [
      pkgs.bottles
      unstable.calibre
      pkgs.filezilla
      pkgs.termius
      pkgs.onlyoffice-desktopeditors
      pkgs.rnote
      pkgs.gimp 
      pkgs.drawio
      pkgs.zoom-us
      pkgs.woeusb-ng
      pkgs.krita
    ];
   

  };

}