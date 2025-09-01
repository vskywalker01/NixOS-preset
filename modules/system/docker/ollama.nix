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
    virtualisation.oci-containers = lib.mkIf (config.ollama.enable) {
      backend = "docker";
      containers = {
        open-webui = {
          image = "ghcr.io/open-webui/open-webui:ollama";
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