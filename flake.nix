{
    description = "personal configuration for my NixOS systems";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak";

        ngrok.url = "github:ngrok/ngrok-nix";
        nvf = {
            url = "github:NotAShelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        silentSDDM = {
            url = "github:uiriansan/SilentSDDM";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    nixConfig = {
        extra-substituters = [
            "https://nix-community.cachix.org"
            "https://cache.nixos-cuda.org"
            "https://cache.nixos.org/" 
        ];
        extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="    
        ];
    };
    outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware,cachix,ngrok,nvf,silentSDDM}: {
        nixosConfigurations.skywalker-pi3 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "aarch64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.raspberry.RPI3.enable=true;
                    services.openssh.enable=true;
                    services.flatpak.enable=false;
                    virtualisation.docker.enable=true;
          
                    netbootxyz.enable = true;
                    octoprint.enable=true;
                    filebrowser.enable=true;
                    services.samba.enable=true;
            
                })
            ];
        };
        nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.virtual.qemu.enable=true;
                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applicaitons.developing.enable = true;
            
                })
            ];
        };
        nixosConfigurations.skywalker-tuf = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.asus.FA507NU.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=true;
                    virtualisation.libvirtd.enable=true;
    
                    applications.ai.enable = true;
                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = true; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = true; 
                    applications.developing.enable = true; 
                    
                })
            ];
        };
        nixosConfigurations.skywalker-r5 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.asus.A320M-K.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=true;
                    virtualisation.libvirtd.enable=true;
    
                    applications.ai.enable = true;

                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = true; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = true; 
                    applications.developing.enable = true; 
                    
                })
            ];
        };
        nixosConfigurations.skywalker-i3 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.toshiba.I3.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=false;
                    virtualisation.libvirtd.enable=false;
    
                    services.ollama.enable = false;

                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = false; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = false; 
                    applications.developing.enable = true; 
                    
                })
            ];
        };
    };
}
