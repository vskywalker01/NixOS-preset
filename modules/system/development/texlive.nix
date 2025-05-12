{config, lib, pkgs, ...}:

{
  options.development.latex = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Includes texlive development tools";
    };
  };
  config = lib.mkIf (config.development.latex.enable) {
    environment.systemPackages = with pkgs; [
      texliveFull
    ];
  };
}