{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
    };
}
