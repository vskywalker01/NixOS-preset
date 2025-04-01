{config, lib, pkgs, inputs, ...}:

with lib;
let 
  cfg = config.gnome;
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.gnome = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "include gnome DE in configuration";
    };
  };
  config = mkIf cfg.enable {
    services.xserver.enable = lib.mkDefault true;
    services.xserver.displayManager.gdm.enable = lib.mkDefault true;
    services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
    services.printing.enable = true;
    environment.gnome.excludePackages = with pkgs; [
      orca
      evince
      # file-roller
      geary
      # gnome-disk-utility
      # seahorse
      # sushi
      # sysprof
      #
      # gnome-shell-extensions
      #
      # adwaita-icon-theme
      # nixos-background-info
      gnome-backgrounds
      # gnome-bluetooth
      # gnome-color-manager
      # gnome-control-center
      # gnome-shell-extensions
      gnome-tour # GNOME Shell detects the .desktop file on first log-in.
      gnome-user-docs
      # glib # for gsettings program
      # gnome-menus
      # gtk3.out # for gtk-launch program
      # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
      # xdg-user-dirs-gtk # Used to create the default bookmarks
      #
      baobab
      epiphany
      #gnome-text-editor
      #gnome-calculator
      #gnome-calendar
      #gnome-characters
      # gnome-clocks
      #gnome-console
      gnome-contacts
      #gnome-font-viewer
      #gnome-logs
      gnome-maps
      gnome-music
      # gnome-system-monitor
      gnome-weather
      # loupe
      # nautilus
      gnome-connections
      #simple-scan
      #snapshot
      totem
      yelp
      gnome-software
    ];
    environment.systemPackages =  [
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.freon
      pkgs.gnomeExtensions.fullscreen-avoider 
      pkgs.gnomeExtensions.top-bar-organizer
      pkgs.gnomeExtensions.gpu-supergfxctl-switch
      pkgs.gnomeExtensions.gamemode-shell-extension
      pkgs.gnome-tweaks
      unstable.whitesur-icon-theme
      unstable.nordzy-icon-theme
      unstable.whitesur-gtk-theme
      pkgs.lm_sensors
      unstable.mission-center
      pkgs.corefonts
    ];    
  };
}

