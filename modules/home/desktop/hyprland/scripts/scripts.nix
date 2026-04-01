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
    xdg.configFile."hypr/scripts/get-power-status.sh" = {
        source = ./get-power-status.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/set-power-status.sh" = {
        source = ./set-power-status.sh;
        executable = true;
    };

    xdg.configFile."hypr/scripts/get-fan-speeds.sh" = {
        source = ./get-fan-speeds.sh;
        executable = true;
    };
         
}
