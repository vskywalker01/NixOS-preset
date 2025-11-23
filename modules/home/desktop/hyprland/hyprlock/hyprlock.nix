{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.hyprlock = {
            enable = true;
            package = null;
        };
        xdg.configFile."hypr/hyprlock.conf".text = 
        ''
        background {
            monitor=
            path = screenshot
            blur_passes = 3 
            contrast = 0.8916
            brightness = 0.8172 
            vibrancy = 0.1696 
            vibrancy_darkness = 0.1
        }

        shape {
            monitor = 
            size = 600, 300
            color= ${config.theme.colors.fgFocus}
            rounding = 40
            border_size= 2
            border_color=${config.theme.colors.border}
            rotate =0

            position=0,175
            halign = center
            valign = center
        }

        general {
            grace = 0
        }

        label {
            monitor = 
            text = cmd[update:1000] echo -e "$(date +'%A, %B %d')"
            color = ${config.theme.colors.textNormal}
            font_size = 25
            font_family = JetBrainsMono Nerd Font
            position = 0, 250
            halign = center
            valign = center 
        }

        label {
            monitor = 
            text = cmd[update:1000] echo "<span>$(date +'%I:%M')</span>"
            color = ${config.theme.colors.textNormal}
            font_size = 120 
            font_family =  JetBrainsMono Nerd Font 
            position = 0, 150
            halign = center 
            valign = center 
        }

        shape {
            monitor = 
            size = 450, 175 
            color= ${config.theme.colors.fgFocus}
            rounding = 30
            border_size=2
            border_color=${config.theme.colors.border}
            rotate =0
            xray = false
            position=0,-85
            halign = center
            valign = center
        }
        label {
            monitor = 
            text = cmd[update:1000] echo -e "\uf007 $USER" 
            font_size = 35
            font_family = JetBrainsMono Nerd Font
            position = 0, -50 
            halign = center 
            valign = center 
        }

        input-field {
            monitor = 
            size = 300, 50
            outline_thickness = 2 
            dots_size = 0.2 
            dots_spacing = 0.2 
            dots_center =true
            outer_color = ${config.theme.colors.border}
            inner_color= ${config.theme.colors.fgFocus}
            font_color = ${config.theme.colors.textNormal}
            fail_color = ${config.theme.colors.textError}
            check_color = ${config.theme.colors.accent}
            fade_on_empty =false
            font_family = JetBrainsMono Nerd Font
            hide_input = false
            position = 0, -125
            valign = center 
            halign = center 
        }
        '';


    };

}

