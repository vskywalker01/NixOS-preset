{ config, pkgs, flake-inputs, lib, ...}:
{
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./applications/applications.nix
    ./gnome/gnome-home-configuration.nix
    ./gnome/gnome-home-configuration-nvidia.nix
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

