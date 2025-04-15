{config, pkgs, lib, inputs, ...}:
{
  config = {
    #services.ollama = {
    #  loadModels = [
    #    "qwen2.5-coder"
    #    "deepseek-r1:8b"
    #    "codegemma"
    #  ];
    #};
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        open-webui = {
          image = "ghcr.io/open-webui/open-webui:ollama";
          ports = [
            "8080:8080"
          ];
          extraOptions=[
            "--device=nvidia.com/gpu=all"
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