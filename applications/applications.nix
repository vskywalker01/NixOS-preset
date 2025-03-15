{config, lib, pkgs, ...}:
with lib;
  let 
    cfg = config.applications;
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
      home.packages = with pkgs; 
        lib.optionals (!cfg.excludeCADs) [
          eagle
          kicad
          freecad
          #curaengine
        ]
        ++ 
        lib.optionals (!cfg.excludeGaming) [
          discord    
          r2modman
        ]
        ++
     
        lib.optionals (!cfg.excludeOptionals) [
          bottles
          remmina 
          calibre
          filezilla
          termius
          onlyoffice-desktopeditors
          rnote
        ]
        ++
        lib.optionals (!cfg.excludeVideoEditing) [
          obs-studio
          audacity
          lightworks
          handbrake
          vlc
        ];
      
      services.flatpak.packages = lib.optionals (!cfg.excludeVideoEditing) [
        "com.github.wwmm.easyeffects"
      ];

      programs.vscode = {
      enable = lib.mkDefault true;
      extensions = with pkgs.vscode-extensions; [
          #ms-python.python
          #ms-python.vscode-pylance
          #ms-python.debugpy
          #ms-vscode.cpptools
          #ms-vscode-remote.remote-ssh
          #ms-vscode-remote.remote-ssh-edit
          #firefox-devtools.vscode-firefox-debug
          #james-yu.latex-workshop
          #jnoortheen.nix-ide

        ];
      };
    };
  }

