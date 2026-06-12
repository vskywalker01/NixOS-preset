{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.applications.gaming.enable) { 
        
        #adding support for ntsync for newer kernels 
        boot.kernelModules = [ "ntsync" ];

        #enabling steam 
        programs.steam = {
            remotePlay.openFirewall = lib.mkDefault true;
            dedicatedServer.openFirewall = lib.mkDefault true; 
            localNetworkGameTransfers.openFirewall = lib.mkDefault true; 
            gamescopeSession.enable = lib.mkDefault true;
            
            #adding proton-ge 
            extraCompatPackages = with pkgs; [
                proton-ge-bin
            ];   
        };

        #enabling gamemode for cpu optimization during gaming sessions
        programs.gamemode = {
            enable = lib.mkDefault true;
            enableRenice = lib.mkDefault true;
            settings = import ./gamemode.nix;
        };

        #adding support for xbox one and xbox 360 controllers
        hardware.xone.enable = true;
        hardware.xpad-noone.enable = true;
  };
}
