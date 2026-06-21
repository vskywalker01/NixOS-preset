{ config, pkgs, lib, ... }: 
{
    options.hardware.virtual.qemu.enable = lib.mkOption {
        type = lib.types.bool; 
        default = false;
        description = "Enable hardware profile for qemu virtual machines";
    };

    config = lib.mkIf (config.hardware.virtual.qemu.enable) {

        #enabling SPICE and QEMU guest utils
        services.spice-vdagentd.enable= lib.mkDefault true;
        services.qemuGuest.enable = lib.mkDefault true;
        services.spice-webdavd.enable = lib.mkDefault true;
    };
}

