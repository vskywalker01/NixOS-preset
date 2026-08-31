{config, lib, pkgs,inputs, ...}:
let 
    inhibitScript = pkgs.writeShellScript "minecraft-inhibit" ''
        set -eu

        while true; do
            players="$(
                ${pkgs.mcrcon}/bin/mcrcon \
                -H 127.0.0.1 \
                -P ${toString config.services.minecraft-servers.servers.default.serverProperties."rcon.port"} \
                -p ${toString config.services.minecraft-servers.servers.default.serverProperties."rcon.password"} \
                "list" 2>/dev/null || true
            )"

            if echo "$players" | grep -Eq "There are [1-9][0-9]*"; then
                if ! ${pkgs.procps}/bin/pgrep -f "systemd-inhibit.*Minecraft" >/dev/null; then
                    ${pkgs.systemd}/bin/systemd-inhibit \
                    --what=sleep \
                    --who="Minecraft" \
                    --why="Minecraft players online" \
                    ${pkgs.coreutils}/bin/sleep infinity &
                fi
            else
                ${pkgs.procps}/bin/pkill -f "systemd-inhibit.*Minecraft" || true
            fi

            sleep 240
        done
    '';

    backuperYml = pkgs.writeText "backuper.yml" ''
        # DO NOT CHANGE
        configVersion: 14.0
        lastBackup: 0
        lastChange: 0

        backup:
          autoBackup: true
          autoBackupPeriod: 1440
          autoBackupCron: '${config.services.minecraft-server.backend.backups.schedule}'
          backupFileNameFormat: dd-MM-yyyy HH-mm-ss
          addDirectoryToBackup: []
          excludeDirectoryFromBackup: []
          deleteBrokenBackups: true
          skipDuplicateBackup: true
          afterBackup: NOTHING
          setWorldsReadOnly: false

        server:
          alertTimeBeforeRestart: 60
          alertOnlyServerRestart: true
          alertBackupMessage: Backup in %d second(s)
          alertBackupRestartMessage: Server restart in %d second(s)
  
          sizeCacheFile: ./plugins/Backuper/sizeCache.json
          threadNumber: 0
          checkUpdates: false
          betterLogging: true

        storages:
          sftp:
            type: sftp
            enabled: ${if config.services.minecraft-server.backend.backups.enable == true then "true" else "false"}
            autoBackup: true
            backupsFolder: ${config.services.minecraft-server.backend.backups.path}
            pathSeparatorSymbol: /
            maxBackupsNumber: 5
            maxBackupsWeight: 0
            zipArchive: true
            zipCompressionLevel: 5
    
            auth:
              address: '${config.services.minecraft-server.backend.backups.address}'
              port: 22
              authType: key
              username: '${config.services.minecraft-server.backend.backups.user}'
              keyFilePath: '${config.services.minecraft-server.backend.backups.key}'
              useKnownHostsFile: false
    
            debug:
              protocolLogging: true
    '';
in {
    options.services.minecraft-server.backend = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable minecraft server backend";
        };
        port = lib.mkOption {
            type = lib.types.int; 
            default = 25565;
            description = "port of the server";
        };
        rconPass = lib.mkOption {
            type = lib.types.str; 
            default = "supersecret-password"; 
            description = "wake on lan when required";
        };
        rconPort = lib.mkOption {
            type = lib.types.int; 
            default = 25575; 
            description = "wake on lan when required";
        };
    
        backups = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = false; 
                description = "SFTP world backup";
            };
            address = lib.mkOption {
                type = lib.types.str; 
                default = "127.0.0.1"; 
                description = "SSH server address to be used for backups";
            };
            user = lib.mkOption {
                type = lib.types.str; 
                default = "minecraft"; 
                description = "user to use for SSH connection";
            };
            key = lib.mkOption {
                type = lib.types.str; 
                default = "./";
                description = "path of the ssh provate key to use for autentications";
            };
            path = lib.mkOption {
                type = lib.types.str; 
                default = "./"; 
                description = "absolute path to use for backups in the remote server";
            };
            schedule = lib.mkOption {
                type = lib.types.str; 
                default = "0 0 3 ? * MON,TUE,WED,THU,FRI,SAT,SUN *";
                description = "cron schedule for automatic backups";
            };

        };
    };


    imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ./velocity.nix
    ];
    config = lib.mkIf(config.services.minecraft-server.backend.enable) {
        services.minecraft-servers = {
            enable = true;
            eula = true; 
            servers.default = {
                enable = true;
                serverProperties = {
                    autoStart = true;
                    server-ip = "0.0.0.0";
                    port = config.services.minecraft-server.backend.port;
                    difficulty = 2;
                    gamemode = 0;
                    max-players = 30;
                    motd = "Sfinfirinx poskys!";
                    white-list = false;
                    allow-cheats = true;
                    online-mode = false;
                    enable-rcon = true;
                    "rcon.password" = config.services.minecraft-server.backend.rconPass;
                    "rcon.port" = config.services.minecraft-server.backend.rconPort;

                };
                package = pkgs.paperServers.paper-26_2;

                jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
                symlinks = {
                    "plugins/SkinsRestorer.jar" = pkgs.fetchurl { 
                        url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/wXS6bHiC/SkinsRestorer.jar?mr_download_reason=standalone"; 
                        sha256 = "sha256-vxP/7pu0iBQbfsmWA+vIq6xomTPXLbFeZk/rC03u/GA="; 
                    };
                    "plugins/Backuper.jar" = pkgs.fetchurl {
                        url = "https://github.com/DVDishka/Backuper/releases/download/4.1.0/Backuper-4.1.0.jar";
                        sha256 = "fb6e57162022bf49c7a11371373cb0c50ebbd406be10441b6dd407c3d4d61c68";
                    };
                };
                files = {
                    "plugins/Backuper/config.yml" = backuperYml;
                };
                path = [
                    pkgs.coreutils
                    pkgs.bash
                    pkgs.cron 
                    pkgs.openssh
                ];
            };
        };
        systemd.services.minecraft-inhibit = {
              description = "Minecraft sleep inhibitor";
              wantedBy = [ "minecraft-server-default.service" ];
              after = [
                    "minecraft-server-default.service"
              ];
              serviceConfig = {
                    User = "root";
                    ExecStart = inhibitScript;
                    Restart = "always";
              };
        };

        environment.systemPackages = [
            pkgs.mcrcon 
        ];
    };     
}
