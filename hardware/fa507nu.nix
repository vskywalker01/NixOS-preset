{ config, pkgs, lib, ... }: 

{
  hardware.nvidia.prime.amdgpuBusId = lib.mkForce "PCI:35:00:0";
  hardware.nvidia.open = lib.mkForce true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.86.16"; # use new 570 drivers
      sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      usePersistenced = false;
    };
  hardware.asus.battery.chargeUpto = 80;
  hardware.asus.battery.enableChargeUptoScript = false;
  nixpkgs.config.cudaSupport = true;  
  hardware.nvidia-container-toolkit.enable = true;
  environment.systemPackages = with pkgs; [
    ryzenadj
  ];
  systemd.services.ryzenadj = {
    description = "RyzenAdj";
    after = [ "sysinit.target" ]; 
    wantedBy = [ "multi-user.target" ]; 

    serviceConfig = {
      Restart = "always"; 
      RestartSec = "10";
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj -f 85";  
      User = "root";
    };
  };
  services.asusd = {
    #asusdConfig = builtins.readFile ./asusd/asusd.ron;
    fanCurvesConfig = builtins.readFile ./asusd/fan_curves.ron;
    
  };
}