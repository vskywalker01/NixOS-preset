{
  description = "personal configuration for my NixOS systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware, cachix}: {
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        ./hardware/qemu.nix
        ./modules.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";
            #gnome-home-nvidiaExtensions.enable = true;
            #applications.excludeVideoEditing = true;
            #applications.excludeGaming = true;
            #applications.excludeCADs = true;
            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs.flake-inputs = inputs;
        }
      ];
    };
    nixosConfigurations.skywalker-tuf = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;

      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        nixos-hardware.nixosModules.asus-fa507nv
        ./hardware/fa507nu.nix
        ./configuration.nix
        ./modules.nix
        home-manager.nixosModules.home-manager
        {
          ollama.enable = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";
            gnome-home-nvidiaExtensions.enable = true;
            #applications.excludeVideoEditing = true;
            #applications.excludeGaming = true;
            #applications.excludeCADs = true;
            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs.flake-inputs = inputs;
        }
      ];
    };
  };
}
