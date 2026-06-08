{config, lib, pkgs, systemConfig ? {} , ...}:
let
    lua = lib.generators.mkLuaInline; 
in {
    imports = [
        ./waybar/waybar.nix
        ./scripts/scripts.nix
        ./wlogout/wlogout.nix
        ./hyprlock/hyprlock.nix
        ./rofi/rofi.nix
        ./mako/mako.nix
        ./swayosd/swayosd.nix
        ./hypridle/hypridle.nix
        ./hyprsunset/hyprsunset.nix
        ./theme/theme.nix
    ];
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        home.packages = with pkgs; [
            whitesur-cursors  
            whitesur-gtk-theme
            colloid-gtk-theme
            #colloid-icon-theme
            catppuccin-qt5ct 
            #nordic
            reversal-icon-theme
        ];
        services.udiskie = {
            enable = true;
            automount = true;
            notify = true;
            tray = "always";
        };
        home.sessionVariables = {
            QT_QPA_PLATFORMTHEME = "gtk3";
            GTK_THEME = "Colloid-Dark";            
        };
        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.whitesur-cursors;
            name = "WhiteSur-cursors";
            size = 16;
        }; 
        gtk = {
            enable = true;
            theme = {
                name = "Colloid-Dark";
                package = pkgs.colloid-gtk-theme;
            };
            iconTheme = {
                name = "Reversal-dark";
                package = pkgs.reversal-icon-theme;
            };
            cursorTheme = {
                name = "WhiteSur-cursors";
                package = pkgs.whitesur-cursors;
                size=24;
            };
            gtk4 = {
                extraConfig = {
                    Settings = ''
                        gtk-application-prefer-dark-theme=1
                    '';
                };
                theme = config.gtk.theme;
            };
            gtk3.extraConfig = {
                Settings = ''
                    gtk-application-prefer-dark-theme=1
                '';
            };
        };
        dconf.settings = {
            "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            };
        };
        qt = {
            enable = true;
            platformTheme.name = "gtk3";
            style.package = pkgs.colloid-gtk-theme;
            #style.name = "Catppuccin-Mocha";
        };
        
        wayland.windowManager.hyprland = {
            enable=true;
            package = null;
            portalPackage = null;
            configType = "lua";
            settings = {
                mod = {
                    _var = "CTRL + SHIFT";
                };
                
                config = {
                    general = {
                        gaps_in = 2;
                        gaps_out = 8;
                        border_size = 2;
                    };
                    misc = {
                        vrr = 2;
                    };
                    decoration = {
                        rounding = 12;
                        blur = {
                            enabled = true;
                            size = 9;
                            passes = 3;
                            new_optimizations = true;
                            special = true; 
                            popups= true;
                            ignore_opacity = false;
                        };
                        active_opacity = 1.0;
                    };
                    input = {
                        kb_layout = "it";
                        sensitivity = -0.2;
                        natural_scroll = false;
                        touchpad = {
                            natural_scroll = true;
                            disable_while_typing = true; 
                            tap_to_click = true; 

                        };
                    };
                    window_rule = [
                        {match.class = "kitty"; opacity = 0.8;}
                        {match.class = "logout_dialog"; no_blur = false; }
                        {match.class = "notifications"; no_blur = false; }
                        {match.class = "rofi"; active_opacity = 0.90; }
                        {match.class = "mako"; no_blur = false; }
                        {match.class = "^(org.pulseaudio.pavucontrol)$"; float = true;}
                        {match.class = "^(.blueman-manager-wrapped)$"; float = true;}
                    ];
                    cursor = {
                        sync_gsettings_theme = true;
                        no_break_fs_vrr = 1;
                        enable_hyprcursor = true; 
                    };
                };
                
                bind = [
                    {_args = [(lua "mod .. \" + Q\"")(lua "hl.dsp.window.close()"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + T\"")(lua "hl.dsp.exec_cmd(\"kitty\")"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + N\"")(lua "hl.dsp.exec_cmd(\"nautilus\")"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + C\"")(lua "hl.dsp.exec_cmd(\"gnome-calculator\")"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + D\"")(lua "hl.dsp.exec_cmd(\"rofi -show drun -theme=~/.config/rofi/drun.rasi\")"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + O\"")(lua "hl.dsp.exec_cmd(\"xdg-open http://localhost:8080\")"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + F\"")(lua "hl.dsp.window.fullscreen()"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + SPACE\"")(lua "hl.dsp.window.float({ action = \"toggle\" })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 1\"")(lua "hl.dsp.focus({ workspace = 1 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 2\"")(lua "hl.dsp.focus({ workspace = 2 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 3\"")(lua "hl.dsp.focus({ workspace = 3 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 4\"")(lua "hl.dsp.focus({ workspace = 4 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 5\"")(lua "hl.dsp.focus({ workspace = 5 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 6\"")(lua "hl.dsp.focus({ workspace = 6 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 7\"")(lua "hl.dsp.focus({ workspace = 7 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 8\"")(lua "hl.dsp.focus({ workspace = 8 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + 9\"")(lua "hl.dsp.focus({ workspace = 9 })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + LEFT\"")(lua "hl.dsp.focus({ workspace = \"e-1\" })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + RIGHT\"")(lua "hl.dsp.focus({ workspace = \"e+1\" })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + L\"")(lua "hl.dsp.window.move({ workspace = \"e-1\" })"){ locked = false; }];}
                    {_args = [(lua "mod .. \" + R\"")(lua "hl.dsp.window.move({ workspace = \"e+1\" })"){ locked = false; }];}

                    {_args = [(lua "\"XF86AudioRaiseVolume\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --output-volume raise\")"){ locked = true; repeating = true;}];}
                    {_args = [(lua "\"XF86AudioLowerVolume\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --output-volume lower\")"){ locked = true; repeating = true;}];}
                    {_args = [(lua "\"XF86AudioMute\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --output-volume mute-toggle\")"){ locked = true; repeating = true;}];}
                    {_args = [(lua "\"XF86MonBrightnessUp\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --brightness raise\")"){ locked = true; repeating = true;}];}
                    {_args = [(lua "\"XF86MonBrightnessDown\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --brightness lower\")"){ locked = true; repeating = true;}];}
                    #{_args = [(lua "\"KEY_VOLUMEUP\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --brightness lower\")"){ locked = true; repeating = true;}];} 
                    #{_args = [(lua "\"KEY_VOLUMEDOWN\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --output-volume lower\")"){ locked = true; repeating = true;}];}
                    #{_args = [(lua "\"KEY_MUTE\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --output-volume mute-toggle\")"){ locked = true; repeating = true;}];}
                    #{_args = [(lua "\"KEY_BRIGHTNESSUP\"")(lua "hl.dsp.exec_cmd(\"swayosd-client --brightness raise\")"){ locked = true; repeating = true;}];}
                   # {_args = [(lua "\"KEY_PROG2\"")(lua "hl.dsp.exec_cmd(\"rog-control-center\")"){ locked = true; repeating = true;}];}
                    {_args = [(lua "mod .. \"+ mouse:272\"")(lua "hl.dsp.window.drag()"){ locked = false; mouse= true;}];}
                    {_args = [(lua "mod .. \"+ mouse:273\"")(lua "hl.dsp.window.resize()"){ locked = false; mouse= true;}];}
                ];    
                on = {
                    _args = [
                        "hyprland.start"
                        (lua "function()\n  
                           hl.exec_cmd(\"waybar\")\n
                           hl.exec_cmd(\"swww-daemon\")\n
                           hl.exec_cmd(\"systemctl --user start hyprpolkitagent\")\n
                           hl.exec_cmd(\"wl-paste --watch cliphist store\")\n
                           hl.exec_cmd(\"waypaper --restore\")\n
                           hl.exec_cmd(\"mako\")\n
                           hl.exec_cmd(\"hypridle\")\n
                           hl.exec_cmd(\"swayosd-server -s ~/.config/swayosd/style.scss\")\n
                           hl.exec_cmd(\"hyprctl setcursor WhiteSur-cursors 20\")\n
                           hl.exec_cmd(\"dex -a\")\n
                           hl.exec_cmd(\"hyprsunset\")\n
                        \nend")
                    ];
                }; 
            };
            extraConfig = ''
                hl.env("XCURSOR_THEME","WhiteSur-cursors")
                hl.env("XCURSOR_SIZE","28")
                hl.env("HYPRCURSOR_SIZE","20")
                hl.env("AQ_NO_MODIFIERS","1")
                require("monitors");
                require("workspaces");
            '';
        };
    };
}
