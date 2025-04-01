{ config, pkgs, flake-inputs, lib, ...}:
{
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./applications.nix
    ./modules/gnome/gnome-home-configuration.nix
    ./modules/gnome/gnome-home-nvidiaExtensions.nix
  ];
  home.packages = with pkgs; [
      neofetch
    ];
  programs.git = {
    enable = true;
    userName = "vittorio01";
    userEmail = "vittoriopolci@live.com";
  };
  programs.fish = {
    enable = true;
    shellInit = "neofetch";
  };
}

