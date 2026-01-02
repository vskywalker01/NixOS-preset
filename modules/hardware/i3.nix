{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "I3") {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.graphics.enable = true;
    
    hardware.cpu.intel.updateMicrocode = true;
  };  
}
