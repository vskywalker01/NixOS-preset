{ config, pkgs, lib, ... }: 

{
  services.spice-vdagentd.enable= lib.mkDefault true;
  services.qemuGuest.enable = lib.mkDefault true;
  services.spice-webdavd.enable = lib.mkDefault true;
}
