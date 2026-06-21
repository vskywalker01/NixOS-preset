{config, lib, pkgs, systemConfig ? {} ,flake-inputs, ...}:

{
    #color accents for systemwide themes (used heavily on hyprland) 

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
        
            #
            fgSolid        = "rgba(202,210,197,1)";
            fgSolidHex     = "#CAD2C5FF";
        
            fgFocus        = "rgba(25,25,25,0.3)";
            fgFocusHex     = "#1919194D";
            
            border         = "rgba(255,251,254,0.8)";
            borderHex      = "#FFFBFECC";
            borderWidth    = "2";

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
}

