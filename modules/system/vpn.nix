{config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.networking.networkmanager.enable) {
    environment.systemPackages = with pkgs; [
      openconnect
      globalprotect-openconnect
    ];
    services.globalprotect.enable=true;
    services.globalprotect.csdWrapper="${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };
}