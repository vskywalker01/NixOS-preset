{ config, pkgs, ...}:

{
  home.username = "vittorio";
  home.homeDirectory = "/home/vittorio";
  home.packages = with pkgs; [
    neofetch
    
  ];
  programs.git = {
    enable = true;
    userName = "vittorio01";
    userEmail = "vittoriopolci@live.com";
  };
  programs.bash = {
    enable = true;
    bashrcExtra = "neofetch";
  };
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}

