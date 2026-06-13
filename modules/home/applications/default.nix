{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
{
  imports = [
    ./rclone.nix
    ./rog-control-center.nix
    ./arduino.nix
    ./blender.nix
    ./bottles.nix
    ./calibre.nix
    ./cura.nix
    ./discord.nix
    ./drawio.nix
    ./filezilla.nix
    ./freecad.nix
    ./gimp.nix
    ./greenlight.nix
    ./gtkterm.nix
    ./kicad.nix
    ./krita.nix
    ./neovim.nix
    ./onlyoffice.nix
    ./r2modman.nix
    ./rnote.nix
    ./termius.nix
    ./tlauncher.nix
    ./woeusb-ng.nix
    ./zoom.nix
    ./obs-studio.nix
    ./handbrake.nix
    ./audacity.nix
    ./shotcut.nix
  ];
    config = {

        #adding common used fonts and nerdfonts
        home.packages = [
            pkgs.nerd-fonts.jetbrains-mono
            pkgs.nerd-fonts.fira-code
            pkgs.corefonts 
        ];
        home.activation.installfonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p "${config.xdg.dataHome}/fonts"
            cp -n ${pkgs.corefonts}/share/fonts/truetype/* "${config.xdg.dataHome}/fonts/"
            ${pkgs.fontconfig}/bin/fc-cache -f "${config.xdg.dataHome}/fonts"
        '';
        fonts.fontconfig.enable = true;

        #some default programs
        programs.git.enable = true; 
        programs.fish = {
            enable = true;
        };
        nixpkgs.config.allowUnfree = true;  
        
    };
}

