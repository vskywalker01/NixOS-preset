{config, lib, pkgs, ...}:
{
    imports = [
        ./ollama
        ./printers
        ./samba
        ./sshd
        ./vpn
    ];
}
