{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

let 
  unstable = import flake-inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in {
  options.applications = {
    programming = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Include programming IDEs in home configuration";
    };
  };
  
  config = lib.mkIf (config.applications.programming) {
    programs.vscode = {
      enable = lib.mkDefault true;
      #enableUpdateCheck = lib.mkDefault false;
      #enableExtensionUpdateCheck = lib.mkDefault false;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        firefox-devtools.vscode-firefox-debug
        jnoortheen.nix-ide
        james-yu.latex-workshop
      ] 
      ++ lib.optionals (systemConfig.ollama.enable) [
        continue.continue
      ]
      ++ lib.optionals (systemConfig.virtualisation.docker.enable) [
        ms-vscode-remote.remote-containers
      ];

    };
    home.packages = [
      pkgs.gtkterm
      pkgs.arduino
    ];
  };
}
