{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        services.swayosd = {
            enable = true;
            stylePath = "${config.home.homeDirectory}/.config/swayosd/style.scss";
        };
        xdg.configFile."swayosd/style.scss".text = 
        ''
        window#osd {
            padding: 12px 20px;
            border-radius: 999px;
            border: 2px solid ${config.theme.colors.border};
            background: ${config.theme.colors.bgBlur}; 
            }
        window#osd #container {
            margin: 16px; }
            window#osd image,
            window#osd label {
            color: ${config.theme.colors.textNormal}; 
        }
        window#osd progressbar:disabled,
        window#osd image:disabled {
            opacity: 0.5; 
        }
        window#osd progressbar {
            min-height: 6px;
            border-radius: 999px;
            background: transparent;
            border: none; 
        }
        window#osd trough {
            min-height: inherit;
            border-radius: inherit;
            border: none;
            background: ${config.theme.colors.textNormal}; }
        window#osd progress {
            min-height: inherit;
            border-radius: inherit;
            border: none;
            background: ${config.theme.colors.textNormal}; 
        }
        '';
    };
}
