{config, pkgs, lib, inputs, ...}:
{
    imports = [
        ./proxy.nix
    ];
    config = lib.mkIf (config.applications.ai.enable) {
        services.ollama = {
            enable = true;
            environmentVariables = {
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
        services.open-webui = {
            host = "0.0.0.0";
            enable = true;
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
        systemd.user.services.ollama-unload = {
            description = "Unload Ollama models on logout";
            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.ollama}/bin/ollama ps | awk \"NR>1 {print \\$1}\" | xargs -r ${pkgs.ollama}/bin/ollama stop'";
            };
            wantedBy = [ "exit.target" ];
        };

        services.searx = {
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
    };
}
