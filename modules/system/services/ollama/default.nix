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
    config = {
        services.ollama = lib.mkIf (config.applications.ai.enable) {
            enable = true;
            environmentVariables = {
                OLLAMA_CONTEXT_LENGTH = "8192";
                OLLAMA_KEEP_ALIVE = "5m";
            };

            #choosing ollama-vulkan version to avoid conflicts for different GPU manufacters
            package = pkgs.ollama-vulkan;
            loadModels = [
                #common chat model 
                "qwen3.5:4b"
            ];
        };

        #enabling open-webui for chatbots
        services.open-webui = lib.mkIf (config.applications.ai.enable){

            
            enable = true;
            port = server-port;
            environment = {
                ENABLE_WEB_SEARCH = "True";
                WEB_SEARCH_ENGINE = "searxng";
                WEB_SEARCH_RESULT_COUNT = "3";
                WEB_SEARCH_CONCURRENT_REQUESTS = "10";
                SEARXNG_QUERY_URL = "http://localhost:8081/search?q=<query>";
            };
        };

        #automatic unload of ollama models before the logout. 
        #This service fixes problems encoutered with supergfxctl during the logout process for changing GPU profile
        systemd.user.services.ollama-unload = lib.mkIf (config.applications.ai.enable){
            description = "Unload Ollama models on logout";
            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.ollama}/bin/ollama ps | awk \"NR>1 {print \\$1}\" | xargs -r ${pkgs.ollama}/bin/ollama stop'";
            };
            wantedBy = [ "exit.target" ];
        };


        services.searx = lib.mkIf (config.applications.ai.enable){
            enable = true;
            redisCreateLocally = true;
            settings = {
                server = {
                    bind_address = "127.0.0.1";
                    port = 8081;
                    secret_key = "notsosecretkey";
                };
                search = {
                    safesearch = 0;
                    formats = [
                        "html"
                        "json" 
                    ];

                };
            };
        };
        services.caddy = lib.mkIf (config.services.open-webui.proxy.enable) {
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
