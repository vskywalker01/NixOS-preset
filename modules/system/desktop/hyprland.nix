{config, lib, pkgs, inputs, ...}:
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.programs.hyprland.enable) {
        programs.xwayland.enable = true;
        programs.firefox.package = pkgs.firefox-bin;
        services.xserver.enable = lib.mkDefault true;
        services.printing.enable = lib.mkDefault true;
        services.pipewire.enable = lib.mkDefault true;
        services.blueman.enable = lib.mkDefault true;
        services.power-profiles-daemon.enable= lib.mkDefault true;
        hardware.bluetooth.enable= lib.mkDefault true;
        environment.systemPackages = [
            pkgs.libsForQt5.qt5ct
            pkgs.grim 
            pkgs.slurp
            pkgs.wl-clipboard
            pkgs.cliphist
            unstable.waybar
            pkgs.kitty
            pkgs.rofi-wayland
            pkgs.rofi-bluetooth
            pkgs.rofi-network-manager
            pkgs.rofi-pulse-select
            pkgs.nautilus
            pkgs.pulseaudio 
            pkgs.hyprlock
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-wlr
            pkgs.wdisplays
            pkgs.pavucontrol
            pkgs.networkmanagerapplet
            pkgs.wlogout
            pkgs.upower
            pkgs.gnome-power-manager 
            pkgs.swww
            pkgs.waypaper
            pkgs.mako
            pkgs.hypridle
            pkgs.swayosd
            pkgs.libnotify
            pkgs.mission-center
            pkgs.dex
            pkgs.gnome-calculator
            pkgs.eog 
        ];   
        
        networking.networkmanager.enable=true;
        xdg.portal = {
            enable = true;
            wlr.enable = true;
            extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
        };
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
        services.displayManager.sessionPackages = [pkgs.hyprland];
        services.displayManager.defaultSession = "hyprland";
    };
}

