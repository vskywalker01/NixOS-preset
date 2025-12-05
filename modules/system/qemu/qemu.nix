{config, lib, pkgs, inputs, ...}:
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
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
      virtio-win
      win-spice
      adwaita-icon-theme
      looking-glass-client
    ];

    virtualisation = {
      libvirtd = {
        qemu = {
          swtpm.enable = lib.mkDefault true;
        
          runAsRoot=true;
        };
        hooks.qemu = {
          qemu = ./hooks;
        };
      };
      
      spiceUSBRedirection.enable = lib.mkDefault true;
    };
    services.spice-vdagentd.enable = lib.mkDefault true;

  };
  
}
