{ config, pkgs, lib, ... }: 

{
  hardware.nvidia.prime.amdgpuBusId = lib.mkForce "PCI:35:00:0";
  hardware.nvidia.open = lib.mkForce true;
  hardware.asus.battery.chargeUpto = 80;
  hardware.asus.battery.enableChargeUptoScript = false;
  #nixpkgs.config.cudaSupport = true;
  services.asusd = {
    #asusdConfig = builtins.readFile ./asusd/asusd.ron;
    fanCurvesConfig = builtins.readFile ./asusd/fan_curves.ron;
  };
}
