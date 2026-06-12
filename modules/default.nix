{config, lib, pkgs, ...}:
{
    options.applications.gaming.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable gaming application stock";
    };
    options.applications.cads.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable cads application stock";
    };
    options.applications.video-editing.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable video-editing application stock";
    };
    options.applications.tools.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable tools application stock";
    };
    options.applications.office.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable office application stock";
    };
    options.applications.developing.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable developing application stock";
    };


    imports = [
        ./hardware
        ./home
        ./system
    ];
}
