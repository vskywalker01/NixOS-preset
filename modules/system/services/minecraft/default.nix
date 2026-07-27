{config, lib, pkgs,inputs, ...}:
let 
    server-port = 25564;
    rcon-port = 25563;
    rcon-pass = "supersecret-password";

    inhibitScript = pkgs.writeShellScript "minecraft-inhibit" ''
        set -eu

        while true; do
            players="$(
                ${pkgs.mcrcon}/bin/mcrcon \
                -H 127.0.0.1 \
                -P ${toString rcon-port} \
                -p ${rcon-pass} \
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
    imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ./lazymc.nix
    ];
    config = lib.mkIf(config.services.minecraft-servers.enable) {
        services.minecraft-servers = { 
            eula = true; 
            servers.vanilla = {
                serverProperties = {
                    autoStart = true;
                    server-ip = "0.0.0.0";
                    server-port = server-port;
                    difficulty = 2;
                    gamemode = 0;
                    max-players = 6;
                    motd = "Sfinfirinx poskys!";
                    white-list = false;
                    allow-cheats = true;
                    online-mode = false;
                    enable-rcon = true;
                    "rcon.port" = rcon-port;
                    "rcon.password" = rcon-pass;
                };
                package = pkgs.vanillaServers.vanilla-26_2;
                jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
            };
        };
        systemd.services.minecraft-inhibit = {
              description = "Minecraft sleep inhibitor";
              wantedBy = [ "minecraft-server-vanilla.service" ];
              after = [
                    "minecraft-server-vanilla.service"
              ];
              serviceConfig = {
                    User = "root";
                    ExecStart = inhibitScript;
                    Restart = "always";
              };
        };

        environment.systemPackages = [
            pkgs.mcron 
        ];

        networking.firewall.allowedTCPPorts = [
            server-port 
            rcon-port 
        ];

    };     
}
