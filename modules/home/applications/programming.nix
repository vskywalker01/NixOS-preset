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
    imports=[flake-inputs.nvf.homeManagerModules.nvf];
    config = lib.mkIf (config.applications.programming) {
    programs.vscode = {
      enable = lib.mkDefault true;
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
    home.packages = with pkgs; [
      gtkterm
      arduino
    ];

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias=true;
          vimAlias=true;
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };

          languages.nix.enable=true;
          telescope.enable=true;
          filetree.neo-tree.enable=true;
          autocomplete.nvim-cmp.enable=true;
        };
      };
    };
    
  };
}
