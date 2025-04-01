{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.gnome-home-nvidiaExtensions;
in {
  options.gnome-home-nvidiaExtensions = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = "enable nvidia optimus gnome personalizations";
    };
  };
  config = mkIf cfg.enable {
    dconf = {
      settings = {
        "org/gnome/shell" = { 
          enabled-extensions = with pkgs.gnomeExtensions; [
            gpu-supergfxctl-switch.extensionUuid
            freon.extensionUuid
            gamemode-shell-extension.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/freon" = {
            use-gpu-nvidia = true;
        };
        "org/gnome/mutter" = {
            experimental-features = ["variable-refresh-rate"];
        }; 
      };
    };
  };
}
