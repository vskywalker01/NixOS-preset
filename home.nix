{ config, pkgs, flake-inputs, lib, ...}:

{
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./applications/applications.nix
    ./modules/modules-home.nix
  ];
  gnome-home-nvidiaExtensions.enable = true;
  #applications.excludeVideoEditing = true;
  #applications.excludeGaming = true;
  #applications.excludeCADs = true;
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

