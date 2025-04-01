{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.steam;
in {
  options.steam = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "include steam in configuration";
    };
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true; 
      localNetworkGameTransfers.openFirewall = true; 
      gamescopeSession.enable = true;
    };
    programs.gamemode = {
      enable =true;
      enableRenice = true;
      settings = import ./gamemode.nix;
    };
  };
}
