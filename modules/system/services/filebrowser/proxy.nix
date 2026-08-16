{config, lib, pkgs, ...}:
{
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
        port = lib.mkOption {
            type = lib.types.int; 
            default = config.services.filebrowser.settings.port;
            description = "port of the server";
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
    config = lib.mkIf (config.services.filebrowser.proxy.enable) {
        services.caddy =  {
            enable = true;
            virtualHosts."${config.services.filebrowser.proxy.domain}".extraConfig = ''
                tls internal
                reverse_proxy ${config.services.filebrowser.proxy.server}:${toString config.services.filebrowser.proxy.port}
            ''
            + lib.optionalString config.services.filebrowser.proxy.enableWol ''
                handle_errors {
                    @502 expression {err.status_code} == 502
                    handle @502 {
                        wake_on_lan ${config.services.filebrowser.proxy.server-mac}
                        reverse_proxy ${config.services.filebrowser.proxy.server}:${toString config.services.filebrowser.proxy.port} {
                            lb_try_duration 120s
                        }
                    }
                }
            '';
        };
    };
}
