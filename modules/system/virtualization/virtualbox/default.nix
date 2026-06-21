{config, lib, pkgs, ...}:
{
    config = lib.mkIf (config.virtualisation.virtualbox.host.enable) {
        
        #adding persmissions to virtualbox 
        users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
        
        #enabling extension pack
        virtualisation.virtualbox.host.enableExtensionPack = lib.mkDefault true;
        
        #enabling dedicated kvm service to avoid conflicts with qemu
        virtualisation.virtualbox.host.enableKvm = true;

        #adding network interface
        virtualisation.virtualbox.host.addNetworkInterface = false;
    };
}

