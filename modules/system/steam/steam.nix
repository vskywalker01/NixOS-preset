{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.programs.steam.enable) {
    programs.steam = {
      remotePlay.openFirewall = lib.mkDefault true;
      dedicatedServer.openFirewall = lib.mkDefault true; 
      localNetworkGameTransfers.openFirewall = lib.mkDefault true; 
      gamescopeSession.enable = lib.mkDefault true;
    };
    programs.gamemode = {
      enable = lib.mkDefault true;
      enableRenice = lib.mkDefault true;
      settings = import ./gamemode.nix;
    };
    hardware.xone.enable = true;
    hardware.xpad-noone.enable = true;
  };
}
