{config, lib, pkgs, systemConfig ? {} , ...}:

{
    xdg.configFile."hypr/scripts/slurp.sh" = {
        source = ./slurp.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/caffeina-status.sh" = {
        source = ./caffeina-status.sh;
        executable = true;
    };
    xdg.configFile."hypr/scripts/caffeina-set-status.sh" = {
        source = ./caffeina-set-status.sh;
        executable = true;
    };

}
