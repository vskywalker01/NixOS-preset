{config, lib, pkgs, inputs,...}:
let 
    server-port = 8334; 
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
