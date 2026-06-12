{config, lib, pkgs, ...}:

{
    config = lib.mkIf (config.services.printing.enable) {
        
        #adding additional printer drivers to CUPS 
        environment.systemPackages = with pkgs; [
            gutenprint
            canon-cups-ufr2
        ];
        services.printing.drivers = [ 
            pkgs.gutenprint 
        ]; 
    };
}
