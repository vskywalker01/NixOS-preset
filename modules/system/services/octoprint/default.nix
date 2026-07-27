{config, lib, pkgs, ...}:
let 
    server-port = 5000; 
in {
    imports = [
        ./proxy.nix
    ];
    config = lib.mkIf (config.services.octoprint.enable) {
        services.octoprint = {
            plugins =  plugins: with plugins; [
                themeify 
            ];
        };
    };
}
