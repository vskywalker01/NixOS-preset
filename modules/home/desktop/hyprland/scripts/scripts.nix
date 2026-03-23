{config, lib, pkgs, systemConfig ? {} , ...}:

{
    xdg.configFile."hypr/scripts/slurp.sh" = {
        text =
        ''
        #!/usr/bin/env bash

        grim -g "$(slurp -c '${config.theme.colors.borderHex}' -b '${config.theme.colors.bgBlurHex}' -w ${config.theme.colors.borderWidth})" - | wl-copy --type image/png
        notify-send "Screenshot saved in the clipboard"
        '';
       executable = true;
    };
    xdg.configFile."hypr/scripts/supergfxctl-get.sh" = {
        source = ./supergfxctl-get.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/supergfxctl-set.sh" = {
        source = ./supergfxctl-set.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/fan-speeds.sh" = {
        source = ./fan-speeds.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/cpu-fan-speed.sh" = {
        source = ./cpu-fan-speed.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/gpu-fan-speed.sh" = {
        source = ./gpu-fan-speed.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/gpu-status.sh" = {
        source = ./gpu-status.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/settings.sh" = {
        source = ./settings.sh;
        executable = true;
    };
     
    

}
