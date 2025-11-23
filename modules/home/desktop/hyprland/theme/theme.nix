{config, lib, pkgs, systemConfig ? {} ,flake-inputs, ...}:

{
    options.theme.colors = lib.mkOption {
        type = lib.types.attrs; 
        description = "Custom scheme color for hyprland environment";
        default = {
            bgBlur         = "rgba(25,25,25,0.6)";
            bgBlurHex      = "#19191999";

            bgSolid        = "rgba(25,25,25,1)";
            bgSolidHex     = "#191919FF";
            
            fgBlur         = "rgba(202,210,197,0.6)";
            fgBlurHex      = "#CAD2C599";
        
            fgSolid        = "rgba(202,210,197,1)";
            fgSolidHex     = "#CAD2C5FF";
        
            fgFocus        = "rgba(25,25,25,0.3)";
            fgFocusHex     = "#1919194D";
            
            border         = "rgba(255,251,254,0.8)";
            borderHex      = "#FFFBFECC";

            borderSelected = "rgba(52,36,166,0.8)";
            borderSelectedHex = "#3424A6CC";
            
            textNormal     = "rgba(255,255,255,1)";
            textNormalHex  = "#FFFFFFFF";
            
            textError      = "rgba(163,11,55,1)";
            textErrorHex   = "#A30B37FF";
            
            textAlert      = "rgba(250,199,72,1)";
            textAlertHex   = "#FAC748FF";
            
            textSuccess    = "rgba(5,140,66,1)";
            textSuccessHex = "#058C42FF";
            
            accent         = "rgba(52,36,166,1)";
            accentHex      = "#3424A6FF"; 
        };
    };
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/theme/mainTheme.css".text = 
        ''
        @define-color bgBlur ${config.theme.colors.bgBlur};
        @define-color bgSolid ${config.theme.colors.bgSolid};
        @define-color fgBlur ${config.theme.colors.fgBlur};
        @define-color fgSolid ${config.theme.colors.fgSolid};
        @define-color fgFocus ${config.theme.colors.fgFocus};

        @define-color border ${config.theme.colors.border};
        @define-color borderSelected ${config.theme.colors.borderSelected}; 

        @define-color textNormal ${config.theme.colors.textNormal};
        @define-color textError ${config.theme.colors.textError};
        @define-color textAlert ${config.theme.colors.textAlert};
        @define-color textSuccess ${config.theme.colors.textSuccess};
        @define-color accent ${config.theme.colors.accent};
        '';

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

