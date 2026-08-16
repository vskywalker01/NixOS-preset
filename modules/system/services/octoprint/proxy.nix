{config, lib, pkgs, ...}:
{
    options.services.octoprint.proxy = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable octoprint reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the server";
        };
        port = lib.mkOption {
            type = lib.types.int; 
            default = config.services.octoprint.port;
            description = "port of the server";
        };
        domain = lib.mkOption {
            type = lib.types.str; 
            default = "octoprint.skywalker.home";
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
       services.caddy = lib.mkIf (config.services.octoprint.proxy.enable) {
            enable = true;
            virtualHosts."${config.services.octoprint.proxy.domain}".extraConfig = ''
                tls internal
                reverse_proxy ${config.services.octoprint.proxy.server}:${toString config.services.octoprint.proxy.port}
            ''
            + lib.optionalString config.services.octoprint.proxy.enableWol ''
                handle_errors {
                    @502 expression {err.status_code} == 502
                    handle @502 {
                        wake_on_lan ${config.services.octoprint.proxy.server-mac}
                        reverse_proxy ${config.services.octoprint.proxy.server}:${toString config.services.octoprint.proxy.port} {
                            lb_try_duration 120s
                        }
                    }
                }
            ''
            + lib.optionalString config.services.octoprint.webcam.enable ''
                handle_path /webcam/* {
                    reverse_proxy ${config.services.octoprint.proxy.server}:${toString config.services.octoprint.webcam.port}
                }
            '';
        };
 
    };
}
