{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.cads.enable){
        home.packages = with pkgs; [cura-appimage];
    };
}
