{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.ssh;
in {
  options.ssh = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ssh server in configuration";
    };
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = lib.mkDefault true;
      ports = lib.mkDefault [22];
      settings = {
        PasswordAuthentication = lib.mkDefault true;
        AllowUsers = lib.mkDefault null;
        UseDns = lib.mkDefault true;
        X11Forwarding = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
  };
}
