{config, lib, pkgs, systemConfig ? {} , ...}:

{
    xdg.configFile."hypr/scripts/swww-random-sh" = {
        source = ./swww-random.sh;
        executable = true;
    };

}
