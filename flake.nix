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
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware, cachix,ngrok,nvf,silentSDDM}: {
    nixosConfigurations.skywalker-pi3 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "aarch64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        
        ./modules/hardware
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
            hardware.raspberry.RPI3.enable=true;
            services.openssh.enable=true;
            services.flatpak.enable=false;
            virtualisation.docker.enable=true;
          
            users.users.vittorio.extraGroups = [ "dialout" "docker" "wheel"];
            netbootxyz.enable = true;
            octoprint.enable=true;
            filebrowser.enable=true;
            services.samba.enable=true;
            services.xserver.desktopManager.gnome.enable=false;

            #home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vittorio = {
                imports = [./modules/home/home.nix];
                home.username = "vittorio";
                home.homeDirectory = "/home/vittorio";

                applications.CADs=false;
                applications.gaming=false;
                applications.misc=false;
                applications.videoEditing=false;
                applications.programming=false;
                applications.megasync=false;

                home.stateVersion = "24.11";
                programs.home-manager.enable = true;
            };
            home-manager.extraSpecialArgs = {
                flake-inputs = inputs;
                systemConfig = config;
                        
            };
            nixpkgs.config.allowUnfree = true;
            
        }
        )
      ];
    };
    
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
          hardware.virtual.qemu.enable=true;
          services.openssh.enable=true;
          services.flatpak.enable=true;
          #services.xserver.desktopManager.gnome.enable=true;
          programs.hyprland.enable=true;

          home-manager.useGlobalPkgs = true;
          #home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=false;
            applications.misc=true;
            applications.videoEditing=false;
            applications.programming=true;
            applications.megasync=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
                        
          };
        }
        )
      ];
    };
    nixosConfigurations.skywalker-tuf = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
            hardware.asus.FA507NU.enable=true;
          virtualisation.virtualbox.host.enable=true;
          services.openssh.enable=true;
          virtualisation.libvirtd.enable=true;
          services.ollama.enable = true;
          services.flatpak.enable=true;
          virtualisation.docker.enable=true;
          programs.steam.enable=true;
          users.users.vittorio.extraGroups = ["networkmanager" "dialout" "docker" "audio" "realtime"];
          launchpad.enable=true;
          #services.desktopManager.gnome.enable=true;
          programs.hyprland.enable=true;
          #home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=true;
            applications.misc=true;
            applications.videoEditing=true;
            applications.programming=true;
            applications.megasync=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
                        
          };
        }
        )
      ];
    };
    nixosConfigurations.skywalker-r5 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
            hardware.asus.A320M-K.enable=true;
          virtualisation.virtualbox.host.enable=true;
          services.openssh.enable=true;
          virtualisation.libvirtd.enable=true;
          services.flatpak.enable=true;
          virtualisation.docker.enable=true;
          programs.steam.enable=true;
          services.samba.enable=true;
          services.ollama.enable=true;
          launchpad.enable=true;
          #services.desktopManager.gnome.enable=true;
          programs.hyprland.enable=true;

	      users.users.vittorio.extraGroups = [ "dialout" "docker " "audio" "realtime" "network" "systemd-journal"];

          #home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=true;
            applications.misc=true;
            applications.videoEditing=true;
            applications.programming=true;
            applications.megasync=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
                        
          };
        })
      ];
    };
    nixosConfigurations.skywalker-i3 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
          hardware.toshiba.I3.enable=true;
          services.openssh.enable=true;
          services.flatpak.enable=true;
          virtualisation.docker.enable=true;
          users.users.vittorio.extraGroups = [ "dialout" "docker" "audio" "realtime"];
          #services.desktopManager.gnome.enable=true;
          programs.hyprland.enable=true;
          #home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=false;
            applications.misc=true;
            applications.videoEditing=false;
            applications.programming=true;
            applications.megasync=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
            };
        }
        )
      ];
    };
  };
}
