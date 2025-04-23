{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.printing.enable) {
    environment.systemPackages = with pkgs; [
      gutenprint
      canon-cups-ufr2
    ];
    services.printing.drivers = [ 
      pkgs.gutenprint 
    ]; 
  };
}