{config, pkgs, lib, ...}:

{
  config = lib.mkIf (config.services.ollama.enable) {
    services.ollama = {
      loadModels = [
        "qwen2.5-coder"
        "deepseek-r1:8b"
      ];
    };
  };
}