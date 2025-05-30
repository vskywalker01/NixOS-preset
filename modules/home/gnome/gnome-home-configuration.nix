{config, lib, pkgs, systemConfig ? {}, ...}:

{
  dconf = lib.mkIf (systemConfig.services.xserver.desktopManager.gnome.enable) {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; 
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          caffeine.extensionUuid
          fullscreen-avoider.extensionUuid
          #top-bar-organizer.extensionUuid
          appindicator.extensionUuid
          user-themes.extensionUuid 
          cronomix.extensionUuid
        ]
        ++
        lib.optionals (systemConfig.programs.gamemode.enable) 
        [
          gamemode-shell-extension.extensionUuid
        ];
      };

      "org/gnome/shell/extensions/gamemodeshellextension" = lib.mkIf (systemConfig.programs.gamemode.enable) {
        show-icon-only-when-active = true;
      };

      "org/gnome/mutter" = {
            experimental-features = ["variable-refresh-rate"];
      }; 

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        blur-on-overwiev = false;
        brightness = 0.7;
        enable-all = true;
        opacity = 195;
        sigma = 65;
        blacklist = ["Plank" "com.desktop.ding" "Conky" "firefox" "War Thunder (Vulkan, 64bit)" "com.github.flxzt.rnote" "eeschema" "steam_app_1966720" "virt-manager" "steam_app_548430"];
  
      };
      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        pipeline = "pipeline-default-rounded";
        sigma = 30;
      };
    

      "org/gnome/shell/extensions/top-bar-organizer" = {
        center-box-order = ["dateMenu"];
        left-box-order = ["activities" "freonMenu" "places-menu"];
      };
      
      "org/gnome/desktop/wm/preferences/interface".theme = "WhiteSur-Dark";
      "org/gnome/shell/extensions/user-theme".name = "WhiteSur-Dark";
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Nordzy-cyan-dark";
        gtk-theme = "WhiteSur-Dark";
        key-theme = "WhiteSur-Dark";
        show-battery-percentage = true;
      };
    };
  };
}

