{config, lib, pkgs, inputs, ...}:
let 
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    config = lib.mkIf (config.services.desktopManager.gnome.enable) {
        programs.firefox.package = pkgs.firefox-bin;

        #enable xserver for x11 compatibility
        services.xserver.enable = lib.mkDefault true;
        services.xserver.displayManager.gdm.enable = lib.mkDefault true;
        
        #enable printing service
        services.printing.enable = lib.mkDefault true;
        security.rtkit.enable = true;
        programs.firefox.enable = true;

        #excluding useless packages
        environment.gnome.excludePackages = with pkgs; [
            orca
            evince
            geary
            gnome-backgrounds
            gnome-tour 
            gnome-user-docs
            baobab
            epiphany
            gnome-contacts
            gnome-maps
            gnome-music
            gnome-weather
            gnome-connections
            totem
            yelp
            gnome-software
        ];

        environment.systemPackages =  [
            #extensions for the desktop layout
            pkgs.gnomeExtensions.blur-my-shell
            pkgs.gnomeExtensions.appindicator
            pkgs.gnomeExtensions.caffeine
            pkgs.gnomeExtensions.freon
            pkgs.gnomeExtensions.fullscreen-avoider 
            pkgs.gnomeExtensions.top-bar-organizer
            pkgs.gnomeExtensions.gpu-supergfxctl-switch
            pkgs.gnomeExtensions.gamemode-shell-extension
            pkgs.gnomeExtensions.custom-command-toggle
            pkgs.gnomeExtensions.user-themes
            pkgs.gnomeExtensions.tiling-shell
            pkgs.gnome-tweaks
            pkgs.gnomeExtensions.cronomix

            #icon and themes
            unstable.whitesur-icon-theme
            unstable.nordzy-icon-theme
            unstable.whitesur-gtk-theme

            #tools and utilities
            pkgs.lm_sensors
            pkgs.mission-center
            unstable.vlc
            pkgs.remmina
            pkgs.timeshift
            pkgs.gnome-remote-desktop
            pkgs.easyeffects
            pkgs.vlc
        ];   

        #enaling remote desktop service
        services.gnome.gnome-remote-desktop.enable = true;
        systemd.services.gnome-remote-desktop = {
            wantedBy = [ "graphical.target" ];
        };
        networking.firewall.allowedTCPPorts = [ 3389 ];

        #disabling autologin
        services.displayManager.autoLogin.enable = lib.mkForce false;
        services.getty.autologinUser = lib.mkForce null;
      };
}

