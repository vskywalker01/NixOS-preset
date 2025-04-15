{config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.virtualisation.libvirtd.enable) {
    programs.dconf.enable = lib.mkDefault true;
    #users.users.gcis.extraGroups = [ "libvirtd" ];
    users.extraGroups.libvirtd.members = [ "gcis" ];
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];
    virtualisation = {
      libvirtd = {
        qemu = {
          swtpm.enable = lib.mkDefault true;
          ovmf.enable = lib.mkDefault true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = lib.mkDefault true;
    };
    services.spice-vdagentd.enable = lib.mkDefault true;
  };
}
