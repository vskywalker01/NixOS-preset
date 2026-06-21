{ config, pkgs, lib, ... }: 
{
    imports = [
        ./asus
        ./raspberry
        ./virtual
        ./toshiba
        ./common
    ];

    #Common options
    config = {
        services.power-profiles-daemon.enable = lib.mkDefault true;
    };
}



