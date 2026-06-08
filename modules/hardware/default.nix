{ config, pkgs, lib, ... }: 
{
    imports = [
        ./asus
        ./raspberry
        ./virtual
        ./toshiba
    ];

    #Common options
    config = {
        services.power-profiles-daemon.enable = lib.mkDefault true;
    };
}



