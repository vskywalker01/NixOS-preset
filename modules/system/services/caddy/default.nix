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
                hash = "sha256-vzGs2nuEDQ80tvq8Nl37aDhVU0PBscWwbWy+gTdbPug=";
            };
            globalConfig = ''
                order wake_on_lan before respond
            '';
        };
        networking.firewall.allowedTCPPorts = [ 80 443 53];
        networking.firewall.allowedUDPPorts = [53];
    };
}
