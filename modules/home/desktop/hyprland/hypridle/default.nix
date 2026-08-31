{config, lib, pkgs, flake-inputs, systemConfig ? {} , ...}:
let 
    unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
        systemd.user.services.hypridle = {
              Install.WantedBy = [ "graphical-session.target" ];

              Unit = {
                    PartOf = [ "graphical-session.target" ];
                    After = [ "graphical-session.target" ];
              };

              Service = {
                    ExecStart = "${unstable.hypridle}/bin/hypridle";
                    Restart = "on-failure";
              };
        };

    };

}
