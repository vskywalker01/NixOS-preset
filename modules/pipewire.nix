{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.pipewire;
in {
  options.pipewire = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "include audio features in configuration";
    };
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = lib.mkDefault true;
    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
