{config, lib, pkgs, systemConfig ? {} , ...}:

{
    xdg.configFile."hypr/scripts/slurp.sh" = {
        source = ./slurp.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/supergfxctl-get.sh" = {
        source = ./supergfxctl-get.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/supergfxctl-set.sh" = {
        source = ./supergfxctl-set.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/gpu-temp.sh" = {
        source = ./gpu-temp.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/fan-speeds.sh" = {
        source = ./fan-speeds.sh;
        executable = true;
    };
    

}
