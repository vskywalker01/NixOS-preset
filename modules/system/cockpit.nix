{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.cockpit.enable) {
    networking.firewall.allowedTCPPorts = [ 9090 ];
  };
}