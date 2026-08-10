{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.services.openssh.enable) {
        services.openssh = {   
            #assigning default port for ssh connections
            ports = lib.mkDefault [22];
            settings = {
                
                #password authentication required
                PasswordAuthentication = lib.mkDefault true;
                AllowUsers = lib.mkDefault null;

                #Additional settings
                UseDns = lib.mkDefault true;
                X11Forwarding = lib.mkDefault false;
                PermitRootLogin = lib.mkDefault "no";
            };
        };
    };
}
