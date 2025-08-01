{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.octoprint.enable) {
    services.octoprint.port = 5000;
  
    systemd.services.octoprint = {
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      };
    };

    networking.firewall = rec {
      allowedTCPPorts = [
        5000
      ];
      allowedUDPPorts = allowedTCPPorts;
    };
  };
}