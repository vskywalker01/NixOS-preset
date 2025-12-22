{config, lib, pkgs, systemConfig ? {} , ...}:

{
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
            QT_QPA_PLATFORMTHEME = "qt5ct";
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
            gtk4.extraConfig = {
            Settings = ''
                    gtk-application-prefer-dark-theme=1
                '';
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
            style.package = pkgs.whitesur-gtk-theme;
        };
        
        wayland.windowManager.hyprland = {
	    enable=true;
	    package = null;
   	    portalPackage = null;
            settings = {
                "$MOD"="CTRL_SHIFT";
                exec-once = [
                    "waybar"
                    "swww-daemon"
                    "wl-paste --watch cliphist store"
                    "waypaper --restore"
                    "mako"
                    "hypridle"
                    "swayosd-server -s ~/.config/swayosd/style.scss"
                    "hyprctl setcursor WhiteSur-cursors 20"
                    "dex -a"
                    "hyprsunset"
                                    
                ];
                input.kb_layout = "it";
                general = {
                    gaps_in = 2;
                    gaps_out = 5;
                    border_size = 1;
                };
                decoration = {
                    rounding = 12;
                    blur = {
                        enabled = true;
                        size = 6;
                        passes = 3;
                        new_optimizations = true;
                    };
                
                };
		        bind = [
		            "$MOD, T, exec, kitty"
                    "$MOD, D, exec, rofi -show drun -theme=~/.config/rofi/drun.rasi"
                    "$MOD, Q, killactive"
                    "$MOD, F, fullscreen"
                    "$MOD, SPACE, togglefloating"
                    "$MOD, h/j/k/l, movefocus, l/d/u/r"
                    "$MOD, right,movetoworkspace,+1"
                    "$MOD, left,movetoworkspace,-1"

                    "$MOD,1,workspace,1"
                    "$MOD,2,workspace,2"
                    "$MOD,3,workspace,3"
                    "$MOD,4,workspace,4"
                    "$MOD,5,workspace,5"
                    "$MOD,6,workspace,6"
                    "$MOD,7,workspace,7"
                    "$MOD,8,workspace,8"

                    "$MOD,N,exec,nautilus"
                    "$MOD, R, exec, hyprctl reload"

                    ",PRINT,exec,~/.config/hypr/scripts/slurp.sh"


                ];
                binde = [
                    ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
                    ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
                    ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
                    ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
		            ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

                    ",KEY_VOLUMEUP, exec, swayosd-client --output-volume raise"
                    ",KEY_VOLUMEDOWN, exec, swayosd-client --output-volume lower"
                    ",KEY_MUTE, exec, swayosd-client --output-volume mute-toggle"
                    ",KEY_BRIGHTNESSUP, exec, swayosd-client --brightness raise"
		            ",KEY_BRIGHTNESSDOWN, exec, swayosd-client --brightness lower"
                    ",KEY_PROG2,exec,rog-control-center"
                ];
                bindm = [
                    "$MOD, mouse:272, movewindow"
                    "$MOD, mouse:273, resizewindow"
                ];
                layerrule = [
                    "blur, logout_dialog"
                    "blur, notifications"
                    "ignorezero, notifications"
                    "blur, rofi"
                    "blur, mako"
                ];
                windowrulev2 = [
                    "float, class:^(org.pulseaudio.pavucontrol)$" 
                    "float, class:^(.blueman-manager-wrapped)$"
                ];

            };
            extraConfig = ''
                env = XCURSOR_THEME,WhiteSur-cursors
                env = XCURSOR_SIZE,28
                env = HYPRCURSOR_THEME,WhiteSur-cursors
                env = HYPRCURSOR_SIZE,20
                source = ~/.config/hypr/monitors.conf
                source = ~/.config/hypr/workspaces.conf
            '';
        };
    };
}
