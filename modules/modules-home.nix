{config, lib, pkgs, ...}:
{
  imports = [
    gnome/gnome-home-configuration.nix
    gnome/gnome-home-nvidiaExtensions.nix
  ];
}