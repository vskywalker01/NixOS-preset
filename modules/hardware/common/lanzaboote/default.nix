{ config, pkgs, lib, inputs, ... }: 
{
    imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
    ];
    config = lib.mkIf (config.boot.lanzaboote.enable) {
        boot.loader.grub.enable = lib.mkForce false;
        boot.loader.systemd-boot.enable = lib.mkForce false;
        boot.loader.efi.canTouchEfiVariables = lib.mkForce true;
        boot.lanzaboote = {
            pkiBundle = "/etc/secureboot";
            autoGenerateKeys.enable = true;
            autoEnrollKeys =  {
                enable = true;
                autoReboot = true;
            };
        };
        
        environment.systemPackages = with pkgs; [
            sbctl
        ];
    };
}


