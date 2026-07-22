{config, lib, pkgs, ...}:
let 
    server-port = 5001; 
in {
    options.services.filebrowser.proxy = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable filebrowser reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the server";
        };
        domain = lib.mkOption {
            type = lib.types.str; 
            default = "filebrowser.skywalker.home";
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
        services.filebrowser = lib.mkIf (config.services.filebrowser.enable) {
            settings = {
                root = "/srv/hdd";
                address = "127.0.0.1";
                port = server-port;
            };
        };
        services.caddy = lib.mkIf (config.services.filebrowser.proxy.enable) {
            enable = true;
            virtualHosts."${config.services.filebrowser.proxy.domain}".extraConfig = ''
                tls internal
                reverse_proxy ${config.services.filebrowser.proxy.server}:5001
            ''
            + lib.optionalString config.services.filebrowser.proxy.enableWol ''
                handle_errors {
                    @502 expression {err.status_code} == 502
                    handle @502 {
                        wake_on_lan ${config.services.filebrowser.proxy.server-mac}
                        reverse_proxy ${config.services.filebrowser.proxy.server}:${server-port} {
                            lb_try_duration 120s
                        }
                    }
                }
            '';
        };
    };
}
