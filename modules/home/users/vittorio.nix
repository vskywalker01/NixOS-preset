{config, lib, pkgs, inputs, ...}:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];
    users.users.vittorio.extraGroups = [ "dialout" "docker" "audio" "realtime" "network" "systemd-journal" "networkmanager"];
    home-manager.useUserPackages = true;
    home-manager.users.vittorio = {
        imports = [
            ../applications 
            ../desktop
            inputs.nvf.homeManagerModules.nvf
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        config = {
            
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";
            programs.git.settings.user.name = "vskywalker01";
            programs.git.settings.user.email = "vittoriopolci@live.com";

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;

            
        };
    };
    home-manager.extraSpecialArgs = {
        flake-inputs = inputs;
        systemConfig = config;
    };
}
