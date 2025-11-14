{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        services.mako = {
            enable = true;
        
        };
        xdg.configFile."mako/config".source = ./config;
 
    };

}

