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
            lact
            ryzenadj
        ];
        # ----- Boot/system settings -----

        #USe latest kernel and enable proprietary drivers
        boot.kernelPackages = pkgs.linuxPackages_6_18;
        boot.extraModulePackages = with config.boot.kernelPackages; [ it87 ];
        boot.kernelParams = [ "acpi_enforce_resources=lax" ];
        boot.kernelModules = [ "coretemp" "it87" ];
        hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

        # ----- Memory options -----
        swapDevices = [{
            device = "/swapfile";
            size = 16 * 1024; # 16GB
        }];
        systemd.tmpfiles.rules = [
          "d /srv/hddraid 0755 root root -"
          "d /var/spool/samba 1777 root root -"
        ];
        #automatic mount of HDDs raid
        fileSystems."/srv/hddraid" = {
          device = "/dev/disk/by-uuid/a4a8fac9-9bbd-47b6-b984-0668f4ae4244";
          fsType = "btrfs";
          options = [
            "defaults" 
            "compress=zstd"
          ];
        };

        # ----- AMDGPU -----
        hardware.amdgpu.opencl.enable = true;
        hardware.amdgpu.overdrive.enable = false;
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

        # ----- Samba share ------
        services.samba.settings = lib.mkIf (config.services.samba.enable) {
            "hdd" = {
                "path" = "/srv/hddraid";
                "browseable" = "yes";
                "read only" = "no";
                "guest ok" = "no";
                "valid users" = [ "vittorio" ];
                "create mask" = "0644";
                "directory mask" = "0755";
            };
            "printers" = {
                "comment" = "Printers";
                "path" = "/var/spool/samba";
                "public" = "yes";
                "browseable" = "yes";
                "guest ok" = "yes";
                "writable" = "no";
                "printable" = "yes";
                "create mode" = 0700;
            };
        }; 
        
        # ----- Network settings -----
        #assigning static IP for ethernet
        networking.interfaces.eth0 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.1.250";
              prefixLength = 24;
            }
          ];
          wakeOnLan.enable = true;
        };
        networking.defaultGateway = "192.168.1.1";
        networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
    };
}
