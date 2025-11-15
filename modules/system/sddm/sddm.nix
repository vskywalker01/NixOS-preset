{config, lib, pkgs,inputs, ...}:
let
   sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
      theme = "default"; 
    };
in {
  config = lib.mkIf (config.services.displayManager.sddm.enable) {
    services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        theme = sddm-theme.pname;
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
        General = {
          GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
          InputMethod = "qtvirtualkeyboard";
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
