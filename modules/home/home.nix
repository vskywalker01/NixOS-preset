{ config, pkgs, flake-inputs, lib, ...}:
{
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./applications/applications.nix
    ./gnome/gnome-home-configuration.nix
    ./gnome/gnome-home-configuration-nvidia.nix
    ./gnome/gnome-home-configuration-ollama.nix
  ];
  home.packages = [
      pkgs.neofetch
      flake-inputs.nix-alien.packages.${pkgs.system}.nix-alien
    ];
  programs.git = {
    enable = true;
    userName = "vittorio01";
    userEmail = "vittoriopolci@live.com";
  };
  programs.fish = {
    enable = true;
    shellInit = ''
      if status is-interactive
        neofetch
      end
    '';
  };
  

}

