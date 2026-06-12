{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:

{
    config = {
        home.packages = with pkgs; [
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
                        name = "oxocarbon";
                        style = "dark";
                    };
                    autopairs.nvim-autopairs.enable=true;
                    languages.nix.enable=true;
                    telescope.enable=true;
                    filetree.neo-tree.enable=true;
                    autocomplete.nvim-cmp.enable=true;
                    statusline.lualine.enable=true;
                    terminal.toggleterm.enable=true;
                    git.neogit.enable = true;
                    visuals.nvim-cursorline.enable=true;
                };
        
            };
        };
    };
}

