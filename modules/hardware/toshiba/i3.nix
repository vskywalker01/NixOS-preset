{ config, pkgs, lib, inputs, ... }: 
let 
    #unstable channel
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    options.hardware.toshiba.I3.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable hardware profile for I3 (to be changed to actual motherboard type)";
    };

    config = lib.mkIf (config.hardware.toshiba.I3.enable) {
        # ----- Boot/system settings -----
        boot.kernelPackages = pkgs.linuxPackages_latest;
        hardware.graphics.enable = true;
        hardware.cpu.intel.updateMicrocode = true;
    };  
}
