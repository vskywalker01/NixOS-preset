{config, pkgs, lib, inputs, ...}:
let 
   llama-port = 8008;
in {
    imports = [
        ./proxy.nix
    ];
    config = lib.mkIf (config.applications.ai.enable) {
        services.llama-cpp = {
            enable = true;
            package = pkgs.llama-cpp-vulkan;
            port = llama-port;
            extraFlags = [
                "--sleep-idle-seconds" 
                "300"
                "--models-max" 
                "1"
            ];
            modelsPreset = {
                "Ornith-1.5-9B" = {
                    hf-repo = "ornith-ai/Ornith-1.5-9B-GGUF";
                    hf-file = "Ornith-1.5-9B-Q4_K_M.gguf";
                    temp = "1.0";
                    repeat-penalty = "1.0";
                    presence-penalty = "1.5";
                    top-p = "0.95";
                    min-p = "0.0";
                    top-k = "20";
                };
                "Qwen3.5-4B" = {
                    hf-repo = "unsloth/Qwen3.5-4B-GGUF";
                    hf-file = "Qwen3.5-4B-Q4_K_M.gguf";
                    temp = "1.0";
                    repeat-penalty = "1.0";
                    top-p = "0.95";
                    top-k = "0.80";
                    min-p = "0.0";
                    presence-penalty = "1.5";
                };
            };
        };
        systemd.services.llama-cpp = {
            environment = {
                XDG_CACHE_HOME = "/var/cache/llama-cpp";
                MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
            };
        };
        #enabling open-webui for chatbots
        services.open-webui = {
            host = "0.0.0.0";
            enable = true;
            environment = {
                ENABLE_OLLAMA_API="false";

                OPENAI_API_BASE_URL="http://127.0.0.1:${toString llama-port}/v1";
                OPENAI_API_KEY="";
                OPENAI_API_CONFIGS="{'0':{'enable':true,'prefix_id':'llama.cpp','connection_type':'external'}}";

                ENABLE_PERSISTENT_CONFIG="false";
                
                ENABLE_WEB_SEARCH = "False";
            };
        };
        systemd.user.services.llama-cpp-unload = {
            description = "Unload all llama.cpp models on logout";

            serviceConfig = {
                Type = "oneshot";

                ExecStart = pkgs.writeShellScript "llama-cpp-unload" ''
                    set -u
                    LLAMA_URL="http://127.0.0.1:${toString llama-port}"
    
                    models=$(
                        ${pkgs.curl}/bin/curl -fsS "$LLAMA_URL/models" |
                        ${pkgs.jq}/bin/jq -r '
                        .data[]
                        | select(
                            .status.value == "loaded" or
                            .status.value == "sleeping"
                        )
                        | .id
                        '
                    ) || exit 0

                    [ -n "$models" ] || exit 0

                    while IFS= read -r model; do
                        [ -n "$model" ] || continue

                        echo "Unloading llama.cpp model: $model"

                        ${pkgs.curl}/bin/curl -fsS \
                        -X POST \
                        -H "Content-Type: application/json" \
                        -d "$(${pkgs.jq}/bin/jq -n --arg model "$model" \
                            '{model: $model}')" \
                            "$LLAMA_URL/models/unload" \
                        >/dev/null || true

                    done <<< "$models"
                '';
            };
            wantedBy = [ "exit.target" ];
        };
        #automatic unload of ollama models before the logout. 
        #This service fixes problems encoutered with supergfxctl during the logout process for changing GPU profile
        #systemd.user.services.ollama-unload = {
        #    description = "Unload Ollama models on logout";
        #    serviceConfig = {
        #        Type = "oneshot";
        #        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.ollama}/bin/ollama ps | awk \"NR>1 {print \\$1}\" | xargs -r ${pkgs.ollama}/bin/ollama stop'";
        #    };
        #    wantedBy = [ "exit.target" ];
        #};
    };
}
