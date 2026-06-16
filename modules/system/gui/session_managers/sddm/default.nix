{config, lib, pkgs,inputs, ...}:
let
   sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        theme = "catppuccin-mocha"; 
    };
in {
  config = lib.mkIf (config.services.desktopManager.gnome.enable || config.programs.hyprland.enable) {
        #disabling gdm to avoid conflicts
        services.displayManager.gdm.enable = lib.mkForce false;
        services.xserver.displayManager.lightdm.enable = lib.mkForce false;

        services.displayManager.sddm = {
            enable = lib.mkDefault true;
            wayland.enable = true;
            package = pkgs.kdePackages.sddm;

            #adding custom theme (catpucchin mocha)
            theme = sddm-theme.pname;
            extraPackages = sddm-theme.propagatedBuildInputs;
            settings = {
                General = {
                    GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
                    InputMethod = "qtvirtualkeyboard";
                };
                LockScreen = {
                    background-color = "#191919";
                };
                Wayland = {
                    EnableHiDPI = true;
                };
            };
        };
        environment.systemPackages = with pkgs; [
            sddm-theme 
            sddm-theme.test
        ];
        qt.enable = lib.mkForce true;
    };
}
