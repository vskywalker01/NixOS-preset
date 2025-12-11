{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.pipewire.enable || config.programs.hyprland.enable || config.services.desktopManager.gnome.enable) {
    security.rtkit.enable = lib.mkDefault true;
    services.pipewire = {
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      jack.enable = true;
      extraConfig.pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 1024;
          };
        };
      };
      wireplumber.enable = true;
    };
  };
}
