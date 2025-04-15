{ config, pkgs, lib, ... }: 
{
  imports = [
    ./hardware-profile.nix
    ./fa507nu.nix
    ./qemu.nix
  ];
}