{ config, pkgs, flake-inputs, lib, ...}:
{
  config = lib.mkIf (config.services.samba.enable) {
    services.samba = {
      securityType = "user";
      openFirewall = lib.mkForce true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = config.networking.hostName;
          "netbios name" = config.networking.hostName;
          "security" = "user";
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };
        "home" = {
          "path" = "/home/";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };
    services.samba-wsdd = {
      enable = lib.mkForce true;
      openFirewall = lib.mkForce true;
    };
    networking.firewall.enable = lib.mkForce true;
    networking.firewall.allowPing = lib.mkForce true;
  };
}
