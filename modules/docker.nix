{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.docker;
in {
  options.docker = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "include docker in configuration";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
    virtualisation.docker.rootless = {
      enable = lib.mkDefault true;
      setSocketVariable = lib.mkDefault true;
    };
  };
}
