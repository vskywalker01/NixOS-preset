{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "I3") {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.graphics.enable = true;
    #services.xserver.videoDrivers = [ "nvidia" ];
    #hardware.nvidia = {
    #  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    #  modesetting.enable = true;
    #};
    hardware.cpu.intel.updateMicrocode = true;
      boot.kernelModules = [ "nouveau" ];
    boot.blacklistedKernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" ];
    services.xserver = {
      enable = true;
      videoDrivers = [ "nouveau" ];
    };

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        mesa.drivers
      ];
    };
  };  
}