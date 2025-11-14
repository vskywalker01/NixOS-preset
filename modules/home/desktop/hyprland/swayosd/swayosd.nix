{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        services.swayosd = {
            enable = true;
        };
        xdg.configFile."swayosd/style.scss".source = ./style.scss;
    };
}
