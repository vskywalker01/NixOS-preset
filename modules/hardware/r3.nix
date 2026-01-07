{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "R3") {
    boot.kernelPackages = pkgs.linuxPackages_6_17;
    environment.systemPackages = with pkgs; [ 
        lact
        ryzenadj
    ];
    systemd.packages = with pkgs; [ 
      lact 
      ethtool
    ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    systemd.tmpfiles.rules = [
      "d /srv/hddraid 0755 root root -"
      "d /var/spool/samba 1777 root root -"
    ];

    fileSystems."/srv/hddraid" = {
      device = "/dev/disk/by-uuid/a4a8fac9-9bbd-47b6-b984-0668f4ae4244";
      fsType = "btrfs";
      options = [
        "defaults" 
        "compress=zstd"
      ];
    };

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
    systemd.services.ryzenadj = {
      description = "RyzenAdj";
      after = [ "sysinit.target" ]; 
      wantedBy = [ "multi-user.target" ]; 

      serviceConfig = {
        Restart = "always"; 
        RestartSec = "10";
        ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj -f 70";  
        User = "root";
      };
    };


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
