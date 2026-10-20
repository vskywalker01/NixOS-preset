{config, lib, pkgs, ...}:
let 
    inhibitScript = pkgs.writeShellScript "ssh-inhibit" ''
        set -eu

        while true; do
            if ${pkgs.iproute2}/bin/ss -Htn state established '( sport = :ssh )' | grep -q .; then
                if ! ${pkgs.procps}/bin/pgrep -f "systemd-inhibit.*SSH" >/dev/null; then
                    ${pkgs.systemd}/bin/systemd-inhibit \
                    --what=sleep \
                    --who="openSSH" \
                    --why="SSH connections active" \
                    ${pkgs.coreutils}/bin/sleep infinity &
                fi
            else
                ${pkgs.procps}/bin/pkill -f "systemd-inhibit.*SSH" || true
            fi

            sleep 240
        done
    '';

in{
    config = lib.mkIf (config.services.openssh.enable) {
        services.openssh = {   
            #assigning default port for ssh connections
            ports = lib.mkDefault [22];
            settings = {
                
                #password authentication required
                PasswordAuthentication = lib.mkDefault true;
                AllowUsers = lib.mkDefault null;

                #Additional settings
                UseDns = lib.mkDefault true;
                X11Forwarding = lib.mkDefault false;
                PermitRootLogin = lib.mkDefault "no";
            };
        };
        systemd.services.ssh-inhibit = {
              description = "ssh sleep inhibitor";
              wantedBy = [ "sshd.service" ];
              after = ["sshd.service"];
              serviceConfig = {
                    User = "root";
                    ExecStart = inhibitScript;
                    Restart = "always";
              };
        };

    };
}
