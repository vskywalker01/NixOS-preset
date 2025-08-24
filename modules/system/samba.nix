{ config, pkgs, flake-inputs, lib, ...}:
{
  config = lib.mkIf (config.services.samba.enable) {
    services.samba = {
      openFirewall = lib.mkForce true;
      package = pkgs.sambaFull;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = config.networking.hostName;
          "netbios name" = config.networking.hostName;
          "security" = "user";
          "hosts allow" = "192.168.1.0/24 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "min protocol" = "SMB2";
          "max protocol" = "SMB3";
          "log level" = "3";
          "load printers" = "yes";
          "printing" = "cups";
          "printcap name" = "cups";
        };
      };
    };
    services.samba-wsdd = {
      enable = lib.mkForce true;
      openFirewall = lib.mkForce true;
    };
    networking.firewall.enable = lib.mkForce true;
    networking.firewall.allowPing = lib.mkForce true;
    networking.firewall.allowedTCPPorts = [ 139 445 ];
    networking.firewall.allowedUDPPorts = [ 137 138 ];
  };
}
