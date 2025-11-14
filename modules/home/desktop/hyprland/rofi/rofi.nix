{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."rofi/config.rasi".source = ./config.rasi;
        xdg.configFile."rofi/drun.rasi".source = ./drun.rasi;

    };

}

