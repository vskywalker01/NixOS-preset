{config, lib, pkgs, ...}:
{
    imports = [
        ./docker
        ./qemu
        ./appimage 
        ./flatpacks 
        ./virtualbox
    ];
}
