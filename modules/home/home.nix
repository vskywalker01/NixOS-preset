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
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.corefonts 
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
  fonts.fontconfig.enable = true;
  
  home.activation.installfonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.dataHome}/fonts"
    cp -n ${pkgs.corefonts}/share/fonts/truetype/* "${config.xdg.dataHome}/fonts/"
    ${pkgs.fontconfig}/bin/fc-cache -f "${config.xdg.dataHome}/fonts"
  '';
}

