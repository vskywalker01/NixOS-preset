{ config, pkgs, lib, inputs, ... }: 
{
  config = lib.mkIf (config.hardware.hardware-profile == "RPI3") {
    boot.loader.generic-extlinux-compatible.enable = true;

    swapDevices = [ { device = "/swap"; size = 4096; } ];

    environment.systemPackages = with pkgs; [
      libraspberrypi
    ];
    boot= {
      kernelParams = [
        "console=ttyS1,115200n8"
      ];
    };
    systemd.services.btattach = {
      before = [ "bluetooth.service" ];
      after = [ "dev-ttyAMA0.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
      };
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
    hardware.enableRedistributableFirmware = true;
    networking.wireless.enable = true;
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
  };
}