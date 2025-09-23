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
      pkgs.corefonts 
      pkgs.zoom-us
      pkgs.woeusb-ng
    ];
    home.activation.installfonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${config.xdg.dataHome}/fonts"
      cp -n ${pkgs.corefonts}/share/fonts/truetype/* "${config.xdg.dataHome}/fonts/"
      ${pkgs.fontconfig}/bin/fc-cache -f "${config.xdg.dataHome}/fonts"
    '';

  };

}