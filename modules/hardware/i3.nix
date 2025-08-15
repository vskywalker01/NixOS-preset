{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "I3") {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      modesetting.enable = true;
    };
    hardware.cpu.intel.updateMicrocode = true;
  };  
}