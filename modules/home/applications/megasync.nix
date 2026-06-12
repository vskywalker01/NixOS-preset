{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

{  
    config = lib.mkIf(systemConfig.applications.tools.enable) {
        nixpkgs.config.allowUnfree = lib.mkForce true;
        home.packages = with pkgs; [
            megasync    
        ];

        home.file.".config/autostart/megasync.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        GenericName=File Synchronizer
        Name=MEGAsync
        Comment=Easy automated syncing between your computers and your MEGA cloud drive.
        TryExec=megasync
        Exec=sh -c "sleep 10 && megasync"
        Icon=mega
        Terminal=false
        Categories=Network;System;
        StartupNotify=false
        X-GNOME-Autostart-Delay=60
        '';
  };
}
