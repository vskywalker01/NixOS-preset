{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "FA507NU") {
    #NVIDIA PRIME
    #Sets the correct PCI ID for the AMD GPU
    hardware.nvidia.prime.amdgpuBusId = lib.mkForce "PCI:35:00:0"; 
    #Workaround for errors during compilation for specific kernel versions                  
    hardware.nvidia.open = lib.mkForce true;                                          
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.86.16";  
      sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      usePersistenced = false;
    };
  
    #disable nixos-hardware battery charge control script
    #hardware.asus.battery.enableChargeUptoScript = lib.mkForce false;
   

    #enable Cuda support and GPU passtrough for Nvidia GPU on docker 
    nixpkgs.config.cudaSupport = lib.mkDefault true;  
    hardware.nvidia-container-toolkit = lib.mkIf (config.virtualisation.docker.enable) {
      enable = lib.mkDefault true;
    };
    virtualisation.docker.rootless.daemon.settings.features = lib.mkIf (config.virtualisation.docker.enable) {
        cdi= lib.mkForce true;
    };

    #THERMAL CONTROL
    #Installs ryzenadj for setting temperature limit on the cpu
    environment.systemPackages = with pkgs; [
      ryzenadj
      nvtopPackages.full
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

    #ASUSD CONFIGURATION
    #adding specific fan configuration for asusd
    services.asusd = lib.mkIf (config.services.asusd.enable) {
      #package=unstable.asusctl;
      #asusdConfig = builtins.readFile ./asusd/asusd.ron;
      fanCurvesConfig = builtins.readFile ./asusd/fan_curves.ron;
    };
  };
}