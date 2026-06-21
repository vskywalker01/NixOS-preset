{ config, pkgs, lib, inputs, ... }: 
{
    #adding specific fan configuration for asusd
    services.asusd = {
        enable = true;
        fanCurvesConfig.source = ./fan_curves.ron;
    };
}

