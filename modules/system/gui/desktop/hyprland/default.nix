{config, lib, pkgs, inputs, ...}:
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = lib.mkIf (config.programs.hyprland.enable) {
        programs.firefox.package = pkgs.firefox-bin;
   
        #enabling xwayland for x11 support
        programs.xwayland.enable = true;
        services.xserver.enable = lib.mkDefault true;

        #services and apps  
        services.printing.enable = lib.mkDefault true;
        services.pipewire.enable = lib.mkDefault true;
        services.blueman.enable = lib.mkDefault true;
        services.power-profiles-daemon.enable= lib.mkDefault true;
        hardware.bluetooth.enable= lib.mkDefault true;
        services.upower.enable = lib.mkDefault true;
        services.system-config-printer.enable = lib.mkDefault true;
        programs.system-config-printer.enable = lib.mkDefault true;
        services.gvfs.enable = lib.mkDefault true;
        security.polkit.enable = lib.mkDefault true;
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        networking.networkmanager.enable=true;
        services.udisks2.enable = true;     
        hardware.opentabletdriver.enable = true;
        hardware.uinput.enable = true;
        boot.kernelModules = [ "uinput" ];
        hardware.opentabletdriver.blacklistedKernelModules = [ "hid-uclogic" "wacom" ];
        security.rtkit.enable = true;
        programs.firefox.enable = true;
        
        services.logind = {
            enable = true; 
            settings.Login = {
               IdleAction="suspend-then-hibernate";
               IdleActionSec="20min";
            };
        };
        systemd.sleep.settings.Sleep = {
            HibernateDelaySec = "1h";
            SuspendState = "mem";
        };
        boot.kernelParams = ["mem_sleep_default=deep"];

        #required packages
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
            unstable.nwg-displays
            pkgs.pavucontrol
            pkgs.networkmanagerapplet
            pkgs.wlogout
            pkgs.upower
            pkgs.awww
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
            pkgs.moonlight-qt
            pkgs.vlc
            unstable.easyeffects
        ];  

        environment.pathsToLink = [ "share/thumbnailers" ];
        

        #excluding xterm (kitty is a good replacement for hyprland) 
        services.xserver.excludePackages = [
            pkgs.xterm
        ]; 

        xdg.portal = {
            enable = true;
            wlr.enable = true;
            extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
        };
        
        #adding hyprland in the session manager
        services.displayManager.sessionPackages = [pkgs.hyprland];
        services.displayManager.defaultSession = "hyprland-uwsm";
        programs.hyprland.withUWSM = true;
    };
}

