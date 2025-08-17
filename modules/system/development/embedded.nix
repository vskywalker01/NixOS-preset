{config, lib, pkgs, ...}:

{
  options.development.embedded = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Includes development tools for embedded devices";
    };
  };
  config = lib.mkIf (config.development.embedded.enable) {
    environment.systemPackages = with pkgs; [
      platformio
      avrdude            
      esptool          
      python3
      python3Packages.pip
    ];
  };
}