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
            servers.default = {
                serverProperties = {
                    autoStart = true;
                    server-ip = "0.0.0.0";
                    difficulty = 2;
                    gamemode = 0;
                    max-players = 6;
                    motd = "Sfinfirinx poskys!";
                    white-list = false;
                    allow-cheats = true;
                    online-mode = false;
                    enable-rcon = true;
                };
                package = pkgs.vanillaServers.vanilla-26_2;
                jvmOpts = "-Xms2048M -Xmx2048M -Djava.net.preferIPv4Stack=true";
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
