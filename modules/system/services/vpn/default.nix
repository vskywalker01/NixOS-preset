{config, lib, pkgs, inputs, ...}:

{
  config = lib.mkIf (config.networking.networkmanager.enable) {
        #adding VPN support for network manager    
    
        environment.systemPackages = with pkgs; [
            openconnect
            networkmanager-openconnect
            gpclient 
            gpauth
        ];
        
        #adding VPN plugins
        networking.networkmanager.plugins = [
            pkgs.networkmanager-openconnect
            pkgs.networkmanager-openvpn
            
        ];
    };
}
