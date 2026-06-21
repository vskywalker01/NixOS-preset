{config, lib, pkgs, systemConfig ? {} , ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
        systemd.user.services.hypridle = {
              Install.WantedBy = [ "graphical-session.target" ];

              Unit = {
                    PartOf = [ "graphical-session.target" ];
                    After = [ "graphical-session.target" ];
              };

              Service = {
                    ExecStart = "${pkgs.hypridle}/bin/hypridle";
                    Restart = "on-failure";
              };
        };

    };

}
