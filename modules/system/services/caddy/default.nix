{config, lib, pkgs, ...}:    
{
    config = lib.mkIf (config.services.caddy.enable) {
        environment.systemPackages = with pkgs; [
            wakeonlan 
            wol 
        ];
        services.caddy = {
            package = pkgs.caddy.withPlugins {
                plugins = [
                    "github.com/dulli/caddy-wol@v1.0.0"
                ];
                hash = "sha256-Wgi75Q/TaCDspsrRLpGj/ySjJDto3cfO2AYB/kHbHpQ=";
            };
            globalConfig = ''
                order wake_on_lan before respond
                acme_ca https://ca.home/acme/caddy/directory
            '';
        };
        networking.firewall.allowedTCPPorts = [ 80 443 53 9000];
        networking.firewall.allowedUDPPorts = [53];
    };
}
