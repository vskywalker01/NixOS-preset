{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
  imports = [
    ./megasync/megasync.nix
    ./cads.nix
    ./gaming.nix
    ./misc.nix
    ./programming.nix
    ./video-editing.nix
  ];
}

