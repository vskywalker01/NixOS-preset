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
                * {
                    background-image:none;
                    box-shadow: none;
                }
                window {
                    border-radius: 0;
                    border-color: white;
                    text-decoration-color: white;
                    color: white;
                    background-color: rgba (25,25,25, 0.1);

                }
                button {
                    background-repeat: no-repeat;
                    background-position: center;
                    background-size: 20%;
                    border: 3px solid rgba (25,25,25,0);
                    animation: gradient_f 20s ease-in infinite;
                    transition: all 0.3s ease-in;
                    box-shadow: 0 0 10px 2px transparent;
                    border-radius: 16px;
                    margin: 10px;
                    background-color: rgba(25,25,25,0.2);
                }

                button:focus {
                    box-shadow: none;
                    background-size: 20%;
                }

                button:hover {
                    background-size: 40%;
                    background-color: rgba(25,25,25,0.6);
                    color: transparent;
                    transition: all 0.3s cubic-bezier(0.55,0.5,0.22,1.682), box-shadow 0.5s ease-in;
                    border: 3px solid rgba(255,255,255,0.6);

                }

                #lock {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/lock.svg"));
                }
                #logout {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/logout.svg"));
                }
                #reboot {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/reboot.svg"));
                }
                #shutdown {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/shutdown.svg"));
                }
                #suspend {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/suspend.svg"));
                }
                #hibernate {
                    background-image: image(url("${pkgs.wleave}/share/wleave/icons/hibernate.svg"));
                }




            '';
        };
        home.packages = [pkgs.wleave];

    };

}

