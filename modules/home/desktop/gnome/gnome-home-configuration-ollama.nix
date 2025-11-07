{config, lib, pkgs, systemConfig ? {} , ...}:

{
  config = lib.mkIf (systemConfig.services.xserver.desktopManager.gnome.enable && systemConfig.ollama.enable) {
    dconf = {
      settings = {
        "org/gnome/shell" = { 
          enabled-extensions = with pkgs.gnomeExtensions; [
            custom-command-toggle.extensionUuid
          ]; 
        };
        "org/gnome/shell/extensions/custom-command-toggle" = {
            entryrow1-setting = "systemctl start docker-open-webui";
            entryrow2-setting = "systemctl stop docker-open-webui";
            entryrow3-setting = "Open WebUI";
            entryrow4-setting = "computer-symbolic";
            checkexitcode1-setting = true;
        };
      };
    };
  };
}
