{config, lib, pkgs, ...}:
{
    options.services.hdparm = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable minecraft server reverse proxy";
        };
        spindown = lib.mkOption {
            type = lib.types.int; 
            default = 360;
            description = "Default spindown time for mechanical hard disk";
        };
        apm = lib.mkOption {
            type = lib.types.int; 
            default = 127;
            description = "Defaulkt apm value for mechanical hard disk";
        };
    };

    config = lib.mkIf (config.services.hdparm.enable) {
        environment.systemPackages = with pkgs; [
            hdparm
            util-linux
        ];

        systemd.services.hdparm-hdd = {
            description = "Configure hdparm for all rotational disks";
            wantedBy = [ "multi-user.target" ];
            after = [ "local-fs-pre.target" ];

            serviceConfig = {
                Type = "oneshot";
            };

            script = ''
                while read -r disk rota; do
                if [ "$rota" = "1" ]; then
                    echo "Configuring /dev/$disk"
                    ${pkgs.hdparm}/bin/hdparm -S ${toString config.services.hdparm.spindown} -B ${toString config.services.hdparm.apm} "/dev/$disk" || true
                fi
                done < <(${pkgs.util-linux}/bin/lsblk -d -n -o NAME,ROTA)
            '';
        };
    }; 
}
