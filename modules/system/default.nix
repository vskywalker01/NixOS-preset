{config, lib, pkgs, ...}:
{
  imports = [
    ./audio
    ./virtualization 
    ./games
    ./gui
    ./services
    ./tools
];

  config = {
        nixpkgs.config.allowUnfree = lib.mkForce true;
        environment.systemPackages = with pkgs; [
            git
            nano
        ];
    };
}
