{config, lib, pkgs, ...}:
{
    config = {
        networking.firewall.enable = lib.mkDefault true;
        
        #allowing ports used for DNS communicaiton for user network shares
        networking.firewall.allowedUDPPorts = [ 53 67 ];
        networking.firewall.allowedTCPPorts = [ 53 ];
        
        # If internet works but DNS fails, you might need:
        networking.firewall.checkReversePath = "loose";


    };
}
