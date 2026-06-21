{config, pkgs, lib, ... }:

{
    config = lib.mkIf (config.virtualisation.libvirtd.enable) {
        programs.dconf.enable = lib.mkDefault true;
        users.extraGroups.libvirtd.members = [ "gcis" ];
        
        #useful packages
        environment.systemPackages = with pkgs; [
            virt-manager
            virt-viewer
            spice 
            spice-gtk
            spice-protocol
            virtio-win
            win-spice
            adwaita-icon-theme
            #looking-glass-client
        ];
        virtualisation = {
            libvirtd = {
                qemu = {
                    swtpm.enable = lib.mkDefault true;
                };
            };
            spiceUSBRedirection.enable = lib.mkDefault true;
        };

        #enabling spice agent
        services.spice-vdagentd.enable = lib.mkDefault true;
    };
}
