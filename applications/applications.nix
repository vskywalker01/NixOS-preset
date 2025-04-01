{config, lib, pkgs,flake-inputs, ...}:
with lib;
  let 
    cfg = config.applications;
    unstable = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  in {
    imports = [
      ./megasync/megasync.nix
    ];
    options.applications = {
      excludeVideoEditing = mkOption {
        type = types.bool; 
        default = false;
        description = "Option to exclude video editing tools from the application list";
      };
      excludeGaming = mkOption {
        type = types.bool; 
        default = false;
        description = "Option to exclude gaming applications from the application list";
      };
      excludeCADs = mkOption {
        type = types.bool; 
        default = false;
        description = "Option to exclude cad applications from the application list";
      };
      excludeOptionals = mkOption {
        type = types.bool; 
        default = false;
        description = "Option to exclude optional applications from the application list";
      };
    };
    config = {
      home.packages = []
        ++ 
        lib.optionals (!cfg.excludeCADs) [
          pkgs.eagle
          pkgs.kicad
          pkgs.freecad
          pkgs.blender
          #pkgs.curaengine
        ]
        ++ 
        lib.optionals (!cfg.excludeGaming) [
          pkgs.discord    
          pkgs.r2modman
          unstable.suyu
        ]
        ++
        lib.optionals (!cfg.excludeOptionals) [
          pkgs.bottles
          pkgs.remmina 
          pkgs.calibre
          pkgs.filezilla
          pkgs.termius
          pkgs.onlyoffice-desktopeditors
          pkgs.rnote
          pkgs.gimp 
        ]
        ++
        lib.optionals (!cfg.excludeVideoEditing) [
          pkgs.obs-studio
          pkgs.audacity
          pkgs.lightworks
          pkgs.handbrake
          pkgs.vlc
        ];
      
      services.flatpak.packages = lib.optionals (!cfg.excludeVideoEditing) [
        "com.github.wwmm.easyeffects"
      ];

      programs.vscode = {
      enable = lib.mkDefault true;
      extensions = with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.vscode-pylance
          ms-python.debugpy
          ms-vscode.cpptools
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          firefox-devtools.vscode-firefox-debug
          james-yu.latex-workshop
          jnoortheen.nix-ide
        ];
      };
    };
  }

