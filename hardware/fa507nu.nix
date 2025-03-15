{ config, pkgs, lib, ... }: 

{
  hardware.nvidia.prime.amdgpuBusId = lib.mkForce "PCI:35:00:0";
  hardware.asus.battery.chargeUpto = 80;
  hardware.asus.battery.enableChargeUptoScript = false;
  services.asusd = {
    #asusdConfig = builtins.readFile ./asusd/asusd.ron;
    fanCurvesConfig = builtins.readFile ./asusd/fan_curves.ron;
  };
}
