{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.tools.enable){
        home.packages = with pkgs; [gimp];
    };
}


