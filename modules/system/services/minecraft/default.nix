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

            sleep 60
        done
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
                package = pkgs.neoForgeServers.neoForge-26_2;
                jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
                symlinks = {
                    "mods/SkinsRestorer.jar" = pkgs.fetchurl { 
                        url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/IVzK51WC/SkinsRestorer-Mod-NeoForge-15.12.5.jar?mr_download_reason=standalone"; 
                        sha256 = "80e832c55305162cb1c18a44eeaf68255627f31b3e5bd48df2adccbf5982618b"; 
                    };
                };
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
