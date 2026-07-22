{config, lib, pkgs, ...}:    
{
    options.services.haproxy = {
        configs = lib.mkOption {
            type = lib.types.listOf lib.types.lines;
            default = [];
            description = "HAProxy configuration fragments";
        };
    };

    config = lib.mkIf (config.services.haproxy.enable) {
        environment.systemPackages = with pkgs; [
            wakeonlan 
            wol 
        ];
        services.haproxy.config = ''
            global
                log stdout format raw local0
            defaults
                mode tcp
                timeout connect 5s
                timeout client 1m
                timeout server 1m
            
            ${lib.concatStringsSep "\n\n" config.services.haproxy.configs}
        '';
    };
}
