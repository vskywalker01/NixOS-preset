{config, lib, pkgs,inputs, ...}:
let 
    server-port = 25564;
    rcon-port = 25563;
    rcon-pass = "supersecret-password";

    wakecommand = lib.optionalString config.services.minecraft-server.proxy.enableWol "${pkgs.wakeonlan}/bin/wakeonlan ${config.services.minecraft-server.proxy.server-mac}";
 
    lazymcConfig= ''
        [server]
        directory = "."
        command = "${wakecommand}" 
        address = "${config.services.minecraft-server.proxy.server}:${toString server-port}"

        [public]
        bind = "0.0.0.0:25565"
        version = "26.2"
        
        [motd]
        sleeping = "Server inactive (join to wake up)"
        starting = "Starting server..."
        stopping = "Stopping server..."
        from_server = False

        [join]
        methods = [   
            "hold",
            "kick",
        ]
        
        [join.kick]
        starting = "The server is starting...\n\nPlease try to reconnect after few minutes."
        stopping = "The server is going to sleep...\n\nPlease try to reconnect after few minutes to wake it again."

        [join.hold]
        timeout = 300
        
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
    config = lib.mkIf(config.services.minecraft-server.proxy.enable){ 
        environment = { 
            systemPackages = [
                pkgs.wakeonlan
                pkgs.mcron 
                pkgs.lazymc 
            ];
            etc."lazymc/config.toml".text = lazymcConfig;
        };
        systemd.tmpfiles.rules = [
            "d /var/lib/lazymc 0750 root root -"
        ];
        systemd.services.lazymc = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            serviceConfig = {
                ExecStart = "${pkgs.lazymc}/bin/lazymc -c /etc/lazymc/config.toml";
                WorkingDirectory = "/var/lib/lazymc";
                Restart = "always";
            };
            
        }; 
        networking.firewall.allowedTCPPorts = [
            25565
        ];
    };     
}
