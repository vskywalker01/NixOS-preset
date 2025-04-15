{config, pkgs, lib, systemConfig ? {},...}:
{
  config = lib.mkIf (systemConfig.services.asusd.enable) {
    home.file.".config/autostart/rog-control-center.desktop".source =./rog-control-center.desktop;
  };
}
