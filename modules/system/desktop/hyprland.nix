{config, lib, pkgs, inputs, ...}:
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
        services.upower.enable = true;
        services.system-config-printer.enable = lib.mkDefault true;
        programs.system-config-printer.enable = lib.mkDefault true;
        services.gvfs.enable = true;
        security.polkit.enable = true;
        environment.systemPackages = [
            pkgs.libsForQt5.qt5ct
            pkgs.grim 
            pkgs.slurp
            pkgs.wl-clipboard
            pkgs.cliphist
            unstable.waybar
            pkgs.kitty
            pkgs.hyprpolkitagent
            pkgs.rofi
            pkgs.rofi-bluetooth
            pkgs.rofi-systemd
            pkgs.rofi-network-manager
            pkgs.rofi-pulse-select
            pkgs.nautilus
            pkgs.nautilus-open-in-blackbox
            pkgs.nautilus-open-any-terminal
            pkgs.libheif
            pkgs.libheif.out
            pkgs.gnome-disk-utility
            pkgs.pulseaudio 
            pkgs.hyprlock
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-wlr
            pkgs.nwg-displays
            pkgs.pavucontrol
            pkgs.networkmanagerapplet
            pkgs.wlogout
            pkgs.upower
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
            pkgs.brightnessctl
            pkgs.lm_sensors
            pkgs.hyprsunset
            pkgs.file-roller
            pkgs.libinput
        ];   
        environment.pathsToLink = [ "share/thumbnailers" ];

        services.xserver.excludePackages = [
            pkgs.xterm
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
        services.udisks2.enable = true;     
        hardware.opentabletdriver.enable = true;
        hardware.uinput.enable = true;
        boot.kernelModules = [ "uinput" ];
        hardware.opentabletdriver.blacklistedKernelModules = [ "hid-uclogic" "wacom" ];
        };
}

