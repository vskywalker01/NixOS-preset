{ config, pkgs, flake-inputs, lib, ...}:
{
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./applications/applications.nix
    ./modules/modules-home.nix
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

