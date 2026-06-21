{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.gaming.enable){
        home.packages = with pkgs; [r2modman];
    };
}

