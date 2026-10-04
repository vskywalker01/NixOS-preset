{config, lib, pkgs, ...}:
{
    imports = [
        ./llama
        ./printers
        ./samba
        ./sshd
        ./vpn
        ./firewall
        ./tailscale
        ./octoprint
        ./filebrowser
        ./minecraft
        ./caddy
        ./hdparm
    ];
}
