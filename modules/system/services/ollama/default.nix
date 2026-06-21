{config, pkgs, lib, inputs, ...}:
{
    config = lib.mkIf (config.applications.ai.enable) {
        
        services.ollama = {
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
        services.open-webui = {
            enable = true; 
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
    };
}
