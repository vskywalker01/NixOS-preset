{ config, pkgs, lib, inputs, ... }: 
let
    #Unstable channel 
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    options.hardware.asus.A320M-K.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable hardware profile for ASUS A320M-K motherboard";
    };

    config = lib.mkIf (config.hardware.asus.A320M-K.enable) {
        # ----- Addition packages ------
        environment.systemPackages = with pkgs; [ 
            ryzenadj
        ];
        # ----- Boot/system settings -----

        #USe latest kernel and enable proprietary drivers

        boot = {
            loader = { 
                systemd-boot.enable = false;
                efi.canTouchEfiVariables = true;
            };
            lanzaboote.enable = true;
            kernelPackages = pkgs.linuxPackages_6_18;
            extraModulePackages = with config.boot.kernelPackages; [ it87 ];
            kernelParams = [ "mem_sleep_default=deep" "acpi_enforce_resources=lax" ];
            kernelModules = [ "coretemp" "it87" ];
            binfmt.emulatedSystems = [ "aarch64-linux" ];
        };
        hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

        # ----- Memory options -----
        swapDevices = [{
            device = "/swapfile";
            size = 16 * 1024; # 16GB
        }];
                
        # ----- AMDGPU -----
        hardware.amdgpu.opencl.enable = true;
        hardware.amdgpu.overdrive.enable = true;
        services.lact.enable = true;
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        # ----- Thermal control / power management------
        programs.coolercontrol.enable = true;
        systemd.services.lactd.wantedBy = ["multi-user.target"];
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

        services.logind = {
            enable = true; 
        };
        systemd.sleep.settings.Sleep = {
            SuspendState = "mem";
            AllowSuspend = "yes";
            AllowHibernation = "yes";
            AllowHybridSleep = "yes";
            AllowSuspendThenHibernate = "no";
        };

    };
}
