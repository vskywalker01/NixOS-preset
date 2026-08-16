{config, lib, pkgs, inputs,...}:
{
    imports = [
        ./proxy.nix
    ];
    config = {
        services.filebrowser = lib.mkIf (config.services.filebrowser.enable) {
            settings = {
                root = "/srv/hdd";
                address = "127.0.0.1";
            };
        };
    };
}
