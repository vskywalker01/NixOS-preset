{config, pkgs, lib, ...}:

with lib;
let 
  cfg = config.ollama;
in {
  options.ollama = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable ollama and openwebui services";
    };
  };
  config = mkIf cfg.enable {
    services.open-webui = {
      enable = lib.mkDefault true;
    };
    services.ollama = {
      enable = lib.mkDefault true;
      loadModels = [
        "qwen2.5-coder"
      ];
    };
  };
}