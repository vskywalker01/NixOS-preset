{config, lib, pkgs, ...}:

{
  services.openssh = lib.mkIf (config.services.openssh.enable) {
    ports = lib.mkDefault [22];
    settings = {
      PasswordAuthentication = lib.mkDefault true;
      AllowUsers = lib.mkDefault null;
      UseDns = lib.mkDefault true;
      X11Forwarding = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };
}
