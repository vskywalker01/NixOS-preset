{config, pkgs, lib, inputs, ...}:
{
  config = lib.mkIf (config.services.ollama.enable) {
    services.ollama = {
        environmentVariables = {
            OLLAMA_CONTEXT_LENGTH = "8192";
            OLLAMA_KEEP_ALIVE = "2m";
        };
        package = pkgs.ollama-vulkan;
        acceleration = "vulkan";
        loadModels = [
            "codegemma:2b"
        ];
    };
    services.nextjs-ollama-llm-ui = {
        port = 8080;
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
