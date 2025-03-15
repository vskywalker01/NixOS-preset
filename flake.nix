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
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware}: {
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;

      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        ./hardware/qemu.nix
        ./modules/modules.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = import ./home.nix;
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
        ./modules/modules.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = import ./home.nix;
          home-manager.extraSpecialArgs.flake-inputs = inputs;
        }
      ];
    };
  };
}
