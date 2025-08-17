{config, lib, pkgs, ...}:

{
  imports = [
    ./texlive.nix
    ./embedded.nix
  ];
}