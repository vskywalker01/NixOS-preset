{ config, pkgs, lib, inputs, ... }: 
let
    #Unstable channel 
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    options.hardware.raspberry.RPI3.enable = lib.mkOption  {
        type = lib.types.bool; 
        default = false;
        description = "Enable hardware profile for raspberry pi 3";
    };
    config = lib.mkIf (config.hardware.raspberry.RPI3.enable) {
        # ----- Addition packages ------
        environment.systemPackages = with pkgs; [
            libraspberrypi
        ];

        # ----- Boot/system settings -----
        boot.loader.generic-extlinux-compatible.enable = true;
        boot.kernelParams = [
            "console=ttyS1,115200n8"
        ];
        hardware.enableRedistributableFirmware = true;

        # ----- Memory options -----
        zramSwap.enable = true; 
        swapDevices = [{ 
            device = "/swap"; 
            size = 4096; 
        }];

        #Automatic spindown for HDD
        services.hdparm = {
            enable = true; 
            spindown = 120;        
        };
       
        #automatic optimization of the nix store
        nix.optimise.automatic = true;
        nix.optimise.dates = [ "03:45" ];
        nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
    };
}
