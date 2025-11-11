{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.hyprlock = {
            enable = true;
            package = null;
        };
        xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;


    };

}

