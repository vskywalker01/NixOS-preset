{ config, pkgs, lib, ... }: 
{
  config = lib.mkIf (config.hardware.hardware-profile == "QEMU") {
    #enabling SPICE and QEMU guest utils
    services.spice-vdagentd.enable= lib.mkDefault true;
    services.qemuGuest.enable = lib.mkDefault true;
    services.spice-webdavd.enable = lib.mkDefault true;
  };
}

