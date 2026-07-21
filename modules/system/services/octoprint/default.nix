{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.services.octoprint.enable){
        services.octoprint.plugins = [
            
        ];
    };
}
