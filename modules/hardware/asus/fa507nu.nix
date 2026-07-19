{ config, pkgs, lib, inputs, ... }: 
let
    #Unstable channel 
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

    #Automatic script for ryzenadj
    ryzenadjDynamic = pkgs.writeShellScript "ryzenadj-dynamic" ''
        AC_STATUS=$(cat /sys/class/power_supply/AC*/online)

        if [ "$AC_STATUS" = "1" ]; then
          exec ${pkgs.ryzenadj}/bin/ryzenadj -f 85
        else
          exec ${pkgs.ryzenadj}/bin/ryzenadj -f 65
        fi
      '';
    
    batteryDynamic = pkgs.writeScriptBin "charge-upto" ''
        #!${pkgs.bash}/bin/bash
        echo ''${1:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
    '';
    
    batteryChargeLimit = 80;

in {
    options.hardware.asus.FA507NU.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable hardware profile for ASUS TUF A15 (FA507NU)";
    };
    imports = [
        ./asusd
    ];
    
    config = lib.mkIf (config.hardware.asus.FA507NU.enable) {
        # ----- Addition packages ------
        environment.systemPackages = [
            pkgs.ryzenadj
            pkgs.nvtopPackages.full
            pkgs.supergfxctl
            batteryDynamic
        ];

        # ----- Boot/system settings -----

        #USe latest kernel and enable proprietary drivers
        boot = {
            loader = { 
                systemd-boot.enable = false;
                efi.canTouchEfiVariables = true;
            };
            lanzaboote.enable = true;
            kernelPackages = pkgs.linuxPackages_latest;
            kernelParams = [ "amd_pstate=active" "usbcore.autosuspend=1"];
        };

        hardware.enableAllFirmware = false;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        services.fstrim.enable = lib.mkDefault true;        
        services.irqbalance.enable = true;
        # Battery charge limit 
        systemd.services.battery-charge-threshold = {
            wantedBy = [
                "local-fs.target"
                "suspend.target"
                "suspend-then-hibernate.target"
                "hibernate.target"
            ];
            after = [
                "local-fs.target"
                "suspend.target"
                "suspend-then-hibernate.target"
                "hibernate.target"
            ];
            description = "Set the battery charge threshold to ${toString batteryChargeLimit}%";
            startLimitBurst = 5;
            startLimitIntervalSec = 1;
            serviceConfig = {
                Type = "oneshot";
                Restart = "on-failure";
                ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString batteryChargeLimit} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
            };
        };


        # ----- Memory options -----
        #enable zram and 16GB swap
        zramSwap.enable = true; 
        swapDevices = [{
            device = "/swapfile";
            size = 16 * 1024; # 16GB
        }];

        # ----- Nvidia drivers -----
        #Sets the correct PCI ID for the AMD GPU
        services.supergfxd.enable = true;
        systemd.services.supergfxd-restart = {
          description = "Restart supergfxd after suspend";
          wantedBy = [ "suspend.target" ];
          after = [ "suspend.target" ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.systemd}/bin/systemctl restart supergfxd.service";
          };
        };

        #Using nvidia drivers + optimus 
        services.xserver.videoDrivers = [ "nvidia" ];
        boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
        boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
        hardware.nvidia = {
            powerManagement.enable = lib.mkDefault true;
            modesetting.enable = lib.mkDefault true;
            nvidiaSettings = lib.mkDefault true;
            package = #config.boot.kernelPackages.nvidiaPackages.mkDriver {
                #version = "610.43.02";
                #sha256_64bit = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
                #sha256_aarch64 = "sha256-isWTnokUA/dzWocFBLalnk4+O5gSExVjs3dVpdYTU88=";
                #openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
                #settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
                #persistencedSha256 = "sha256-Whgv9X+v2fRhzliOl2LzltY9v1SxDafFfv3IUPqj/hk=";    
            #};

            config.boot.kernelPackages.nvidiaPackages.stable;
            open = true; 
            prime = {
                amdgpuBusId = lib.mkForce "PCI:35:00:0";
                nvidiaBusId = "PCI:1:0:0";
            };
        };
        hardware.nvidia-container-toolkit = lib.mkIf (config.virtualisation.docker.enable) {
            enable = lib.mkDefault false;
        };
        virtualisation.docker.rootless.daemon.settings.features = lib.mkIf (config.virtualisation.docker.enable) {
            cdi= lib.mkForce true;
        };
        

        # ----- Thermal control ------
        # Set limit temperature to avoid CPU overheating using ryzenadj
        services.asusd.enable = true;
        systemd.services.ryzenadj = {
          description = "RyzenAdj";
          after = [ "sysinit.target" ]; 
          wantedBy = [ "multi-user.target" ]; 
          serviceConfig = {
            Restart = "always"; 
            RestartSec = "10";
            ExecStart = ryzenadjDynamic;  
            User = "root";
          };
        };
        networking.networkmanager.wifi.powersave = true;
        services.tailscale = {
            enable = true;
            useRoutingFeatures = "client";
        };

    };
}
