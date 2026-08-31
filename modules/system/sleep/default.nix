{config, lib, pkgs, inputs, ...}:
let 
    lock = "/var/run/autoshutdown.lock";
in {
    options.sleep.autoshutdown = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable gaming application stock";
        };
        action = lib.mkOption {
            type = lib.types.str; 
            default = "hibernate";
            description = "Systemd action to achieve after long suspension periods";
        };
        seconds = lib.mkOption {
            type = lib.types.int; 
            default = 3600;
            description = "time before taking an action after suspension";
        };
    };
    config = lib.mkIf (config.sleep.autoshutdown.enable) {
        systemd.services."autoshutdown-recovery-timer" = {
            description = "Sets up the suspend so that it'll wake for the autoshutdown";
            wantedBy = [ "suspend.target" ];
            before = [ "systemd-suspend.service" ];
            script = ''
              curtime=$(date +%s)
              echo "$curtime $1" >> /tmp/autoshutdown.log
              echo "$curtime" > ${lock}
              ${pkgs.utillinux}/bin/rtcwake -m no -s ${toString config.sleep.autoshutdown.seconds}
            '';
            serviceConfig.Type = "simple";
        };
        systemd.services."shutdown-after-recovery" = {
            description = "Shutdown after a suspend recovery due to timeout";
            wantedBy = [ "suspend.target" ];
            after = [ "systemd-suspend.service" ];
            script = ''
              curtime=$(date +%s)
              sustime=$(cat ${lock})
              rm ${lock}
              if [ $(($curtime - $sustime)) -ge ${toString config.sleep.autoshutdown.seconds} ] ; then
                systemctl ${config.sleep.autoshutdown.action};
              else
                ${pkgs.utillinux}/bin/rtcwake -m no -s 1
              fi
            '';
            serviceConfig.Type = "simple";
        };
    }; 
}

