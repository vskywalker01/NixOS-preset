{config, lib, pkgs, ...}:
let 
    startScript = pkgs.writeShellScript "gamemode-start" ''
        export PATH="/run/current-system/sw/bin:$PATH"
        if command -v asusctl >/dev/null 2>&1; then
            asusctl profile set performance
            notify-send "AsusCtl Profile automatically changed to Performance"

        elif command -v powerprofilesctl >/dev/null 2>&1; then
            powerprofilesctl set performance
            notify-send "PPD Profile automatically changed to 'Performance'" 
        fi 
    '';
    endScript = pkgs.writeShellScript "gamemode-end" ''
        export PATH="/run/current-system/sw/bin:$PATH"
        if command -v asusctl >/dev/null 2>&1; then
            asusctl profile set balanced
            notify-send "AsusCtl Profile automatically changed to Balanced"

        elif command -v powerprofilesctl >/dev/null 2>&1; then
            powerprofilesctl set palanced
            notify-send "PPD Profile automatically changed to Balanced"
        fi 
         
    '';

in {
    config = lib.mkIf (config.applications.gaming.enable) { 
        
        #adding support for ntsync for newer kernels 
        boot.kernelModules = [ "ntsync" ];

        #enabling steam 
        programs.steam = {
            enable = true;
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
            settings = { 
                general = {
                    #desiredgov="performance";
                    #defaultgov="powersave";

                    reaper_freq=5;
                    igpu_desiredgov="performance";
                    igpu_power_threshold=0.3;
                    softrealtime="on"; 
                    ioprio=0;
                    inhibit_screensaver=1;
                    disable_splitlock=1;
                };
                cpu = {
                    pin_cores="yes";
                };
                custom = {
                    start = "${startScript}"; 
                    end = "${endScript}";
                };
            };
        };

        #adding support for xbox one and xbox 360 controllers
        hardware.xone.enable = true;
        hardware.xpad-noone.enable = true;
  };
}
