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
    vscode = lib.mkOption { 
      type = lib.types.bool;
      default = false;
      description = "Include VScode as programming IDE";
      };
    };
    imports=[flake-inputs.nvf.homeManagerModules.nvf];
    config = lib.mkIf (config.applications.programming) {
    programs.vscode = lib.mkIf (config.applications.vscode) {
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
          statusline.lualine.enable=true;
          terminal.toggleterm.enable=true;
          assistant.avante-nvim = lib.mkIf (systemConfig.ollama.enable) {
            enable = true;
            setupOpts= {
              provider = "ollama";
              providers.ollama = {
                endpoint = "http://127.0.0.1:11434";
                model= "codegemma:latest";
                timeout = 30000;
                #extra_request_body = {
                #  options = {
                #    num_ctx = 20480;
                #    keep_alive = "5m";
                #  };
                #};
              };
            };
          };
        };
      };
    };
  };
}
