{config, pkgs, lib, inputs, ...}:
{
  options.netbootxyz = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Enable netbootxyz for pxe server";
    };
  };
  config = {
    virtualisation.oci-containers = lib.mkIf (config.netbootxyz.enable) {
      backend = "docker";
      containers = {
        netbootxyz = {
          image = "ghcr.io/netbootxyz/netbootxyz";
          extraOptions = [ "--network=host" ];
          environment = {
            MENU_VERSION = "2.0.84";
            NGINX_PORT = "80";
            WEB_APP_PORT = "3000";
          };
          autoStart = true;
          
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 3000 80 8080 ];
    networking.firewall.allowedUDPPorts = [ 69 ];
  };
}