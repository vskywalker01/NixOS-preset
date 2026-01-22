{ config, pkgs, lib, inputs, ... }: 
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "FA507NU") {
    boot.kernelPackages = pkgs.linuxPackages_6_18;
    hardware.enableAllFirmware = true;
    zramSwap.enable = true; 
  
    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }];

    #NVIDIA PRIME
    #Sets the correct PCI ID for the AMD GPU
    hardware.nvidia.prime.amdgpuBusId = lib.mkForce "PCI:35:00:0"; 
    #Workaround for errors during compilation for specific kernel versions                  
    hardware.nvidia.open = lib.mkForce true;                                          

    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "590.48.01";
      sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
      sha256_aarch64 = "sha256-FOz7f6pW1NGM2f74kbP6LbNijxKj5ZtZ08bm0aC+/YA=";
      openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
      settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
      persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
    };

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
      #asusdConfig = builtins.readFile ./asusd/asusd.ron;
      fanCurvesConfig.source = ./asusd/fan_curves.ron;
    };

    /*boot = {
      kernelParams = [ "amd_iommu=on" "vfio-pci.reset=1" "vfio-pci.disable_idle_d3=1" "iommu=pt" "vfio-pci.verbose=1"];
      kernelModules = [ "kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    };*/
  };
}
