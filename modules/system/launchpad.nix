{config, lib, pkgs, ...}:

{
  options.launchpad = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Includes Launchpad S audio tools";
    };
  };
  config = lib.mkIf (config.launchpad.enable && config.services.pipewire.enable) {
    environment.systemPackages = with pkgs; [
      ardour
      drumkv1
      samplv1
      synthv1
      sfizz
      jack2
      a2jmidid
      alsa-utils
    ];
  };
}