{config, pkgs, lib, systemConfig ? {},...}:
{
    config = lib.mkIf (systemConfig.services.asusd.enable) {
        home.file.".config/autostart/rog-control-center.desktop".text = 
        ''
        [Desktop Entry]
        Version=1.0
        Type=Application

        Name=ROG Control Center
        Comment=Make your ASUS ROG Laptop go Brrrrr!
        Categories=Settings

        Icon=rog-control-center
        Exec=rog-control-center
        Terminal=false

        '';
    };
}
