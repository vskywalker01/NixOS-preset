{config, lib, pkgs, ...}:
{
  imports = [
    ./desktop/gnome 
    ./desktop/hyprland
    ./session_managers
  ];
}
