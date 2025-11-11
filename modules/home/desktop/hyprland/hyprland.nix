{config, lib, pkgs, systemConfig ? {} , ...}:

{
    imports = [
        ./waybar/waybar.nix
        ./scripts/scripts.nix
        ./wlogout/wlogout.nix
        ./hyprlock/hyprlock.nix
    ];
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        home.packages = with pkgs; [
            whitesur-cursors  
            whitesur-gtk-theme
            reversal-icon-theme
        ];
        home.sessionVariables = {
            QT_QPA_PLATFORMTHEME = "qt5ct";
        };

        gtk = {
            enable = true;
            theme = {
                name = "WhiteSur-Dark";
                package = pkgs.whitesur-gtk-theme;
            };
            iconTheme = {
                name = "Reversal-dark";
                package = pkgs.reversal-icon-theme;
            };
            cursorTheme = {
                name = "WhiteSur-cursors";
                package = pkgs.whitesur-icon-theme;
                size=24;
            };
        };

        wayland.windowManager.hyprland = {
	    enable=true;
	    package = null;
   	    portalPackage = null;
            settings = {
                "$MOD"="SUPER";
                exec-once = [
                    "waybar"
                    "swww-daemon"
                    "wl-paste --watch cliphist store"
                    "~/.config/hypr/scripts/swww-random.sh"
                ];
                input.kb_layout = "it";
                general = {
                    gaps_in = 2;
                    gaps_out = 5;
                    border_size = 1;
                };
                decoration = {
                    rounding = 5;
                    blur = {
                        enabled = true;
                        size = 6;
                        passes = 3;
                    };
                
                };
		        bind = [
		            "$MOD, T, exec, kitty"
                    "$MOD, D, exec, rofi -show drun"
                    "$MOD, Q, killactive"
                    "$MOD, F, fullscreen"
                    "$MOD, SPACE, togglefloating"
                    "$MOD, h/j/k/l, movefocus, l/d/u/r"
                    "$MOD SHIFT,h/j/k/l, movewindow, l/d/u/r"
                    "$MOD SHIFT,1,movetoworkspace,1"
                    "$MOD SHIFT,2,movetoworkspace,2"
                    "$MOD SHIFT,3,movetoworkspace,3"
                    "$MOD SHIFT,4,movetoworkspace,4"
                    "$MOD,1,workspace,1"
                    "$MOD,2,workspace,2"
                    "$MOD,3,workspace,3"
                    "$MOD,4,workspace,4"
                    "$MOD,E,exec,nautilus"
                    "$MOD,B,exec,firefox"
                    "$MOD,L,exec,hyprlock"
                    "$MOD SHIFT, R, exec, hyprctl reload"
                    "$MOD, ESCAPE, exit"
                    
                    ",PRINT,exec,grim -g '$(slurp)'"

                ];
                binde = [
                    ",XF86AudioRaiseVolume, exec, pamixer -i 5"
                    ",XF86AudioLowerVolume, exec, pamixer -i 5"
                    ",XF86AudioMute, exec, pamixer -t"
                    #",XF86,MonBrightnessUp, exec, brightnessctl set +5%"
		            #",XF86,MonBrightnessDown, exec, brightnessctl set -5%"
                ];
                bindm = [
                    "$MOD, mouse:272, movewindow"
                    "$MOD, mouse:273, resizewindow"
                ];
                layerrule = [
                    "blur, logout_dialog"
                ];
            };
        };
    };
}
