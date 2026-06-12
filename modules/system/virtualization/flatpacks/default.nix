{config, lib, pkgs, inputs, ...}:

{
    imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
    config = {
        services.flatpak.enable = lib.mkDefault true;
    };
}
