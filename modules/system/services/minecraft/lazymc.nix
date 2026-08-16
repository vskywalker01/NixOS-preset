{config, lib, pkgs,inputs, ...}:
let 
    wakecommand = lib.optionalString config.services.minecraft-server.proxy.enableWol "${pkgs.wakeonlan}/bin/wakeonlan ${config.services.minecraft-server.proxy.server-mac}";
 
    lazymcConfig= ''
        [server]
        directory = "."
        command = "${wakecommand}" 
        address = "${toString config.services.minecraft-server.proxy.server}:${toString config.services.minecraft-server.proxy.port}"

        [public]
        bind = "0.0.0.0:25565"
        version = "26.2"
        
        [motd]
        sleeping = "Server inactive (join to wake up)"
        starting = "Starting server..."
        stopping = "Stopping server..."
        from_server = false

        [join]
        methods = [   
            "hold",
            "kick",
        ]
        
        [join.kick]
        starting = "The server is starting...\n\nPlease try to reconnect after few minutes."
        stopping = "The server is going to sleep...\n\nPlease try to reconnect after few minutes to wake it again."

        [join.hold]
        timeout = 600
        
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
        port = lib.mkOption {
            type = lib.types.int; 
            default = 25565;
            description = "port of the server";
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
                pkgs.lazymc
                pkgs.mcrcon
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
        
    };     
}
