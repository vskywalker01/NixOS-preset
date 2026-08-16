{config, lib, pkgs, ...}:
{
    options.services.octoprint.webcam = {
        enable = lib.mkOption {
            type = lib.types.bool; 
            default = false;
            description = "Enable octoprint webcam capabilities";
        };
        resolution = lib.mkOption {
            type = lib.types.str; 
            default = "640x480";
            description = "webcam resolution";
        };
        device = lib.mkOption {
            type = lib.types.str; 
            default = "/dev/video0"; 
            description = "webcam resolution";
        };
        framerate = lib.mkOption {
            type = lib.types.str; 
            default = "15";
            description = "webcam framerate";
        };
        port = lib.mkOption {
            type = lib.types.int; 
            default = "5001"; 
            description = "port of the webcam server";
        };
    };

    imports = [
        ./proxy.nix
    ];
    config = lib.mkIf (config.services.octoprint.enable) {
        services.octoprint = {
            plugins =  plugins: with plugins; [
                themeify 
            ];
        };
        environment.systemPackages = with pkgs; [
            mjpg-streamer
        ];
        users.users.mjpg-streamer = {
            isSystemUser = true;
            group = "video";
        };
        systemd.services.mjpg-streamer = lib.mkIf(config.services.octoprint.webcam.enable){
            description = "MJPEG Streamer";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            serviceConfig = {
                User = "mjpg-streamer";
                Group = "video";

                ExecStart = ''
                    ${pkgs.mjpg-streamer}/bin/mjpg_streamer \
                    -i "${pkgs.mjpg-streamer}/lib/mjpg-streamer/input_uvc.so -d ${config.services.octoprint.webcam.device} -r ${config.services.octoprint.webcam.resolution} -f ${config.services.octoprint.webcam.framerate}" \
                    -o "${pkgs.mjpg-streamer}/lib/mjpg-streamer/output_http.so -w ${pkgs.mjpg-streamer}/share/mjpg-streamer/www -p ${config.services.octoprint.webcam.port}"
                '';

                Restart = "always";
                RestartSec = 5;
            };
        };

    };
}
