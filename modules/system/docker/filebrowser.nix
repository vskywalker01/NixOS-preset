{config, pkgs, lib, inputs, ...}:
{
  options.filebrowser = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Enable filebrowser for data server";
    };
  };
  config = {
    virtualisation.oci-containers = lib.mkIf (config.filebrowser.enable) {
      backend = "docker";
      containers = {
        filebrowser = {
          image = "filebrowser/filebrowser";
          extraOptions = [ "--network=host" ];
          autoStart = true;
          volumes = [
            "/srv/hdd:/srv"
            "filebrowser_database:/database"
            "filebrowser_config:/config"
          ];
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}