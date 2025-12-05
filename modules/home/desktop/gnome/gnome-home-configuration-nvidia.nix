{config, lib, pkgs, systemConfig ? {} , ...}:

{
  config = lib.mkIf (systemConfig.services.desktopManager.gnome.enable && systemConfig.hardware.nvidia.modesetting.enable) {
    dconf = {
      settings = {
        "org/gnome/shell" = { 
          enabled-extensions = with pkgs.gnomeExtensions; [
            freon.extensionUuid
          ] 
          ++ lib.optionals (systemConfig.hardware.nvidia.prime.offload.enable || systemConfig.hardware.nvidia.prime.sync.enable) [
            gpu-supergfxctl-switch.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/freon" = {
            use-gpu-nvidia = true;
        };
      };
    };
  };
}
