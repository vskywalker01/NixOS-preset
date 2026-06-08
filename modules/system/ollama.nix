{config, pkgs, lib, inputs, ...}:
{
  config = lib.mkIf (config.services.ollama.enable) {
    services.ollama = {
        environmentVariables = {
            OLLAMA_CONTEXT_LENGTH = "8192";
            OLLAMA_KEEP_ALIVE = "5m";
        };
        package = pkgs.ollama-vulkan;
        loadModels = [
            "qwen2.5-coder:1.5b"
            "qwen3.5:4b"
        ];
    };
    /*services.nextjs-ollama-llm-ui = {
        port = 8080;
        enable = true;
    };*/ 
    services.open-webui = {
        enable = true; 
    };
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
