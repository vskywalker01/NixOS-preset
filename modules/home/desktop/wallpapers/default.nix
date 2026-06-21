{config, lib, pkgs, systemConfig ? {} , ...}:

{
    #adds default wallpapers on a predefined directory
    home.file.".local/share/wallpapers".source=./img;
} 
