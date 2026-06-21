{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:

{
    config = lib.mkIf(systemConfig.applications.developing.enable){
        home.packages = with pkgs; [
            gtkterm
        ];                    
    };
}


