{ config, pkgs, lib, ... }: 
{
  imports = [
    ./hardware-profile.nix
    ./fa507nu.nix
    ./qemu.nix
    ./rpi3.nix
    ./r5.nix
    ./i3.nix
  ];
}
