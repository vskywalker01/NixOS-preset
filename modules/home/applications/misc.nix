{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

{
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
      pkgs.calibre
      pkgs.filezilla
      pkgs.termius
      pkgs.onlyoffice-desktopeditors
      #pkgs.rnote
      pkgs.gimp 
      pkgs.drawio
      pkgs.zoom-us
      pkgs.woeusb-ng
      pkgs.krita
      pkgs.vlc
    ];
    services.flatpak.packages = lib.mkIf (systemConfig.services.flatpak.enable || false) [
        "com.github.flxzt.rnote"
    ];

   

  };

}
