{ config, pkgs, flake-inputs, lib, systemConfig ? {}, ...}:
{
    imports = [
        ./wallpapers
        ./colors
        ./hyprland
        ./gnome
    ];
    config = lib.mkIf (systemConfig.programs.hyprland.enable || systemConfig.services.desktopManager.gnome.enable) {
        home.file.".local/share/applications/vim-editor.desktop".text = ''
        [Desktop Entry]
        Name=Vim (Terminal)
        Exec=kitty -e vim %F
        Type=Application
        Terminal=false
        Categories=Utility;TextEditor;
        ''; 
    };
}

