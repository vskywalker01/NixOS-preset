{config, lib, pkgs, ...}:

{
  imports = [
    ./gnome-home-nvidiaExtensions.nix
  ];
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; 
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          caffeine.extensionUuid
          #freon.extensionUuid
          fullscreen-avoider.extensionUuid
          top-bar-organizer.extensionUuid
          appindicator.extensionUuid
    
        ];
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        blur-on-overwiev = false;
        brightness = 0.7;
        enable-all = true;
        opacity = 195;
        sigma = 65;
        blacklist = ["Plank" "com.desktop.ding" "Conky" "firefox" "War Thunder (Vulkan, 64bit)" "com.github.flxzt.rnote" "eeschema" "steam_app_1966720" "virt-manager"];
  
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
      
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell/extensions/user-theme".name = "WhiteSur-Dark";
      "org/gnome/desktop/interface" = {
        icon-theme = "WhiteSur-dark";
        gtk-theme = "WhiteSur-dark";
      };
    };
  };
}

