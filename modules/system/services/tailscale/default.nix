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
        services.tailscale.extraDaemonFlags = ["--no-logs-no-support"];
        services.tailscale.extraUpFlags = ["--accept-routes"];
        services.tailscale.useRoutingFeatures = lib.mkDefault "both";
        services.resolved.enable = true;
        networking.networkmanager.dns = "systemd-resolved";
    };
}
