{config, lib, pkgs, ...}:
let 
    server-port = 8000; 
in {
    imports = [
        ./proxy.nix
    ];
    config = {
        services.filebrowser = lib.mkIf (config.services.filebrowser.enable) {
            settings = {
                root = "/srv/hdd";
                address = "127.0.0.1";
                port = server-port;
            };
        };
    };
}
