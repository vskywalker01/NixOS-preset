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
        hardware.bluetooth.enable=true;
        environment.systemPackages = with pkgs; [
            libsForQt5.qt5ct
            grim 
            slurp
            wl-clipboard
            cliphist
            waybar
            kitty
            rofi-wayland
            rofi-bluetooth
            pulseaudio 
            hyprlock
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-wlr
            catppuccin-sddm-corners
            wdisplays
            pavucontrol
            networkmanagerapplet
            wlogout
            upower
            gnome-power-manager 
            swww
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
            theme = "catppuccin";
        };
        services.displayManager.sessionPackages = [pkgs.hyprland];
        services.displayManager.defaultSession = "hyprland";
    };
}

