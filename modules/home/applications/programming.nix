{config, lib, pkgs,flake-inputs, systemConfig ? {}, ...}:

let 
  unstable = import flake-inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
  vimrc = builtins.fetchGit  {
    url = "https://github.com/danebulat/vim-config.git";
    rev = "491f6306f46b2eaacb90b5732f121c00e94ec3a2"; 
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
    programs.vim.enable = true;
    home.file.".vim/bundle/Vundle.vim".source = builtins.fetchGit {
      url = "https://github.com/VundleVim/Vundle.vim.git";
      rev = "5548a1a937d4e72606520c7484cd384e6c76b565"; 
    };
    home.activation.installVimCustomizations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "$(command -v vim)" ]; then
        vim +PluginInstall +qall || true
      fi
    '';
    home.file.".vimrc".source = "${vimrc}/light-ide/vimrc";
  };
}
