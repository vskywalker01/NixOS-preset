{config, lib, pkgs, ...}:
{
    #adding ntfs utilities
    environment.systemPackages = with pkgs; [
        ntfs3g
    ];  }
