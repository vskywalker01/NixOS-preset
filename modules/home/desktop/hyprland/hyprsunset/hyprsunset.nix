{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/hyprsunset.conf".source = ./hyprsunset.conf;
    };
}
