{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.wlogout={
            enable=true;
            layout = [
                {
                    label= "lock";
                    action = "hyprlock";
                    text="Lock";
                    keybind = "l";
                }
                {
                    label="logout";
                    action="hyprctl dispatch exit 0";
                    text = "Logout";
                    keybind="e";

                }
                {
                    label="hibernate";
                    action="hyprctl hyprlock && systemctl hibernate";
                    text="Hibernate";
                    keybind="i";
                }
                {
                    label="shutdown";
                    action="systemctl poweroff";
                    text ="Shutdown";
                    keybind="s";
                }
                {
                    label="reboot";
                    action="systemctl reboot";
                    text="Reboot";
                    keybind="r";
                }
                {
                    label="suspend";
                    action="systemctl suspend";
                    text="Suspend";
                    keybind="u";
                }
            ];
            style = ''
                @import url("../hypr/theme/mainTheme.css");
                * {
                    background-image:none;
                    box-shadow: none;
                }
                window {
                    border-radius: 0;
                    border-color: @border;
                    text-decoration-color: @textNormal;
                    color: @textNormal;
                    background-color: @fgFocus;

                }
                button {
                    background-repeat: no-repeat;
                    background-position: center;
                    background-size: 20%;
                    background-color: transparent;
                    border: 4px solid rgba(0,0,0,0); 
                    animation: gradient_f 20s ease-in infinite;
                    transition: all 0.3s ease-in;
                    box-shadow: 0 0 10px 2px transparent;
                    border-radius: 16px;
                    margin: 10px;
                }

                button:focus {
                    box-shadow: none;
                    background-size: 20%;
                }

                button:hover {
                    background-size: 40%;
                    background-color: transparent;
                    color: @textNormal;
                    transition: all 0.3s cubic-bezier(0.55,0.5,0.22,1.682), box-shadow 0.5s ease-in;
                    border: 4px solid @border;

                }

                #lock {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/lock.svg"));
                }
                #logout {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/logout.svg"));
                }
                #reboot {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/reboot.svg"));

                }
                #shutdown {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/shutdown.svg"));
                }
                #suspend {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/suspend.svg"));
                }
                #hibernate {
                    background-image: image(url("${config.home.homeDirectory}/.config/hypr/theme/icons/logout/hibernate.svg"));
                }
            '';
        };
    };

}

