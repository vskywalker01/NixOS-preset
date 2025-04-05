{config, lib, pkgs, ...}:
{
  config = lib.mkIf (config.virtualisation.virtualbox.host.enable) {
    nixpkgs.config.allowUnfree = lib.mkForce true;
    users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
    virtualisation.virtualbox.host.enableExtensionPack = lib.mkDefault true;
  };
}

