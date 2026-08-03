{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
    config = lib.mkIf(systemConfig.applications.cads.enable){
        services.flatpak.packages = [
            "org.freecad.FreeCAD"
        ];
        #home.packages = with pkgs; [freecad];
    };
}
