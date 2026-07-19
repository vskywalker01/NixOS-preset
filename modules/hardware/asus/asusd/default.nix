{ config, pkgs, lib, inputs, ... }: 
{
    #adding specific fan configuration for asusd
    services.asusd = lib.mkIf (config.services.asusd.enable)  {
        fanCurvesConfig.source = ./fan_curves.ron;
    };
}

