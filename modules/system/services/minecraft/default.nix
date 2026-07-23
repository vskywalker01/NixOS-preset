{config, lib, pkgs, ...}:
let 
    server-port = 25250;
    rcon-port = 25251;
    rcon-pass = "supersecret-password";
    wakecommand = lib.optionalString config.services.minecraft-server.proxy.enableWol "${pkgs.wakeonlan}/bin/wakeonlan ${config.services.minecraft-server.proxy.server-mac}";

    inhibitScript = pkgs.writeShellScript "minecraft-inhibit" ''
        set -eu

        while true; do
            players="$(
                ${pkgs.mcrcon}/bin/mcrcon \
                -H 127.0.0.1 \
                -P ${toString rcon-port} \
                -p ${rcon-pass} \
                "list" 2>/dev/null || true
            )"

            if echo "$players" | grep -Eq "There are [1-9][0-9]*"; then
                if ! ${pkgs.procps}/bin/pgrep -f "systemd-inhibit.*Minecraft" >/dev/null; then
                    ${pkgs.systemd}/bin/systemd-inhibit \
                    --what=sleep \
                    --who="Minecraft" \
                    --why="Minecraft players online" \
                    ${pkgs.coreutils}/bin/sleep infinity &
                fi
            else
                ${pkgs.procps}/bin/pkill -f "systemd-inhibit.*Minecraft" || true
            fi

            sleep 60
        done
    ''; 
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
        systemd.services.minecraft-inhibit = {
              description = "Minecraft sleep inhibitor";

              wantedBy = [ "minecraft.service" ];

              after = [
                    "minecraft.service"
              ];

              serviceConfig = {
                    User = "root";
                    ExecStart = inhibitScript;
                    Restart = "always";
              };
        };

        environment = lib.mkIf (config.services.minecraft-server.enable || config.services.minecraft-server.proxy.enable) { 
            systemPackages = [
                pkgs.wakeonlan
                pkgs.mcron 
                pkgs.lazymc 
            ];
            etc."lazymc/config.toml" = lib.mkIf (config.services.minecraft-server.proxy.enable) {
                text =
                ''
                    [server]
                    directory = "."
                    command = "${wakecommand}" 
                    address = "${config.services.minecraft-server.proxy.server}:${toString server-port}"

                    [public]
                    bind = "0.0.0.0:25565"
                    
                    [motd]
                    sleeping = "Sfinfirinx no poskys"
                    starting = "Sfinfirinx poskys?"
                    stopping = "sfinfirinx poskys?"
                    from_server = false

                    [join]
                    methods = [   
                        "hold",
                    ]
                    
                    [join.kick]
                    
                    [join.hold]
                    timeout = 180
                    
                    [join.forward]

                    [join.lobby]

                    [lockout]

                    [time]

                    [rcon]
                    address = "${config.services.minecraft-server.proxy.server}:${toString rcon-port}"
                    password = "${rcon-pass}"

                    [advanced]

                    [config]
                    version = "0.2.11"
                '';
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
