{config, lib, pkgs, ...}:
{
    imports = [
        ./vittorio.nix
    ];
    config = {
        nix.settings.trusted-users = [ "root" ];
    };
}
