{config, lib, pkgs, ...}:
let 
    server-port = 25250;
    rcon-port = 25251;
    rcon-pass = "supersecret-password";
    wakecommand = lib.optionalString config.services.filebrowser.proxy.enableWol "wakeonlan ${config.services.minecraft-server.proxy.server-mac}";
    
in {
    options.services.minecraft-server.proxy = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable minecraft server reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the server";
        };
        enableWol = lib.mkOption {
            type = lib.types.bool; 
            default = false; 
            description = "wake on lan when required";
        };
        server-mac = lib.mkOption {
            type = lib.types.str; 
            default = "00:00:00:00:00:00";
            description = "mac address of the server (for wake on lan)";
        };
    };
    config = {
        services.minecraft-server = lib.mkIf (config.services.minecraft-server.enable) { 
            eula = true; 
            declarative = true;
            serverProperties = {
                server-port = server-port;
                difficulty = 3;
                gamemode = 0;
                max-players = 6;
                motd = "Sfinfirinx poskys!";
                white-list = false;
                allow-cheats = true;
                online-mode = false;
                enable-rcon = true;
                "rcon.port" = rcon-port;
                "rcon.password" = rcon-pass;
            };
            jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
        };
        environment = lib.mkIf (config.services.minecraft-server.enable || config.services.minecraft-server.proxy.enable) { 
            systemPackages = [
                pkgs.wakeonlan
                pkgs.mcron 
                pkgs.lazymc 
            ];
            etc."lazymc/config.toml".text = lib.mkIf (config.services.minecraft-server.proxy.enable) 
            ''
                [server]
                directory = "."
                command = "${wakecommand}" 
                address = "${config.services.minecraft-server.proxy.server}:${toString server-port}"

                [public]
                bind = "0.0.0.0:25565"
                
                [motd]
                sleeping = "Sfinfirinx poskys -> no"
                starting = "Sfinfirinx poskys -> yes"
                stopping = "sfinfirinx poskys -> forse"
                from_server = false

                [join]
                methods = [   
                    "hold",
                ]
                
                [join.kick]
                
                [join.hold]
                timeout = 25
                
                [join.forward]

                [join.lobby]

                [lockout]

                [time]

                [rcon]

                [advanced]

                [config]
                version = "0.2.11"
            '';
        };
        systemd.services.minecraft-suspend-lock = lib.mkIf (config.services.minecraft-server.enable) {
            description = "Disable suspend while Minecraft players are online";

            wantedBy = [
                "multi-user.target"
            ];

            after = [
                "minecraft-server.service"
            ];

            serviceConfig = {
                ExecStart = ''
                    #!/bin/sh
                    RCON_PASSWORD="${rcon-pass}"
                    RCON_PORT=${toString rcon-port}

                    while true; do
                        PLAYERS=$(
                            mcrcon \
                              -H 127.0.0.1 \
                              -P $RCON_PORT \
                              -p "$RCON_PASSWORD" \
                              "list" |
                            grep -o '[0-9]\+ player' |
                            cut -d' ' -f1
                        )

                        if [ "${PLAYERS:-0}" -gt 0 ]; then
                            if ! systemd-inhibit --list | grep -q minecraft; then
                                systemd-inhibit \
                                  --what=sleep \
                                  --mode=block \
                                  --why="Minecraft player connected" \
                                  &
                            fi
                        else
                            pkill -f "systemd-inhibit.*Minecraft player"
                        fi

                        sleep 30
                    done
                '';
                Restart = "always";
            };
        };
        systemd.tmpfiles.rules = lib.mkIf (config.services.minecraft-server.proxy.enable) [
            "d /var/lib/lazymc 0750 root root -"
        ];
        systemd.services.lazymc =lib.mkIf (config.services.minecraft-server.proxy.enable) {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            serviceConfig = {
                ExecStart = "${pkgs.lazymc}/bin/lazymc -c /etc/lazymc/config.toml";
                WorkingDirectory = "/var/lib/lazymc";
                Restart = "always";
            };
            
        }; 
        networking.firewall.allowedTCPPorts = lib.mkIf (config.services.minecraft-server.proxy.enable) [
            25565
        ];
        
    };     
}
