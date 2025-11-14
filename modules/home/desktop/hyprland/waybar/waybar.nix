{config, lib, pkgs, systemConfig ? {} ,flake-inputs, ...}:
let 
  unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
    config = lib.mkIf (systemConfig.programs.hyprland.enable) {
        programs.waybar = {
            enable=true;
            package=unstable.waybar;
        };
        xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
        xdg.configFile."waybar/style.css".source = ./style.css;
    };

}

