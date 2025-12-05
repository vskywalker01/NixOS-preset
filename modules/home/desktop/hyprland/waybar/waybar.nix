{config, lib, pkgs, systemConfig ? {} ,flake-inputs, ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.waybar = {
            enable=true;
            package=pkgs.waybar;
        };
        xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
        xdg.configFile."waybar/style.css".source = ./style.css;
    };

}

