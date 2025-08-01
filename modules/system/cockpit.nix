{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.services.cockpit.enable) {
    networking.firewall.allowedTCPPorts = [ 443 ];
    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addAdminRule(function(action, subject) {
        return ["unix-group:wheel"];
      });
    '';
    environment.systemPackages = with pkgs; [
      cockpit
    ];
    services.cockpit = {
      port = 443;
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };
  };
}
