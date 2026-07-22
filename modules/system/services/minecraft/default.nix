{config, lib, pkgs, ...}:
let 
    server-port = 25250; 
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
                motd = "The best minecraft server that I ever created";
                white-list = false;
                allow-cheats = true;
                online-mode = false;
            };
            jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
        };
        services.haproxy = lib.mkIf (config.services.minecraft-server.proxy.enable) {
            enable = true; 
            configs = [
                ''
                frontend minecraft-proxy
                    bind *:25565
                    default_backend minecraft

                backend minecraft
                    server mc ${config.services.minecraft-server.proxy.server}:${toString server-port} check
                ''
            ];
        };
    };     
}
