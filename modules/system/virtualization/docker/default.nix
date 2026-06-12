{config, lib, pkgs, ...}:

{
    imports = [
        ./containers/netbootxyz.nix
        ./containers/octoprint.nix
        ./containers/filebrowser.nix
    ];
    config = lib.mkIf (config.virtualisation.docker.enable) {
            
        #adding permissions to docker 
        users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
        virtualisation.docker = {
            rootless = {
                enable = lib.mkDefault true;
                #setSocketVariable = lib.mkDefault true;
            };
        };
    };
}
