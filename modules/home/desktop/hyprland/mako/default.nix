{config, lib, pkgs, systemConfig ? {} , ...}:

{
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        services.mako = {
            enable = true;
        
        };
        xdg.configFile."mako/config".text = 
        ''
        font=JetBrains Mono 10
        background-color=${config.theme.colors.bgBlurHex}
        text-color=${config.theme.colors.textNormalHex}
        border-color=${config.theme.colors.borderHex}
        border-size=2
        border-radius=12
        icon-border-radius=12
        default-timeout=5000
        margin=20,20
        padding=16
        width=300
        anchor=top-right 
        max-visible=3
        '';

        systemd.user.services.mako = {
            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${pkgs.mako}/bin/mako";
                Restart = "on-failure";
            };
        };
 
    };

}

