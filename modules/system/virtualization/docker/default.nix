{config, lib, pkgs, ...}:

{
    imports = [
    ];
    config = lib.mkIf (config.virtualisation.docker.enable) {
            
        #adding permissions to docker 
        users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
        virtualisation.docker = {
            rootless = {
                enable = lib.mkDefault true;
                #setSocketVariable = lib.mkDefault true;
            };
            storageDriver = "btrfs";
        };
    };
}
