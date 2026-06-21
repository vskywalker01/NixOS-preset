{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.office.enable){
        home.packages = with pkgs; [rnote];
    };
}

