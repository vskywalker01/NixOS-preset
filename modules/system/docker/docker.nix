{config, lib, pkgs, ...}:

{
  imports = [
    ./netbootxyz.nix
    ./octoprint.nix
    ./ollama.nix
  ];
  config = lib.mkIf (config.virtualisation.docker.enable) {
    users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
    virtualisation.docker = {

      rootless = {
        enable = lib.mkDefault true;
        #setSocketVariable = lib.mkDefault true;
      };
    };
  };
}
