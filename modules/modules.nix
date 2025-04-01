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
      ./docker.nix
      ./pipewire.nix
      ./gnome/gnome.nix
      ./qemu.nix
      ./steam/steam.nix
      ./ssh.nix
      ./virtualbox.nix
      ./flatpacks.nix
      ./ollama.nix
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
