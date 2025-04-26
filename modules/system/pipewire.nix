{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.pipewire.enable || config.services.xserver.desktopManager.gnome.enable) {
    security.rtkit.enable = lib.mkDefault true;
    services.pipewire = {
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      jack.enable = true;
    };
  };
}
