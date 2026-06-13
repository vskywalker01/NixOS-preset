{config, lib, pkgs, systemConfig ? {} , ...}:
let
    lua = lib.generators.mkLuaInline; 
in {
    imports = [
        ./waybar
        ./scripts
        ./wlogout
        ./hyprlock
        ./rofi
        ./mako
        ./swayosd
        ./hypridle
        ./hyprsunset
    ];
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {

        #adding theme packages 
        home.packages = with pkgs; [
            whitesur-cursors  
            whitesur-gtk-theme
            colloid-gtk-theme
            catppuccin-qt5ct 
            reversal-icon-theme
        ];

        #services used for automount devices 
        services.udiskie = {
            enable = true;
            automount = true;
            notify = true;
            tray = "always";
        };

        home.sessionVariables = {
            QT_QPA_PLATFORMTHEME = "gtk3";
        };

        #assigning cursor theme
        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.whitesur-cursors;
            name = "WhiteSur-cursors";
            size = 16;
        }; 

        #gtk theming
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

        #qt theming
        qt = {
            enable = true;
            platformTheme.name = "gtk3";
            style.name = "adwaita-dark";
        };

        #defining css color scheme 
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
 
        
        wayland.windowManager.hyprland = {
            enable=true;
            package = null;
            systemd.enable = false;
            portalPackage = null;
            configType = "lua";
            extraConfig = ''
                
                hl.env("XCURSOR_SIZE", "24")
                hl.env("HYPRCURSOR_SIZE", "24")
                hl.env("XCURSOR_THEME","WhiteSur-cursors")
                hl.env("AQ_NO_MODIFIERS","1")
                hl.env("WLR_RENDERER","vulkan")
                require("monitors");
                require("workspaces");

                hl.config({
                    general = {
                        gaps_in  = 2,
                        gaps_out = 8,
                        border_size = 2,
                        resize_on_border = false,
                        layout = "dwindle",
                    },

                    decoration = {
                        rounding       = 12,
                        active_opacity   = 1.0,
                        inactive_opacity = 1.0,

                        shadow = {
                            enabled      = false,
                            range        = 4,
                            render_power = 3,
                            color        = 0xee1a1a1a,
                        },

                        blur = {
                            enabled   = true,
                            size      = 9,
                            passes    = 3,
                            vibrancy  = 0.1696,
                            new_optimizations = true,
                            ignore_opacity = false,
                            special = true, 
                            popups = true, 
                        },
                    },
                    input = {
                        kb_layout = "it",
                        sensitivity = -0.2,
                        natural_scroll = false,
                        touchpad = {
                            natural_scroll = true,
                            disable_while_typing = true, 
                            tap_to_click = true,
                        };
                    };
                    
                    cursor = {
                        sync_gsettings_theme = true,
                        no_break_fs_vrr = 1,
                        enable_hyprcursor = true, 
                    };
                })

                local mod = "CTRL + SHIFT"
                hl.bind(mod .. "+ Q", hl.dsp.window.close())
                hl.bind(mod .. "+ T", hl.dsp.exec_cmd("kitty"))
                hl.bind(mod .. "+ N", hl.dsp.exec_cmd("nautilus"))
                hl.bind(mod .. "+ D", hl.dsp.exec_cmd("rofi -show drun -theme=~/.config/rofi/drun.rasi"))
                hl.bind(mod .. "+ O", hl.dsp.exec_cmd("xdg-open http://localhost:8080"))

                hl.bind(mod .. "+ F", hl.dsp.window.fullscreen())
                hl.bind(mod .. "+ SPACE", hl.dsp.window.float({ action = "toggle" }))
                for i = 1, 10 do
                    local key = i % 10 -- 10 maps to key 0
                    hl.bind(mod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
                end


                hl.bind(mod .. "+ LEFT", hl.dsp.focus({ workspace = "-1" }))
                hl.bind(mod .. "+ RIGHT", hl.dsp.focus({ workspace = "+1" }))
                hl.bind(mod .. "+ L", hl.dsp.window.move({ workspace = "-1" }))
                hl.bind(mod .. "+ R", hl.dsp.window.move({ workspace = "+1" }))

                hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true })
                hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),      { locked = true, repeating = true })
                hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),     { locked = true, repeating = true })
                hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
                hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness raise"),                  { locked = true, repeating = true })
                hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness lower"),                  { locked = true, repeating = true })

                hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
                hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
                hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
                hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
                hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
                hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

                hl.window_rule({match = {class = "^(kitty)$"}, opacity = 0.85})
                hl.layer_rule({match = {class = "^(logout_dialog)$"}, blur = true, ignore_alpha = 0.4})
                hl.layer_rule({match = {class = "^(notifications)$"}, blur = true, ignore_alpha = 0.4})
                hl.layer_rule({match = {class = "^(rofi)$"}, blur = true, ignore_alpha = 0.4})
                hl.layer_rule({match = {class = "^(mako)$"}, blur = true, ignore_alpha = 0.4})
                hl.layer_rule({match = {class = "^(slurp)$"}, blur = true, ignore_alpha = 0.4})
                hl.window_rule({match = {class = "^(org.pulseaudio.pavucontrol)$"}, float = true,})
                hl.window_rule({match = {class = "^(.blueman-manager-wrapped)$"}, float = true,})

    
                hl.on("hyprland.start", function () 
                    hl.exec_cmd("waybar")
                    hl.exec_cmd("swww-daemon")
                    hl.exec_cmd("systemctl --user start hyprpolkitagent")
                    hl.exec_cmd("wl-paste --watch cliphist store")
                    hl.exec_cmd("waypaper --restore")
                    hl.exec_cmd("mako")
                    hl.exec_cmd("hypridle")
                    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.scss")
                    hl.exec_cmd("hyprctl setcursor WhiteSur-cursors 20")
                    hl.exec_cmd("dex -a")
                    hl.exec_cmd("hyprsunset")
                end)
            '';
        };
    };
}
