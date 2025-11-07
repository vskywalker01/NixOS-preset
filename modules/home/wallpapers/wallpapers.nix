{config, lib, pkgs, systemConfig ? {} , ...}:

{
    home.file.".local/share/wallpapers".source=./images;
} 
