{config, lib, pkgs, ...}:

{
    options.audio.ardour = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enables ardour and midi extensions";
        };
    };
    config = lib.mkIf (config.audio.ardour.enable && config.services.pipewire.enable) {
        environment.systemPackages = with pkgs; [
            ardour
            drumkv1
            samplv1
            synthv1
            jack2
            a2jmidid
            alsa-utils
        ];    
    };
}
