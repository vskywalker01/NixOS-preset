{config, lib, pkgs,inputs, ...}:
let 
    wakecommand = lib.optionalString config.services.minecraft-server.proxy.enableWol "${pkgs.wakeonlan}/bin/wakeonlan ${config.services.minecraft-server.proxy.server-mac}";
    

    autoStartStopConfig = ''
        version: 1
        settings:
          shutdown_timeout: 30s
          empty_server_check_interval: 5m
          motd_cache_interval: 15m
          check_for_updates: false

        defaults:
          server:
            control_api:
              type: 'shell' 
            ping:
              timeout: 240s
              method: velocity
            startup_timer:
              expected_startup_time: 240s
              auto_calculate_expected_startup_time: false

        servers:
          default:
            virtual_host: minecraft.skywalker.home
            control_api:
              type: 'shell'
              start_command: '${wakecommand}' 

        rules:
          start_on_connection:
            enabled: true
            template: start_on_connection
            servers: [default]  # List of server names to monitor
            mode: hold  
    '';
    

    velocityConfig= ''
        config-version = "2.8"
        bind = "0.0.0.0:25565"

        motd = "Sfinfirinx poskys!"
        show-max-players = 30
        online-mode = false
        force-key-authentication = true
        prevent-client-proxy-connections = false
        player-info-forwarding-mode = "MODERN"
        forwarding-secret-file = "forwarding.secret"

        announce-forge = false
        kick-existing-players = true
        ping-passthrough = "ALL"
        sample-players-in-ping = false
        enable-player-address-logging = true

        [packet-limiter]
        interval = 7
        packets-per-second = -1
        bytes-per-second = -1
        decompressed-bytes-per-second = 5242880

        [servers]
        default = "${toString config.services.minecraft-server.proxy.server}:${toString config.services.minecraft-server.proxy.port}"
        
        try = [
            "default"
        ]

        [forced-hosts]
        "minecraft.skywalker.home" = [
            "default"
        ]

        [advanced]
        compression-threshold = 256
        compression-level = -1

        login-ratelimit = 3000
        connection-timeout = 5000
        read-timeout = 30000
        haproxy-protocol = false
        tcp-fast-open = false
        bungee-plugin-message-channel = false
        show-ping-requests = false
        
        failover-on-unexpected-server-disconnect = true
        announce-proxy-commands = true

        log-command-executions = false
        log-player-connections = true

        accepts-transfers = false
        enable-reuse-port = false
        command-rate-limit = 50
        forward-commands-if-rate-limited = true
        kick-after-rate-limited-commands = 0
        tab-complete-rate-limit = 10
        kick-after-rate-limited-tab-completes = 0

        [query]
        enabled = false
        port = 25565
        map = "Velocity"
        show-plugins = false
    '';

    velocityToml = pkgs.writeText "velocity.toml" velocityConfig;
    autoStartStopYml = pkgs.writeText "config.yml" autoStartStopConfig;
in {
    options.services.minecraft-server.proxy = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable minecraft server reverse proxy";
        };
        server = lib.mkOption {
            type = lib.types.str; 
            default = "127.0.0.1";
            description = "ip address of the server";
        };
        port = lib.mkOption {
            type = lib.types.int; 
            default = 25565;
            description = "port of the server";
        };
        enableWol = lib.mkOption {
            type = lib.types.bool; 
            default = false; 
            description = "wake on lan when required";
        };
        server-mac = lib.mkOption {
            type = lib.types.str; 
            default = "00:00:00:00:00:00";
            description = "mac address of the server (for wake on lan)";
        };
        autowake = {
            enable = lib.mkOption {
                type = lib.types.bool; 
                default = false;
                description = "Enable programmed wakeup of the backend server";
            };
            time = lib.mkOption {
                type = lib.types.str; 
                default = "";
                description = "programmed wakeup period in systemd timer format for backend server";
            };
        };
    };
    imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
    ];
    config = lib.mkIf(config.services.minecraft-server.proxy.enable){ 
        environment = { 
            systemPackages = [
                pkgs.wakeonlan
                pkgs.mcrcon

            ];
        };

        services.minecraft-servers = {
            enable = true;
            eula = true;
            servers.velocity = {
                enable = true;
                serverProperties.autoStart = true;
                package = pkgs.velocityServers.velocity.override {
                    jre_headless = pkgs.jdk25;
                };
                jvmOpts = "-Xms256M -Xmx256M -Djava.net.preferIPv4Stack=true";
                symlinks = {
                    "velocity.toml" = velocityToml;
                    "plugins/autostartstop/config.yml" = autoStartStopYml; 
                    "plugins/AutoStartStop.jar" = pkgs.fetchurl { 
                        url = "https://github.com/beyenilmez/autostartstop/releases/download/v1.1.0-beta/AutoStartStop-1.1.0-beta.jar"; 
                        sha256 = "80e832c55305162cb1c18a44eeaf68255627f31b3e5bd48df2adccbf5982618b"; 
                    };
                    "plugins/GeyserMC.jar" = pkgs.fetchurl { 
                        url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/vj2QhrSS/Geyser-Velocity.jar?mr_download_reason=standalone"; 
                        sha256 = "sha256-iy5KYOibJU0nLcJN0FLTBS9q/CxFn5B/3Seg132rGKA="; 
                    };
                    "plugins/SkinRestorer.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/wXS6bHiC/SkinsRestorer.jar?mr_download_reason=standalone";
                        sha256 = "sha256-vxP/7pu0iBQbfsmWA+vIq6xomTPXLbFeZk/rC03u/GA=";
                    };
                };
                path = [
                    pkgs.coreutils
                    pkgs.bash
                ];
            };
        };
        systemd.services.wake-on-lan = {
            description = "Send Wake-on-LAN packet";

            serviceConfig = {
                Type = "oneshot";
                ExecStart = wakecommand;
                path = [
                    pkgs.coreutils
                    pkgs.bash 
                    pkgs.wakeonlan
                ];
            };
        };

        systemd.timers.wake-on-lan = lib.mkIf (config.services.minecraft-server.proxy.autowake.enable) {
            description = "Scheduled Wake-on-LAN";

            wantedBy = [ "timers.target" ];

            timerConfig = {
                OnCalendar = "${config.services.minecraft-server.proxy.autowake.time}";
                Persistent = true;
            };
        };
    };     
}
