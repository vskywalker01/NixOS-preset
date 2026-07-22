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
    imports = [
        inputs.ngrok.nixosModules.ngrok
    ];
    config = lib.mkIf (config.hardware.raspberry.RPI3.enable) {
        # ----- Addition packages ------
        environment.systemPackages = with pkgs; [
            libraspberrypi
            hdparm
            wakeonlan 
            wol 
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
        systemd.tmpfiles.rules = [
            "d /srv/hdd 0755 root root -"
            "d /var/spool/samba 1777 root root -"
        ];

        fileSystems."/srv/hdd" = {
            device = "/dev/sda1";
            fsType = "btrfs";
            options = [
                "defaults" 
                "compress=zstd"
            ];
        };
        #Automatic spindown for HDD
        systemd.services.hdparm-sda = {
            description = "Set spindown timeout for /dev/sda";
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.hdparm}/bin/hdparm -S 120 -B 127 /dev/sda";
            };
        };
    

        networking.interfaces.eth0 = {
            useDHCP = false;
            ipv4.addresses = [{
                address = "192.168.1.254";
                prefixLength = 24;
            }];
        };
        networking.defaultGateway = "192.168.1.1";
        networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
        
        #dnsmasq server fir IPXE 
        services.dnsmasq = {
            enable = true;
            settings = {
                address = [
                    "/skywalker.home/192.168.1.254"
                ];

                server = [
                    "8.8.8.8"
                    "8.8.4.4"
                ];
            };
        };
    
        # ----- Samba share ------
 
        services.samba.settings = lib.mkIf (config.services.samba.enable) {
            "hdd" = {
                "path" = "/srv/hdd";
                "browseable" = "yes";
                "read only" = "no";
                "guest ok" = "no";
                "valid users" = [ "vittorio" ];
                "create mask" = "0644";
                "directory mask" = "0755";
            };
        };
        services.tailscale = {
            enable = true;
            useRoutingFeatures = "server";
            extraUpFlags = [
                "--advertise-routes=192.168.1.254/32" # For subnet routers
            ];
        };
        services.networkd-dispatcher = {
            enable = true;
            rules."50-tailscale-optimizations" = {
                onState = [ "routable" ];
                script = ''
                    ${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off
                '';
            };
        };
        services.filebrowser.settings.root = "/srv/hdd";
        
        networking.firewall.allowedTCPPorts = [ 80 443 53];
        networking.firewall.allowedUDPPorts = [53];
    };
}
