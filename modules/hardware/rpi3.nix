{ config, pkgs, lib, inputs, ... }: 
{
  config = lib.mkIf (config.hardware.hardware-profile == "RPI3") {
    boot.loader.generic-extlinux-compatible.enable = true;
    zramSwap.enable = true; 
    swapDevices = [ { device = "/swap"; size = 4096; } ];

    environment.systemPackages = with pkgs; [
      libraspberrypi
      hd-idle
    ];
    boot= {
      kernelParams = [
        "console=ttyS1,115200n8"
      ];
    };
    networking.interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.254";
          prefixLength = 24;
        }
      ];
    };
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
    services.dnsmasq = {
      enable = true;
      settings = {
        # Range DHCP + lease time
        dhcp-range = "192.168.1.100,192.168.1.200,255.255.255.0,12h";

        # Gateway
        dhcp-option = [
          "option:router,192.168.1.1"
          "option:dns-server,8.8.8.8,8.8.4.4"
        ];

        # PXE Boot per diversi tipi di client
        "dhcp-match" = [
          "set:bios,60,PXEClient:Arch:00000"
          "set:efi64,60,PXEClient:Arch:00007"
          "set:efi64-2,60,PXEClient:Arch:00009"
          "set:efi64-3,60,PXEClient:Arch:0000B"
        ];

        "dhcp-boot" = [
          "tag:bios,netboot.xyz.kpxe,,192.168.1.254"
          "tag:efi64,netboot.xyz.efi,,192.168.1.254"
          "tag:efi64-2,netboot.xyz.efi,,192.168.1.254"
          "tag:efi64-3,netboot.xyz-arm64.efi,,192.168.1.254"
        ];
      };
    };
    hardware.enableRedistributableFirmware = true;

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
    systemd.services.hd-idle = {
      description = "External HD spin down daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sda -i 600";
      };
    };
  };
}