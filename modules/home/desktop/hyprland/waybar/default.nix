{config, lib, pkgs, systemConfig ? {} ,flake-inputs, ...}:
{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.waybar = {
            enable=true;
            package=pkgs.waybar;
        };
        xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
        xdg.configFile."waybar/style.css".source = ./style.css;
        home.activation.reloadWaybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ${pkgs.procps}/bin/pkill -SIGUSR2 waybar || true
        '';
        systemd.user.services.waybar = {
            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${pkgs.waybar}/bin/waybar";
                Restart = "on-failure";
            };
        };
    };
    
}

