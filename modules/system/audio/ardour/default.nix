{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.applications.video-editing.enable && config.services.pipewire.enable) {
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
