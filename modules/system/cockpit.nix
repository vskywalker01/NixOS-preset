{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.cockpit.enable) {
    networking.firewall.allowedTCPPorts = [ 9090 ];
    environment.systemPackages = with pkgs; [
      cockpit
    ];
    services.cockpit = {
      port = 9090;
      settings = {
        WebService = {
          Address = "0.0.0.0";
          AllowUnencrypted = true;
        };
      };
    };
  };
}
