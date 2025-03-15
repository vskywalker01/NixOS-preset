{config, pkgs, lib, ...}:
{
  nixpkgs.config.allowUnfree = lib.mkForce true;
  home.packages = with pkgs; [
    megasync    
  ];

  home.file.".config/autostart/megasync.desktop".source =./megasync.desktop;
}
