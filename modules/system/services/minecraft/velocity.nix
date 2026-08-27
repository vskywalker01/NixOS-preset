{config, lib, pkgs,inputs, ...}:
let 
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

    wakecommand = lib.optionalString config.services.minecraft-server.proxy.enableWol "${pkgs.wakeonlan}/bin/wakeonlan ${config.services.minecraft-server.proxy.server-mac}";
    
    velocity-autostartstop = pkgs.stdenvNoCC.mkDerivation {
        pname = "velocity-autostartstop";
        version = "1.1.0-beta";

        src = pkgs.fetchurl {
            url = "https://github.com/beyenilmez/autostartstop/releases/download/v${velocity-autostartstop.version}/AutoStartStop-${velocity-autostartstop.version}.jar";
            hash = "sha256-gOgyxVMFFiyxwYpE7q9oJVYn8xs+W9SN8q3Mv1mCYYs=";
        };
        dontUnpack = true;
        installPhase = ''
            mkdir -p $out/share/velocity/plugins
            cp $src $out/share/velocity/plugins/AutoStartStop.jar
        '';
    };

    velocity-geyser = pkgs.stdenvNoCC.mkDerivation {
        pname = "velocity-geyser";
        version = "1233";

        src = pkgs.fetchurl {
            url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/velocity";
            hash = "sha256-iy5KYOibJU0nLcJN0FLTBS9q/CxFn5B/3Seg132rGKA=";
        };
        dontUnpack = true;
        installPhase = ''
            mkdir -p $out/share/velocity/plugins
            cp $src $out/share/velocity/plugins/Geyser.jar
        '';
    };


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
              timeout: 30s
              method: velocity
            startup_timer:
              expected_startup_time: 60s
              auto_calculate_expected_startup_time: true

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

          # Customize ping/MOTD responses based on server status
          respond_ping:
            enabled: true
            template: respond_ping
            servers: [default]  # List of server names to handle (maps to virtual_hosts from servers section)
            offline:
              use_cached_motd: false
              use_backend_motd: false
              motd: "Server inactive (join to wake up)"
              version_name: "<blue>◉ Sleeping"
              protocol_version: -1
              #icon: "/path/to/offline-icon.png"
            online:
              use_cached_motd: false
              use_backend_motd: true
              motd: "Server online"
              version_name: ""
              protocol_version: 772
              #icon: "/path/to/online-icon.png"

    '';

    velocityConfig= ''
        config-version = "2.8"
        bind = "0.0.0.0:25565"

        motd = "Sfinfirinx poskys!"
        show-max-players = 6
        online-mode = false
        force-key-authentication = true
        prevent-client-proxy-connections = false
        player-info-forwarding-mode = "NONE"
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
    };
    config = lib.mkIf(config.services.minecraft-server.proxy.enable){ 
        environment = { 
            systemPackages = [
                pkgs.wakeonlan
                unstable.velocity
                pkgs.mcrcon
                velocity-autostartstop
                velocity-geyser
            ];
            etc."velocity-debug".text =
  "${unstable.velocity}\n${unstable.velocity.version}\n";
        };
        systemd.tmpfiles.rules = [
            "d /var/lib/velocity 0750 root root -"
            "d /var/lib/velocity/plugins 0750 root root -"
            "d /var/lib/velocity/plugins/autostartstop 0750 root root -"

            "L+ /var/lib/velocity/plugins/AutoStartStop.jar - - - - ${velocity-autostartstop}/share/velocity/plugins/AutoStartStop.jar"
            "L+ /var/lib/velocity/plugins/Geyser.jar - - - - ${velocity-geyser}/share/velocity/plugins/Geyser.jar"
            "L+ /var/lib/velocity/velocity.toml - - - - ${velocityToml}"
            "L+ /var/lib/velocity/plugins/autostartstop/config.yml - - - - ${autoStartStopYml}"
        ];
        systemd.services.velocity = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            serviceConfig = {
                ExecStart = "${unstable.velocity}/bin/velocity ";
                WorkingDirectory = "/var/lib/velocity";
                Restart = "always";
            };
            
        }; 
        
    };     
}
