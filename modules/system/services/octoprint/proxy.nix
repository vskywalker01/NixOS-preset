{config, lib, pkgs, ...}:
let 
    server-port = 5000;
    webcam-port = 5001;
in {
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
       services.octoprint = lib.mkIf (config.services.octoprint.enable) {
            plugins =  plugins: with plugins; [
                themeify 
            ];
       };
       services.caddy = lib.mkIf (config.services.octoprint.proxy.enable) {
            enable = true;
            virtualHosts."${config.services.octoprint.proxy.domain}".extraConfig = ''
                tls internal
                reverse_proxy ${config.services.octoprint.proxy.server}:${toString server-port}
            ''
            + lib.optionalString config.services.octoprint.proxy.enableWol ''
                handle_errors {
                    @502 expression {err.status_code} == 502
                    handle @502 {
                        wake_on_lan ${config.services.octoprint.proxy.server-mac}
                        reverse_proxy ${config.services.octoprint.proxy.server}:${toString server-port} {
                            lb_try_duration 120s
                        }
                    }
                }
            ''
            + lib.optionalString config.services.octoprint.webcam.enable ''
                handle_path /webcam/* {
                    reverse_proxy ${config.services.octoprint.proxy.server}:${toString webcam-port}
                }
            '';
        };
 
    };
}
