{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

{
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
      wl-clipboard
    ];

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          options={
            tabstop=4;
            shiftwidth=4;
          };
          viAlias=true;
          vimAlias=true;
          clipboard.enable=true;
          theme = {
            enable = true;
            name = "onedark";
            style = "warmer";
          };
          autocomplete.blink-cmp.enable=true;
          autopairs.nvim-autopairs.enable=true;
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
                extra_request_body = {
                  options = {
                    num_ctx = 20480;
                    keep_alive = "5m";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
