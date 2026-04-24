{config, lib, pkgs, ...}:

{
  config = {
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
        pkgs.icu
        pkgs.libxcrypt-legacy
        pkgs.python312
        pkgs.python312Packages.torch
        pkgs.libepoxy
        pkgs.zstd
        pkgs.gcc
        ]; 
    };
    environment.systemPackages = with pkgs; [
        pkgs.appimage-run
    ];
  };
}
