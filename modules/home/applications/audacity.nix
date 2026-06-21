{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.video-editing.enable){
        home.packages = with pkgs; [audacity];
    };
}
