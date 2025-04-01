{config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules;
in {
  options.modules = {
    includeDE = lib.mkOption {
      type = types.bool; 
      default = true;
      description = "Option to include gnome DE in configuration";
    };
  };
  imports = [
      ./modules/docker.nix
      ./modules/pipewire.nix
      ./modules/gnome/gnome.nix
      ./modules/qemu.nix
      ./modules/steam/steam.nix
      ./modules/ssh.nix
      ./modules/virtualbox.nix
      ./modules/flatpacks.nix
      ./modules/ollama.nix
    ];
  config = {
    flatpacks.enable = lib.mkForce (cfg.includeDE);
    gnome.enable = lib.mkForce (cfg.includeDE);
    pipewire.enable = lib.mkForce (cfg.includeDE);
    steam.enable = lib.mkForce (cfg.includeDE);
    virtualbox.enable = lib.mkForce (cfg.includeDE);
    qemu.enable = lib.mkForce (cfg.includeDE);
  };
}
