{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/hyprsunset.conf".source = ./hyprsunset.conf;
        systemd.user.services.hyprsunset = {
            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset";
                Restart = "on-failure";
            };
        };

    };
}
