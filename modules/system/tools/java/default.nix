{config, lib, pkgs, ...}:
{
    #enabling ava by default
    programs.java.enable = lib.mkDefault true;
}

