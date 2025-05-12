#Use sudo systemctl start docker-open-webui to start the docker 

{config, pkgs, lib, inputs, ...}:
{
  options.ollama = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Enable ollama and open-webui";
    };
  };
  config = {
    #services.ollama = {
    #  loadModels = [
    #    "qwen2.5-coder"
    #    "deepseek-r1:8b"
    #    "codegemma"
    #  ];
    #};
    virtualisation.oci-containers = lib.mkIf (config.ollama.enable) {
      backend = "docker";
      containers = {
        open-webui = {
          image = "ghcr.io/open-webui/open-webui:ollama";
          #ports = [
          #  "8080:8080"
          #  "11434:11434"
          #];
          extraOptions=[
            "--device=nvidia.com/gpu=all"
            "--network=host"
          ];
          volumes = [
            "ollama:/root/.ollama"
            "open-webui:/app/backend/data"
          ];
          autoStart = false;
          
        };
      };
    };
  };
}