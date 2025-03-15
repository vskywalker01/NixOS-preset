{config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.qemu;
in {
  options.qemu = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "include qemu virtualization tools in configuration";
    };
  };
  config = mkIf cfg.enable {
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
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
