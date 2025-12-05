{config, lib, pkgs, inputs, ...}:
let
  csdWrapper = pkgs.writeShellScriptBin "csd-wrapper" ''
    #!/bin/sh
    exec ${pkgs.openconnect}/libexec/openconnect/hipreport.sh "$@"
  '';
in {
  config = lib.mkIf (config.networking.networkmanager.enable) {
        environment.systemPackages = with pkgs; [
            openconnect
            networkmanager-openconnect
            #globalprotect-openconnect
            gpclient 
            gpauth
        ];
        networking.networkmanager.plugins = [
            pkgs.networkmanager-openconnect
            pkgs.networkmanager-openvpn
            
        ];
            #sudo gpclient --fix-openssl  connect --csd-wrapper /usr/lib/openconnect/hipreport.sh vpn-mfa.icts.unitn.it#
    #services.globalprotect.enable=true;
    #services.globalprotect.csdWrapper="${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  
    };
}
