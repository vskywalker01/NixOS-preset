{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.virtualbox;
in {
  options.virtualbox = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "incluse virtualbox virtualization tools in configuration";
    };
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = lib.mkForce true;
    users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
  };
}

