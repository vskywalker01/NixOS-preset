{config, lib, pkgs, ...}:
let
    velocityDir = "/var/lib/velocity";
in {
    options.services.velocity = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable velocity reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the minecraft server";
        };
        
    };

    config = lib.mkIf (config.services.velocity.enable) {
        environment.systemPackages = with pkgs; [
            jdk21
            wakeonlan
            velocity
        ];
        systemd.tmpfiles.rules = [
            "d ${velocityDir} 0750 velocity velocity -"
        ];

        users.users.velocity = {
            isSystemUser = true;
            group = "velocity";
            home = velocityDir;
        };

        users.groups.velocity = {};

        systemd.services.velocity = {
            description = "Minecraft Velocity Proxy";

            wantedBy = [ "multi-user.target" ];

            after = [ 
                "network-online.target" 
                "velocity-setup.service"
            ];
            wants = [ "network-online.target" ];

            serviceConfig = {
                User = "velocity";
                WorkingDirectory = velocityDir;

                ExecStart = ''
                    ${pkgs.jdk21}/bin/java \
                    -Xms512M \
                    -Xmx1G \
                    -jar ${pkgs.velocity}/share/velocity/velocity.jar
                '';

                Restart = "always";
            };
        };
        networking.firewall.allowedTCPPorts = [
            25565
        ];
        systemd.services.velocity-setup = {
            wantedBy = [ "multi-user.target" ];
            before = [
                "velocity.service"
            ];
            serviceConfig.Type = "oneshot";
            script = ''
                cat > ${velocityDir}/velocity.toml <<'EOF'
                    config-version = "2.7"
                    bind = "0.0.0.0:25565"
                    motd = "<green>Server Minecraft"
                    show-max-players = 6
                    online-mode = false
                    player-info-forwarding-mode = "modern"
                    forwarding-secret-file = "${velocityDir}/forwarding.secret"

                    [servers]
                    minecraft = "${config.services.velocity.server}:25250"

                    try = [
                        "minecraft"
                    ]

                    [forced-hosts]
                EOF

                chown velocity:velocity ${velocityDir}/velocity.toml
                


                if [ ! -e ${velocityDir}/forwarding.secret ]; then
                    ${pkgs.openssl}/bin/openssl rand -hex 32 \
                    > ${velocityDir}/forwarding.secret
                fi

                chown velocity:velocity ${velocityDir}/forwarding.secret
                chmod 0400 ${velocityDir}/forwarding.secret
            '';
        }; 
   }; 
}
