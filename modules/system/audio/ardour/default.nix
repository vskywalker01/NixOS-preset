{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.applications.video-editing.enable && config.services.pipewire.enable) {
        environment.systemPackages = with pkgs; [
            ardour_8
            drumkv1
            samplv1
            alsa-utils
        ]; 
        
    };
}
