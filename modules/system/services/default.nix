{config, lib, pkgs, ...}:
{
    imports = [
        ./ollama
        ./printers
        ./samba
        ./sshd
        ./vpn
        ./firewall
        ./tailscale
        ./octoprint
        ./filebrowser
        ./haproxy
        ./minecraft
        ./caddy
        ./hdparm
    ];
}
