{config, lib, pkgs, ...}:

{
    imports = [
        ./apps/stabilitymatrix.nix
    ];
    config = {
        programs.appimage.enable = lib.mkDefault true;
        programs.appimage.binfmt = lib.mkDefault true;
        programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
            pkgs.icu
            pkgs.libxcrypt-legacy
            pkgs.python312
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
