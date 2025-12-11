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
    xdg.configFile."hypr/scripts/cpu-fan-speed.sh" = {
        source = ./cpu-fan-speed.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/gpu-fan-speed.sh" = {
        source = ./gpu-fan-speed.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/gpu-status.sh" = {
        source = ./gpu-status.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/settings.sh" = {
        source = ./settings.sh;
        executable = true;
    };
     
    

}
