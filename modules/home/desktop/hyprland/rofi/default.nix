{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."rofi/config.rasi".source = ./config.rasi;
        xdg.configFile."rofi/drun.rasi".source = ./drun.rasi;

        xdg.configFile."hypr/theme/rofiTheme.rasi".text = 
        ''
        * {
            bgBlur: ${config.theme.colors.bgBlurHex};
            bgSolid: ${config.theme.colors.bgSolidHex};
            fgBlur: ${config.theme.colors.fgBlurHex};
            fgSolid: ${config.theme.colors.fgSolidHex};
            fgFocus: ${config.theme.colors.fgFocusHex};
            border: ${config.theme.colors.borderHex};
            borderSelected: ${config.theme.colors.borderSelectedHex}; 
            textNormal: ${config.theme.colors.textNormalHex};
            textError: ${config.theme.colors.textErrorHex};
            textAlert: ${config.theme.colors.textAlertHex};
            textSuccess: ${config.theme.colors.textSuccessHex};
            accent: ${config.theme.colors.accentHex};
        }
        '';


    };

}

