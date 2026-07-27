{config, pkgs, lib, inputs, ...}:
let 
    server-port = 8080; 
in {
    options.services.open-webui.proxy = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable open-webui reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the server";
        };
        domain = lib.mkOption {
            type = lib.types.str; 
            default = "openwebui.skywalker.home";
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
    config = lib.mkIf (config.services.open-webui.proxy.enable) {
        services.caddy = {
            enable = true;
            virtualHosts."${config.services.open-webui.proxy.domain}".extraConfig = ''
                tls internal
                reverse_proxy ${config.services.open-webui.proxy.server}:${toString server-port}
            ''
            + lib.optionalString config.services.open-webui.proxy.enableWol ''
                handle_errors {
                    @502 expression {err.status_code} == 502
                    handle @502 {
                        wake_on_lan ${config.services.open-webui.proxy.server-mac}
                        reverse_proxy ${config.services.open-webui.proxy.server}:${toString server-port} {
                            lb_try_duration 120s
                        }
                    }
                }
            '';
        };

    };
}
