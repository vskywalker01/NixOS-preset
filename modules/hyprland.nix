{config, pkgs, lib, ...}:
{
  imports = [];
  programs.hyprland = {
    enable = lib.mkDefault true;
  };
}


