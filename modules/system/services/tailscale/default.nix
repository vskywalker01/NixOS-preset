{config, lib, pkgs, ...}:
{
    config = lib.mkIf (config.services.tailscale.enable) {
        environment.systemPackages = with pkgs; [
            tailscale
            ethtool
        ];
        services.tailscale = {
            authKeyFile = "/secrets/tailscale_key";
        };
    
        networking.firewall = { 
            trustedInterfaces = [ "tailscale0" ];
            allowedUDPPorts = [ config.services.tailscale.port ];
            allowedTCPPorts = [ 22 ];
            checkReversePath = "loose";
        };
        services.tailscale.permitCertUid = lib.mkIf (config.services.caddy.enable) "caddy";

    };
}
